--- @class PromptStringArgs
--- @field message string
--- @field informative_text? string
--- @field default? string
--- @field buttonA? string
--- @field buttonB? string

--- @param prompt_args? PromptStringArgs
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
    return hs.dialog.textPrompt(prompt_args.message, prompt_args.informative_text, prompt_args.default,
    prompt_args.buttonA, prompt_args.buttonB)
  end)
  local ok_button_pressed = button_pressed == prompt_args.buttonA

  if stringy.startswith(rawReturn, " ") then -- space triggers lua eval mode
    rawReturn = singleLe(rawReturn)
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
--- @field allows_loop_selection? boolean
--- @field allowed_file_types? string[]
--- @field resolves_aliases? boolean

--- @param prompt_args? PromptPathArgs
--- @return (string|string[]|nil), boolean
function promptPathInner(prompt_args)
  prompt_args                        = prompt_args or {}
  prompt_args.message                = defaultIfNil(prompt_args.message, "Choose a file or folder.")
  prompt_args.default                = defaultIfNil(prompt_args.default, env.HOME)
  prompt_args.can_choose_files       = defaultIfNil(prompt_args.can_choose_files, true)
  prompt_args.can_choose_directories = defaultIfNil(prompt_args.can_choose_directories, true)
  prompt_args.allows_loop_selection  = defaultIfNil(prompt_args.allows_loop_selection, false)
  prompt_args.allowed_file_types     = defaultIfNil(prompt_args.allowed_file_types, {})
  prompt_args.resolves_aliases       = defaultIfNil(prompt_args.resolves_aliases, true)
  local rawReturn                    = hs.dialog.chooseFileOrFolder(prompt_args.message, prompt_args.default,
  prompt_args.can_choose_files, prompt_args.can_choose_directories, prompt_args.allows_loop_selection,
  prompt_args.allowed_file_types, prompt_args.resolves_aliases)
  if rawReturn == nil then
    return nil, false
  end
  local listReturn = values(rawReturn)
  if #listReturn == 0 then
    return nil, true
  end
  if prompt_args.allows_loop_selection then
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
--- @field final_postprocessor? fun(transformedReturn: any): any

--- @param prompt_spec? PromptSpecifier
--- @return any
function promptNopolicy(prompt_spec)
  prompt_spec = copy(prompt_spec) or {}
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
  prompt_spec.prompt_args.informative_text = prompt_spec.prompt_args.informative_text ..
  "on_cancel: " ..
  prompt_spec.on_cancel ..
  ", on_raw_invalid: " ..
  prompt_spec.on_raw_invalid .. ", on_transformed_invalid: " .. prompt_spec.on_transformed_invalid .. "\n"

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
          if prompt_spec.final_postprocessor then
            return prompt_spec.final_postprocessor(transformed_return)
          else
            return transformed_return
          end
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

--- @alias promptInt fun(type: "int", prompt_spec?: PromptSpecifier, loop: "pipeline" | nil): integer|nil
--- @alias promptIntMult fun(type: "int", prompt_spec?: PromptSpecifier, loop: "array"): integer[]|nil
--- @alias promptNumber fun(type: "number", prompt_spec?: PromptSpecifier, loop: "pipeline" | nil): number|nil
--- @alias promptNumberMult fun(type: "number", prompt_spec?: PromptSpecifier, loop: "array"): number[]|nil
--- @alias promptString fun(type?: "string" | "string-path" | "string-filepath", prompt_spec?: PromptSpecifier | string, loop: "pipeline" | nil): string|nil
--- @alias promptStringMult fun(type?: "string" | "string-path" | "string-filepath", prompt_spec?: PromptSpecifier | string, loop: "array"): string[]|nil
--- @alias promptPath fun(type: "path" | "dir", prompt_spec?: PromptSpecifier | string, loop: "pipeline" | nil): string|string[]|nil
--- @alias promptPathMult fun(type: "path" | "dir", prompt_spec?: PromptSpecifier | string, loop: "array"): string[]|nil
--- @alias promptPair fun(type: "pair", prompt_spec?: PromptSpecifier, loop: "pipeline" | nil): string[]|nil
--- @alias promptPairMult fun(type: "pair", prompt_spec?: PromptSpecifier, loop: "array"): string[][]|nil


