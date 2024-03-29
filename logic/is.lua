is = {
  str = {

    -- simple conditions

    empty_str = function(str)
      return str == ""
    end,
    not_empty_str = function(str)
      return not is.str.empty_str(str)
    end,
    not_starting_with_whitespace_str = function(str)
      return get.str.bool_by_matches_part_eutf8(str, "^%s")
    end,
    not_ending_with_whitespace_str = function(str)
      return get.str.bool_by_matches_part_eutf8(str, "%s$")
    end,
    not_starting_o_ending_with_whitespace_str = function(str)
      return is.str.not_starting_with_whitespace_str(str) and is.str.not_ending_with_whitespace_str(str)
    end,
    ascii_str = function(str)
      return get.str.bool_by_matches_whole_onig_w_regex_character_class_innards(str, r.g.ascii_char)
    end,
    line = function(str)
      return get.str.bool_by_not_matches_part_eutf8(str, "[\n\r]")
    end,
    json_str = transf["nil"]["true"], -- figuring this out would require parsing the json, which is too expensive here
    yaml_str = transf["nil"]["true"], -- same as above
    toml_str = transf["nil"]["true"], -- same as above
    ini_str = transf["nil"]["true"], -- same as above
    bib_str = transf["nil"]["true"], -- same as above
    mime_part_block = transf["nil"]["true"], -- currently don't know enough about this seemingly custom format to check for it
    email_or_displayname_email = function(str)
      return is.str.email(str) or is.str.displayname_email(str)
    end,
    content_starting_lt_ending_gt_str = function(str)
      local cnt = transf.str.not_starting_o_ending_with_whitespace_str(str)
      return get.str.bool_by_startswith(cnt, "<") and get.str.bool_by_endswith(cnt, ">")
    end,

  },
  content_starting_lt_ending_gt_str = {
    doctype_starting_str = function(str)
      return get.str.bool_by_matches_part_eutf8(str, "^%s*<!DOCTYPE")
    end,
    xml_declaration_starting_str = function(str)
      return get.str.bool_by_matches_part_eutf8(str, "^%s*<%?xml")
    end,
    html_starting_str = function(str)
      return get.str.bool_by_matches_part_eutf8(str, "^%s*<html")
    end,
    sgml_document = function(str)
      return is.content_starting_lt_ending_gt_str.doctype_starting_str(str) or is.content_starting_lt_ending_gt_str.xml_declaration_starting_str(str) or is.content_starting_lt_ending_gt_str.html_starting_str(str)
    end,

  },
  not_empty_str = {
    utf8_char = function(str)
      return transf.str.pos_int_by_len_utf8_chars(str) == 1
    end,
    multiline_str = function(str)
      return get.str.bool_by_matches_part_eutf8(str, "[\n\r]")
    end,
    whitespace_str = function(str)
      return get.str.bool_by_matches_part_eutf8(str, "%s")
    end,
    starting_with_dot_str = function(str)
      return get.str.bool_by_startswith(str, ".")
    end,
     input_spec_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.input_spec_str) -- we're calling onig on a str which we are not sure is ascii. I'm not sure how problematic this is, since I've forgotten whether onig just doesn't implement any specific behavior for non-ascii chars, or if actually sees them as the ascii chars the utf8 corresponds to. Either way, worst comes the worst it'd result in a few false positives, which is fine.
    end,
    input_spec_series_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, " *(?:" .. r.g.input_spec_str .. ")(?: *\\n *(?:" .. r.g.input_spec_str .. "))* *")
    end
    
    
  },
  multiline_str = {
    here_doc = function(str)
      return get.str.bool_by_startswith(str, "<<EOF") and get.str.bool_by_endswith(str, "EOF") -- technically obviously it doesn't have to be EOF, but I'm only ever gonna use EOF
    end,
    script_str = function(str)
      return get.str.bool_by_startswith(str, "#!")
    end,
    raw_contact = transf["nil"]["true"],
    hydrus_relationship_block = transf["nil"]["true"],
    ini_section_contents_str = function(str)
      return get.arr.bool_by_all_pass_w_fn(
        transf.str.noempty_line_arr(str),
        is.line.ini_section_line
      )
    end,
    decoded_email_header_block = function(str)
      return get.arr.bool_by_all_pass_w_fn(
        transf.str.line_arr(str),
        is.line.decoded_email_header_line
      )
    end,
    decoded_email = function(str)
      local header, body = get.str.n_strs_by_split_w_str(str, "\n\n", 2)
      if not body then
        return false
      end
      return is.multiline_str.decoded_email_header_block(header)
    end
  },
  script_str = {
    shell_script_str = function(str)
      return get.str.bool_by_matches_part_onig(str, r.g.shell_shebang)
    end,
  },
  shell_script_str = {
    envlike_str = function(str)
      return get.str.bool_by_contains_w_str(str, "export ")
    end,
  },
  whitespace_str = {
    starting_with_whitespace_str = function(str)
      return get.str.bool_by_matches_part_eutf8(str, "^%s")
    end,
    ending_with_whitespace_str = function(str)
      return get.str.bool_by_matches_part_eutf8(str, "%s$")
    end,
    starting_o_ending_with_whitespace_str = function(str)
      return is.whitespace_str.starting_with_whitespace_str(str) or is.whitespace_str.ending_with_whitespace_str(str)
    end,
    starting_a_ending_with_whitespace_str = function(str)
      return is.whitespace_str.starting_with_whitespace_str(str) and is.whitespace_str.ending_with_whitespace_str(str)
    end,
    envlike_mapping = function(str)
      return get.str.bool_by_matches_part_eutf8(str, "^%s*export%s+%w+=\\")
    end,
  },
  line = {
    not_whitespace_str = function(str)
      return not is.not_empty_str.whitespace_str(str)
    end,

    indent_line = function(str)
      return is.str.starting_with_whitespace_str(str)
    end,
    noindent_line = function(str)
      return is.str.not_starting_with_whitespace_str(str)
    end,
    hashcomment_line = function(str)
      return get.str.bool_by_matches_part_eutf8(str, "^%s*#")
    end,
    nohashcomment_line = function(str)
      return not is.line.hashcomment_line(str)
    end,
    semicoloncomment_line = function(str)
      return get.str.bool_by_matches_part_eutf8(str, "^%s*;")
    end,
    nosemicoloncomment_line = function(str)
      return not is.line.semicoloncomment_line(str)
    end,
    trailing_whitespace_line = function(str)
      return is.str.ending_with_whitespace_str(str)
    end,
    notrailing_whitespace_line = function(str)
      return is.str.not_ending_with_whitespace_str(str)
    end,
    noempty_line = function(str)
      return is.str.not_empty_str(str)
    end,
    noweirdwhitespace_line = function(str)
      return get.str.bool_by_not_matches_part_eutf8(str, "[\t\v\f]")
    end,
    decoded_email_header_line = function(str)
      return get.str.bool_by_contains_w_str(str, ": ")
    end,

    -- combined conditions

    noempty_nohashcomment_line = function(str)
      return is.line.noempty_line(str) and is.line.nohashcomment_line(str)
    end,
    noempty_noindent_line = function(str)
      return is.line.noempty_line(str) and is.line.noindent_line(str)
    end,
    
    trimmed_line = function(str)
      return is.line.noindent_line(str) and is.line.notrailing_whitespace_line(str)
    end,
    ini_section_line = function(str)
      return is.line.semicoloncomment_line(str) or is.line.ini_kv_line(str)
    end,
    noempty_trimmed_line = function(str)
      return is.line.noempty_line(str) and is.line.trimmed_line(str)
    end,

  },
  noempty_line = {
    ini_kv_line = function(str)
      return get.str.bool_by_not_startswith(str, "=") and get.str.bool_by_not_endswith(str, "=") and get.str.bool_by_contains_w_str(str, "=")
    end,
    country_identifier_str = transf["nil"]["true"],
    language_identifier_str = transf["nil"]["true"],
    multirecord_str = function(str)
      return get.str.bool_by_contains_w_str(str, consts.printable_ascii_not_whitespace_str_by_unique_record_separator)
    end,
    record_str = function(str)
      return get.str.bool_by_contains_w_str(str, consts.printable_ascii_not_whitespace_str_by_unique_field_separator)
    end,
  },
  noempty_noindent_line = {
    noempty_noindent_hashcomment_line = function(str)
      return is.line.hashcomment_line(str)
    end,
    noempty_noindent_nohashcomment_line = function(str)
      return is.line.noempty_nohashcomment_line(str) and is.line.noindent_line(str)
    end,
  },
  noweirdwhitespace_line = {
    mod_symbol = function(str)
      return get.arr.bool_by_contains(ls.mod_symbol_arr, str)
    end,
    path_component = function(str)
      return str == "/" or get.str.bool_by_not_contains_w_ascii_str(str, "/") 
    end,
    trimmed_noweirdwhitespace_line = function(str)
      return is.line.trimmed_line(str)
    end,
  },
  path_component = {
    leaflike = function(str)
      return str ~= "/"
    end,
  },
  leaflike = {
    extension = function(str)
      return get.str.bool_by_not_contains_w_ascii_str(str, ".") -- I consider e.g. .tar.gz files to have an extension of 'gz'
    end,
    citable_filename = function(str)
      return 
        get.str.bool_by_contains_w_str(str, "!citid:")
    end,
    name_of_useless_file = function(str)
      return get.arr.bool_by_contains(ls.name_of_useless_file_arr, str)
    end,
  },
  extension = {
    bin_extension = function(str)
      return get.arr.bool_by_contains(ls.bin_extension_arr, str)
    end,
    plaintext_extension = function(str)
      return not is.extension.bin_extension(str)
    end,
    image_extension = function(str)
      return get.arr.bool_by_contains(ls.image_extension_arr, str)
    end,
    hydrusable_extension = function(str)
      return get.arr.bool_by_contains(ls.hydrusable_extension_arr, str)
    end,
  },
  bin_extension = {
    db_extension = function(str)
      return get.arr.bool_by_contains(ls.db_extension_arr, str)
    end,
    playable_extension = function(str)
      return get.arr.bool_by_contains(ls.audio_extension_arr, str) or get.arr.bool_by_contains(ls.video_extension_arr, str)
    end,
  },
  playable_extension = {
    audio_extension = function(str)
      return get.arr.bool_by_contains(ls.audio_extension_arr, str)
    end,
    video_extension = function(str)
      return get.arr.bool_by_contains(ls.video_extension_arr, str)
    end,
    whisper_extension = function(str)
      return get.arr.bool_by_contains(ls.whisper_extension_arr, str)
    end,
  },
  db_extension = {
    sql_extension = function(str)
      return get.arr.bool_by_contains(ls.sql_extension_arr, str)
    end,
  },

  sql_extension = {
    sqlite_extension = function(str)
      return get.arr.bool_by_contains(ls.sqlite_extension_arr, str)
    end,
  },
  plaintext_extension = {
    plaintext_table_extension = function(str)
      return get.arr.bool_by_contains(ls.plaintext_table_extension_arr, str)
    end,
    plaintext_assoc_extension = function(str)
      return get.arr.bool_by_contains(ls.plaintext_assoc_extension_arr, str)
    end,
  },
  trimmed_line = {
    displayname_email = function(str)
      return get.str.bool_by_matches_whole_eutf8(str, ".- <.-@.+>")
    end,
   
  },
  trimmed_noweirdwhitespace_line = {
    path = function(str)
      return get.str.bool_by_contains_w_str(str, "/")
    end
  },

  ascii_str = {
    printable_ascii_str = function(str)
      return get.str.bool_by_matches_whole_onig_w_regex_character_class_innards(str, r.g.printable_ascii_char)
    end,
    ascii_char = function(str)
      return #str == 1
    end,
  },
  ascii_char = {
    
    lua_escapable_ascii_char = function(str)
      return get.arr.bool_by_contains(ls.lua_escapable_ascii_char_arr, str)
    end,

  },
  printable_ascii_str = {
    printable_ascii_line = function(str)
      return get.str.bool_by_not_matches_part_onig_w_regex_character_class_innards(str, "\r\n")
    end,
    printable_ascii_char = function(str)
      return #str == 1
    end,
    printable_ascii_multiline_str = function(str)
      return not is.printable_ascii_str.printable_ascii_line(str)
    end,
  },
  printable_ascii_char = {
    base_letter = function(str)
      return get.arr.bool_by_contains(ls.base_letter_arr, str)
    end,
    rfc3339like_dt_separator = function(str)
      return get.arr.bool_by_contains(ls.rfc3339like_dt_separator_arr, str)
    end,
    mouse_button_char = function(str)
      return get.arr.bool_by_contains(ls.mouse_button_char_arr, str)
    end,
    lua_regex_metacharacter = function(str)
      return get.arr.bool_by_contains(ls.lua_regex_metacharacter_arr, str)
    end,
    general_regex_metacharacter = function(str)
      return get.arr.bool_by_contains(ls.general_regex_metacharacter_arr, str)
    end,
  },
  printable_ascii_multiline_str = {
    email_header_block = function(str)
      return get.arr.bool_by_all_pass_w_fn(
        transf.str.line_arr(str),
        is.printable_ascii_line.email_header_line
      )
    end,
    raw_email = function(str)
      local header, body = get.str.n_strs_by_split_w_str(str, "\n\n", 2) -- todo: I'm not quite sure what implicit processing my emails may go through, but they might have \r\n, so if the tests fail, that might be why
      if not body then
        return false
      end
      return is.printable_ascii_multiline_str.email_header_block(header)
    end,
  },
  printable_ascii_line = {
    printable_ascii_no_vertical_space_str = function(str)
      return get.str.bool_by_not_matches_part_onig_w_regex_character_class_innards(str, "\v\f")
    end,
  },
  printable_ascii_no_vertical_space_str = {
    printable_ascii_no_nonspace_whitespace_str = function(str)
      return get.str.bool_by_not_contains_w_ascii_str(str, "\t")
    end,
    email_header_kv_line = function(str)
      return get.str.bool_by_contains_w_str(str, ": ")
    end,
    indent_ascii_line = function(str)
      return get.str.bool_by_startswith(str, " ") or get.str.bool_by_startswith(str, "\t")
    end,
    email_header_line = function(str)
      return is.printable_ascii_no_nonspace_whitespace_str.email_header_kv_line(str) or is.printable_ascii_no_nonspace_whitespace_str.indent_ascii_line(str)
    end,
    iban = function(str)
      local cleaned_iban = transf.iban.cleaned_iban(str)
      return #cleaned_iban <= 34 and is.printable_ascii_str.alphanum(cleaned_iban)
    end,
    shell_shebang = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.shell_shebang)
    end,
  },
  printable_ascii_no_nonspace_whitespace_str = {
    fnname = transf["nil"]["true"],
    single_attachment_str = function(str)
      return 
        get.str.bool_by_startswith(str, "#") 
        and get.str.bool_by_matches_part_onig(str, "^#" .. r.g.media_type .. " ")
    end,
    printable_ascii_not_whitespace_str = function(str)
      return get.str.bool_by_not_matches_part_eutf8(str, "%s")
    end,
    indicated_page_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, "pp?\\. *\\d+")
    end,
    
    application_name = transf["nil"]["true"], -- no way to tell if a str is an application name of some application
    separated_nonindicated_number_str = function(str)
      return is.printable_ascii_not_whitespace_str.nonindicated_number_str(
        transf.str.not_whitespace_str(str)
      )
    end,
    url_or_local_path = function(str)
      return is.printable_ascii_no_nonspace_whitespace_str.url(str) or is.printable_ascii_no_nonspace_whitespace_str.local_path(str)
    end,
    phone_number = function(str)
      return #str <= 25 and get.str.bool_by_matches_part_onig(str, "\\d{2}") -- will have many false positives, but that's fine
    end,
    alphanum_minus_underscore_space_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, "[a-zA-Z0-9 _-]+")
    end,
  },
  alphanum_minus_underscore_space_str =  {
    alphanum_space_str = function(str)
      return get.str.bool_by_not_contains_w_str_arr(str, {"_", "-"})
    end,
  },
  alphanum_space_str = {
    vcard_addr_key = function(str)
      return get.arr.bool_by_contains(ls.vcard_addr_key_arr, str)
    end,
  },
  separated_nonindicated_number_str = {
    separated_nonindicated_bin_number_str = function(str)
      return is.printable_ascii_not_whitespace_str.nonindicated_bin_number_str(
        transf.str.not_whitespace_str(str)
      )
    end,
    separated_nonindicated_oct_number_str = function(str)
      return is.printable_ascii_not_whitespace_str.nonindicated_oct_number_str(
        transf.str.not_whitespace_str(str)
      )
    end,
    separated_nonindicated_dec_number_str = function(str)
      return is.printable_ascii_not_whitespace_str.nonindicated_dec_number_str(
        transf.str.not_whitespace_str(str)
      )
    end,
    separated_nonindicated_hex_number_str = function(str)
      return is.printable_ascii_not_whitespace_str.nonindicated_hex_number_str(
        transf.str.not_whitespace_str(str)
      )
    end,
  },
  application_name = {
    mac_application_name = function(str)
      return get.arr.bool_by_contains(
        transf["nil"].mac_application_name_arr(),
        str
      )
    end,
  },
  printable_ascii_not_whitespace_str = {
    html_entity = function(str)
      return #str > 20 and get.str.bool_by_startswith(str, "&") and get.str.bool_by_endswith(str, ";") and get.str.bool_by_matches_whole_onig(str, r.g.html_entity) -- the earlier checks are technically unncessary but improve performance
    end,
    startswith_percent_printable_ascii_not_whitespace = function(str)
      return get.str.bool_by_startswith(str, "%")
    end,
    startswith_at_printable_ascii_not_whitespace = function(str)
      return get.str.bool_by_startswith(str, "%")
    end,
    package_name = transf["nil"]["true"], -- no way to tell if a str is a package name of some package
    package_name_package_manager_name_compound_str = function(str)
      return get.str.pos_int_by_amount_contained_nooverlap(str, ":") == 1 and get.str.bool_by_not_contains_w_ascii_str(str, "@")
    end,
    package_name_semver_compound_str = function(str)
      return get.str.pos_int_by_amount_contained_nooverlap(str, "@") == 1 and get.str.bool_by_not_contains_w_ascii_str(str, ":")
    end,
    package_name_semver_package_manager_name_compound_str = function(str)
      return get.str.pos_int_by_amount_contained_nooverlap(str, "@") == 1 and get.str.pos_int_by_amount_contained_nooverlap(str, ":") == 1
    end,
    urlcharset_str = function(str)
      return get.str.bool_by_matches_whole_onig_inverted_w_regex_character_class_innards(str, "\"<>`\\|\\\\^{}")
    end,
    
  },
  startswith_percent_printable_ascii_not_whitespace = {
    dt_format_part = function(str)
      return #str == 2 
    end,
    rfc3339like_dt_str_format_part = function(str)
      return get.arr.bool_by_contains(ls.rfc3339like_dt_str_format_part_arr, str)
    end,
    rfc3339like_dt_format_str = function(str)
      return get.str.bool_by_contains(ls.rfclike_dt_format_str_arr, str)
    end,
  },
  dt_format_part = {
    rfc3339like_dt_format_part = function(str)
      return get.arr.bool_by_contains(ls.rfc3339like_dt_format_part_arr, str)
    end,
  },
  startswith_at_printable_ascii_not_whitespace = {
    handle = transf["nil"]["true"],

  },
  urlcharset_str = {
    cronspec_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.cronspec_str)
    end,
    fs_tag_kv = function(str)
      return get.str.bool_by_matches_whole_onig(str, "[a-z0-9]+-[a-z0-9,]+")
    end,
    url = function(str)
      return get.fn.rt_by_memoized(
        transf.str.bool_by_evaled_env_bash_success,
      )(
        "url_parser_cli " .. transf.str.str_by_single_quoted_escaped(str)
      )
    end,
    query_k_o_v = function(str)
      return get.str.bool_by_not_contains_w_str_arr(str, {"=", "&"})
    end,
    query_mapping = function(str)
      return get.str.bool_by_contains_w_str(str, "=") and get.str.bool_by_not_contains_w_ascii_str(str, "&")
    end,
    query_str = function(str)
      return get.str.bool_by_contains_w_str(str, "=")
    end,
    urllike_with_no_scheme = function(str)
      return is.urlcharset_str.url("https://" .. str)
    end,
    percent_encoded_octet = function(str)
      return #str == 3 and get.str.bool_by_startswith(str, "%") and is.printable_ascii_not_whitespace_str.nonindicated_number_str(str:sub(2, 3))
    end,
    bracketed_ipv6 = function(str)
      return get.str.bool_by_startswith(str, "[") and get.str.bool_by_endswith(str, "]") and is.printable_ascii_not_whitespace_str.ipv6(str:sub(2, -2))
    end,
    host = function(str)
      return is.printable_ascii_not_whitespace_str.domain_name(str) or is.printable_ascii_not_whitespace_str.ip(str)
    end,
    ip_host = function(str)
      return is.printable_ascii_not_whitespace_str.ipv4(str) or is.printable_ascii_not_whitespace_str.ipv6(str)
    end,
    fs_tag_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.fs_tag_str)
    end,
    media_type = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.media_type)
    end,
    base64_gen_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.base64_gen_str)
    end,
    base64_url_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.base64_url_str)
    end,
    base64_str = function(str)
      return is.printable_ascii_not_whitespace_str.base64_gen_str(str) or is.printable_ascii_not_whitespace_str.base64_url_str(str)
    end,
    --- trying to determine what str is and is not an email is a notoriously thorny problem. In our case, we don't care much about false positives, but want to avoid false negatives to a certain extent.
    email = function(str)
      return 
        get.str.bool_by_contains_w_str(str, "@") and
        get.str.bool_by_contains_w_str(str, ".")
    end,
    dice_notation = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.dice_notation)
    end,
    doi = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.doi)
    end,
    lower_alphanum_underscore_comma = function(str)
      return get.str.bool_by_matches_whole_onig_w_regex_character_class_innards(str, "a-z0-9_,")
    end,
    pcp_alphanum_minus_underscore = function(str)
      return get.str.bool_by_not_matches_part_eutf8(str, "[^%w%-_:\\+.]")
    end,
    semver_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.semver_str)
    end,
    indicated_isbn = function(str)
      return get.str.bool_by_startswith(str, "isbn:") -- gonna trust that if it's printable_ascii_not_whitespace_str and starts with isbn: it's an isbn, similarly for the following
    end,
    indicated_pmid = function(str)
      return get.str.bool_by_startswith(str, "pmid:")
    end,
    indicated_doi = function(str)
      return get.str.bool_by_startswith(str, "doi:")
    end,
    indicated_isbn_part = function(str)
      return get.str.bool_by_startswith(str, "isbn_part:")
    end,
    indicated_pcmid = function(str)
      return get.str.bool_by_startswith(str, "pmcid:")
    end,
    indicated_accession = function(str)
      return get.str.bool_by_startswith(str, "accession:")
    end,
    indicated_issn_full = function(str)
      return get.str.bool_by_startswith(str, "issn_full:")
    end,
    indicated_urlmd5 = function(str)
      return get.str.bool_by_startswith(str, "urlmd5:")
    end,
    indicated_citable_object_id = function(str)
      return
        is.printable_ascii_not_whitespace_str.indicated_isbn(str) or
        is.printable_ascii_not_whitespace_str.indicated_pmid(str) or
        is.printable_ascii_not_whitespace_str.indicated_doi(str) or
        is.printable_ascii_not_whitespace_str.indicated_isbn_part(str) or
        is.printable_ascii_not_whitespace_str.indicated_pcmid(str) or
        is.printable_ascii_not_whitespace_str.indicated_accession(str) or
        is.printable_ascii_not_whitespace_str.indicated_issn_full(str) or
        is.printable_ascii_not_whitespace_str.indicated_urlmd5(str)
    end,
  },
  urllike_with_no_scheme = {
    owner_item_urllike = function(str)
      return is.url.owner_item_url("https://" .. str)
    end,
  },
  indicated_citable_object_id = {
    filename_safe_indicated_citable_object_id = function(str)
      return transf.str.urlcharset_str_by_encoded_query_param_part(str) == str
    end,
  },
  package_name = {
    installed_package_name = function(str)
      return get.arr.bool_by_contains(transf.package_manager_name_or_nil.package_name_arr(nil), str)
    end,
  },
  base64_gen_str = {
    unicode_codepoint_str = function(str)
      return get.str.bool_by_startswith(str, "U+") and transf.str.bool_by_matches_whole_eutf8(str, "^U+%x+$")
    end,
    my_slash_date = function(str)
      return get.str.bool_by_matches_whole_onig(str, "\\d{2}/\\d{2}")
    end,
  },
  base64_url_str = {
    youtube_video_id = function(str)
      return #str == 11 -- not officially specified, but b/c 64^11 > 2^64 > 64^10 and 64 chars in base64, allowing for billions of ids per living person, unlikely to change
    end,
    youtube_playlist_id = function(str)
      return get.str.bool_by_startswith(str, "PL") and #str == 34
    end,
    youtube_channel_id = function(str)
      return get.str.bool_by_startswith(str, "UC") and #str == 24
    end,
  },
  pcp_alphanum_minus_underscore = {
    api_request_kv_location = function(str)
      return get.arr.bool_by_contains(ls.api_request_kv_location_arr, str)
    end,
    url_scheme = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.url_scheme)
    end,
    colon_period_alphanum_minus_underscore = function(str)
      return get.str.bool_by_not_contains_w_str(str, "+")
    end,
  },
  colon_period_alphanum_minus_underscore = {
    colon_alphanum_minus_underscore = function(str)
      return get.str.bool_by_not_contains_w_str(str, ".")
    end,
    period_alphanum_minus_underscore = function(str)
      return get.str.bool_by_not_contains_w_str(str, ":")
    end,
    indicated_utf8_hex_str = function(str)
      return get.str.bool_by_startswith(str, "utf8:") -- we're gonna trust that everything after is a valid hex str
    end,
    rfc3339like_dt_o_interval = function(str)
      return get.str.bool_by_matches_part_onig(str, "^" .. r.g.rfc3339like_dt)
    end,
  },
  rfc3339like_dt_o_interval = {
    rfc3339like_interval = function(str)
      return get.string.bool_by_contains(str, "_to_")
    end,
    rfc3339like_dt = function(str)
      return not is.rfc3339like_dt_o_interval.rfc3339like_interval(str)
    end,
  },
  rfc3339like_dt = {
    full_rfc3339like_dt = function(str)
      return #str >= 19 -- full for me is at least date and time, but not necessarily timezone or fractional seconds
    end,
    rfc3339like_y = function(str)
      return get.str.bool_by_matches_whole_onig(str, "\\d{4}")
    end,
    rfc3339like_ym = function(str)
      return get.str.bool_by_matches_whole_onig(str, "\\d{4}-\\d{2}")
    end,
    rfc3339like_ymd = function(str)
      return get.str.bool_by_matches_whole_onig(str, "\\d{4}-\\d{2}-\\d{2}")
    end,
  },
  period_alphanum_minus_underscore = {
    period_alphanum_minus = function(str)
      return get.str.bool_by_not_contains_w_str(str, "_")
    end,
  },
  period_alphanum_minus = {
    nonindicated_number_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, "-?[0-9a-fA-F]+(:?\\.[0-9a-fA-F]+)?")
    end,
    indicated_number_str = function(str)
      return get.str.bool_by_matches_whole_onig(
        str,
        "-?0[boxd][0-9a-fA-F]+(:?\\.[0-9a-fA-F]+)?"
      )
    end,
    domain_name = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.domain_name)
    end,
    ipv4_address = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.ipv4_address)
    end,
  },
  domain_name = {
    source_id = function(str)
      return get.str.bool_by_startswith(str, "com.apple.inputmethod") or get.str.bool_by_startswith(str, "com.apple.keylayout")
    end,
    bundle_id = transf["nil"]["true"] -- any (reverse) domain name can be a bundle id
  },
  indicated_number_str = {
    indicated_bin_number_str = function(str)
      return get.str.bool_by_startswith(str, "0b") or get.str.bool_by_startswith(str, "-0b")
    end,
    indicated_hex_number_str = function(str)
      return get.str.bool_by_startswith(str, "0x") or get.str.bool_by_startswith(str, "-0x")
    end,
    indicated_oct_number_str = function(str)
      return get.str.bool_by_startswith(str, "0o") or get.str.bool_by_startswith(str, "-0o")
    end,
    indicated_dec_number_str = function(str)
      return get.str.bool_by_startswith(str, "0d") or get.str.bool_by_startswith(str, "-0d")
    end,
  },
  nonindicated_number_str = {
    nonindicated_bin_number_str = function(str)
      return get.str.bool_by_matches_whole_onig_w_regex_character_class_innards(str, "-01\\.")
    end,
    nonindicated_oct_number_str = function(str)
      return get.str.bool_by_matches_whole_onig_w_regex_character_class_innards(str, "-0-7\\.")
    end,
    nonindicated_dec_number_str = function(str)
      return get.str.bool_by_matches_whole_onig_w_regex_character_class_innards(str, "-0-9\\.")
    end,
    nonindicated_hex_number_str = function(str)
      return get.str.bool_by_matches_whole_onig_w_regex_character_class_innards(str, "-0-9a-fA-F\\.")
    end,
  },
  nonindicated_hex_number_str = {
    pos_int_nonindicated_hex_number_str = function(str)
      return get.str.bool_by_not_startswith(str, "-") and get.str.bool_by_not_contains_w_ascii_str(str, ".")
    end
  },
  hex_str = {
    byte_hex_str = function(str)
      return #str == 2
    end,
    two_byte_hex_str = function(str)
      return #str == 4
    end,
    git_sha1_hex_str = function(str)
      return #str >= 7 and #str <= 40
    end,
    sha1_hex_str = function(str)
      return #str == 40
    end,
    sha256_hex_str = function(str)
      return #str == 64
    end,
    hydrus_service_key = function(str)
      return true
    end,
  },
  sha256_hex_str = {
    hydrus_file_hash = function(str)
      return true
    end,
  },
  git_sha1_hex_str = {
    full_sha1_hex_str = function(str)
      return #str == 40
    end,
    short_sha1_hex_str = function(str)
      return #str <= 40
    end,
  },
  colon_alphanum_minus_underscore = {
    device_identifier = function(str)
      return get.str.pos_int_by_amount_contained_nooverlap(str, ":") >= 4 -- linux_chassis:kernel_name:os_common_subname:machine_arch:host_name (perhaps more in the future)
    end,
    alphanum_minus_underscore = function(str)
      return get.str.bool_by_not_contains_w_str(str, ":")
    end,
    calendar_name = function(str)
      return get.arr.bool_by_contains(
        transf["nil"].calendar_name_arr(),
        str
      )
    end,
    colon_alphanum_minus = function(str)
      return get.str.bool_by_not_contains_w_str(str, "_")
    end,
  },
  colon_alphanum_minus = {
    ipv6 = function(str)
      return get.str.bool_by_matches_whole_onig_w_regex_character_class_innards(str, "a-fA-F0-9:") -- naive check because the actual regex is a monster
    end,
    colon_minus_num = function(str)
      return get.str.bool_by_matches_whole_onig_w_regex_character_class_innards(str, "-0-9:")
    end,
    issn_full = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.issn .. "::\\d+::\\d+")
    end,
  },
  colon_minus_num = {
    colon_num = function(str)
      return get.str.bool_by_not_contains_w_ascii_str(str, "-")
    end,
    slice_notationn = transf['nil']['true'], -- too lazy or now
    int_ratio_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.int_ratio_str)
    end,
  },
  colon_num = {
    hour = function(str)
      return get.str.bool_by_matches_whole_onig(str, "\\d{2}")
    end,
    hour_minute = function(str)
      return get.str.bool_by_matches_whole_onig(str, "\\d{2}:\\d{2}")
    end,
    hour_minute_second = function(str)
      return get.str.bool_by_matches_whole_onig(str, "\\d{2}:\\d{2}:\\d{2}")
    end,
    twod_locator = function(str)
      return get.str.bool_by_matches_whole_onig(str, ":\\d+(:?:\\d+)?")
    end,
  },
  calendar_name = {
    writeable_calendar_name = function(name)
      return get.str.bool_by_not_startswith(name, "r-:")
    end,
  },
  alphanum_minus = {
    isbn10 = function(str)
      return get.str.bool_by_matches_whole_onig(transf.alphanum_minus.alphanum_by_remove(str), r.g.isbn10)
    end,
    isbn13 = function(str)
      return get.str.bool_by_matches_whole_onig(transf.alphanum_minus.alphanum_by_remove(str), r.g.isbn13)
    end,
    isbn = function(str)
      return is.alphanum_minus.isbn10(str) or is.alphanum_minus.isbn13(str)
    end,
    issn = function(str) 
      return get.str.bool_by_matches_whole_onig(str, r.g.issn)
    end,
    uuid = function(str)
      return get.str.bool_by_matches_whole_insensitive_onig(transf.str.str_by_all_eutf8_lower(str), r.g_i.uuid)
    end,
    ipc_socket_id = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.ipc_socket_id)
    end,
    github_username = function(str)
      return get.str.bool_by_not_startswith(str, "-") and get.str.bool_by_not_endswith(str, "-") and #str <= 39
    end,
    lower_alphanum_minus = function(str)
      return get.str.bool_by_not_matches_part_onig_w_regex_character_class_innards(str, "A-Z")
    end,
    upper_alphanum_minus = function(str)
      return get.str.bool_by_not_matches_part_onig_w_regex_character_class_innards(str, "a-z")
    end,
    num_minus = function(str)
      return get.str.bool_by_matches_whole_onig_w_regex_character_class_innards(str, "-0-9")
    end,
    
    kebap_case = function(str)
      return get.str.bool_by_not_matches_part_onig(str, "^\\d")
    end,
    kernel_name = function(str)
      return get.arr.bool_by_contains(ls.kernel_name_arr, str)
    end,
    os_common_subname = function(str)
      return get.arr.bool_by_contains(ls.os_common_subname_arr, str)
    end,
  },
  kebap_case = {
    strict_kebap_case = function(str)
      return 
        get.str.bool_by_not_startswith(str, "-") and
        get.str.bool_by_not_endswith(str, "-") and
        get.str.bool_by_not_contains_w_str(str, "--")
    end,
  },
  strict_kebap_case = {
    upper_strict_kebap_case = function(str)
      return get.str.bool_by_not_matches_part_onig_w_regex_character_class_innards(str, "a-z")
    end,
    lower_strict_kebap_case = function(str)
      return get.str.bool_by_not_matches_part_onig_w_regex_character_class_innards(str, "A-Z")
    end,
    mixed_strict_kebap_case = function(str)
      return not is.strict_kebap_case.upper_strict_kebap_case(str) and not is.strict_kebap_case.lower_strict_kebap_case(str)
    end,
    bcp_47_language_tag = transf["nil"]["true"] -- too lazy for now
  },
  bcp_47_language_tag = {
    basic_locale = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.basic_locale)
    end,
  },
  lower_strict_kebap_case = {
    csl_style = function(str)
      return is.local_absolute_path.local_extant_path(
        transf.lower_strict_snake_case.local_absolute_path_by_csl_file(str)
      )
    end,
    stream_boolean_attribute = function(str)
      return get.arr.bool_by_contains(ls.stream_boolean_attribute_arr, str)
    end,
  },
  mixed_strict_kebap_case = {
    camel_strict_kebap_case = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.camel_strict_kebap_case)
    end,
  },
  camel_strict_kebap_case = {
    upper_camel_strict_kebap_case = function(str)
      return get.str.bool_by_matches_part_onig(str, "^[A-Z]")
    end,
    lower_camel_strict_kebap_case = function(str)
      return get.str.bool_by_matches_part_onig(str, "^[a-z]")
    end,
  },
  num_minus = {
    
    digit_interval_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, "\\d+-\\d+")
    end,
  },
  lower_alphanum_minus = {
    relay_identifier = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.relay_identifier)
    end,
    git_remote_type = function(str)
      return get.arr.bool_by_contains(
        ls.git_remote_type_arr,
        str
      )
    end,
  },
  relay_identifier = {
    active_relay_identifier = function(str)
      return str == transf["nil"].active_relay_identifier()
    end,
  },
  uuid = {
    contact_uuid = function(uuid)
      local succ, res = pcall(transf.uuid.raw_contact_or_nil, uuid)
      return succ 
    end,
    null_uuid = function(uuid)
      return uuid == "00000000-0000-0000-0000-000000000000"
    end
  },
  youtube_video_id = {
    actual_youtube_video_id = function(id)
      return transf.youtube_video_id.youtube_video_item(id) ~= nil
    end
  },
  actual_youtube_video_id = {
    extant_youtube_video_id = function(id)
      return get.arr.bool_by_contains(ls.youtube_exists_upload_status_arr, transf.youtube_video_id.youtube_upload_status(id))
    end,
    private_youtube_video_id = function(id)
      return transf.youtube_video_id.privacy_status(id) == "private"
    end,
    unavailable_youtube_video_id = function(id)
      return 
        not transf.youtube_video_id.extant(id) or
        transf.youtube_video_id.private(id)
    end,
  },
  path = {
    extension_path = function(path)
      return transf.path.extension(path) ~= ""
    end,
    remote_path = function(path)
      return is.remote_path.labelled_remote_path(path) -- future: or is.remote_path.url_remote_path(path)
    end,
    local_path = function(path)
      return not is.path.remote_path(path)
    end,
    absolute_path = function(path)
      return (
        is.path.remote_path(path) and is.remote_path.remote_absolute_path()
      ) or (
        is.path.local_path(path) and is.local_path.local_absolute_path()
      )
    end,
    path_with_twod_locator = function(path)
      return get.str.bool_by_matches_part_eutf8(transf.path.leaflike_by_leaf(path), ":%d+$")
    end,
    useless_file_leaf_path = function(path)
      return get.arr.bool_by_contains(ls.name_of_useless_file_arr, transf.path.leaflike_by_leaf(path))
    end,
    not_useless_file_leaf_path = function(path)
      return not is.path.useless_file_leaf_path(path)
    end,
    citable_path = function(path)
      return 
        is.leaflike.citable_filename(transf.path.leaflike_by_leaf(path)) 
    end,
    dotfilename_path = function(path)
      return 
        is.str.starting_with_dot_str(transf.path.leaflike_by_leaf(path))
    end,
    not_dotfilename_path = function(path)
      return not is.path.dotfilename_path(path)
    end,
  },
  citable_path = {
    mpapers_citable_local_absolute_path = function(path)
      return get.str.bool_by_startswith(path, dynamic_permanents.str_key_str_value_assoc_by_env.MPAPERS)
    end,
    mcitations_citable_local_absolute_path = function(path)
      return get.str.bool_by_startswith(path, dynamic_permanents.str_key_str_value_assoc_by_env.MCITATIONS)
    end,
    mpapernotes_citable_local_absolute_path = function(path)
      return get.str.bool_by_startswith(path, dynamic_permanents.str_key_str_value_assoc_by_env.MPAPERNOTES)
    end,
    mpapers_citable_object_file = function(path)
      return is.citable_path.mpapers_citable_local_absolute_path(path) and is.local_absolute_path.local_file(path)
    end,
    mcitations_csl_file = function(path)
      return is.citable_path.mcitations_citable_local_absolute_path(path) and is.local_absolute_path.local_file(path)
    end,
    mpapernotes_citable_object_notes_file = function(path)
      return is.citable_path.mpapernotes_citable_local_absolute_path(path) and is.local_absolute_path.local_file(path)
    end,
  },
  remote_path = {
    labelled_remote_path = function(path)
      return not not path:find("^[^/:]-:/") 
    end,
    -- url_remote_path = is.str.url,
    remote_absolute_path = transf["nil"]["true"] -- remote paths are always absolute
  },
  remote_absolute_path = {
    remote_extant_path = function(path)
      return is.labelled_remote_absolute_path.labelled_remote_extant_path(path)
    end,
  },
  labelled_remote_absolute_path = {
    labelled_remote_extant_path = function(path)
      return transf.str.bool_by_evaled_env_bash_success("rclone ls " .. transf.str.str_by_single_quoted_escaped(path))
    end,
  },
  remote_extant_path = {
    remote_dir = function(path)
      return is.labelled_remote_extant_path.labelled_remote_dir(path)
    end,
    remote_file = function(path)
      return not is.remote_extant_path.remote_dir(path)
    end,
  },
  labelled_remote_extant_path = {
    labelled_remote_dir = function(path)
      return get.str.not_userdata_o_fn_or_nil_by_evaled_env_bash_parsed_json_in_key("rclone lsjson --stat" .. transf.str.str_by_single_quoted_escaped(path))
    end,
    labelled_remote_file = function(path)
      return not is.labelled_remote_extant_path.labelled_remote_dir(path)
    end,
  },
  labelled_remote_file = {
    empty_labelled_remote_file = function(path)
      local contents = transf.labelled_remote_file.str_by_contents(path)
      return contents == nil or contents == ""
    end,
    nonempty_labelled_remote_file = function(path)
      return not is.labelled_remote_file.empty_labelled_remote_file(path)
    end,
  },
  remote_file = {
    empty_remote_file = function(path)
      return is.labelled_remote_file.empty_labelled_remote_file(path)
    end,
    nonempty_remote_file = function(path)
      return is.labelled_remote_file.empty_labelled_remote_file(path)
    end,
  },
  labelled_remote_dir = {
    empty_labelled_remote_dir = function(path)
      return transf.labelled_remote_dir.absolute_path_stateful_iter_by_children(path)() == nil
    end,
    nonempty_labelled_remote_dir = function(path)
      return not is.labelled_remote_dir.empty_labelled_remote_dir(path)
    end,
  },
  remote_dir = {
    empty_remote_dir = function(path)
      return is.labelled_remote_dir.empty_labelled_remote_dir(path)
    end,
    nonempty_remote_dir = function(path)
      return not is.labelled_remote_dir.empty_labelled_remote_dir(path)
    end,
  },
  local_path = {
    local_naive_absolute_path = function(path)
      return get.str.bool_by_startswith(path, "/")
    end,
    local_nonabsolute_path = function(path)
      return not is.local_path.local_absolute_path(path)
    end,
    contains_relative_references_local_path = function(path)
      return 
        get.str.bool_by_startswith_any_w_str_arr(
          path,
          {
            "./",
            "../",
            "/./",
            "/../",
          }
        ) or 
        get.str.bool_by_contains_any_w_str_arr(
          path,
          {
            "/./",
            "/../",
          }
        ) or
        get.str.bool_by_endswith_any_w_ascii_str_arr(
          path,
          {
            "/.",
            "/..",
          }
        )
      end,
    not_contains_relative_references_local_path = function(path)
      return not is.path.contains_relative_references_path(path)
    end,
    local_resolvable_path = function(path)
      return is.local_path.local_naive_absolute_path(path) or is.local_path.local_tilde_path(path)
    end
  },
  local_naive_absolute_path = {
    local_absolute_path = function(path)
      return is.local_path.local_naive_absolute_path(path) and is.local_path.not_contains_relative_references_local_path(path)
   end,
  },
  local_nonabsolute_path = {
    local_tilde_path = function(path)
      return get.str.bool_by_startswith(path, "~/")
    end,
    atpath = function(path)
      return get.str.bool_by_startswith(path, "@")
    end,
    duplex_local_nonabsolute_path = function(path)
      return get.str.pos_int_by_amount_contained_nooverlap(path, "/") == 2
    end,
    triplex_local_nonabsolute_path = function(path)
      return get.str.pos_int_by_amount_contained_nooverlap(path, "/") == 3
    end,
  },
  duplex_local_nonabsolute_path = {
    owner_item_path = transf["nil"]["true"],
  },
  local_absolute_path = {
    local_extant_path = function(path)
      local file = io.open(path, "r")
      pcall(io.close, file)
      return file ~= nil
    end,
    local_nonextant_path = function(path)
      return not is.path.local_extant_path(path)
    end,
    root_local_absolute_path = function(path)
      return path == "/"
    end,
    in_volume_local_absolute_path = function(path)
      return get.str.bool_by_startswith(path, "/Volumes/")
    end,
    in_home_local_absolute_path = function(path)
      return get.str.bool_by_startswith(path, dynamic_permanents.str_key_str_value_assoc_by_env.HOME)
    end,
    in_global_tmp_path = function(path)
      return get.str.bool_by_startswith(path, "/tmp/")
    end,
  },
  in_global_tmp_path = {
    ipc_socket_path = function(path)
      return get.str.bool_by_startswith(path, "/tmp/sockets/")
    end,
  },
  in_home_local_absolute_path = {
    in_me_local_absolute_path = function(path)
      return get.str.bool_by_startswith(path, dynamic_permanents.str_key_str_value_assoc_by_env.ME)
    end,
    in_cache_local_absolute_path = function(path)
      return get.str.bool_by_startswith(path, dynamic_permanents.str_key_str_value_assoc_by_env.XDG_CACHE_HOME)
    end,
    in_tmp_local_absolute_path = function(path)
      return get.str.bool_by_startswith(path, dynamic_permanents.str_key_str_value_assoc_by_env.TMPDIR)
    end,
    in_downloads_local_absolute_path = function(path)
      return get.str.bool_by_startswith(path, dynamic_permanents.str_key_str_value_assoc_by_env.DOWNLOADS)
    end,
    in_proc_local_absolute_path = function(path)
      return get.str.bool_by_startswith(path, dynamic_permanents.str_key_str_value_assoc_by_env.HOMEPROC)
    end,
  },
  in_tmp_local_absolute_path = {
    
  },
  in_proc_local_absolute_path = {
    in_proc_pull_local_absolute_path = function(path)
      return get.str.bool_by_startswith(path, dynamic_permanents.str_key_str_value_assoc_by_env.HOMEPROC .. "/pull/")
    end,
    in_proc_local_local_absolute_path = function(path)
      return get.str.bool_by_startswith(path, dynamic_permanents.str_key_str_value_assoc_by_env.HOMEPROC .. "/local/")
    end,
  },
  in_proc_local_local_absolute_path = {
    in_proc_old_local_absolute_path = function(path)
      return get.str.bool_by_startswith(path, dynamic_permanents.str_key_str_value_assoc_by_env.HOMEPROC .. "/local/old/")
    end,
    in_proc_hydrus_local_absolute_path = function(path)
      return get.str.bool_by_startswith(path, dynamic_permanents.str_key_str_value_assoc_by_env.HOMEPROC .. "/local/hydrus/")
    end,
  },
  in_proc_old_local_absolute_path = {
    old_location_logs_proc_dir = function(path)
      return transf.path.path_by_ending_with_slash(path) == dynamic_permanents.str_key_str_value_assoc_by_env.HOMEPROC .. "/local/old/location_logs/"
    end,
    old_media_logs_proc_dir = function(path)
      return transf.path.path_by_ending_with_slash(path) == dynamic_permanents.str_key_str_value_assoc_by_env.HOMEPROC .. "/local/old/media_logs/"
    end,
  },
  in_downloads_local_absolute_path = {
    telegram_raw_export_dir = function(path)
      return get.str.bool_by_startswith(path, dynamic_permanents.str_key_str_value_assoc_by_env.DOWNLOADS .. "/Telegram Desktop/DataExport_")
    end,
  },
  in_me_local_absolute_path = {
    in_mcitations_absolute_path = function(path)
      return get.str.bool_by_startswith(path, dynamic_permanents.str_key_str_value_assoc_by_env.MCITATIONS)
    end,
    in_mpapers_absolute_path = function(path)
      return get.str.bool_by_startswith(path, dynamic_permanents.str_key_str_value_assoc_by_env.MPAPERS)
    end,
    in_menv_absolute_path = function(path)
      return get.str.bool_by_startswith(path, dynamic_permanents.str_key_str_value_assoc_by_env.MENV)
    end,
  },
  in_cache_local_absolute_path = {
    in_hs_cache_local_absolute_path = function(path)
      return get.str.bool_by_startswith(path, dynamic_permanents.str_key_str_value_assoc_by_env.XDG_CACHE_HOME .. "/hs")
    end,
  },
  in_hs_cache_local_absolute_path = {
    in_cache_export_local_absolute_path = function(path)
      return get.str.bool_by_startswith(path, dynamic_permanents.str_key_str_value_assoc_by_env.XDG_CACHE_HOME .. "/export/")
    end,
  },
  in_cache_export_local_absolute_path = {
    export_dir = function(path)
      return transf.path.path_by_ending_with_slash(transf.path.trimmed_noweirdwhitespace_line_by_parent_path(path)) == dynamic_permanents.str_key_str_value_assoc_by_env.XDG_CACHE_HOME .. "/export/"
    end,
    discord_export_child_dir = function(path)
      return get.str.bool_by_startswith(path, dynamic_permanents.str_key_str_value_assoc_by_env.XDG_CACHE_HOME .. "/hs/export/discord/")
    end,
  },
  export_dir = {
    telegram_export_dir = function(path)
      return transf.path.path_by_ending_with_slash(path) == dynamic_permanents.str_key_str_value_assoc_by_env.XDG_CACHE_HOME .. "/hs/export/telegram/"
    end,
    discord_export_dir = function(path)
      return transf.path.path_by_ending_with_slash(path) == dynamic_permanents.str_key_str_value_assoc_by_env.XDG_CACHE_HOME .. "/hs/export/discord/"
    end,
    facebook_export_dir = function(path)
      return transf.path.path_by_ending_with_slash(path) == dynamic_permanents.str_key_str_value_assoc_by_env.XDG_CACHE_HOME .. "/hs/export/facebook/"
    end,
    signal_export_dir = function(path)
      return transf.path.path_by_ending_with_slash(path) == dynamic_permanents.str_key_str_value_assoc_by_env.XDG_CACHE_HOME .. "/hs/export/signal/"
    end,
  },

  in_volume_local_absolute_path = {
    
  },
  volume_local_extant_path = {
    
    dynamic_time_machine_volume_local_extant_path = function(path)
      return get.str.bool_by_startswith(
        path,
        "/Volumes/com.apple.TimeMachine.localsnapshots/Backups.backupdb/" .. transf["nil"].alphanum_minus_by_localized_name() .. "/" .. os.date("%Y-%m-%d-%H")
      )
    end,
    static_time_machine_volume_local_extant_path = function(path)
      return path == dynamic_permanents.str_key_str_value_assoc_by_env.TMBACKUPVOL .. "/"
    end
      
  },
  local_extant_path = {
    volume_local_extant_path = function(path)
      return get.arr.bool_by_contains(
        transf["nil"].volume_local_extant_path_arr(),
        path
      )
    end,
    local_dir = function(path)
      return not not hs.fs.chdir(path)
    end,
    local_file = function(path)
      return not is.path.local_dir(path)
    end,
  },
  local_file = {
    empty_local_file = function(path)
      local contents =  transf.local_file.str_by_contents(path)
      return contents == nil or contents == ""
    end,
    nonempty_local_file = function(path)
      return not is.path.empty_local_file(path)
    end,
    maildir_file = function(path)
      return is.local_dir.maildir_dir(transf.path.trimmed_noweirdwhitespace_line_by_parent_path(path))
     end,
    local_image_file = function(path)
      return is.file.image_file(path)
    end,
    local_hydrusable_file = function(path)
      return is.file.hydrusable_file(path)
    end,
  },
  local_image_file = {
    local_svg_file = function(path)
      return get.str.bool_by_endswith(path, ".svg")
    end,
  },
  local_dir = {
    empty_local_dir = function(path)
      return transf.local_dir.absolute_path_vt_stateful_iter_by_children(path)() == nil
    end,
    nonempty_local_dir = function(path)
      return not is.path.empty_local_dir(path)
    end,
    dotapp_dir = function(path)
      return get.str.bool_by_endswith(path, ".app")
    end,
    maildir_dir = function(path)
      local leaf transf.path.leaflike_by_leaf(path)
      return leaf == "cur" or leaf == "new" or leaf == "tmp"
    end,
  },
  dotapp_dir = {
    installed_app_dir = function(path)
      return get.str.bool_by_startswith(path, "/Applications/")
    end,
  },
  nonempty_local_dir = {
    latex_project_dir = function(dir)
      return get.dir.bool_by_contains_leaf_of_child(dir, "main.tex")
    end,
    omegat_project_dir = function(dir)
      return get.dir.bool_by_contains_leaf_of_child(dir, "omegat.project")
    end,
    npm_project_dir = function(dir)
      return get.dir.bool_by_contains_leaf_of_child(dir, "package.json")
    end,
    cargo_project_dir = function(dir)
      return get.dir.bool_by_contains_leaf_of_child(dir, "Cargo.toml")
    end,
    sass_project_dir = function(dir)
      return get.dir.bool_by_extension_of_child(dir, "sass")
    end,
    project_dir = function(dir)
      return is.dir.latex_project_dir(dir) or is.dir.omegat_project_dir(dir) or is.dir.npm_project_dir(dir) or is.dir.cargo_project_dir(dir) or is.dir.sass_project_dir(dir)
    end,
  },
  project_dir = {
    client_project_dir = function(dir)
      return get.dir.bool_by_contains_leaf_of_child(dir, "client_project_data.yaml")
    end,
  },
  absolute_path = {
    extant_path = function(path)
      return (
        is.path.remote_path(path) and is.remote_absolute_path.remote_extant_path(path)
      ) or (
        is.path.local_path(path) and is.local_absolute_path.local_extant_path(path)
      )
    end,
    nonextant_path = function(path)
      return not is.path.extant_path(path)
    end,
  },
  extant_path = {
    dir = function(path)
      return (
        is.path.remote_path(path) and is.remote_extant_path.remote_dir(path)
      ) or (
        is.path.local_path(path) and is.local_extant_path.local_dir(path)
      )
    end,
    file = function(path)
      return not is.extant_path.dir(path)
    end,
    in_git_dir = function(path)
      return get.local_extant_path.extant_path_by_self_or_ancestor_sibling_w_leaf(path, ".git")
    end,
  },
  dir = {
    non_bare_git_root_dir = function(path)
      return is.line.git_repository_dir(
        transf.path.path_by_ending_with_slash(path) .. ".git"
      )
    end,
    git_repository_dir = function(path)
      return get.dir.bool_by_contains_leaf_of_child(path, "HEAD")
    end,
    bare_git_root_dir = function(path)
      return is.dir.git_repository_dir(path) and not is.dir.non_bare_git_root_dir(path)
    end,
    git_root_dir = function(path)
      return is.dir.non_bare_git_root_dir(path) or is.dir.git_repository_dir(path) -- not `is.dir.bare_git_root_dir(path)` since we already know that the condition is.dir.non_bare_git_root_dir(path) is false and thus checking is.dir.git_repository_dir(path) is sufficient
    end,

    empty_dir = function(path)
      return (
        is.path.remote_path(path) and is.remote_dir.empty_remote_dir(path)
      ) or (
        is.path.local_path(path) and is.local_dir.empty_local_dir(path)
      )
    end,
    nonempty_dir = function(path)
      return not is.dir.empty_dir(path)
    end,
    logging_dir = function(path)
      return get.str.bool_by_endswith(transf.path.leaflike_by_leaf(path), "_logs")
    end,
  },
  git_root_dir = {
    
    
  },
  nonempty_dir = {
    grandparent_dir = function (path)
      return get.arr.bool_by_some_pass_w_fn(
        transf.dir.absolute_path_arr_by_children(path),
        is.absolute_path.dir
      )
    end,
  },
  in_git_dir = {
    in_has_no_changes_git_dir = function(path)
      return get.str.bool_by_contains_w_str(
        transf.in_git_dir.multiline_str_by_status(path),
        "nothing to commit"
      )
    end,
    in_has_changes_git_dir = function(path)
      return not is.in_git_dir.in_has_no_changes_git_dir(path)
    end,
    in_has_unpushed_commits_git_dir = function(path)
      return #transf.in_git_dir.short_sha1_hex_str_arr_by_unpushed_commits(path) > 0
    end,
  },
  file = {
    plaintext_file = function(path)
      return not is.file.bin_file(path)
    end,
    image_file = function(path)
      return get.path.bool_by_is_normalized_extension_w_str_arr(path, ls.image_extension)
    end,
    hydrusable_file = function(path)
      return get.path.bool_by_is_normalized_extension_w_str_arr(path, ls.hydrusable_extension)
    end,
    bin_file = function(path)
      return get.arr.bool_by_contains(ls.bin_extension, path)
    end,
  },
  bin_file = {
    db_file = function(path)
      return get.path.bool_by_is_normalized_extension_w_str_arr(
        path,
        ls.db_extension
      )
    end,
    playable_file = function (path)
      return get.path.bool_by_is_normalized_extension_w_str_arr(path, ls.audio_extension) or get.path.bool_by_is_normalized_extension_w_str_arr(path, ls.video_extension)
    end,
  },
  db_file = {
    sqlite_file = function(path)
      return get.path.bool_by_is_normalized_extension_w_str_arr(
        path,
        ls.sqlite_extension
      )
    end,
  },
  playable_file = {
    whisper_file = function(path)
      return get.path.bool_by_is_normalized_extension_w_str_arr(path, ls.whisper_extension)
    end,
  },
  shell_script_file = {
    shell_script_file_with_errors = function(path)
      return transf.shell_script_file.str_or_nil_by_gcc_style_errors(path) ~= ""
    end,
    shell_script_file_with_warnings = function(path)
      return transf.shell_script_file.str_or_nil_by_gcc_style_warnings(path) ~= ""
    end,
    envlike_file = function(path)
      return is.shell_script_str.envlike_str(
        transf.plaintext_file.str_by_contents(path)
      )
    end,
  },
  plaintext_file = {
    url_file = function(path)
      return get.path.bool_by_is_extension(path, "url2")
    end,
    script_file = function(path)
      return is.str.script_str(
        transf.plaintext_file.str_by_contents(path)
      )
    end,
    plaintext_assoc_file = function(path)
      get.path.bool_by_is_normalized_extension_w_str_arr(
        path,
        ls["plaintext_assoc_extension"]
      )
    end,
    plaintext_table_file = function(path)
      get.path.bool_by_is_normalized_extension_w_str_arr(
        path,
        ls["plaintext_table_extension"]
      )
    end,
    m3u_file = function(path)
      return get.path.bool_by_is_extension(path, "m3u")
    end,
    gitignore_file = function(path)
      return get.path.bool_by_is_filename(path, ".gitignore")
    end,
    log_file = function(path)
      return get.path.bool_by_is_extension(path, "log")
    end,
    citations_file = function (path)
      return get.path.is_leaf(path, "citations")
    end,
    md_file = function(path)
      return get.path.bool_by_is_normalized_extension_w_str(path, "md")
    end,
  },
  script_file = {
    shell_script_file = function(path)
      return is.str.shell_script_str(
        transf.plaintext_file.str_by_contents(path)
      )
    end,
  },
  plaintext_assoc_file = {
    yaml_file = get.fn.fn_by_arbitrary_args_bound_or_ignored(get.path.bool_by_is_normalized_extension_w_str, {consts.use_singleton, "yaml"}),
    json_file = get.fn.fn_by_arbitrary_args_bound_or_ignored(get.path.bool_by_is_normalized_extension_w_str, {consts.use_singleton, "json"}),
    toml_file = get.fn.fn_by_arbitrary_args_bound_or_ignored(get.path.bool_by_is_normalized_extension_w_str, {consts.use_singleton, "toml"}),
    ini_file = get.fn.fn_by_arbitrary_args_bound_or_ignored(get.path.bool_by_is_normalized_extension_w_str, {consts.use_singleton, "ini"}),
    ics_file = get.fn.fn_by_arbitrary_args_bound_or_ignored(get.path.bool_by_is_normalized_extension_w_str, {consts.use_singleton, "ics"}),
  },
  plaintext_table_file = {

  },
  alphanum_minus_underscore = {
    lower_alphanum_minus_underscore = function(str)
      return get.str.bool_by_not_matches_part_onig_w_regex_character_class_innards(str, "A-Z")
    end,
    package_manager_name = function(str)
      return get.arr.bool_by_contains(transf["nil"].package_manager_name_arr(), str)
    end,
    alphanum_underscore =  function(str) 
      return get.str.bool_by_not_contains_w_str(str, "-")
    end,
    alphanum_minus = function(str)
      return get.str.bool_by_not_contains_w_str(str, "_")
    end,
    alphanum = function(str)
      return is.alphanum_minus_underscore.alphanum_underscore(str) and is.alphanum_minus_underscore.alphanum_minus(str)
    end,
    unicode_block_name = transf["nil"]["true"],
    unicode_category_name = transf["nil"]["true"], 
    unicode_plane_name = transf["nil"]["true"], -- currently no real point in the performance cost of checking if the strings actually are block/category/plane names. maybe in the future
    sign_indicator = function(str)
      return str == "" or str == "-"
    end,
    snakekebap_case = function(str)
      return get.str.bool_by_not_matches_part_onig(str, "^\\d")
    end,
    csl_key = function(str)
      return get.arr.bool_by_contains(ls.csl_key_arr, str)
    end,
    
  },
  csl_key = {
    csl_title_key = function(str)
      return get.arr.bool_by_contains(ls.csl_title_key_arr, str)
    end,
  },
  lower_alphanum_minus_underscore = {
   
    machine_arch = function(str)
      return get.arr.bool_by_contains(ls.machine_arch_arr, str)
    end,
    
  },
  snakekebap_case = {
    strict_snakekebap_case = function(str)
      return 
        get.str.bool_by_not_startswith(str, "_") and
        get.str.bool_by_not_endswith(str, "_") and
        get.str.bool_by_not_contains_w_str(str, "__")
    end,
  },
  strict_snakekebap_case = {
    lower_strict_snakekebap_case = function(str)
      return get.str.bool_by_not_matches_part_onig_w_regex_character_class_innards(str, "A-Z")
    end,
  },
  lower_strict_snakekebap_case = {
    auth_pass_item_name = function(str)
      return get.extant_path.bool_by_file_descendant_with_filename(
        transf.path.path_by_ending_with_slash(dynamic_permanents.str_key_str_value_assoc_by_env.MPASS) .. "p", 
        str
      )
    end,
    cc_pass_item_name = function(str)
      return get.local_extant_path.bool_by_file_descendant_with_filename(
        transf.path.path_by_ending_with_slash(dynamic_permanents.str_key_str_value_assoc_by_env.MPASS) .. "cc", 
        str
      )
    end,
    pass_item_name = function(str)
      return get.local_extant_path.absolute_path_by_descendant_with_filename(
        dynamic_permanents.str_key_str_value_assoc_by_env.MPASS,
        str
      )
    end,
    csl_type = function(str)
      return get.arr.bool_by_contains(ls.csl_type_arr, str)
    end,
  },
  alphanum_underscore = {
    lower_alphanum_underscore = function(str)
      return get.str.bool_by_not_matches_part_onig_w_regex_character_class_innards(str, "A-Z")
    end,
    upper_alphanum_underscore = function(str)
      return get.str.bool_by_not_matches_part_onig_w_regex_character_class_innards(str, "a-z")
    end,
    snake_case = function(str)
      return get.str.bool_by_not_matches_part_onig(str, "^\\d")
    end,
  },
  snake_case = {
    strict_snake_case = function(str)
      return 
        get.str.bool_by_not_startswith(str, "_") and
        get.str.bool_by_not_endswith(str, "_") and
        get.str.bool_by_not_contains_w_str(str, "__")
    end,
  },
  strict_snake_case = {
    upper_strict_snake_case = function(str)
      return get.str.bool_by_not_matches_part_onig_w_regex_character_class_innards(str, "a-z")
    end,
    lower_strict_snake_case = function(str)
      return get.str.bool_by_not_matches_part_onig_w_regex_character_class_innards(str, "A-Z")
    end,
    mixed_strict_snake_case = function(str)
      return not is.strict_snake_case.upper_strict_snake_case(str) and not is.strict_snake_case.lower_strict_snake_case(str)
    end,
  },
  lower_strict_snake_case = {
    citable_object_id_indication_name = function(str)
      return get.arr.bool_by_contains(ls.citable_object_id_indication_name_arr, str)
    end,
    client_id = function(str)
      return get.table.bool_by_has_key(dynamic_permanents.str_key_assoc_by_fstblmap.client_id.contact_uuid, str)
    end,
    client_project_kind = function(str)
      return get.arr.bool_by_contains(ls.client_project_kind_arr, str)
    end,
    billing_unit = function(str)
      return get.arr.bool_by_contains(ls.billing_unit_arr, str)
    end,
    markdown_extension_name = function(str)
      return get.arr.bool_by_contains(ls.markdown_extension_name_arr, str)
    end,
    backup_type = function(str)
      return get.arr.bool_by_contains(ls.backup_type_arr, str)
    end,
    root_hydrus_tag_namespace = function(str)
      return get.arr.bool_by_contains(ls.root_hydrus_tag_namespace_arr, str)
    end,
    root_hydrus_note_namespace = function(str)
      return get.arr.bool_by_contains(ls.root_hydrus_note_namespace_arr, str)
    end,
    dynamic_structure_name = function(str)
      return get.arr.bool_by_contains(ls.dynamic_structure_name_arr, str)
    end,
    api_name = function(str)
      return get.arr.bool_by_contains(ls.api_name_arr, str)
    end,
    secondary_api_name = function(str)
      return get.arr.bool_by_contains(ls.secondary_api_name_arr, str)
    end,
    pandoc_basic_format = function(str)
      return get.arr.bool_by_contains(ls.pandoc_basic_format_arr, str)
    end,
    search_engine_id = function(str)
      return get.arr.bool_by_contains(ls.search_engine_id_arr, str)
    end,
    creation_specifier_type = function(str)
      return get.arr.bool_by_contains(ls.creation_specifier_type_arr, str)
    end,
    bin_specifier_name = function(str)
      return get.arr.bool_by_contains(ls.bin_specifier_name_arr, str)
    end,
    unicode_char_prop = function(str)
      return get.arr.bool_by_contains(ls.unicode_char_prop_arr, str)
    end,
    unicode_emoji_prop = function(str)
      return get.arr.bool_by_contains(ls.unicode_emoji_prop_arr, str)
    end,
  },
  root_hydrus_tag_namespace = {
    global_value_taking_root_hydrus_tag_namespace = function(str)
      return get.arr.bool_by_contains(ls.global_value_taking_root_hydrus_tag_namespace_arr, str)
    end,
  },
  mixed_strict_snake_case = {
    camel_strict_snake_case = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.camel_strict_snake_case)
    end,
  },
  camel_strict_snake_case = {
    upper_camel_strict_snake_case = function(str)
      return get.str.bool_by_matches_part_onig(str, "^[A-Z]")
    end,
    lower_camel_strict_snake_case = function(str)
      return get.str.bool_by_matches_part_onig(str, "^[a-z]")
    end,
  },
  lower_alphanum_underscore = {
    general_name = function(str)
      return get.str.bool_by_not_startswith(str, "_") and get.str.bool_by_not_endswith(str, "_")
    end,
    
  },
  general_name = {
    thing_name_with_optional_explanation = transf["nil"]["true"],
    function_container_name = function (str)
      return get.arr.bool_by_contains(ls.function_container_name_arr, str)
      
    end
  },
  thing_name_with_optional_explanation = {
    thing_name = function(str)
      return get.str.bool_by_not_contains_w_str_arr(str, {"_by_", "_w_"})
    end,
  },
  thing_name = {
    assc_thing_name = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.assc_thing_name_by_extract_key_value)
    end,
  },
  alphanum = {
    alpha_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, "\\w+")
    end,
    digit_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, "\\d+")
    end,
    hex_str = function(str)
      return get.str.bool_by_matches_whole_onig_w_regex_character_class_innards(str, "0-9a-fA-F")
    end,
    indicated_hex_str = function(str)
      return get.str.bool_by_startswith(str, "0x") and is.alphanum.hex_str(str:sub(3))
    end,
    indicated_bin_str = function(str)
      return get.str.bool_by_startswith(str, "0b") and is.alphanum.bin_str(str:sub(3))
    end,
    indicated_oct_str = function(str)
      return get.str.bool_by_startswith(str, "0o") and is.alphanum.oct_str(str:sub(3))
    end,
    indicated_dec_str = function(str)
      return get.str.bool_by_startswith(str, "0d") and is.alphanum.digit_str(str:sub(3))
    end,
    base32_gen_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.base32_gen_str)
    end,
    base32_crock_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.base32_crock_str)
    end,
    base32_str = function(str)
      return is.printable_ascii_not_whitespace_str.base32_gen_str(str) or is.printable_ascii_not_whitespace_str.base32_crock_str(str)
    end,
    bic = function(str)
      return #str == 8 or #str == 11
    end,
    lower_camel_case = function(str)
      return get.str.bool_by_matches_part_onig(str, "^[a-z]")
    end,
    upper_camel_case = function(str)
      return get.str.bool_by_matches_part_onig(str, "^[A-Z]")
    end,
    token_type = function(str)
      return get.arr.bool_by_contains(ls.token_type_arr, str)
    end,
    pos_int_dimensions_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.pos_int_dimensions_str)
    end,
  },
  indicated_hex_str = {
    fnid = function(str)
      return #str == 14
    end,
  },
  digit_str = {
    bin_str = function(str)
      return get.str.bool_by_matches_whole_onig_w_regex_character_class_innards(str, "01")
    end,
    oct_str = function(str)
      return get.str.bool_by_matches_whole_onig_w_regex_character_class_innards(str, "0-7")
    end,
    cleaned_payment_card_number = function(str)
      return #str >= 8 and #str <= 19
    end,
  },
  alpha_str = {
    lower_alpha_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, "[a-z]+")
    end,
    upper_alpha_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, "[A-Z]+")
    end,
    iso_3366_1_alpha_2_country_code = function(str)
      return #str == 2
    end,
    iso_3166_1_alpha_3_country_code = function(str)
      return #str == 3
    end,
    iso_639_1_language_code = function(str)
      return #str == 2
    end,
    iso_639_3_language_code = function(str)
      return #str == 3
    end,
    mullvad_city_code = function(str)
      return #str == 3
    end,
    http_authentication_scheme = function(str)
      return get.arr.bool_by_contains(ls.http_authentication_scheme_arr, str)
    end,
    menu_item_key = function(str)
      return get.arr.bool_by_contains(ls.menu_item_key_arr, str)
    end,
    vcard_key_with_vcard_type = function(str)
      return get.arr.bool_by_contains(ls.vcard_key_with_vcard_type_arr, str)
    end,
  },
  lower_alpha_str = {
    fs_attr_name = function(str)
      return get.arr.bool_by_contains(ls.fs_attr_name_arr, str)
    end,
    local_o_remote_str = function(str)
      return str == "local" or str == "remote"
    end,
    dcmp_name = function(str)
      return get.arr.bool_by_contains(ls.dcmp_name_arr, str)
    end,
    dcmp_name_long = function(str)
      return get.arr.bool_by_contains(ls.dcmp_name_long_arr, str)
    end,
    mod_char = function(str)
      return get.arr.bool_by_contains(ls.mod_char_arr, str)
    end,
    mod_name = function(str)
      return get.arr.bool_by_contains(ls.mod_name_arr, str)
    end,
    leaf_str = function(str)
      return str == "leaf"
    end,
    project_type = function(str)
      return get.arr.bool_by_contains(ls.project_type_arr, str)
    end,
    vcard_phone_type = function(str)
      return get.arr.bool_by_contains(ls.vcard_phone_type_arr, str)
    end,
    vcard_email_type = function(str)
      return get.arr.bool_by_contains(ls.vcard_email_type_arr, str)
    end,
    vcard_address_type = function(str)
      return get.arr.bool_by_contains(ls.vcard_address_type_arr, str)
    end,
    audiodevice_subtype = function(str)
      return str == "input" or str == "output"
    end,
    otp_type = function(str)
      return str == "totp" or str == "hotp"
    end,
    llm_chat_role = function(str)
      return get.arr.bool_by_contains(ls.llm_chat_role_arr, str)
    end,
    stream_state = function(str)
      return get.arr.bool_by_contains(ls.stream_state_arr, str)
    end,
    flag_profile_name = function(str)
      return get.arr.bool_by_contains(ls.flag_profile_name_arr, str)
    end,
    markdown_extension_set_name = function(str)
      return get.arr.bool_by_contains(ls.markdown_extension_set_name_arr, str)
    end,
    booru_rating = function(str)
      return get.arr.bool_by_contains(ls.booru_rating_arr, str)
    end,
    external_tag_namespace = function(str)
      return get.arr.bool_by_contains(ls.external_tag_namespace_arr, str)
    end,
    type_name = function(str)
      return get.arr.bool_by_contains(ls.type_name_arr, str)
    end,
    mac_plist_type_name = function(str)
      return get.arr.bool_by_contains(ls.mac_plist_type_name_arr, str)
    end,
    youtube_upload_status = function(str)
      return get.arr.bool_by_contains(ls.youtube_upload_status_arr, str)
    end,
    youtube_privacy_status = function(str)
      return get.arr.bool_by_contains(ls.youtube_privacy_status_arr, str)
    end,
    likely_main_branch_name = function(str)
      return get.arr.bool_by_contains(ls.likely_main_branch_name_arr, str)
    end,
    linux_chassis  = function(str)
      return get.arr.bool_by_contains(ls.linux_chassis_arr, str)
    end,
  },
  youtube_upload_status  = {
    youtube_exists_upload_status = function(str)
      return get.str.bool_by_contains(ls.youtube_exists_upload_status_arr, str)
    end,
  },
  external_tag_namespace = {
    danbooru_category_name = function(str)
      return get.arr.bool_by_contains(ls.danbooru_category_name_arr, str)
    end,
  },
  url = {
    scheme_url = function(url)
      return get.str.bool_by_matches_part_onig(url, "^" .. r.g.url_scheme)
    end,
    path_url = function(url)
      return transf.url.local_absolute_path_or_nil_by_path(url) ~= nil
    end,
    authority_url = function(url)
      return transf.url.authority(url) ~= nil
    end,
    query_url = function(url)
      return transf.url.query_str_or_nil(url) ~= nil
    end,
    fragment_url = function(url)
      return transf.url.urlcharset_str_or_nil_by_fragment(url) ~= nil
    end,
    username_url = function(url)
      return transf.url.username(url) ~= nil
    end,
    password_url = function(url)
      return transf.url.urlcharset_str_or_nil_by_password(url) ~= nil
    end,
    userinfo_url = function(url)
      return transf.url.urlcharset_str_or_nil_by_userinfo(url) ~= nil
    end,
    nofragment_url = function(url)
      return transf.url.fragment(url) == nil
    end,

   
    pornpen_post_url = function(url)
      return is.url.pornpen_style_post_url(url) and is.url.porpen_url(url)
    end,
    github_url = function(url)
      return get.str.bool_by_startswith(url, "https://github.com/")
    end,
    wayback_machine_url = function(url)
      return get.str.bool_by_startswith(url, "https://web.archive.org/web/")
    end,
    hydrus_style_file_url = function(url)
      return is.url.hydrus_style_file_endpoint_url(url) and is.url.hydrus_style_single_hash_url(url)
    end,
    hydrusable_url = function(url)
      local url_type = transf.url.sme_5_pos_int_or_nil_by_hydrus_url_type(url)
      return url_type ~= nil and url_type ~= 5
    end,

  },
  canon_booru_post_url = {
    gelbooru_post_url = function(url)
      return is.canon_booru_url.gelbooru_url(url)
    end,
    danbooru_post_url = function(url)
      return is.canon_booru_url.danbooru_url(url)
    end,
  },
  hydrusable_url = {
    hydrusable_post_url = function(url)
      return transf.url.sme_5_pos_int_or_nil_by_hydrus_url_type(url) == 0
    end,
    hydrusable_file_url = function(url)
      return transf.url.sme_5_pos_int_or_nil_by_hydrus_url_type(url) == 2
    end,
    hydrusable_page_url = function(url)
      return transf.url.sme_5_pos_int_or_nil_by_hydrus_url_type(url) == 3
    end,
    hydrusable_gallery_url = function(url)
      return transf.url.sme_5_pos_int_or_nil_by_hydrus_url_type(url) == 4
    end,
  },
  hydrus_style_file_url = {
    local_hydrus_file_url = function(url)
      return is.url.hydrus_url(url)
    end,
  },
  github_url = {
    github_path_url = function(url)
      return is.url.path_url(url)
    end,
  },
  github_path_url = {
    github_user_url = function(url)
      local path = transf.url.local_nonabsolute_path_or_nil_by_path(
        url
      )
      return get.str.bool_by_not_contains_w_ascii_str(
        path, "/"
      )
    end,
  },
  nofragment_url = {
    clean_url = function(url)
      return transf.url.query_str_or_nil(url) == nil
    end,
  },
  clean_url = {
    base_url = function(url)
      return transf.url.local_absolute_path_or_nil_by_path(url) == nil
    end,
  },
  base_url = {
    dotgit_url = function(url)
      return get.str.bool_by_endswith(url, ".git")
    end,
  },
  scheme_url = {
    mailto_url = function(url)
      return get.str.bool_by_startswith(url, "mailto:")
    end,
    tel_url = function(url)
      return get.str.bool_by_startswith(url, "tel:")
    end,
    otpauth_url = function(url)
      return get.str.bool_by_startswith(url, "otpauth:")
    end,
    data_url = function(url)
      return get.str.bool_by_startswith(url, "data:")
    end,
    http_protocol_url = function(url)
      return get.str.bool_by_startswith(url, "http://") or get.str.bool_by_startswith(url, "https://")
    end,
    file_url = function(url)
      return get.str.bool_by_startswith(url, "file://")
    end,
  },
  http_protocol_url = {
    http_url = function(url)
      return get.str.bool_by_startswith(url, "http://")
    end,
    https_url = function(url)
      return get.str.bool_by_startswith(url, "https://")
    end,
  },
  path_url = {
    owner_item_url = function(url) 
      return #transf.owner_item_url.two_strs__arr(url) == 2
    end,
    extension_url = function(url)
      return is.path.extension_path(transf.path_url.path(url))
    end,
    danbooru_style_post_url = function(url)
      return get.str.bool_by_matches_whole_eutf8(transf.path_url.path(url), "/posts/%d+/?")
    end,
    yandere_style_post_url = function(url)
      return get.str.bool_by_matches_whole_eutf8(transf.path_url.path(url), "/post/show/%d+/?")
    end,
    pornpen_style_post_url = function(url)
      return get.str.bool_by_matches_whole_onig(transf.path_url.path(url), "/view/[a-zA-Z0-9]+/?")
    end,
    doi_url = function(url)
      return is.str.doi(
        transf.url.local_absolute_path_or_nil_by_path_decoded(url)
      )
    end,
    hydrus_style_file_endpoint_url = function(url)
      return 
        transf.path.path_by_ending_with_slash(transf.path_url.path(url)) == "/get_files/file/"
    end,
  },
  query_url = {
    gelbooru_style_post_url = function(url)
      local paramtbl = transf.url.str_key_str_value_assoc_by_decoded_param_table(url)
      return is.any.int_str(paramtbl["id"]) and paramtbl["page"] == "post"
    end,
    hydrus_style_single_hash_url = function(url)
      local paramtbl = transf.url.str_key_str_value_assoc_by_decoded_param_table(url)
      return paramtbl.hash
    end,
    hydrus_style_multiple_hash_url = function(url)
      local paramtbl = transf.url.str_key_str_value_assoc_by_decoded_param_table(url)
      return paramtbl.hashes
    end,
  },
  extension_url = {
    image_url = function(url)
      return get.path.bool_by_is_extension_in(transf.path_url.path(url), ls.image_extension)
    end,
    playable_url = function(url)
      return get.path.bool_by_is_normalized_extension_w_str_arr(
        transf.path_url.path(url),
        ls.audio_extension
      ) or get.path.bool_by_is_normalized_extension_w_str_arr(
        transf.path_url.path(url),
        ls.video_extension
      )
    end
  },
  playable_url = {
    whisper_url = function(url)
      return get.path.bool_by_is_normalized_extension_w_str_arr(
        transf.path_url.path(url),
        ls.whisper_extension
      )
    end,
  },
  authority_url = {
    host_url = function(url)
      return transf.url.host(url) ~= nil
    end,
  },
  host_url = {
    canon_booru_url = function(url)
      return  transf.host_url.host(url) == "danbooru.donmai.us" or 
              transf.host_url.host(url) == "gelbooru.com"
    end,
    youtube_url = function(url)
      return transf.host_url.host(url) == "youtube.com"
    end,
    pornpen_url = function(url)
      return transf.host_url.host(url) == "pornpen.ai"
    end,
    hydrus_url = function(url)
      return transf.host_url.host(url) == "127.0.0.1:45869"
    end,
  },
  canon_booru_url = {
    danbooru_url = function(url)
      return transf.url.host(url) == "danbooru.donmai.us"
    end,
    gelbooru_url = function(url)
      return transf.url.host(url) == "gelbooru.com"
    end,
    canon_booru_post_url = function(url)
      return 
        is.url.gelbooru_style_post_url(url) or
        is.url.danbooru_style_post_url(url) 
    end,
  },
  youtube_url = {
    youtube_path_url = function(url)
      return is.url.path_url(url)
    end,
  },
  youtube_path_url = {
    youtube_video_url = function(url)
      return transf.path_url.path_component_by_initial(url) == "watch"
    end,
    youtube_playlist_url = function(url)
      return transf.path_url.path_component_by_initial(url) == "playlist"
    end,
    youtube_channel_url = function(url)
      return transf.path_url.path_component_by_initial(url) == "channel"
    end,
    youtube_playable_url = function(url)
      return is.youtube_url.youtube_video_url(url) or is.youtube_url.youtube_playlist_url(url)
    end,
    youtube_video_feed_url = function(url)
      return transf.url.local_absolute_path_or_nil_by_path(url) = "/feed/videos.xml"
    end,
  },
  youtube_video_feed_url ={
    youtube_channel_video_feed_url = function (url)
      local params = transf.url.str_key_str_value_assoc_by_decoded_param_table(url)
      return params.channel_id ~= nil
    end,
    youtube_playlist_video_feed_url = function (url)
      local params = transf.url.str_key_str_value_assoc_by_decoded_param_table(url)
      return params.playlist_id ~= nil
    end,
  },
  data_url = {
    base64_data_url = function(url)
      return get.str.bool_by_endswith(transf.data_url.urlcharset_str_by_header_part(url), ";base64")
    end,
    image_data_url = function(url)
      return is.media_type.image_media_type(transf.data_url.content_type(url))
    end,
  },
  media_type = {
    image_media_type = function(media_type)
      return get.str.bool_by_startswith(media_type, "image/")
    end,
  },
  source_id = {
    active_source_id = function(source_id)
      return hs.keycodes.currentSourceID() == source_id
    end,
  },
  number = {
    pos_number = function(num)
      return num >= 0
    end,
    neg_number = function(num)
      return num < 0
    end,
    zero = function(num)
      return num == 0
    end,
    int = function(num)
      return math.floor(num) == num 
    end,
    float = function(num)
      return not is.number.int(num)
    end,
    inclusive_proper_fraction = function(num)
      return num >= 0 and num <= 1
    end,
  },
  inclusive_proper_fraction = {
    proper_fraction = function(num)
      return num > 0 and num < 1
    end,
  },
  int = {
    even_int = function(num)
      return num % 2 == 0
    end,
    pos_int = function(num)
      return num >= 0
    end,
    neg_int = function(num)
      return num < 0
    end,
    timestamp_s = transf["nil"]["true"], -- all integers are valid timestamps (s)
    timestamp_ms = transf["nil"]["true"], -- all integers are valid timestamps (ms)
  },
  float = {
    pos_float = function(num)
      return num >= 0
    end,
    neg_float = function(num)
      return num < 0
    end,
  },
  timestamp_s = {
    reasonable_timestamp_s = function(num)
      return num > 1e7 and num < 1e10
    end,
  },
  timestamp_ms = {
    reasonable_timestamp_ms = function(num)
      return num > 1e10 and num < 1e13
    end,
  },
  pos_int = {
    hydrus_file_id = function(num)
      return true
    end,
    eightbyte_pos_int = function(num)
      return num < 2^64
    end,
  },
  eightbyte_pos_int = {
    fourbyte_pos_int = function(num)
      return num < 2^32
    end,
  },
  fourbyte_pos_int = {
    twobyte_pos_int = function(num)
      return num < 2^16
    end,
  },
  twobyte_pos_int = {
    byte_pos_int = function(num)
      return num < 2^8
    end,
  },
  byte_pos_int = {
    halfbyte_pos_int = function(num)
      return num < 128
    end,
  },
  halfbyte_pos_int = {
    percentage_pos_int = function(num)
      return num <= 100
    end,
  },
  percentage_pos_int = {
    nibble_pos_int = function(num)
      return num < 16
    end,
    iso_weeknumber_int = function(num)
      return num >= 1 and num <= 53
    end,
  },
  nibble_pos_int = {
    sme_10_pos_int = function(num)
      return num <= 10
    end,
  },
  sme_10_pos_int = {
    sme_8_pos_int = function(num)
      return num <= 8
    end,
  },
  sme_8_pos_int = {
    sme_7_pos_int = function(num)
      return num <= 7
    end,
  },
  sme_7_pos_int = {
    sme_6_pos_int = function(num)
      return num <= 6
    end,
    weekday_int_start_1 = function(num)
      return num >= 1 
    end,
  },
  sme_6_pos_int = {
    weekday_int_start_0 = transf["nil"]["true"],
    date_component_index = transf["nil"]["true"],
    sme_5_pos_int = function(num)
      return num <= 5
    end,
    zero = function(num)
      return num == 0
    end,
    one = function(num)
      return num == 1
    end,
  },
  sme_5_pos_int = {
    sme_4_pos_int = function(num)
      return num <= 4
    end,
  },
  sme_4_pos_int = {
    sme_3_pos_int = function(num)
      return num <= 3
    end,
  },
  mult_anys = {
    one_to_three_anys = function(...)
      return transf.n_anys.int_by_amount(...) >= 1 and transf.n_anys.int_by_amount(...) <= 3
    end,
  },
  one_to_three_anys = {
    two_anys = function(...)
      return transf.n_anys.int_by_amount(...) == 2
    end,
    three_anys = function(...)
      return transf.n_anys.int_by_amount(...) == 3
    end,
    one_to_three_numbers = function(...)
      return get.arr.bool_by_all(
        transf.n_anys.arr(...),
        is.any.number
      )
    end,
  },
  one_to_three_numbers = {
    one_to_three_pos_ints = function(...)
      return get.arr.bool_by_all(
        transf.n_anys.arr(...),
        is.number.pos_int
      )
    end,
  },
  one_to_three_pos_ints = {
    dtprts = transf["nil"]["true"]
  },
  two_anys = {
    two_numbers = function(a, b)
      return  is.any.number(a) and is.any.number(b)
    end,
    two_strs = function(a, b)
      return  is.any.str(a) and is.any.str(b)
    end,
    two_arrs = function(a, b)
      return  is.any.arr(a) and is.any.arr(b)
    end,
    any_and_arr = function(a, b)
      return is.any.arr(b)
    end,
    arr_and_any = function(a, b)
      return is.any.arr(a)
    end,
    arr_or_nil_and_any = function(a, b)
      return is.any.arr_or_nil(a)
    end,
  },
  two_strs = {
    snake_case_and_str = function(a, b)
      return is.str.snake_case(a)
    end,
  },
  three_anys = {
    three_strs = function(a, b, c)
      return is.any.str(a) and is.any.str(b) and is.any.str(c)
    end,
    number_and_two_anys = function(a, b, c)
      return is.any.number(a)
    end,
  },
  three_strs = {
    rfc3339like_y_and_rfc3339like_ym_and_rfc3339like_ymd = function(a, b, c)
      return is.str.year(a) and is.str.rfc3339like_ym(b) and is.str.rfc3339like_ymd(c)
    end,
  },
  any = {
    fn = function(val)
      return  type(val) == "function"
    end,
    number = function(val)
      return type(val) == "number"
    end,
    str = function(val)
      return type(val) == "string"
    end,
    table = function(val)
      return type(val) == "table"
    end,
    primitive = function(val)
      return not is.any.table(val)
    end,
    ["nil"] = function(val)
      return val == nil
    end,
    not_int = function(val)
      return not is.any.int(val)
    end,
    userdata = function(val)
      return type(val) == "userdata"
    end,
    bool = function(val)
      return type(val) == "boolean"
    end,
    lower_alphanum_underscore_or_lower_alphanum_underscore_arr_ = function(val)
      return is.any.lower_alphanum_underscore(val) or is.any.lower_alphanum_underscore_arr(val)
    end,
    not_userdata_o_fn = function(val)
      return not is.any.userdata(val) and not is.any.fn(val)
    end,
    having_metatable = function(val)
      return getmetatable(val) ~= nil
    end,
    operational_comparable = function(val)
      return is.any.number(val) or is.any.metatable_comparable(val) 
    end,
    operational_addable = function(val)
      return is.any.number(val) or is.any.metatable_addable(val)
    end,
    operational_addcompable = function(val)
      return is.any.operational_addable(val) and is.any.operational_comparable(val)
    end,

  },
  not_userdata_o_fn = {
    not_userdata_fn_even_nested = transf["nil"]["true"], -- the way to check this would be to iterate through keys and values, possibly recursively, and check that none of them are userdata or fn. But the performance cost isn't worth it. ≙ marshalable with shelve
  },
  not_userdata_fn_even_nested = {
    not_userdata_o_fn_even_nested_notblkeytblval = transf["nil"]["true"], -- see above + testing keys for being tables. ≙ yaml convertable
  },
  not_userdata_o_fn_even_nested_notblkeytblval = {
    not_userdata_o_fn_even_nested_only_pos_int_or_str_key_table = transf["nil"]["true"], -- see above + testing keys for only being pos ints or strs. ≙ json convertable
  },
  bool = {
    ["true"] = function(val)
      return val == true
    end,
    ["false"] = function(val)
      return val == false
    end,
  },
  having_metatable = {
    metatable_comparable = function(val)
      local mt = getmetatable(val)
      return mt.__lt and mt.__le and mt.__eq -- currently we're not distinguishing between subtypes of operational_comparable (partially ordered, totally ordered, etc), and so we require all three relations to be defined
    end,
    metatable_addable = function(val)
      local mt = getmetatable(val)
      return mt.__add
    end,
  },
  auth_pass_item_name = {
    passw_pass_item_name = function(name)
      return get.auth_pass_item_name.bool_by_exists_as(name, "passw")
    end,
    username_pass_item_name = function(name)
      return get.auth_pass_item_name.bool_by_exists_as(name, "username", "txt")
    end,
    recovery_pass_item_name = function(name)
      return get.auth_pass_item_name.bool_by_exists_as(name, "recovery")
    end,
    otp_pass_item_name = function(name)
      return get.auth_pass_item_name.bool_by_exists_as(name, "otp")
    end,
    secq_pass_item_name = function(name)
      return get.pass_iauth_pass_item_nametem_name.bool_by_exists_as(name, "secq")
    end,
    login_pass_item_name = function(name)
      return 
        is.pass_item_name.passw_pass_item_name(name) or
        is.pass_item_name.username_pass_item_name(name)
    end,


  },
  mac_application_name = {
    running_mac_application_name = function(name)
      return get.mac_application_name.running_application(name) ~= nil
    end,
    jxa_browser_name = function(name)
      return get.arr.bool_by_contains(ls.jxa_browser_name_arr, name)
    end,
    jxa_tabbable_name = function(name)
      return get.arr.bool_by_contains(ls.jxa_tabbable_name_arr, name)
    end,
    jxa_browser_tabbable_name = function(name)
      return is.mac_application_name.jxa_browser_name(name) and is.mac_application_name.jxa_tabbable_name(name)
    end,
  },
  table = {
    empty_table = function(t)
      for k, v in transf.table.kt_vt_stateless_iter(t) do
        return false
      end
      return true
    end,
    non_empty_table = function(t)
      return not is.table.empty_table(t)
    end,
    only_pos_int_key_table = function(t)
      for k, v in transf.table.kt_vt_stateless_iter(t) do
        if not is.any.pos_int(k) then return false end
      end
      return true
    end,
    assoc = transf["nil"]["true"],
    thing_name_hierarchy = function(t)
      return t == thing_name_hierarchy
    end
  },
  empty_table = {
    nil_singleton = function(t)
      return t == consts.nil_singleton
    end,
    use_singleton = function(t)
      return t == consts.use_singleton
    end,
  },
  only_pos_int_key_table = {
    --- an empty only_pos_int_key_table is never a hole_y_arrlike and always an arr
    hole_y_arrlike = function(only_pos_int_key_table)
      if #only_pos_int_key_table == 0 then return false end
      for i = 1, #only_pos_int_key_table do
        if only_pos_int_key_table[i] == nil then return true end
      end
      return false
    end,
    arr = function(only_pos_int_key_table)
      return not is.only_pos_int_key_table.hole_y_arrlike(only_pos_int_key_table)
    end,
  },
  arr = {
    set = function(arr)
      local seen_vals = {}
      for k, v in transf.arr.kt_vt_stateless_iter(arr) do
        if seen_vals[v] then return false end 
        seen_vals[v] = true
      end
      return true
    end,
    any_arr = transf["nil"]["true"],
    mult_anys__arr = transf["nil"]["true"],
    dcmp_name_seq = function(arr)
      return is.any_arr.dcmp_name_arr(arr) 
        and get.arr.bool_by_is_sorted(
          arr,
          transf.two_dcmp_names.bool_by_first_larger
        )
    end,
  },
  dcmp_name_seq = {
    cont_dcmp_name_seq = function(arr)
      local expected_idx = tblmap.dcmp_name.date_component_index[arr[1]]
      for i = 2, #arr do
        expected_idx = expected_idx + 1
        if tblmap.dcmp_name.date_component_index[arr[i]] ~= expected_idx then return false end
      end
      return true
    end
  },
  cont_dcmp_name_seq = {
    prefix_dcmp_name_seq = function(arr)
      return arr[1] == "year"
    end,
    suffix_dcmp_name_seq = function(arr)
      return arr[#arr] == "sec"
    end,
  },
  set = {
    set_set = function(set)
      return is.any.set_arr(set)
    end,
  },
  non_empty_table = {
    has_id_key_table = function(t)
      return t.id ~= nil
    end,
    has_index_key_table = function(t)
      return t.index ~= nil
    end,
    created_item_specifier = function(t)
      return
        t.inner_item and t.creation_specifier
    end,
    creation_specifier = function(t)
      return
        t.type
    end,
    audiodevice_specifier = function(t)
      return
        t.device and t.subtype
    end,
    geojson_obj = function(t)
      return
        t.type
    end,
    csl_table = function(t)
      return
    end,
    input_spec = function(t)
      return
        t.mouse_button_char or t.key or t.target_point
    end,
    unicode_prop_table = function(t)
      return
        t.cpoint
    end,
    path_leaf_specifier = function(t)
      return t.extension or t.path or t.rfc3339like_dt_o_interval or t.general_name or t.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc
    end,
    intra_file_location_spec = function(t)
      return t.path and t.line
    end,
    prompt_args_spec = function(t)
      return t.message or t.default
    end,
    dcmp_spec = function(t)
      return t.year or t.month or t.day or t.hour or t.min or t.sec
    end,
    semver_component_specifier = function(t)
      return t.major
    end,
    email_specifier = function(t)
      return t.non_inline_attachment_local_file_arr or t.body or t.subject or t.to or t.cc or t.bcc or t.from
    end,
    gpt_response_table = function(t)
      return t.choices
    end,
    syn_specifier = function(t)
      return t.synonyms or t.antonyms
    end,
    iban_data_spec = function(t)
      return t.bankName or t.bic 
    end,
    ical_spec = function(t)
      return t.VCALENDAR
    end,
    role_content_message_spec = function(t)
      return t.role and t.content
    end,
    tree_node = function(t)
      return t.children and t.label
    end,
    val_dep_spec = function(t)
      return t.value and t.dependencies
    end,
    str_format_part_specifier = function(t)
      return t.str_format_part or t.value or t.fallback
    end,
    contact_table = function(t)
      return t.uid
    end,
    address_table = function(t)
      return t.contact or t.Box or t.Extended or t.Street or t.Code or t.City or t.Region or t.Country
    end,
    youtube_api_item = function(t)
      return t.kind
    end,
    vdirsyncer_pair_specifier = function(t)
      return t.local_storage_path and t.local_storage_type
    end,
    url_components = function(t)
      return t.scheme or t.host or t.endpoint or t.params or t.url or t.nofragment_url or t.clean_url or t.base_url
    end,
    csl_person = function(t)
      return t.family or t.given or t["dropping-particle"] or t["non-dropping-particle"] or t.suffix or t.literal
    end,
    reaction_spec = function(t)
      return t.emoji and t.count
    end,
    export_chat_main_object = function(t)
      return t.messages
    end,
    telegram_export_chat_message = function(t)
      return t.date_unixtime and t.from and t.text
    end,
    discord_export_chat_message = function(t)
      return t.timestamp and t.bar and t.content -- bar is still here as a placeholder because str_by_author isn't implemented yet
    end,
    facebook_export_chat_message = function(t)
      return t.timestamp_ms and t.sender_name and t.content
    end,
    signal_export_chat_message = function(t)
      return t.sent_at and t.body
    end,
    fn_queue_specifier = function(t)
      return t.fn_arr and t.hotkey_created_item_specifier
    end,
    n_shot_llm_spec = function(t)
      return t.query and t.input
    end,
    prompt_spec = function(t)
      return t.prompter
    end,
    hs_geometry_point_like = function(t)
      return t.x and t.y
    end,
    hs_geometry_size_like = function(t)
      return t.w and t.h
    end,
    hs_geometry_rect_like = function(t)
      return t.x and t.y and t.w and t.h
    end,
    hs_geometry = function(t)
      return t.angleTo ~= nil
    end,
    form_filling_specifier = function(t)
      return t.in_fields and t.form_fields and t.explanations
    end,
    timer_spec = function(t)
      return t.next_timestamp_s
    end,
    retriever_specifier = function(t)
      return t.thing_name
    end,
    action_specifier = function(t)
      return t.d and (t.getfn or t.dothis)
    end,
    chooser_item_specifier = function(t)
      return t.text
    end,
    menu_item_table = function(t)
      return t.AXTitle
    end,
    jxa_windowlike_specifier = function(t)
      return t.application_name and t.window_index
    end,
    detailed_env_node = function(t)
      return t.value
    end,
    hschooser_specifier = function(t)
      return t.chooser_item_specifier_arr
    end,
    choosing_hschooser_specifier = function(t)
      return t.key_name and t.tbl and t.hschooser_specifier
    end,
    url_table = function(t)
      return t.scheme
    end,
    total_cost_specifier = function(t)
      return t.total and t.price_specifier_arr
    end,
    price_specifier = function(t)
      return t.amount and t.unit and t.rate and t.price
    end,
    msg_spec = function(t)
      return t.author and t.content
    end,
    path_key_haver = function(t)
      return t.path
    end,
    cut_specifier = function(t)
      return t.start or t.stp
    end,
    location_log_spec = function(t)
      return t.lat and t.long
    end,
    timestamp_ms_key_haver = function(t)
      return t.timestamp_ms
    end,
    hydrus_rel_spec = function(t)
      return t.sib and t.parent
    end,
    plist_single_dk_spec = function(t)
      return t.domain and t.key
    end,
    hydrus_metadata_spec = function(t)
      return t.hash
    end,
    hydrus_internal_tag_spec = function(t)
      return t.storage_tags and t.display_tags
    end,
    hydrus_url_spec = function(t)
      return t.normalised_url and t.url_type
    end,
    danbooru_tag_record = function(t)
      return t.id and t.name and t.category and t.post_count -- there are more, but this should be enough
    end,
    danbooru_tag_implication_record = function(t)
      return t.id and t.antecedent_name and t.consequent_name
    end,
    danbooru_hydrus_inference_specifier = function(t)
      return t.danbooru_tags and t.result
    end,
    composite_tag_specifier = function(t)
      return t.parts
    end,
    bin_specifier = function(t)
      return t.vt ~= nil and t.vf ~= nil
    end,
    keymap_spec = function(t)
      return t.map and t.modifiers
    end,
    
  },
  plist_single_dk_spec = {
    plist_single_dkv_spec = function(t)
      return t.value ~= nil
    end,
  },
  geojson_obj = {
    geojson_feature_collection = function(t)
      return t.type == "FeatureCollection"
    end,
    geojson_feature = function(t)
      return t.type == "Feature"
    end,
  },
  timestamp_ms_key_haver = {
    media_log_spec = function(t)
      return t.title and t.url
    end,
  },
  location_log_spec = {
    old_location_log_spec = function(t)
      return t.dt
    end,
  },
  cut_specifier = {
    interval_specifier = function(t)
      return t.start and t.stop
    end,
  },
  jxa_windowlike_specifier = {
    jxa_tab_specifier = function(t)
      return t.tab_index
    end,
    jxa_window_specifier = function(t)
      return not is.jxa_windowlike_specifier.jxa_tab_specifier(t)
    end,
    browser_jxa_windowlike_specifier = function(t)
      return is.mac_application_name.jxa_browser_name(
        t.application_name
      )
    end,
  },
  jxa_tab_specifier = {
    browser_jxa_tab_specifier = function(t)
      return is.jxa_windowlike_specifier.browser_jxa_windowlike_specifier(t)
    end,
  },
  jxa_window_specifier = {
    tabbable_jxa_window_specifier = function(t)
      return is.mac_application_name.jxa_tabbable_name(
        t.application_name
      )
    end,
  },
  tabbable_jxa_window_specifier = {
    browser_tabbable_jxa_window_specifier = function(t)
      return is.jxa_windowlike_specifier.browser_jxa_windowlike_specifier(t)
    end,
  },
  chooser_item_specifier = {
    index_chooser_item_specifier = function(t)
      return t.index
    end,
  },
  retriever_specifier = {
    partial_retriever_specifier = function(t)
      return t.target == nil
    end,
  },
  creation_specifier = {
    fireable_creation_specifier = function(t)
      return t.fn ~= nil
    end,
    task_creation_specifier = function(t)
      return t.args ~= nil
    end,
  },
  fireable_creation_specifier = {
    hotkey_creation_specifier = function(t)
      return t.key_input_spec
    end,
    watcher_creation_specifier = function(t)
      return t.watcher_container
    end,
    stream_creation_specifier = function(t)
      return t.urls
    end
  },
  hs_geometry_point_like = {
    hs_geometry_point = function(t)
      return is.non_empty_table.hs_geometry(t)
    end,
    point_spec = function(t)
      return not is.hs_geometry_point(t)
    end,
  },
  hs_geometry_size_like = {
    hs_geometry_size = function(t)
      return is.non_empty_table.hs_geometry(t)
    end,
    size_spec = function(t)
      return not is.hs_geometry_size(t)
    end,
  },
  hs_geometry_rect_like = {
    hs_geometry_rect = function(t)
      return is.non_empty_table.hs_geometry(t)
    end,
    rect_spec = function(t)
      return not is.hs_geometry_rect(t)
    end,
  },
  role_content_message_spec = {
    system_role_content_message_spec = function(t)
      return t.role == "system"
    end,
    user_role_content_message_spec = function(t)
      return t.role == "user"
    end,
    assistant_role_content_message_spec = function(t)
      return t.role == "assistant"
    end,
    function_role_content_message_spec = function(t)
      return t.role == "function"
    end,
  },
  export_chat_main_object = {
    telegram_export_chat_main_object = function(t)
      return t.name and t.id
    end,
    discord_export_chat_main_object = function(t)
      return t.channel
    end,
    facebook_export_chat_main_object = function(t)
      return t.title and t.thread_path
    end,
    signal_export_chat_main_object = function(t)
      return t.author
    end,
  },

  youtube_api_item = {
    youtube_video_item = function(t)
      return t.kind  == "youtube#video"
    end,
    youtube_caption_item = function(t)
      return t.kind  == "youtube#caption"
    end,
    youtube_playlist_item = function(t)
      return t.kind  == "youtube#playlist"
    end,
    youtube_channel_item = function(t)
      return t.kind  == "youtube#channel"
    end,
  },
  dcmp_spec = {
    full_dcmp_spec = function(t)
      return t.year and t.month and t.day and t.hour and t.min and t.sec
    end,
    partial_dcmp_spec = function(t)
      return not is.dcmp_spec.full_dcmp_spec(t)
    end,
    cont_dcmp_spec = function(t)
      return is.arr.dcmp_name_seq(
        transf.table.kt_arr(t)
      )
    end
  },
  cont_dcmp_spec = {
    prefix_dcmp_spec = function(t)
      return is.cont_dcmp_name_seq.prefix_dcmp_name_seq(
        transf.table.kt_arr(t)
      )
    end,
    suffix_dcmp_spec = function(t)
      return is.cont_dcmp_name_seq.suffix_dcmp_name_seq(
        transf.table.kt_arr(t)
      )
    end,
    prefix_partial_dcmp_spec = function(t)
      return is.cont_dcmp_spec.prefix_dcmp_spec(t) and is.dcmp_spec.partial_dcmp_spec(t)
    end,
    suffix_partial_dcmp_spec = function(t)
      return is.cont_dcmp_spec.suffix_dcmp_spec(t) and is.dcmp_spec.partial_dcmp_spec(t)
    end,
  },
  interval_specifier = {
    number_interval_specifier = function(t)
      return is.any.number(t.start) and is.any.number(t.stop)
    end,
    sequence_specifier = function(t)
      return t.step ~= nil
    end
  },
  number_interval_specifier = {
    int_interval_specifier = function(t)
      return is.number.int(t.start) and is.number.int(t.stop)
    end,
    number_sequence_specifier = function(t)
      return is.interval_specifier.sequence_specifier(t)
    end,
  },
  int_interval_specifier = {
    timestamp_s_interval_specifier = transf["nil"]["true"],
    pos_int_interval_specifier = function(t)
      return is.number.pos_int(t.start) and is.number.pos_int(t.stop)
    end,
  },
  pos_int_interval_specifier = {
    pos_int_sequence_specifier = function(t)
      return is.interval_specifier.sequence_specifier(t)
    end
  },
  timestamp_s_interval_specifier = {
    timestamp_s_sequence_specifier = function(t)
      return is.interval_specifier.sequence_specifier(t)
    end,
  },
  prompt_args_spec = {
    str_prompt_args_spec = function(t)
      return t.informative_text or t.buttonA or t.buttonB
    end,
    path_prompt_args_spec = function(t)
      return t.can_choose_files ~= nil or t.can_choose_directories ~= nil or t.multiple ~= nil or t.resolves_aliases ~= nil or t.allowed_file_types
    end
  },
  audiodevice_specifier = {
    active_audiodevice_specifier = function(spec)
      return spec.device == transf.audiodevice_type.audiodevice_by_default(spec.subtype)
    end,
  },
  csl_table = {
    whole_book_type_csl_table = function(csl_table)
      return csl_table.type == "book" or csl_table.type == "monograph"
    end,
    book_chapter_type_csl_table = function(csl_table)
      return csl_table.type == "chapter"
    end,
    whole_book_csl_table = function(csl_table)
      return is.csl_table.whole_book_type_csl_table(csl_table) and not csl_table.chapter and not csl_table.pages
    end
  },
  ipc_socket_id = {
    mpv_ipc_socket_id = function(mpv_ipc_socket_id)
      return get.ipc_socket_id.not_userdata_o_fn_or_nil_by_response(mpv_ipc_socket_id, {
        command = {"get_property", "pid"}
      }) ~= nil
    end,
  },
  created_item_specifier = {
    stream_created_item_specifier = function(t)
      return
        t.inner_item.ipc_socket_id ~= nil
    end,
    fireable_created_item_specifier = function(t)
      return t.creation_specifier.fn ~= nil
    end,
  },
  fireable_created_item_specifier = {
    hotkey_created_item_specifier = function(t)
      return t.creation_specifier.key_input_spec ~= nil
    end,
    watcher_created_item_specifier = function(t)
      return t.creation_specifier.watcher_container ~= nil
    end,
  },
  stream_created_item_specifier = {
    alive_stream_created_item_specifier = function(stream_created_item_specifier)
      return is.ipc_socket_id.mpv_ipc_socket_id(stream_created_item_specifier.inner_item.ipc_socket_id)
    end,
  },
  input_spec = {
    declared_input_spec = function(t)
      return t.mode
    end,
    click_input_spec = function(t)
      return t.mouse_button_char
    end,
    key_input_spec = function(t)
      return t.key
    end,
    position_change_input_spec = function(t)
      return t.target_point
    end,
  },
  declared_input_spec = {
    declared_click_input_spec = function(input_spec)
      return input_spec.mode == "click"
    end,
    declared_key_input_spec = function(input_spec)
      return input_spec.mode == "key"
    end,
    declared_move_input_spec = function(input_spec)
      return input_spec.mode == "move"
    end,
    declared_scroll_input_spec = function(input_spec)
      return input_spec.mode == "scroll"
    end,
    declared_position_change_input_spec = function(input_spec)
      return is.input_spec.declared_move_input_spec(input_spec) or is.input_spec.declared_scroll_input_spec(input_spec)
    end,
  },
  userdata = {
    full_userdata = function(val)
      return getmetatable(val) ~= nil
    end,
    light_userdata = function(val)
      return getmetatable(val) == nil
    end,
  },
  full_userdata = {
    window = function(val)
      return transf.full_userdata.str_by_classname(val) == "hs.window"
    end,
    running_application = function(val)
      return transf.full_userdata.str_by_classname(val) == "hs.application"
    end,
    hs_image = function(val)
      return transf.full_userdata.str_by_classname(val) == "hs.image"
    end,
    styledtext = function(val)
      return transf.full_userdata.str_by_classname(val) == "hs.styledtext"
    end,
    audiodevice = function(val)
      return transf.full_userdata.str_by_classname(val) == "hs.audiodevice"
    end,
    watcher = function(val)
      return val.start and val.stop
    end,
    hs_hotkey = function(val)
      return transf.full_userdata.str_by_classname(val) == "hs.hotkey"
    end,
    hs_screen = function(val)
      return transf.full_userdata.str_by_classname(val) == "hs.screen"
    end,
    window_filter = function(val)
      return transf.full_userdata.str_by_classname(val) == "hs.window.filter"
    end,
    hschooser = function(val)
      return transf.full_userdata.str_by_classname(val) == "hs.chooser"
    end,
  },
}

