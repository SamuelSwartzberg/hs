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
    fill_template = transf.multiline_string.trimmed_lines_multiline_string([[Fill the following template
    
    {{[
      get.string_or_number_array.string_by_joined(get.array.array_by_mapped_w_t_arg_t_ret_fn(d.form_field_specifier_array, function (form_field_specifier)
        return form_field_specifier.value .. (form_field_specifier.explanation and " (" .. form_field_specifier.explanation .. ")" or "") .. ":"
      end), "\n")
    ]}}

    by extracting data from the following fields

    {{[
      get.string_or_number_array.string_by_joined(get.table.string_array_by_mapped_w_fmt_string(d.in_fields), "\n")
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
  },
  translation = {
    rechnung = [[
      {{[
  transf.omegat_project_dir.creator_main_relevant_address_label(d)
]}}
 
{{[
  transf.omegat_project_dir.client_main_relevant_address_label(d)
]}}
 

Steuernummer: {{[ 
  transf.omegat_project_dir.creator_translation_tax_number(d) 
]}}
Rechnungsnummer: {{[
  transf.omegat_project_dir.rechnung_id(d)
]}}
Liefertermin: {{[
  transf.omegat_project_dir.delivery_date(d)
]}} 
Rechnungstermin: {{[
  transf["nil"].date_by_current():fmt("%d.%m.%Y")
]}}
 

 

Guten Tag {{[
  transf.omegat_project_dir.client_main_name(d)
]}},
 
hiermit erlaube ich mir für die Übersetzung {{[
  #transf.omegat_project_dir.target_files(d) == 1 and "des Textes" or "der Texte"
]}} wie folgt abzurechnen:   

{{[
  transf.omegat_project_dir.translation_price_block_german(d)
]}}

Gemäß § 19 UStG wird keine Umsatzsteuer berechnet.  
 

Ich bitte um Überweisung auf das folgende Konto:  

{{[
  transf.omegat_project_dir.creator_bank_details_string(d)
]}}
 

Mit freundlichen Grüßen,  
 
{{[ 
  transf.omegat_project_dir.creator_main_name(d)
]}}
    ]],
    rechnung_email = [[
      Guten Tag {{[transf.omegat_project_dir.client_main_name(d)]}},

anbei die Rechnung der Übersetzung{{[#transf.omegat_project_dir.target_file_char_amount_array(d) > 1 and "en" or ""]}} vom {{[transf.omegat_project_dir.delivery_date(d)]}}.

{{[le(comp.snippets.email_footer_casual)]}}
    ]]
  }
}
