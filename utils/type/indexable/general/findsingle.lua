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
--- @field tostring boolean
--- @field ret kvmult | "boolean"

--- @class matchspec 
--- @field k integer
--- @field v indexable
--- @field match boolean

--- @param item? string
--- @param conditions? conditionSpec
--- @param opts? testOpts
--- @return boolean
function findsingle(item, conditions, opts)
  item = item or ""
  conditions = conditions or true
---@diagnostic disable-next-line: cast-local-type
  opts = opts or "boolean" -- default to returning a boolean, this is different from the general default, which is why we have to do this before calling defaultOpts
  opts = defaultOpts(opts)
  

  if opts.tostring then item = tostring(item) end

  if not isListOrEmptyTable(conditions) then
    conditions = {conditions}
  end

  local results

  for _, condition in wdefarg(ipairs)(conditions) do 

    -- process shorthand conditions into full conditions

    if type(condition) == "boolean" then
      condition = {_empty = condition}
    elseif type(condition) == "string" or type(condition) == "number" then
      condition = {_exactly = condition}
    end
  
    -- process full conditions into results

    if type(condition) == "table" then

      local bool 
      if condition._invert then
        bool = returnNot
      else
        bool = returnBool
      end

      --- @return matchspec
      local getres = function(match, k, v)
        match = bool(match)
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

      local found_other_use_for_table = false

      -- nocase management

      local item_maybe_nocase = item
      if condition._ignore_case then
        item_maybe_nocase = eutf8.lower(item)
      end

      function lowerIfNecessary(str)
        if condition._ignore_case then
          return eutf8.lower(str)
        else
          return str
        end
      end

      if condition._r or condition._start or condition._stop then
        if type(item) == "string" then
          if condition._r then -- regex
            condition._regex_engine = condition._regex_engine or "onig"
            local start, stop, matched = _G[condition._regex_engine].find(item, condition._r, 1, condition._ignore_case and "i" or nil)
            local match = start ~= nil
            if condition._only_if_all then
              match = match and #matched == #item
            end
            push(results, getres(start, start, matched))
          end
          if condition._start then -- starts with
            local match = stringy.startswith(item_maybe_nocase, lowerIfNecessary(condition._start))
            if condition._only_if_all then
              match = match and #condition._start == #item
            end
            push(results, getres(match, 1, condition._start))
          end
          if condition._stop then -- ends with
            local match = stringy.endswith(item_maybe_nocase, lowerIfNecessary(condition._stop))
            if condition._only_if_all then
              match = match and #condition._stop == #item
            end
            push(results, getres(match, #item - #condition._stop + 1, condition._stop))
          end
          found_other_use_for_table = true
        end
      end
      if condition._empty then -- empty
        local succ, rs = pcall(function() return #item == 0 end) -- pcall because # errors on failure
        push(results, getres(succ and rs, 1, item))
        found_other_use_for_table = true
      end
      if condition._type then -- type
        local match = type(item) == condition._type
        -- _only_if_all guaranteed to be true here if match is, so no check needed
        push(results, getres(match, 1, item))
        found_other_use_for_table = true
      end
      if condition._exactly then -- exactly
        local match = item_maybe_nocase == lowerIfNecessary(condition._exactly)
        -- _only_if_all guaranteed to be true here if match is, so no check needed
        push(results, getres(match, 1, item))
        found_other_use_for_table = true
      end
      if condition._contains then -- contains
        local start = stringy.find(item_maybe_nocase, lowerIfNecessary(condition._contains))
        local match = start ~= nil
        if condition._only_if_all then
          match = match and #item_maybe_nocase == #condition._contains
        end
        push(results, getres(match, start, condition._contains))
        found_other_use_for_table = true
      end

      if condition._list or not found_other_use_for_table then
        local list = condition._list or condition
        for _, listitem in ipairs(list) do
          local match = item_maybe_nocase == lowerIfNecessary(listitem)
          if match then
            push(results, getres(match, 1, item))
            break
          end
        end
      end
    elseif type(condition) == "function" then
      local k, v = condition(item)
      push(results, getres(not not k, k, v))
    end
  end

  --- @param acc matchspec
  ---@param val matchspec
  local res = reduce(results, function(acc, val) 
    -- we need to make a decision how we want to treat cases where we had multiple conditions, and thus the k and v are different
    -- My current perspective is that since we require all conditions to be true, the k is the smallest k, and the v is the match from the first k to the largest k + #v 
    -- This is a somewhat arbitrary decision, but its results are fairly predictable and intuitive

    local accmatchindex = acc.k + #acc.v - 1
    local valmatchindex = val.k + #val.v - 1
    local largermatchindex = math.max(accmatchindex, valmatchindex)
    local newv = slice(item, acc.k, largermatchindex)
    return {
      k = math.min(acc.k, val.k),
      v = newv,
      match = acc.match and val.match
    }
  end)

  if opts.ret == "boolean" then
    return res.match
  else
    for _, retarg in ipairs(opts.ret) do
      push(results, res[retarg])
    end
    return table.unpack(results)
  end
  
end


      