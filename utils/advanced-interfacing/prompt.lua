function prompt(ptype, prompt_spec, loop)
  if ptype == "int" then
    prompt_spec = prompt_spec or {}
    prompt_spec.transformer = prompt_spec.transformer or get.string_or_number.int
  elseif ptype == "number" then
    prompt_spec.transformer = prompt_spec.transformer or get.string_or_number.number
  elseif ptype == "string" then
    if type(non_table_prompt_spec) == "string" then
      prompt_spec = { prompt_args = { message = non_table_prompt_spec } } -- prompt_spec shorthand when type is string: prompt_spec is the message
    end
end