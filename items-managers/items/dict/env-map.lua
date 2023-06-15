--- a env map is a table of key-value pairs where the values are either strings or env items

local function getDependencyLines(line_with_dependencies, lines_with_dependencies)
  local lines = {}
  for _, dependency in ipairs(line_with_dependencies.dependencies) do
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

      ["env-lines-dependency-ordered"] = function(self)
        -- order the env lines so that the dependencies are defined before the dependents
        local lines = self:get("env-lines")
        local w_deps = {}
        
        local out_lines = {}
        for _, line_with_dependencies in fastpairs(w_deps) do
          out_lines = concat(out_lines, getDependencyLines(line_with_dependencies, w_deps))
        end
        return toSet(out_lines)
      end,
    },
    doThisables = {
      
     
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
 CreateEnvMap = bindArg(NewDynamicContentsComponentInterface, EnvMapSpecifier)
