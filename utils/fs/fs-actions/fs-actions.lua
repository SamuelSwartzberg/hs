

--- @param path string
function processSetupDirectivesInFiles(path)
  for _, child in ipairs(itemsInPath({path = path, include_dirs = false})) do
    logFile("processSetupDirectivesInFiles", child)
    local basename = getLeafWithoutPath(child)
    local command = changeCasePre(
      table.concat(
        mapValueNewValue(
          stringy.split(basename, "-"),
          function (part)
            return changeCasePre(part, 1, "up")
          end
        ), 
        ""
      ),
      1,
      "down"
    )
    local contents = stringy.strip(envsubstShell(readFile(child)))
    for line in stringx.lines(contents) do
      line = stringy.strip(line)
      if not stringy.startswith(line, "#") then -- allow for simple comments
        local tabbed_line = stringy.split(line, "\t")
        local interval = tabbed_line[1]
        local argstring = tabbed_line[2]
        local args = stringy.split(argstring, " ")
        args = mapValueNewValue(args, function (arg)
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
        print(
          "Would execute"
          .. " _G[\"" .. command .. "\"]"
          .. "(" .. table.concat(mapValueToStr(args), ", ") .. ")"
        )
        print(
          "with interval " .. interval
        )
        if stringy.startswith(interval, "@") then -- is an event
          if interval == "@startup" then
            _G[command](table.unpack(args))
          else
            -- in the future: add support for other events
          end
        else -- is a timer
          System:get("manager", "timer"):doThis("create", {
            interval = interval,
            fn = function ()
              _G[command](table.unpack(args))
            end
          })
        end
      end
    end
  end
end






