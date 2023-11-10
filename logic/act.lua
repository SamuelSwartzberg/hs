
--- `act.\<source>.\<action>` - do action on source
--- Only take one argument, which is the source.
--- For actions that take more than one argument, see op.lua, and `op.\<source>.\<action>`.
act = {
  relay_identifier = {
    set_active_mullvad_relay_dentifier = function(id)
      dothis.str.env_bash_eval("mullvad relay set hostname " .. id)
    end,
  },
  package_manager_name = {
    install_self = function(mgr)
      act.str.env_bash_eval_async("upkg " .. mgr .. " install-self")
    end,
    install_missing = function(mgr)
      act.str.env_bash_eval_async("upkg " .. mgr .. " install-missing")
    end,
    upgrade_all = function(mgr)
      act.str.env_bash_eval_async("upkg " .. mgr .. " upgrade-all")
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
  vdirsyncer_pair_specifier = {
    write_to_config = function(spec)
      dothis.absolute_path.append_file_if_file(
        dynamic_permanents.str_key_str_value_assoc_by_env.VDIRSYNCER_CONFIG .. "/config",
        "\n\n" .. transf.vdirsyncer_pair_specifier.ini_str(spec)
      )
      dothis.absolute_path.append_file_if_file(
        dynamic_permanents.str_key_str_value_assoc_by_env.KHAL_CONFIG .. "/config",
        "\n\n" .. transf.url.ini_str_by_khal_config_section(spec.remote_storage_url)
      )
      dothis.absolute_path.create_dir(
        transf.url.local_absolute_path_by_webcal_storage_location(spec.remote_storage_url)
      )
      local name = transf.url.calendar_name_by_for_webcal(spec.remote_storage_url)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped(
        "vdirsyncer discover" ..
        transf.str.str_by_single_quoted_escaped(name),
        get.fn.fn_by_1st_n_bound(
          act.str.env_bash_eval_async,
          "vdirsyncer sync" .. transf.str.str_by_single_quoted_escaped(name)
        )
      )
      dothis.in_git_dir.commit_self(
        dynamic_permanents.str_key_str_value_assoc_by_env.KHAL_CONFIG .. "/config",
        "Add web calendar " .. name
      )
    end,
  },
  url = {
    download_into_downloads_async = function(url)
      dothis.url.download_into_async(url, dynamic_permanents.str_key_str_value_assoc_by_env.DOWNLOADS)
    end,
    create_as_url_file_in_murls = function(url)
      act.url_arr.create_as_url_files_in_murls({url})
    end,
    subscribe_to_calendar = function(url)
      local pair_spec = transf.url.vdirsyncer_pair_specifier(url)
      act.vdirsyncer_pair_specifier.write_to_config(pair_spec)
    end,
    add_to_hydrus = function(url, do_after)
      dothis.url.add_to_hydrus(url, {"date:"..transf["nil"].full_rfc3339like_dt_by_current()}, do_after)
    end,
  },
  ics_file = {
    add_events_to_default_calendar = function(ics_file)
      dothis.ics_file.add_events_from_file(ics_file, "default")
    end,
    add_events_to_chosen_calendar = function(ics_file)
      dothis.arr.choose_item(transf["nil"].writeable_calendar_name_arr(), function(calendar)
        dothis.ics_file.add_events_from_file(ics_file, calendar)
      end)
    end,
    generate_json_file = function(path)
      return act.str.env_bash_eval_async(
        "ical2json" .. transf.str.str_by_single_quoted_escaped(path)
      )
    end,
  },
  hydrus_file_hash_arr = {
    add_tags_to_hydrus_item = function(arr, do_after)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped(
        "hydrus_add_tags" .. transf.str.here_doc(
          transf.str_arr.multiline_str(arr)
        ),
        do_after
      )
    end,
    write_stream_metadata_to_cache = function(arr)
      dothis.arr.each(
        arr,
        act.hydrus_file_hash.write_stream_metadata_to_cache
      )
    end,
    create_stream_foreground = function(arr)
      dothis.hydrus_file_hash_arr.create_stream(arr, "foreground")
    end,
    create_stream_background = function(arr)
      dothis.hydrus_file_hash_arr.create_stream(arr, "background")
    end,
  },
  hydrus_file_hash = {
    add_tags_to_hydrus_item_by_ai_tags = function(str, do_after)
      act.hydrus_file_hash_arr.add_tags_to_hydrus_item({str}, do_after)
    end,
    write_stream_metadata_to_cache = function(hash)
      local path = transf.n_leaflikes.local_absolute_path_by_namespaced_cache(
        "hydrus_metadata",
        transf.str.base64_url_str_by_string_as_binary(
          transf.hydrus_file_hash.local_hydrus_file_url(
            hash
          )
        )
      ) .. ".json"
      if is.absolute_path.extant_path(path) then
        return
      end
      dothis.absolute_path.write_file(
        path,
        transf.not_userdata_o_fn_even_nested_only_pos_int_or_str_key_table.json_str_or_err_by_pretty(
          transf.hydrus_file_hash.assoc_by_stream_metadata(
            hash
          )
        )
      )

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
  url_arr = {
    open_all_ff = function(url_arr)
      dothis.url_arr.open_all(url_arr, "Firefox")
    end,
    create_as_url_files_in_murls = function(url_arr)
      local path = transf.local_absolute_path.local_absolute_path_by_prompted_multiple_from_default(dynamic_permanents.str_key_str_value_assoc_by_env.MURLS)
      dothis.url_arr.create_as_url_files(url_arr, path)
    end,
    create_as_session_in_msessions = function(url_arr)
      dothis.url_arr.create_as_session(url_arr, dynamic_permanents.str_key_str_value_assoc_by_env.MSESSIONS)
    end,
    create_as_stream_foreground = function(url_arr)
      dothis.created_item_specifier_arr.create(
        stream_arr,
        get.url_arr.stream_creation_specifier(url_arr, "foreground")
      )
    end,
    create_as_stream_background = function(url_arr)
      dothis.created_item_specifier_arr.create(
        stream_arr,
        get.url_arr.stream_creation_specifier(url_arr, "background")
      )
    end,
  },
  plaintext_url_or_local_path_file = {
    open_all_ff = function(path)
      dothis.plaintext_url_or_local_path_file.open_all(path, "Firefox")
    end,
  },
  any = {
    choose_action = function(any)
      dothis.any.choose_action_specifier(
        any, 
        get.fn.fn_by_arbitrary_args_bound_or_ignored(dothis.action_specifier.execute, {consts.use_singleton, any})
      )
    end,
  },
  mpv_ipc_socket_id = {
    cycle_loop_playlist = function(id)
      dothis.mpv_ipc_socket_id.cycle_inf_no(id, "loop-playlist")
    end,
    cycle_loop_playback = function(id)
      dothis.mpv_ipc_socket_id.cycle_inf_no(id, "loop-file")
    end,
    cycle_pause = function(id)
      dothis.mpv_ipc_socket_id.cycle(id, "pause")
    end,
    cycle_shuffle = function(id)
      dothis.mpv_ipc_socket_id.cycle_inf_no(id, "shuffle")
    end,
    stop = function(id)
      dothis.mpv_ipc_socket_id.exec(id, "stop")
    end,
    set_playlist_first = function(id)
      dothis.mpv_ipc_socket_id.set(id, "playlist-pos", 0)
    end,
    set_playlist_last = function(id)
      dothis.mpv_ipc_socket_id.set(id, "playlist-pos", transf.mpv_ipc_socket_id.pos_int_by_playlist_length(id))
    end,
    set_playback_first = function(id)
      dothis.mpv_ipc_socket_id.set_playback_seconds(id, 0)
    end,
    chapter_backwards = function(id)
      dothis.mpv_ipc_socket_id.set_chapter(
        id,
        transf.ipc_socket_id.chapter_int(id) - 1
      )
    end,
    chapter_forwards = function(id)
      dothis.mpv_ipc_socket_id.set_chapter(
        id,
        transf.ipc_socket_id.chapter_int(id) + 1
      )
    end,
    playlist_backwards = function(id)
      dothis.mpv_ipc_socket_id.set_playlist_index(
        id,
        transf.ipc_socket_id.playlist_index_int(id) - 1
      )
    end,
    playlist_forwards = function(id)
      dothis.mpv_ipc_socket_id.set_playlist_index(
        id,
        transf.ipc_socket_id.playlist_index_int(id) + 1
      )
    end,
    restart = function(id)
      act.mpv_ipc_socket_id.set_playlist_first(id)
      act.mpv_ipc_socket_id.set_playback_first(id)
    end,
  },
  stream_created_item_specifier = {
    set_playback_seconds_plus_15 = get.fn.fn_by_arbitrary_args_bound_or_ignored(dothis.stream_created_item_specifier.set_playback_seconds_relative, {consts.use_singleton, 15}),
    set_playback_seconds_minus_15 = get.fn.fn_by_arbitrary_args_bound_or_ignored(dothis.stream_created_item_specifier.set_playback_seconds_relative, {consts.use_singleton, -15}),
    set_playback_seconds_plus_60 = get.fn.fn_by_arbitrary_args_bound_or_ignored(dothis.stream_created_item_specifier.set_playback_seconds_relative, {consts.use_singleton, 60}),
    set_playback_seconds_minus_60 = get.fn.fn_by_arbitrary_args_bound_or_ignored(dothis.stream_created_item_specifier.set_playback_seconds_relative, {consts.use_singleton, -60}),
    set_playback_percent_plus_5 = get.fn.fn_by_arbitrary_args_bound_or_ignored(dothis.stream_created_item_specifier.set_playback_percent, {consts.use_singleton, 5}),
    set_playback_percent_minus_5 = get.fn.fn_by_arbitrary_args_bound_or_ignored(dothis.stream_created_item_specifier.set_playback_percent, {consts.use_singleton, -5}),
    set_state_transitioned_state = function(spec)
      spec.inner_item.state = transf.stream_created_item_specifier.stream_state_by_transitioned(spec)
    end,
    cycle_loop_playlist = function(spec)
      return act.mpv_ipc_socket_id.cycle_loop_playlist(spec.inner_item.ipc_socket_id)
    end,
    cycle_loop_playback = function(spec)
      return act.mpv_ipc_socket_id.cycle_loop_playback(spec.inner_item.ipc_socket_id)
    end,
    set_playlist_first = function(spec)
      return act.mpv_ipc_socket_id.set_playlist_first(spec.inner_item.ipc_socket_id)
    end,
    set_playlist_last = function(spec)
      return act.mpv_ipc_socket_id.set_playlist_last(spec.inner_item.ipc_socket_id)
    end,
    set_playback_first = function(spec)
      return act.mpv_ipc_socket_id.set_playback_first(spec.inner_item.ipc_socket_id)
    end,
    set_chapter = function(spec, chapter)
      return dothis.mpv_ipc_socket_id.set_chapter(spec.inner_item.ipc_socket_id, chapter)
    end,
    chapter_backwards = function(spec)
      return act.mpv_ipc_socket_id.chapter_backwards(spec.inner_item.ipc_socket_id)
    end,
    chapter_forwards = function(spec)
      return act.mpv_ipc_socket_id.chapter_forwards(spec.inner_item.ipc_socket_id)
    end,
    restart = function(spec)
      return act.mpv_ipc_socket_id.restart(spec.inner_item.ipc_socket_id)
    end,
    cycle_pause = function(spec)
      return act.mpv_ipc_socket_id.cycle_pause(spec.creation_specifier.ipc_socket_id)
    end,
    stop = function(spec)
      return act.mpv_ipc_socket_id.stop(spec.creation_specifier.ipc_socket_id)
    end,
    playlist_backwards = function(spec)
      return act.mpv_ipc_socket_id.playlist_backwards(spec.creation_specifier.ipc_socket_id)
    end,
    playlist_forwards = function(spec)
      return act.mpv_ipc_socket_id.playlist_forwards(spec.creation_specifier.ipc_socket_id)
    end,
    cycle_shuffle = function(spec)
      return act.mpv_ipc_socket_id.cycle_shuffle(spec.creation_specifier.ipc_socket_id)
    end,
  },
  stream_created_item_specifier_arr = {
    set_state_transitioned_state_all = function(arr)
      dothis.arr.each(arr, act.stream_created_item_specifier.set_state_transitioned_state)
    end,
    filter_in_place_valid = function(arr)
      dothis.arr.filter_in_place(arr, transf.stream_created_item_specifier.bool_by_is_valid)
    end,
    maintain_state = function(arr)
      act.stream_created_item_specifier_arr.set_state_transitioned_state_all(arr)
      act.stream_created_item_specifier_arr.filter_in_place_valid(arr)
    end,

  },
  created_item_specifier_arr = {
    choose_item_and_action_on_creation_specifiers = function(arr)
      act.arr.choose_item_and_action(
        transf.created_item_specifier_arr.creation_specifier_arr(arr)
      )
    end,
  },
  local_image_file = {
    add_hs_image_to_clipboard = function(path)
      act.hs_image.add_to_clipboard(
        transf.local_image_file.hs_image(path)
      )
    end,
    paste_hs_image = function(path)
      act.hs_image.paste(
        transf.local_image_file.hs_image(path)
      )
    end,
    paste_hs_image_and_delete = function(path)
      act.hs_image.paste(
        transf.local_image_file.hs_image(path)
      )
      act.absolute_path.delete(path)
    end,
    add_as_otp_with_prompted_name = function(path)
      act.otp_url.add_otp_pass_item_with_prompted_name(
        transf.local_image_file.multiline_str_by_qr_data(path)
      )
    end,
  },
  local_hydrusable_file ={
    add_to_hydrus_by_path = function(path, do_after)
      rest({
        api_name = "hydrus",
        endpoint = "add_files/add_file",
        request_table = { path = path },
        request_verb = "POST",
      }, function(res)
        if res.status ~= 1 then
          error("Hydrus error, failed to add. Status: " .. res.status, 0)
        else
          if do_after then
            do_after(res.hash)
          end
        end
      end)
    end,
    add_to_hydrus_by_path_or_url_ai = function(path_or_url, do_after)
      dothis.local_hydrusable_file.add_to_hydrus_by_path_or_url(path_or_url, true, do_after)
    end,
    add_to_hydrus_by_path_or_url_noai = function(path_or_url, do_after)
      dothis.local_hydrusable_file.add_to_hydrus_by_path_or_url(path_or_url, false, do_after)
    end,
    
  },
  hydrus_noai_proc_dir = {
    add_all_to_hydrus = function(path)
      local files = transf.extant_path.file_arr_by_descendants(path)
      dothis.arr.each(
        files,
        dothis.local_hydrusable_file.add_to_hydrus_by_path_or_url
      )
    end
  },
  hydrus_ai_proc_dir = {
    add_all_to_hydrus = function(path)
      local files = transf.extant_path.file_arr_by_descendants(path)
      dothis.arr.each(
        files,
        function(file)
          dothis.local_hydrusable_file.add_to_hydrus_by_path_or_url(file, true)
        end
      )
    end
  },
  otp_url = {
    add_otp_pass_item_with_prompted_name = function(url)
      local name = get.str.alphanum_minus_underscore_str_by_prompted_once_from_default("", "Enter a name for the pass OTP item (alphanum minus underscore only):")
      dothis.otp_url.add_otp_pass_item(url, name)
    end,
  },
  local_path = {
    open_default = function(path, do_after)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped("open " .. transf.str.str_by_single_quoted_escaped(path), do_after)
    end,
    open_gui_editor = function(path, do_after)
      dothis.local_path.open_app(path, dynamic_permanents.str_key_str_value_assoc_by_env.GUI_EDITOR, do_after)
    end,
    open_and_reveal = function(path)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped("open -R " .. transf.str.str_by_single_quoted_escaped(path))
    end,
    open_libreoffice_async = function(path)
      dothis.local_path.open_app(path, "LibreOffice", true)
    end,
  },
  remote_nonextant_path = {
    create_dir = function(path)
      dothis.labelled_remote_absolute_path.create_dir(path)
    end,
  },
  nonextant_path = {
    create_dir = function(path)
      if is.path.remote_path(path) then
        dothis.remote_absolute_path.create_dir(path)
      else
        dothis.local_extant_path.create_dir(path)
      end
    end,
  },
  local_extant_path = {
    pull_all_descendants = function(path)
      act.in_git_dir_arr.pull_all(
        transf.extant_path.git_root_dir_arr_by_descendants(path)
      )
    end,
    make_executable = function(path)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("chmod +x " .. transf.str.str_by_single_quoted_escaped(path))
    end,
    delete = os.remove,

  },
  local_nonextant_path = {
    create_dir = function(path)
      act.str.env_bash_eval_sync("mkdir -p " .. transf.str.str_by_single_quoted_escaped(path))
    end,
  },
  local_file = {
    edit_file_in_vscode_act_on_path = function(path, do_after)
      dothis.str.env_bash_eval_w_str_or_str_and_8_bit_pos_int_arg_fn("codium --wait --disable-extensions " .. transf.str.str_by_single_quoted_escaped(path), function()
        if do_after then
          do_after(path)
        end
        act.absolute_path.delete(path)
      end)
    end,
    edit_file_in_vscode_act_on_contents = function(path, do_after)
      dothis.str.env_bash_eval_w_str_or_str_and_8_bit_pos_int_arg_fn("codium --wait --disable-extensions " .. transf.str.str_by_single_quoted_escaped(path), function()
        local contents = transf.file.str_by_contents(path)
        act.absolute_path.delete(path)
        do_after(contents)
      end)
    end,
  },
  labelled_remote_dir = {
    empty_dir = function(path)
      act.labelled_remote_dir.delete_dir(path)
      act.labelled_remote_nonextant_path.create_dir(path)
    end,
    delete_dir = function(path)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("rclone purge " .. transf.str.str_by_single_quoted_escaped(path))
    end,
  },
  labelled_remote_nonextant_path = {
    create_dir = function(path)
      act.str.env_bash_eval_sync("rclone mkdir " .. transf.str.str_by_single_quoted_escaped(path))
    end,
  },
  local_absolute_path = {
    start_recording_to = function(path, do_after)
      act.absolute_path.create_parent_dir(path)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped("rec " .. transf.str.str_by_single_quoted_escaped(path), function()
        if do_after then
          do_after(path)
        end
      end)
    end,
  },

  remote_dir =  {
    empty_dir = function(path)
      act.labelled_remote_dir.empty_dir(path)
    end,
    delete_dir = function(path)
      act.labelled_remote_dir.delete_dir(path)
    end,
  },
  local_dir = {
    git_init = function(path)
      dothis.local_extant_path.do_in_path(
        path,
        "git init",
        function()
          dothis.absolute_path.write_file_if_nonextant_path(
            transf.path.path_by_ending_with_slash(path) .. ".gitignore",
            ""
          )
          dothis.in_git_dir.commit_all_root(path, "Initial commit")
        end
      )
    end,
    empty_dir = function(path)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("rm -rf " .. transf.str.str_by_single_quoted_escaped(
        transf.path.path_by_ending_with_slash(path) .. "*"
      ) .. "/*")
    end,
    sync_local_to_labelled_remote = function(path)
      dothis.dir.sync_contents_to_absolute_path(
        path,
        transf.local_absolute_path.labelled_remote_absolute_path(path)
      )
    end,
    sync_labelled_remote_to_local = function(path)
      dothis.dir.sync_contents_to_absolute_path(
        transf.local_absolute_path.labelled_remote_absolute_path(path),
        path
      )
    end,
  },
  in_git_dir = {
    pull = function(path)
      dothis.local_extant_path.do_in_path(path, "git pull")
    end,
    push = function(path)
      dothis.local_extant_path.do_in_path(path, "git push")
    end,
    fetch = function(path)
      dothis.local_extant_path.do_in_path(path, "git fetch")
    end,
    add_self = function(path, do_after)
      dothis.local_extant_path.do_in_path(path, "git add" .. transf.str.str_by_single_quoted_escaped(path), do_after)
    end,
    -- will also add untracked files
    add_all = function(path, do_after)
      dothis.local_extant_path.do_in_path(path, "git add -A", do_after)
    end,
    add_all_root = function(path, do_after)
      act.in_git_dir.add_all(transf.in_git_dir.git_root_dir(path), do_after)
    end,
  },
  email_specifier = {
    send = function(specifier, do_after)
      act.maildir_file.send(transf.email_specifier.raw_email(specifier), do_after)
    end,
    edit_then_send = function(specifier, do_after)
      act.maildir_file.edit_then_send(transf.email_specifier.raw_email(specifier), do_after)
    end,
  },
  email = {
    edit_then_send = function(address, do_after)
      act.email_specifier.edit_then_send({to = address}, do_after)
    end,
  },
  audiodevice = {
    ensure_sound_will_be_played = function(device)
      device:setOutputMuted(false)
      device:setOutputVolume(100)
    end,
  },
  audiodevice_specifier = {
    set_default = function(specifier)
      dothis.audiodevice.set_default(
        transf.audiodevice_specifier.audiodevice(specifier),
        transf.audiodevice_specifier.audiodevice_subtype(specifier)
      )
    end,
  },
  audiodevice_specifier_arr = {
    choose_item_and_set_default = function(arr)
      dothis.arr.choose_item(
        arr,
        act.audiodevice_specifier.set_default
      )
    end,
  },
  in_menv_absolute_path = {
    write_env_and_check = function(in_menv_absolute_path)
      act.envlike_str.write_env_and_check(
        transf.in_menv_absolute_path.envlike_str(in_menv_absolute_path)
      )
    end,
  },
  indicated_citable_object_id = {
    edit_mcitations_csl_file = function(indicated_citable_object_id)
      dothis.local_path.open_app(
        transf.indicated_citable_object_id.mcitations_csl_file(indicated_citable_object_id),
        dynamic_permanents.str_key_str_value_assoc_by_env.GUI_EDITOR
      )
    end,
    open_mpapers_citable_object_file = function(indicated_citable_object_id)
      act.local_path.open_default(
        transf.indicated_citable_object_id.mpapers_citable_object_file(indicated_citable_object_id)
      )
    end,

  },
  login_pass_item_name = {
    fill = function(name)
      act.str_arr.fill_with({
        transf.auth_pass_item_name.line_by_username_or_default(name),
        transf.passw_pass_item_name.line_by_password(name),
      })
    end,
  },
  str_arr = {
    fill_with = function(arr)
      dothis.str_arr.join_and_paste(arr, "\t")
    end,
    choose_item_and_paste = function(arr)
      dothis.arr.choose_item(
        arr,
        act.str.paste
      )
    end,
  },
  assoc = {
    
  },
  window = {
    focus = function(window)
      window:focus()
    end,
    close = function(window)
      window:close()
    end,
    make_main = function(window)
      window:becomeMain()
    end,
  },
  omegat_project_dir = {
    create_and_open_new_source_odt = function(omegat_project_dir)
      dothis.omegat_project_dir.create_and_open_new_source_odt(
        omegat_project_dir,
        get.str.str_by_prompted_once_from_default(
          "",
          "Enter the name of the new source file (without extension):"
        )
      )
    end,
    pull_project_materials = function(omegat_project_dir)
      for _, type in transf.arr.pos_int_vt_stateless_iter(tblmap.project_type.str_arr_by_project_materials_list["omegat"]) do
        dothis.project_dir.pull_project_materials(
          omegat_project_dir,
          type,
          transf.omegat_project_dir.client_id_by_client(omegat_project_dir)
        )
      end
    end,
    push_project_materials = function(omegat_project_dir)
      dothis.project_dir.push_project_materials(
        omegat_project_dir,
        "glossary",
        transf.omegat_project_dir.client_id_by_client(omegat_project_dir)
      )
      dothis.extant_path.copy_into_absolute_path(
        transf.omegat_project_dir.local_absolute_path_by_resultant_tm(omegat_project_dir),
        get.project_dir.local_absolute_path_by_global_subtype_project_material(
          omegat_project_dir,
          "tm",
          transf.omegat_project_dir.client_id_by_client(omegat_project_dir)
        )
      )
    end,
    open_project = function(omegat_project_dir)
      local running_application = transf.mac_application_name.running_application_by_ensure("OmegaT")
      dothis.mac_application_name.open_recent("OmegaT", omegat_project_dir)
      dothis.running_application.focus_main_window(running_application)
    end,
    generate_target_txts = function(dir, do_after)
      dothis.arr.each(
        transf.omegat_project_dir.file_arr_by_target(dir),
        function(file)
          transf.str.str_or_nil_by_evaled_env_bash_stripped("soffice --headless --convert-to txt:Text --outdir"..
          transf.str.str_by_single_quoted_escaped(
            transf.omegat_project_dir.local_extant_path_by_target_txt_dir(dir)
          ) ..
          transf.str.str_by_single_quoted_escaped(file))
        end
      )
      error("TODO: Watch dir, count files every second or so until they are all there, then do_after. Perhaps refactor this into a general function")
    end,
    generate_rechnung_pdf = function(dir, do_after)
      dothis.md_file.to_file_in_same_dir(
        transf.client_project_dir.local_absolute_path_by_rechnung_md(dir),
        "pdf",
        transf.client_project_dir.local_absolute_path_by_rechnung_pdf(dir),
        do_after
      )
    end,
    generate_rechnung = function(path, do_after)
      act.omegat_project_dir.generate_target_txts(path, function()
        act.client_project_dir.generate_rechnung_de_md(path)
        act.omegat_project_dir.generate_rechnung_pdf(path, do_after)
      end)
    end,
    finalize_rechnung = function(path)

    end,
    finalize_project = function(path)
      act.omegat_project_dir.push_project_materials(path)
      act.omegat_project_dir.file_rechnung(path)
      act.omegat_project_dir.file_source_target(path)
    end,

  },
  jxa_tab_specifier = {
    make_main = function(jxa_tab_specifier)
      get.str.any_by_evaled_js_osa( ("Application('%s').windows()[%d].activeTabIndex = %d"):format(
        jxa_tab_specifier.application_name,
        jxa_tab_specifier.window_index,
        jxa_tab_specifier.tab_index
      ))
    end,
    close = function(jxa_tab_specifier)
      get.str.any_by_evaled_js_osa( ("Application('%s').windows()[%d].tabs()[%d].close()"):format(
        jxa_tab_specifier.application_name,
        jxa_tab_specifier.window_index,
        jxa_tab_specifier.tab_index
      ))
    end,
  },
  move_input_spec = {
    final_exec = function(spec)
      hs.mouse.absolutePosition(
        transf.declared_position_change_input_spec.hs_geometry_point_by_start(spec)
      )
    end,
    exec = function(spec, do_after)
      act.declared_position_change_input_spec.exec(
        get.input_spec.declared_input_spec(spec, "move"),
        do_after
      )
    end,
  },
  scroll_input_spec = {
    final_exec = function() end,
    exec = function(spec, do_after)
      act.declared_position_change_input_spec.exec(
        get.input_spec.declared_input_spec(spec, "scroll"),
        do_after
      )
    end,
  },
  declared_position_change_input_spec = {
    exec = function(spec, do_after)
      local position_change_state_spec = transf.declared_position_change_input_spec.position_change_state_spec_by_start(spec)
      local timer = hs.timer.doWhile(function() 
        if 
          not transf.position_change_state_spec.should_continue(position_change_state_spec)
        then
          act[
            spec.mode .. "_input_spec"
          ].final_exec(spec, do_after)
          if do_after then
            hs.timer.doAfter(0.2, do_after)
          end
          return false
        else
          position_change_state_spec = transf.position_change_state_spec.position_change_state_spec_by_next(position_change_state_spec)
          return true
        end
      end, function()
        dothis[
          spec.mode .. "_input_spec"
        ].exec_position_change_state_spec(spec, position_change_state_spec)
      end, consts.number_by_polling_interval)
      timer:start()
    end,
  },
  key_input_spec = {
    exec = function(spec, do_after)
      if spec.mods then
        local mods = get.arr.arr_by_mapped_w_t_key_assoc(spec.mods, normalize.mod)
        hs.eventtap.keyStroke(mods, spec.key)
      elseif #spec.key == 1 then
        hs.eventtap.keyStroke({}, spec.key)
      else
        hs.eventtap.keyStrokes(spec.key)
      end
      hs.timer.doAfter(0.2, do_after)
    end,
  },
  click_input_spec = {
    exec = function(spec, do_after)
      transf.click_input_spec.click_fn(spec)(hs.mouse.absolutePosition())
      hs.timer.doAfter(0.2, do_after)
    end,
  },
  input_spec = {
    exec = function(spec, do_after)
      act[
        spec.mode .. "_input_spec"
      ].exec(spec, do_after)
    end,
  },
  input_spec_arr = {
    exec = function(specarr, do_after)
      wait_time = transf.number_interval_specifier.number_by_random({start=0.10, stop=0.12})
      dothis.input_spec_arr.exec(specarr, wait_time, do_after)
    end
  },
  input_spec_str_arr = {
    exec = function(strarr, do_after)
      act.input_spec_arr.exec(
        transf.input_spec_str_arr.input_spec_arr(strarr),
        do_after
      )
    end
  },
  input_spec_series_str = {
    exec = function(str, do_after)
      act.input_spec_arr.exec(
        transf.input_spec_series_str.input_spec_arr(str),
        do_after 
      )
    end

  },
  intra_file_location_spec = {
    go_to = function(specifier)
      dothis.input_spec_arr.exec(
        transf.intra_file_location_spec.input_spec_arr(specifier)
      )
    end,
    open_go_to = function(specifier)
      dothis.local_path.open_app(
        transf.intra_file_location_spec.path(specifier),
        dynamic_permanents.str_key_str_value_assoc_by_env.GUI_EDITOR,
        get.fn.fn_by_1st_n_bound(act.intra_file_location_spec.go_to, specifier)
      )
    end
  },
  path_with_twod_locator = {
    open_go_to = function(path_with_twod_locator)
      act.intra_file_location_spec.open_go_to(
        transf.path_with_twod_locator.intra_file_location_spec(path_with_twod_locator)
      )
    end
  },
  absolute_path_key_str_or_str_arr_assoc = {
    write = function(dynamic_absolute_path_key_assoc)
      for absolute_path, contents in transf.table.kt_vt_stateless_iter(dynamic_absolute_path_key_assoc) do
        if is.any.arr(contents) then
          dothis.absolute_path[act.arr.shift(contents)](absolute_path, transf.arr.n_anys(contents))
        else
          act.absolute_path[contents](absolute_path)
        end
      end
    end,
  },
  plaintext_file = {
    append_line_and_commit_by_prompted = function(path)
      dothis.plaintext_file.append_line_and_commit(
        path,
        get.str.str_by_prompted_once_from_default(
          "",
          "Enter line to add to " .. path
        )
      )
    end,
    pop_line = function(path)
      local lines = transf.plaintext_file.line_arr(path)
      local line = dothis.arr.remove_by_index(lines, #lines)
      dothis.plaintext_file.write_lines(path, lines)
      return line
    end,
  },
  absolute_path_and_fnname = {
    url_by_serve = function(path, fnname)
      local cache = {}
      if not cache[path] then
        act.str.env_bash_eval_async(
          "luaserve-server" ..
          transf.str.str_by_single_quoted_escaped(path) ..
          transf.str.str_by_single_quoted_escaped(fnname) ..
          transf.str.str_by_single_quoted_escaped(
            consts.digit_str_by_lua_server_port
          )
        )
        cache[path] = true
      end
      return "https://127.0.0.1:" .. consts.digit_str_by_lua_server_port .. path
    end,
  },
  absolute_path = {
    write_template = function(path, template_path)
      dothis.absolute_path.write_file(
        path,
        get.str.str_by_evaled_as_template(
          get.str.any_by_evaled_as_lua(template_path),
          path
        )
      )
    end,
    create_dir = function(path)
      if is.absolute_path.nonextant_path(path) then
        act.nonextant_path.create_dir(path)
      end
    end,
    create_parent_dir = function(path)
      act.absolute_path.create_parent_dir(path)
    end,
    delete = function(path)
      if is.absolute_path.extant_path(path) then
        act.extant_path.delete(path)
      end
    end,
    empty = function(path)
      if is.absolute_path.extant_path(path) then
        act.extant_path.empty(path)
      end
    end,
    delete_dir = function(path)
      if is.path.extant_path(path) then
        act.extant_path.delete_dir(path)
      end
    end,
    empty_dir = function(path)
      if is.path.extant_path(path) then
        act.extant_path.empty_dir(path)
      end
    end,
    delete_file = function(path)
      if is.path.extant_path(path) then
        act.extant_path.delete_file(path)
      end
    end,
    empty_file = function(path)
      if is.path.extant_path(path) then
        act.extant_path.empty_file(path)
      end
    end,
    delete_if_empty_path = function(path)
      if is.path.extant_path(path) then
        act.extant_path.delete_if_empty_path(path)
      end
    end,
    delete_file_if_empty_file = function(path)
      if is.path.extant_path(path) then
        act.extant_path.delete_file_if_empty_file(path)
      end
    end,
    delete_dir_if_empty_dir = function(path)
      if is.path.extant_path(path) then
        act.extant_path.delete_dir_if_empty_dir(path)
      end
    end,
    initialize_omegat_project = function (path)
      dothis.local_path.write_dynamic_structure(path, "omegat")
      act.omegat_project_dir.pull_project_materials(path)
    end,
    empty_write_file = function(path)
      act.absolute_path.create_parent_dir(path)
      act.file.empty_write_file(path)
    end,
  },
  absolute_path_str_value_assoc = {
    write = function(absolute_path_str_value_assoc)
      for absolute_path, contents in transf.table.kt_vt_stateless_iter(absolute_path_str_value_assoc) do
        dothis.absolute_path.write_file(absolute_path, contents)
      end
    end,
  },
  running_application = {
    focus_main_window = function(running_application)
      transf.running_application.main_window(running_application):focus()
    end,
    activate = function(running_application)
      running_application:activate()
    end,
  },
  mac_application_name = {
    reload = function(application_name)
      dothis.mac_application_name.execute_full_action_path(
        application_name,
        tblmap.mac_application_name.str_arr_reload_full_action_path[application_name]
      )
    end,
    focus_main_window = function(application_name)
      dothis.running_application.focus_main_window(
        transf.mac_application_name.running_application_or_nil(application_name)
      )
    end,
    activate = function(application_name)
      dothis.running_application.activate(
        transf.mac_application_name.running_application_or_nil(application_name)
      )
    end,
  },
  iban = {
    fill_bank_form = function(iban)
      act.str_arr.fill_with(transf.iban.three_str__arr_by_iban_bic_bank_name(iban))
    end
  },
  menu_item_table = {
    execute = function(menu_item_table)
      dothis.running_application.execute_full_action_path(
        transf.menu_item_table.running_application(menu_item_table),
        transf.menu_item_table.str_arr_by_action_path(menu_item_table)
      )
    end,
  },
  envlike_str = {
    write_env_and_check = function(str)
      dothis.envlike_str.write_and_check(
        str,
        dynamic_permanents.str_key_str_value_assoc_by_env.ENVFILE
      )
    end,
  },
  volume_local_extant_path = {
    eject_or_err = function(path)
      hs.fs.volume.eject(path)
      if is.local_absolute_path.volume_local_extant_path(path) then
        error("Volume could not be ejected.", 0)
      end
    end,
    eject_or_msg = function(path)
      act.str.alert("Ejecting volume...")
      local succ, res = pcall(act.volume_local_extant_path.eject_or_err, path)
      if succ then
        act.str.alert("Volume ejected successfully.")
      else
        act.str.alert(res)
      end
    end
  },
  otpauth_url = {
    add_as_otp_by_prompted_name = function(url)
      local name = get.str.alphanum_minus_underscore_str_by_prompted_once_from_default("", "Enter a name for the pass OTP item (alphanum minus underscore only):")
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
  maildir_file = {
    choose_attachment_and_choose_action = function(path)
      act.maildir_file.choose_attachment_and_download(path, dothis.any.choose_action)
    end,
    choose_attachment_and_download = function(path, do_after)
      dothis.arr.choose_item(
        transf.maildir_file.leaflike_arr_by_attachments(path),
        function(att)
          dothis.maildir_file.download_attachment_to_cache(path, att, do_after)
        end
      )
    end,
    send = function(path, do_after)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped(
        "msmtp -t <" .. transf.str.str_by_single_quoted_escaped(path),
        function(res)
          if not res then
            dothis.absolute_path.write_file(
              dynamic_permanents.str_key_str_value_assoc_by_env.FAILED_EMAILS .. "/" .. transf["nil"].full_rfc3339like_dt_by_current(), 
              transf.file.str_by_contents(path)
            )
            act.absolute_path.delete(path)
          else
            dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped(
              "cat" ..
              transf.str.str_by_single_quoted_escaped(path) .. "| msed" ..
              transf.str.str_by_single_quoted_escaped(
                "/Date/a/"..
                transf.timestamp_s.urlcharset_str_by_email_dt(
                  transf["nil"].timestamp_s_by_current()
                )
              ) ..
              "| msed".. transf.str.str_by_single_quoted_escaped("/Status/a/S/") ..
              "| mdeliver -c" .. transf.str.str_by_single_quoted_escaped(dynamic_permanents.str_key_str_value_assoc_by_env.MBSYNC_ARCHIVE),
              function()
                act.absolute_path.delete(path)
                if do_after then
                  do_after()
                end
              end
            )
          end
        end
      )
    end,
    edit_then_send = function(path, do_after)
      dothis.local_file.edit_file_in_vscode_act_on_contents(path, function(str)
        dothis.absolute_path.write_file(path, get.str.str_by_evaled_as_template(str)) -- re-eval
        act.maildir_file.send(path, do_after)
      end)
    end,
    reply = function(path, specifier, do_after)
      specifier = transf.two_tables.table_by_take_new(transf.maildir_file.email_specifier_by_reply(path), specifier)
      act.email_specifier.send(specifier, do_after)
    end,
    edit_then_reply = function(path, do_after)
      act.email_specifier.edit_then_send(transf.maildir_file.email_specifier_by_reply(path), do_after)
    end,
    forward = function(path, specifier, do_after)
      specifier = transf.two_tables.table_by_take_new(transf.maildir_file.email_specifier_by_forward(path), specifier)
      act.email_specifier.send(specifier, do_after)
    end,
    edit_then_forward = function(path, do_after)
      act.email_specifier.edit_then_send(transf.maildir_file.email_specifier_by_forward(path), do_after)
    end,
  },
  alphanum_minus_underscore = {
    add_as_passw_pass_item_name_by_prompted_password = function(name)
      dothis.alphanum_minus_underscore.add_as_pass_item_name(
        name,
        get.str.str_by_prompted_once_from_default(
          transf.pos_int.base64_gen_str_by_random_of_length(32),
          "Enter a password, or confirm the generated 32-character base64 pregenerated one:"
        )
      )
    end,
    add_as_username_pass_item_name_by_prompted_username = function(name)
      dothis.alphanum_minus_underscore.add_as_username_pass_item_name(
        name,
        get.str.str_by_prompted_once_from_default(
          "",
          "Enter a username:"
        )
      )
    end,
  },
  
  str = {
    say_ja = function(str)
      dothis.str.say(str, "ja")
    end,
    say_en = function(str)
      dothis.str.say(str, "en")
    end,
    log_in_diary = function(str)
      dothis.entry_logging_dir.log_str(
        dynamic_permanents.str_key_str_value_assoc_by_env.MENTRY_LOGS,
        str
      )
    end,
    create_snippet = function(str)
      local path = get.local_extant_path.local_absolute_path_by_default_prompted_multiple(dynamic_permanents.str_key_str_value_assoc_by_env.MCOMPOSITE .. "/snippets")
      dothis.absolute_path.write_file_if_nonextant_path(path, str)
    end,
    push_qf_music = function(str)
      dothis.plaintext_file.append_line_and_commit(
        dynamic_permanents.str_key_str_value_assoc_by_env.MQF .. "/music",
        str
      )
    end,
    push_qf_things = function(str)
      dothis.plaintext_file.append_line_and_commit(
        dynamic_permanents.str_key_str_value_assoc_by_env.MQF .. "/things",
        str
      )
    end,
    add_to_clipboard = hs.pasteboard.setContents,
    add_to_pasteboard_arr = function(str)
      dothis.arr.move_to_front_or_unshift(
        dynamic_permanents.str_arr_by_pasteboard_arr,
        str
      )
    end,
    write_to_temp_file = function(str)
      local path = transf.str.in_tmp_local_absolute_path(os.time(), "temp_file")
      dothis.absolute_path.write_file(path, str)
      return path
    end,
    open_temp_file = function(str, do_after)
      dothis.local_path.open_app(
        act.str.write_to_temp_file(str),
        dynamic_permanents.str_key_str_value_assoc_by_env.GUI_EDITOR,
        do_after
      )
    end,
    edit_temp_file_in_vscode_act_on_path = function(str, do_after)
      local path = act.str.write_to_temp_file(str)
      act.local_file.edit_file_in_vscode_act_on_path(path, do_after)
    end,
    edit_temp_file_in_vscode_act_on_contents = function(str, do_after)
      local path = act.str.write_to_temp_file(str)
      act.local_file.edit_file_in_vscode_act_on_contents(path, do_after)
    end,
    create_url_arr_as_session_in_msessions = function(str)
      act.url_arr.create_as_session_in_msessions(
        transf.str.url_arr_by_one_per_line(str)
      )
    end,
    env_bash_eval_async = function(str)
      local task = hs.task.new(
        "/opt/homebrew/bin/bash",
        transf["nil"]["nil"],
        { "-c", transf.str.str_by_env_getter_comamnds_prepended(
          str
        )}
      )
      task:start()
      return task
    end,
    env_bash_eval_sync = function(str)
      hs.execute(
        transf.str.str_by_env_getter_comamnds_prepended(
          str
        )
      )
    end,
    alert = function(str)
      dothis.str.alert(str, 10)
    end,
    paste = function(str)
      local lines = get.str.str_arr_by_split_w_ascii_char(str, "\n")
      local is_first_line = true
      for _, line in transf.arr.pos_int_vt_stateless_iter(lines) do
        if is_first_line then
          is_first_line = false
        else
          hs.eventtap.keyStroke({}, "return")
        end
        hs.eventtap.keyStrokes(line)
      end
    end,
    paste_le = function(str)
      act.str.paste(get.str.str_by_evaled_as_template(str))
    end,
    fill_with_lines = function(str)
      act.str_arr.fill_with(transf.str.line_arr(str))
    end,
    fill_with_noempty_line_arr = function(path)
      act.str_arr.fill_with(transf.str.noempty_line_arr(path))
    end,
    fill_with_noempty_noindent_nohashcomment_line_arr = function(path)
      act.str_arr.fill_with(transf.str.noempty_noindent_nohashcomment_line_arr(path))
    end,
    search_wiktionary = function(query) dothis.search_engine_id.search("wiktionary", query) end,
    search_wikipedia = function(query) dothis.search_engine_id.search("wikipedia", query) end,
    search_youtube = function(query) dothis.search_engine_id.search("youtube", query) end,
    search_jisho = function(query) dothis.search_engine_id.search("jisho", query) end,
    search_glottopedia = function(query) dothis.search_engine_id.search("glottopedia", query) end,
    search_ruby_apidoc = function(query) dothis.search_engine_id.search("ruby_apidoc", query) end,
    search_python_docs = function(query) dothis.search_engine_id.search("python_docs", query) end,
    search_merriam_webster = function(query) dothis.search_engine_id.search("merriam_webster", query) end,
    search_assoc_cc = function(query) dothis.search_engine_id.search("assoc_cc", query) end,
    search_deepl_en_ja = function(query) dothis.search_engine_id.search("deepl_en_ja", query) end,
    search_deepl_de_en = function(query) dothis.search_engine_id.search("deepl_de_en", query) end,
    search_mdn = function(query) dothis.search_engine_id.search("mdn", query) end,
    search_scihub = function(query) dothis.search_engine_id.search("scihub", query) end,
    search_libgen = function(query) dothis.search_engine_id.search("libgen", query) end,
    search_semantic_scholar = function(query) dothis.search_engine_id.search("semantic_scholar", query) end,
    search_google_scholar = function(query) dothis.search_engine_id.search("google_scholar", query) end,
    search_google_images = function(query) dothis.search_engine_id.search("google_images", query) end,
    search_google_maps = function(query) dothis.search_engine_id.search("google_maps", query) end,
    search_danbooru = function(query) dothis.search_engine_id.search("danbooru", query) end,
    search_gelbooru = function(query) dothis.search_engine_id.search("gelbooru", query) end,
  },
  extant_path = {
    empty = function(path)
      if is.extant_path.dir(path) then
        act.dir.empty_dir(path)
      elseif is.extant_path.file(path) then
        dothis.file.empty_write_file(path)
      end
    end,
    delete = function(path)
      if is.extant_path.dir(path) then
        act.dir.delete_dir(path)
      elseif is.extant_path.file(path) then
        act.file.delete_file(path)
      end
    end,
    delete_if_empty_path = function(path)
      if is.extant_path.empty_path(path) then
        act.extant_path.delete(path)
      end
    end,
    empty_file = function(path)
      if is.extant_path.file(path) then
        act.file.empty_write_file(path)
      end
    end,
    delete_file = function(path)
      if is.extant_path.file(path) then
        act.file.delete_file(path)
      end
    end,
    delete_file_if_empty_file = function(path)
      if is.extant_path.file(path) then
        act.file.delete_file_if_empty_file(path)
      end
    end,
    delete_dir = function(path)
      if is.extant_path.dir(path) then
        act.dir.delete_dir(path)
      end
    end,
    delete_dir_if_empty_dir = function(path)
      if is.extant_path.dir(path) then
        act.dir.delete_dir_if_empty_dir(path)
      end
    end,
    empty_dir = function(path)
      if is.extant_path.dir(path) then
        act.dir.empty_dir(path)
      end
    end,
    move_to_parent_path = function(path)
      dothis.extant_path.move_to_absolute_path(path, transf.path.trimmed_noweirdwhitespace_line_by_parent_path(path))
    end,
    move_to_downloads = function(path)
      dothis.extant_path.move_to_absolute_path(path, dynamic_permanents.str_key_str_value_assoc_by_env.DOWNLOADS)
    end,
    move_to_parent_path_with_extension_if_any = function(path)
      dothis.extant_path.move_to_absolute_path(path, transf.path.path_by_parent_path_with_extension_if_any(path))
    end,
    create_stream_foreground = function(path)
      dothis.created_item_specifier_arr.create(
        stream_arr,
        get.extant_path.stream_creation_specifier_by_descendant_m3u_file_content_lines(path, "foreground")
      )
    end,
    create_stream_background = function(path)
      dothis.created_item_specifier_arr.create(
        stream_arr,
        get.extant_path.stream_creation_specifier_by_descendant_m3u_file_content_lines(path, "background")
      )
    end,
    choose_item_and_action_by_descendants = function(path)
      act.arr.choose_item_and_action(
        transf.extant_path.absolute_path_arr_by_descendants(path)
      )
    end,
    choose_item_and_action_by_descendants_depth_3 = function(path)
      act.arr.choose_item_and_action(
        transf.extant_path.absolute_path_arr_by_descendants_depth_3(path)
      )
    end,
  },
  audio_file = {
    play = function(path, do_after)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped("play " .. transf.str.str_by_single_quoted_escaped(path), do_after)
    end
  },
  hs_image = {
    add_to_clipboard = function(hsimage)
      hs.pasteboard.writeObjects(hsimage)
    end,
    paste = function(hsimage)
      hs.pasteboard.writeObjects(hsimage)
      hs.eventtap.keyStroke({"cmd"}, "v")
    end,
  },
  api_name = {
    delete_api_key = function(api_name)
      act.absolute_path.delete(
        transf.api_name.local_absolute_path_by_api_key_file(api_name)
      )
    end,
    delete_access_token = function(api_name)
      act.absolute_path.delete(
        transf.api_name.local_absolute_path_by_access_token_file(api_name)
      )
    end,
    delete_refresh_token = function(api_name)
      act.absolute_path.delete(
        transf.api_name.local_absolute_path_by_refresh_token_file(api_name)
      )
    end,
    delete_client_id = function(api_name)
      act.absolute_path.delete(
        transf.api_name.local_absolute_path_by_client_id_file(api_name)
      )
    end,
    delete_client_secret = function(api_name)
      act.absolute_path.delete(
        transf.api_name.local_absolute_path_by_client_secret_file(api_name)
      )
    end,
    delete_authorization_code = function(api_name)
      act.absolute_path.delete(
        transf.api_name.local_absolute_path_by_authorization_code_file(api_name)
      )
    end,
  },
  dir = {
    choose_item_and_action_by_children = function(path)
      act.arr.choose_item_and_action(
        transf.dir.absolute_path_arr_by_children(path)
      )
    end,
    choose_leaf_until_file_then_action = function(path)
      dothis.dir.choose_leaf_or_dotdot_until_file_w_file_arg_fn(
        path,
        dothis.any.choose_action
      )
    end,
    empty_dir = function(path)
      act[
        transf.path.local_o_remote_str(path) .. "_extant_path"
      ].empty_dir(path)
    end,
    delete_dir = function(path)
      act[
        transf.path.local_o_remote_str(path) .. "_extant_path"
      ].delete_dir(path)
    end,
    delete_dir_if_empty_dir = function(path)
      if is.dir.empty_dir(path) then
        act.dir.delete_dir(path)
      end
    end,
  },
  file = {
    empty_write_file = function(path)
      dothis.file.write_file(path, "")
    end,
    delete_file = function(path)
      act[
        transf.path.local_o_remote_str(path) .. "_extant_path"
      ].delete_file(path)
    end,
    delete_file_if_empty_file = function(path)
      if is.file.empty_file(path) then
        act.file.delete_file(path)
      end
    end,
  },
  sme_3_pos_int_and_table = {
    manage_timemachine_backup = function(event, information)
      if event == hs.fs.volume.didMount then
        if is.volume_local_extant_path.static_time_machine_volume_local_extant_path(information.path) then
          hs.alert.show("Starting backup...")
          act.str.env_bash_eval_async("tmutil startbackup")
        end
      elseif event == hs.fs.volume.didUnmount then
        if is.volume_local_extant_path.dynamic_time_machine_volume_local_extant_path(information.path) then
          hs.timer.doAfter(30, 
            get.fn.fn_by_1st_n_bound(act.volume_local_extant_path.eject_or_msg, dynamic_permanents.str_key_str_value_assoc_by_env.TMBACKUPVOL)
          )
        end
      end
    end
  },
  mac_application_name_and_sme_6_pos_int = {
    start_ff_backup_on_ff_quit = function(mac_application_name, hs_applicaton_event_type)
      if mac_application_name == "Firefox" and hs_applicaton_event_type == hs.application.watcher.terminated then
        hs.timer.doAfter(3, act["nil"].ff_backup)
      end
    end
  },
  volume_local_extant_path_arr = {
    choose_item_and_eject_or_msg = function(arr)
      dothis.arr.choose_item(
        arr,
        act.volume_local_extant_path.eject_or_msg
      )
    end,
  },
  stream_creation_specifier = {
    create_inner_item = function(spec)
      local ipc_socket_id = os.time() .. "-" .. math.random(1000000)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("mpv " .. transf.stream_creation_specifier.str_by_flags(spec) .. 
        " --msg-level=all=warn --input-ipc-server=" .. transf.ipc_socket_id.ipc_socket_path(ipc_socket_id) .. " --start=" .. spec.values.start .. " " .. transf.str_arr.str_by_single_quoted_escaped_joined(spec.urls))
      return {
        ipc_socket_id = ipc_socket_id,
        state = "booting"
      }
    end,
  },
  hotkey_creation_specifier = {
    create_inner_item = function(spec)
      local hotkey = hs.hotkey.new(
        spec.modifiers,
        spec.key, 
        spec.fn
      )
      hotkey:enable()
      return hotkey
    end,
  },
  plist_single_dkv_spec = {
    write_default = function(spec, do_after)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped_noempty(
        transf.plist_single_dkv_spec.line_by_write_default_command(spec),
        do_after
      )
    end,
  },
  watcher_creation_specifier = {
    create_inner_item = function(spec)
      local watcher = transf.watcher_creation_specifier.watcher_ret_fn(spec)(spec.fn)
      watcher:start()
      return watcher
    end,
  },
  task_creation_specifier = {
    create_inner_item = function(spec)
      return transf.str.str_or_nil_by_evaled_env_bash_stripped(
        spec.opts
      )
    end,
  },
  creation_specifier = {
    create = function(spec)
      return {
        inner_item = dothis[
          transf.creation_specifier.creation_specifier_type(spec) .. "_creation_specifier"
        ].create_inner_item(spec),
        creation_specifier = spec,
      }
    end,
  },
  local_svg_file = {
    to_png_in_cache = function(path)
      dothis.local_svg_file.to_png(
        path,
        transf.local_svg_file.local_absolute_path_by_png_in_cache(path)      )
    end,
  },
  created_item_specifier = {
    recreate = function(spec)
      return act.creation_specifier.create(spec.creation_specifier)
    end,
  },
  fireable_created_item_specifier = {
    fire = function(spec)
      spec.creation_specifier.fn()
    end,
  },
  task_created_item_specifier = {
    pause = function(spec)
      spec.inner_item:pause()
    end,
    resume = function(spec)
      spec.inner_item:resume()
    end,
  },
  hotkey_created_item_specifier = {
    pause = function(spec)
      spec.inner_item:disable()
    end,
    resume = function(spec)
      spec.inner_item:enable()
    end,
  },
  watcher_created_item_specifier = {
    pause = function(spec)
      spec.inner_item:stop()
    end,
    resume = function(spec)
      spec.inner_item:start()
    end,
  },
  timer_spec = {
    set_next_timestamp_s = function(spec)
      spec.next_timestamp_s = transf.cronspec_str.timestamp_s_by_next(spec.cronspec_str)
    end,
    fire = function(spec)
      spec.fn()
      act.timer_spec.set_next_timestamp_s(spec)
      spec.largest_interval = transf.two_operational_comparables.bool_by_larger(spec.largest_interval, transf.timer_spec.int_by_interval_left(spec))
    end,
  },
  timer_spec_arr = {
    fire_all_if_ready_and_space_if_necessary = function(arr)
      local fired = false
      for _, v in transf.arr.pos_int_vt_stateless_iter(arr) do
        if 
          transf.timer_spec.bool_by_ready(v) 
        then
          if 
            not fired or
            not transf.timer_spec.bool_by_long_timer(v)
          then
            act.timer_spec.fire(v)
            fired = true
          else
            dothis.timer_spec.postpone_next_timestamp_s(v, 1)
          end
        end
      end
    end,
  },
  two_strs = {
    set_key_redis_raw = function(key, str)
      dynamic_permanents.table_by_redis_client:set(key, str)
    end,
  },
  arr_and_any = {
    set_key_redis = function(arr, val)
      act.two_strs.set_key_redis_raw(
        transf.arr.str_or_err_by_redis_key(arr),
        transf.any.str_or_nil_by_marshalled(val)
      )
    end,
  },
  not_userdata_o_fn_even_nested_arr_and_not_userdata_o_fn_even_nested = {
    set_key_redis = function(arr, val)
      act.two_strs.set_key_redis_raw(
        transf.not_userdata_o_fn_even_nested_arr.str_by_redis_key(arr),
        transf.not_userdata_o_fn_even_nested.str_by_marshalled(val)
      )
    end,
  },
  ["nil"] = {
    fill_dynamic_permanent_env = function()
      dynamic_permanents.dynamic_permanents.str_key_str_value_assoc_by_env = transf.str.table_or_err_by_evaled_env_bash_parsed_json("env | jc --ini")
    end,
    start_redis = function()
      dothis.created_item_specifier_arr.create_or_recreate(
        dynamic_permanents.task_created_item_specifier_arr,
        consts.task_creation_specifier_by_redis_server
      )
      hs.timer.doWhile(
        function()
          return dynamic_permanents.table_by_redis_client == nil
        end, function()
          local succ, client = pcall(redis.connect, '127.0.0.1', 6379)
          if succ then
            dynamic_permanents.table_by_redis_client = client
          end
        end
      )
    end,
    create_fn_key_fnname_value_assoc = function()
      for _, fncontainer in transf.arr.pos_int_vt_stateless_iter({"transf", "get", "act", "dothis"}) do
        for from, fntable in transf.table.kt_vt_stateless_iter(_G[fncontainer]) do
          for to, fn in transf.table.kt_vt_stateless_iter(fntable) do
            dynamic_permanents.fn_key_fnname_value_assoc[fn] = fncontainer .. "." .. from .. "." .. to
          end
        end
      end
    end,
    fill_dynamic_permanent_fstblmap = function()
      dynamic_permanents.str_key_assoc_by_fstblmap = transf.dir.plaintext_dictonary_read_assoc(dynamic_permanents.str_key_str_value_assoc_by_env.MDICTIONARIES .. "/mappings")
    end,
    fill_dynamic_permanent_mcomposite = function()
      dynamic_permanents.str_key_assoc_by_mcomposite = transf.dir.plaintext_dictonary_read_assoc(dynamic_permanents.str_key_str_value_assoc_by_env.MCOMPOSITE)
    end,
    fill_initial_dynamic_permanents = function()
      dothis["nil"].fill_dynamic_permanent_env()
      dothis["nil"].start_redis()
      dothis["nil"].create_fn_key_fnname_value_assoc()
      dothis["nil"].fill_dynamic_permanent_fstblmap()
      dothis["nil"].fill_dynamic_permanent_mcomposite()
    end,
    create_fn_queue_specifier = function ()
      dynamic_permanents.fn_queue_specifier = {
        fn_arr = {},
        hotkey_created_item_specifier = dothis.created_item_specifier_arr.create_or_recreate(consts.hotkey_creation_specifier_by_pop_fn_queue)
      }
    end,
    create_hotkeys = function()
      dothis.created_item_specifier_arr.create_or_recreate(
        dynamic_permanents.hotkey_created_item_specifier_arr,
        consts.hotkey_creation_specifier_by_reload
      )
      dothis.created_item_specifier_arr.create_all(
        dynamic_permanents.hotkey_created_item_specifier_arr,
        consts.keymap_spec_by_cmd_shift_alt
      )
      dothis.created_item_specifier_arr.create_all(
        dynamic_permanents.hotkey_created_item_specifier_arr,
        consts.keymap_spec_by_cmd_alt
      )
    end,
    create_watchers = function()
      dothis.created_item_specifier_arr.create_all(
        dynamic_permanents.watcher_created_item_specifier_arr,
        ls.watcher_creation_specifier_arr
      )
    end,
    start_oauth2callback_server = function()
      dothis.created_item_specifier_arr.create_or_recreate(
        dynamic_permanents.task_created_item_specifier_arr,
        consts.task_creation_specifier_by_oauth2callback_server
      )
    end,
    url_by_launch_decoding_fetching_server = function()
      return act.absolute_path_and_fnname.url_by_serve(
        "/decode_and_fetch",
        "transf.str.str_or_nil_by_percent_decoded_as_url_response"
      )
    end,
    ensure_sound_played_on_speakers = function()
      local device = hs.audiodevice.findOutputByName("Built-in Output")
      act.audiodevice.ensure_sound_will_be_played(device)
      dothis.audiodevice.set_default(device, "output")
    end,
    choose_menu_item_table_and_execute_by_frontmost_application = function()
      act.menu_item_table_arr.choose_item_and_execute(
        transf["nil"].menu_item_table_arr_by_frontmost_application()
      )
    end,
    choose_item_and_action_on_contact_table_arr = function()
      act.arr.choose_item_and_action(
        transf["nil"].contact_table_arr()
      )
    end,
    choose_item_and_eject_or_msg_by_all_volumes = function()
      act.volume_local_extant_path_arr.choose_item_and_eject_or_msg(
        transf["nil"].volume_local_extant_path_arr()
      )
    end,
    choose_item_and_action_on_screenshot_children = function()
      act.dir.choose_item_and_action_by_children(dynamic_permanents.str_key_str_value_assoc_by_env.SCREENSHOTS)
    end,
    choose_item_and_action_on_hotkey_creation_specifier_arr = function()
      act.created_item_specifier_arr.choose_item_and_action_on_creation_specifiers(
        dynamic_permanents.hotkey_creation_specifier_arr
      )
    end,
    choose_item_and_paste_on_pasteboard_arr  = function()
      act.str_arr.choose_item_and_paste(
        dynamic_permanents.str_arr_by_pasteboard_arr
      )
    end,
    choose_item_and_action_on_pasteboard_arr = function()
      act.str_arr.choose_item_and_action(
        dynamic_permanents.str_arr_by_pasteboard_arr
      )
    end,
    show_2_by_4_grid = function()
      act.hs_geometry_size_like.show_grid({w=2, h=4})
    end,
    choose_default_search_and_create_background_stream = function()
      dothis.arr.choose_item(
        transf.json_file.not_userdata_o_fn_even_nested_only_pos_int_or_str_key_table(dynamic_permanents.str_key_str_value_assoc_by_env.MSPEC .. "/lists/video_searches.json"),
        function(arr)
          local hashes = transf.arr.hydrus_file_hash_arr_by_search_motion_only(arr)
          act.hydrus_file_hash_arr.create_stream_background(hashes)
        end
      )
    end,
    choose_item_and_action_on_mcitation_csl_table = function()
      act.arr.choose_item_and_action(
        transf.path_arr.csl_table_arr_by_filtered_mapped(
          transf.extant_path.file_arr_by_descendants(
            dynamic_permanents.str_key_str_value_assoc_by_env.MCITATIONS
          )
        )
      )
    end,
    pop_main_qspec = function()
      act.fn_queue_specifier.pop(
        dynamic_permanents.fn_queue_specifier
      )
    end,
    choose_item_and_set_active_relay_identifier = function()
      act.relay_identifier_arr.choose_item_and_set_active(
        transf["nil"].relay_identifier_arr()
      )
    end,
    choose_inbox_email_and_action = function()
      act.arr.choose_item_and_action(
        get.maildir_dir.maildir_file_arr_by_sorted_filtered(dynamic_permanents.str_key_str_value_assoc_by_env.MBSYNC_INBOX, true)
      )
    end,
    choose_input_audiodevice_specifier_and_set_default = function()
      act.audiodevice_specifier_arr.choose_item_and_set_default(
        transf.audiodevice_type.audiodevice_specifier_arr("input")
      )
    end,
    choose_output_audiodevice_specifier_and_set_default = function()
      act.audiodevice_specifier_arr.choose_item_and_set_default(
        transf.audiodevice_type.audiodevice_specifier_arr("output")
      )
    end,
    choose_item_and_action_by_env_var = function()
      dothis.table.choose_w_vt_fn(
        dynamic_permanents.str_key_str_value_assoc_by_env
      )
    end,
    sox_rec_toggle_and_act = function()
      dothis.sox.sox_rec_toggle_cache(dothis.any.choose_action)
    end,
    choose_action_on_current_timestamp_s = function()
      act.any.choose_action(transf["nil"].timestamp_s_by_current())
    end,
    choose_login_pass_item_name_and_fill = function()
      dothis.arr.choose_item(
        transf["nil"].passw_pass_item_name_arr(),
        act.login_pass_item_name.fill
      )
    end,
    choose_otp_pass_item_name_and_paste = function()
      dothis.arr.choose_item(
        transf["nil"].otp_pass_item_name_arr(),
        act.str.paste
      )
    end,
    activate_next_source_id = function()
      act.source_id_arr.activate_next(dynamic_permanents.source_id_arr)
    end,
    maintain_state_stream_arr = function()
      act.stream_created_item_specifier_arr.maintain_state(dynamic_permanents.stream_created_item_specifier_arr)
    end,
    choose_action_on_first_running_stream = function()
      local strm = transf.stream_created_item_specifier_arr.stream_created_item_specifier_by_first_running(dynamic_permanents.stream_created_item_specifier_arr)
      if strm then
        act.any.choose_action(strm)
      else
        act.str.alert("No running streams.")
      end
    end,
    choose_stream_and_then_action = function()
      act.arr.choose_item_and_action(
        dynamic_permanents.stream_created_item_specifier_arr
      )
    end,
    choose_action_on_first_item_in_pasteboard_arr = function()
      act.any.choose_action(
        dynamic_permanents.str_arr_by_pasteboard_arr[1]
      )
    end,
    vdirsyncer_sync = function()
      act.str.env_bash_eval_async("vdirsyncer sync")
    end,
    pull_from_labelled_remote = function()
      local paths_to_pull = transf.extant_path.absolute_path_arr_by_descendants_depth_2_leaf_matching_device_identifier("crhsftp:pull")
      dothis.arr.each(
        paths_to_pull,
        function(path)
          dothis.extant_path.move_descendants_into_absolute_path_preserving_structure(
            path,
            dynamic_permanents.str_key_str_value_assoc_by_env.HOMEPROCPULL .. "/" .. transf.path.path_component_or_nil_by_parent_leaf(path)
          )
        end
      )
    end,
    newsboat_reload = function()
      act.str.env_bash_eval_async("newsboat -x reload")
    end,
    mullvad_connect = function()
      act.str.env_bash_eval_async("mullvad connect")
    end,
    mullvad_disconnect = function()
      act.str.env_bash_eval_async("mullvad disconnect")
    end,
    mullvad_toggle = function()
      if transf["nil"].bool_by_mullvad_connected() then
        act["nil"].mullvad_disconnect()
      else
        act["nil"].mullvad_connect()
      end
    end,
    mbsync_sync  = function()
      dothis.str.env_bash_eval('mbsync -c "$XDG_CONFIG_HOME/isync/mbsyncrc" mb-channel')
    end,
    choose_action_on_user_entered_str = function()
      local res = get.str.str_by_prompted_once_from_default("", "str to act on")
      if res then 
        act.any.choose_action(res)
      end
    end,
    choose_item_and_action_on_local_extant_path_in_downloads = function()
      act.extant_path.choose_item_and_action_by_children(dynamic_permanents.str_key_str_value_assoc_by_env.DOWNLOADS)
    end,
    choose_action_on_running_application_by_frontmost = function()
      act.any.choose_action(
        transf["nil"].running_application_by_frontmost()
      )
    end,
    purge_memstore = function()
      dynamic_permanents.fn_key_int_key_table_value_assoc_value_assoc_by_memstore = {}
    end,
    purge_fsmemoize_cache = function()
      dothis.absolute_path.delete(
        dothis.absolute_path.empty_dir(dynamic_permanents.str_key_str_value_assoc_by_env.XDG_CACHE_HOME .. "/hs/fsmemoize")
      )
    end,
    omegat_create_all_translated_documents = function()
      dothis.mac_application_name.execute_full_action_path(
        "OmegaT",
        {
          "Project",
          "Create Translated Documents"
        }
      )
    end,
    omegat_create_current_translated_document = function()
      dothis.mac_application_name.execute_full_action_path(
        "OmegaT",
        {
          "Project",
          "Create Current Translated Document"
        }
      )
    end,
    -- expects to be called on a watcher for tachiyomi state
    tachiyomi_backup = function()
      local backup_origin_path = get.dir.extant_path_arr_by_grandchildren_with_device_identifier_slash_current_device_identifier(
        dynamic_permanents.str_key_str_value_assoc_by_env.HOMEPROCPULL,
        "::Android::"
      )[1] .. "/backup/tachiyomi"
      dothis.local_zip_file.unzip_to_absolute_path(
        backup_origin_path,
        transf.n_leaflikes.local_absolute_path_by_namespaced_cache("export", "tachiyomi")
      )
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped("jsonify-tachiyomi-backup", function()
        local tmst_assoc = transf.tachiyomi_json_table.timestamp_ms_key_assoc_value_assoc(transf.json_file.not_userdata_o_fn_even_nested_only_pos_int_or_str_key_table(dynamic_permanents.str_key_str_value_assoc_by_env.TMP_TACHIYOMI_JSON))
        tmst_assoc = get.timestamp_ms_key_assoc_value_assoc.timestamp_ms_key_assoc_value_assoc_by_filtered_timestamp(tmst_assoc, "tachiyomi")
        dothis.logging_dir.log_timestamp_ms_key_assoc_value_assoc(
          dynamic_permanents.str_key_str_value_assoc_by_env.MMANGA_LOGS,
          tmst_assoc
        )
        act.backuped_thing_identifier.write_current_timestamp_ms("tachiyomi")
      end)
    end,
    --- do once ff is quit
    ff_backup = function()
      local timestamp = transf.backuped_thing_identifier.timestamp_ms("firefox")
      if transf.mac_application_name.bool_by_running_application("Firefox") then
        return -- don't try to backup while firefox is running
      end
      dothis.sqlite_file.query_w_table_arg_fn(
        dynamic_permanents.str_key_str_value_assoc_by_env.MAC_FIREFOX_PLACES_SQULITE,
        "SELECT json_group_object(visit_date/1000, json_object('title', title, 'url', url))" .. 
        "FROM moz_places " ..
        "INNER JOIN moz_historyvisits ON moz_places.id = moz_historyvisits.place_id " ..
        "WHERE visit_date > " .. timestamp * 1000 .. " " ..
        "ORDER BY timestamp DESC;",
        function(tbl)
          dothis.logging_dir.log_timestamp_ms_key_assoc_value_assoc(
            dynamic_permanents.str_key_str_value_assoc_by_env.MBROWSER_LOGS,
            tbl
          )
          act.backuped_thing_identifier.write_current_timestamp_ms("firefox")
        end
      )
    end,
    newpipe_backup = function()
      act["nil"].newpipe_extract_backup()
      local timestamp = transf.backuped_thing_identifier.timestamp_ms("newpipe")
      dothis.sqlite_file.query_w_table_arg_fn(
        transf.n_leaflikes.local_absolute_path_by_namespaced_cache("export", "newpipe") .. "/history.db",
        "SELECT json_group_object(access_date, json_object('title', title, 'url', url, 'timestamp_ms', access_date ))" .. 
        "FROM stream_history " ..
        "INNER JOIN streams ON stream_history.stream_id = streams.uid " ..
        "WHERE access_date > " .. timestamp  .. " " ..
        "ORDER BY timestamp DESC;",
        function(tbl)
          dothis.logging_dir.log_timestamp_ms_key_assoc_value_assoc(
            dynamic_permanents.str_key_str_value_assoc_by_env.MMEDIA_LOGS,
            tbl
          )
          act.backuped_thing_identifier.write_current_timestamp_ms("newpipe")
          act.local_dir.empty_dir(transf.n_leaflikes.local_absolute_path_by_namespaced_cache("export", "newpipe"))
        end
      )
    end,
    facebook_preprocess_backup = function()
      local dlchildren = transf.dir.absolute_path_arr_by_children(dynamic_permanents.str_key_str_value_assoc_by_env.DOWNLOADS)
      local fbfiles = get.path_arr.path_arr_by_filter_to_filename_starting(dlchildren, "facebook-samswartzberg")
      local fbzips = get.path_arr.path_arr_by_filter_to_same_extension(fbfiles, "zip")
      local newest_fbzip = transf.local_extant_path_arr.local_extant_path_by_newest_creation(fbzips)
      local tmploc = transf.str.in_tmp_local_absolute_path("facebook", "export")
      dothis.local_zip_file.unzip_to_absolute_path(newest_fbzip, tmploc)
      act.file.delete_file(newest_fbzip)
      act.facebook_raw_export_dir.process_to_facebook_export_dir(tmploc)
    end,
    telegram_backup = function()
      act["nil"].telegram_generate_backup(nil, function()
        act.telegram_raw_export_dir.process_to_telegram_export_dir(
          transf["nil"].telegram_raw_export_dir_by_current()
        )
        act.backup_type.log("telegram")
      end)
    end,
    signal_backup = function()
      act["nil"].signal_generate_backup(nil, function()
        act.backup_type.log("signal")
      end)
    end,
    discord_backup = function()
      act["nil"].discord_generate_backup(nil, function()
        act.backup_type.log("discord")
      end)
    end,
    sox_rec_start_cache = function(_, do_after)
      act.local_absolute_path.start_recording_to(transf.n_leaflikes.local_absolute_path_by_namespaced_cache("recording", os.time()), do_after)
    end,
    sox_rec_stop = function(_, do_after)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped("killall rec", do_after)
    end,
    sox_rec_toggle_cache = function(_, do_after)
      if transf["nil"].bool_by_sox_is_recording() then
        act["nil"].sox_rec_stop()
      else
        act["nil"].sox_rec_start_cache(_, do_after)
      end
    end,
    firefox_dump_state = function(_, do_after)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped('lz4jsoncat "$MAC_FIREFOX_PLACES_SESSIONSTORE_RECOVERY" > "$TMP_FIREFOX_STATE_JSON', do_after)
    end,
    newpipe_extract_backup = function()
      local newpipe_dir = dynamic_permanents.str_key_str_value_assoc_by_env.HOMEPROCPULL .. "/handset:Linux:Android:arm64:TODO NAME/backup/newpipe"
      dothis.local_zip_file.unzip_to_absolute_path(
        transf.dir.extant_path_by_newest_child(newpipe_dir),
        transf.n_leaflikes.local_absolute_path_by_namespaced_cache("export", "newpipe")
      )
      act.local_dir.empty_dir(newpipe_dir)
    end,
   
    telegram_generate_backup = function(_, do_after)
      dothis.fn_queue_specifier.push(dynamic_permanents.fn_queue_specifier,
        function()
          local window = transf.running_application.main_window(
            transf.mac_application_name.running_application_or_nil("Telegram")
          )
          act.window.focus(window)
          dothis.window.set_hs_geometry_rect_like(window, {x = 0, y = 0, w = 800, h = 1500})
          dothis.input_spec_arr.exec({
            "m30 65 %tl", ".",
            "m40 395 %tl", ".",
            "m0 -300 %c", ".",
            "m0 295 %c", ".",
            "m-150 -155 %c", ".",
            "m-150 -65 %c", ".",
            "s0 -200",
            "m0 0 %c", ".",
            "s0 -200",
            "s0 -200",
            "s0 -70",
            "m0 0 %c", ".",
            "m0 -100 %c",
            "s0 -300",
            "s0 -300",
            "m0 170 %c", ".",
            "m130 215 %c", ".",
          })
          hs.timer.doAfter(300, do_after)
        end
      )
    end,
    signal_generate_backup = function(_, do_after)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped(
        "sigtop export-messages -f json" ..
        transf.str.str_by_single_quoted_escaped(
          transf.n_leaflikes.local_absolute_path_by_namespaced_cache("export", "signal") .. "/chats"
        ) .. "&& sigtop export-attachments" ..
        transf.str.str_by_single_quoted_escaped(
          transf.n_leaflikes.local_absolute_path_by_namespaced_cache("export", "signal") .. "/media"
        ),
        do_after
      )
    end,
    facebook_generate_backup = function(_, do_after)
      dothis.fn_queue_specifier.push(main_qspec,
      function()
        dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped("open -a Firefox" .. 
          transf.str.str_by_single_quoted_escaped("https://www.facebook.com/dyi/?referrer=yfi_settings") " && sleep 1", function()
            hs.eventtap.keyStroke({"cmd"}, "0") -- reset zoom
            local ff_window = transf.running_application.main_window(
              transf.mac_application_name.running_application_or_nil("Firefox")
            )
            act.window.focus(ff_window)
            dothis.window.set_hs_geometry_rect_like(ff_window, {x = 0, y = 0, w = 1280, h = 1600})
            dothis.input_spec_arr.exec({ 
              "m-100x-410 %c", -- format open
              ".",
              "m-100x-310 %c", -- format select
              ".",
              "m-100x-270 %c", -- date open
              ".",
              "m-100x-200 %c", -- date select
              ".",
              "m-80x690 %tr", -- deselect all
              ".",
              "m-63x945 %tr", -- select messages
              ".",
              "s0x-4000", -- scroll to end of page
              "m530x1548 %l", -- export button
              ".",
            })
            do_after()
          end)
        end
      )
    end,
    discord_generate_backup = function(_, do_after)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped(
        "dscexport exportdm --media --reuse-media -f json --dateformat unix -o" .. transf.str.str_by_single_quoted_escaped(
          transf.n_leaflikes.local_absolute_path_by_namespaced_cache("export", "discord")
        ),
        do_after
      )
    end,

  },
  telegram_raw_export_dir = {
    process_to_telegram_export_dir = function(dir)
      for _, chat_dir in transf.arr.pos_int_vt_stateless_iter(transf.dir.absolute_path_arr_by_children(transf.path.path_by_ending_with_slash(dir) .. "chats")) do
        local media_path = transf.path.path_by_ending_with_slash(dir) .. "media/" 
        for _, media_type_dir in transf.arr.pos_int_vt_stateless_iter(
          transf.dir.dir_arr_by_children(chat_dir)
        ) do
          dothis.dir.move_children_absolute_path_arr_into_absolute_path(
            media_type_dir,
            media_path
          )
        end
      end
      dothis.extant_path.move_to_absolute_path(
        dir,
        transf.n_leaflikes.local_absolute_path_by_namespaced_cache("export", "telegram")
      )

    end,
  },
  facebook_raw_export_dir = {
    process_to_facebook_export_dir = function(dir)
      local actual_dir = transf.path.path_by_ending_with_slash(dir) .. "messages/inbox/"
      for _, chat_dir in transf.arr.pos_int_vt_stateless_iter(transf.dir.absolute_path_arr_by_children(actual_dir)) do
        local media_path = chat_dir .. "media/"
        for _, media_type_dir in transf.arr.pos_int_vt_stateless_iter(
          transf.dir.dir_arr_by_children(chat_dir)
        ) do
          dothis.dir.move_children_absolute_path_arr_into_absolute_path(
            media_type_dir,
            media_path
          )
        end
      end
      dothis.extant_path.move_to_absolute_path(
        actual_dir,
        transf.n_leaflikes.local_absolute_path_by_namespaced_cache("export", "facebook")
      )
    end
  },
  backuped_thing_identifier = {
    write_current_timestamp_ms = function(identifier)
      dothis.local_file.write_file(
        transf.path.path_by_ending_with_slash(dynamic_permanents.str_key_str_value_assoc_by_env.MLAST_BACKUP) .. identifier,
        (os.time() - 30) * 1000
      )
    end,

  },
  relay_identifier_arr = {
    choose_item_and_set_active = function(arr)
      dothis.arr.choose_item(
        arr,
        act.relay_identifier.set_active_mullvad_relay_dentifier
      )
    end,
  },
  menu_item_table_arr = {
    choose_item_and_execute = function(arr)
      dothis.arr.choose_item(
        arr,
        act.menu_item_table.execute
      )
    end,
  },
  client_project_dir = {
    generate_rechnung_de_md = function(dir)
      dothis.absolute_path.write_file(
        transf.client_project_dir.local_absolute_path_by_rechnung_md(dir),
        transf.client_project_dir.multiline_str_by_raw_rechnung_de(dir)
      )
    end,
  },
  latex_project_dir = {
    open_pdf = function(latex_project_dir)
      act.local_path.open_default(
        transf.latex_project_dir.local_absolute_path_by_main_pdf_file(latex_project_dir)
      )
    end,
    build_and_open_pdf = function(latex_project_dir)
      act.latex_project_dir.build(
        latex_project_dir,
        get.fn.fn_by_1st_n_bound(act.latex_project_dir.open_pdf, latex_project_dir)
      )
    end,
    write_bib = function(latex_project_dir)
      dothis.citations_file.write_bib(
        transf.latex_project_dir.citations_file(latex_project_dir),
        transf.latex_project_dir.local_absolute_path_by_main_bib_file(latex_project_dir)
      )
    end,
  },
  arr = {
    choose_item_and_action = function(arr)
      dothis.arr.choose_item(arr, dothis.any.choose_action)
    end,
    pop = function(arr)
      local last = arr[#arr]
      arr[#arr] = nil
      return last
    end,
    shift = function(arr)
      return table.remove(arr, 1)
    end,
    to_empty_table = function(arr)
      for i, v in transf.arr.pos_int_vt_stateless_iter(arr) do
        arr[i] = nil
      end
    end,
    sort = function(arr)
      dothis.arr.sort(arr)
    end,
  },
  contact_table = {
    edit_contact = function(table, do_after)
      dothis.contact_uuid.edit_contact(transf.contact_table.contact_uuid(table), do_after)
    end,
    add_iban_by_prompted = function(table)
      dothis.contact_table.add_iban(table, get.str.str_by_prompted_once_from_default("", "Enter an IBAN:"))
    end,
  },
  contact_uuid = {
    edit_contact = function(uuid)
      dothis.contact_uuid.edit_contact(uuid)
    end,
    add_iban_by_prompted = function(uuid)
      dothis.contact_uuid.add_iban(uuid, get.str.str_by_prompted_once_from_default("", "Enter an IBAN:"))
    end,
  },
  m3u_file = {
    add_to_hydrus = function(path)
      local urls = transf.plaintext_file.noempty_noindent_nohashcomment_line_arr(path)
      dothis.arr.each(
        urls,
        function(url)
          if is.url.youtube_video_url(url) then
            dothis.youtube_video_url.add_to_hydrus(
              url,
              transf.local_file.line_arr_by_file_tags(path),
              function()
                act.file.delete_file(path)
              end
            )
          end
        end
      )
    end,
  },
  youtube_video_url = {
    add_as_m3u = function(url)
      local deduced_tags = transf.youtube_video_url.lower_alphanum_underscore_key_lower_alphanum_underscore_or_lower_alphanum_underscore_arr_value_assoc(url)
      local edited_tags = transf.str_value_assoc.str_value_assoc_by_prompted_once_from_default(deduced_tags)
      local plspec = {}
      plspec.tag = transf.two_arr_or_nils.arr(edited_tags, transf.str.two_strs__arr_ar_by_prompted_multiple("tag"))
      plspec.path  = get.local_extant_path.dir_by_default_prompted_once(dynamic_permanents.str_key_str_value_assoc_by_env.MAUDIOVISUAL)
      plspec.path = transf.str.str_by_prompted_once_from_default(plspec.path)
      plspec.extension = "m3u"
      dothis.absolute_path.write_file(transf.path_leaf_specifier.absolute_path(plspec), url)
    end,
    add_to_hydrus = function(url, do_after)
      dothis.youtube_video_url.add_to_hydrus(url, {}, do_after)
    end,
  },
  source_id = {
    activate = function(source_id)
      hs.keycodes.currentSourceID(source_id)
      hs.alert.show(transf.source_id.line_by_language(source_id))
    end,
  },
  source_id_arr = {
    activate_next = function(arr)
      act.source_id.activate(
        transf.source_id_arr.source_id_by_next_to_be_activated(arr)
      )
    end,
  },
  in_git_dir_arr = {
    pull_all = function(paths)
      dothis.arr.each(paths, act.in_git_dir.pull)
    end,
    push_all = function(paths)
      dothis.arr.each(paths, act.in_git_dir.push)
    end,
    fetch_all = function(paths)
      dothis.arr.each(paths, act.in_git_dir.fetch)
    end,

  },
  old_location_logs_proc_dir = {
    process_to_new_location_logs = function(path)
      local timestamp_ms_key_location_log_spec_value_assoc = transf.old_location_logs_proc_dir.timestamp_ms_key_location_log_spec_value_assoc_by_path(path)
      dothis.logging_dir.log_timestamp_ms_key_assoc_value_assoc(
        dynamic_permanents.str_key_str_value_assoc_by_env.MMOMENTS .. "/location_logs",
        timestamp_ms_key_location_log_spec_value_assoc
      )
    end,
  },
  old_media_logs_proc_dir = {
    process_to_new_media_logs = function(path)
      local timestamp_ms_key_media_log_spec_value_assoc = transf.old_media_logs_proc_dir.timestamp_ms_key_media_log_spec_value_assoc(path)
      dothis.logging_dir.log_timestamp_ms_key_assoc_value_assoc(
        dynamic_permanents.str_key_str_value_assoc_by_env.MMOMENTS .. "/media_logs",
        timestamp_ms_key_media_log_spec_value_assoc
      )
    end,
  },
  old_entries_proc_dir = {
    process_to_new_entries = function(path)
      local files = transf.dir.absolute_path_arr_by_children(path)
      local assoc = get.table.table_by_mapped_w_vt_arg_kt_vt_ret_fn(
        files,
        function(fpath)
          local rfc3339like_ymd = transf.path.path_leaf_specifier_or_nil(fpath).rfc3339like_dt_o_interval
          local ts = transf.rfc3339like_dt.timestamp_s_by_min(rfc3339like_ymd) * 1000
          return ts , {entry = transf.plaintext_file.str_by_contents(fpath), timestamp_ms = ts }
        end
      )
      dothis.logging_dir.log_timestamp_ms_key_assoc_value_assoc(
        dynamic_permanents.str_key_str_value_assoc_by_env.MMOMENTS .. "/entries",
        assoc
      )
    end,
  },
  git_tmp_log_dir = {
    process_to_git_logs = function(path)
      local timestamp_ms_key_git_log_spec_value_assoc = transf.git_tmp_log_dir.timestamp_ms_key_assoc_value_assoc(path)
      dothis.logging_dir.log_timestamp_ms_key_assoc_value_assoc(
        dynamic_permanents.str_key_str_value_assoc_by_env.MMOMENTS .. "/git_logs",
        timestamp_ms_key_git_log_spec_value_assoc
      )
      act.dir.empty_dir(path)
    end,
  },
  mpv_tmp_log_dir = {
    process_to_media_logs = function(path)
      local timestamp_ms_key_media_log_spec_value_assoc = transf.mpv_tmp_log_dir.timestamp_ms_key_media_log_spec_value_assoc(path)
      dothis.logging_dir.log_timestamp_ms_key_assoc_value_assoc(
        dynamic_permanents.str_key_str_value_assoc_by_env.MMOMENTS .. "/media_logs",
        timestamp_ms_key_media_log_spec_value_assoc
      )
      act.dir.empty_dir(path)
    end,
  },
  backup_type = {
    log = function(typ)
      dothis.export_dir.log(
        transf.n_leaflikes.local_absolute_path_by_namespaced_cache("export", typ),
        typ
      )
    end
  },
  fn_queue_specifier = {
    update = function(qspec)
      hs.alert.closeSpecific(qspec.alert)
      if #qspec.fn_arr == 0 then 
        act.hotkey_created_item_specifier.pause(qspec.hotkey_created_item_specifier)
      else
        qspec.alert = dothis.str.alert(
          transf.fn_queue_specifier.str_by_waiting_message(qspec),
          "indefinite"
        )
        act.hotkey_created_item_specifier.resume(qspec.hotkey_created_item_specifier)
      end
    end,
    pop = function(qspec)
      local fn = act.arr.pop(qspec.fn_arr)
      fn()
      act.fn_queue_specifier.update(qspec)
    end,
  },
  fn = {
    reset_by_all = function(fn)
      act.fnid.reset_by_all(
        transf.fn.fnid(fn)
      )
    end,
  },
}