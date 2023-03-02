---@param str string
---@param regex_inner string
---@return boolean
function asciiStringContaisSomeNative(str, regex_inner)
  local regex = ("[%s]"):format(regex_inner)
  return not not string.find(str, regex)
end

---@param str string
---@param list_of_chars string[]
---@return boolean
function asciiStringContainsSome(str, list_of_chars)
  for _, char in ipairs(list_of_chars) do
    if stringy.find(str, char) then return true end
  end
  return false
end

---@param str string
---@param regex_inner string
---@return boolean
function asciiStringContainsNoneNative(str, regex_inner) 
  local regex = ("[%s]"):format(regex_inner)
  return not string.find(str, regex)
end

---significantly faster than using asciiStringContainsNoneNative for smaller amounts of chars (< 20 or so)
---@param str string
---@param list_of_chars string[]
---@return boolean
function asciiStringContainsNone(str, list_of_chars)
  for _, char in ipairs(list_of_chars) do
    if stringy.find(str, char) then return false end
  end
  return true
end
---faster than using asciiStringContainsNone on the complement for any case I benchmarked
---@param str string
---@param regex_inner string
---@return boolean
function asciiStringContainsOnly(str, regex_inner) 
  local regex = ("[^%s]"):format(regex_inner)
  return not string.find(str, regex)
end

---@param str string
---@param regex_inner string
---@return boolean
function utf8StringContainsOnly(str, regex_inner)
  local regex = ("[^%s]"):format(regex_inner)
  return not eutf8.find(str, regex)
end

--- @alias starts_ends_specifier {starts: string, ends: string}

--- @param str string
--- @param specifier starts_ends_specifier
--- @return boolean
function startsEndsWith(str, specifier)
  return stringy.startswith(str, specifier.starts) and stringy.endswith(str, specifier.ends)
end

--- returns true if the string starts with the given substring, or if the string does not contain the given substring at all
--- @param str string 
--- @param first string
--- @return boolean
function isFirstIfAny(str, first)
  if eutf8.find(str, "^" .. first) then
    return true
  else
    return not eutf8.find(str, first)
  end
end

--- returns true if the string ends with the given substring, or if the string does not contain the given substring at all
--- @param str string
--- @param last string
--- @return boolean
function isLastIfAny(str, last)
  if eutf8.find(str, last .. "$") then
    return true
  else
    return not eutf8.find(str, last)
  end
end

--- @class condition
--- @field _r? string
--- @field _start? string
--- @field _stop? string
--- @field _empty? boolean
--- @field _type? "string" | "number" | "boolean" | "table" | "function" | "thread" | "userdata
--- @field _exactly? string
--- @field _invert? boolean
--- @field _list? any[]


--- @alias conditionThatCantBeConfusedForListOfConditions boolean | string | table | condition | function
--- @alias anyCondition conditionThatCantBeConfusedForListOfConditions | any[]
--- @alias conditionSpec conditionThatCantBeConfusedForListOfConditions | anyCondition[]

--- @class testOpts
--- @field tostring boolean


--- @param item? string
--- @param conditions? conditionSpec
--- @param opts? testOpts
--- @return boolean
function test(item, conditions, opts)
  item = item or ""
  conditions = conditions or true
  opts = opts or {}
  opts.tostring = defaultIfNil(opts.tostring, true)

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

      local ps

      if condition._invert then
        ps = returnNot
      else
        ps = returnBool
      end

      local found_other_use_for_table = false

      if condition._r or condition._start or condition._stop then
        if type(item) == "string" then
          if condition._r then -- regex
            push(results, ps(onig.find(item, condition._r)))
          end
          if condition._start then -- starts with
            push(results, ps(stringy.startswith(item, condition._start)))
          end
          if condition._stop then -- ends with
            push(results, ps(stringy.endswith(item, condition._stop)))
          end
          found_other_use_for_table = true
        end
      end
      if condition._empty then -- empty
        local succ, rs = pcall(function() return #item == 0 end) -- pcall because # errors on failure
        push(results, ps(succ and rs))
        found_other_use_for_table = true
      end
      if condition._type then -- type
        push(results, ps(type(item) == condition._type))
        found_other_use_for_table = true
      end
      if condition._exactly then -- exactly
        push(results, ps(item == condition._exactly))
        found_other_use_for_table = true
      end

      if condition._list or not found_other_use_for_table then
        push(results, ps(find(condition, item))) -- TODO: potential infinite loop since find may be refactored to use test
      end
    elseif type(condition) == "function" then
      push(results, condition(item))
    end
  end

  return not find(results, returnSame)
end


      