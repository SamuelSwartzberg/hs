--[[
  - This ordered field implementation calls itself virtual because it doesn't modify anything.
  - A basic internal table is created to track insertion order. Each orderedtable creates a subtable.
  - Each subtable is referred to by its memory address, as a unique identifier.
  - The subtables contain index -> key pairs which indirectly map the insertion order.
  - The mirror subtable contains key -> index pairs which indirectly map the insertion order.
  - The purpose of the mirror table is to fetch insertion order by key in O(1).
--]]

--- @type orderedtable
local pkg = {} -- Main package
local ins_order = {} -- Tracks insertion order; L1 table
local key_ins_order = {} -- Mirror of `ins_order` to fetch the order of the key by its name; L2 table

--[[
  Metatable used to implement ordered tables. Stored in a local for identification purposes.
--]]
local orderedmetatable = {
  -- This metamethod is called when the ordered table is about to be garbage collected.
  __gc = function (t)
    -- The unique memory address of the subtable is extracted from the ordered table.
    local id = string.sub(tostring(t), 8)

    -- If either of the subtables exists, remove the subtable from the table of insertion orders.
    if ins_order[id] then
      ins_order[id] = nil
    end

    if key_ins_order[id] then
      key_ins_order[id] = nil
    end
  end,

  -- This metamethod is called when a new key-value pair is added to the ordered table.
  __newindex = function(t, key, value)
    -- Ensure that the key is a string.
    assert(type(key) == "string", "key must be a string.")

    -- The unique memory address of the subtable is extracted from the ordered table.
    local id = string.sub(tostring(t), 8)

    if value == nil then -- deletion handling
       -- If the value is `nil`, remove the key-value pair from the table.
       local idx = key_ins_order[id][key]

       -- If the key does not exist in the mirror table, return.
       if not idx then -- key doesn't exist
         return
       end
 
       -- Remove the key from the list of keys.
       table.remove(ins_order[id], idx)
 
       -- Remove the key from the mirror table.
       key_ins_order[id][key] = nil
 
       -- Remove the key-value pair from the ordered table.
       rawset(t, key, nil)
    else 
      -- Add the new key-value pair to the ordered table.
      local idx = #ins_order[id] + 1
      ins_order[id][idx] = key
      key_ins_order[id][key] = idx
      rawset(t, key, value)
    end

   end,
 
   -- This metamethod is called when a key is accessed but does not exist in the ordered table.
   __index = function(t, k)
    local v = pkg[k]
    if v then
      return v
    elseif type(k) == "number" then
      return pkg.getindex(t, k)
    else
      return nil
    end
  end
  
 }

pkg.orderedmetatable = orderedmetatable

function pkg.new()
  -- Create a new ordered table with an empty metatable.
  local tbl = setmetatable({}, orderedmetatable)
  -- Generate a unique memory address for the new subtable.
  local id = string.sub(tostring(tbl), 8)
  -- Create a new subtable to track the insertion order.
  ins_order[id] = {}
  key_ins_order[id] = {}
  return tbl
end

function pkg.init(all_elems)
  -- Create a new ordered table.
  local t = pkg.new()
  -- Add each key-value pair in the list

  for i, spec in ipairs(all_elems) do
    -- Check if the key-value pair is specified as `{key, value}` or `{k = key, v = value}` / `{key = key, value = value}`.
    if isList(spec) then
      if #spec == 2 then
        t[spec[1]] = spec[2]
      else
        error("invalid key-value pair, doesn't have len 2 " .. hs.inspect(spec))
      end
    else
      -- Use the `defaultIfNil` function to retrieve the key-value pair from the `spec` assoc arr.
      t[defaultIfNil(spec.k, spec.key)] = defaultIfNil(spec.v, spec.value)
      if spec.k == nil and spec.key == nil then
        error("invalid key-value pair, doesn't have key " .. hs.inspect(spec))
      elseif spec.v == nil and spec.value == nil then
        error("invalid key-value pair, doesn't have value " .. hs.inspect(spec))
      end
    end
  end
  -- Return the ordered table.
  return t
end

-- Gets an ordered field's value by its insertion index.
-- Setting `give_key_name` to `true` returns (key_name, key_value) instead of key_value.
function pkg.getindex(t, idx, give_key_name)
  -- Ensure that `idx` is a number.
  assert(type(idx) == "number", "idx must be a number.")

  -- Extract the unique memory address of the subtable from the ordered table.
  local id = string.sub(tostring(t), 8)
  -- Get the list of keys in the insertion order.
  local kstr = ins_order[id]

  -- If the list of keys does not exist, return an error message.
  if not kstr then
    return nil, "this table has no keys"
  else
    -- Get the key at the specified index.
    local k = kstr[idx]

    -- If `give_key_name` is `true`, return the key-value pair instead of the value.
    if give_key_name == true then
      return k, t[k]
    else
      return t[k]
    end
  end
end

-- Returns the insertion index of the key.
function pkg.keyindex(t, key)
  -- Ensure that `key` is a string.
  assert(type(key) == "string", "key must be a string.")

  -- Extract the unique memory address of the subtable from the ordered table.
  local id = string.sub(tostring(t), 8)
  -- Get the mirror table that maps keys to insertion order indices.
  local kstr = key_ins_order[id]

  -- If the mirror table does not exist, return an error message.
  if not kstr then
    return nil, "this table has no keys"
  else
    -- Get the insertion order index of the key.
    return kstr[key]
  end
end

function pkg.keyfromindex(t, idx)
  -- Ensure that `idx` is a int.
  assert(type(idx) == "number", "idx must be a number.")

  -- Extract the unique memory address of the subtable from the ordered table.
  local id = string.sub(tostring(t), 8)
  
  -- Get the list of keys in the insertion order.
  local kstr = ins_order[id]

  -- If the list of keys does not exist, return an error message.
  if not kstr then
    return nil, "this table has no keys"
  else
    -- Get the key at the specified index.
    return kstr[idx]
  end
end

function pkg.len(t)
  -- Extract the unique memory address of the subtable from the ordered table.
  local id = string.sub(tostring(t), 8)
  
  -- Get the list of keys in the insertion order.
  local kstr = ins_order[id]

  -- If the list of keys does not exist, return 0.
  if not kstr then
    print("this table has no keys")
    return 0
  else
    -- Return the number of keys in the list.
    return #kstr
  end
end


pkg.isovtable = true

--- @alias getindex_givekey fun(t: orderedtable, idx: number, give_key_name: true): string, any 
--- @alias getindex_nogivekey fun(t: orderedtable, idx: number, give_key_name: false | nil): any

--- @class orderedtable may also be used a table would, since it has a metatable implementing the relevant metamethods properly. Typically imported as `ovtable`.
--- @field new fun(): orderedtable
--- @field init fun(all_elems: ({ k: string, v: any } | { key: string, value: any })[]): orderedtable
--- @field getindex getindex_givekey | getindex_nogivekey
--- @field keyindex fun(t: orderedtable, key: string): number | nil, string | nil
--- @field keyfromindex fun(t: orderedtable, idx: integer): string | nil, string | nil
--- @field len fun(t: orderedtable): integer
--- @field isovtable true signal that this is an orderedtable

ovtable = pkg