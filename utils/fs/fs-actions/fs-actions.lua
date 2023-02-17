--- @param path string
--- @param app? string
--- @return boolean
function openPath(path, app)
  local apparg = app and "-A '" .. app .. "' " or "" 
  local _, status = hs.execute("open " .. apparg .. "'" .. path .. "'")
  return status
end

--- @param path string
function openPathVscode(path)
  if not type(path) == "string" then 
    error("path must be a string")
  end
   runHsTask({
    "open",
    "-a",
     { value = "Visual Studio Code", type = "quoted" },
    { value = path, type = "quoted" }
  })
end

--- @param contents string
function openStringInVscode(contents)
  local tmp_file = createUniqueTempFile(contents)
  openPathVscode(tmp_file)
end

--- @param path string
function processSetupDirectivesInFiles(path)
  for _, child in ipairs(getChildren(path, false,true)) do
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
      local args = stringy.split(line, " ")
      print(
        "Would execute"
        .. " _G[\"" .. command .. "\"]"
        .. "(" .. table.concat(args, ", ") .. ")"
      )
      _G[command](table.unpack(args))
    end
  end
end













