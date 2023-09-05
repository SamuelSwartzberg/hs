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
    ascii_str = function(str)
      return get.str.bool_by_matches_whole_onig_w_regex_character_class_innards(str, r.g.char_range.ascii)
    end,
    line = function(str)
      return get.str.bool_by_not_matches_part_eutf8(str, "[\n\r]")
    end,
    json_str = transf["nil"]["true"], -- figuring this out would require parsing the json, which is too expensive here
    yaml_str = transf["nil"]["true"], -- same as above
    email_or_displayname_email = function(str)
      return is.str.email(str) or is.str.displayname_email(str)
    end,

  },
  not_empty_str = {
    
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
      return get.str.bool_by_matches_whole_onig(str, r.g.rough_input_spec_str) -- we're calling onig on a str which we are not sure is ascii. I'm not sure how problematic this is, since I've forgotten whether onig just doesn't implement any specific behavior for non-ascii chars, or if actually sees them as the ascii chars the utf8 corresponds to. Either way, worst comes the worst it'd result in a few false positives, which is fine.
    end,
    input_spec_series_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, " *(?:" .. r.g.rough_input_spec_str .. ")(?: *\\n *(?:" .. r.g.rough_input_spec_str .. "))* *")
    end
    
    
  },
  multiline_str = {
    here_doc = function(str)
      return get.str.bool_by_startswith(str, "<<EOF") and get.str.bool_by_endswith(str, "EOF") -- technically obviously it doesn't have to be EOF, but I'm only ever gonna use EOF
    end,
    raw_contact = transf["nil"]["true"]
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
    comment_line = function(str)
      return get.str.bool_by_matches_part_eutf8(str, "^%s*#")
    end,
    nocomment_line = function(str)
      return not is.line.comment_line(str)
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

    -- combined conditions

    noempty_nocomment_line = function(str)
      return is.line.noempty_line(str) and is.line.nocomment_line(str)
    end,
    noempty_nocomment_noindent_line = function(str)
      return is.line.noempty_nocomment_line(str) and is.line.noindent_line(str)
    end,
    trimmed_line = function(str)
      return is.line.noindent_line(str) and is.line.notrailing_whitespace_line(str)
    end,

  },
  noweirdwhitespace_line = {
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
        get.str.bool_by_contains_w_ascii_str(str, "!citid:")
    end
  },
  trimmed_line = {
    displayname_email = function(str)
      return get.str.bool_by_matches_whole_eutf8(str, ".- <.-@.+>")
    end,
   
  },
  trimmed_noweirdwhitespace_line = {
    path = function(str)
      return get.str.bool_by_contains_w_ascii_str(str, "/")
    end
  },

  ascii_str = {
    printable_ascii_str = function(str)
      return get.str.bool_by_matches_whole_onig_w_regex_character_class_innards(str, r.g.char_range.printable_ascii)
    end,
    ascii_char = function(str)
      return #str == 1
    end,
  },
  ascii_char = {
    base_letter = function(str)
      return get.arr.bool_by_contains(ls.base_letters, str)
    end
  },
  printable_ascii_str = {
    printable_ascii_no_nonspace_whitespace_str = function(str)
      return get.str.bool_by_not_matches_part_eutf8(str, "[\t\v\f]")
    end,
    iban = function(str)
      local cleaned_iban = transf.iban.cleaned_iban(str)
      return #cleaned_iban <= 34 and is.printable_ascii_str.alphanum(cleaned_iban)
    end,
  },
  printable_ascii_no_nonspace_whitespace_str = {
    fnname = transf["nil"]["true"],
    single_attachment_str = function(str)
      return 
        get.str.bool_by_startswith(str, "#") 
        and get.str.bool_by_matches_part_onig(str, "^#" .. r.g.id.media_type .. " ")
    end,
    printable_ascii_not_whitespace_str = function(str)
      return get.str.bool_by_not_matches_part_eutf8(str, "%s")
    end,
    url = function(str)
      return get.fn.rt_or_nil_by_memoized(
        transf.str.bool_by_evaled_env_bash_success,
        {},
        "is.printable_ascii_str.url")(
        "url_parser_cli " .. transf.str.str_by_single_quoted_escaped(str)
      )
    end,
    urllike_with_no_scheme = function(str)
      return is.printable_ascii_no_nonspace_whitespace_str.url("https://" .. str)
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
    
    html_entity = function(str)
      return #str > 20 and get.str.bool_by_startswith(str, "&") and get.str.bool_by_endswith(str, ";") and get.str.bool_by_matches_whole_onig(str, r.g.html_entity) -- the earlier checks are technically unncessary but improve performance
    end,
    fs_tag_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.fs_tag_str)
    end,
    media_type = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.id.media_type)
    end,
    base64_gen_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.b.b64.gen)
    end,
    base64_url_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.b.b64.url)
    end,
    base64_str = function(str)
      return is.printable_ascii_not_whitespace_str.base64_gen_str(str) or is.printable_ascii_not_whitespace_str.base64_url_str(str)
    end,
    handle = function(str)
      return get.str.bool_by_startswith(str, "@")
    end,
    --- trying to determine what str is and is not an email is a notoriously thorny problem. In our case, we don't care much about false positives, but want to avoid false negatives to a certain extent.
    email = function(str)
      return 
        get.str.bool_by_contains_w_ascii_str(str, "@") and
        get.str.bool_by_contains_w_ascii_str(str, ".")
    end,
    dice_notation = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.syntax.dice)
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
    doi = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.id.doi)
    end,
    colon_period_alphanum_minus_underscore = function(str)
      return get.str.bool_by_not_matches_part_eutf8(str, "[^%w%-_:.]")
    end,
    semver_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.version.semver)
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
    indicated_isbn_part_identifier = function(str)
      return get.str.bool_by_startswith(str, "isbn_part:")
    end,
    indicated_pcmid = function(str)
      return get.str.bool_by_startswith(str, "pmcid:")
    end,
    indicated_accession = function(str)
      return get.str.bool_by_startswith(str, "accession:")
    end,
    indicated_issn_full_identifier = function(str)
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
        is.printable_ascii_not_whitespace_str.indicated_isbn_part_identifier(str) or
        is.printable_ascii_not_whitespace_str.indicated_pcmid(str) or
        is.printable_ascii_not_whitespace_str.indicated_accession(str) or
        is.printable_ascii_not_whitespace_str.indicated_issn_full_identifier(str) or
        is.printable_ascii_not_whitespace_str.indicated_urlmd5(str)
    end
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
  },
  period_alphanum_minus_underscore = {
    nonindicated_number_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, "-?[0-9a-fA-F]+(:?\\.[0-9a-fA-F]+)?")
    end,
    indicated_number_str = function(str)
      return 
        get.str.bool_by_startswith(str, "0") and
        get.arr.bool_by_contains(transf.table_or_nil.kt_arr(tblmap.base_letter.pos_int_by_base), str:sub(2, 2)) and
        is.printable_ascii_str.nonindicated_number_str(str:sub(3))
    end,
    domain_name = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.id.domain_name)
    end,
    ipv4_address = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.ipv4)
    end,
  },
  indicated_number_str = {
    indicated_bin_number_str = function(str)
      return get.str.bool_by_startswith(str, "0b")
    end,
    indicated_hex_number_str = function(str)
      return get.str.bool_by_startswith(str, "0x")
    end,
    indicated_oct_number_str = function(str)
      return get.str.bool_by_startswith(str, "0o")
    end,
    indicated_dec_number_str = function(str)
      return get.str.bool_by_startswith(str, "0d")
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
  },
  colon_alphanum_minus_underscore = {
    alphanum_minus_underscore = function(str)
      return get.str.bool_by_not_contains_w_str(str, ":")
    end,
    calendar_name = function(str)
      return get.arr.bool_by_contains(
        transf["nil"].calendar_name_arr(),
        str
      )
    end,
    twod_locator = function(str)
      return get.str.bool_by_matches_whole_onig(str, ":\\d+(:?:\\d+)?")
    end,
    ipv6 = function(str)
      return get.str.bool_by_matches_whole_onig_w_regex_character_class_innards(str, "a-fA-F0-9:") -- naive check because the actual regex is a monster
    end
  },
  calendar_name = {
    writeable_calendar_name = function(name)
      return get.str.bool_by_not_startswith(name, "r-:")
    end,
  },
  alphanum_minus = {
    isbn10 = function(str)
      return get.str.bool_by_matches_whole_onig(transf.alphanum_minus.alphanum_by_remove(str), r.g.id.isbn10)
    end,
    isbn13 = function(str)
      return get.str.bool_by_matches_whole_onig(transf.alphanum_minus.alphanum_by_remove(str), r.g.id.isbn13)
    end,
    isbn = function(str)
      return is.alphanum_minus.isbn10(str) or is.alphanum_minus.isbn13(str)
    end,
    issn = function(str) 
      return get.str.bool_by_matches_whole_onig(str, r.g.id.issn)
    end,
    uuid = function(str)
      return get.str.bool_by_matches_whole_onig(transf.str.str_by_all_eutf8_lower(str), r.g.id.uuid)
    end,
    relay_identifier = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.id.relay_identifier)
    end,
    ipc_socket_id = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.id.ipc_socket_id)
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
    
  },
  lower_alphanum_minus = {
    git_remote_type = function(str)
      return get.arr.bool_by_contains(
        ls.git_remote_types,
        str
      )
    end,
  },
  uuid = {
    contact_uuid = function(uuid)
      local succ, res = pcall(transf.uuid.raw_contact, uuid)
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
      return get.arr.bool_by_contains(ls.youtube.extant_upload_status, transf.youtube_video_id.upload_status(id))
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
      return get.arr.bool_by_contains(ls.useless_files, transf.path.leaflike_by_leaf(path))
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
      return get.str.bool_by_startswith(path, env.MPAPERS)
    end,
    mcitations_citable_local_absolute_path = function(path)
      return get.str.bool_by_startswith(path, env.MCITATIONS)
    end,
    mpapernotes_citable_local_absolute_path = function(path)
      return get.str.bool_by_startswith(path, env.MPAPERNOTES)
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
      return get.str.not_userdata_or_function_or_nil_by_evaled_env_bash_parsed_json_in_key("rclone lsjson --stat" .. transf.str.str_by_single_quoted_escaped(path))
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
        get.str.bool_by_startswith_any_w_ascii_str_arr(
          path,
          {
            "./",
            "../",
            "/./",
            "/../",
          }
        ) or 
        get.str.bool_by_contains_any_w_ascii_str_arr(
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
    owner_item_path = function(path)
      return get.str.pos_int_by_amount_contained_nooverlap(path, "@")
    end,
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
      return get.str.bool_by_startswith(path, env.HOME)
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
      return get.str.bool_by_startswith(path, env.ME)
    end,
    in_cache_local_absolute_path = function(path)
      return get.str.bool_by_startswith(path, env.XDG_CACHE_HOME)
    end,
    in_tmp_local_absolute_path = function(path)
      return get.str.bool_by_startswith(path, env.TMPDIR)
    end,
  },
  in_me_local_absolute_path = {
    in_mcitations_absolute_path = function(path)
      return get.str.bool_by_startswith(path, env.MCITATIONS)
    end,
    in_mpapers_absolute_path = function(path)
      return get.str.bool_by_startswith(path, env.MPAPERS)
    end,
  },
  in_volume_local_absolute_path = {
    
  },
  volume_local_extant_path = {
    
    dynamic_time_machine_volume_local_extant_path = function(path)
      return get.str.bool_by_startswith(
        path,
        "/Volumes/com.apple.TimeMachine.localsnapshots/Backups.backupdb/" .. get.fn.rt_or_nil_by_memoized(hs.host.localizedName)() .. "/" .. os.date("%Y-%m-%d-%H")
      )
    end,
    static_time_machine_volume_local_extant_path = function(path)
      return path == env.TMBACKUPVOL .. "/"
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
  },
  dotapp_dir = {
    installed_app_dir = function(path)
      return get.str.bool_by_startswith(path, "/Applications/")
    end,
  },
  nonempty_local_dir = {
    latex_project_dir = function(dir)
      return get.dir.bool_by_leaf_of_child(dir, "main.tex")
    end,
    omegat_project_dir = function(dir)
      return get.dir.bool_by_leaf_of_child(dir, "omegat.project")
    end,
    npm_project_dir = function(dir)
      return get.dir.bool_by_leaf_of_child(dir, "package.json")
    end,
    cargo_project_dir = function(dir)
      return get.dir.bool_by_leaf_of_child(dir, "Cargo.toml")
    end,
    sass_project_dir = function(dir)
      return get.dir.bool_by_extension_of_child(dir, "sass")
    end,
    project_dir = function(dir)
      return is.dir.latex_project_dir(dir) or is.dir.omegat_project_dir(dir) or is.dir.npm_project_dir(dir) or is.dir.cargo_project_dir(dir) or is.dir.sass_project_dir(dir)
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
    git_root_dir = function(path)
      return get.arr.bool_by_some_equals_w_t(
        transf.dir.leaflike_arr_by_children_filenames(path),
        ".git"
      )
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
  nonempty_dir = {
    grandparent_dir = function (path)
      return get.arr.bool_by_some_pass_w_fn(
        transf.dir.absolute_path_arr_by_children(path),
        is.absolute_path.dir
      )
    end,
  },
  in_git_dir = {
    in_has_changes_git_dir = function(path)
      return transf.in_git_dir.str_by_status(path) ~= ""
    end,
    in_has_unpushed_commits_git_dir = function(path)
      return #transf.in_git_dir.unpushed_commit_hash_list(path) > 0
    end,
  },
  file = {
    plaintext_file = function(path)
      error("TODO")
    end,
    image_file = function(path)
      return get.path.usable_as_filetype(path, "image")
    end,
    bin_file = function(path)
      return not is.file.plaintext_file(path)
    end,
    email_file = function(path)
      return 
       get.path.is_extension(path, "eml") or 
       transf.path.path_component_or_nil_by_parent_leaf(path) == "new" or
       transf.path.path_component_or_nil_by_parent_leaf(path == "cur")
     end,
  },
  bin_file = {
    db_file = function(path)
      return get.path.is_standartized_extension_in(
        path,
        ls.filetype["db"]
      )
    end,
    playable_file = function (path)
      return get.path.usable_as_filetype(path, "audio") or get.path.usable_as_filetype(path, "video")
    end,
  },
  playable_file = {
    whisper_file = function(path)
      return get.path.usable_as_filetype(path, "whisper-audio")
    end,
  },
  shellscript_file = {
    shellscript_file_with_errors = function(path)
      return transf.shellscript_file.gcc_str_errors(path) ~= ""
    end,
    shellscript_file_with_warnings = function(path)
      return transf.shellscript_file.gcc_str_warnings(path) ~= ""
    end,
  },
  plaintext_file = {
    shellscript_file = function(path)
      return get.path.usable_as_filetype(path, "shell-script") 
      or get.str.bool_by_matches_part_onig(
        transf.file.str_by_contents(path),
        "^#!.*?(?:ba|z|fi|da|k|t?c)sh\\s+"
      )
    end,
    plaintext_assoc_file = function(path)
      get.path.is_standartized_extension_in(
        path,
        ls.filetype["plaintext-dictionary"]
      )
    end,
    plaintext_table_file = function(path)
      get.path.is_standartized_extension_in(
        path,
        ls.filetype["plaintext-table"]
      )
    end,
    m3u_file = function(path)
      return get.path.is_extension(path, "m3u")
    end,
    gitignore_file = function(path)
      return get.path.is_filename(path, ".gitignore")
    end,
    log_file = function(path)
      return get.path.is_extension(path, "log")
    end,
    newsboat_urls_file = function(path)
      return get.path.is_leaf(path, "urls")
    end,
    md_file = function(path)
      return get.path.is_standartized_extension(path, "md")
    end,
  },
  plaintext_assoc_file = {
    yaml_file = get.fn.arbitrary_args_bound_or_ignored_fn(get.path.is_standartized_extension, {a_use, "yaml"}),
    json_file = get.fn.arbitrary_args_bound_or_ignored_fn(get.path.is_standartized_extension, {a_use, "json"}),
    toml_file = get.fn.arbitrary_args_bound_or_ignored_fn(get.path.is_standartized_extension, {a_use, "toml"}),
    ini_file = get.fn.arbitrary_args_bound_or_ignored_fn(get.path.is_standartized_extension, {a_use, "ini"}),
    ics_file = get.fn.arbitrary_args_bound_or_ignored_fn(get.path.is_standartized_extension, {a_use, "ics"}),
  },
  plaintext_table_file = {

  },
  alphanum_minus_underscore = {
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
    pass_item_name = function(str)
      return get.local_extant_path.absolute_path_by_descendant_with_filename(env.MPASS, str)
    end,
    unicode_block_name = transf["nil"]["true"],
    unicode_category_name = transf["nil"]["true"], 
    unicode_plane_name = transf["nil"]["true"], -- currently no real point in the performance cost of checking if the strings actually are block/category/plane names. maybe in the future
    sign_indicator = function(str)
      return str == "" or str == "-"
    end
    
  },
  alphanum_underscore = {
    lower_alphanum_underscore = function(str)
      return get.str.bool_by_not_matches_part_onig_w_regex_character_class_innards(str, "A-Z")
    end,
    upper_alphanum_underscore = function(str)
      return get.str.bool_by_not_matches_part_onig_w_regex_character_class_innards(str, "a-z")
    end,
  },
  lower_alphanum_underscore = {
    general_name = function(str)
      return get.str.bool_by_not_startswith(str, "_") and get.str.bool_by_not_endswith(str, "_")
    end,
    search_engine_id = function(str)
      return get.arr.bool_by_contains(ls.search_engine_id, str)
    end
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
    base32_gen_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.id.b32.gen)
    end,
    base32_crock_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, r.g.id.b32.crockford)
    end,
    base32_str = function(str)
      return is.printable_ascii_not_whitespace_str.base32_gen_str(str) or is.printable_ascii_not_whitespace_str.base32_crock_str(str)
    end,
    bic = function(str)
      return #str == 8 or #str == 11
    end
  },
  digit_str = {
    bin_str = function(str)
      return get.str.bool_by_matches_whole_onig_w_regex_character_class_innards(str, "01")
    end,
    oct_str = function(str)
      return get.str.bool_by_matches_whole_onig_w_regex_character_class_innards(str, "0-7")
    end,
  },
  alpha_str = {
    lower_alpha_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, "[a-z]+")
    end,
    upper_alpha_str = function(str)
      return get.str.bool_by_matches_whole_onig(str, "[A-Z]+")
    end,
  },
  lower_alpha_str = {
    fs_attr_name = function(str)
      return get.arr.bool_by_contains(ls.fs_attr_name, str)
    end,
    local_o_remote_str = function(str)
      return str == "local" or str == "remote"
    end,
    date_component_name = function(str)
      return get.arr.bool_by_contains(ls.date.date_component_names, str)
    end,
    date_component_name_long = function(str)
      return get.arr.bool_by_contains(ls.date.date_component_names_long, str)
    end,
    mod_char = function(str)
      return get.arr.bool_by_contains(ls.mod_char, str)
    end,
    mod_name = function(str)
      return get.arr.bool_by_contains(ls.mod_name, str)
    end,
    leaf_str = function(str)
      return str == "leaf"
    end,
    project_type = function(str)
      return get.arr.bool_by_contains(ls.project_type, str)
    end,
  },
  url = {
    scheme_url = function(url)
      return get.str.bool_by_matches_part_onig(url, r.g.url.scheme)
    end,
    path_url = function(url)
      return transf.url.absolute_path_or_nil_by_path(url) ~= nil
    end,
    authority_url = function(url)
      return transf.url.authority(url) ~= nil
    end,
    query_url = function(url)
      return transf.url.query(url) ~= nil
    end,
    fragment_url = function(url)
      return transf.url.printable_ascii_or_nil_by_fragment(url) ~= nil
    end,
    username_url = function(url)
      return transf.url.username(url) ~= nil
    end,
    password_url = function(url)
      return transf.url.password(url) ~= nil
    end,
    userinfo_url = function(url)
      return transf.url.userinfo(url) ~= nil
    end,
    base_url = function(url)
      return transf.url.absolute_path_or_nil_by_path == nil and transf.url.query == nil and transf.url.fragment == nil
    end,

    booru_post_url = function(url)
      return 
        (is.url.query_url(url) and is.query_url.gelbooru_style_post_url(url)) or
        (is.url.path_url(url) and (
          is.path_url.danbooru_style_post_url(url) or
          is.path_url.yandere_style_post_url(url)
        ))
    end,
    github_url = function(url)
      return get.str.bool_by_startswith(url, "https://github.com/")
    end,
    wayback_machine_url = function(url)
      return get.str.bool_by_startswith(url, "https://web.archive.org/web/")
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
      return #transf.owner_item_url.two_strs_arr(url) == 2
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
  },
  query_url = {
    gelbooru_style_post_url = function(url)
      local paramtbl = transf.url.str_key_str_value_assoc_by_decoded_param_table(url)
      return is.any.int_str(paramtbl["id"]) and paramtbl["page"] == "post"
    end
  },
  extension_url = {
    image_url = function(url)
      return get.path.is_extension_in(transf.path_url.path(url), ls.filetype.image)
    end,
    playable_url = function(url)
      return get.path.usable_as_filetype(
        transf.path_url.path(url),
        "audio"
      ) or get.path.usable_as_filetype(
        transf.path_url.path(url),
        "video"
      )
    end
  },
  playable_url = {
    whisper_url = function(url)
      return get.path.usable_as_filetype(
        transf.path_url.path(url),
        "whisper-audio"
      )
    end,
  },
  authority_url = {
    host_url = function(url)
      return transf.url.host(url) ~= nil
    end,
  },
  host_url = {
    booru_url = function(url)
      return get.arr.bool_by_contains(ls.url.booru, transf.host_url.host(url))
    end,
    youtube_url = function(url)
      return transf.host_url.host(url) == "youtube.com"
    end,
  },
  booru_url = {
    danbooru_url = function(url)
      return transf.url.host(url) == "danbooru.donmai.us"
    end,
    gelbooru_url = function(url)
      return transf.url.host(url) == "gelbooru.com"
    end,
    safebooru_url = function(url)
      return transf.url.host(url) == "safebooru.org"
    end,
  },
  youtube_url = {
    youtube_video_url = function(url)
      return transf.path_url.initial_path_component(url) == "watch"
    end,
    youtube_playlist_url = function(url)
      return transf.path_url.initial_path_component(url) == "playlist"
    end,
    youtube_playable_url = function(url)
      return is.youtube_url.youtube_video_url(url) or is.youtube_url.youtube_playlist_url(url)
    end,
  },
  data_url = {
    base64_data_url = function(url)
      return get.str.bool_by_endswith(transf.data_url.header_part(url), ";base64")
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
    nibble_pos_int = function(num)
      return num < 16
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
    weekday_int_start_0 = transf["nil"]["true"]
  },
  n_anys = {
    any = function(...)
      return transf.n_anys.int_by_amount(...) == 1
    end,
    two_anys = function(...)
      return transf.n_anys.int_by_amount(...) == 2
    end,
  },
  two_anys = {
    two_numbers = function(...)
      return get.arr.bool_by_all_pass_w_fn(
        transf.n_anys.arr(...),
        is.any.number
      )
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
  },
  pass_item_name = {
    passw_pass_item_name = function(name)
      return get.pass_item_name.bool_by_exists_as(name, "passw")
    end,
    username_pass_item_name = function(name)
      return get.pass_item_name.bool_by_exists_as(name, "username", "txt")
    end,
    recovery_pass_item_name = function(name)
      return get.pass_item_name.bool_by_exists_as(name, "recovery")
    end,
    otp_pass_item_name = function(name)
      return get.pass_item_name.bool_by_exists_as(name, "otp")
    end,
    secq_pass_item_name = function(name)
      return get.pass_item_name.bool_by_exists_as(name, "secq")
    end,
    login_pass_item_name = function(name)
      return 
        is.pass_item_name.passw_pass_item_name(name) or
        is.pass_item_name.username_pass_item_name(name)
    end,


  },
  mac_application_name = {
    running = function(name)
      return get.mac_application_name.running_application(name) ~= nil
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
    only_int_key_table = function(t)
      for k, v in transf.table.kt_vt_stateless_iter(t) do
        if is.any.not_int(k) then return false end
      end
      return true
    end,
  },
  only_int_key_table = {
    --- an empty only_int_key_table is never a hole_y_arrlike and always an arr
    hole_y_arrlike = function(only_int_key_table)
      if #only_int_key_table == 0 then return false end
      for i = 1, #only_int_key_table do
        if only_int_key_table[i] == nil then return true end
      end
      return false
    end,
    arr = function(only_int_key_table)
      return not is.only_int_key_table.hole_y_arrlike(only_int_key_table)
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
  },
  set = {
    set_set = function(set)
      return is.any.set_arr(set)
    end,
  },
  non_empty_table = {
    str_key_non_empty_table = function(t)
      return get.table.bool_by_all_keys_pass_w_fn(
        t,
        is.any.str
      )
    end,
    date = function(t)
      return is.any.fn(t.addyears) -- arbitrary prop of date object
    end,
    has_id_key_assoc = function(t)
      return t.id ~= nil
    end,
    has_index_key_assoc = function(t)
      return t.index ~= nil
    end,
  },
  str_key_non_empty_table = {
    created_item_specifier = function(t)
      return
        t.created_item and t.creation_specifier
    end,
    audiodevice_specifier = function(t)
      return
        t.device and t.subtype
    end,
    csl_table = function(t)
      return
       
    end,
    input_spec = function(t)
      return
        t.mode and
        (t.mouse_button_str or t.key or t.target_point)
    end,
    unicode_prop_table = function(t)
      return
        t.cpoint
    end,
    path_leaf_specifier = function(t)
      return t.extension or t.path or t.rfc3339like_dt_o_interval or t.general_name or t.fs_tag_assoc
    end,
    intra_file_location_spec = function(t)
      return t.path and t.line
    end,
    prompt_args_spec = function(t)
      return t.message or t.default
    end,
    interval_specifier = function(t)
      return t.start and t.stop
    end,
    dcmp_assoc = function(t)
      return t.year or t.month or t.day or t.hour or t.min or t.sec
    end,
    semver_component_specifier = function(t)
      return t.major
    end,
    email_specifier = function(t)
      return t.non_inline_attachment_local_file_arr 
    end,
    absolute_path_key_assoc = function(t)
      return get.table.bool_by_all_keys_pass_w_fn(
        t,
        is.any.absolute_path
      )
    end,
    leaflike_key_assoc = function(t)
      return get.table.bool_by_all_keys_pass_w_fn(
        t,
        is.any.leaflike
      )
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
  },
  absolute_path_key_assoc = {
    absolute_path_key_leaf_str_or_nested_value_assoc = function(t)
      return get.table.bool_by_all_values_pass_w_fn(
        t,
        function(val)
          return is.any.leaf_str(val) or is.any.absolute_path_key_leaf_str_or_nested_value_assoc(val)
        end
      )
    end,
  },
  leaflike_key_assoc = {
    leaflike_key_leaf_str_or_nested_value_assoc = function(t)
      return get.table.bool_by_all_values_pass_w_fn(
        t,
        function(val)
          return is.any.leaf_str(val) or is.any.leaflike_key_leaf_str_or_nested_value_assoc(val)
        end
      )
    end,
  },
  dcmp_assoc = {
    full_dcmp_assoc = function(t)
      return t.year and t.month and t.day and t.hour and t.min and t.sec
    end
  },
  interval_specifier = {
    number_interval_specifier = function(t)
      return is.any.number(t.start) and is.any.number(t.stop)
    end,
    date_interval_specifier = function(t)
      return is.any.date(t.start) and is.any.date(t.stop)
    end,
    sequence_specifier = function(t)
      return t.step ~= nil
    end
  },
  number_interval_specifier = {
    int_interval_specifier = function(t)
      return is.number.int(t.start) and is.number.int(t.stop)
    end,
  },
  date_interval_specifier = {
    date_sequence_specifier = function(t)
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
      return get.audiodevice.is_active_audiodevice(
        spec.device,
        spec.type
      )
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
      return get.ipc_socket_id.response_table_or_nil(mpv_ipc_socket_id, {
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
  stream_created_item_specifier = {
    alive_stream_created_item_specifier = function(stream_created_item_specifier)
      return is.ipc_socket_id.mpv_ipc_socket_id(stream_created_item_specifier.inner_item.ipc_socket_id)
    end,
  },
  input_spec = {
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
  }
}

-- to allow for is.<type1>.<type2> where type2 is a descendant but not childtype of type1, we will use a metatable to search for the path from type1 to type2 by using thing_name_hierarchy, and then create a dynamic function that tests is.<type1>.<subtype> and is.<subtype>.<subtype2> and so on until we reach type2
-- to avoid code duplication we will resolve any call is.<type_a>_arr.<type_b>_arr to a dynamically generated function that calls get.arr.bool_by_all_pass_w_fn(arr, is.<type_a>.<type_b>)

local experimental_cache = {}

for type1, v in pairs(is) do
  experimental_cache[type1] = {}
  for type2, fn in pairs(v) do
    experimental_cache[type1][type2] = {}
  end
  local type1_ends_arr = get.str.bool_by_endswith(type1, "_arr")
  local mt = {
    __index = function(t, type2)

      local fn = rawget(t, type2)
      if fn then 
        return fn
      end

      if type1_ends_arr and get.str.bool_by_endswith(type2, "_arr") then
        local type_a = string.sub(type1, 1, -5)
        local type_b = string.sub(type2, 1, -5)
        return function(arr)
          return get.arr.bool_by_all_pass_w_fn(arr, is[type_a][type_b])
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
  setmetatable(v, mt)
end