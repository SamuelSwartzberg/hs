--- @class condition
--- @field _r? string
--- @field _start? string
--- @field _stop? string
--- @field _contains? string
--- @field _empty? boolean
--- @field _type? "string" | "number" | "boolean" | "table" | "function" | "thread" | "userdata"
--- @field _exactly? string
--- @field _invert? boolean
--- @field _list? any[]


--- @alias conditionThatCantBeConfusedForListOfConditions boolean | string | table | condition | function
--- @alias anyCondition conditionThatCantBeConfusedForListOfConditions | any[]
--- @alias conditionSpec conditionThatCantBeConfusedForListOfConditions | anyCondition[]

--- @class testOpts
--- @field tostring boolean
--- @field ret kvmult | "boolean"

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
            k = 1,
            v = "",
            match = false
          }
        end
      end

      local found_other_use_for_table = false

      if condition._r or condition._start or condition._stop then
        if type(item) == "string" then
          if condition._r then -- regex
            local start, stop, match = onig.find(item, condition._r)
            push(results, getres(start, start, match))
          end
          if condition._start then -- starts with
            local match = stringy.startswith(item, condition._start)
            push(results, getres(match, 1, condition._start))
          end
          if condition._stop then -- ends with
            local match = stringy.endswith(item, condition._stop)
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
        push(results, getres(match, 1, item))
        found_other_use_for_table = true
      end
      if condition._exactly then -- exactly
        local match = item == condition._exactly
        push(results, getres(match, 1, item))
        found_other_use_for_table = true
      end
      if condition._contains then -- contains
        local start = stringy.find(item, condition._contains)
        push(results, getres(start, start, condition._contains))
        found_other_use_for_table = true
      end

      if condition._list or not found_other_use_for_table then
        local list = condition._list or condition
        for _, listitem in ipairs(list) do
          local match = item == listitem
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

  return reduce(results, returnAnd)
end


      