--- @type promptInt | promptNumber | promptString | promptPath | promptPair | promptIntMult | promptNumberMult | promptStringMult | promptPathMult | promptPairMult
function prompt(type, prompt_spec, loop)
  prompt_spec = copy(prompt_spec) or {}
  prompt_spec.prompt_args = prompt_spec.prompt_args or {}
  type = type or "string"
  if type == "int" then
    prompt_spec = prompt_spec or {}
    prompt_spec.transformer = prompt_spec.transformer or bind(toNumber, {a_use, "int" })
  elseif type == "number" then
    prompt_spec.transformer = prompt_spec.transformer or tonumber
  elseif type == "string" then
    if type(prompt_spec) == "string" then
      prompt_spec = { prompt_args = { message = prompt_spec } } -- prompt_spec shorthand when type is string: prompt_spec is the message
    end
  elseif type == "string-path" or type == "string-filepath" or type == "path" or type == "dir" then
    if type(prompt_spec) == "string" then
      prompt_spec = { prompt_args = { default = prompt_spec } } -- prompt_spec shorthand when type is string: prompt_spec is the default value
    end

    if type == "path" or type == "dir" then
      prompt_spec.prompt_args.default = prompt_spec.prompt_args.default or ""

      if type == "dir" then
        prompt_spec.prompt_args.can_choose_files = false
        prompt_spec.prompt_args.message = prompt_spec.prompt_args.message or "Choose a directory"
      end

      prompt_spec.prompter = promptPathInner
    elseif type == "string-path" then
      prompt_spec.transformed_validator = function(x)
        local res = (x ~= nil)
        if res then
          res = pcall(createPath, x)
        end
        return res
      end
    elseif type == "string-filepath" then
      prompt_spec.transformed_validator = function(x)
        local res = (x ~= nil)
        if res then
          res = pcall(writeFile, x)
        end
        return res
      end
    end
  elseif type == "pair" then
    if type(prompt_spec) == "string" then
      prompt_spec = { prompt_args = { message = prompt_spec } }
    end
    prompt_spec.prompt_args.message = "Add a new " .. prompt_spec.prompt_args.message .. " pair, separated by '-'"
    prompt_spec.transformer = function(x)
      local key, value = x:match("^(.-)-(.*)$")
      if key ~= nil and value ~= nil then
        ---@diagnostic disable-next-line: return-type-mismatch -- not sure why, but lua-language-server seems to have cast prompt_spec.transformer to `tonumber` for some reason. Since lua-language-server is often a bit buggy, I'm just going to disable the warning for now.
        return { key, value }
      else
        ---@diagnostic disable-next-line: return-type-mismatch
        return nil
      end
    end
  end

  prompt_spec.prompt_args.message = prompt_spec.prompt_args.message or ("Enter a " .. type .. ":")

  if loop == "array" then
    prompt_spec.raw_validator = function(x) return x ~= nil end -- ensure that we can end the loop by a nil-equivalent prompt input
    local res = {}
    while true do
      local x = promptNopolicy(prompt_spec)
      if x == nil then
        return res
      else
        table.insert(res, x)
      end
    end
  elseif loop == "pipeline" then
    while true do
      local x = promptNopolicy(prompt_spec)
      if x == prompt_spec.prompt_args.default then
        return prompt_spec.prompt_args.default
      else
        prompt_spec.prompt_args.default = x
      end
    end
  else
    return promptNopolicy(prompt_spec)
  end
end

function promptPipeline(prompt_pipeline)
  local res = prompt_pipeline[1].prompt_args.default
  for _, args in iprs(prompt_pipeline) do
    local prompt_spec = args[2] or {}
    prompt_spec.prompt_args = prompt_spec.prompt_args or {}
    prompt_spec.prompt_args.default = res
    res = prompt(args[1], prompt_spec, args[3])
  end
  return res
end
