---Ensure things related to adfixes
---@param in_str string the string to check and potentially modify
---@param in_adfix string the adfix to check for and potentially add.
---@param presence? boolean whether the adfix should be present or not. Default true
---@param case_insensitive? boolean whether to ignore case when checking for the adfix. Default false
---@param adfix_type? "pre"|"suf"|"in"|nil where the adfix should be. Default "pre"
---@param strip_after? boolean whether to strip whitespace before returning. Default false
---@param regex? boolean whether the adfix is a regex. Default false
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
  local check_ad = ternary(regex, in_adfix, replace(in_adfix, to.regex.general_escaped)) -- which adfix to check for in regex
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

--- Ensure a suffix, fast version
--- @param in_str string
--- @param suffix string
--- @return string
function mustEnd(in_str, suffix)
  if stringy.endswith(in_str, suffix) then
    return in_str
  else
    return in_str .. suffix
  end
end

--- Ensure a prefix, fast version
--- @param in_str string
--- @param prefix string
--- @return string
function mustStart(in_str, prefix)
  if stringy.startswith(in_str, prefix) then
    return in_str
  else
    return prefix .. in_str
  end
end

--- Ensure not prefix
--- @param in_str string
--- @param prefix string
--- @return string
function mustNotStart(in_str, prefix)
  if stringy.startswith(in_str, prefix) then
    local pref_len = eutf8.len(prefix)
    return eutf8.sub(in_str, pref_len + 1)
  else
    return in_str
  end
end

--- Ensure not suffix
--- @param in_str string
--- @param suffix string
--- @return string
function mustNotEnd(in_str, suffix)
  if stringy.endswith(in_str, suffix) then
    local suff_len = eutf8.len(suffix)
    return eutf8.sub(in_str, 1, eutf8.len(in_str) - suff_len)
  else
    return in_str
  end
end