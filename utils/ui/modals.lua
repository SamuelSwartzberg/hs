
--- @param question string
--- @return boolean
function promptYesNo(question)
  return doWithActivated("Hammerspoon", function()
    local rawReturn = hs.dialog.blockAlert(question, "", "Yes", "No")
    return rawReturn == "Yes"
  end)
end

--- @class PromptStringArgs
--- @field message string
--- @field informative_text? string
--- @field default? string
--- @field buttonA? string
--- @field buttonB? string

--- @param prompt_args PromptStringArgs
--- @return (string|nil), boolean
function promptStringInner(prompt_args)
  prompt_args = prompt_args or {}
  prompt_args.message = prompt_args.message or "Enter a string."
  prompt_args.informative_text = prompt_args.informative_text or ""
  prompt_args.default = prompt_args.default or ""
  prompt_args.buttonA = prompt_args.buttonA or "OK"
  prompt_args.buttonB = prompt_args.buttonB or "Cancel"
  --- @type string, string|nil
  local button_pressed, rawReturn = doWithActivated("Hammerspoon", function()
    return hs.dialog.textPrompt(prompt_args.message, prompt_args.informative_text, prompt_args.default, prompt_args.buttonA, prompt_args.buttonB)
  end)
  local ok_button_pressed = button_pressed == prompt_args.buttonA
  
  if stringy.startswith(rawReturn, " ") then -- space triggers lua eval mode
    rawReturn = evaluateStringToValue(rawReturn)
  end
  if rawReturn == "" then
    rawReturn = nil
  end

  return rawReturn, ok_button_pressed

end

--- @class PromptPathArgs
--- @field message? string
--- @field default? string
--- @field can_choose_files? boolean
--- @field can_choose_directories? boolean
--- @field allows_multiple_selection? boolean
--- @field allowed_file_types? string[]
--- @field resolves_aliases? boolean

--- @param prompt_args PromptPathArgs
--- @return (string|string[]|nil), boolean
function promptPathInner(prompt_args)
  prompt_args = prompt_args or {}
  prompt_args.message = defaultIfNil(prompt_args.message, "Choose a file or folder.")
  prompt_args.default = defaultIfNil(prompt_args.default, env.HOME)
  prompt_args.can_choose_files = defaultIfNil(prompt_args.can_choose_files, true)
  prompt_args.can_choose_directories = defaultIfNil(prompt_args.can_choose_directories, true)
  prompt_args.allows_multiple_selection  = defaultIfNil(prompt_args.allows_multiple_selection, false)
  prompt_args.allowed_file_types = defaultIfNil(prompt_args.allowed_file_types , {})
  prompt_args.resolves_aliases = defaultIfNil(prompt_args.resolves_aliases, true)
  local rawReturn = hs.dialog.chooseFileOrFolder(prompt_args.message, prompt_args.default, prompt_args.can_choose_files, prompt_args.can_choose_directories, prompt_args.allows_multiple_selection, prompt_args.allowed_file_types, prompt_args.resolves_aliases)
  if rawReturn == nil then
    return nil, false
  end
  local listReturn = values(rawReturn)
  if #listReturn == 0 then
    return nil, true
  end
  if prompt_args.allows_multiple_selection then
    return listReturn, true
  else
    return listReturn[1], true
  end
end

--- @alias failure_action "error" | "return_nil" | "reprompt"

--- @class PromptSpecifier
--- @field prompter? fun(prompt_args: table): any, boolean must return nil on the equivalent of an empty value
--- @field prompt_args? table
--- @field transformer? fun(rawReturn: any): any
--- @field raw_validator? fun(rawReturn: any): boolean
--- @field transformed_validator? fun(transformedReturn: any): boolean
--- @field on_cancel? failure_action
--- @field on_raw_invalid? failure_action
--- @field on_transformed_invalid? failure_action

