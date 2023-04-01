lemap = {
  gpt = {
    text_interpolation_explanation = [[The syntax for text interpolation is `{{[some content]}}`, where the content can be a lua expression or lua statement. The interpolations have access to a featureful global environment. Any parameters you want to pass will be available on the `d` table.]],
    text_interpolation_generation_request = [[I would like to generate an interpolated string for asking a LLM to {{[d.topic]}}, taking a variety of suitable parameters. {{[lemap.gpt.text_interpolation_generation_request]}}. For example, if I wanted an interpolated string for "generating dummy text", a good output would be`.]],
    dummy_text = [[Please generate a {{[d.format or "list"]}} of {{[d.amount or "10"]}} {{[d.unit or "words"]}} in {{[d.language or "English"]}} about {{[d.topic or "Vegetables"]}}, using {{d.language_specfics or "casual English"}}. Please format the output as {{[d.out_syntax or "markdown"]}}.]],
    email_response = [[I, Sam, would like to write a response to an email. To that end, when I send you an email text, you ask me for the gist of what I want to respond with, and then you generate a response for me. If subsequently I request any edits, I would like you to implement them and output the new response. Please always generate the response in the same language and style as I have displayed in any of my emails in the chain. Here is the email I would like you to respond to:
    
    ---
    {{[d.email_text]}}
    ---
    
    Please ask me for the gist of what I want to respond with once you are ready.]],
    text_first_draft = [[The following is the first draft of {{[d.text_purpose]}}. However, it's still a bit {{[d.problem or "wordy and awkward in places"]}}. Please edit it for {{[d.change or "style and clarity"]}}. Feel free to change stuff around a bit.]],
    fill_template = transf.multiline_string.trimmed_lines([[Fill the following template
    
    {{[
      table.concat(map(d.out_fields, function (field)
        return field.value .. (field.explanation and " (" .. field.explanation .. ")" or "") .. ":"
      end), "\n")
    ]}}

    by extracting data from the following fields

    {{[
      table.concat(map(d.in_fields, {_f= "%s: %s"}, { args = "kv", ret = "v", tolist = true }), "\n")
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
