thing_name_hierarchy = {
  two_anys = {
    two_numbers = "leaf"
  },
  any = {
    str = {
      empty_str = "leaf",
      not_starting_with_whitespace_str = "leaf",
      not_ending_with_whitespace_str = "leaf",
      not_empty_str = {
        
        whitespace_str = {
          starting_with_whitespace_str = "leaf",
          ending_with_whitespace_str = "leaf",
          starting_or_ending_with_whitespace_str = "leaf",
          starting_and_ending_with_whitespace_str = "leaf",
        },
        starting_with_dot_str = "leaf",
        multiline_str = "leaf"
      },
      line = {
        not_whitespace_str = "leaf",
        indent_line = "leaf",
        noindent_line = "leaf",
        comment_line = "leaf",
        nocomment_line = "leaf",
        trailing_whitespace_line = "leaf",
        notrailing_whitespace_line = "leaf",
        noempty_line = "leaf",
        noempty_nocomment_line = "leaf",
        noempty_nocomment_noindent_line = "leaf",
        trimmed_line = "leaf",
        noweirdwhitespace_line = {
          leaflike = {
            extension = "leaf",
            citable_filename = "leaf"
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
                    git_root_dir = "leaf",
                    logging_dir = "leaf",
                  },
                  file = {
                    empty_file = "leaf",
                    nonempty_file = "leaf",
                    image_file = "leaf",
                    email_file = "leaf",
                    plaintext_file = { 
                      shellscript_file = {
                        shellscript_file_with_errors = "leaf",
                        shellscript_file_with_warnings = "leaf",
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
                    binary_file = {
                      db_file = "leaf",
                      playable_file = {
                        whisper_file = "leaf"
                      }
                    }
                  },
                  in_git_dir = {
                    in_has_changes_git_dir = "leaf",
                    in_has_unpushed_commits_git_dir = "leaf",
                  },
                },
                nonextant_path = "leaf"
              },
              path_with_intra_file_locator = "leaf",
            },
            local_path = {
              local_nonabsolute_path = {
                local_tilde_path = "leaf"
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
        printable_ascii_str = {
          printable_ascii_no_nonspace_whitespace_str = {
            application_name = {
              mac_application_name = "leaf",
            },
            printable_ascii_not_whitespace_str = {
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
              email_address = "leaf",
              dice_notation = "leaf",
              installed_package_name = "leaf",
              doi = "leaf",
              indicated_isbn = "leaf",
              indicated_pmid = "leaf",
              indicated_doi = "leaf",
              indicated_isbn_part_identifier = "leaf",
              indicated_pcmid = "leaf",
              indicated_accession = "leaf",
              indicated_issn_full_identifier = "leaf",
              indicated_urlmd5 = "leaf",
              indicated_citable_object_id = "leaf",
              colon_period_alphanum_minus_underscore = {
                colon_alphanum_minus_underscore = {
                  calendar_name = {
                    writeable_calendar_name = "leaf",
                  },
                  alphanum_minus_underscore = {
                    package_manager_name = "leaf",
                    pass_item_name = {
                      otp_pass_item_name = "leaf",
                      passw_pass_item_name = "leaf",
                      recovery_pass_item_name = "leaf",
                      secq_pass_item_name = "leaf",
                      username_pass_item_name = "leaf",
                      login_pass_item_name = "leaf"
                    },
                    alphanum_minus = {
                      isbn10 = "leaf",
                      isbn13 = "leaf",
                      issn = "leaf",
                      isbn = "leaf",
                      uuid = {
                        contact_uuid = "leaf",
                        null_uuid = "leaf",
                      },
                      relay_identifier = "leaf",
                    },
                    alphanum_underscore = {
                      lower_alphanum_underscore = "leaf",
                      upper_alphanum_underscore = "leaf",
                    },
                    alphanum = {
                      alpha_str = {
                        upper_alpha_str = "leaf",
                        lower_alpha_str = {
                          fs_attr_name = "leaf",
                        },
                      },
                      digit_str = {
    
                      },
                      base32_gen_str = "leaf",
                      base32_crock_str = "leaf",
                      base32_str = "leaf",
                    },
                  }
                },
                period_alphanum_minus_underscore = {
                  number_str = "leaf",
                  indicated_number_str = "leaf",
                  indicated_binary_number_str = "leaf",
                  indicated_hex_number_str = "leaf",
                  indicated_octal_number_str = "leaf",
                  indicated_decimal_number_str = "leaf",
                  domain_name = {
                    source_id = {
                      active_source_id = "leaf",
                    }
                  }
                },
                
                number_str = {
                  indicated_number_str = "leaf",
                  nonindicated_number_str = "leaf"
                }
              },
            },
            url = {
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
              booru_post_url = "leaf",
              github_url = "leaf"
            },
          },
          iban = {},
        },
      },
    },
    table = {
      only_int_key_table = {
        arr = {
  
        },
        hole_y_arrlike = "leaf"
      },
      empty_table = "leaf",
      non_empty_table = {
        date = "leaf",
        str_key_non_empty_table = {
  
        }
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
        pos_int = "leaf",
      },
      float = "leaf",
      pos_number = "leaf",
      neg_number = "leaf",
      zero = "leaf",
    }, 
    fn = {
  
    },
    ["nil"] = "leaf",
    not_int = "leaf"
  }
}