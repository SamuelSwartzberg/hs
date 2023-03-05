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
    dt = dt:fmt(map.dt_component.rfc3339[map.normalize.dt_component[specifier.precision]])
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

--- @param timestamp_key_table orderedtable
--- @return { [string]: { [string]: { [string]: string[] } } }
function timestampKeyTableToYMDTable(timestamp_key_table)
  local year_month_day_time_table = {}
  for timestamp_str, fields in timestamp_key_table:revpairs() do 
    local timestamp = tonumber(timestamp_str)
    local year = os.date("%Y", timestamp)
    local year_month = os.date("%Y-%m", timestamp)
    local year_month_day = os.date("%Y-%m-%d", timestamp)
    local time = os.date("%H:%M:%S", timestamp)
    if not year_month_day_time_table[year] then year_month_day_time_table[year] = {} end
    if not year_month_day_time_table[year][year_month] then year_month_day_time_table[year][year_month] = {} end
    if not year_month_day_time_table[year][year_month][year_month_day] then year_month_day_time_table[year][year_month][year_month_day] = {} end
    local contents = concat({time}, fields)
    table.insert(year_month_day_time_table[year][year_month][year_month_day], contents)
  end
  return year_month_day_time_table
end


--- @param precision number|string
--- @return string
function getRFC3339FormatStringForPrecision(precision)
  local format_string = ""
  if type(precision) == "string" then
    precision = component_precision_map[precision]
  end
  if not precision then error("Invalid precision: " .. precision) end
  for i = 1, precision do
    local current_component = precision_component_map[i]
    format_string = format_string .. precision_percent_specifier_map[current_component]
    if i < precision then
      format_string = format_string .. rfc_3339_format_separators[current_component]
    end
  end
  return format_string
end
--- @param date_part_array number[]
--- @return string|osdate
function datePartArrayToRFC3339String(date_part_array)
  local precision = #date_part_array
  local format_string = getRFC3339FormatStringForPrecision(precision)
  return os.date(format_string, os.time({
    year = date_part_array[1],
    month = date_part_array[2],
    day = date_part_array[3],
    hour = date_part_array[4],
    min = date_part_array[5],
    sec = date_part_array[6]
  }))
end
