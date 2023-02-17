--- @param snippet string
--- @return any
function getViaJXA(snippet)
  print(snippet)
  local succ, parsed_res, raw_res = hs.osascript.javascript(snippet)
  if succ then
    return parsed_res
  else
    return nil
  end
end

--- @param snippet string
--- @return any
function getViaApplescript(snippet)
  local succ, parsed_res, raw_res = hs.osascript.applescript(snippet)
  if succ then
    return parsed_res
  else
    return nil
  end
end

--- @param app string
--- @param window_index integer
--- @param field string
--- @param after? string
--- @return any
function getOrDoAppWindowField(app, window_index, field, after)
  local code = ("Application('%s').windows()[%d].%s()")
    :format(app, window_index, field) .. (after or "")
  return getViaJXA(code)
end

--- @param app string
--- @param window_index integer
--- @param tab_index integer
--- @param field string
--- @return any
function getOrDoAppTabField(app, window_index, tab_index, field)
  local code = ("Application('%s').windows()[%d].tabs()[%d].%s()")
    :format(app, window_index, tab_index, field)
  return getViaJXA(code)
end

--- @param app string
--- @param window_index integer
--- @param tab_index integer
--- @return nil
function setAppActiveTab(app, window_index, tab_index)
  local code = ("Application('%s').windows()[%d].activeTabIndex = %d")
    :format(app, window_index, tab_index + 1)
  print(code)
  getViaJXA(code)
end