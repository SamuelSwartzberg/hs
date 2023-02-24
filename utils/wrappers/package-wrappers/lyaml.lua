--- @param input any
--- @return nil
function null2nil(input) -- in-place!
  -- cleanup keys with lyaml.null values
  -- in obj table produced by lyaml.load
  -- https://github.com/gvvaughan/lyaml/issues/31
  for k, v in pairs(input) do
    if v == yaml.null then
      input[k] = nil
    elseif type(v) == "table" then
      null2nil(v)
    end
  end
end

--- @param str string
--- @return any
function yamlLoad(str)
  local res = yaml.load(str)
  null2nil(res)
  return res
end


--- wraps yaml.dump into a more intuitive form which always encodes a single document
--- @param tbl any
--- @return string
function yamlDump(tbl)
  local raw_yaml = yaml.dump({tbl})
  local lines = stringy.split(raw_yaml, "\n")
  return table.concat(lines, "\n", 2, #lines - 2)
end

---@param table table
---@param key_stop integer
---@param value_stop integer
---@param depth integer
---@return string[]
function yamlDumpAlignedInner(table, key_stop, value_stop, depth)
  local lines = {}
  for value_k, value_v in pairs(table) do
    local pre_padding_length = depth * 2
    local key_length = #value_k
    local key_padding_length = key_stop - (key_length + pre_padding_length)
    if type(value_v) == "table" and not (value_v.value or value_v.comment) then 
      listPush(lines, string.rep(" ", depth * 2) .. value_k .. ":" .. string.rep(" ", key_padding_length) .. " ")
      lines = listConcat(lines, yamlDumpAlignedInner(value_v, key_stop, value_stop, depth + 1))
    elseif type(value_v) == "table" and (value_v.value or value_v.comment) then 
      local key_part = string.rep(" ", pre_padding_length) .. value_k .. ":" .. string.rep(" ", key_padding_length) .. " "
      local value_length = 0
      local value_part = ""
      if value_v.value then
        value_length = #value_v.value
        value_part = value_v.value
      end
      local comment_part = ""
      if value_v.comment then
        local value_padding_length = value_stop - value_length
        comment_part = string.rep(" ", value_padding_length) .. " # " .. value_v.comment
      end
      listPush(lines, key_part .. value_part .. comment_part)
    else
      -- do nothing
    end
  end
  
  return lines
end

--- allows for aligned values and comments, but may be less robust than yamlDump, since I'm implementing it myself
--- value and comment must be strings
--- @param tbl table
--- @return string
function yamlDumpAligned(tbl)
  local value_table = mapTableWithValueInCertainKeyToTableHoldingValueDirectly(tbl, "value", true, false)
  local key_stop, value_stop = nestedAssocArrGetMaxStops(value_table)
  return table.concat(yamlDumpAlignedInner(tbl, key_stop, value_stop, 0), "\n")
end