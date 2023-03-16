lemap = {
  gpt = {
    text_interpolation_explanation = [[The syntax for text interpolation is `{{[some content]}}`, where the content can be a lua expression or lua statement. The interpolations have access to a featureful global environment. Any parameters you want to pass will be available on the `d` table.]],
    text_interpolation_generation_request = [[I would like to generate an interpolated string for asking a LLM to {{[d.topic]}}, taking a variety of suitable parameters. {{[lemap.gpt.text_interpolation_generation_request]}}. For example, if I wanted an interpolated string for "generating dummy text", a good output would be`.]],
    dummy_text = [[Please generate a {{[d.format or "list"]}} of {{[d.amount or "10"]}} {{[d.unit or "words"]}} in {{[d.language or "English"]}} about {{[d.topic or "Vegetables"]}}, using {{d.language_specfics or "casual English"}}. Please format the output as {{[d.out_syntax or "markdown"]}}.]],
    fill_template = transf.multiline_string.trimmed_lines([[Fill the following template
    
    {{[
      table.concat(map(d.out_fields, function (field)
        return field.value .. (field.explanation and " (" .. field.explanation .. ")" or "") .. ":"
      end), "\n")
    ]}}

    by extracting data from the following fields

    {{[
      table.concat(map(d.in_fields, "%s: %s", { args = "kv", ret = "v", tolist = true }), "\n")
    ]}}

    If there seems to be no data for a field, just leave it blank.

    ]]),
    code_coverage = [[I have a function with the signature:

```lua
{{[d.signature]}}
```
I would like to know if there any parameters that are not being tested, or for which possible types of values are not being tested? That is, is the test coverage for this function complete?

The tests so far:
  
```lua
{{[d.tests]}}
```
]]
  }
}
