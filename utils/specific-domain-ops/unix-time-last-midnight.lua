--- Get the unix time of the last midnight.
--- @return number
function getUnixTimeLastMidnight()
  local now = os.time()
  local midnight = os.date("*t", now)
  midnight.hour = 0
  midnight.min = 0
  midnight.sec = 0
  midnight.isdst = false
  return os.time(midnight)
end