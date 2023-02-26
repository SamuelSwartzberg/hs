

--- wrapper for hs.timer.doAt that takes a timestamp instead of seconds after midnight
--- @param timestamp integer
--- @param do_this function
function doAtTimestamp(timestamp, do_this)
  local last_midnight = getUnixTimeLastMidnight()
  local seconds_to_wait = timestamp - last_midnight
  if seconds_to_wait < 0 then
    error("Timestamp is in the past by " .. -seconds_to_wait .. " seconds")
  elseif seconds_to_wait == 0 then
    do_this()
    return
  end
  local is_more_than_24_hours = seconds_to_wait > 86400

  if is_more_than_24_hours then
    error("Timestamp is more than 24 hours in the future, which lua itself cannot handle, and I have not yet implemented a workaround for this")
  end
  hs.timer.doAt(seconds_to_wait, do_this)
end