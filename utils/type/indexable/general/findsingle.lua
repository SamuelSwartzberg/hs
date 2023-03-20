--- @class condition
--- @field _r? string a regex to match
--- @field _start? string a plain string that the item must start with
--- @field _stop? string a plain string that the item must end with
--- @field _contains? string a plain string that the item must contain
--- @field _empty? boolean whether the item must be empty (this rarely makes sense to combine with other conditions)
--- @field _type? "string" | "number" | "boolean" | "table" | "function" | "thread" | "userdata" the type of the item (most often only makes sense when used with find() on tables, since if you are using find() on a string, you already know the type, lol)
--- @field _exactly? any the item must be exactly this value
--- @field _list? any[] the item must be contained in this list
--- @field _invert? boolean whether to invert the result of the condition
--- @field _ignore_case? boolean whether to ignore case when matching (only for strings)
--- @field _only_if_all? boolean whether to only return true if the condition matches the entire string (only for strings)
--- @field _regex_engine? "onig" | "eutf8" the regex engine to use for _r


--- @alias conditionThatCantBeConfusedForListOfConditions boolean | string | table | condition | function a condition that can't be confused for a list of conditions (see below)
--- @alias anyCondition conditionThatCantBeConfusedForListOfConditions | any[] a condition (condition table or condition shorthand)
--- @alias conditionSpec conditionThatCantBeConfusedForListOfConditions | anyCondition[] a condition or a list of conditions, excluding the list shorthand, since we have no way of knowing if the user meant a list of conditions or the list shorthand (i.e. it is unclear if {"a", "b"} is the list shorthand (and therefore we should find an element in this list) or it is a list of string shorthands (and therefore we should find a match for both "a" and "b")) This is all to say, use {{ "a", "b" }} if all you want to do is find an element in the list {"a", "b"}.

--- @class testOpts
--- @field tostring boolean whether to convert the item to a string before testing it
--- @field ret kvmult | "boolean" what of the element does the callback (or equivalent thing) return in which order (or just return a boolean)

--- @class matchspec 
--- @field k integer the start of the match
--- @field v indexable the value of the match
--- @field match boolean whether it counts as a match

--- find a single item that matches the conditions
--- this is the logic guts of `find`, but can also be used on its own
--- @param item? any most conditions only work if type is string, or the tostring option is set
--- @param conditions? conditionSpec the conditions to test against
--- @param opts? testOpts the options to use
--- @return boolean
function findsingle(item, conditions, opts)
  item = item or ""
  conditions = defaultIfNil(conditions, true)
