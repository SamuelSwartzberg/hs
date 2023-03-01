
local do_queue = {}
local current_alert
local alert_hotkey
alert_hotkey =  hs.hotkey.bind({"cmd", "alt", "shift"}, "/", function()
  local first_in = table.remove(do_queue, 1)
  first_in.fn(tableUnpackIfTable(first_in.args))
  if #do_queue == 0 then 
    alert_hotkey:disable()
    hs.alert.closeSpecific(current_alert)
  else
    hs.alert.closeSpecific(current_alert)
    current_alert = alert("Waiting to proceed (" .. #do_queue .. " waiting in queue) ... (Press chord / to continue.)", "indefinite")
  end
end)

--- @param fn function
--- @param args? any
function doWhenReady(fn, args)
  if current_alert then 
    hs.alert.closeSpecific(current_alert)
  end
  
  push(do_queue, {
    fn = fn, 
    args = args
  })
  current_alert = alert("Waiting to proceed (" .. #do_queue .. " waiting in queue) ... (Press chord / to continue.)", "indefinite")
  ---@diagnostic disable-next-line: need-check-nil
  alert_hotkey:enable()
end