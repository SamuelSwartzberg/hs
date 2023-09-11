lemap = {
  rechnung =  {
    de = [[{{[
transf.client_project_dir.multiline_str_by_relevant_address_label_client(d)
]}}

{{[
transf.client_project_dir.multiline_str_by_relevant_address_label_creator(d)
]}}


Steuernummer: {{[ 
transf.client_project_dir.line_or_nil_by_tax_number(d) 
]}}
Rechnungsnummer: {{[
transf.client_project_dir.alphanum_minus_underscore_by_rechnung_id(d)
]}}
Liefertermin: {{[
transf.client_project_dir.rfc3339like_ymd_by_delivery_date(d)
]}} 
Rechnungstermin: {{[
transf["nil"].rfc3339like_ymd_by_current()
]}}




Guten Tag {{[
transf.client_project_dir.line_by_main_name_client(d)
]}},

hiermit erlaube ich mir für die {{transf.client_project_dir.line_by_kind_plaintext_name_de(d)}} wie folgt abzurechnen:   

{{[
transf.client_project_dir.multiline_str_by_price_block_german(d)
]}}

Gemäß § 19 UStG wird keine Umsatzsteuer berechnet.  


Ich bitte um Überweisung auf das folgende Konto:  

{{[
transf.client_project_dir.multiline_str_by_name_bank_details_creator(d)
]}}


Mit freundlichen Grüßen,  

{{[ 
transf.client_project_dir.line_by_main_name_creator(d)
]}}]],
  },
  
  rechnung_email =  {
    de = [[
Guten Tag {{[transf.client_project_dir.line_by_main_name_client(d)]}},

anbei die Rechnung der {{transf.client_project_dir.line_by_kind_plaintext_name_de(d)}} vom {{[transf.client_project_dir.delivery_date(d)]}}.

Viele Grüße,

{{[transf.client_project_dir.line_by_main_name_creator(d)]}}]]
  }
}
