
--- @param str string
--- @param env? table
--- @return any
function evaluateStringToValue(str, env)
  local luaExecutable = load("return " .. str, "chunk", "t", env or _G)
  if luaExecutable ~= nil then -- expression
    return luaExecutable()
  else
    local luaExecutable = load(str, "chunk", "t", env or _G)
    if luaExecutable ~= nil then -- statement, must return within the statement itself
      return luaExecutable()
    else
      error("Neither a valid expression nor a valid statement.")
    end
  end
end

function evalWithLocal(str, d)
  local env = _G
  env.d = d
  return evaluateStringToValue(str, env)
end
evalEnv = bind(evaluateStringToValue, {["2"] = env})

--- @param template string
--- @return string
function envsubstShell(template)
  return run({
    "echo", 
    {value = template, type = "quoted"},
    "|",
    "envsubst"
  })
end

--- @param template string
--- @return string
function envsubstLua(template)
  local res = eutf8.gsub(template, "%${(.-)}", evalEnv)
  return res
end

--- simple implementation of a template engine
--- Surround material to be templated from global namespace together local data model (addressable by `d`) by `{{[]}}`
--- to make parsing easier, nesting is not supported
--- @param template string
--- @param d? table
--- @return string
function luaTemplateEval(template, d)
  local res = eutf8.gsub(template, "{{%[(.-)%]}}", function(item)
    return evalWithLocal(item, d)
  end)
  return res
end

le = luaTemplateEval

--- @param template string
--- @param yaml_file string
--- @return string
function luaTemplateEvalFromYaml(template, yaml_file)
  local d = yaml.load(readFile(yaml_file, "error"))
  return luaTemplateEval(template, d)
end