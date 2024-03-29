

tblmap = {
  lua_escapable_ascii_str = {
    printable_ascii_not_whitespace_str_by_escaped = {
      ["\n"] = "\\n",
      ["\t"] = "\\t",
      ["\f"] = "\\f",
      ["\r"] = "\\r",
      ["\0"] = "\\0"
    },
  },
  mouse_button_char = {
    alpha_str_by_mouse_button_function_name = {
      l = "leftClick",
      r = "rightClick",
      m = "middleClick"
    }
  },
  mod_name = {
    mod_symbol = {
      cmd = "⌘",
      alt = "⌥",
      shift = "⇧",
      ctrl = "⌃",
      fn = "fn",
    },
    mod_char = {
      cmd = "c",
      alt = "a",
      shift = "s",
      ctrl = "ct",
      fn = "f",
    },
  },
  
  dcmp_name = {
    timestamp_s = {
      sec = 1,
      min = 60,
      hour = 60 * 60,
      day = 60 * 60 * 24,
      week = 60 * 60 * 24 * 7,
      month = 60 * 60 * 24 * 30,
      year = 60 * 60 * 24 * 365,
    },
    timestamp_ms = {
      sec = 1000,
      min = 1000 * 60,
      hour = 1000 * 60 * 60,
      day = 1000 * 60 * 60 * 24,
      week = 1000 * 60 * 60 * 24 * 7,
      month = 1000 * 60 * 60 * 24 * 30,
      year = 1000 * 60 * 60 * 24 * 365,
    },
    rfc3339like_dt_format_part = {
      sec = "%S",
      min = "%M",
      hour = "%H",
      day = "%d",
      month = "%m",
      year = "%Y",
    },
    rfc3339like_dt_str_format_part = {
      sec = "%02d",
      min = "%02d",
      hour = "%02d",
      day = "%02d",
      month = "%02d",
      year = "%04d",
    },
    rfc3339like_dt_str_format_part_fallback = {
      sec = "??",
      min = "??",
      hour = "??",
      day = "??",
      month = "??",
      year = "????",
    },
    rfc3339like_dt_separator = {
      year = "-",
      month = "-",
      day = "T",
      hour = ":",
      min = ":",
      sec = "Z",
    },
    rfc3339like_dt_separator_by_prev = {
      year = nil,
      month = "-",
      day = "-",
      hour = "T",
      min = ":",
      sec = ":",
    },
    rfc3339like_dt_format_str = {
      year = "%Y",
      month = "%Y-%m",
      day = "%Y-%m-%d",
      hour = "%Y-%m-%dT%H",
      min = "%Y-%m-%dT%H:%M",
      sec = "%Y-%m-%dT%H:%M:%SZ",
    },
    pos_int_by_max_dcmp_val = {
      sec = 60,
      min = 60,
      hour = 24,
      day = 30,
      month = 12,
    },
    pos_int_by_min_dcmp_val = {
      sec = 0,
      min = 0,
      hour = 0,
      day = 1,
      month = 1,
    },
    date_component_index = {
      year = 1,
      month = 2,
      day = 3,
      hour = 4,
      min = 5,
      sec = 6,
    },
    dcmp_name_long = {
      year = "year",
      month = "month",
      day = "day",
      hour = "hour",
      min = "minute",
      sec = "second",
    },

  },
  date_component_index = {
    dcmp_name = {
      [1] = "year",
      [2] = "month",
      [3] = "day",
      [4] = "hour",
      [5] = "min",
      [6] = "sec",
    },
  },
  rfc3339like_dt_format_part = {
    dcmp_name = {
      ["%Y"] = "year",
      ["%m"] = "month",
      ["%d"] = "day",
      ["%H"] = "hour",
      ["%M"] = "min",
      ["%S"] = "sec",
    },
  },
  dcmp_name_long = {
    dcmp_name = {
      year = "year",
      month = "month",
      day = "day",
      hour = "hour",
      minute = "min",
      second = "sec",
    },
  },
  sme_7_pos_int = {
    alpha_str_by_weekday_en_mon1 = {
      [1] = "Monday",
      [2] = "Tuesday",
      [3] = "Wednesday",
      [4] = "Thursday",
      [5] = "Friday",
      [6] = "Saturday",
      [7] = "Sunday"
    },
  },
  alpha_str_by_weekday_en_mon1 = {
    sme_7_pos_int = {
      ["Monday"] = 1,
      ["Tuesday"] = 2,
      ["Wednesday"] = 3,
      ["Thursday"] = 4,
      ["Friday"] = 5,
      ["Saturday"] = 6,
      ["Sunday"] = 7
    }
  },
  iso_639_1_language_code = {
    basic_locale_by_default = {
      en = "en-US",
      de = "de-DE",
    },
    mac_voice_name_by_default = {
      en = "Alex",
      ja = "Kyoko"
    }
  },
  secondary_api_name = {
    api_name = {
      youtube = "google"
    },
    noweirdwhitespace_line_by_endpoint_prefix = {
      youtube = "youtube/v3"
    },
    str_key_str_value_assoc_by_default_params = {
      youtube = {
        part = "snippet",
      }
    }
  },
  rel_pkey = {
    hydrus_rel = {
      _p = "parent",
      _rp = "parent",
      _s = "sib",
      _rs = "sib",
    }
  },
  api_name = {
    host = {
      dropbox = "api.dropboxapi.com/2",
      danbooru = "danbooru.donmai.us",
      openai = "api.openai.com/v1",
      hydrus = "127.0.0.1:45869",
      httpbin = "httpbin.org",
      google = "www.googleapis.com",
      osm = "nominatim.openstreetmap.org",
    },
    url_scheme = {
      hydrus = "http://",
    },
    alphanum_minus_underscore_by_auth_header = {
      hydrus = "Hydrus-Client-API-Access-Key"
    },
    api_request_kv_location_by_token_where = {
      hydrus = "header",
      danbooru = "param",
      dropbox = "header",
      openai = "header",
      google = "header",
    },
    token_type = {
      google = "oauth2",
      dropbox = "oauth2",
    },
    api_request_kv_location_by_username_pw_where = {

    },
    http_authentication_scheme = {
      hydrus = "" -- "" means no auth process. Even though it's using keys for auth, it doesn't use the Bearer indicator
    },
    http_protocol_url_by_oauth2_url = {
      dropbox = "api.dropboxapi.com/oauth2/token",
      google = "https://accounts.google.com/o/oauth2/token"
    },
    http_protocol_url_by_oauth2_authorization_url = {
      dropbox = "https://www.dropbox.com/oauth2/authorize",
      google = "https://accounts.google.com/o/oauth2/auth"
    },
    bool_by_needs_scopes = {
      google = true
    },
    str_by_scopes = {
      google = "https://www.googleapis.com/auth/youtube"
    },
    str_by_empty_post_body = {
      dropbox = "null"
    },
    media_type_by_empty_post_body_raw_type = {
      dropbox = "application/json"
    },
    str_key_str_value_assoc_by_additional_auth_params = {
      google = {
        access_type = "offline", 
        prompt = "consent"
      }
    },
  },
  extension = {
    utf8_char_by_likely_field_separator = {
      csv = ",",
      tsv = "\t",
    },
    utf8_char_by_likely_record_separator = {
      csv = "\n",
      tsv = "\n",
    },
    extension_by_normalized =  {
      jpeg = "jpg",
      jpg = "jpg",
      htm = "html",
      html = "html",
      yml = "yaml",
      yaml = "yaml",
      markdown = "md",
      md = "md",
    },
  },
  pandoc_basic_format = {
    extension = {
      pdf = "pdf",
      beamer = "pdf",
      revealjs = "html",
    }
  },
  mac_application_name = {
    str_arr_by_recent_full_action_path = {
      OmegaT = {"Project", "Open Recent Project"}
    },
    str_arr_reload_full_action_path = {
      LibreOffice = {"File", "Reload"}
    },
  },
  search_engine_id = {
    http_protocol_url = {
      wiktionary = "https://en.wiktionary.org/wiki/%s",
      wikipedia = "https://en.wikipedia.org/wiki/%s",
      youtube = "https://www.youtube.com/results?search_query=%s",
      jisho = "https://jisho.org/search/%s",
      glottopedia = "https://glottopedia.org/index.php?search=",
      ruby_apidoc = "https://apidock.com/ruby/search?query=%s",
      python_docs = "https://docs.python.org/3/search.html?q=%s",
      merriam_webster = "https://www.merriam-webster.com/dictionary/%s",
      assoc_cc = "https://www.assoc.cc/?s=%s",
      deepl_en_ja = "https://www.deepl.com/translator#en/ja/%s",
      deepl_de_en = "https://www.deepl.com/translator#de/en/%s",
      mdn = "https://developer.mozilla.org/en-US/search?q=%s",
      scihub = "https://sci-hub.st/%s",
      libgen = "https://libgen.rs/search.php?req=%s",
      semantic_scholar = "https://www.semanticscholar.org/search?q=%s",
      google_scholar = "https://scholar.google.com/scholar?q=%s",
      google_images = "https://www.google.com/search?tbm=isch&q=%s",
      google_maps = "https://www.google.com/maps/search/%s",
      google = "https://www.google.com/search?q=%s",
      danbooru = "https://danbooru.donmai.us/posts?tags=%s",
      gelbooru = "https://gelbooru.com/index.php?page=post&s=list&tags=%s",
    },
    bool_by_param_is_path = {
      wikipedia = true,
      wiktionary = true,
      jisho = true,
      merriam_webster = true,
      deepl_en_ja = true,
      deepl_de_en = true,
      scihub = true,
      google_maps = true,
    }
  },
  host = {
    git_remote_type = {},
    host_by_blob_default = {},
    host_by_raw_default = {},
  },
  client_project_kind = {
    billing_unit = {
      translation = "line"
    },
    iso_639_1_language_code_key_line_value_assoc_by_plaintext_name_sg = {
      translation = {
        de = "Übersetzung"
      }
    },
    iso_639_1_language_code_key_line_value_assoc_by_plaintext_name_pl = {
      translation = {
        de = "Übersetzungen"
      }
    }
  },
  billing_unit = {
    iso_639_1_language_code_key_line_value_assoc = {
      line = {
        de = "Zeilen",
      }
    }
  },
  git_remote_type = {
    noweirdwhitespace_line_by_blob_indicator_path = {
      github = "blob/",
      gitlab = "blob/",
      bitbucket = "src/",
    },
    host_by_blob_default = {
      github = "github.com",
      gitlab = "gitlab.com",
      bitbucket = "bitbucket.org",
    },
    noweirdwhitespace_line_by_raw_indicator_path = {
      
      github = "",
      gitlab = "raw/",
      bitbucket = "raw/",
    },
    host_by_raw_default = {
      github = "raw.githubusercontent.com",
      gitlab = "gitlab.com",
      bitbucket = "bitbucket.org",
    },
  },
  base_letter = {
    pos_int_by_base = {
      b = 2,
      o = 8,
      d = 10,
      x = 16,
    }
  },
  dynamic_structure_name = {
    leaflike_key_str_or_str_arr_value_assoc = {
      latex = {
        citations = "write_file",
        ["main.tex"] = {"write_template","comp.templates.latex_main"},
        citable_objects = "create_dir"
      },
      omegat = {
        dictionary = "create_dir",
        glossary = "create_dir",
        omegat = "create_dir",
        source = "create_dir",
        target = "create_dir",
        target_txt = "create_dir",
        tm = "create_dir",
        ["client_project_data.yaml"] = {"write_template","comp.templates.data_yaml"},
        ["omegat.project"] = {"write_template", "comp.templates.omegat"}
      },
    }
  },
  project_type = {
    str_by_build_command = {
      latex =  "pdflatex main.tex && biber main && pdflatex main.tex && pdflatex main.tex",
      npm = "npm run build",
      cargo = "cargo build",
    },
    str_by_install_command = {
      npm = "npm run install",
    },
    str_arr_by_project_materials_list = {
      omegat = {
        "tm",
        "glossary"
      }
    }
  },
  stream_boolean_attribute = {
    line_by_true_emoji = {
      loop = "🔂",
      shuffle = "🔀",
    },
    line_by_false_emoji =  {
      video = "🙈",
      pause = "▶️",
    }
  },
  thing_name = {
    partial_retriever_specifier_by_chooser_image = {
      local_image_file = {
        thing_name = "hs_image",
        precedence = 999
      },
      image_url = {
        thing_name = "hs_image",
        precedence = 999
      },
      image_data_url = {
        thing_name = "hs_image",
        precedence = 999
      },
    },
    partial_retriever_specifier_by_chooser_text = {
      str = {
        thing_name = "singleline_str_by_folded",
        precedence = -999
      },
      audiodevice_specifier = {
        thing_name = "name",
        precedence = 999
      },
      stream_created_item_specifier = {
        thing_name = "summary_line"
      },
      csl_table = {
        thing_name = "apa_str",
        precedence = 999
      },
      menu_item_table = {
        thing_name = "summary",
        precedence = 999
      },
      syn_specifier = {
        thing_name = "summary",
        precedence = 999
      },
      arr = {
        thing_name = "summary",
        precedence = 1
      },
      two_anys__arr = {
        thing_name = "assoc_entry_str",
        precedence = 999
      },
      full_dcmp_spec = {
        thing_name = "urlcharset_str_by_detailed_summary",
        precedence = 999
      },
      contact_table = {
        thing_name = "summary",
        precedence = 999
      }
    },
    partial_retriever_specifier_by_chooser_subtext = {
      stream_created_item_specifier = {
        thing_name = "source_path"
      }
    },
    partial_retriever_specifier_by_placeholder_text = {
      
    },
    partial_retriever_specifier_by_initial_selected_index = {
      audiodevice_specifier_arr = {
        thing_name = "active_audiodevice_specifier_index",
        precedence = 999
      }
    },
  },
  stream_state = {
    bool_key_stream_state_value_assoc = {
      booting = {
        [true] = 'active',
        [false] = 'booting'
      },
      active = {
        [true] = 'active',
        [false] = 'ended'
      },
      ended = {
        [true] = 'ended',
        [false] = 'ended'
      }
    }
  },
  bin_specifier_name = {
    bin_specifier = {
      inf_no = {
        vt = "inf",
        vf = "no"
      }
    }
  },
  lower_strict_snake_case = {
    line_by_namespace_and_potentially_subnamespace = {
      srsrelindex = "season_subindex",
      srsrel = "episode_role",
      tcrea = "creation_ware:creation_agent",
      series = "thing:ip",
      srs = "thing:ip",
      char = "agentlike:char",
      character = "agentlike:char",
      title = "creation_title",
      date = "date",
      ch = "chapter_index",
      chapter_index = "chapter_index",
      season = "season_index",
      season_index = "season_index",
      ep = "episode_index",
      episode_index = "episode_index",
      chname = "chapter_title",
      chapter_title = "chapter_title",
      page = "page_index",
      page_index = "page_index",
      vol = "volume_index",
      volume_index = "volume_index",
      purpose = "message_force",
      use_as = "message_force",
      message_force = "message_force",
      msgf = "message_force",
      msgd = "message_direction",
      message_direction = "message_direction",
      msgc = "message_change",
      general = "general",
      g = "general",
      person = "person",
      medium = "medium",
      occ = "occasion",
      occasion = "occasion",
      epsub = "episode_subindex",
      episode_subindex = "episode_subindex",
      prompt = "prompt",
      neta = "neta",
      creation_context = "acquisition_context",
      acquisition_context = "acquisition_context",
      ctx = "acquisition_context",
      coll = "collection",
      collection = "collection",
      proximate_source = "proximate_source",
      tourism = "tourism",
      service = "service",
      inspiration_for = "use",
      semver = "semver",
      acqins = "acquisition_institution",
      period = "period",
      per = "period",
      subj = "subject_matter",
      subject_matter = "subject_matter",
      concept = "concept",
      puse = "use",
      use = "use",

    },
    lower_strict_snake_case_key_line_value_assoc = {
      action = {
        confession = "confession",
        hairplay = "playing_with_anothers_hair",
        head_rest = "head_on_anothers_shoulder",
        hug = "hug",
        headpat = "headpat",
        breast_rub = "grabbing_anothers_breast",
        breast_grab = "grabbing_anothers_breast",
        penetration = "sex",
        masturbation = "masturbation",
      },
      relationship = {
        yuri = "yuri",
      },
      orig = {
        orig = "original",
      },
      style = {
        real = "realistic",
      },
      layout = {
        manga_page = "comic",
        webtoon = "webtoon"
      },
    }
  },
  flag_profile_name ={
    stream_boolean_attribute_key_bool_value_assoc = {
      foreground = {
        ["loop-playlist"] = false,
        shuffle = false,
        pause = false,
        ["no-video"] = false,
      },
      background = {
        ["loop-playlist"] = true,
        shuffle = true,
        pause = true,
        ["no-video"] = true,
      }
    }
  },
    
 
  sme_5_pos_int = {
    danbooru_category_name = {
      [0] = "general",
      [1] = "artist",
      [3] = "copyright",
      [4] = "character",
      [5] = "meta",
    }
  },
  markdown_extension_set_name = {
    markdown_extension_name_arr = {
      basic = {
        "yaml_metadata_block"
      },
      featureful = {
        "fenced_code_blocks",
        "backtick_code_blocks",
        "fenced_code_attributes",
        "line_blocks",
        "fancy_lists",
        "startnum",
        "definition_lists",
        "task_lists",
        "example_lists",
        "table_captions",
        "pipe_tables",
        "all_symbols_escapable",
        "strikeout",
        "superscript",
        "subscript",
        "tex_math_dollars",
        "raw_html",
        "footnotes",
        "inline_notes",
        "implicit_figures",
        "mark",
        "angle_brackets_escapable",
        "hard_line_breaks",
        "emoji",
        "autolink_bare_uris",
      },
      navigable = {
        "implicit_header_references"
      },
      citing = {
        "citations",
      },
      styleable = {
        "header_attributes",
        "auto_identifiers",
        "gfm_auto_identifiers",
        "link_attributes",
        "fenced_divs"
      }
    }
  },
  function_container_name = {
    thing_name_key_thing_name_with_optional_explanation_key_boolean_value_assoc_value_assoc = {
      act = {
        hydrusable_url = {
          save_url_to_proc_for_hydrus_general = true,
        }
      }
    }
  }
}