---@diagnostic disable-next-line: cast-local-type
  if not opts then opts = {ret = "boolean"} 
  elseif type(opts) == "table" and not opts.ret then opts.ret = "boolean" end -- default to returning a boolean, this is different from the general default, which is why we have to do this before calling defaultOpts
  opts = defaultOpts(opts)  

  if opts.tostring then item = tostring(item) end

  if not isListOrEmptyTable(conditions) then
    conditions = {conditions}
  end

  local results = {}

  --- @return matchspec
  local gen_getres = function(match, k, v)
    if match then 
      return {
        k = k,
        v = v,
        match = match
      }
    else 
      return {
        k = -1,
        v = false,
        match = false
      }
    end
  end

  for _, condition in wdefarg(ipairs)(conditions) do 

    -- process shorthand conditions into full conditions

    if type(condition) == "boolean" then
      condition = {_empty = condition}
    elseif type(condition) == "string" or type(condition) == "number" then
      condition = {_exactly = condition}
    end
  
    -- process full conditions into results

    -- condition is a table, so we need to do some complex processing
    if type(condition) == "table" then

      local bool 
      if condition._invert then
        bool = returnNot
      else
        bool = returnBool
      end

      -- easier to wrap here than to keep passing in the bool function
      -- can't be defined in gen_getres because it needs to be defined after bool is defined
      local getres = function(match, k, v)
        match = bool(match)
        return gen_getres(match, k, v)
      end

      local found_other_use_for_table = false

      -- nocase management

      -- make the item itself lowercase if necessary
      local item_maybe_nocase = item
      if condition._ignore_case then
        item_maybe_nocase = eutf8.lower(item)
      end

      -- helper function that implements _ignore_case for other things that may need to be compared to the item
      function lowerIfNecessary(str) 
        if condition._ignore_case then
          return eutf8.lower(str)
        else
          return str
        end
      end

      -- conditions that can only be used on strings
      if condition._r or condition._start or condition._stop then
        if type(item) == "string" then
          if condition._r ~= nil then -- regex
            condition._regex_engine = condition._regex_engine or "onig"
            local slice_lib = _G[condition._regex_engine] == "onig" and string or eutf8
            local start, stop = _G[condition._regex_engine].find(item, condition._r, 1, condition._ignore_case and "i" or nil)
            local matched = slice_lib.sub(item, start, stop)
            local match = start ~= nil
            if condition._only_if_all then
              match = match and #matched == #item
            end
            push(results, getres(match, start, matched))
          end
          if condition._start ~= nil then -- starts with
            local match = stringy.startswith(item_maybe_nocase, lowerIfNecessary(condition._start))
            if condition._only_if_all then
              match = match and #condition._start == #item
            end
            push(results, getres(match, 1, condition._start))
          end
          if condition._stop ~= nil then -- ends with
            local match = stringy.endswith(item_maybe_nocase, lowerIfNecessary(condition._stop))
            if condition._only_if_all then
              match = match and #condition._stop == #item
            end
            push(results, getres(match, #item - #condition._stop + 1, condition._stop))
          end
          found_other_use_for_table = true
        end
      end

      -- conditions that can be used on any type
      if condition._empty ~= nil then -- empty
        
        local succ, rs = pcall(function() return #item == 0 end) -- pcall because # errors on failure
        local isempty = succ and rs
        push(results, getres( isempty == condition._empty, 1, item))
        found_other_use_for_table = true
      end
      if condition._type ~= nil then -- type
        local match = type(item) == condition._type
        -- _only_if_all guaranteed to be true here if match is, so no check needed
        push(results, getres(match, 1, item))
        found_other_use_for_table = true
      end
      if condition._exactly ~= nil then -- exactly
        local match = item_maybe_nocase == lowerIfNecessary(condition._exactly)
        -- _only_if_all guaranteed to be true here if match is, so no check needed
        push(results, getres(match, 1, item))
        found_other_use_for_table = true
      end
      if condition._contains ~= nil then -- contains
        local start = toNumber(stringy.find(item_maybe_nocase, lowerIfNecessary(condition._contains)), "pos-int", "nil")
        local match = start ~= nil
        if condition._only_if_all then
          match = match and #item_maybe_nocase == #condition._contains
        end
        push(results, getres(match, start, condition._contains))
        found_other_use_for_table = true
      end

      if condition._list ~= nil or not found_other_use_for_table then
        local list = condition._list or condition
        local match = false
        for _, listitem in ipairs(list) do
          print(listitem)
          match = item_maybe_nocase == lowerIfNecessary(listitem)
          if match then
            push(results, getres(match, 1, item))
            break
          end
        end
        if not match then
          push(results, getres(match, -1, false))
        end
      end
    -- condition is a function, so we only need to call it, and get the result
    elseif type(condition) == "function" then
      local k, v = condition(item)
      push(results, gen_getres(not not k, k, v))
    end
  end


  --- @param acc matchspec
  --- @param val matchspec
  local res = reduce(results, function(acc, val) 
    -- we need to make a decision how we want to treat cases where we had multiple conditions, and thus the k and v are different
    -- My current perspective is that since we require all conditions to be true, the k is the smallest k, and the v is the match from the first k to the largest k + #v 
    -- This is a somewhat arbitrary decision, but its results are fairly predictable and intuitive

    if acc.match and val.match then 
      local accmatchindex = acc.k + #acc.v - 1
      local valmatchindex = val.k + #val.v - 1
      local largermatchindex = math.max(accmatchindex, valmatchindex)
      local newv = slice(item, acc.k, largermatchindex)
      return {
        k = math.min(acc.k, val.k),
        v = newv,
        match = true
      }
    else
      return {
        k = -1,
        v = false,
        match = false
      }
    end
  end)

  if opts.ret == "boolean" then
    return res.match
  else
    local finalresults = {}
    for _, retarg in ipairs(opts.ret) do
      push(finalresults, res[retarg])
    end
    return table.unpack(finalresults)
  end
  
end


      