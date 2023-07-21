function prompt(ptype, prompt_spec, loop)
  local non_table_prompt_spec
  if type(prompt_spec) == "table" then
    prompt_spec = get.table.copy(prompt_spec)
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
  elseif ptype == "path" or ptype == "dir" then
    if type(non_table_prompt_spec) == "string" then
      prompt_spec = { prompt_args = { default = non_table_prompt_spec } } -- prompt_spec shorthand when type is string: prompt_spec is the default value
    end

    if ptype == "path" or ptype == "dir" then
      prompt_spec.prompt_args.default = prompt_spec.prompt_args.default or ""

      if ptype == "dir" then
        prompt_spec.prompt_args.can_choose_files = false
        prompt_spec.prompt_args.message = prompt_spec.prompt_args.message or "Choose a directory"
      end

      prompt_spec.prompter = transf.prompt_args_path.local_absolute_path_or_local_absolute_path_array_and_boolean
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
      local x = transf.prompt_spec.any(prompt_spec)
      if x == nil then
        return res
      else
        table.insert(res, x)
      end
    end
  elseif loop == "pipeline" then
    while true do
      local x = transf.prompt_spec.any(prompt_spec)
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
    return transf.prompt_spec.any(prompt_spec)
  end
end


--- The `promptPipeline` function is used to manage a series of prompts to the user, feeding the result of each prompt into the next. 
--- It accepts an array where each element is another array containing three elements: 
--- - a string representing the type of the prompt, 
--- - a table of parameters for the prompt function,
--- - a string representing the loop type.
--- The function will return the result of the last prompt in the pipeline.
--- @param prompt_pipeline any[][] -- array of { ptype, prompt_spec, loop } tuples
function promptPipeline(prompt_pipeline)
  local res
  local first_prompt_spec = prompt_pipeline[1][2]
  if type(first_prompt_spec) == "table" and first_prompt_spec.prompt_args then 
    res = first_prompt_spec.prompt_args.default
  else
    res = first_prompt_spec
  end
  for _, args in transf.array.index_value_stateless_iter(prompt_pipeline) do
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