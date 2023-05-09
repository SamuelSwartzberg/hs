--- transforms a timestamp-key orderedtable into a table of the structure [yyyy] = { [yyyy-mm] = { [yyyy-mm-dd] = { [hh:mm:ss, ...] } } }
--- @param timestamp_key_table orderedtable
--- @return { [string]: { [string]: { [string]: string[] } } }
function timestampKeyTableToYMDTable(timestamp_key_table)
  local year_month_day_time_table = {}
  for timestamp_str, fields in prs(timestamp_key_table,-1,1,-1) do 
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