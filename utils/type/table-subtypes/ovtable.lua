--[[
MIT License

Copyright (c) 2022 Ryan Starrett

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
--]]

-- Lua 5.4 Virtual Ordered Field Implementation, backwards-compatibility untested.

--[[
    Feature Implementation:
        - This ordered field implementation calls itself virtual because it doesn't modify anything.
        - A basic internal table is created to track insertion order. Each orderedtable creates a subtable.
        - Each subtable is referred to by its memory address, as a unique identifier.
        - The subtables contain index -> key pairs which indirectly map the insertion order.
        - The mirror subtable contains key -> index pairs which indirectly map the insertion order.
        - The purpose of the mirror table is to fetch insertion order by key in O(1).

        - Setting a key to nil won't reorder the insertion table, but it will by skipped by __pairs.
        - If you want to correctly abolish an ordered field, use the `del` function. It's O(n); n = #table - 1.

        - Numeric indices aren't supported. They're already ordered.
        - Adding them to the table works fine, I just don't interact with them.

        - Manually adding fields doesn't order them. I also just ignore them, so you can mix your table up.
        - Careful with the ignore though, because pairs won't show your elements if you override_pairs. They're still there however.
--]]

--- @type orderedtable
local pkg = {}-- Main package.
local ins_order = {} -- Tracks insertion order; L1 table.
local key_ins_order = {} -- Mirror of `ins_order` to fetch the order of the key by its name; L2 table.

local use_assertioncalls = true
local predef_table_unqid = nil

--[[
    Metatable used to implement ordered tables. Stored in a local for identification purposes.
--]]
local orderedmetatable = {
    __pairs = function (t)
        local idx = 1
        local id = string.sub(tostring(t), 8)

        local L1 = ins_order[id]
        local L2 = key_ins_order[id]

        if not L1 or not L2 then
            return function () return nil end
        end

        return function ()
            local k = L1[idx]
            local v = t[k]

            while v == nil and idx <= #L1 do
                idx = idx + 1

                k = L1[idx]
                v = t[k]
            end

            idx = idx + 1

            return k, v
        end
    end,

   

    __gc = function (t)
        local id = string.sub(tostring(t), 8)

        if ins_order[id] then
            ins_order[id] = nil
        end

        if key_ins_order[id] then
            key_ins_order[id] = nil
        end
    end,

    __newindex = function(t, key, value)
      if use_assertioncalls == true then
          assert(type(key) == "string", "key must be a string.")
      end

      local id = predef_table_unqid or string.sub(tostring(t), 8)

      if value == nil then -- deletion handling
        local idx = key_ins_order[id][key]

        if not idx then -- key doesn't exist
            return
        end

        table.remove(ins_order[id], idx)
        key_ins_order[id][key] = nil
        rawset(t, key, nil)
      end


      local idx = #ins_order[id] + 1

      ins_order[id][idx] = key

      key_ins_order[id][key] = idx

      rawset(t, key, value)
    end,

    __index = pkg
}

pkg.orderedmetatable = orderedmetatable

function pkg.revpairs(t)
    local id = string.sub(tostring(t), 8)
    local idx = #ins_order[id]

    local L1 = ins_order[id]
    local L2 = key_ins_order[id]

    if not L1 or not L2 then
        return function () return nil end
    end

    return function ()
        local k = L1[idx]
        local v = t[k]

        while v == nil and idx > 0 do
            idx = idx - 1

            k = L1[idx]
            v = t[k]
        end

        idx = idx - 1

        return k, v
    end
end

function pkg.new()
  local tbl = setmetatable({}, orderedmetatable)
  local id = predef_table_unqid or string.sub(tostring(tbl), 8)
  ins_order[id] = {}
  key_ins_order[id] = {}
  return tbl
end

function pkg.init(all_elems)
  local t = pkg.new()
  for i, spec in ipairs(all_elems) do
    if #spec == 2 then
      t[spec[1]] = spec[2]
    else
        t[defaultIfNil(spec.k, spec.key)] = defaultIfNil(spec.v, spec.value)
    end
  end
  return t
end

-- Gets an ordered field's value by its insertion index.
-- Setting `give_key_name` to `true` returns (key_name, key_value) instead of key_value.
function pkg.getindex(t, idx, give_key_name)
    if use_assertioncalls == true then
        assert(type(idx) == "number", "idx must be a number.")
        assert(getmetatable(t).__gc == orderedmetatable.__gc, "t must be an orderedtable.")
    end

    local id = predef_table_unqid or string.sub(tostring(t), 8)
    local kstr = ins_order[id]

    if not kstr then
        return nil, "this table has no keys"
    else
        local k = kstr[idx]

        if give_key_name == true then
            return k, t[k]
        else
            return t[k]
        end
    end
end

-- Returns the insertion index of the key.
function pkg.keyindex(t, key)
    if use_assertioncalls == true then
        assert(type(key) == "string", "key must be a string.")
        assert(getmetatable(t).__gc == orderedmetatable.__gc, "t must be an orderedtable.")
    end

    local addr = predef_table_unqid or string.sub(tostring(t), 8)
    local kstr = key_ins_order[addr]

    if not kstr then
        return nil, "this table has no keys"
    else
        return kstr[key]
    end
end


--- @alias getindex_givekey fun(t: orderedtable, idx: number, give_key_name: true): string, any 
--- @alias getindex_nogivekey fun(t: orderedtable, idx: number, give_key_name: false | nil): any

--- @class orderedtable may also be used a table would, since it has a metatable implementing the relevant metamethods properly. Typically imported as `ovtable`.
--- @field new fun(): orderedtable
--- @field init fun(all_elems: ({ k: string, v: any } | { key: string, value: any })[]): orderedtable
--- @field getindex getindex_givekey | getindex_nogivekey
--- @field keyindex fun(t: orderedtable, key: string): number | nil, string | nil
--- @field revpairs fun(t: orderedtable): fun(): (string, any) | nil

ovtable = pkg