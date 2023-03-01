--- @alias relay_table { [string]: { [string]: string[] } }


--- @param raw string
--- @return relay_table
function parseRelayTable(raw)
  local raw_countries = stringx.split(raw, "\n\n") -- stringy does not support splitting by multiple characters
  raw_countries = filter(raw_countries, true)
  local countries = {}
  for _, raw_country in ipairs(raw_countries) do
    local raw_country_lines = stringy.split(raw_country, "\n")
    raw_country_lines = filter(raw_country_lines, true)
    local country_header = raw_country_lines[1]
    local country_code = extractFirstThingInParentheses(country_header)
    if country_code == nil then error("could not find country code in header. header was " .. country_header) end
    local payload_lines = slice(raw_country_lines, 2, -1)
    countries[country_code] = {}
    local city_code
    for _, payload_line in ipairs(payload_lines) do
      if stringy.startswith(payload_line, "\t\t") then -- line specifying a single relay
        local relay_code = payload_line:match("^\t\t([%w%-]+) ") -- lines look like this: \t\tfi-hel-001 (185.204.1.171) - OpenVPN, hosted by Creanova (Mullvad-owned)
        pop(countries[country_code][city_code], relay_code)
      elseif stringy.startswith(payload_line, "\t") then -- line specifying an entire city
        city_code = extractFirstThingInParentheses(payload_line) -- lines look like this: \tHelsinki (hel) @ 60.19206°N, 24.94583°W
        countries[country_code][city_code] = {}
      end
    end

  end
 
  return countries
end