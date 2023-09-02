thing_name_hierarchy = {
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
            absolute_path = {
              extant_path = {
                dir = {
                  empty_dir = "leaf",
                  nonempty_dir = {
                    grandparent_dir = "leaf",
                  }
                },
                file = {
                  empty_file = "leaf",
                  nonempty_file = "leaf"
                }
              }
            },
            path_with_intra_file_locator = "leaf",
            volume = "leaf"
          },
          local_path = {
            local_absolute_path = {
              local_extant_path = {
                local_dir = {
                  local_empty_dir = "leaf",
                  local_nonempty_dir = "leaf"
                }
              }
            },
          }
        }
      },
      
    },
    ascii_str = {
      printable_ascii_str = {
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
                  lowercase_alphanum_underscore = 
                },
                package_manager = {}
              },
            },
            period_alphanum_minus_underscore = {
              number_str = "leaf",
              indicated_number_str = "leaf",
              indicated_binary_number_str = "leaf",
              indicated_hex_number_str = "leaf",
              indicated_octal_number_str = "leaf",
              indicated_decimal_number_str = "leaf"
            },
            
            number_str = {
              indicated_number_str = "leaf",
              nonindicated_number_str = "leaf"
            }
          },
        },
        url = {},
        iban = {},
      },
    },
  },
  table = {
    created_item_specifier = {
      stream_created_item_specifier = "leaf"
    }
  },
  number = {
    int = {
      timestamp_s = "leaf",
      timestamp_ms = "leaf",
    },
    float = "leaf",
    pos_number = "leaf",
    neg_number = "leaf",
  }
}