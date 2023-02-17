
---@param str string
---@param circumfix string
---@return string
function surroundBy(str, circumfix)
  return circumfix .. str .. circumfix
end

---Ensure things related to adfixes
---@param in_str string
---@param in_adfix string
---@param presence? boolean
---@param case_insensitive? boolean
---@param adfix_type? "pre"|"suf"|"in"|nil
---@param strip_after? boolean
---@param regex? boolean
---@return string
function ensureAdfix(in_str, in_adfix, presence, case_insensitive, adfix_type, strip_after, regex)
  if case_insensitive == nil then case_insensitive = false end
  if presence == nil then presence = true end
  if adfix_type == nil then adfix_type = "pre" end
  if strip_after == nil then strip_after = false end
  if regex == nil then regex = false end
  local str, adfix
  if case_insensitive then
    str = in_str:lower()
    adfix = in_adfix:lower()
  else
    str = in_str
    adfix = in_adfix
  end
  local flag = ternary(case_insensitive, "i", "")
  local check_ad = ternary(regex, in_adfix, escapeGeneralRegex(in_adfix)) -- which adfix to check for in regex
  local position_check_func
  if adfix_type == "pre" then
    if regex then 
      position_check_func = function(s, ad) 
        return onig.find(s, "^" .. check_ad, nil, flag) ~= nil
      end
    else
      position_check_func = stringy.startswith
    end
    append_func = function(s, ad) return ad .. s end
    if regex then 
      remove_func = function(s, ad) 
        return onig.gsub(s, "^" .. check_ad, "", nil, flag)
      end
    else
      remove_func = function(s, ad) return eutf8.sub(s, eutf8.len(ad) + 1) end
    end
  elseif adfix_type == "suf" then
    if regex then 
      position_check_func = function(s, ad) 
        return onig.find(s, check_ad .. "$", nil, flag) ~= nil
      end
    else
      position_check_func = stringy.endswith
    end
    append_func = function(s, ad) return s .. ad end
    if regex then 
      remove_func = function(s, ad) 
        return onig.gsub(s, check_ad .. "$", "", nil, flag)
      end
    else
      remove_func = function(s, ad) return eutf8.sub(s, 1, eutf8.len(s) - eutf8.len(ad)) end
    end
  elseif adfix_type == "in" then
    position_check_func = function(s, ad) 
      return onig.find(s, check_ad, nil, flag) ~= nil
    end
    append_func = function(s, ad)
      local pos = math.random(1, eutf8.len(s)) -- no way to know where exactly to insert, so just insert at a random position
      return eutf8.sub(s, 1, pos) .. ad .. eutf8.sub(s, pos + 1)
    end
    remove_func = function(s, ad)
      return onig.gsub(s, check_ad, "", nil, flag)
    end
  else
    error("Invalid adfix type: " .. tostring(adfix_type))
  end
  local res
  if position_check_func(str, adfix) then
    if presence then
      res =  in_str
    else
      res = remove_func(in_str, in_adfix)
    end
  else
    if presence then
      res = append_func(in_str, in_adfix)
    else
      res = str
    end
  end
  if strip_after then
    res = stringy.strip(res)
  end
  return res
end

---@param str string
---@param n? integer
---@param dir? "up"| "down"
---@return string
function changeCasePre(str, n, dir)
  n = n or 1
  dir = dir or "up"
  local casefunc
  if dir == "up" then
    casefunc = eutf8.upper
  elseif dir == "down" then
    casefunc = eutf8.lower
  else
    error("Invalid direction: " .. tostring(dir))
  end
  local res = casefunc(eutf8.sub(str, 1, n)) .. eutf8.sub(str, n + 1)
  return res
end


--- @alias TransformSpecifier {value: string, presence: boolean, case_insensitive: boolean, adfix: "pre"|"suf"|"in"|nil, strip_after: boolean, regex: boolean}

--- @param str string
--- @param transform_specifiers TransformSpecifier[]
--- @return string
function transformString(str, transform_specifiers)
  for _, transform_specifier in ipairs(transform_specifiers) do
    str = ensureAdfix(str, transform_specifier.value, transform_specifier.presence, transform_specifier.case_insensitive, transform_specifier.adfix, defaultIfNil(transform_specifier.strip_after, true), transform_specifier.regex)
  end
  return str
end