-- to allow for is.<type1>.<type2> where type2 is a descendant but not childtype of type1, we will use a metatable to search for the path from type1 to type2 by using thing_name_hierarchy, and then create a dynamic function that tests is.<type1>.<subtype> and is.<subtype>.<subtype2> and so on until we reach type2
-- to avoid code duplication we will resolve any call is.<type_a>_arr.<type_b>_arr to a dynamically generated function that calls get.arr.bool_by_all_pass_w_fn(arr, is.<type_a>.<type_b>)

local experimental_cache = {}


-- TODO this is not gonna work as-is, because we're assuming that type1 exists on `is`, but it might not. Therefore instead of iterating we need to add a __index metamethod to is

function get_nested_mt(type1)
  experimental_cache[type1] = {}
  local type1_ends__arr = get.str.bool_by_endswith(type1, "_arr")
  local type1_ends___arr = false
  local type1_noarr
  if type1_ends__arr then
    type1_noarr = string.sub(type1, 1, -5)
    if get.str.bool_by_endswith(type1_noarr, "_") then
      type1_noarr = string.sub(type1_noarr, 1, -2)
      type1_ends___arr = true
      type1_ends__arr = false
    end
  end

  -- NB: assoc handling will not work for _or_nested_value_assoc types, because of prohibitive complexity. _or_nested_value_assoc types may not be checked using `is` at all. Trying to will always result in false

  local type1_ends_assoc = get.str.bool_by_endswith(type1, "_assoc")
  local assoc_keytype, assoc_valuetype
  if type1 == "assoc" then
    assoc_keytype = "any"
    assoc_valuetype = "any"
  elseif type1_ends_assoc then
    assoc_keytype, assoc_valuetype = get.string.n_strs_by_extracted_onig(type1, r.g.assc_thing_name_by_extract_key_value)
    assoc_valuetype = assoc_valuetype or "any"
  end

  local type1_ends_or_nil = get.str.bool_by_endswith(type1, "_or_nil")

  local mt = {
    __index = function(t, type2)
      local fn = rawget(t, type2)
      if fn then 
        return fn
      end

      if type1_ends___arr and get.str.bool_by_endswith(type2, "__arr") then
        local type_b = string.sub(type2, 1, -6)
        return function(arr)
          return is[type1_noarr][type_b](transf.arr.n_anys(arr))
        end
      elseif type1_ends__arr and get.str.bool_by_endswith(type2, "_arr") then
        local type_b = string.sub(type2, 1, -5)
        return function(arr)
          return get.arr.bool_by_all_pass_w_fn(arr, is[type1_noarr][type_b])
        end
      elseif type1_ends_assoc and get.str.bool_by_endswith(type2, "_assoc") then
        local assoc_keytype_b, assoc_valuetype_b = get.string.n_strs_by_extracted_onig(type2, r.g.assc_thing_name_by_extract_key_value)
        return function(assoc)
          local retval = get.table.bool_by_all_keys_pass_w_fn(
            assoc,
            is[assoc_keytype][assoc_keytype_b]
          )
          if assoc_valuetype_b then
            retval = retval and get.table.bool_by_all_values_pass_w_fn(
              assoc,
              is[assoc_valuetype][assoc_valuetype_b]
            )
          end
          return retval
        end
      elseif type1 == "any" or type1_ends_or_nil and get.string.bool_by_endswith(type2, "_or_nil") then -- handle _or_nil cases automatically
        if type1 ~= "any" then
          type1 = string.sub(type2, 1, -8)
        end
        type2 = string.sub(type2, 1, -8)
        return function(val)
          return val == nil or is[type1][type2](val)
        end
      end
      
      return function(arg)
        local cache = experimental_cache[type1][type2]
        local now = os.time()
        if cache[now] and cache[now][arg] then
          return cache[now][arg]
        else
          local path = get.table.arr_or_nil_by_find_path_between_two_keys(
            thing_name_hierarchy,
            type1,
            type2
          )
          local res = get.thing_name_arr.bool_by_chained_and(path, arg)
          experimental_cache[type1][type2][now] = {[arg] = res}
          return res
        end
      end
    end
  }
  return mt
end

for type1, v in pairs(is) do
  local mt = get_nested_mt(type1)
  setmetatable(v, mt)
end

local is_mt = {
  __index = function(t, type1)
    local nested_tbl = rawget(t, type1)
    if nested_tbl then
      return nested_tbl
    else
      local mt = get_nested_mt(type1)
      local nested_tbl = {}
      setmetatable(nested_tbl, mt)
      rawset(t, type1, nested_tbl)
      return nested_tbl
    end
  end
}

setmetatable(is, is_mt)
