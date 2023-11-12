r = {
  g_i = {
    uuid = "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}",
  },
  g = {

    camel_strict_snake_case = "[a-zA-Z][a-zA-Z0-9]*(?:_[A-Z]+[a-zA-Z0-9]+)*",
    camel_strict_kebap_case = "[a-zA-Z][a-zA-Z0-9]*(?:-[A-Z]+[a-zA-Z0-9]+)*",
    dice_notation =  "(?:\\d+)?d\\d+(?:[/x\\*]\\d+)?(?:[+-]\\d+)?",
    printable_ascii_char = "\\x20-\\x7E",
    ascii_char = "\\x00-\\x7F",
    rfc3339like_dt = "\\d{4}(?:" ..
        "\\-\\d{2}(?:" ..
          "\\-\\d{2}(?:" ..
            "T\\d{2}(?:" ..
              "\\:\\d{2}(?:" ..
                "\\:\\d{2}(?:" ..
                  "\\.\\d{1,9}"
                ..")?"
              ..")?"
            ..")?Z?"
          ..")?"
        ..")?"
      ..")?",
    fs_tag_str = "(?:%[a-z0-9_]+-[a-z0-9_]+)*",
    base64_gen_str = "[A-Za-z0-9\\+/=]+",
    base64_url_str = "[A-Za-z0-9_\\-=]+",
    base32_gen_str = "[A-Za-z2-7=]+",
    base32_crock_str = "[0-9A-HJKMNP-TV-Z=]+",
    cronspec_str = "(?:@(annually|yearly|monthly|weekly|daily|hourly|reboot))|(?:@every (\\d+(ns|us|µs|ms|s|m|h))+)|((((\\d+,)+\\d+|(\\d+(\\/|-)\\d+)|\\d+|\\*) ?){5,7})",
    issn = "[0-9]{4}-?[0-9]{3}[0-9xX]",
    isbn10 = "[0-9]{9}[0-9xX]",
    isbn13 = "[0-9]{13}",
    doi = "(10\\.\\d{4,9}/[-._;()/:A-Z0-9]+)",
    relay_identifier = "[a-z]{2}-[a-z]{3}-(?:wg|ovpn)-\\d{3}",
    media_type = "[-\\w.]+/[-\\w.\\+]+",
    domain_name = "(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\\.)+[a-z0-9][a-z0-9-]{0,61}[a-z0-9]",
    ipc_socket_id = "\\d+-\\d+",
    basic_locale = "[a-z]{2,3}-[A-Z]{2,3}",
    html_entity = "&(?:[a-zA-Z\\d]+|#\\d+|#x[a-fA-F\\d]+);",
    input_spec_str = "(?:\\.[lrm])|(?::.*)|(?:[ms]-?\\d+..*?-?\\d+ %[a-zA-Z]+)",
    url_scheme = "[a-zA-Z][a-zA-Z0-9+.-]*-:",
    ipv4_address = "(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)",
    assc_thing_name_by_extract_key_value = "^(\\w+)_key(?:_(\\w+)_value)?_assoc$",
    shell_shebang = "^#!\\s*/.*?(?:ba|z|fi|da|k|t?c)sh\\s+",
    semver_str = "(\\d+)(?:\\.(\\d+)(?:\\.(\\d+)(?:\\-([\\w.-]+))?(?:\\+([\\w.-]+))?)?)?",
    pos_int_dimensions_str = "(\\d+)x(\\d+)",
    int_ratio_str = "(-?\\d+):(-?\\d+)",
  },
  lua = {  }
}