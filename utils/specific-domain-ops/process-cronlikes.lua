--- @class cronlikeSpec
--- @field condition string
--- @field conditionType "timer" | "startup"
--- @field fn string
--- @field args string[]

--- @param line string
--- @param fn string
--- @return cronlikeSpec
function processCronlikeLine(line, fn)
  local tabbed_line = stringy.split(line, "\t")
  --- @type string | nil
  local condition = tabbed_line[1]
  local argstring = tabbed_line[2]
  local args = stringy.split(argstring, " ")
  args = map(args, function (arg)
    if arg == "true" then
      return true
    elseif arg == "false" then
      return false
    elseif arg == "nil" then
      return nil
    else
      return arg
    end
  end)
  local conditionType
  if stringy.startswith(condition, "@") then
    conditionType = string.sub(condition, 2)
    condition = nil
  else
    conditionType = "timer"
  end
  return {
    condition = condition,
    conditionType = conditionType,
    fn = fn,
    args = args
  }
end

--- @param rawcnt string
--- @param fn string
--- @return cronlikeSpec[]
function processCronlikeContents(rawcnt, fn)
  local contents = run({ "envsubst", "<<<", { value =rawcnt, type ="sq"} })
  local specs = {}
  for line in stringx.lines(contents) do
    line = stringy.strip(line)
    if not stringy.startswith(line, "#") and #line > 0 then -- allow for simple comments
      push(specs, processCronlikeLine(line, fn))
    end
  end
  return specs
end

--- @param filename string
--- @return cronlikeSpec[]
function processCronlikeFile(filename)
  local basename = pathSlice(filename, "-1:-1")[1]
  local command = replace(
    table.concat(
      map(
        stringy.split(basename, "-"),
        function (part)
          return replace(part, to.case.capitalized)
        end
      ), 
      ""
    ),
    to.case.notcapitalized
  )
  return processCronlikeContents(readFile(filename), command)
end


--- @param path string
function processSetupDirectivesInFiles(path)
  for _, child in iprs(itemsInPath({path = path, include_dirs = false})) do
    local cronlikeSpecs = processCronlikeFile(child)
    
    for _, spec in iprs(cronlikeSpecs) do
      if spec.conditionType == "startup" then
        _G[spec.fn](table.unpack(spec.args))
      elseif spec.conditionType == "timer" then
        System:get("manager", "timer"):doThis("create", {
          interval = spec.condition,
          fn = function ()
            _G[spec.fn](table.unpack(spec.args))
          end
        })
      end 
    end
  end
end






