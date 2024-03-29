thing_name_hierarchy = {
  mult_anys = {
    one_to_three_anys = {
      two_anys = {
        two_numbers = "leaf",
        two_strs = {
          snake_case_and_str = "leaf",
        },
        two_arrs = "leaf",
      },
      three_anys = {
        three_strs = {
          rfc3339like_y_and_rfc3339like_ym_and_rfc3339like_ymd = "leaf",
        },
        number_and_two_anys = "leaf",
      },
      one_to_three_numbers = {
        one_to_three_pos_ints = {
          dtprts = "leaf"
        }
      }
    }
  },
  any = {
    bool = {
      ["true"] = "leaf",
      ["false"] = "leaf",
    },
    having_metatable = {
      metatable_comparable = "leaf",
      metatable_addable = "leaf",
    },
    operational_comparable = "leaf",
    operational_addable = "leaf",
    operational_addcomparable = "leaf",
    not_userdata_o_fn = {
      not_userdata_fn_even_nested = {
        not_userdata_o_fn_even_nested_notblkeytblval = {
          not_userdata_o_fn_even_nested_only_pos_int_or_str_key_table = "leaf"
        }
      }
    },
    lower_alphanum_underscore_or_lower_alphanum_underscore_arr_ = "leaf",
    str = {
      content_starting_lt_ending_gt_str = {
        doctype_starting_str = "leaf",
        xml_declaration_starting_str = "leaf",
        html_starting_str = "leaf",
        sgml_document = "leaf",
      },
      email_or_displayname_email = "leaf",
      empty_str = "leaf",
      json_str = "leaf",
      yaml_str = "leaf",
      toml_str = "leaf",
      not_starting_with_whitespace_str = "leaf",
      not_ending_with_whitespace_str = "leaf",
      not_starting_o_ending_with_whitespace_str = "leaf",
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
          hydrus_relationship_block = "leaf",
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
        noempty_noindent_line = {
          noempty_noindent_hashcomment_line = "leaf",
          noempty_noindent_nohashcomment_line = "leaf",
        },
        ini_section_line = "leaf",
        trimmed_line = {
          displayname_email = "leaf",
        },
        noweirdwhitespace_line = {
          mod_symbol = "leaf",
          path_component = {
            leaflike = {
              name_of_useless_file = "leaf",
              extension = {
                bin_extension = {
                  db_extension = {
                    sql_extension = {
                      sqlite_extension = "leaf",
                    },
                    
                  },
                  playable_extension = {
                    whisper_extension = "leaf",
                    video_extension = "leaf",
                    audio_extension = "leaf",
                  }
                },
                plaintext_extension = {
                  plaintext_table_extension = "leaf",
                  plaintext_assoc_extension = "leaf",
                },
                image_extension = "leaf",
                hydrusable_extension = "leaf",
              },
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
                    hydrusable_file = "leaf",
                    plaintext_file = { 
                      url_file = "leaf",
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
                    in_proc_local_absolute_path = {
                      in_proc_pull_local_absolute_path = "leaf",
                      in_proc_local_local_absolute_path = {
                        in_proc_old_local_absolute_path = {
                          old_location_logs_proc_dir = "leaf",
                          old_media_logs_proc_dir = "leaf",
                        },
                        in_proc_hydrus_local_absolute_path = "leaf"
                      },
                    },
                    in_me_local_absolute_path = {
                      in_mcitations_local_absolute_path = "leaf",
                      in_mpapers_local_absolute_path = "leaf",
                      in_menv_absolute_path = "leaf",
                    },
                    in_cache_local_absolute_path = {
                      in_hs_cache_local_absolute_path = {
                        in_cache_export_local_absolute_path = {
                          export_dir = {
                            telegram_export_dir = "leaf",
                            discord_export_dir = "leaf",
                            facebook_export_dir = "leaf",
                            signal_export_dir = "leaf",
                          },
                          discord_export_child_dir = "leaf",
                        }
                      }
                      
                    },
                    in_tmp_local_absolute_path = {
                      git_tmp_log_dir = "leaf",
                      mpv_tmp_log_dir = "leaf",
                    },
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
                        project_dir = {
                          client_project_dir = "leaf"
                        },
                        latex_project_dir = "leaf",
                        omegat_project_dir = "leaf",
                        npm_project_dir = "leaf",
                        cargo_project_dir = "leaf",
                        sass_project_dir = "leaf"
                      },
                      dotapp_dir = {
                        installed_app_dir = "leaf",
                      },
                      maildir_dir = "leaf"
                    },
                    local_file = {
                      empty_local_file = "leaf",
                      nonempty_local_file = "leaf",
                      maildir_file = "leaf",
                      local_image_file = {
                        loca_svg_fie = "leaf",
                      },
                      local_hydrusable_file = "leaf",
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
          lua_escapable_ascii_char = "leaf",
        },
        printable_ascii_str = {
          printable_ascii_multiline_str = {
            email_header_block = "leaf",
          },
          printable_ascii_char = {
            base_letter = "leaf",
            rfc3339like_dt_separator = "leaf",
            mouse_button_char = "leaf",
            lua_regex_metacharacter = "leaf",
            general_regex_metacharacter = "leaf",
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
                  mac_application_name = {
                    running_mac_application_name = "leaf",
                    jxa_browser_name = "leaf",
                    jxa_tabbable_name = "leaf",
                    jxa_browser_tabbable_name = "leaf",
                  },
                },
                separated_nonindicated_number_str = {
                  separated_nonindicated_bin_number_str = "leaf",
                  separated_nonindicated_hex_number_str = "leaf",
                  separated_nonindicated_oct_number_str = "leaf",
                  separated_nonindicated_dec_number_str = "leaf",
                },
                alphanum_minus_underscore_space_str = {
                  alphanum_space_str = {
                    vcard_addr_key = "leaf",
                  },
                },
                printable_ascii_not_whitespace_str = {
                  startswith_percent_printable_ascii_not_whitespace = {
                    rfc3339like_dt_format_str = "leaf",
                    dt_format_part = {
                      rfc3339like_dt_format_part = "leaf",
                    },
                    rfc3339like_dt_str_format_part = "leaf"
                  },
                  startswith_at_printable_ascii_not_whitespace = {
                    handle = "leaf",
                  },
                  package_name = {
                    installed_package_name = "leaf",
                  },
                  package_name_package_manager_name_compound_str = "leaf",
                  package_name_semver_compound_str = "leaf",
                  package_name_semver_package_manager_name_compound_str = "leaf",
                  urlcharset_str = {
                    url = {
                      nofragment_url = {
                        clean_url = {
                          base_url = {
                            dotgit_url = "leaf",
                          },
                        },
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
                        pornpen_style_post_url = "leaf",
                        hydrus_style_file_endpoint_url = "leaf",
                      },
                      authority_url = {
                        host_url = {
                          pornpen_url = "leaf",
                          hydrus_url = "leaf",
                          canon_booru_url = {
                            danbooru_url = "leaf",
                            gelbooru_url = "leaf",
                            canon_booru_post_url = {
                              danbooru_post_url = "leaf",
                              gelbooru_post_url = "leaf",
                            }
                          },
                          youtube_url = {
                            youtube_path_url = {
                              youtube_video_url = "leaf",
                              youtube_playlist_url = "leaf",
                              youtube_playable_url = "leaf",
                              youtube_channel_url = "leaf",
                              youtube_video_feed_url = {
                                youtube_channel_video_feed_url = "leaf",
                                youtube_playlist_video_feed_url = "leaf",
                              }
                            }
                          }
                        }
                      },
                      query_url = {
                        gelbooru_style_post_url = "leaf",
                        hydrus_style_single_hash_url = "leaf",
                        hydrus_style_multi_hash_url = "leaf",
                      },
                      fragment_url = "leaf",
                      username_url = "leaf",
                      password_url = "leaf",
                      userinfo_url = "leaf",
                      pornpen_post_url = "leaf",
                      github_url = {
                        github_path_url = {
                          github_user_url = "leaf"
                        }
                      },
                      hydrus_style_file_url = {
                        local_hydrus_file_url = "leaf",
                      },
                      hydrusable_url = {
                        hydrusable_post_url = "leaf",
                        hydrusable_file_url = "leaf",
                        hydrusable_page_url = "leaf",
                        hydrusable_gallery_url = "leaf",
                      }
                    },
                    urllike_with_no_scheme = {
                      owner_item_urllike = "leaf",
                    },
                    query_k_o_v = "leaf",
                    query_mapping = "leaf",
                    query_str = "leaf",
                    fs_tag_kv = "leaf",
                    cronspec_str = "leaf",
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
                    email = "leaf",
                    dice_notation = "leaf",
                    
                    doi = "leaf",
                    semver_str = "leaf",
                    indicated_isbn = "leaf",
                    indicated_pmid = "leaf",
                    indicated_doi = "leaf",
                    indicated_isbn_part = "leaf",
                    indicated_pcmid = "leaf",
                    indicated_accession = "leaf",
                    indicated_issn_full = "leaf",
                    indicated_urlmd5 = "leaf",
                    indicated_citable_object_id = {
                      filename_safe_indicated_citable_object_id = "leaf"
                    },
                    percent_encoded_octet = "leaf",
                    lower_alphanum_underscore_comma = "leaf",
                    
                    pcp_alphanum_minus_underscore = {
                      url_scheme = "leaf",
                      api_request_kv_location = "leaf",
                      colon_period_alphanum_minus_underscore = {
                        indicated_utf8_hex_str = "leaf",
                        rfc3339like_dt_o_interval = {
                          rfc3339like_dt = {
                            full_rfc3339like_dt = "leaf",
                            rfc3339like_y = "leaf",
                            rfc3339like_ym = "leaf",
                            rfc3339like_ymd = "leaf",
                          },
                          rfc3339like_interval = "leaf",
                        },
                        colon_alphanum_minus_underscore = {
                          calendar_name = {
                            writeable_calendar_name = "leaf",
                          },
                          device_identifier = "leaf",
                          colon_alphanum_minus = {
                            colon_minus_num = {
                              colon_num = {
                                hour = "leaf",
                                hour_minute = "leaf",
                                hour_minute_second = "leaf",
                                twod_locator = "leaf"
                              },
                              int_ratio_str = "leaf",
                              slice_notation = "leaf",  
                            },
                            ipv6 = "leaf",
                          },
                          alphanum_minus_underscore = {
                            csl_key = "leaf",
                            lower_alphanum_minus_underscore = {
                              machine_arch = "leaf",
                            },
                            snakekebap_case = {
                              strict_snakekebap_case = {
                                lower_strict_snakekebap_case = {
                                  pass_item_name = {
                                    auth_pass_item_name = {
                                      otp_pass_item_name = "leaf",
                                      passw_pass_item_name = "leaf",
                                      recovery_pass_item_name = "leaf",
                                      secq_pass_item_name = "leaf",
                                      username_pass_item_name = "leaf",
                                      login_pass_item_name = "leaf"
                                    },
                                    cc_pass_item_name = "leaf",
                                  },
                                  csl_type = "leaf",
                                }
                              }
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
                                digit_interval_str = "leaf",
                              },
                              kernel_name = "leaf",
                              os_common_subname = "leaf",
                              upper_alphanum_minus ="leaf",
                              kebap_case = {
                                strict_kebap_case = {
                                  bcp_47_language_tag = {
                                    basic_locale = "leaf",
                                  },
                                  upper_strict_kebap_case = "leaf",
                                  lower_strict_kebap_case = {
                                    csl_style = "leaf",
                                    stream_boolean_attribute = "leaf",
                                  },
                                  mixed_strict_kebap_case = {
                                    camel_strict_kebap_case = {
                                      upper_camel_strict_kebap_case = "leaf",
                                      lower_camel_strict_kebap_case = "leaf",
                                    }
                                  }
                                }
                              }
                            },
                            alphanum_underscore = {
                              lower_alphanum_underscore = {
                                general_name = {
                                  function_container_name = "leaf",
                                  thing_name_with_optional_explanation = {
                                    thing_name = "leaf"
                                  }
                                },
                              },
                              upper_alphanum_underscore = "leaf",
                              snake_case = {
                                strict_snake_case = {
                                  upper_strict_snake_case = "leaf",
                                  lower_strict_snake_case = {
                                    citable_object_id_indication_name = "leaf",
                                    client_id = "leaf",
                                    client_project_kind = "leaf",
                                    billing_unit = "leaf",
                                    markdown_extension_name = "leaf",
                                    backup_type = "leaf",
                                    root_hydrus_tag_namespace = {
                                      global_value_taking_root_hydrus_tag_namespace = "leaf",
                                    },
                                    root_hydrus_note_namespace = "leaf",
                                    dynamic_structure_name = "leaf",
                                    api_name = "leaf",
                                    secondary_api_name = "leaf",
                                    pandoc_basic_format = "leaf",
                                    search_engine_id = "leaf",
                                    creation_specifier_type = "leaf",
                                    bin_specifier_name = "leaf",
                                    unicode_char_prop = "leaf",
                                    unicode_emoji_prop = "leaf",
                                  },
                                  mixed_strict_snake_case = {
                                    camel_strict_snake_case = {
                                      upper_camel_strict_snake_case = "leaf",
                                      lower_camel_strict_snake_case = "leaf",
                                    }
                                  }
                                }
                              }
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
                                  audiodevice_subtype = "leaf",
                                  otp_type = "leaf",
                                  llm_chat_role = "leaf",
                                  stream_state = "leaf",
                                  flag_profile_name = "leaf",
                                  markdown_extension_set_name = "leaf",
                                  booru_rating = "leaf",
                                  external_tag_namespace = {
                                    danbooru_category_name = "leaf",
                                  },
                                  type_name = "leaf",
                                  youtube_upload_status = {
                                    youtube_exists_upload_status = "leaf",
                                  },
                                  youtube_privacy_status = "leaf",
                                  likely_main_branch_name = "leaf",
                                  linux_chassis = "leaf",
                                },
                                iso_3366_1_alpha_2_country_code = "leaf",
                                iso_3366_1_alpha_3_country_code = "leaf",
                                iso_639_1_language_code = "leaf",
                                iso_639_3_language_code = "leaf",
                                mullvad_city_code = "leaf",
                                menu_item_key = "leaf",
                                vcard_key_with_vcard_type = "leaf",
                              },
                              hex_str = {
                                byte_hex_str = "leaf",
                                two_byte_hex_str = "leaf",
                                sha1_hex_str = "leaf",
                                sha256_hex_str = {
                                  hydrus_file_hash = "leaf",
                                },
                                hydrus_service_key = "leaf",
                                git_sha1_hex_str = {
                                  full_sha1_hex_str = "leaf",
                                  short_sha1_hex_str = "leaf",
                                },
                              },
                              digit_str = {
                                bin_str = "leaf",
                                oct_str = "leaf",
                                cleaned_payment_card_number = "leaf"
                              },
                              base32_gen_str = "leaf",
                              base32_crock_str = "leaf",
                              base32_str = "leaf",
                              lower_camel_case = "leaf",
                              upper_camel_case = "leaf",
                              indicated_hex_str = {
                                fnid = "leaf"
                              },
                              indicated_bin_str = "leaf",
                              indicated_oct_str = "leaf",
                              indicated_dec_str = "leaf",
                              token_type = "leaf",
                              pos_int_dimensions_str = "leaf",
                            },
                          }
                        },
                        period_alphanum_minus_underscore = {
                          period_alphanum_minus = {
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
                              },
                              bundle_id = "leaf",
                            }
                          }
                        },
                      },
                    },
                  },
                  
                },
                url_or_local_path = "leaf"
              },
              iban = "leaf",
              shell_shebang = "leaf",
            },
          }
        }
      },
    },
    table = {
      only_pos_int_key_table = {
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
        has_id_key_table = "leaf",
        has_index_key_table = "leaf",
        created_item_specifier = {
          stream_created_item_specifier = {
            alive_stream_created_item_specifier = "leaf"
          },
          fireable_created_item_specifier = {
            hotkey_created_item_specifier = "leaf",
            watcher_created_item_specifier = "leaf",
          }
        },
        geojson_obj = {
          geojson_feature_collection = "leaf",
          geojson_feature = "leaf",
        },
        creation_specifier = {
          watcher_creation_specifier = "leaf",
          hotkey_creation_specifier = "leaf",
          stream_creation_specifier = "leaf",
        },
        audiodevice_specifier = {},
        csl_table = {
          whole_book_type_csl_table = "leaf",
          book_chapter_type_csl_table = "leaf",
          whole_book_csl_table = "leaf",
        },
        input_spec = {
          declared_input_spec = {
            declared_click_input_spec = "leaf",
            declared_key_input_spec = "leaf",
            declared_move_input_spec = "leaf",
            declared_scroll_input_spec = "leaf",
            declared_position_change_input_spec = "leaf",
          },
          click_input_spec = "leaf",
          key_input_spec = "leaf",
          position_change_input_spec = "leaf",
        },
        unicode_prop_table = "leaf",
        prompt_args_spec = {
          str_prompt_args_spec = "leaf",
        },
        cut_specifier = {
          interval_specifier = {
            number_interval_specifier = {
              int_interval_specifier = {
                timestamp_s_interval_specifier = {
                  timestamp_s_sequence_specifier = "leaf",
                },
              }
            },
            sequence_specifier = "leaf",
          },
        },
        gpt_response_table = "leaf",
        iban_data_spec = "leaf", 
        contact_table = "leaf",
        ical_spec = "leaf",
        tree_node = "leaf",
        role_content_message_spec = {
          system_role_content_message_spec = "leaf",
          user_role_content_message_spec = "leaf",
          assistant_role_content_message_spec = "leaf",
          function_role_content_message_spec = "leaf",
        },
        val_dep_spec = "leaf",
        n_shot_llm_spec = "leaf",
        syn_specifier = "leaf",
        vdirsyncer_pair_specifier = "leaf",
        email_speciier = "leaf",
        semver_component_specifier = "leaf",
        reaction_spec = "leaf",
        export_chat_main_object = {
          telegram_export_chat_main_object = "leaf",
          discord_export_chat_main_object = "leaf",
          facebook_export_chat_main_object = "leaf",
          signal_export_chat_main_object = "leaf",
        },
        telegram_export_chat_message = "leaf",
        discord_export_chat_message = "leaf",
        facebook_export_chat_message = "leaf",
        signal_export_chat_message = "leaf",
        url_components = "leaf",
        csl_person = "leaf",
        dcmp_spec = {
          full_dcmp_spec = "leaf",
          cont_dcmp_spec = {
            prefix_dcmp_spec = "leaf",
            suffix_dcmp_spec = "leaf",
          }
        },
        str_format_part_specifier = "leaf",
        youtube_api_item = {
          youtube_video_item = "leaf",
          youtube_playlist_item = "leaf",
          youtube_caption_item = "leaf",
          youtube_channel_item = "leaf",
        },
        fn_queue_specifier = "leaf",
        prompt_spec = "leaf",
        hs_geometry = "leaf",
        hs_geometry_point_like = {
          hs_geometry_point = "leaf",
          point_spec = "leaf",
        },
        hs_geometry_rect_like = {
          hs_geometry_rect = "leaf",
          rect_spec = "leaf",
        },
        hs_geometry_size_like = {
          hs_geometry_size = "leaf",
          size_spec = "leaf",
        },
        form_filling_specifier = "leaf",
        form_field_specifier = "leaf",
        timer_spec = "leaf",
        retriever_specifier = {
          partial_retiever_specifier = "leaf",
        },
        chooser_item_specifier = {
          index_chooser_item_specifier = "leaf",
        },
        menu_item_table = "leaf",
        jxa_windowlike_specifier = {
          jxa_tab_specifier = {
            browser_jxa_tab_specifier = "leaf"
          },
          jxa_window_specifier = {
            tabbable_jxa_window_specifier = {
              browser_tabbable_jxa_window_specifier = "leaf"
            }
          },
          browser_jxa_windowlike_specifier = "leaf"
        },
        detailed_env_node = "leaf",
        hschooser_specifier = "leaf",
        choosing_hschooser_specifier = "leaf",
        url_table = "leaf",
        total_cost_specifier = "leaf",
        price_specifier = "leaf",
        msg_spec = "leaf",
        path_key_haver = "leaf",
        location_log_spec = {
          old_location_log_spec = "leaf",
        },
        timestamp_ms_key_haver = {
          media_log_spec = "leaf",
        },
        plist_single_dk_spec = {
          plist_single_dkv_spec = "leaf",
        },
        hydrus_rel_spec = "leaf",
        hydrus_metadata_spec = "leaf",
        hydrus_internal_tag_spec = "leaf",
        hydrus_url_spec = "leaf",
        danbooru_tag_record = "leaf",
        danbooru_tag_implication_record = "leaf",
        danbooru_hydrus_inference_specifier = "leaf",
        composite_tag_specifier = "leaf",
        bin_specifier = "leaf",
        keymap_spec = "leaf",
      }
    },
    primitive = {
  
    },
    number = {
      inclusive_proper_fraction = {
        proper_fraction = "leaf",
      },
      int = {
        timestamp_s  = {
          reasonable_timestamp_s = "leaf",
        },
        timestamp_ms = {
          reasonable_timestamp_ms = "leaf",
        },
        even_int = "leaf",
        pos_int = {
          hydrus_file_id = "leaf",
          eightbyte_pos_int = {
            fourbyte_pos_int = {
              twobyte_pos_int = {
                byte_pos_int = {
                  halfbyte_pos_int = {
                    percentage_pos_int = {
                      iso_weeknumber_int = "leaf",
                      nibble_pos_int = {
                        sme_10_pos_int = {
                          sme_8_pos_int = {
                            sme_7_pos_int = {
                              sme_6_pos_int = {
                                sme_5_pos_int = {
                                  sme_4_pos_int = {
                                    sme_3_pos_int = "leaf"
                                  }
                                },
                                weekday_int_start_0 = "leaf",
                                date_component_index = "leaf",
                                zero = "leaf",
                                one = "leaf",
                              },
                              weekday_int_start_1 = "leaf",
                            }
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
        running_application = "leaf",
        hs_image = "leaf",
        styledtext = "leaf",
        audiodevice = "leaf",
        watcher = "leaf",
        hs_hotkey = "leaf",
        hs_screen = "leaf",
        window_filter = "leaf",
      },
      light_userdata = "leaf"
    }
  }
}

-- add array versions of all other types

thing_name_hierarchy.any.table.only_pos_int_key_table.arr.any_arr =
  transf.table.table_by_mapped_nested_w_kt_arg_kt_ret_fn_only_primitive_is_leaf(
    thing_name_hierarchy.any, 
    function (k)
      return k .. "_arr"
    end
  )

thing_name_hierarchy.any.table.only_pos_int_key_table.arr.mult_anys__arr =
  transf.table.table_by_mapped_nested_w_kt_arg_kt_ret_fn_only_primitive_is_leaf(
    thing_name_hierarchy.any, 
    function (k)
      return k .. "__arr"
    end
  )

-- add nested array versions of all other types (for now, this level of nesting is what we'll leave it at)

thing_name_hierarchy.any.table.only_pos_int_key_table.arr.any_arr.table_arr.only_pos_int_key_table_arr.arr_arr.any_arr_arr = 
  transf.table.table_by_mapped_nested_w_kt_arg_kt_ret_fn_only_primitive_is_leaf(
    thing_name_hierarchy.any.table.only_pos_int_key_table.arr.any_arr, 
    function (k)
      return k .. "_arr"
    end
  )

thing_name_hierarchy.any.table.only_pos_int_key_table.arr.any_arr.table_arr.only_pos_int_key_table_arr.arr_arr.mult_anys__arr_arr =
  transf.table.table_by_mapped_nested_w_kt_arg_kt_ret_fn_only_primitive_is_leaf(
    thing_name_hierarchy.any.table.only_pos_int_key_table.arr.any_arr, 
    function (k)
      return k .. "__arr"
    end
  )