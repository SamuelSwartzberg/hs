--- @alias out_field  {value: string, alias?: string, explanation?: string}

--- @param opts { in_fields: {[string]: string}, out_fields: out_field[] }
--- @param do_after fun(result: {[string]: string}): nil
function fillTemplateFromFieldsWithAI(opts, do_after)
  local ai_request_str = "Fill the following template\n\n"
  for _, field in ipairs(opts.out_fields) do
    ai_request_str = ai_request_str .. field.value
    if field.explanation then
      ai_request_str = ai_request_str .. " (" .. field.explanation .. ")"
    end
    ai_request_str = ai_request_str .. ":\n"
  end
  ai_request_str = ai_request_str .. "\nby extracting the data from the following fields\n\n"
  for field, value in pairs(opts.in_fields) do
    ai_request_str = ai_request_str .. field .. ": " .. value .. "\n"
  end
  ai_request_str = ai_request_str .. "\nIf there seems to be no data for a field, just leave it blank.\n\n"

  gpt(ai_request_str, function (result)
    local out_fields = {}
    for _, field in ipairs(opts.out_fields) do
      local field_value = string.match(result, field.value .. "[^\n]-: *(.-)\n") or string.match(result, field.value .. "[^\n]-: *(.-)$")
      if field_value then
        out_fields[field.alias or field.value] = field_value
      end
    end
    do_after(out_fields)
  end, { temperature = 0})
end

