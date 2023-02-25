--- @enum NumberWeekdayMap
number_weekday_map = {
  [1] = "Monday",
  [2] = "Tuesday",
  [3] = "Wednesday",
  [4] = "Thursday",
  [5] = "Friday",
  [6] = "Saturday",
  [7] = "Sunday"
}

weekday_number_map = switchKeysAndValues(number_weekday_map)

--- @param start dateObj
--- @param finish dateObj
--- @param step? number
--- @param unit? string
--- @return dateObj[]
function dateRange(start, finish, step, unit)
  if not step then step = 1 end
  if not unit then unit = "days" end
  start = start:copy()
  finish = finish:copy()
  local range = {}
  local current = start
  while current <= finish do
    table.insert(range, current)
    local current_copy = current:copy()
    current = current_copy["add" .. unit](current_copy, step)
  end
  return range
end

--- @param dt dateObj
--- @param precision string | integer
--- @return dateObj
function dateToRFC3339Precision(dt, precision)
  return date(dt:fmt(getRFC3339FormatStringForPrecision(precision)))
end

--- @param specifier { dt?: dateObj, unit?: string, amount?: number, precision?: string }
--- @param orig_date dateObj
--- @return dateObj
function processDateSpecification(specifier, orig_date)
  local dt
  local date_copy = orig_date:copy() -- copy to avoid modifying the original
  if not specifier then 
    return date_copy
  elseif specifier.dt then
    dt = specifier.dt
  elseif specifier.unit then
    specifier.amount = specifier.amount or 1
    dt = date_copy["add" .. specifier.unit](date_copy, specifier.amount)
  else
    dt = date_copy
  end
  if specifier.precision then
    dt = dateToRFC3339Precision(dt, specifier.precision)
  end
  return dt
end


--- @param cronspec string
--- @return number
function getCronNextTime(cronspec)
  return tonumber(run({
    "ncron",
    { value = cronspec, type = "quoted"}
  }), 10)
end