--- @param input any
--- @return nil
function null2nil(input) -- in-place!
  -- cleanup keys with lyaml.null values
  -- in obj table produced by lyaml.load
  -- https://github.com/gvvaughan/lyaml/issues/31
  for k, v in prs(input) do
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
---@param keystop integer
---@param valuestop integer
---@param depth integer
---@return string[]
function yamlDumpAlignedInner(table, keystop, valuestop, depth)
  local lines = {}
  for value_k, value_v in prs(table) do
    local pre_padding_length = depth * 2
    local key_length = #value_k
    local key_padding_length = keystop - (key_length + pre_padding_length)
    if type(value_v) == "table" and not (value_v.value or value_v.comment) then 
      push(lines, string.rep(" ", depth * 2) .. value_k .. ":" .. string.rep(" ", key_padding_length) .. " ")
      lines = concat(lines, yamlDumpAlignedInner(value_v, keystop, valuestop, depth + 1))
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
        local value_padding_length = valuestop - value_length
        comment_part = string.rep(" ", value_padding_length) .. " # " .. value_v.comment
      end
      push(lines, key_part .. value_part .. comment_part)
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
  local value_table = map(
    tbl,
    {_k = "value", _ret = "orig" },
    { recurse = true, treat_as_leaf = "list" }
  )
  local stops = flatten(value_table, {
    treat_as_leaf = "list",
    mode = "assoc",
    val = {"valuestop", "keystop"},
  })
  local valuestop = reduce(map(values(stops), {_k = "valuestop"}))
  local keystop = reduce(map(values(stops), {_k = "keystop"}))
  return table.concat(yamlDumpAlignedInner(tbl, keystop, valuestop, 0), "\n")
end