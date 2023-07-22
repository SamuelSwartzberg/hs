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
end