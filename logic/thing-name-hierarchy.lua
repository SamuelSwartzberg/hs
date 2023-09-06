thing_name_hierarchy = {
  mult_anys = {
    two_anys = {
      two_numbers = "leaf",
      two_strs = {
        shell_var_name_and_str = "leaf",
      }
    },
    three_anys = {
      three_strs = {
        year_and_year_month_and_year_month_day = "leaf",
      }
    }
  },
  any = {
    lower_alphanum_underscore_or_lower_alphanum_underscore_arr_ = "leaf",
    str = {
      email_or_displayname_email = "leaf",
      empty_str = "leaf",
      json_str = "leaf",
      yaml_str = "leaf",
      not_starting_with_whitespace_str = "leaf",
      not_ending_with_whitespace_str = "leaf",
      not_empty_str = {
        utf8_char = "leaf",
        input_spec_str = "leaf",
        input_spec_series_str = "leaf",
        whitespace_str = {
          starting_with_whitespace_str = "leaf",
          ending_with_whitespace_str = "leaf",
          starting_o_ending_with_whitespace_str = "leaf",
          starting_a_ending_with_whitespace_str = "leaf",
        },
        starting_with_dot_str = "leaf",
        multiline_str = {
          here_doc = "leaf",
          raw_contact = "leaf",
          ini_section_contents_str = "leaf",
          decoded_email_header_block = "leaf",
          decoded_email = "leaf",
          script_str = {
            shell_script_str = {
              envlike_str = "leaf",
            },
          }
        },
      },
      line = {
        not_whitespace_str = "leaf",
        indent_line = "leaf",
        noindent_line = "leaf",
        hashcomment_line = "leaf",
        nohashcomment_line = "leaf",
        semicoloncomment_line = "leaf",
        nosemicoloncomment_line = "leaf",
        trailing_whitespace_line = "leaf",
        notrailing_whitespace_line = "leaf",
        decoded_email_header_line = "leaf",
        noempty_line = {
          ini_kv_line = "leaf"
        },
        noempty_nohashcomment_line = "leaf",
        noempty_noindent_line = "leaf",
        noempty_nohashcomment_noindent_line = "leaf",
        ini_section_line = "leaf",
        trimmed_line = {
          displayname_email = "leaf",
        },
        noweirdwhitespace_line = {
          path_component = {
            leaflike = {
              extension = "leaf",
              citable_filename = "leaf"
            },
          },
          trimmed_noweirdwhitespace_line = {
            path = {
              extension_path = "leaf",
              useless_file_leaf_path = "leaf",
              not_useless_file_leaf_path = "leaf",
              citable_path = {
                mpapers_citable_local_absolute_path = "leaf",
                mcitations_citable_local_absolute_path = "leaf",
                mpapernotes_citable_local_absolute_path = "leaf",
                mpapers_citable_object_file = "leaf",
                mcitations_csl_file = "leaf",
                mpapernotes_citable_object_notes_file = "leaf",
              },
              dotfilename_path = "leaf",
              not_dotfilename_path = "leaf",
              remote_path = {
                labelled_remote_path = {
                  labelled_remote_absolute_path = {
                    labelled_remote_extant_path = {
                      labelled_remote_dir = {
                        empty_labelled_remote_dir = "leaf",
                        nonempty_labelled_remote_dir = "leaf"
                      },
                      labelled_remote_file = {
                        empty_labelled_remote_file = "leaf",
                        nonempty_labelled_remote_file = "leaf"
                      }
                    }
                  }
                },
                remote_absolute_path = {
                  remote_extant_path = {
                    remote_dir = {
                      empty_remote_dir = "leaf",
                      nonempty_remote_dir = "leaf"
                    },
                    remote_file = {
                      empty_remote_file = "leaf",
                      nonempty_remote_file = "leaf"
                    }
                  }
                }
              },
              absolute_path = {
                extant_path = {
                  dir = {
                    empty_dir = "leaf",
                    nonempty_dir = {
                      grandparent_dir = "leaf",
                    },
                    non_bare_git_root_dir = "leaf",
                    bare_git_root_dir = "leaf",
                    git_reposity_dir = "leaf",
                    git_root_dir = "leaf",
                    logging_dir = "leaf",
                  },
                  file = {
                    empty_file = "leaf",
                    nonempty_file = "leaf",
                    image_file = "leaf",
                    email_file = "leaf",
                    plaintext_file = { 
                      script_file = {
                        shell_script_file = {
                          shell_script_file_with_errors = "leaf",
                          shell_script_file_with_warnings = "leaf",
                          envlike_file = "leaf",
                        },
                      },
                      plaintext_assoc_file = {
                        yaml_file = "leaf",
                        toml_file = "leaf",
                        json_file = "leaf",
                        ini_file = "leaf",
                        csv_file = "leaf",
                      },
                      plaintext_table_file = {
  
                      },
                      m3u_file = "leaf",
                      gitignore_file = "leaf",
                      log_file = "leaf",
                      newsboat_urls_file = "leaf",
                      md_file = "leaf"
                    },
                    bin_file = {
                      db_file = "leaf",
                      playable_file = {
                        whisper_file = "leaf"
                      }
                    }
                  },
                  in_git_dir = {
                    in_has_changes_git_dir = "leaf",
                    in_has_no_changes_git_dir = "leaf",
                    in_has_unpushed_commits_git_dir = "leaf",
                  },
                },
                nonextant_path = "leaf"
              },
              path_with_twod_locator = "leaf",
            },
            local_path = {
              local_nonabsolute_path = {
                local_tilde_path = "leaf",
                atpath = "leaf",
                duplex_local_nonabsolute_path = {
                  owner_item_path = "leaf"
                },
                triplex_local_nonabsolute_path = "leaf"
              },
              contains_relative_references_local_path = "leaf",
              not_contains_relative_references_local_path = "leaf",
              local_resolvable_path = "leaf",
              local_naive_absolute_path = {
                local_absolute_path = {
                  root_local_absolute_path = "leaf",
                  in_volume_local_absolute_path = "leaf",
                  in_home_local_absolute_path = {
                    in_me_local_absolute_path = {
                      in_mcitations_local_absolute_path = "leaf",
                      in_mpapers_local_absolute_path = "leaf",
                    }
                  },
                  in_global_tmp_path = {
                    ipc_socket_path = "leaf"
                  },
                  local_nonextant_path = "leaf",
                  local_extant_path = {
                    volume_local_extant_path = {
                      dynamic_time_machine_volume_local_extant_path = "leaf",
                      static_time_machine_volume_local_extant_path = "leaf"
                    },
                    local_dir = {
                      empty_local_dir = "leaf",
                      nonempty_local_dir = {
                        project_dir = "leaf",
                        latex_project_dir = "leaf",
                        omegat_project_dir = "leaf",
                        npm_project_dir = "leaf",
                        cargo_project_dir = "leaf",
                        sass_project_dir = "leaf"
                      },
                      dotapp_dir = {
                        installed_app_dir = "leaf",
                      }
                    },
                    local_file = {
                      empty_local_file = "leaf",
                      nonempty_local_file = "leaf"
                    }
                  }
                },
              }
            }
          }
        },
        
      },
      ascii_str = {
        ascii_char = {
          rfc3339like_dt_separator = "leaf",
        },
        printable_ascii_str = {
          printable_ascii_multiline_str = {
            email_header_block = "leaf",
          },
          printable_ascii_line = {
            printable_ascii_no_vertical_space_str = {
              email_header_kv_line = "leaf",
              indent_ascii_line = "leaf",
              email_header_line = "leaf",
              printable_ascii_no_nonspace_whitespace_str = {
                fnname = "leaf",
                single_attachment_str = "leaf",
                phone_number = "leaf",
                application_name = {
                  mac_application_name = "leaf",
                },
                separated_nonindicated_number_str = {
                  separated_nonindicated_bin_number_str = "leaf",
                  separated_nonindicated_hex_number_str = "leaf",
                  separated_nonindicated_oct_number_str = "leaf",
                  separated_nonindicated_dec_number_str = "leaf",
                },
                printable_ascii_not_whitespace_str = {
                  fs_tag_kv = "leaf",
                  bracketed_ipv6 = "leaf",
                  ip_host = "leaf",
                  host = "leaf",
                  html_entity = "leaf",
                  fs_tag_str = "leaf",
                  base64_gen_str = {
                    unicode_codepoint_str = "leaf"
                  },
                  base64_url_str =  {
                    youtube_video_id = {
                      actual_youtube_video_id = {
                        extant_youtube_video_id = "leaf",
                        private_youtube_video_id = "leaf",
                        unavailable_youtube_video_id = "leaf",
                      }
                    },
                    youtube_playlist_id = "leaf",
                    youtube_channel_id = "leaf",
                  },
                  media_type = {
                    image_media_type = "leaf"
                  },
                  base64_str = "leaf",
                  handle = "leaf",
                  email = "leaf",
                  dice_notation = "leaf",
                  package_name = {
                    installed_package_name = "leaf",
                  },
                  package_name_package_manager_name_compound_str = "leaf",
                  package_name_semver_compound_str = "leaf",
                  package_name_semver_package_manager_name_compound_str = "leaf",
                  doi = "leaf",
                  semver_str = "leaf",
                  indicated_isbn = "leaf",
                  indicated_pmid = "leaf",
                  indicated_doi = "leaf",
                  indicated_isbn_part_identifier = "leaf",
                  indicated_pcmid = "leaf",
                  indicated_accession = "leaf",
                  indicated_issn_full_identifier = "leaf",
                  indicated_urlmd5 = "leaf",
                  indicated_citable_object_id = "leaf",
                  percent_encoded_octet = "leaf",
                  lower_alphanum_underscore_comma = "leaf",
                  
                  colon_period_alphanum_minus_underscore = {
                    indicated_utf8_hex_str = "leaf",
                    rfc3339like_dt_o_interval = {
                      rfc3339_dt = {
                        full_rfc3339like_dt = "leaf",
                      },
                      rfc3339_interval = "leaf",
                    },
                    colon_alphanum_minus_underscore = {
                      colon_num = {
                        hour = "leaf",
                        hour_minute = "leaf",
                        hour_minute_second = "leaf",
                      },
                      ipv6 = "leaf",
                      calendar_name = {
                        writeable_calendar_name = "leaf",
                      },
                      alphanum_minus_underscore = {
                        lower_alphanum_minus_underscore = {
                          pass_item_name = {
                            otp_pass_item_name = "leaf",
                            passw_pass_item_name = "leaf",
                            recovery_pass_item_name = "leaf",
                            secq_pass_item_name = "leaf",
                            username_pass_item_name = "leaf",
                            login_pass_item_name = "leaf"
                          },
                        },
                        package_manager_name = "leaf",
                        alphanum_minus = {
                          isbn10 = "leaf",
                          isbn13 = "leaf",
                          issn = "leaf",
                          isbn = "leaf",
                          uuid = {
                            contact_uuid = "leaf",
                            null_uuid = "leaf",
                          },
                          ipc_socket_id = {
                            mpv_ipc_socket_id = "leaf",
                          },
                          sign_indicator = "leaf",
                          github_username = "leaf",
                          lower_alphanum_minus = {
                            relay_identifier = "leaf",
                            git_remote_type = "leaf",
                          },
                          num_minus = {
                            year = "leaf",
                            year_month = "leaf",
                            year_month_day = "leaf",
                            digit_interval_str = "leaf",
                          },
                          upper_alphanum_minus ="leaf"
                        },
                        alphanum_underscore = {
                          lower_alphanum_underscore = {
                            general_name = "leaf",
                            search_engine_id = "leaf"
                          },
                          upper_alphanum_underscore = "leaf",
                        },
                        alphanum = {
                          alpha_str = {
                            upper_alpha_str = "leaf",
                            lower_alpha_str = {
                              fs_attr_name = "leaf",
                              local_o_remote_str ="leaf",
                              dcmp_name = "leaf",
                              dcmp_name_long = "leaf",
                              mod_char = "leaf",
                              mod_name = "leaf",
                              leaf_str = "leaf",
                              project_type = "leaf",
                              vcard_phone_type = "leaf",
                              vcard_email_type = "leaf",
                              vcard_address_type = "leaf",
                            },
                            iso_3366_1_alpha_2_country_code = "leaf",
                            iso_3366_1_alpha_3_country_code = "leaf",
                          },
                          hex_str = {
                            byte_hex_str = "leaf",
                            two_byte_hex_str = "leaf",
                            sha1_hex_str = "leaf",
                            git_sha1_hex_str = {
                              full_sha1_hex_str = "leaf",
                              short_sha1_hex_str = "leaf",
                            },
                          },
                          digit_str = {
                            bin_str = "leaf",
                            oct_str = "leaf",
                          },
                          base32_gen_str = "leaf",
                          base32_crock_str = "leaf",
                          base32_str = "leaf",
                        },
                      }
                    },
                    period_alphanum_minus_underscore = {
                      ipv4 = "leaf",
                      nonindicated_number_str = {
                        nonindicated_bin_number_str = "leaf",
                        nonindicated_hex_number_str = "leaf",
                        nonindicated_oct_number_str = "leaf",
                        nonindicated_dec_number_str = "leaf",
                      },
                      indicated_number_str = {
                        indicated_bin_number_str = "leaf",
                        indicated_hex_number_str = "leaf",
                        indicated_oct_number_str = "leaf",
                        indicated_dec_number_str = "leaf",
                      },
                      domain_name = {
                        source_id = {
                          active_source_id = "leaf",
                        }
                      }
                    },
                  },
                },
                url = {
                  base_url = {
                    dotgit_url = "leaf",
                  },
                  scheme_url = {
                    mailto_url = "leaf",
                    tel_url = "leaf",
                    otpauth_url = "leaf",
                    data_url = {
                      base64_data_url = "leaf",
                      image_data_url = "leaf",
                    },
                    http_protocol_url = {
                      http_url = "leaf",
                      https_url = "leaf",
                    },
                    file_url = "leaf"
                  },
                  path_url = {
                    owner_item_url  = "leaf",
                    extension_url = {
                      image_url = "leaf",
                      playable_url = {
                        whisper_url = "leaf"
                      }
                    },
                    danbooru_stule_post_url = "leaf",
                    yandere_style_post_url = "leaf",
                  },
                  authority_url = {
                    host_url = {
                      booru_url = {
                        danbooru_url = "leaf",
                        yandere_url = "leaf",
                        gelbooru_url = "leaf",
                      },
                      youtube_url = {
                        youtube_video_url = "leaf",
                        youtube_playlist_url = "leaf",
                        youtube_playable_url = "leaf"
                      }
                    }
                  },
                  query_url = {
                    gelbooru_style_post_url = "leaf",
                  },
                  fragment_url = "leaf",
                  username_url = "leaf",
                  password_url = "leaf",
                  userinfo_url = "leaf",
                  booru_post_url = "leaf",
                  github_url = {
                    github_path_url = {
                      github_user_url = "leaf"
                    }
                  }
                },
                url_or_local_path = "leaf"
              },
              iban = {},
            },
          }
        }
      },
    },
    table = {
      only_int_key_table = {
        arr = { 
          dcmp_name_seq = {
            cont_dcmp_name_seq = {
              prefix_dcmp_name_seq = "leaf",
              suffix_dcmp_name_seq = "leaf",
            }
          },
          set =  {
            set_set = "leaf",
          }
        }, -- partially added later, see below
        hole_y_arrlike = "leaf"
      },
      empty_table = "leaf",
      assoc =  {
          
        absolute_path_key_assoc = {
          absolute_path_key_leaf_str_or_nested_value_assoc = "leaf"
        },
        leaflike_key_assoc = {
          leaflike_key_leaf_str_or_nested_value_assoc = "leaf"
        },
        printable_ascii_str_key_assoc = {
          lower_alphanum_underscore_key_assoc = {
            lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc = "leaf"
          }
        }
      },
      non_empty_table = {
        date = "leaf",
        has_id_key_table = "leaf",
        has_index_key_table = "leaf",
        created_item_specifier = {
          stream_created_item_specifier = {
            alive_stream_created_item_specifier = "leaf"
          },
          fireable_created_item_specifier = "leaf"
        },
        audiodevice_specifier = {},
        csl_table = {
          whole_book_type_csl_table = "leaf",
          book_chapter_type_csl_table = "leaf",
          whole_book_csl_table = "leaf",
        },
        input_spec = {
          declared_click_input_spec = "leaf",
          declared_key_input_spec = "leaf",
          declared_move_input_spec = "leaf",
          declared_scroll_input_spec = "leaf",
          declared_position_change_input_spec = "leaf",
        },
        unicode_prop_table = "leaf",
        prompt_args_spec = {
          str_prompt_args_spec = "leaf",
        },
        interval_specifier = {
          number_interval_specifer = {
            int_interval_specifier = "leaf",
          },
          sequence_specifier = "leaf",
          date_interval_specifier = {
            date_sequence_specifier = "leaf",
          }
        },
        gpt_response_table = "leaf",
        iban_data_spec = "leaf", 
        contact_table = "leaf",
        ical_spec = "leaf",
        tree_node = "leaf",
        val_dep_spec = "leaf",
        syn_specifier = "leaf",
        email_speciier = "leaf",
        newsboat_urls_specifier = "leaf",
        semver_component_specifier = "leaf",
        dcmp_spec = {
          full_dcmp_spec = "leaf",
          cont_dcmp_spec = {
            prefix_dcmp_spec = "leaf",
            suffix_dcmp_spec = "leaf",
          }
        },
        str_format_part_specifier = "leaf"
      }
    },
    primitive = {
  
    },
    number = {
      int = {
        timestamp_s  = {
          reasonable_timestamp_s = "leaf",
        },
        timestamp_ms = {
          reasonable_timestamp_ms = "leaf",
        },
        even_int = "leaf",
        pos_int = {
          eightbyte_pos_int = {
            fourbyte_pos_int = {
              twobyte_pos_int = {
                byte_pos_int = {
                  halfbyte_pos_int = {
                    iso_weeknumber_int = "leaf",
                    nibble_pos_int = {
                      sme_10_pos_int = {
                        sme_8_pos_int = {
                          sme_7_pos_int = {
                            sme_6_pos_int = {
                              weekday_int_start_0 = "leaf"
                            },
                            weekday_int_start_1 = "leaf",
                          }
                        }
                      }
                    }
                  }
                },
              }
            }
          }
        },
        neg_int = "leaf",
      },
      float = {
        pos_float = "leaf",
        neg_float = "leaf",
      },
      pos_number = "leaf",
      neg_number = "leaf",
      zero = "leaf",
    },
    fn = {
  
    },
    ["nil"] = "leaf",
    not_int = "leaf",
    userdata = {
      full_userdata = {
        window = "leaf",
        running_application = "leaf"
      },
      light_userdata = "leaf"
    }
  }
}

