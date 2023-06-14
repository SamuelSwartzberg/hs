--- @class PrompterArgs
--- @field message? any Message to display in the prompt.
--- @field default? any Default value for the prompt.

--- @class PromptStringArgs : PrompterArgs
--- @field informative_text? any Additional text to display in the prompt.
--- @field buttonA? any Label for the first button.
--- @field buttonB? any Label for the second button.

--- @param prompt_args? PromptStringArgs
--- @return (string|nil), boolean
function promptStringInner(prompt_args)

  -- set up default values, make sure provided values are strings

  prompt_args = prompt_args or {}
  prompt_args.message = transf.not_nil.string(prompt_args.message) or "Enter a string."
  prompt_args.informative_text = transf.not_nil.string(prompt_args.informative_text) or ""
  prompt_args.default = transf.not_nil.string(prompt_args.default) or ""
  prompt_args.buttonA = transf.not_nil.string(prompt_args.buttonA) or "OK"
  prompt_args.buttonB = transf.not_nil.string(prompt_args.buttonB) or "Cancel"

  -- show prompt

  --- @type string, string|nil
  local button_pressed, rawReturn = doWithActivated("Hammerspoon", function()
    return hs.dialog.textPrompt(prompt_args.message, prompt_args.informative_text, prompt_args.default,
    prompt_args.buttonA, prompt_args.buttonB)
  end)

  -- process result

  local ok_button_pressed = button_pressed == prompt_args.buttonA

  if stringy.startswith(rawReturn, " ") then -- space triggers lua eval mode
    rawReturn = singleLe(rawReturn)
  end
  if rawReturn == "" then
    rawReturn = nil
  end

  -- return result

  return rawReturn, ok_button_pressed
end

--- @class PromptPathArgs
--- @field can_choose_files? boolean 
--- @field can_choose_directories? boolean
--- @field allows_loop_selection? boolean
--- @field allowed_file_types? string[]
--- @field resolves_aliases? boolean

--- @param prompt_args? PromptPathArgs
--- @return (string|string[]|nil), boolean
function promptPathInner(prompt_args)

    -- set up default values, make sure message and default are strings

  prompt_args                        = prompt_args or {}
  prompt_args.message                = defaultIfNil(transf.not_nil.string(prompt_args.message), "Choose a file or folder.")
  prompt_args.default                = defaultIfNil(transf.not_nil.string(prompt_args.default), env.HOME)
  prompt_args.can_choose_files       = defaultIfNil(prompt_args.can_choose_files, true)
  prompt_args.can_choose_directories = defaultIfNil(prompt_args.can_choose_directories, true)
  prompt_args.allows_loop_selection  = defaultIfNil(prompt_args.allows_loop_selection, false)
  prompt_args.allowed_file_types     = defaultIfNil(prompt_args.allowed_file_types, {})
  prompt_args.resolves_aliases       = defaultIfNil(prompt_args.resolves_aliases, true)

  prompt_args.default = transf.string.path_resolved(prompt_args.default, true) -- resolve the path ourself, to be sure & remain in control

  -- show prompt

  local rawReturn                    = hs.dialog.chooseFileOrFolder(prompt_args.message, prompt_args.default, prompt_args.can_choose_files, prompt_args.can_choose_directories, prompt_args.allows_loop_selection, prompt_args.allowed_file_types, prompt_args.resolves_aliases)

  -- process result

  if rawReturn == nil then
    return nil, false
  end
  local listReturn = values(rawReturn)
  if #listReturn == 0 then
    return nil, true
  end

  -- return result

  if prompt_args.allows_loop_selection then
    return listReturn, true
  else
    return listReturn[1], true
  end
end

--- @alias failure_action "error" | "return_nil" | "reprompt"

--- @class PromptSpecifier
--- @field prompter? fun(prompt_args: table): any, boolean The function that implements prompting. Must return nil on the equivalent of an empty value.
--- @field prompt_args? table Arguments to pass to `prompter`.
--- @field transformer? fun(rawReturn: any): any transforms the raw return value into the transformed return value. Default is the identity function.
--- @field raw_validator? fun(rawReturn: any): boolean validates before application of `transformer`. Default is ensuring the return value is not nil.
--- @field transformed_validator? fun(transformedReturn: any): boolean validates after application of `transformer`. Default is ensuring the return value is not nil.
--- @field on_cancel? failure_action What to do if the user cancels the prompt. May error, return nil, or reprompt. Default is "error".
--- @field on_raw_invalid? failure_action What to do if the raw return value is invalid. May error, return nil, or reprompt. Default is "return_nil".
--- @field on_transformed_invalid? failure_action What to do if the transformed return value is invalid. May error, return nil, or reprompt. Default is "reprompt".
--- @field final_postprocessor? fun(transformedReturn: any): any A function to run on the final transformed return value, after validation. Default is the identity function.

