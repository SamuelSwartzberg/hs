--- @param command_parts command_part[] list of things to assemble into a command
--- @return string
function buildInnerCommand(command_parts)
  local command = ""
  command_parts = fixListWithNil(command_parts) -- this allows us to have optional args simply by having them be nil
  inspPrint(command_parts)
  for _, command_part in ipairs(command_parts) do
    if type(command_part) == "string" then
      command = command .. " " .. command_part
    elseif type(command_part) == "table" then
      if command_part.type == "quoted" then
        print(command_part.value)
        print(escapeCharacter(command_part.value, '"', "\\"))
        command = command .. ' "' .. escapeCharacter(command_part.value, '"', "\\") .. '"'
      elseif command_part.type == "interpolated" then
        command = command .. '"$('  .. buildInnerCommand(command_part.value) .. ')"'
      else
        error("Unknown command_part type: " .. command_part.type)
      end
    else
      error("Unknown command_part type: " .. type(command_part))
    end
  end

  return command
end

--- @param command_parts (string | {value: string, type: "quoted" | nil})[]
--- @return string[]
function buildTaskArgs(command_parts)
  local hs_task_args = {
    "-c",
    "cd && source \"$HOME/.target/envfile\" &&" .. buildInnerCommand(command_parts)
  }
  inspPrint(hs_task_args)
  return hs_task_args

end

