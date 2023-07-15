
--- @param str string
--- @param d? table
--- @return any
function singleLe(str, d)
  if d then -- add d to global namespace so that it can be accessed in the string
    _G.d = d
  end
  local luaExecutable = load("return " .. str, "chunk", "t", _G)
  if luaExecutable ~= nil then -- expression
    return luaExecutable()
  else
    local luaExecutable = load(str, "chunk", "t", _G)
    if luaExecutable ~= nil then -- statement, must return within the statement itself
      return luaExecutable()
    else
      error("Neither a valid expression nor a valid statement.")
    end
  end
  _G.d = nil

end

--- simple implementation of a template engine
--- Surround material to be templated from global namespace together local data model (addressable by `d`) by `{{[]}}`
--- to make parsing easier, nesting is not supported
--- @param template string
--- @param d? table | string either a table or a path to a yaml or json file containing the data model
--- @return string
function le(template, d)
  if type(d) == "string" then
    if stringy.endswith(d, ".yaml") then
      d = yaml.load(transf.file.contents(d, "error"))
    elseif stringy.endswith(d, ".json") then
      d = json.decode(transf.file.contents(d, "error"))
    else
      error("Unknown file type.")
    end
  end
  local res = eutf8.gsub(template, "{{%[(.-)%]}}", function(item)
    return singleLe(item, d)
  end)
  return res
end