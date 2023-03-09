--- @class condition
--- @field _r? string
--- @field _start? string
--- @field _stop? string
--- @field _contains? string
--- @field _empty? boolean
--- @field _type? "string" | "number" | "boolean" | "table" | "function" | "thread" | "userdata"
--- @field _exactly? string
--- @field _list? any[]
--- @field _invert? boolean
--- @field _ignore_case? boolean
--- @field _only_if_all? boolean
--- @field _regex_engine? "onig" | "eutf8"


--- @alias conditionThatCantBeConfusedForListOfConditions boolean | string | table | condition | function
--- @alias anyCondition conditionThatCantBeConfusedForListOfConditions | any[]
--- @alias conditionSpec conditionThatCantBeConfusedForListOfConditions | anyCondition[]

--- @class testOpts
--- @field tostring boolean
--- @field ret kvmult | "boolean"

--- @alias matchspec {k: integer, v: indexable, match: boolean}

--- @param item? string
--- @param conditions? conditionSpec
--- @param opts? testOpts
--- @return boolean
function findsingle(item, conditions, opts)
  item = item or ""
  conditions = conditions or true
  opts = opts or {}
  opts.tostring = defaultIfNil(opts.tostring, true)
  opts.ret = opts.ret or "boolean"

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
            v = "",
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


      