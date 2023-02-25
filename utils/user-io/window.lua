--- @param app string
--- @param window_index integer
--- @param field string
--- @param after? string
--- @return any
function getOrDoAppWindowField(app, window_index, field, after)
  local code = ("Application('%s').windows()[%d].%s()")
    :format(app, window_index, field) .. (after or "")
  return getViaOSA("js", code)
end

--- @param app string
--- @param window_index integer
--- @param tab_index integer
--- @param field string
--- @return any
function getOrDoAppTabField(app, window_index, tab_index, field)
  local code = ("Application('%s').windows()[%d].tabs()[%d].%s()")
    :format(app, window_index, tab_index, field)
  return getViaOSA("js", code)
end

--- @param app string
--- @param window_index integer
--- @param tab_index integer
--- @return nil
function setAppActiveTab(app, window_index, tab_index)
  local code = ("Application('%s').windows()[%d].activeTabIndex = %d")
    :format(app, window_index, tab_index + 1)
  print(code)
  getViaOSA("js", code)
end