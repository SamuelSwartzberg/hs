--- a env map is a table of key-value pairs where the values are either strings or env items

local function getDependencyLines(line_with_dependencies, lines_with_dependencies)
  local lines = {}
  for _, dependency in iprs(line_with_dependencies.dependencies) do
    local dependency_line_with_dependencies = lines_with_dependencies[dependency]
    if dependency_line_with_dependencies then
      lines = concat(lines, getDependencyLines(dependency_line_with_dependencies, lines_with_dependencies))
    end
  end
  push(lines, line_with_dependencies.line)
  return lines
end

--- @type ItemSpecifier
EnvMapSpecifier = {
  type = "env-map",
  properties = {
    getables = {
      ["env-lines"] = function(self, pkey)
        local  lines = {}
        local pkey_var = pkey and "$" .. pkey .. "/" or ""
        for key, value in fastpairs(self:get("contents")) do
          if type(value) == "string" then
            push(lines, string.format("%s=\"%s%s\"", key, pkey_var, value))
          elseif value.type == "env-item" then
            lines = concat(lines, value:get("env-lines", { pkey_var = pkey_var, key = key }))
          end
        end
        return lines
      end,
      ["env-lines-dependency-ordered"] = function(self)
        -- order the env lines so that the dependencies are defined before the dependents
        local lines = self:get("env-lines")
        local lines_with_dependencies = {}
        for _, line in iprs(lines) do
          local key, value = string.match(line, "^([A-Z0-9_]-)=\"(.*)\"$")
          local dependencies
          if value then
            local match = value:gmatch("%$([A-Z0-9_]+)")
            dependencies = iterToTbl({tolist=true, ret="v"},match)
          else
            dependencies = {}
          end
          lines_with_dependencies[key] = { line = line, dependencies = dependencies }
        end
        local out_lines = {}
        for _, line_with_dependencies in fastpairs(lines_with_dependencies) do
          out_lines = concat(out_lines, getDependencyLines(line_with_dependencies, lines_with_dependencies))
        end
        return toSet(out_lines)
      end,
          
      ["to-env-file-string"] = function(self)
        local lines = self:get("env-lines-dependency-ordered")
        local line_string = stringx.join("\n", lines)
        line_string = table.concat(
          map(
            stringy.split(line_string, "\n"),
            {_f = "export %s"}
          )
        )
        return "#!/usr/bin/env bash\n\n" ..
          "set -u\n\n" .. 
          line_string .. 
          "\n\nset +u\n"
      end,
    },
    doThisables = {
      
     
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
 CreateEnvMap = bindArg(NewDynamicContentsComponentInterface, EnvMapSpecifier)