--- With the default prompt_spec, we will error if cancelled, return nil if the raw return value is the equivalent of an empty value, and never reprompt.
--- @param prompt_spec? PromptSpecifier
--- @return any
function promptNopolicy(prompt_spec)

  -- set defaults for all prompt_spec fields
  prompt_spec = copy(prompt_spec) or {}
  prompt_spec.prompter = prompt_spec.prompter or promptStringInner
  prompt_spec.transformer = prompt_spec.transformer or function(x) return x end
  prompt_spec.raw_validator = prompt_spec.raw_validator or function(x) return x ~= nil end
  prompt_spec.transformed_validator = prompt_spec.transformed_validator or function(x) return x ~= nil end
  prompt_spec.on_cancel = prompt_spec.on_cancel or "error"
  prompt_spec.on_raw_invalid = prompt_spec.on_raw_invalid or "return_nil"
  prompt_spec.on_transformed_invalid = prompt_spec.on_transformed_invalid or "reprompt"
  prompt_spec.prompt_args = prompt_spec.prompt_args or {}

  -- generate some informative text mainly used when prompter is promptStringInner, though other prompters can consume this too
  local validation_extra
  local original_informative_text = prompt_spec.prompt_args.informative_text
  local info_on_reactions = "c: " ..
    prompt_spec.on_cancel ..
    ", r_i: " ..
    prompt_spec.on_raw_invalid .. 
    ", t_i: " .. 
    prompt_spec.on_transformed_invalid
  local static_informative_text 
  if original_informative_text then
    static_informative_text = original_informative_text .. "\n" .. info_on_reactions
  else
    static_informative_text = info_on_reactions
  end

  -- main loop to allow reprompting when prompt_spec conditions for reprompting are met
  while true do

    -- add information on why the prompter is being called to the informative text, if it exists
    if validation_extra then
      prompt_spec.prompt_args.informative_text = static_informative_text .. "\n" .. validation_extra
    else
      prompt_spec.prompt_args.informative_text = static_informative_text
    end

    -- call the prompter
    local raw_return, ok_button_pressed = prompt_spec.prompter(prompt_spec.prompt_args)

    if ok_button_pressed then -- not cancelled
      if prompt_spec.raw_validator(raw_return) then -- raw input was valid
        local transformed_return = prompt_spec.transformer(raw_return)
        if prompt_spec.transformed_validator(transformed_return) then -- transformed input was valid

          -- if the prompt_spec has a final_postprocessor, call it. No matter what, return the result
          if prompt_spec.final_postprocessor then
            return prompt_spec.final_postprocessor(transformed_return)
          else
            return transformed_return
          end
        else -- transformed input was invalid, handle according to prompt_spec.on_transformed_invalid
          if prompt_spec.on_transformed_invalid == "error" then
            error("WARN: User input was invalid (after transformation).", 0)
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
      else -- raw input was invalid, handle according to prompt_spec.on_raw_invalid
        if prompt_spec.on_raw_invalid == "error" then
          error("WARN: User input was invalid (before transformation).", 0)
        elseif prompt_spec.on_raw_invalid == "return_nil" then
          return nil
        elseif prompt_spec.on_raw_invalid == "reprompt" then
          local has_string_eqviv, string_eqviv = pcall(tostring, raw_return)
          validation_extra = "Invalid input: " .. (has_string_eqviv and string_eqviv or "<not tostringable>")
        end
      end
    else -- cancelled, handle according to prompt_spec.on_cancel
      if prompt_spec.on_cancel == "error" then
        error("WARN: User cancelled modal.", 0)
      elseif prompt_spec.on_cancel == "return_nil" then
        return nil
      end
    end
  end
end

--- @alias promptInt fun(type: "int", prompt_spec?: PromptSpecifier, loop: "pipeline" | nil): integer|nil prompts for a string, transforms it to an integer.
--- @alias promptIntMult fun(type: "int", prompt_spec?: PromptSpecifier, loop: "array"): integer[]|nil
--- @alias promptNumber fun(type: "number", prompt_spec?: PromptSpecifier, loop: "pipeline" | nil): number|nil prompts for a string, transforms it to a number.
--- @alias promptNumberMult fun(type: "number", prompt_spec?: PromptSpecifier, loop: "array"): number[]|nil
--- @alias promptString fun(type?: "string" | "string-path" | "string-filepath", prompt_spec?: PromptSpecifier | string, loop: "pipeline" | nil): string|nil prompts for a string, optionally validates it as a path or filepath. If prompt_spec is a string, it is used as the message for "string", and as the default value for "string-path" and "string-filepath".
--- @alias promptStringMult fun(type?: "string" | "string-path" | "string-filepath", prompt_spec?: PromptSpecifier | string, loop: "array"): string[]|nil
--- @alias promptPath fun(type: "path" | "dir", prompt_spec?: PromptSpecifier | string, loop: "pipeline" | nil): string|string[]|nil
--- @alias promptPathMult fun(type: "path" | "dir", prompt_spec?: PromptSpecifier | string, loop: "array"): string[]|nil
--- @alias promptPair fun(type: "pair", prompt_spec?: PromptSpecifier, loop: "pipeline" | nil): string[]|nil
--- @alias promptPairMult fun(type: "pair", prompt_spec?: PromptSpecifier, loop: "array"): string[][]|nil