--- @param prompt_spec? PromptSpecifier
--- @return any
function prompt(prompt_spec)
  prompt_spec = prompt_spec or {}
  prompt_spec.prompter = prompt_spec.prompter or promptStringInner
  prompt_spec.transformer = prompt_spec.transformer or function(x) return x end
  prompt_spec.raw_validator = prompt_spec.raw_validator or function(x) return x ~= nil end
  prompt_spec.transformed_validator = prompt_spec.transformed_validator or function(x) return x ~= nil end
  prompt_spec.on_cancel = prompt_spec.on_cancel or "error"
  prompt_spec.on_raw_invalid = prompt_spec.on_raw_invalid or "return_nil"
  prompt_spec.on_transformed_invalid = prompt_spec.on_transformed_invalid or "reprompt"
  prompt_spec.prompt_args = prompt_spec.prompt_args or {}
  local validation_extra = ""
  local original_informative_text = prompt_spec.prompt_args.informative_text
  while true do
    if original_informative_text then
      prompt_spec.prompt_args.informative_text = original_informative_text .. "\n" .. validation_extra
    else
      prompt_spec.prompt_args.informative_text = validation_extra
    end
    local raw_return, ok_button_pressed = prompt_spec.prompter(prompt_spec.prompt_args)
    prompt_spec.prompt_args.informative_text = original_informative_text
    if ok_button_pressed then
      if prompt_spec.raw_validator(raw_return) then
        local transformed_return = prompt_spec.transformer(raw_return)
        if prompt_spec.transformed_validator(transformed_return) then
          return transformed_return
        else
          if prompt_spec.on_transformed_invalid == "error" then
            error("WARN: User input was invalid (after transformation).")
          elseif prompt_spec.on_transformed_invalid == "return_nil" then
            return nil
          elseif prompt_spec.on_transformed_invalid == "reprompt" then
            local has_string_eqviv, string_eqviv = pcall(tostring, raw_return)
            local transformed_has_string_eqviv, transformed_string_eqviv = pcall(tostring, transformed_return)
            validation_extra = 
              "Invalid input:\n" ..
              "  Original: " .. (has_string_eqviv and string_eqviv or "<not tostringable>") .. "\n" ..
              "  Transformed: " .. (transformed_has_string_eqviv and transformed_string_eqviv or "<not tostringable>")
          end
        end
      else
        if prompt_spec.on_raw_invalid == "error" then
          error("WARN: User input was invalid (before transformation).")
        elseif prompt_spec.on_raw_invalid == "return_nil" then
          return nil
        elseif prompt_spec.on_raw_invalid == "reprompt" then
          local has_string_eqviv, string_eqviv = pcall(tostring, raw_return)
          validation_extra = "Invalid input: " .. (has_string_eqviv and string_eqviv or "<not tostringable>")
        end
      end
    else
      if prompt_spec.on_cancel == "error" then
        error("WARN: User cancelled modal.")
      elseif prompt_spec.on_cancel == "return_nil" then
        return nil
      end
    end
  end
end

--- @param prompt_spec? PromptSpecifier
--- @return any[]
function promptList(prompt_spec)
  prompt_spec.raw_validator = function(x) return x ~= nil end -- ensure that we can end the loop by a nil-equivalent prompt input
  local res = {}
  while true do
    local x = prompt(prompt_spec)
    if x == nil then
      return res
    else
      table.insert(res, x)
    end
  end
end

--- @param prompt_spec? PromptSpecifier
--- @return number|nil
function promptNumber(prompt_spec)
  prompt_spec = prompt_spec or {}
  prompt_spec.transformer = prompt_spec.transformer or tonumber
  prompt_spec.transformed_validator = prompt_spec.transformed_validator or function(x) return x ~= nil end -- tonumber returns nil on failure
  return prompt(prompt_spec)
end

--- @param prompt_spec? PromptSpecifier
--- @return integer|nil
function promptInteger(prompt_spec)
  prompt_spec = prompt_spec or {}
  prompt_spec.transformer = prompt_spec.transformer or bindNthArg(toNumber, 2, "int")
  prompt_spec.transformed_validator = prompt_spec.transformed_validator or function(x) return x ~= nil end 
  return prompt(prompt_spec)
end

--- @param msg? string
--- @param prompt_spec? PromptSpecifier
--- @return string|nil
function promptString(msg, prompt_spec)
  prompt_spec = prompt_spec or {}
  prompt_spec.prompt_args = prompt_spec.prompt_args or {}
  prompt_spec.prompt_args.message = msg or prompt_spec.prompt_args.message or "Enter a string."
  return prompt(prompt_spec)
end

