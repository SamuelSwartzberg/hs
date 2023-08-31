
--- `act.\<source>.\<action>` - do action on source
--- Only take one argument, which is the source.
--- For actions that take more than one argument, see op.lua, and `op.\<source>.\<action>`.
act = {
  mullvad_relay_identifier = {
    set_active_mullvad_relay_dentifier = function(id)
      dothis.string.env_bash_eval("mullvad relay set hostname " .. id)
    end,
  },
  package_manager_name = {
    install_self = function(mgr)
      dothis.string.env_bash_eval_async("upkg " .. mgr .. " install-self")
    end,
    install_missing = function(mgr)
      dothis.string.env_bash_eval_async("upkg " .. mgr .. " install-missing")
    end,
    upgrade_all = function(mgr)
      dothis.string.env_bash_eval_async("upkg " .. mgr .. " upgrade-all")
    end,
    backup = function(mgr)
      dothis.package_manager_name.do_backup_and_commit(mgr, "backup", "backup packages")
    end,
    delete_backup = function(mgr)
      dothis.package_manager_name.do_backup_and_commit(mgr, "delete-backup", "delete backup of packages")
    end,
    replace_backup = function(mgr)
      dothis.package_manager_name.do_backup_and_commit(mgr, "replace-backup", "replace backup of packages")
    end,
  },
  event_search_spec = {
    --- edit event by adding new event and deleting old one (necessary since khal won't allow us to use a GUI editor (Don't try, I've spent hours on this, it's not possible))
    edit_event = function(event_search_specifier)
      local event_table = get.khal.search_event_tables(event_search_specifier.searchstr)[1]
      local do_after = function()
        dothis.event_search_spec.delete_event(event_search_specifier)
      end
      dothis.event_table.add_event_interactive(event_table, do_after)
    end,

    delete_event = function(event_search_specifier)
      local command = 
        "echo $'D\ny\n' | khal edit " .. get.khal.basic_command_parts(event_search_specifier.include, event_search_specifier.exclude) .. transf.string.single_quoted_escaped(event_search_specifier.searchstr)
      dothis.string.env_bash_eval(command)
    end,
  },
  event_table = {
    delete = function(event_table)
      act.event_search_spec.delete_event({ searchstr = event_table.uid, include = event_table.calendar})
    end,
    edit = function(event_table)
      act.event_search_spec.edit_event({ searchstr = event_table.uid, include = event_table.calendar})
    end,
    create_similar = function(event_table)
      act.khal.add_event_interactive(event_table)
    end,
    add_event_from_async = function(event_table)
      dothis.event_table.add_event_from(event_table, function() end)
    end,
    add_event_interactive_async = function(event_table)
      dothis.event_table.add_event_interactive(event_table, function() end)
    end,
  },
  vdirsyncer_pair_specifier = {
    write_to_config = function(spec)
      dothis.absolute_path.append_file_if_file(
        env.VDIRSYNCER_CONFIG .. "/config",
        "\n\n" .. transf.vdirsyncer_pair_specifier.ini_string(spec)
      )
      dothis.absolute_path.append_file_if_file(
        env.KHAL_CONFIG .. "/config",
        "\n\n" .. transf.url.ini_string_by_khal_config_section(url)
      )
      dothis.absolute_path.create_dir(
        transf.url.absolute_path_by_webcal_storage_location(url)
      )
      local name = transf.url.string_by_webcal_name(url)
      dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped(
        "vdirsyncer discover" ..
        transf.string.single_quoted_escaped(name),
        get.fn.first_n_args_bound_fn(
          dothis.string.env_bash_eval_async,
          "vdirsyncer sync" .. transf.string.single_quoted_escaped(name)
        )
      )
      dothis.in_git_dir.commit_self(
        env.KHAL_CONFIG .. "/config",
        "Add web calendar " .. name
      )
    end,
  },
  url = {
    add_event_to_default_calendar = function(url)
      dothis.url.add_event_from_url(url, "default")
    end,
    add_event_to_chosen_calendar = function(url)
      dothis.array.choose_item(transf["nil"].writeable_calendar_name_array(), function(calendar)
        dothis.url.add_event_from_url(url, calendar)
      end)
    end,
    download_into_downloads_async = function(url)
      dothis.url.download_into_async(url, env.DOWNLOADS)
    end,
    create_as_url_file_in_murls = function(url)
      act.url_array.create_as_url_files_in_murls({url})
    end,
    subscribe_to_calendar = function(url)
      local pair_spec = transf.url.vdirsyncer_pair_specifier(url)
      act.vdirsyncer_pair_specifier.write_to_config(pair_spec)
    end
  },
  ics_file = {
    add_events_to_default_calendar = function(ics_file)
      dothis.ics_file.add_events_from_file(ics_file, "default")
    end,
    add_events_to_chosen_calendar = function(ics_file)
      dothis.array.choose_item(transf["nil"].writeable_calendar_name_array(), function(calendar)
        dothis.ics_file.add_events_from_file(ics_file, calendar)
      end)
    end,
    generate_json_file = function(path)
      return dothis.string.env_bash_eval_async(
        "ical2json" .. transf.string.single_quoted_escaped(path)
      )
    end,
  },
  booru_post_url = {
    add_to_local = function(url)
      rest({
        api_name = "hydrus",
        endpoint = "add_urls/add_url",
        request_table = { url = url },
        request_verb = "POST",
      })
    end,
  },
  hs_geometry_size_like = {
    show_grid = function(grid)
      hs.grid.setGrid(grid)
      hs.grid.show()
    end,
  },
  url_or_local_path = {
    open_ff = function(url)
      dothis.url_or_local_path.open_browser(url, "Firefox")
    end,
    open_safari = function(url)
      dothis.url_or_local_path.open_browser(url, "Safari")
    end,
    open_chrome = function(url)
      dothis.url_or_local_path.open_browser(url, "Google Chrome")
    end,
  },
  url_array = {
    open_all_ff = function(url_array)
      dothis.url_array.open_all(url_array, "Firefox")
    end,
    create_as_url_files_in_murls = function(url_array)
      local path = transf.local_absolute_path.prompted_multiple_local_absolute_path_from_default(env.MURLS)
      dothis.url_array.create_as_url_files(url_array, path)
    end,
    create_as_session_in_msessions = function(url_array)
      dothis.url_array.create_as_session(url_array, env.MSESSIONS)
    end,
    create_as_stream_foreground = function(url_array)
      dothis.created_item_specifier_array.create(
        stream_arr,
        get.url_array.stream_creation_specifier(url_array, "foreground")
      )
    end,
    create_as_stream_background = function(url_array)
      dothis.created_item_specifier_array.create(
        stream_arr,
        get.url_array.stream_creation_specifier(url_array, "background")
      )
    end,
  },
  plaintext_url_or_local_path_file = {
    open_all_ff = function(path)
      dothis.plaintext_url_or_local_path_file.open_all(path, "Firefox")
    end,
  },
  stream_created_item_specifier = {
    set_playback_seconds_plus_15 = get.fn.arbitrary_args_bound_or_ignored_fn(dothis.stream_created_item_specifier.set_playback_seconds_relative, {a_use, 15}),
    set_playback_seconds_minus_15 = get.fn.arbitrary_args_bound_or_ignored_fn(dothis.stream_created_item_specifier.set_playback_seconds_relative, {a_use, -15}),
    set_playback_seconds_plus_60 = get.fn.arbitrary_args_bound_or_ignored_fn(dothis.stream_created_item_specifier.set_playback_seconds_relative, {a_use, 60}),
    set_playback_seconds_minus_60 = get.fn.arbitrary_args_bound_or_ignored_fn(dothis.stream_created_item_specifier.set_playback_seconds_relative, {a_use, -60}),
    set_playback_percent_plus_5 = get.fn.arbitrary_args_bound_or_ignored_fn(dothis.stream_created_item_specifier.set_playback_percent, {a_use, 5}),
    set_playback_percent_minus_5 = get.fn.arbitrary_args_bound_or_ignored_fn(dothis.stream_created_item_specifier.set_playback_percent, {a_use, -5}),
    set_state_transitioned_state = function(spec)
      spec.inner_item.state = transf.stream_created_item_specifier.transitioned_stream_state(spec)
    end,
    cycle_loop_playlist = function(spec)
      return dothis.mpv_ipc_socket_id.cycle_loop_playlist(spec.inner_item.ipc_socket_id)
    end,
    cycle_loop_playback = function(spec)
      return dothis.mpv_ipc_socket_id.cycle_loop_playback(spec.inner_item.ipc_socket_id)
    end,
    set_playlist_first = function(spec)
      return dothis.mpv_ipc_socket_id.set_playlist_first(spec.inner_item.ipc_socket_id)
    end,
    set_playlist_last = function(spec)
      return dothis.mpv_ipc_socket_id.set_playlist_last(spec.inner_item.ipc_socket_id)
    end,
    set_playback_first = function(spec)
      return dothis.mpv_ipc_socket_id.set_playback_first(spec.inner_item.ipc_socket_id)
    end,
    set_chapter = function(spec, chapter)
      return dothis.mpv_ipc_socket_id.set_chapter(spec.inner_item.ipc_socket_id, chapter)
    end,
    chapter_backwards = function(spec)
      return dothis.mpv_ipc_socket_id.chapter_backwards(spec.inner_item.ipc_socket_id)
    end,
    chapter_forwards = function(spec)
      return dothis.mpv_ipc_socket_id.chapter_forwards(spec.inner_item.ipc_socket_id)
    end,
    restart = function(spec)
      return dothis.mpv_ipc_socket_id.restart(spec.inner_item.ipc_socket_id)
    end,
    cycle_pause = function(spec)
      return dothis.mpv_ipc_socket_id.cycle_pause(spec.creation_specifier.ipc_socket_id)
    end,
    stop = function(spec)
      return dothis.mpv_ipc_socket_id.stop(spec.creation_specifier.ipc_socket_id)
    end,
    playlist_backwards = function(spec)
      return dothis.mpv_ipc_socket_id.playlist_backwards(spec.creation_specifier.ipc_socket_id)
    end,
    playlist_forwards = function(spec)
      return dothis.mpv_ipc_socket_id.playlist_forwards(spec.creation_specifier.ipc_socket_id)
    end,
    cycle_shuffle = function(spec)
      return dothis.mpv_ipc_socket_id.cycle_shuffle(spec.creation_specifier.ipc_socket_id)
    end,
  },
  stream_created_item_specifier_array = {
    set_state_transitioned_state_all = function(array)
      dothis.array.each(array, act.stream_created_item_specifier.set_state_transitioned_state)
    end,
    filter_in_place_valid = function(array)
      dothis.array.filter_in_place(array, transf.stream_created_item_specifier.is_valid)
    end,
    maintain_state = function(array)
      act.stream_created_item_specifier_array.set_state_transitioned_state_all(array)
      act.stream_created_item_specifier_array.filter_in_place_valid(array)
    end,

  },
  local_image_file = {
    add_hs_image_to_clipboard = function(path)
      dothis.hs_image.add_to_clipboard(
        transf.local_image_file.hs_image(path)
      )
    end,
    paste_hs_image = function(path)
      dothis.hs_image.paste(
        transf.local_image_file.hs_image(path)
      )
    end,
    paste_hs_image_and_delete = function(path)
      dothis.hs_image.paste(
        transf.local_image_file.hs_image(path)
      )
      dothis.absolute_path.delete(path)
    end,
    add_as_otp_with_prompted_name = function(path)
      act.otp_url.add_otp_pass_item_with_prompted_name(
        transf.local_image_file.qr_data(path)
      )
    end,
  },
  otp_url = {
    add_otp_pass_item_with_prompted_name = function(url)
      local name = get.string.alphanum_minus_underscore_string_by_prompted_once_from_default("", "Enter a name for the pass OTP item (alphanum minus underscore only):")
      dothis.otp_url.add_otp_pass_item(url, name)
    end,
  },
  local_path = {
    open_libreoffice_async = function(path)
      dothis.local_path.open_app(path, "LibreOffice", true)
    end,
  },
  local_dir = {
    git_init = function(path)
      dothis.local_extant_path.do_in_path(path, "git init")
    end,
  },
  env_yaml_file_container = {
    write_env_and_check = function(env_yaml_file_container)
      dothis.env_string.write_env_and_check(
        transf.env_yaml_file_container.env_string(env_yaml_file_container)
      )
    end,
  },
  indicated_citable_object_id = {
    edit_mcitations_csl_file = function(indicated_citable_object_id)
      dothis.local_path.open_app(
        transf.indicated_citable_object_id.mcitations_csl_file(indicated_citable_object_id),
        env.GUI_EDITOR
      )
    end,
    open_mpapers_citable_object_file = function(indicated_citable_object_id)
      dothis.local_path.open(
        transf.indicated_citable_object_id.mpapers_citable_object_file(indicated_citable_object_id)
      )
    end,

  },
  login_pass_item_name = {
    fill = function(name)
      dothis.string_array.fill_with({
        transf.pass_item_name.username_or_default(name),
        transf.pass_item_name.password(name),
      })
    end,
  },
  dict = {
    
  },
  volume_local_extant_path = {
    eject_or_err = function(path)
      hs.fs.volume.eject(path)
      if is.local_absolute_path.volume_local_extant_path(path) then
        error("Volume could not be ejected.", 0)
      end
    end,
    eject_or_msg = function(path)
      act.string.alert("Ejecting volume...")
      local succ, res = pcall(act.volume_local_extant_path.eject_or_err, path)
      if succ then
        act.string.alert("Volume ejected successfully.")
      else
        act.string.alert(res)
      end
    end
  },
  otpauth_url = {
    add_as_otp_by_prompted_name = function(url)
      local name = get.string.alphanum_minus_underscore_string_by_prompted_once_from_default("", "Enter a name for the pass OTP item (alphanum minus underscore only):")
      dothis.otpauth_url.add_as_otp(url, name)
    end,
  },
  md_file = {
    to_pdf_file_in_downloads = function(path)
      dothis.md_file.to_file_in_downloads(path, "pdf")
    end,
    to_revealjs_file_in_downloads = function(path)
      dothis.md_file.to_file_in_downloads(path, "revealjs")
    end,
  },
  email_file = {
    choose_attachment_and_choose_action = function(path)
      dothis.email_file.choose_attachment_and_download(path, dothis.any.choose_action)
    end,
  },
  alphanum_minus_underscore = {
    add_as_passw_pass_item_name_by_prompted_password = function(name)
      dothis.alphanum_minus_underscore.add_as_pass_item_name(
        name,
        get.string.string_by_prompted_once_from_default(
          transf.pos_int.random_base64_gen_string_of_length(32),
          "Enter a password, or confirm the generated 32-character base64 pregenerated one:"
        )
      )
    end,
    add_as_username_pass_item_name_by_prompted_username = function(name)
      dothis.alphanum_minus_underscore.add_as_username_pass_item_name(
        name,
        get.string.string_by_prompted_once_from_default(
          "",
          "Enter a username:"
        )
      )
    end,
  },
  date = {
    choose_format_and_action = function(dt)
      dothis.date.choose_format(
        dt,
        dothis.any.choose_action
      )
    end,
  },
  string = {
    say_ja = function(str)
      dothis.string.say(str, "ja")
    end,
    say_en = function(str)
      dothis.string.say(str, "en")
    end,
    log_in_diary = function(str)
      dothis.entry_logging_dir.log_string(
        env.MENTRY_LOGS,
        str
      )
    end,
    create_snippet = function(str)
      local path = get.local_extant_path.local_absolute_path_by_default_prompted_multiple(env.MCOMPOSITE .. "/snippets")
      dothis.absolute_path.write_file_if_nonextant_path(path, str)
    end,
    push_qf_music = function(str)
      dothis.plaintext_file.append_line_and_commit(
        env.MQF .. "/music",
        str
      )
    end,
    push_qf_things = function(str)
      dothis.plaintext_file.append_line_and_commit(
        env.MQF .. "/things",
        str
      )
    end,
    add_to_clipboard = hs.pasteboard.setContents,
    add_to_pasteboard_arr = function(str)
      dothis.array.move_to_front_or_unshift(
        pasteboard_arr,
        str
      )
    end,
    alert = function(str)
      dothis.string.alert(str, 10)
    end,
    search_wiktionary = function(query) dothis.search_engine.search("wiktionary", query) end,
    search_wikipedia = function(query) dothis.search_engine.search("wikipedia", query) end,
    search_youtube = function(query) dothis.search_engine.search("youtube", query) end,
    search_jisho = function(query) dothis.search_engine.search("jisho", query) end,
    search_glottopedia = function(query) dothis.search_engine.search("glottopedia", query) end,
    search_ruby_apidoc = function(query) dothis.search_engine.search("ruby_apidoc", query) end,
    search_python_docs = function(query) dothis.search_engine.search("python_docs", query) end,
    search_merriam_webster = function(query) dothis.search_engine.search("merriam_webster", query) end,
    search_dict_cc = function(query) dothis.search_engine.search("dict_cc", query) end,
    search_deepl_en_ja = function(query) dothis.search_engine.search("deepl_en_ja", query) end,
    search_deepl_de_en = function(query) dothis.search_engine.search("deepl_de_en", query) end,
    search_mdn = function(query) dothis.search_engine.search("mdn", query) end,
    search_scihub = function(query) dothis.search_engine.search("scihub", query) end,
    search_libgen = function(query) dothis.search_engine.search("libgen", query) end,
    search_semantic_scholar = function(query) dothis.search_engine.search("semantic_scholar", query) end,
    search_google_scholar = function(query) dothis.search_engine.search("google_scholar", query) end,
    search_google_images = function(query) dothis.search_engine.search("google_images", query) end,
    search_google_maps = function(query) dothis.search_engine.search("google_maps", query) end,
    search_danbooru = function(query) dothis.search_engine.search("danbooru", query) end,
    search_gelbooru = function(query) dothis.search_engine.search("gelbooru", query) end,
  },
  extant_path = {
    create_stream_foreground = function(path)
      dothis.created_item_specifier_array.create(
        stream_arr,
        get.extant_path.stream_creation_specifier(path, "foreground")
      )
    end,
    create_stream_background = function(path)
      dothis.created_item_specifier_array.create(
        stream_arr,
        get.extant_path.stream_creation_specifier(path, "background")
      )
    end,
    choose_item_and_action_by_descendants = function(path)
      act.array.choose_item_and_action(
        transf.extant_path.absolute_path_array_by_descendants(path)
      )
    end,
    choose_item_and_action_by_descendants_depth_3 = function(path)
      act.array.choose_item_and_action(
        transf.extant_path.absolute_path_array_by_descendants_depth_3(path)
      )
    end,
  },
  dir = {
    choose_item_and_action_by_children = function(path)
      act.array.choose_item_and_action(
        transf.dir.absolute_path_array_by_children(path)
      )
    end,
    choose_leaf_until_file_then_action = function(path)
      dothis.dir.choose_leaf_or_dotdot_until_file_w_file_arg_fn(
        path,
        dothis.any.choose_action
      )
    end,
    
  },
  volume_local_extant_path_array = {
    choose_item_and_eject_or_msg = function(array)
      dothis.array.choose_item(
        array,
        act.volume_local_extant_path.eject_or_msg
      )
    end,
  },
  ["nil"] = {
    ensure_sound_played_on_speakers = function()
      local device = hs.audiodevice.findOutputByName("Built-in Output")
      dothis.audiodevice.ensure_sound_will_be_played(device)
      dothis.audiodevice.set_default(device, "output")
    end,
    choose_menu_item_table_and_execute_by_frontmost_application = function()
      act.menu_item_table_array.choose_item_and_execute(
        transf["nil"].menu_item_table_array_by_frontmost_application()
      )
    end,
    choose_item_and_action_on_contact_table_array = function()
      act.array.choose_item_and_action(
        transf["nil"].contact_table_array()
      )
    end,
    choose_item_and_eject_or_msg_by_all_volumes = function()
      act.volume_local_extant_path_array.choose_item_and_eject_or_msg(
        transf["nil"].volume_local_extant_path_array()
      )
    end,
    choose_item_and_action_on_screenshot_children = function()
      act.dir.choose_item_and_action_by_children(env.SCREENSHOTS)
    end,
    show_2_by_4_grid = function()
      act.hs_geometry_size_like.show_grid({w=2, h=4})
    end,
    pop_main_qspec = function()
      dothis.fn_queue_specifier.pop(
        main_qspec
      )
    end,
    choose_item_and_set_active_mullvad_relay_identifier = function()
      act.mullvad_relay_identifier_array.choose_item_and_set_active(
        transf["nil"].mullvad_relay_identifier_array()
      )
    end,
    choose_inbox_email_and_action = function()
      act.array.choose_item_and_action(
        get.maildir_dir.sorted_email_paths(env.MBSYNC_INBOX, true)
      )
    end,
    choose_input_audiodevice_specifier_and_set_default = function()
      dothis.audiodevice_specifier_array.choose_item_and_set_default(
        transf.audiodevice_type.audiodevice_specifier_array("input")
      )
    end,
    choose_output_audiodevice_specifier_and_set_default = function()
      dothis.audiodevice_specifier_array.choose_item_and_set_default(
        transf.audiodevice_type.audiodevice_specifier_array("output")
      )
    end,
    choose_item_and_action_by_env_var = function()
      dothis.table.choose_w_vt_fn(
        env
      )
    end,
    sox_rec_toggle_and_act = function()
      dothis.sox.sox_rec_toggle_cache(dothis.any.choose_action)
    end,
    choose_action_on_current_date = function()
      dothis.any.choose_action(transf["nil"].date_by_current())
    end,
    choose_login_pass_item_name_and_fill = function()
      dothis.array.choose_item(
        transf["nil"].passw_pass_item_name_array(),
        act.login_pass_item_name.fill
      )
    end,
    choose_otp_pass_item_name_and_paste = function()
      dothis.array.choose_item(
        transf["nil"].otp_pass_item_name_array(),
        dothis.string.paste
      )
    end,
    activate_next_source_id = function()
      act.source_id_arr.activate_next(source_id_arr)
    end,
    maintain_state_stream_arr = function()
      act.stream_created_item_specifier_array.maintain_state(stream_arr)
    end,
    choose_action_on_first_running_stream = function()
      local strm = transf.stream_created_item_specifier_array.stream_created_item_specifier_by_first_running(stream_arr)
      if strm then
        dothis.any.choose_action(strm)
      else
        act.string.alert("No running streams.")
      end
    end,
    choose_action_on_first_item_in_pasteboard_arr = function()
      dothis.any.choose_action(
        pasteboard_arr[1]
      )
    end
  },
  mullvad_relay_identifier_array = {
    choose_item_and_set_active = function(array)
      dothis.array.choose_item(
        array,
        act.mullvad_relay_identifier.set_active_mullvad_relay_dentifier
      )
    end,
  },
  menu_item_table_array = {
    choose_item_and_execute = function(array)
      dothis.array.choose_item(
        array,
        dothis.menu_item_table.execute
      )
    end,
  },
  array = {
    choose_item_and_action = function(array)
      dothis.array.choose_item(array, dothis.any.choose_action)
    end,
    pop = function(array)
      local last = array[#array]
      array[#array] = nil
      return last
    end,
    shift = function(array)
      local first = array[1]
      table.remove(array, 1)
      return first
    end,
    to_empty_table = function(array)
      for i, v in transf.array.index_value_stateless_iter(array) do
        array[i] = nil
      end
    end,
    shuffle = get.fn.arbitrary_args_bound_or_ignored_fn(dothis.array.sort, {a_use, transf["nil"].random_boolean}),
  },
  contact_uuid = {
    edit_contact = function(uuid)
      dothis.contact_uuid.edit_contact(uuid)
    end
  },
  youtube_video_url = {
    add_as_m3u = function(url)
      local deduced_tags = transf.youtube_video_url.fs_tag_assoc(url)
      local edited_tags = transf.string_value_dict.string_value_dict_by_prompted_once_from_default(deduced_tags)
      local plspec = {}
      plspec.tag = transf.two_array_or_nils.array(edited_tags, transf.string.prompted_multiple_string_pair_array_for("tag"))
      plspec.path  = get.local_extant_path.dir_by_default_prompted_once(env.MAUDIOVISUAL)
      plspec.path = transf.string.prompted_once_string_from_default(plspec.path)
      plspec.extension = "m3u"
      dothis.absolute_path.write_file(transf.path_leaf_specifier.path(plspec), url)
    end,
  },
  source_id = {
    activate = function(source_id)
      hs.keycodes.currentSourceID(source_id)
      hs.alert.show(transf.source_id.language(source_id))
    end,
  },
  source_id_arr = {
    activate_next = function(arr)
      act.source_id.activate(
        transf.source_id_array.source_id_by_next_to_be_activated(arr)
      )
    end,
  },
  in_git_dir_array = {
    pull_all = function(paths)
      dothis.array.each(paths, dothis.in_git_dir.pull)
    end,
    push_all = function(paths)
      dothis.array.each(paths, dothis.in_git_dir.push)
    end,
    fetch_all = function(paths)
      dothis.array.each(paths, dothis.in_git_dir.fetch)
    end,

  },
}