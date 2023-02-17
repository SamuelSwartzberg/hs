

--- @param str string
--- @return nil
function copyAndView(str)
  hs.pasteboard.setContents(str)
  hs.alert.show(str, nil, nil, 4)
end

local do_queue = {}
local current_alert
local alert_hotkey
alert_hotkey =  hs.hotkey.bind({"cmd", "alt", "shift"}, "/", function()
  local first_in = listShift(do_queue)
  first_in.fn(tableUnpackIfTable(first_in.args))
  if #do_queue == 0 then 
    alert_hotkey:disable()
    hs.alert.closeSpecific(current_alert)
  else
    hs.alert.closeSpecific(current_alert)
    current_alert = alertCode("Waiting to proceed (" .. #do_queue .. " waiting in queue) ... (Press chord / to continue.)", "indefinite")
  end
end)

--- @param fn function
--- @param args? any
function doWhenReady(fn, args)
  if current_alert then 
    hs.alert.closeSpecific(current_alert)
  end
  
  listPush(do_queue, {
    fn = fn, 
    args = args
  })
  current_alert = alertCode("Waiting to proceed (" .. #do_queue .. " waiting in queue) ... (Press chord / to continue.)", "indefinite")
  ---@diagnostic disable-next-line: need-check-nil
  alert_hotkey:enable()
end


--- @param app string|hs.application
--- @param fn function
--- @param reactivate_last_app? boolean
--- @return any
function doWithActivated(app, fn, reactivate_last_app)
  local app_obj = app
  if type(app) == "string" then
    app_obj = hs.application.get(app)
  end
  local last_app = hs.application.frontmostApplication()
  app_obj:activate()
  local retval = {fn()}
  if last_app and reactivate_last_app then 
    last_app:activate()
  end
  return table.unpack(retval)
end