--- @param path? string
--- @param prompt_spec? PromptSpecifier
--- @return string|string[]|nil
function promptPath(path, prompt_spec)
  prompt_spec = prompt_spec or {}
  prompt_spec.prompt_args = prompt_spec.prompt_args or {}
  prompt_spec.prompt_args.default = path or prompt_spec.prompt_args.default or ""
  prompt_spec.prompter = promptPathInner
  return prompt(prompt_spec)
end

--- @param value string
--- @param thing_value_is_for? string
--- @param prompt_spec? PromptSpecifier
--- @return any
function promptUserToEditValue(value, thing_value_is_for, prompt_spec)
  local prompt_spec_local = {
    prompt_args = {
      message = "Confirm value" .. 
      (
        thing_value_is_for 
        and " for " .. thing_value_is_for
        or ""
      ),
      default = value,
    },
  }
  prompt_spec = mergeAssocArrRecursive(prompt_spec or {}, prompt_spec_local)
  return prompt(prompt_spec)
end

--- @param name_of_pairs string
--- @return { [string]: string }
function promptUserToAddNKeyValuePairs(name_of_pairs)
  local pairs = promptList({
    prompt_args = {
      message = "Add a new " .. name_of_pairs .. " pair, separated by '-'",
    },
    transformer = function(x)
      local key, value = x:match("^(.-)-(.*)$")
      if key ~= nil and value ~= nil then
        return {key, value}
      else
        return nil
      end
    end,

  })
  return mapPairNewPairOvtable(pairs, function(i, pair)
    return pair[1], pair[2]
  end)
end

--- @param path string
--- @param prompt_spec? PromptSpecifier
--- @return string
function promptSingleDir(path, prompt_spec)
  prompt_spec = prompt_spec or {}
  prompt_spec.prompter = promptPathInner
  prompt_spec.prompt_args = prompt_spec.prompt_args or {}
  prompt_spec.prompt_args.default = path
  prompt_spec.prompt_args.can_choose_files = false
  prompt_spec.prompt_args.message = prompt_spec.prompt_args.message or "Choose a directory"
  return prompt(prompt_spec)
end




--- @param path string
--- @param prompt_spec? PromptSpecifier
--- @return string
function potentiallyCreateSubdir(path, prompt_spec)
  prompt_spec = prompt_spec or {}
  prompt_spec.prompt_args = prompt_spec.prompt_args or {}
  prompt_spec.prompt_args.message = prompt_spec.prompt_args.message or "Subdirectory name (empty for none)"
  local subdir = prompt(prompt_spec)
  if subdir ~= nil then
    local final_path = ensureAdfix(path, "/", true, false, "suf") .. subdir
    if not pathExists(final_path) then 
      hs.fs.mkdir(final_path)
    end
    return final_path
  else
    return path
  end
end

--- @param path string
--- @param prompt_spec? PromptSpecifier
--- @return string
function potentiallyCreateChildFile(path, prompt_spec)
  prompt_spec = prompt_spec or {}
  prompt_spec.prompt_args = prompt_spec.prompt_args or {}
  prompt_spec.prompt_args.message = prompt_spec.prompt_args.message or "File name (empty for none)"
  prompt_spec.prompt_args.default = prompt_spec.prompt_args.default or "default.txt"
  local file_name = prompt(prompt_spec)
  if file_name ~= nil then
    local final_path = ensureAdfix(path, "/", true, false, "suf") .. file_name
    writeFile(final_path, "", "not-exists")
    return final_path
  else
    return path
  end
end

--- @param path string
--- @param subdir_default? string
--- @return string
function chooseDirAndPotentiallyCreateSubdir(path, subdir_default)
  local actual_path = promptSingleDir(path)
  local subdir = potentiallyCreateSubdir(actual_path, { prompt_args = { default = subdir_default } })
  return subdir
end

--- @param path string
--- @return string
function chooseDirAndPotentiallyCreateSubdirs(path)
  local actual_path = promptSingleDir(path)
  while true do
    local subdir = potentiallyCreateSubdir(actual_path)
    if subdir == actual_path then
      break
    else
      actual_path = subdir
    end
  end
  return actual_path
end

--- @param path string
--- @return string
function chooseDirAndCreateSubdirsAndFiles(path)
  local dir_path = chooseDirAndPotentiallyCreateSubdirs(path)
  local file_name = potentiallyCreateChildFile(dir_path)
  return file_name
end

