lemap = {
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
  transf.timestamp_s.period_alphanum_minus_underscore_by_german_date(transf["nil"].timestamp_s_by_current())
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
  transf.omegat_project_dir.creator_bank_details_str(d)
]}}
 

Mit freundlichen Grüßen,  
 
{{[ 
  transf.omegat_project_dir.creator_main_name(d)
]}}
    ]],
    rechnung_email = [[
      Guten Tag {{[transf.omegat_project_dir.client_main_name(d)]}},

anbei die Rechnung der Übersetzung{{[#transf.omegat_project_dir.target_file_char_amount_arr(d) > 1 and "en" or ""]}} vom {{[transf.omegat_project_dir.delivery_date(d)]}}.

{{[le(comp.snippets.email_footer_casual)]}}
    ]]
  }
}
