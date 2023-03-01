local rrq = bindArg(relative_require, "utils.dt")
rrq("time")
rrq("date")


local component_precision_map = {
  year = 1,
  month = 2,
  day = 3,
  hour = 4,
  min = 5,
  sec = 6
}

local precision_component_map = map(component_precision_map,returnAny, {"kv", "vk"})

local component_variant_form_map = {
  years = "year",
  year = "year",
  y = "year",
  months = "month",
  month = "month",
  days = "day",
  day = "day",
  d = "day",
  hours = "hour",
  hour = "hour",
  h = "hour",
  mins = "min",
  min = "min",
  minutes = "min",
  minute = "min",
  seconds = "sec",
  second = "sec",
  secs = "sec",
  sec = "sec",

}

local precision_percent_specifier_map = {
  year = "%Y",
  month = "%m",
  day = "%d",
  hour = "%H",
  min = "%M",
  sec = "%S"
}

local rfc_3339_format_separators = {
  year = "-",
  month = "-",
  day = "T",
  hour = ":",
  min = ":",
  sec = "Z"
}

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