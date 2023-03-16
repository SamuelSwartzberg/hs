--- @alias out_field  {value: string, alias?: string, explanation?: string}

--- @param opts { in_fields: {[string]: string}, out_fields: out_field[] }
--- @param do_after fun(result: {[string]: string}): nil
function fillTemplateFromFieldsWithAI(opts, do_after)
  gpt(le(lemap.gpt.fill_template, opts), function (result)
    local out_fields = map(
      opts.out_fields,
      function (field, value)
        return 
          value.alias or value.value, 
          string.match(result, value.value .. "[^\n]-: *(.-)\n") or string.match(result, value.value .. "[^\n]-: *(.-)$")
      end,
      "kv"
    )
    do_after(out_fields)
  end, { temperature = 0})
end