-- add array versions of all other types

thing_name_hierarchy.any.table.only_int_key_table.arr.any_arr =
  transf.table.table_by_mapped_nested_w_kt_arg_kt_ret_fn_only_primitive_is_leaf(
    thing_name_hierarchy.any, 
    function (k)
      return k .. "_arr"
    end
  )

thing_name_hierarchy.any.table.only_int_key_table.arr.mult_anys__arr =
  transf.table.table_by_mapped_nested_w_kt_arg_kt_ret_fn_only_primitive_is_leaf(
    thing_name_hierarchy.any, 
    function (k)
      return k .. "__arr"
    end
  )

-- add nested array versions of all other types (for now, this level of nesting is what we'll leave it at)

thing_name_hierarchy.any.table.only_int_key_table.arr.any_arr.table_arr.only_int_key_table_arr.arr_arr.any_arr_arr = 
  transf.table.table_by_mapped_nested_w_kt_arg_kt_ret_fn_only_primitive_is_leaf(
    thing_name_hierarchy.any.table.only_int_key_table.arr.any_arr, 
    function (k)
      return k .. "_arr"
    end
  )

thing_name_hierarchy.any.table.only_int_key_table.arr.any_arr.table_arr.only_int_key_table_arr.arr_arr.mult_anys__arr_arr =
  transf.table.table_by_mapped_nested_w_kt_arg_kt_ret_fn_only_primitive_is_leaf(
    thing_name_hierarchy.any.table.only_int_key_table.arr.any_arr, 
    function (k)
      return k .. "__arr"
    end
  )