--- @type promptInt | promptNumber | promptString | promptPath | promptPair | promptIntMult | promptNumberMult | promptStringMult | promptPathMult | promptPairMult
function prompt(ptype, prompt_spec, loop)
  local non_table_prompt_spec
  if type(prompt_spec) == "table" then
    prompt_spec = copy(prompt_spec)
  elseif prompt_spec ~= nil then
    non_table_prompt_spec = prompt_spec
    prompt_spec = {}
  else
    prompt_spec = {}
  end
  prompt_spec.prompt_args = prompt_spec.prompt_args or {}
  ptype = ptype or "string"
  local untransformer
  if ptype == "int" then
    prompt_spec = prompt_spec or {}
    prompt_spec.transformer = prompt_spec.transformer or get.string_or_number.int
  elseif ptype == "number" then
    prompt_spec.transformer = prompt_spec.transformer or get.string_or_number.number
  elseif ptype == "string" then
    if type(non_table_prompt_spec) == "string" then
      prompt_spec = { prompt_args = { message = non_table_prompt_spec } } -- prompt_spec shorthand when type is string: prompt_spec is the message
    end
  elseif ptype == "string-path" or ptype == "string-filepath" or ptype == "path" or ptype == "dir" then
    if type(non_table_prompt_spec) == "string" then
      prompt_spec = { prompt_args = { default = non_table_prompt_spec } } -- prompt_spec shorthand when type is string: prompt_spec is the default value
    end

    if ptype == "path" or ptype == "dir" then
      prompt_spec.prompt_args.default = prompt_spec.prompt_args.default or ""

      if ptype == "dir" then
        prompt_spec.prompt_args.can_choose_files = false
        prompt_spec.prompt_args.message = prompt_spec.prompt_args.message or "Choose a directory"
      end

      prompt_spec.prompter = promptPathInner
    elseif ptype == "string-path" then
      prompt_spec.transformed_validator = function(x)
        local res = (x ~= nil)
        if res then
          res = pcall(createPath, x, nil, "error")
        end
        return res
      end
    elseif ptype == "string-filepath" then
      prompt_spec.transformed_validator = function(x)
        local res = (x ~= nil)
        if res then
          res = pcall(writeFile, x, "", "not-exists", true, "w", "error")
        end
        return res
      end
    end
  elseif ptype == "pair" then
    if type(non_table_prompt_spec) == "string" then
      prompt_spec = { prompt_args = { message = non_table_prompt_spec } }
    end
    if prompt_spec.prompt_args.message then
      prompt_spec.prompt_args.message = "Add a new " .. prompt_spec.prompt_args.message .. " pair, separated by '-'"
    else
      prompt_spec.prompt_args.message = "Add a new pair, separated by '-'"
    end
    prompt_spec.transformer = function(x)
      local key, value = x:match("^(.-)-(.*)$")
      if key ~= nil and value ~= nil then
        ---@diagnostic disable-next-line: return-type-mismatch -- not sure why, but lua-language-server seems to have cast prompt_spec.transformer to `get.string_or_number.number` for some reason. Since lua-language-server is often a bit buggy, I'm just going to disable the warning for now.
        return { key, value }
      else
        ---@diagnostic disable-next-line: return-type-mismatch
        return nil
      end
    end
    untransformer = function(x)
      return x[1] .. "-" .. x[2]
    end
  end

  prompt_spec.prompt_args.message = prompt_spec.prompt_args.message or ("Enter a " .. ptype .. ":")

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
      local untransformed_if_necessary = x
      if untransformer then -- untransform the output if necessary, so that it can be used as the default for the next prompt, and so it can be compared to the previous input
        untransformed_if_necessary = untransformer(x)
      end
      if untransformed_if_necessary == prompt_spec.prompt_args.default then -- same as previous input, so we're done (default is a bit of a misnomer here, but it's the best I could come up with)
        return x -- return the transformed output
      else
        prompt_spec.prompt_args.default = untransformed_if_necessary
      end
    end
  else
    return promptNopolicy(prompt_spec)
  end
end

function promptPipeline(prompt_pipeline)
  local res
  local first_prompt_spec = prompt_pipeline[1][2]
  if type(first_prompt_spec) == "table" and first_prompt_spec.prompt_args then 
    res = first_prompt_spec.prompt_args.default
  else
    res = first_prompt_spec
  end
  for _, args in ipairs(prompt_pipeline) do
    local prompt_spec = args[2]
    local new_prompt_spec
    if type(prompt_spec) == "table" then
      new_prompt_spec = prompt_spec
    else
      new_prompt_spec = {}
    end
    new_prompt_spec.prompt_args = new_prompt_spec.prompt_args or {}
    new_prompt_spec.prompt_args.default = res
    res = prompt(args[1], new_prompt_spec, args[3])
  end
  return res
end