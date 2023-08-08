
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
  url = {
    add_event_to_default_calendar = function(url)
      dothis.url.add_event_from_url(url, "default")
    end,
    add_event_to_chosen_calendar = function(url)
      dothis.array.choose_item(transf["nil"].writeable_calendar_name_array(), function(calendar)
        dothis.url.add_event_from_url(url, calendar)
      end)
    end,
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
      hs.fnutils.ieach(array, act.stream_created_item_specifier.set_state_transitioned_state)
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
    edit_local_csl_file = function(indicated_citable_object_id)
      dothis.local_path.open_app(
        transf.indicated_citable_object_id.local_csl_file_path(indicated_citable_object_id),
        env.GUI_EDITOR
      )
    end,
    open_local_citable_object_file = function(indicated_citable_object_id)
      dothis.local_path.open(
        transf.indicated_citable_object_id.local_citable_object_file_path(indicated_citable_object_id)
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
  extant_volume_local_extant_path = {
    eject_or_err = function(path)
      hs.fs.volume.eject(path)
      if is.local_absolute_path.extant_volume_local_extant_path(path) then
        error("Volume could not be ejected.", 0)
      end
    end,
    eject_or_msg = function(path)
      local succ, res = pcall(act.extant_volume_local_extant_path.eject_or_err, path)
      if succ then
        dothis.string.alert("Volume ejected successfully.")
      else
        dothis.string.alert(res)
      end
    end
  },
}