


local long_dt_seps = {" at "}
local sep = "[_%-%.:;%s/T]"
local sep_opt =  sep .. "?"
local y = "(%d%d%d%d)"
local y_s = "(%d%d)"
local m = "(%d%d)"
local d = "(%d%d)"
local h = "(%d%d)"
local min = "(%d%d)"
local s = "%d%d"

local date_regexes = {
  full_datetime = "^" .. y .. sep_opt .. m .. sep_opt .. d .. sep_opt .. h .. sep_opt .. min .. sep_opt .. s .. "Z?" .. "$",
  noseconds_datetime = "^" .. y .. sep_opt .. m .. sep_opt .. d .. sep_opt .. h .. sep_opt .. min .. "Z?" .. "$",
  nominutes_noseconds = "^" .. y .. sep_opt .. m .. sep_opt .. d .. sep_opt .. h .. "Z?" .. "$",
  full_date = "^" .. y .. sep_opt .. m .. sep_opt .. d .. "$",
  sep_month = "^" .. y .. sep .. m .. "$",
  short_date = "^" .. y_s .. sep_opt .. m .. sep_opt .. d .. "$",
  onlyear = "^" .. y .. "$"
}

--- @param date string
--- @return number | nil
function parseDate(date)
  if eutf8.match(date, "^%D") then
    parseDate(getSubstringAtStartOfFirstDigit(date))
  end
  -- date is already a timestamp

  if #date == 13 then
    return tonumber(eutf8.sub(date, 1, 10))
  elseif #date == 10 then
    return tonumber(date)
  end

  -- we have to parse the date

  for _, sep in ipairs(long_dt_seps) do
    eutf8.gsub(date, sep, " ")
  end

  local date_parts

  for _, date_regex in pairs(date_regexes) do
    date_parts = {eutf8.match(date, date_regex)}
    if #date_parts > 0 then
      break
    end
  end

  if #date_parts == 0 then
    return nil
  end

  local date_table = map({"year", "month", "day", "hour", "min", "sec"}, function(k,v) return v, date_parts[k] end, "kv")
  local res, timestamp = pcall(os.time, date_table)
  if res then
    return timestamp
  else
    return nil
  end
end