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


--- @alias stringConditionThatCantBeConfusedForListOfStringConditions boolean | string | {[any]: any} | {_r?: string, _start?: string, _stop?: string} | function
--- @alias stringCondition stringConditionThatCantBeConfusedForListOfStringConditions | string[]

--- @class stringTestOpts
--- @field tostring boolean


--- @param str? string
--- @param conditions? stringConditionThatCantBeConfusedForListOfStringConditions | stringCondition[]
--- @param opts? stringTestOpts
--- @return boolean
function stringTest(str, conditions, opts)
  str = str or ""
  conditions = conditions or true
  opts = opts or {}
  opts.tostring = defaultIfNil(opts.tostring, true)

  if opts.tostring then str = tostring(str) end

  if not isListOrEmptyTable(conditions) then
    conditions = {conditions}
  end

  if not type(str) == "string" then return false end
  local results

  for _, condition in wdefarg(ipairs)(conditions) do 
    if type(condition) == "boolean" then
      listPush(results, (str ~= "") == condition)
    elseif type(condition) == "table" then
      local found_other_use_for_table = false
      if condition.r then -- regex
        listPush(results, not not onig.find(str, condition._r))
        found_other_use_for_table = true
      end
      if condition._start then -- starts with
        listPush(results, stringy.startswith(str, condition._start))
        found_other_use_for_table = true
      end
      if condition._stop then -- ends with
        listPush(results, stringy.endswith(str, condition._stop))
        found_other_use_for_table = true
      end

      if not found_other_use_for_table then
        listPush(results, valuesContain(condition, str))
      end
    elseif type(condition) == "function" then
      listPush(results, condition(str))
    else
      listPush(results, str == condition)
    end
  end

  return allValuesPass(results, returnSame)
end


      