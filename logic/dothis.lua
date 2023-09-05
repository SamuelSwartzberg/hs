dothis = {
  package_manager_name = {
    install = function(mgr, pkg)
      dothis.str.env_bash_eval("upkg " .. mgr .. " install " .. transf.str.str_by_single_quoted_escaped(pkg))
    end,
    remove = function(mgr, pkg)
      dothis.str.env_bash_eval("upkg " .. mgr .. " remove " .. transf.str.str_by_single_quoted_escaped(pkg))
    end,
    upgrade = function(mgr, pkg)
      local target
      if pkg then target = transf.str.str_by_single_quoted_escaped(pkg)
      else target = "" end
      dothis.str.env_bash_eval("upkg " .. mgr .. " upgrade " .. target)
    end,
    link = function(mgr, pkg)
      dothis.str.env_bash_eval("upkg " .. mgr .. " link " .. transf.str.str_by_single_quoted_escaped(pkg))
    end,
    do_backup_and_commit = function(mgr, action, msg)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped("upkg " .. mgr .. " " .. action, function()
        local message = msg or action
        
        if mgr then
          message = message .. " for " .. mgr
          local mgr_backup = st(env.MDEPENDENCIES .. "/" .. mgr)
          mgr_backup:doThis("git-commit-self", message)
          mgr_backup:doThis("git-push")
        else 
          local mdependencies = st(env.MDEPENDENCIES)
          mdependencies:doThis("git-commit-all", message)
          mdependencies:doThis("git-push")
        end
      end)
    end,
  },
  event_table = {
    add_event_from = function(specifier, do_after)
      specifier = specifier or {}
      specifier = get.table.table_by_mapped_w_vt_arg_vt_ret_fn_and_vt_arg_bool_ret_fn(specifier, transf.str.not_starting_o_ending_with_whitespace_str, is.any.str)
      local command = {"khal", "new" }
      if specifier.calendar then
        command = transf.two_arrs.arr_by_appended(
          command,
            "--calendar" ..
            transf.str.str_by_single_quoted_escaped(specifier.calendar)
        )
      end

      if specifier.location then
        command = transf.two_arrs.arr_by_appended(
          command,
            "--location" ..
            transf.str.str_by_single_quoted_escaped(specifier.location)
        )
      end

      if specifier.alarms then
        local alarms_str = get.str_or_number_arr.str_by_joined(
          get.table.table_by_mapped_w_vt_arg_vt_ret_fn_and_vt_arg_bool_ret_fn(specifier.alarms, transf.str.not_starting_o_ending_with_whitespace_str, is.any.str),
          ","
        )
        command = transf.two_arrs.arr_by_appended(
          command,
            "--alarm" ..
            transf.str.str_by_single_quoted_escaped(alarms_str )
        )
      end

      if specifier.url then 
        command = transf.two_arrs.arr_by_appended(
          command,
            "--url" ..
            transf.str.str_by_single_quoted_escaped(specifier.url)
        )
      end

      -- needed for postcreation modifications 
      command = transf.two_arrs.arr_by_appended(
        command,
          "--format" ..
          transf.str.str_by_single_quoted_escaped("{uid}")
      )

      if specifier.start then
        dothis.arr.push(command, specifier.start)
      end

      if specifier["end"] then
        dothis.arr.push(command, specifier["end"])
      end

      if specifier.timezone then
        dothis.arr.push(command, specifier.timezone)
      end

      if specifier.title then
        dothis.arr.push(command, specifier.title)
      end

      if specifier.description then
        command = transf.two_arrs.arr_by_appended(
          command,
            "::" ..
            transf.str.str_by_single_quoted_escaped(specifier.description)
        )
      end

      if do_after then
        dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped(
          get.str_or_number_arr.str_by_joined(command, " "), 
          do_after
        )
      else
        dothis.str.env_bash_eval_sync(
          get.str_or_number_arr.str_by_joined(command, " ")
        )
      end
    end,
    add_event_interactive = function(event_table, do_after)
      event_table = event_table or {}
      local temp_file_contents = get.str.str_by_evaled_as_template(transf.event_table.yaml_str_by_calendar_template(event_table))
      dothis.str.edit_temp_file_in_vscode_act_on_contents(temp_file_contents, function(cnt)
        local new_specifier = transf.yaml_str.not_userdata_or_function(cnt)
        dothis.event_table.add_event_from(new_specifier, do_after)
      end)
    end,
  },
  md_file = {
    to_file_in_same_dir = function(source, format, metadata, do_after)
      local target = transf.path.path_by_without_extension(source) .. "." .. tblmap.pandoc_format.extension[format]
      local rawsource = transf.file.str_by_contents(source)
      local processedsource = get.str.str_by_with_yaml_metadata(rawsource, metadata)
      rawsource = get.str.str_and_int_by_replaced_eutf8_w_regex_str(rawsource, "\n +\n", "\n&nbsp;\n")
      local temp_path = source .. ".tmp"
      dothis.absolute_path.write_file(temp_path, processedsource) 
      local cmd = 
        "pandoc" ..
        "--wrap=preserve -f markdown+" .. get.str_or_number_arr.str_by_joined(get.pandoc.extensions(), "+") .. " --standalone -t" ..
        format ..
        "-i" ..
        transf.str.str_by_single_quoted_escaped(temp_path)
        "-o" ..
        transf.str.str_by_single_quoted_escaped(target)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped(cmd, function ()
        dothis.absolute_path.delete(temp_path)
        if do_after then
          do_after(target)
        end
      end)
    end,
    to_file_in_target = function(source, target_dir, format, metadata)
      dothis.md_file.to_file_in_same_dir(source, format, metadata, function(target)
        dothis.extant_path.move_into_absolute_path(target, target_dir)
      end)
    end,
    to_file_in_downloads = function(source, format, metadata)
      dothis.md_file.to_file_in_target(source, env.DOWNLOADS, format, metadata)
    end,
  },
  contact_uuid = {
    add_contact_data = function(uuid, data, type)
      type = "contacts/" .. type
      dothis.alphanum_minus_underscore.set_pass_json(uuid, type, data)
    end,
    edit_contact = function(uuid, do_after)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped("khard edit " .. uuid, do_after or function() end)
    end,
  },
  pass_item_name = {
    replace = function(name, type, data)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped("pass rm " .. type .. "/" .. name, function()
        dothis.alphanum_minus_underscore.add_as_pass_item_name(name, type, data)
      end)
    end,
    rename = function(name, type, new_name)
      dothis.str.env_bash_eval("pass mv " .. type .. "/" .. name .. " " .. type .. "/" .. new_name)
    end,
    remove = function(name, type)
      dothis.str.env_bash_eval("pass rm " .. type .. "/" .. name)
    end,
  },
  alphanum_minus_underscore = {
    add_as_pass_item_name_with_json = function(name, type, data)
      dothis.alphanum_minus_underscore.add_as_pass_item_name(name, type, json.encode(data))
    end,
    add_as_pass_item_name = function(name, type, data)
      dothis.str.env_bash_eval("yes " .. transf.not_userdata_or_function.single_quoted_escaped(data) .. " | pass add " .. type .. "/" .. name)
    end,
    add_as_passw_pass_item_name = function(name, password)
      dothis.alphanum_minus_underscore.add_as_pass_item_name(name, "passw", password)
    end,
    add_as_username_pass_item_name = function(name, username)
      dothis.absolute_path.write_file(
        get.pass_item_name.local_absolute_path(name, "username", "txt"),
        username
      )
    end,
  },
  contact_table = {
    add_iban = function(contact_table, iban)
      dothis.contact_uuid.add_contact_data(transf.contact_table.uuid(contact_table), "iban", iban)
    end,
    edit = function(contact_table, do_after)
      dothis.contact_uuid.edit_contact(transf.contact_table.uuid(contact_table), do_after)
    end,
  },
  youtube_video_id = {
    
  },
  url = {
    download_to_async = function(url, target)
      dothis.str.env_bash_eval_async("curl -L " .. transf.str.str_by_single_quoted_escaped(url) .. " -o " .. transf.str.str_by_single_quoted_escaped(target))
    end,
    download_to_sync = function(url, target)
      dothis.str.env_bash_eval_sync("curl -L " .. transf.str.str_by_single_quoted_escaped(url) .. " -o " .. transf.str.str_by_single_quoted_escaped(target))
    end,
    download_into_async = function(url, target_dir)
      dothis.str.env_bash_eval_async("cd " .. transf.str.str_by_single_quoted_escaped(target_dir) .. "&& curl -L " .. transf.str.str_by_single_quoted_escaped(url) .. " -O")
    end,
    download_into_sync = function(url, target_dir)
      dothis.str.env_bash_eval_sync("cd " .. transf.str.str_by_single_quoted_escaped(target_dir) .. "&& curl -L " .. transf.str.str_by_single_quoted_escaped(url) .. " -O")
    end,
      
    add_event_from_url = function(url, calendar)
      local temp_path_arg = transf.str.str_by_single_quoted_escaped(env.TMPDIR .. "/event_downloaded_at_" .. os.time() .. ".ics")
      dothis.str.env_bash_eval('curl' .. transf.str.str_by_single_quoted_escaped(url) .. ' -o' .. temp_path_arg .. '&& khal import --include-calendar ' .. calendar .. temp_path_arg)
    end,
  },
  otp_url = {
    add_otp_pass_item = function(url, name)
      dothis.str.env_bash_eval_async(
        "echo" ..
        transf.str.str_by_single_quoted_escaped(url) ..
        "| pass otp insert otp/" .. name
      )
    end,
  },
  table = {
    write_ics_file = function(tbl, path)
      local tmpdir_json_path = transf.not_userdata_or_function.in_tmp_dir(tbl) .. ".json"
      local tmpdir_ics_path = transf.not_userdata_or_function.in_tmp_dir(tbl) .. ".ics"
      dothis.absolute_path.write_file(tmpdir_json_path, json.encode(tbl))
      dothis.str.env_bash_eval_sync(
        "ical2json" ..
        "-r" ..
        transf.str.str_by_single_quoted_escaped(tmpdir_ics_path)
      )
      dothis.absolute_path.delete(tmpdir_json_path)
      if path then
        dothis.extant_path.move_to_absolute_path(tmpdir_ics_path, path)
        dothis.absolute_path.delete(tmpdir_ics_path)
      end
    end,
    choose_w_pair_arg_fn = function(tbl, fn, target_item_chooser_item_specifier_name)
      dothis.arr.choose_item(
        transf.table.two_anys_arr_by_sorted_smaller_key_first(tbl),
        fn,
        target_item_chooser_item_specifier_name
      )
    end,
    choose_w_kt_vt_arg_fn = function(tbl, fn, target_item_chooser_item_specifier_name)
      dothis.arr.choose_item(
        transf.table.two_anys_arr_by_sorted_smaller_key_first(tbl),
        function(two_anys_arr)
          fn(transf.two_anys_arr.two_ts(two_anys_arr))
        end,
        target_item_chooser_item_specifier_name
      )
    end,
    choose_w_kt_fn = function(tbl, fn, target_item_chooser_item_specifier_name)
      dothis.arr.choose_item(
        transf.table.two_anys_arr_by_sorted_smaller_key_first(tbl),
        function(two_anys_arr)
          fn(transf.two_anys_arr.t_by_first(two_anys_arr))
        end,
        target_item_chooser_item_specifier_name
      )
    end,
    choose_w_vt_fn = function(tbl, fn, target_item_chooser_item_specifier_name)
      dothis.arr.choose_item(
        transf.table.two_anys_arr_by_sorted_smaller_key_first(tbl),
        function (two_anys_arr)
          fn(transf.two_anys_arr.t_by_second(two_anys_arr))
        end,
        target_item_chooser_item_specifier_name
      )
    end,
    choose_kt_w_kt_fn = function(tbl, fn, target_item_chooser_item_specifier_name)
      dothis.arr.choose_item(
        transf.table.kt_arr_by_sorted_smaller_first(tbl),
        fn,
        target_item_chooser_item_specifier_name
      )
    end,
    choose_vt_w_vt_fn = function(tbl, fn, target_item_chooser_item_specifier_name)
      dothis.arr.choose_item(
        transf.table.vt_arr_by_sorted_smaller_first(tbl),
        fn,
        target_item_chooser_item_specifier_name
      )
    end,
  },
  str = {
    generate_qr_png = function(data, path)
      if not is.path.extant_path(path) then
        transf.str.str_or_nil_by_evaled_env_bash_stripped("qrencode -l M -m 2 -t PNG -o" .. transf.str.str_by_single_quoted_escaped(path) .. transf.str.str_by_single_quoted_escaped(data))
      end -- else: don't do anything: QR code creation is deterministic, so we don't need to do it again. This relies on the path not changing, which our consumers are responsible for.
    end,
    alert = function(str, duration)
      return hs.alert.show(str, {textSize = 12, textFont = "Noto Sans Mono", atScreenEdge = 1, radius = 3}, duration)
    end,
    say = function(str, lang)
      speak:voice(tblmap.lang.voice[lang]):speak(transf.str.singleline_str_by_folded(str))
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
      dothis.str.paste(get.str.str_by_evaled_as_template(str))
    end,
    fill_with_lines = function(str)
      dothis.str_arr.fill_with(transf.str.line_arr(str))
    end,
    fill_with_content_lines = function(path)
      dothis.str_arr.fill_with(transf.str.noempty_line_arr(path))
    end,
    fill_with_nocomment_noindent_content_lines = function(path)
      dothis.str_arr.fill_with(transf.str.nocomment_noindent_content_lines(path))
    end,
    search = function(str, search_engine_id)
      dothis.url_or_local_path.open_browser(
        get.str.search_engine_id_search_url(search_engine_id, str)
      )
    end,
    write_to_temp_file = function(str)
      local path = transf.str.in_tmp_local_absolute_path(os.time(), "temp_file")
      dothis.absolute_path.write_file(path, str)
      return path
    end,
    open_temp_file = function(str, do_after)
      dothis.local_path.open_app(
        transf.str.write_to_temp_file(str),
        env.GUI_EDITOR,
        do_after
      )
    end,
    edit_temp_file_in_vscode_act_on_path = function(str, do_after)
      local path = transf.str.write_to_temp_file(str)
      dothis.local_file.edit_file_in_vscode_act_on_path(path, do_after)
    end,
    edit_temp_file_in_vscode_act_on_contents = function(str, do_after)
      local path = transf.str.write_to_temp_file(str)
      dothis.local_file.edit_file_in_vscode_act_on_contents(path, do_after)
    end,
    create_url_arr_as_session_in_msessions = function(str)
      dothis.url_arr.create_as_session_in_msessions(
        transf.str.url_arr(str)
      )
    end,
    raw_bash_eval_w_str_or_str_and_8_bit_pos_int_arg_fn = function(str, fn)
      local task = hs.task.new(
        "/opt/homebrew/bin/bash",
        function (...) fn(transf.number_and_two_anys.any_or_any_and_number_by_zero(...)) end,
        { "-c", transf.str.str_by_minimal_locale_setter_commands_prepended(
          str
        )}
      )
      task:start()
      return task
    end,
    env_bash_eval_w_str_or_str_and_8_bit_pos_int_arg_fn = function(str, fn)
      local task = hs.task.new(
        "/opt/homebrew/bin/bash",
        function (...) fn(transf.number_and_two_anys.any_or_any_and_number_by_zero(...)) end,
        { "-c", transf.str.str_by_env_getter_comamnds_prepended(
          str
        )}
      )
      task:start()
      return task
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
    env_bash_eval_w_str_or_str_and_8_bit_pos_int_arg_fn_by_stripped = function(str, fn)
      dothis.str.env_bash_eval_w_str_or_str_and_8_bit_pos_int_arg_fn(
        str,
        get.n_any_arg_fn.n_t_arg_fn_w_n_any_arg_n_t_ret_fn(fn, transf.str_and_n_anys.str_and_n_anys_by_stripped)
      )
    end,
    env_bash_eval_w_str_or_nil_arg_fn_by_stripped = function(str, fn)
      dothis.str.env_bash_eval_w_str_or_str_and_8_bit_pos_int_arg_fn_by_stripped(
        str,
        get.n_any_arg_fn.n_t_arg_fn_w_n_any_arg_n_t_ret_fn(fn, transf.str_and_number_or_nil.str_or_nil_by_number)
      )
    end,
    env_bash_eval_w_str_arg_fn_str_arg_fn_by_stripped = function(str, succfn, failfn)
      dothis.str.env_bash_eval_w_str_or_str_and_8_bit_pos_int_arg_fn_by_stripped(
        str,
        function(res, code)
          if code then
            failfn("Exit code " .. code .. " for command " .. str ". Stderr:\n\n" .. res)
          else
            succfn(res)
          end
        end
      )
    end,
    env_bash_eval_w_str_or_nil_arg_fn_by_stripped_noempty = function(str,fn)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped(
        str,
        function(str_or_nil)
          if str_or_nil == "" then str_or_nil = nil end
          fn(str_or_nil)
        end
      )
    end,
    env_bash_eval_w_str_arg_fn_str_arg_fn_by_stripped_noempty = function(str, succfn, failfn)
      dothis.str.env_bash_eval_w_str_arg_fn_str_arg_fn_by_stripped(
        str,
        function(str)
          if str == "" then failfn("Empty str for command " .. str) else succfn(str) end
        end,
        failfn
      )
    end,
    env_bash_eval_w_not_userdata_or_function_or_nil_arg_fn_by_parsed_json = function(str, fn)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped_noempty(
        str,
        function(str_or_nil)
          str_or_nil = transf.fn.rt_or_nil_fn_by_pcall(transf.json_str.not_userdata_or_function)(str_or_nil)
          fn(str_or_nil)
        end
      )
    end,
    env_bash_eval_w_not_userdata_or_function_arg_fn_str_arg_fn_by_parsed_json = function(str, succfn, failfn)
      dothis.str.env_bash_eval_w_str_arg_fn_str_arg_fn_by_stripped_noempty(
        str,
        function(str)
          local succ, res = pcall(transf.json_str.not_userdata_or_function, str)
          if succ then
            succfn(res)
          else
            failfn(res)
          end
        end,
        failfn
      )
    end,
    env_bash_eval_w_table_or_nil_arg_fn_by_parsed_json = function(str, fn)
      dothis.str.env_bash_eval_w_not_userdata_or_function_or_nil_arg_fn_by_parsed_json(
        str,
        function(arg)
          if not is.any.table(arg) then arg = nil end
          fn(arg)
        end
      )
    end,
    env_bash_eval_w_table_arg_fn_str_arg_fn = function(str, succfn, failfn)
      dothis.str.env_bash_eval_w_not_userdata_or_function_arg_fn_str_arg_fn_by_parsed_json(
        str,
        function(arg)
          if not is.any.table(arg) then failfn("Not a table: " .. arg) else succfn(arg) end
        end,
        failfn
      )
    end,
    env_bash_eval_w_table_or_nil_arg_fn_by_parsed_json_nil_error_key = function(str, fn)
      dothis.str.env_bash_eval_w_table_or_nil_arg_fn_by_parsed_json(
        str,
        function(arg)
          if arg.error then arg = nil end
          fn(arg)
        end
      )
    end,
    env_bash_eval_w_table_arg_fn_str_arg_fn_fail_error_key = function(str, succfn, failfn)
      dothis.str.env_bash_eval_w_table_arg_fn_str_arg_fn(
        str,
        function(arg)
          if arg.error then failfn(arg.error) else succfn(arg) end
        end,
        failfn
      )
    end,
   


  },
  url_or_local_path = {
    open_browser = function(url, browser, do_after)
      url = transf.urllike_with_no_scheme.url_by_ensure_scheme(url)
      browser = browser or "Firefox"
      if do_after then -- if we're opening an url, typically, we would exit immediately, negating the need for a callback. Therefore, we want to wait. The only easy way to do this is to use a completely different browser. 
        transf.str.str_or_nil_by_evaled_env_bash_stripped("open -a Safari -W" .. transf.str.str_by_single_quoted_escaped(url), do_after)
        -- Annoyingly, due to a 15 (!) year old bug, Firefox will open the url as well, even if we specify a different browser. I've tried various fixes, but for now we'll just have to live with it and click the tab away manually.
      else
        transf.str.str_or_nil_by_evaled_env_bash_stripped("open -a" .. transf.str.str_by_single_quoted_escaped(browser))
      end
    end,
  },
  local_path = {
    open_default = function(path, do_after)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped("open " .. transf.str.str_by_single_quoted_escaped(path), do_after)
    end,
    open_app = function(path, app, do_after)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped("open -a " .. transf.str.str_by_single_quoted_escaped(app) .. " " .. transf.str.str_by_single_quoted_escaped(path), do_after)
    end,
    open_gui_editor = function(path, do_after)
      dothis.local_path.open_app(path, env.GUI_EDITOR, do_after)
    end,
    open_and_reveal = function(path)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped("open -R " .. transf.str.str_by_single_quoted_escaped(path))
    end,
    write_nonabsolute_path_key_assoc = function(path, nonabsolute_path_key_assoc, extension)
      dothis.dynamic_absolute_path_key_assoc.write(
        get.nonabsolute_path_key_assoc.absolute_path_key_assoc(nonabsolute_path_key_assoc, path, extension)
      )
    end,
    write_dynamic_path_assoc = function(path, assoc, extension)
      dothis.local_path.write_nonabsolute_path_key_assoc(
        transf.table.nonabsolute_path_key_assoc(path), 
        assoc, 
        extension
      )
    end,
    write_dynamic_structure = function(path, name)
      dothis.local_path.write_dynamic_path_assoc(
        path,
        tblmap.dynamic_structure_name.dynamic_structure[name]
      )
    end,
    serve = function(path, port)
      port = port or env.FS_HTTP_SERVER_PORT
      dothis.created_item_specifier_arr.create_or_recreate(
        task_created_item_specifier_arr,
        {
          type = "task",
          args = "http-server -a 127.0.0.1 -p '" .. port .. "' -c-1 '" .. path .. "'"
        }
      )
    end
  },
  absolute_path = {
    write_template = function(path, template_path)
      dothis.absolute_path.write_file(
        path,
        get.str.str_by_evaled_as_template(
          get.str.evaled_as_lua(template_path),
          path
        )
      )
    end,
    create_dir = function(path)
      if is.absolute_path.nonextant_path(path) then
        dothis.nonextant_path.create_dir(path)
      end
    end,
    create_parent_dir = function(path)
      dothis.absolute_path.create_parent_dir(path)
    end,
    copy_into_absolute_path = function(path, tgt)
      if is.absolute_path.extant_path(path) then
        dothis.extant_path.copy_into_absolute_path(path, tgt)
      end
    end,
    copy_to_absolute_path = function(path, tgt)
      if is.absolute_path.extant_path(path) then
        dothis.extant_path.copy_to_absolute_path(path, tgt)
      end
    end,
    delete = function(path)
      if is.absolute_path.extant_path(path) then
        dothis.extant_path.delete(path)
      end
    end,
    empty = function(path)
      if is.absolute_path.extant_path(path) then
        dothis.extant_path.empty(path)
      end
    end,
    delete_dir = function(path)
      if is.path.extant_path(path) then
        dothis.extant_path.delete_dir(path)
      end
    end,
    empty_dir = function(path)
      if is.path.extant_path(path) then
        dothis.extant_path.empty_dir(path)
      end
    end,
    delete_file = function(path)
      if is.path.extant_path(path) then
        dothis.extant_path.delete_file(path)
      end
    end,
    empty_file = function(path)
      if is.path.extant_path(path) then
        dothis.extant_path.empty_file(path)
      end
    end,
    delete_if_empty_path = function(path)
      if is.path.extant_path(path) then
        dothis.extant_path.delete_if_empty_path(path)
      end
    end,
    delete_file_if_empty_file = function(path)
      if is.path.extant_path(path) then
        dothis.extant_path.delete_file_if_empty_file(path)
      end
    end,
    delete_dir_if_empty_dir = function(path)
      if is.path.extant_path(path) then
        dothis.extant_path.delete_dir_if_empty_dir(path)
      end
    end,
    initialize_omegat_project = function (path)
      dothis.local_path.write_dynamic_structure(path, "omegat")
      dothis.omegat_project_dir.pull_project_materials(path)
    end,
    write_file = function(path, contents)
      dothis.absolute_path.create_parent_dir(path)
      dothis.file.write_file(path, contents)
    end,
    empty_write_file = function(path)
      dothis.absolute_path.create_parent_dir(path)
      dothis.file.empty_write_file(path)
    end,
    append_or_write_file = function(path, contents)
      dothis.absolute_path.create_parent_dir(path)
      dothis.file.append_or_write_file(path, contents)
    end,
    append_file_if_file = function(path, contents)
      if is.absolute_path.file(path) then
        dothis.absolute_path.create_parent_dir(path)
        dothis.file.append_file(path, contents)
      end
    end,
    write_file_if_nonextant_path = function(path, contents)
      if is.absolute_path.nonextant_path(path) then
        dothis.absolute_path.create_parent_dir(path)
        dothis.file.write_file(path, contents)
      end
    end,
    write_file_if_file = function(path, contents)
      if is.absolute_path.file(path) then
        dothis.absolute_path.create_parent_dir(path)
        dothis.file.write_file(path, contents)
      end
    end,
  },
  local_absolute_path = {
    start_recording_to = function(path, do_after)
      dothis.absolute_path.create_parent_dir(path)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("rec " .. transf.str.str_by_single_quoted_escaped(path), function()
        if do_after then
          do_after(path)
        end
      end)
    end,
  },
  local_nonextant_path = {
    create_dir = function(path)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("mkdir -p " .. transf.str.str_by_single_quoted_escaped(path))
    end,
  },
  local_nonabsolute_path_relative_to_home = {
    copy_local_to_labelled_remote = function(path)
      dothis.absolute_path.copy_to_absolute_path(
        transf.local_nonabsolute_path_relative_to_home.local_absolute_path(path),
        transf.labelled_remote_path.labelled_remote_absolute_path(path)
      )
    end,
    copy_labelled_remote_to_local = function(path)
      dothis.absolute_path.copy_to_absolute_path(
        transf.labelled_remote_path.labelled_remote_absolute_path(path),
        transf.local_nonabsolute_path_relative_to_home.local_absolute_path(path)
      )
    end,

  },
  labelled_remote_absolute_path = {
    
  },
  labelled_remote_nonextant_path = {
    create_dir = function(path)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("rclone mkdir " .. transf.str.str_by_single_quoted_escaped(path))
    end,
  },
  remote_absolute_path = {
    
  },
  remote_extant_path = {
    zip_to_absolute_path = function(path, tgt)
      local tmppath = transf.str.in_tmp_local_absolute_path(tgt, "temp_zip")
      dothis.extant_path.copy_to_absolute_path(
        path,
        tmppath
      )
      dothis.local_extant_path.zip_to_absolute_path_and_delete(tmppath, tgt)
    end,
  },
  remote_extant_path_arr = {
    zip_to_absolute_path = function(arr, tgt)
      local tmppath = transf.str.in_tmp_local_absolute_path(tgt, "temp_zip")
      dothis.extant_path_arr.copy_into_absolute_path(
        arr,
        tmppath
      )
      dothis.extant_path.zip_to_absolute_path_and_delete(tmppath, tgt)
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
    make_executable = function(path)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("chmod +x " .. transf.str.str_by_single_quoted_escaped(path))
    end,
    do_in_path = function(path, cmd, do_after)
      if is.path.dir(path) then
        dothis.dir.do_in_path(path, cmd, do_after)
      else
        dothis.dir.do_in_path(transf.path.trimmed_noweirdwhitespace_line_by_parent_path(path), cmd, do_after)
      end
    end,
    delete = os.remove,
    move_to_local_absolute_path = function(path, tgt)
      dothis.local_extant_path.create_parent_dir(tgt)
      os.rename(path, tgt)
    end,
    zip_to_local_absolute_path = function(path, tgt)
      dothis.local_extant_path.create_parent_dir(tgt)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("zip -r " .. transf.str.str_by_single_quoted_escaped(tgt) .. " " .. transf.str.str_by_single_quoted_escaped(path))
    end,
    zip_to_absolute_path = function(path, tgt)
      local tmptgt = transf.str.in_tmp_local_absolute_path(tgt, "temp_zip_target")
      dothis.local_extant_path.zip_to_local_absolute_path(path, tmptgt)
      dothis.extant_path.move_to_absolute_path(tmptgt, tgt)
    end,
    zip_to_absolute_path_and_delete = function(path, tgt)
      dothis.local_extant_path.zip_to_absolute_path(path, tgt)
      dothis.local_extant_path.delete(path)
    end,
    link_to_nosudo_nonextant_path = function(path, tgt)
      dothis.absolute_path.create_parent_dir(tgt)
      hs.fs.link(path, tgt, true)
    end,
    link_to_local_nonextant_path = function(path, tgt)
      dothis.absolute_path.create_parent_dir(tgt)
      dothis.str.env_bash_eval_sync(
        "pass passw/os | sudo -S ln -s " .. transf.str.str_by_single_quoted_escaped(path) .. transf.str.str_by_single_quoted_escaped(tgt)
      )
    end,
    link_to_local_absolute_path = function(path, tgt)
      dothis.absolute_path.delete(tgt)
      dothis.local_extant_path.link_to_local_nonextant_path(path, tgt)
    end,
    link_into_local_absolute_path = function(path, tgt)
      local finaltgt = transf.path.path_by_ending_with_slash(tgt) .. transf.path.leaflike_by_leaf(path)
      dothis.local_extant_path.link_to_local_nonextant_path(path, finaltgt)
    end,
    link_descendant_file_arr_into_local_absolute_path = function(path, tgt)
      dothis.local_extant_path_arr.link_into_local_absolute_path(
        transf.path.descendant_file_arr(path),
        tgt
      )
    end,
    
  },
  local_extant_path_arr = {
    zip_to_local_absolute_path = function(arr, tgt)
      dothis.local_extant_path.create_parent_dir(tgt)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("zip -r " .. transf.str.str_by_single_quoted_escaped(tgt) .. " " .. transf.str.str_by_single_quoted_escaped(get.str_or_number_arr.str_by_joined(arr, " ")))
    end,
    zip_to_absolute_path = function(arr, tgt)
      local tmptgt = transf.str.in_tmp_local_absolute_path(tgt, "temp_zip_target")
      dothis.local_absolute_path_arr.zip_to_local_absolute_path(arr, tmptgt)
      dothis.extant_path.move_to_absolute_path(tmptgt, tgt)
    end,
    zip_to_absolute_path_and_delete = function(arr, tgt)
      dothis.local_absolute_path_arr.zip_to_absolute_path(arr, tgt)
      dothis.local_absolute_path_arr.delete(arr)
    end,
    link_into_local_absolute_path = function(arr, tgt)
      dothis.arr.each(
        arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(
          dothis.local_extant_path.link_into_local_absolute_path,
          {a_use, tgt}
        )
      )
    end,
  },
  
  labelled_remote_file = {
    write_file = function(path, contents)
      local temp_file = transf.str.in_tmp_local_absolute_path(path, "labelled_remote_temp_file")
      dothis.local_extant_path.write_file(temp_file, contents)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("rclone copyto" .. transf.str.str_by_single_quoted_escaped(temp_file) .. " " .. transf.str.str_by_single_quoted_escaped(path))
      dothis.absolute_path.delete(temp_file)
    end,
    append_or_write_file = function(path, contents)
      local temp_file = transf.str.in_tmp_local_absolute_path(path, "labelled_remote_temp_file")
      dothis.local_extant_path.append_or_write_file(temp_file, contents)
      dothis.labelled_remote_file.write_file(path, transf.local_file.str_by_contents(temp_file))
    end,
  },
  labelled_remote_dir = {
    empty_dir = function(path)
      dothis.labelled_remote_dir.delete_dir(path)
      dothis.labelled_remote_nonextant_path.create_dir(path)
    end,
    delete_dir = function(path)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("rclone purge " .. transf.str.str_by_single_quoted_escaped(path))
    end,
  },
  remote_file = {
    write_file = function(path, contents)
      dothis.labelled_remote_file.write_file(path, contents)
    end,
    append_or_write_file = function(path, contents)
      dothis.labelled_remote_file.append_or_write_file(path, contents)
    end,
  },
  remote_dir =  {
    empty_dir = function(path)
      dothis.labelled_remote_dir.empty_dir(path)
    end,
    delete_dir = function(path)
      dothis.labelled_remote_dir.delete_dir(path)
    end,
  },
  local_file = {
    write_file = function(path, contents)
      local file = io.open(path, "w")
      file:write(contents)
      file:close()
    end,
    append_or_write_file = function(path, contents)
      local file = io.open(path, "a")
      file:write(contents)
      file:close()
    end,
    copy_to_local_absolute_path = function(path, tgt)
      dothis.local_extant_path.create_parent_dir(tgt)
      plfile.copy(path, tgt)
    end,
    edit_file_in_vscode_act_on_path = function(path, do_after)
      dothis.str.env_bash_eval_w_str_or_str_and_8_bit_pos_int_arg_fn("code --wait --disable-extensions " .. transf.str.str_by_single_quoted_escaped(path), function()
        if do_after then
          do_after(path)
        end
        dothis.absolute_path.delete(path)
      end)
    end,
    edit_file_in_vscode_act_on_contents = function(path, do_after)
      dothis.str.env_bash_eval_w_str_or_str_and_8_bit_pos_int_arg_fn("code --wait --disable-extensions " .. transf.str.str_by_single_quoted_escaped(path), function()
        local contents = transf.file.str_by_contents(path)
        dothis.absolute_path.delete(path)
        do_after(contents)
      end)
    end
  },
  local_dir = {
    empty_dir = function(path)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("rm -rf " .. transf.str.str_by_single_quoted_escaped(
        transf.path.path_by_ending_with_slash(path) .. "*"
      ) .. "/*")
    end,
    copy_to_local_absolute_path = function(path, tgt)
      dothis.local_extant_path.create_parent_dir(tgt)
      pldir.clonetree(path, tgt)
    end,
    link_children_absolute_path_arr_into_local_absolute_path = function(path, tgt)
      dothis.local_absolute_path_arr.link_into_local_absolute_path(
        transf.path.children_absolute_path_arr(path),
        tgt
      )
    end,
  },
  extant_path = {
    empty = function(path)
      if is.extant_path.dir(path) then
        dothis.dir.empty_dir(path)
      elseif is.extant_path.file(path) then
        dothis.file.empty_write_file(path)
      end
    end,
    delete = function(path)
      if is.extant_path.dir(path) then
        dothis.dir.delete_dir(path)
      elseif is.extant_path.file(path) then
        dothis.file.delete_file(path)
      end
    end,
    delete_if_empty_path = function(path)
      if is.extant_path.empty_path(path) then
        dothis.extant_path.delete(path)
      end
    end,
    empty_file = function(path)
      if is.extant_path.file(path) then
        dothis.file.empty_write_file(path)
      end
    end,
    delete_file = function(path)
      if is.extant_path.file(path) then
        dothis.file.delete_file(path)
      end
    end,
    delete_file_if_empty_file = function(path)
      if is.extant_path.file(path) then
        dothis.file.delete_file_if_empty_file(path)
      end
    end,
    delete_dir = function(path)
      if is.extant_path.dir(path) then
        dothis.dir.delete_dir(path)
      end
    end,
    delete_dir_if_empty_dir = function(path)
      if is.extant_path.dir(path) then
        dothis.dir.delete_dir_if_empty_dir(path)
      end
    end,
    empty_dir = function(path)
      if is.extant_path.dir(path) then
        dothis.dir.empty_dir(path)
      end
    end,
    move_to_parent_path = function(path)
      dothis.extant_path.move_to_absolute_path(path, transf.path.trimmed_noweirdwhitespace_line_by_parent_path(path))
    end,
    move_to_downloads = function(path)
      dothis.extant_path.move_to_absolute_path(path, env.DOWNLOADS)
    end,
    move_to_parent_path_with_extension_if_any = function(path)
      dothis.extant_path.move_to_absolute_path(path, transf.path.path_by_parent_path_with_extension_if_any(path))
    end,
    copy_to_absolute_path = function(path, tgt)
      dothis.absolute_path.create_parent_dir(tgt)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("rclone copyto " .. transf.str.str_by_single_quoted_escaped(path) .. " " .. transf.str.str_by_single_quoted_escaped(tgt))
    end,
    copy_into_absolute_path = function(path, tgt)
      local finaltgt = transf.path.path_by_ending_with_slash(tgt) .. transf.path.leaflike_by_leaf(path)
      dothis.extant_path.copy_to_absolute_path(path, finaltgt)
    end,
    copy_descendant_file_arr_into_absolute_path = function(path, tgt)
      dothis.extant_path_arr.copy_into_absolute_path(
        transf.extant_path.file_arr_by_descendants(path),
        tgt
      )
    end,
    move_to_absolute_path = function(path, tgt)
      dothis.absolute_path.create_parent_dir(tgt)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("rclone moveto " .. transf.str.str_by_single_quoted_escaped(path) .. " " .. transf.str.str_by_single_quoted_escaped(tgt))
    end,
    move_into_absolute_path = function(path, tgt)
      local finaltgt = transf.path.path_by_ending_with_slash(tgt) .. transf.path.leaflike_by_leaf(path)
      dothis.extant_path.move_to_absolute_path(path, finaltgt)
    end,
    move_descendant_file_arr_into_absolute_path = function(path, tgt)
      dothis.extant_path_arr.move_into_absolute_path(
        transf.extant_path.file_arr_by_descendants(path),
        tgt
      )
    end,
    zip_to_absolute_path = function(path, tgt)
      if is.path.remote_path(path) then
        dothis.remote_extant_path.zip_to_absolute_path(path, tgt)
      else
        dothis.local_extant_path.zip_to_absolute_path(path, tgt)
      end
    end,
    zip_to_absolute_path_and_delete = function(path, tgt)
      dothis.extant_path.zip_to_absolute_path(path, tgt)
      dothis.extant_path.delete(path)
    end,
    zip_into_absolute_path = function(path, tgt)
      local finaltgt = transf.path.path_by_ending_with_slash(tgt) .. transf.path.leaflike_by_leaf(path)
      dothis.extant_path.zip_to_absolute_path(path, finaltgt)
    end,
    zip_descendant_file_arr_to_absolute_path = function(path, tgt)
      dothis.extant_path_arr.zip_to_absolute_path(
        transf.extant_path.file_arr_by_descendants(path),
        tgt
      )
    end,
    create_stream = function(path, flag_profile_name)

    end,
  },
  extant_path_arr = {
    copy_into_absolute_path = function(arr, tgt)
      dothis.arr.each(
        arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(dothis.extant_path.copy_into_absolute_path, {a_use, tgt})
      )
    end,
    move_into_absolute_path = function(arr, tgt)
      dothis.arr.each(
        arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(dothis.extant_path.move_into_absolute_path, {a_use, tgt})
      )
    end,
    zip_to_absolute_path = function(arr, tgt)
      if is.path_arr.remote_path_arr(arr) then
          dothis.remote_extant_path_arr.zip_to_absolute_path(arr, tgt)
      elseif is.path_arr.local_path_arr(arr) then
          dothis.local_extant_path_arr.zip_to_absolute_path(arr, tgt)
      else
          error("Cannot currently zip mixed local & remote paths")
      end
    end,      
  },
  file = {
    do_in_path = function(path, cmd, do_after)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("cd " .. transf.str.str_by_single_quoted_escaped(transf.path.trimmed_noweirdwhitespace_line_by_parent_path(path)) .. " && " .. cmd, do_after)
    end,
    write_file = function(path, contents)
      dothis[
        transf.path.local_o_remote_str(path) .. "_extant_path"
      ].write_file(path, contents)
    end,
    append_or_write_file = function(path, contents)
      dothis[
        transf.path.local_o_remote_str(path) .. "_extant_path"
      ].append_or_write_file(path, contents)
    end,
    write_file_if_file = function(path, contents)
      dothis.file.write_file(path, contents) -- if the file already exists, replacing is the same as writing
    end,
    empty_write_file = function(path)
      dothis.file.write_file(path, "")
    end,
    delete_file = function(path)
      dothis[
        transf.path.local_o_remote_str(path) .. "_extant_path"
      ].delete_file(path)
    end,
    delete_file_if_empty_file = function(path)
      if is.file.empty_file(path) then
        dothis.file.delete_file(path)
      end
    end,

  },
  audio_file = {
    play = function(path, do_after)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("play " .. transf.str.str_by_single_quoted_escaped(path), do_after)
    end
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
    add_as_otp = function(path, name)
      dothis.otp_url.add_otp_pass_item(
        transf.local_image_file.qr_data(path),
        name
      )
    end,
  },
  local_zip_file = {
    unzip_to_absolute_path = function(path, tgt)
      dothis.absolute_path.create_parent_dir(tgt)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("unzip " .. transf.str.str_by_single_quoted_escaped(path) .. " -d " .. transf.str.str_by_single_quoted_escaped(tgt))
    end,
    unzip_into_absolute_path = function(path, tgt)
      local finaltgt = transf.path.path_by_ending_with_slash(tgt) .. transf.path.leaflike_by_filename(path)
      dothis.local_zip_file.unzip_to_absolute_path(path, finaltgt)
    end,
    
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
  plaintext_file = {
    append_lines = function(path, lines)
      local contents = transf.plaintext_file.one_final_newline(path)
      dothis.absolute_path.write_file_if_file(path, contents .. get.str_or_number_arr.str_by_joined(lines, "\n"))
    end,
    append_line = function(path, line)
      dothis.plaintext_file.append_lines(path, {line})
    end,
    append_line_and_commit = function(path, line)
      dothis.plaintext_file.append_line(path, line)
      dothis.in_git_dir.commit_self(path, "Added line " .. line .. " to " .. get.absolute_path.relative_path_from(path, transf.in_git_dir.git_root_dir(path)))
    end,
    append_line_and_commit_by_prompted = function(path)
      dothis.plaintext_file.append_line_and_commit(
        path,
        get.str.str_by_prompted_once_from_default(
          "",
          "Enter line to add to " .. path
        )
      )
    end,
    write_lines = function(path, lines)
      dothis.absolute_path.write_file_if_file(path, get.str_or_number_arr.str_by_joined(lines, "\n"))
    end,
    set_line = function(path, line, line_number)
      local lines = transf.plaintext_file.str_arr_by_lines(path)
      lines[line_number] = line
      dothis.plaintext_file.write_lines(path, lines)
    end,
    pop_line = function(path)
      local lines = transf.plaintext_file.str_arr_by_lines(path)
      local line = dothis.arr.remove_by_index(lines, #lines)
      dothis.plaintext_file.write_lines(path, lines)
      return line
    end,
    remove_line_w_pos_int = function(path, line_number)
      local lines = transf.plaintext_file.str_arr_by_lines(path)
      dothis.arr.remove_by_index(lines, line_number)
      dothis.plaintext_file.write_lines(path, lines)
    end,
    remove_line_w_fn = function(path, cond)
      local lines = transf.plaintext_file.str_arr_by_lines(path)
      local index = get.arr.pos_int_or_nil_by_first_match_w_fn(lines, cond)
      dothis.plaintext_file.remove_line_w_pos_int(path, index)
    end,
    remove_line_w_str = function(path, cond)
      local lines = transf.plaintext_file.str_arr_by_lines(path)
      local index = get.arr.pos_int_or_nil_by_first_match_w_t(lines, cond)
      dothis.plaintext_file.remove_line_w_pos_int(path, index)
    end,
    find_remove_nocomment_noindent_line = function(path, cond)
      local lines = transf.plaintext_file.str_arr_by_lines(path)
      local index = get.arr.pos_int_or_nil_by_first_match_w_fn(lines, function(line)
        local nocomment_noindent = transf.line.nocomment_noindent(line)
        return findsingle(nocomment_noindent, cond)
      end)
      dothis.plaintext_file.remove_line_w_pos_int(path, index)
    end,

  },
  plaintext_table_file = {
    append_arr_field_arr = function(path, arr_field_arr)
      local lines = get.arr.arr_by_mapped_w_t_arg_t_ret_fn(arr_field_arr, function (arr)
        return get.str_or_number_arr.str_by_joined(arr, transf.plaintext_table_file.field_separator())
      end)
      dothis.plaintext_file.append_lines(path, lines)
    end,

  },
  plaintext_url_or_local_path_file = {
    open_all = function(path, browser)
      dothis.arr.each(
        transf.plaintext_file.nocomment_noindent_content_lines(path),
        get.fn.arbitrary_args_bound_or_ignored_fn(dothis.url_or_local_path.open_browser, {a_use, browser})
      )
    end,
  },
  email_file ={
    download_attachment = function(path, name, do_after)
      local cache_path = env.XDG_CACHE_HOME .. '/hs/email_attachments'
      local att_path = cache_path .. '/' .. name
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped(
        'cd ' .. transf.single_quoted_escaped(cache_path) .. ' && mshow -x'
        .. transf.str.str_by_single_quoted_escaped(path) .. transf.str.str_by_single_quoted_escaped(name),
        function()
          do_after(att_path)
        end
      )
    end,
    choose_attachment_and_download = function(path, fn)
      dothis.arr.choose_item(
        transf.email_file.attachments(path),
        function(att)
          dothis.email_file.download_attachment(path, att, fn)
        end
      )
    end,
    send = function(path, do_after)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped(
        "msmtp -t <" .. transf.str.str_by_single_quoted_escaped(path),
        function(res)
          if not res then
            dothis.absolute_path.write_file(env.FAILED_EMAILS .. "/" .. os.date("%Y-%m-%dT%H:%M:%S"), transf.file.str_by_contents(path))
            dothis.absolute_path.delete(path)
          else
            dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped(
              "cat" ..
              transf.str.str_by_single_quoted_escaped(path) .. "| msed" ..
              transf.str.str_by_single_quoted_escaped("/Date/a/"..os.date(tblmap.date_format_name.date_format.email, os.time())) ..
              "| msed".. transf.str.str_by_single_quoted_escaped("/Status/a/S/") ..
              "| mdeliver -c" .. transf.str.str_by_single_quoted_escaped(env.MBSYNC_ARCHIVE),
              function()
                dothis.absolute_path.delete(path)
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
        dothis.email_file.send(path, do_after)
      end)
    end,
    reply = function(path, specifier, do_after)
      specifier = transf.two_tables.table_by_take_new(transf.email_file.reply_email_specifier(path), specifier)
      dothis.email_specifier.send(specifier, do_after)
    end,
    edit_then_reply = function(path, do_after)
      dothis.email_specifier.edit_then_send(transf.email_file.reply_email_specifier(path), do_after)
    end,
    forward = function(path, specifier, do_after)
      specifier = transf.two_tables.table_by_take_new(transf.email_file.forward_email_specifier(path), specifier)
      dothis.email_specifier.send(specifier, do_after)
    end,
    edit_then_forward = function(path, do_after)
      dothis.email_specifier.edit_then_send(transf.email_file.forward_email_specifier(path), do_after)
    end,
    move = function(source, target)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped(
        "mdeliver" .. transf.str.str_by_single_quoted_escaped(target) ..
        "<" .. transf.str.str_by_single_quoted_escaped(source),
        function()
          dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped(
            "minc" .. transf.str.str_by_single_quoted_escaped(target), -- incorporate the message (/cur -> /new, rename in accordance with the mblaze rules and maildir spec)
            function ()
              dothis.str.env_bash_eval_async(
                "rm" .. transf.str.str_by_single_quoted_escaped(source)
              )
            end
          )
        end
      )
        
    end,
      
    
  },
  dir = {
    pull_all_descendants = function(path)
      act.in_git_dir_arr.pull_all(
        transf.extant_path.git_root_dir_arr_by_descendants(path)
      )
    end,
    do_in_path = function(path, cmd, do_after)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped("cd " .. transf.str.str_by_single_quoted_escaped(path) .. " && " .. cmd, do_after or function() end)
    end,
    delete_child_with_leaf_ending = function(path, ending)
      dothis.absolute_path.delete(
        get.dir.extant_path_by_child_having_leaf_ending(path, ending)
      )
    end,
    empty_dir = function(path)
      dothis[
        transf.path.local_o_remote_str(path) .. "_extant_path"
      ].empty_dir(path)
    end,
    delete_dir = function(path)
      dothis[
        transf.path.local_o_remote_str(path) .. "_extant_path"
      ].delete_dir(path)
    end,
    delete_dir_if_empty_dir = function(path)
      if is.dir.empty_dir(path) then
        dothis.dir.delete_dir(path)
      end
    end,
    copy_children_absolute_path_arr_into_absolute_path = function(path, tgt)
      dothis.extant_path_arr.copy_into_absolute_path(
        transf.dir.absolute_path_arr_by_children(path),
        tgt
      )
    end,
    move_children_absolute_path_arr_into_absolute_path = function(path, tgt)
      dothis.extant_path_arr.move_into_absolute_path(
        transf.dir.absolute_path_arr_by_children(path),
        tgt
      )
    end,
    zip_children_absolute_path_arr_to_absolute_path = function(path, tgt)
      dothis.extant_path_arr.zip_to_absolute_path(
        transf.dir.absolute_path_arr_by_children(path),
        tgt
      )
    end,
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
    choose_leaf_or_dotdot_w_extant_path_arg_fn = function(path, fn)
      dothis.arr.choose_item(
        transf.dir.leaf_or_dotdot_arr(path),
        function(leaf_or_dotdot)
          local local_resolvable_path = transf.path.path_by_ending_with_slash(path) .. leaf_or_dotdot
          local local_extant_path = transf.local_resolvable_path.local_absolute_path(local_resolvable_path)
          fn(local_extant_path)
        end
      )
    end,
    choose_leaf_or_dotdot_until_file_w_file_arg_fn = function(path, fn)
      dothis.dir.choose_leaf_or_dotdot_until_file_w_file_arg_fn(path, function(local_extant_path)
        if is.local_extant_path.local_file(local_extant_path) then
          fn(local_extant_path)
        else
          dothis.dir.choose_leaf_or_dotdot_until_file_w_file_arg_fn(local_extant_path, fn)
        end
      end)
    end
    
  },
  maildir_dir = {
    
  },
  email_specifier = {
    send = function(specifier, do_after)
      dothis.email_file.send(transf.email_specifier.draft_email_file(specifier), do_after)
    end,
    edit_then_send = function(specifier, do_after)
      dothis.email_file.edit_then_send(transf.email_specifier.draft_email_file(specifier), do_after)
    end,
  },
  email = {
    edit_then_send = function(address, do_after)
      dothis.email_specifier.edit_then_send({to = address}, do_after)
    end,
  },
  empty_dir = {

  },
  sqlite_file = {
    query_w_csv_str_arg_fn = function(sqlite_file, query, fn)
      dothis.str.env_bash_eval_w_str_arg_fn_str_arg_fn_by_stripped(
        "sqlite3" ..
        transf.str.str_by_single_quoted_escaped(sqlite_file) ..
        "-csv" ..
        transf.str.str_by_single_quoted_escaped(query)
      , fn, error)
    end,
    query_w_table_arg_fn = function(sqlite_file, query, fn)
      dothis.str.env_bash_eval_w_table_arg_fn_str_arg_fn(
        "sqlite3" ..
        transf.str.str_by_single_quoted_escaped(sqlite_file) ..
        "-json" ..
        transf.str.str_by_single_quoted_escaped(query),
        fn, error)
    end,
  },
  newsboat_urls_file = {
    append_newsboat_url_specifier = function(path, specifier)
      dothis.plaintext_file.append_line(path, transf.newsboat_url_specifier.newsboat_url_line(specifier))
    end,
  },
  youtube_channel_id = {
    add_to_newsboat_urls_file = function(channel_id, category)
      dothis.newsboat_urls_file.append_newsboat_url_specifier(
        env.NEWSBOAT_URLS,
        {
          url = transf.youtube_channel_id.feed_url(channel_id),
          title = transf.youtube_channel_id.channel_title(channel_id),
          category = category,
        }
      )
    end,
  },
  youtube_channel_url = {
    add_to_newsboat_urls_file = function(channel_url, category)
      dothis.youtube_channel_id.add_to_newsboat_urls_file(
        transf.youtube_channel_url.channel_id(channel_url),
        category
      )
    end,
  },
  sgml_url = {
    add_to_newsboat_urls_file = function(url, category)
      dothis.newsboat_urls_file.append_newsboat_url_specifier(
        env.NEWSBOAT_URLS,
        {
          url = url,
          title = transf.sgml_url.str_or_nil_by_title(url),
          category = category,
        }
      )
    end,
  },
  audiodevice = {
    set_default = function(device, type)
      device["setDefault" .. transf.str.str_by_first_eutf8_upper(type) .. "Device"](device)
    end,
    ensure_sound_will_be_played = function(device)
      device:setOutputMuted(false)
      device:setOutputVolume(100)
    end,
  },
  audiodevice_specifier = {
    set_default = function(specifier)
      dothis.audiodevice.set_default(
        transf.audiodevice_specifier.audiodevice(specifier),
        transf.audiodevice_specifier.subtype(specifier)
      )
    end,
  },
  audiodevice_specifier_arr = {
    choose_item_and_set_default = function(arr)
      dothis.arr.choose_item(
        arr,
        dothis.audiodevice_specifier.set_default
      )
    end,
  },
  ics_file = {
    add_events_from_file = function(path, calendar)
      dothis.str.env_bash_eval("khal import --include-calendar " .. calendar .. " " .. transf.str.str_by_single_quoted_escaped(path))
    end,
  },
  git_root_dir = {
    run_hook =  function(path, hook)
      local hook_path = get.git_root_dir.hook_path(path, hook)
      dothis.str.env_bash_eval(hook_path)
    end,
    add_hook = function(path, hook_path, name)
      name = name or transf.path.leaflike_by_filename(hook_path)
      dothis.extant_path.copy_to_absolute_path(hook_path, get.git_root_dir.hook_path(path, name))
      dothis.local_extant_path.make_executable(get.git_root_dir.hook_path(path, name))
    end,
    copy_hook = function(path, type, name)
      type = type or "default"
      local source_hook = env.GITCONFIGHOOKS .. "/" .. type .. "/" .. name
      dothis.local_extant_path.make_executable(source_hook)
      dothis.extant_path.copy_to_absolute_path(source_hook, get.git_root_dir.hook_path(path, name))
    end,
    link_hook = function(path, type, name)
      type = type or "default"
      local source_hook = env.GITCONFIGHOOKS .. "/" .. type .. "/" .. name
      dothis.local_extant_path.make_executable(source_hook)
      dothis.local_extant_path.link_to_nosudo_nonextant_path(source_hook, get.git_root_dir.hook_path(path, name))
    end,
    link_all_hooks = function(path, type)
      local source_hooks = transf.path.join(env.GITCONFIGHOOKS, type)
      for _, hook in transf.arr.pos_int_vt_stateless_iter(get.dir.files(source_hooks)) do
        dothis.git_root_dir.link_hook(path, type, hook)
      end
    end,
    copy_all_hooks = function(path, type)
      local source_hooks = transf.path.join(env.GITCONFIGHOOKS, type)
      for _, hook in transf.arr.pos_int_vt_stateless_iter(get.dir.files(source_hooks)) do
        dothis.git_root_dir.copy_hook(path, type, hook)
      end
    end,

  },
  git_root_dir_arr = {
    
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
    commit_self = function(path, message, do_after)
      dothis.local_extant_path.do_in_path(
        path, 
        "git commit -m" .. transf.str.str_by_single_quoted_escaped(message or ("Programmatic commit of " .. path .. " at " .. os.date(tblmap.date_format_name.date_format["rfc3339-datetime"]))),
        do_after
      )
    end,
    -- will also add untracked files
    add_all = function(path, do_after)
      dothis.local_extant_path.do_in_path(path, "git add -A", do_after)
    end,
    add_all_root = function(path, do_after)
      dothis.in_git_dir.add_all(transf.in_git_dir.git_root_dir(path), do_after)
    end,
    commit_staged = function(path, message, do_after)
      dothis.local_extant_path.do_in_path(
        path, 
        "git commit -m" .. transf.str.str_by_single_quoted_escaped(message or ("Programmatic commit of staged files at " .. os.date(tblmap.date_format_name.date_format["rfc3339-datetime"]))),
        do_after
      )
    end,
    commit_all = function(path, message, do_after)
      dothis.in_git_dir.add_all(path, function()
        dothis.in_git_dir.commit_staged(path, message, do_after)
      end)
    end,
    commit_all_root = function(path, message, do_after)
      dothis.in_git_dir.add_all_root(path, function()
        dothis.in_git_dir.commit_staged(transf.in_git_dir.git_root_dir(path), message, do_after)
      end)
    end,
    commit_all_root_no_untracked = function(path, message, do_after)
      dothis.local_extant_path.do_in_path(
        transf.in_git_dir.git_root_dir(path), 
        "git commit -am" .. transf.str.str_by_single_quoted_escaped(message or ("Programmatic commit of all tracked files at " .. os.date(tblmap.date_format_name.date_format["rfc3339-datetime"]))),
        do_after
      )
    end
  },
  date = {
    create_log_entry = function(date, path, contents)
      error("todo")
    end,
    choose_format = function(dt, fn)
      dothis.table.choose_w_vt_fn(
        tblmap.date_format_name.date_format,
        function(date_format)
          fn(get.date.str_w_date_format_indicator(dt, date_format))
        end
      )
    end
  },
  logging_dir = {
    log_nonabsolute_path_key_timestamp_ms_key_assoc_value_assoc_by_ymd = function(path, assoc)
      local abs_path_assoc = get.nonabsolute_path_key_assoc.absolute_path_key_assoc(
        assoc,
        path,
        ".json"
      )
      for path, assoc in abs_path_assoc do 
        dothis.json_file.merge_w_table(path, assoc)
      end
    end,
    log_timestamp_ms_key_assoc_value_assoc = function(path, timestamp_ms_key_assoc_value_assoc)
      dothis.logging_dir.log_nonabsolute_path_key_timestamp_ms_key_assoc_value_assoc_by_ymd(
        path,
        transf.timestamp_ms_key_assoc_value_assoc.nonabsolute_path_key_timestamp_ms_key_assoc_value_assoc_by_ymd(timestamp_ms_key_assoc_value_assoc)
      )
    end,
  },
  json_file = {
    merge_w_table = function(path, table)
      local tblcnt = get.json_file.table_or_nil(path)
      local newcnt = transf.two_table_or_nils.table_by_take_new(tblcnt, table)
      dothis.local_file.write_file(
        path,
        transf.not_userdata_or_function.json_str(newcnt)
      )
    end
  },
  entry_logging_dir = {
    log_str = function(path, str)
      dothis.logging_dir.log_timestamp_ms_key_assoc_value_assoc(path, {
        [os.time() * 1000] = {
          entry = str
        }
      })
    end,
  },
  timestamp_s = {
    do_at = function(timestamp, fn)
      local last_midnight = transf["nil"].timestamp_s_last_midnight()
      local seconds_to_wait = timestamp - last_midnight
      if seconds_to_wait < 0 then
        error("Timestamp is in the past by " .. -seconds_to_wait .. " seconds")
      elseif seconds_to_wait == 0 then
        fn()
        return
      end
      local is_more_than_24_hours = seconds_to_wait > 86400

      if is_more_than_24_hours then
        error("Timestamp is more than 24 hours in the future, which lua itself cannot handle, and I have not yet implemented a workaround for this")
      end
      hs.timer.doAt(seconds_to_wait, fn)
    end
  },
  str_arr = {
    join_and_paste = function(arr, sep)
      dothis.str.paste_le(transf.str.join(arr, sep))
    end,
    fill_with = function(arr)
      dothis.str_arr.join_and_paste(arr, "\t")
    end
  },
  url_arr = {
    open_all = function(url_arr, browser)
      for _, url in transf.arr.pos_int_vt_stateless_iter(url_arr) do
        dothis.url_or_local_path.open_browser(url, browser)
      end
    end,
    create_as_url_files = function(url_arr, path)
      local abs_path_assoc = get.url_arr.absolute_path_key_assoc_of_url_files(url_arr, path)
      dothis.absolute_path_str_value_assoc.write(abs_path_assoc)
    end,
    create_as_session = function(url_arr, root)
      local path = transf.local_absolute_path.local_absolute_path_by_prompted_multiple_from_default(root)
      path = get.str.str_by_with_suffix(path, ".session")
      dothis.absolute_path.write_file(
        path,
        transf.url_arr.session_str(url_arr)
      )
    end,
    
  },
  sgml_url_arr = {
   
  },
  absolute_path_key_assoc = {

  },
  dynamic_absolute_path_key_assoc = {
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
  absolute_path_str_value_assoc = {
    write = function(absolute_path_str_value_assoc)
      for absolute_path, contents in transf.table.kt_vt_stateless_iter(absolute_path_str_value_assoc) do
        dothis.absolute_path.write_file(absolute_path, contents)
      end
    end,
  },
  mac_application_name = {
    execute_full_action_path = function(application_name, full_action_path)
      dothis.running_application.execute_full_action_path(
        transf.mac_application_name.running_application(application_name),
        full_action_path
      )
    end,
    reload = function(application_name)
      dothis.mac_application_name.execute_full_action_path(
        application_name,
        tblmap.mac_application_name.reload_full_action_path[application_name]
      )
    end,
    open_recent = function(application_name, item)
      dothis.mac_application_name.execute_full_action_path(
        application_name,
        transf.arr_and_any.arr(
          tblmap.mac_application_name.recent_full_action_path[application_name],
          item
        )
      )
    end,
    focus_main_window = function(application_name)
      dothis.running_application.focus_main_window(
        transf.mac_application_name.running_application(application_name)
      )
    end,
    activate = function(application_name)
      dothis.running_application.activate(
        transf.mac_application_name.running_application(application_name)
      )
    end,
    --- if you need `fn` to take args, bind them beforehand
    do_with_activated = function(application_name, fn)
      local app = transf.mac_application_name.running_application(application_name)
      local prev_app = hs.application.frontmostApplication()
      dothis.mac_application_name.activate(application_name)
      local retval = {fn()}
      dothis.running_application.activate(prev_app)
      return transf.arr.n_anys(retval)
    end,
      
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
    set_hs_geometry_size_like = function(window, hs_geometry_size_like)
      window:setSize(hs_geometry_size_like)
    end,
    set_hs_geometry_rect_like = function(window, hs_geometry_rect_like)
      window:setFrame(hs_geometry_rect_like)
    end,
    set_hs_geometry_point_like_tl = function(window, hs_geometry_point_like_tl)
      window:setTopLeft(hs_geometry_point_like_tl)
    end,
    set_relevant_grid = function(window, grid)
      hs.grid.setGrid(grid, transf.window.screen(window))
    end,

    set_grid_cell = function(window, grid_cell)
      hs.grid.set(window, grid_cell, transf.window.screen(window))
    end,
    do_with_window_as_main = function(window, do_with_window_as_main)
      local application = transf.window.running_application(window)
      local main_window = transf.running_application.main_window(application)
      dothis.window.make_main(window)
      do_with_window_as_main(application, window)
      dothis.window.make_main(main_window)
    end,
  },
  jxa_tab_specifier = {
    make_main = function(jxa_tab_specifier)
      get.str.evaled_js_osa( ("Application('%s').windows()[%d].activeTabIndex = %d"):format(
        jxa_tab_specifier.application_name,
        jxa_tab_specifier.window_index,
        jxa_tab_specifier.tab_index
      ))
    end,
    close = function(jxa_tab_specifier)
      get.str.evaled_js_osa( ("Application('%s').windows()[%d].tabs()[%d].close()"):format(
        jxa_tab_specifier.application_name,
        jxa_tab_specifier.window_index,
        jxa_tab_specifier.tab_index
      ))
    end,
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
        env.GUI_EDITOR,
        get.fn.first_n_args_bound_fn(dothis.intra_file_location_spec.go_to, specifier)
      )
    end
  },
  path_with_twod_locator = {
    open_go_to = function(path_with_twod_locator)
      dothis.intra_file_location_spec.open_go_to(
        transf.path_with_twod_locator.intra_file_location_spec(path_with_twod_locator)
      )
    end
  },
  url_components = {
    open_browser = function(url_components, browser, do_after)
      dothis.url_or_local_path.open_browser(
        transf.url_components.url(url_components),
        browser,
        do_after
      )
    end,
  },
  iban = {
    fill_bank_form = function(iban)
      dothis.str_arr.fill_with(transf.iban.three_str_arr_by_iban_bic_bank_name(iban))
    end
  },
  running_application = {
    execute_full_action_path = function(running_application, full_action_path)
      running_application:selectMenuItem(full_action_path)
    end,
    focus_main_window = function(running_application)
      transf.running_application.main_window(running_application):focus()
    end,
    activate = function(running_application)
      running_application:activate()
    end,
  },
  menu_item_table = {
    execute = function(menu_item_table)
      dothis.running_application.execute_full_action_path(
        transf.menu_item_table.running_application(menu_item_table),
        transf.menu_item_table.full_action_path(menu_item_table)
      )
    end,
  },
  env_str = {
    write_and_check = function(str, path)
      dothis.absolute_path.write_file(path, str)
      local errors = transf.shellscript_file.gcc_str_errors(path)
      if errors then
        error("env file " .. path .. " has errors:\n" .. errors)
      end
    end,
    write_env_and_check = function(str)
      dothis.env_str.write_and_check(
        str,
        env.ENVFILE
      )
    end,
  },
  citable_object_id = {
    save_mcitations_csl_file = function(citable_object_id, indication)
      local csl_table = transf[indication].csl_table_by_online(citable_object_id)
      dothis.absolute_path.write_file(
        env.MCITATIONS .. "/" .. transf.csl_table.citable_filename(csl_table) .. ".json",
        transf.not_userdata_or_function.json_str(csl_table)
      )
    end,
  },
  citations_file = {
    write_bib = function(citations_file, path)
      dothis.absolute_path.write_file(
        path,
        transf.citations_file.bib_str(citations_file)
      )
    end,
    add_indicated_citable_object_id = function(citations_file, indicated_citable_object_id)
      dothis.plaintext_file.append_line(
        citations_file,
        transf.indicated_citable_object_id.citations_file_line(indicated_citable_object_id)
      )
    end,
    remove_indicated_citable_object_id = function(citations_file, indicated_citable_object_id)
      dothis.plaintext_file.find_remove_nocomment_noindent_line(
        citations_file,
        {_exactly = indicated_citable_object_id}
      )
    end,
  },
  project_dir = {
    build = function(project_dir, project_type, do_after)
      dothis.dir.do_in_path(
        project_dir,
        tblmap.project_type.str_by_build_command[project_type],
        do_after
      )
    end,
    pull_subtype_project_materials = function(project_dir, type, subtype)
      dothis.dir.copy_children_absolute_path_arr_into_absolute_path( 
        get.project_dir.global_subtype_project_material_path(project_dir, type, subtype),
        get.project_dir.local_subtype_project_material_path(project_dir, type, subtype)
      )
    end,
    push_subtype_project_materials = function(project_dir, type, subtype)
      dothis.dir.copy_children_absolute_path_arr_into_absolute_path( 
        get.project_dir.local_subtype_project_material_path(project_dir, type, subtype),
        get.project_dir.global_subtype_project_material_path(project_dir, type, subtype)
      )
    end,
    pull_universal_project_materials = function(project_dir, type)
      dothis.dir.copy_children_absolute_path_arr_into_absolute_path( 
        get.project_dir.global_universal_project_material_path(project_dir, type),
        get.project_dir.local_universal_project_material_path(project_dir, type)
      )
    end,
    push_universal_project_materials = function(project_dir, type)
      dothis.dir.copy_children_absolute_path_arr_into_absolute_path( 
        get.project_dir.local_universal_project_material_path(project_dir, type),
        get.project_dir.global_universal_project_material_path(project_dir, type)
      )
    end,
    pull_project_materials = function(project_dir, type, subtype)
      dothis.project_dir.pull_universal_project_materials(project_dir, type)
      dothis.project_dir.pull_subtype_project_materials(project_dir, type, subtype)
    end,
    push_project_materials = function(project_dir, type, subtype)
      dothis.project_dir.push_universal_project_materials(project_dir, type)
      dothis.project_dir.push_subtype_project_materials(project_dir, type, subtype)
    end,
  },
  omegat_project_dir = {
    pull_project_materials = function(omegat_project_dir)
      for _, type in transf.arr.pos_int_vt_stateless_iter(tblmap.project_type.project_materials_list["omegat"]) do
        dothis.project_dir.pull_project_materials(
          omegat_project_dir,
          type,
          transf.omegat_project_dir.client_name(omegat_project_dir)
        )
      end
    end,
    push_project_materials = function(omegat_project_dir)
      dothis.project_dir.push_project_materials(
        omegat_project_dir,
        "glossary",
        transf.omegat_project_dir.client_name(omegat_project_dir)
      )
      dothis.extant_path.copy_into_absolute_path(
        transf.omegat_project_dir.local_resultant_tm(omegat_project_dir),
        get.project_dir.global_subtype_project_material_path(
          omegat_project_dir,
          "tm",
          transf.omegat_project_dir.client_name(omegat_project_dir)
        )
      )
    end,
    create_and_open_new_source_odt = function(omegat_project_dir, name) -- while we support any source file, if we manually create a file, it should be an odt
      dothis.absolute_path.write_file_if_nonextant_path(
        transf.omegat_project_dir.source_dir(omegat_project_dir) .. "/" .. name .. ".odt"
      )
      dothis.local_path.open(
        transf.omegat_project_dir.source_dir(omegat_project_dir) .. "/" .. name .. ".odt"
      )
    end,
    open_project = function(omegat_project_dir)
      local running_application = transf.mac_application_name.ensure_running_application("OmegaT")
      dothis.mac_application_name.open_recent("OmegaT", omegat_project_dir)
      dothis.running_application.focus_main_window(running_application)
    end,
    generate_target_txts = function(dir, do_after)
      dothis.arr.each(
        transf.omegat_project_dir.target_files(dir),
        function(file)
          transf.str.str_or_nil_by_evaled_env_bash_stripped("soffice --headless --convert-to txt:Text --outdir"..
          transf.str.str_by_single_quoted_escaped(
            transf.omegat_project_dir.target_txt_dir(dir)
          ) ..
          transf.str.str_by_single_quoted_escaped(file))
        end
      )
      error("TODO: Watch dir, count files every second or so until they are all there, then do_after. Perhaps refactor this into a general function")
    end,
    generate_rechnung_md = function(omegat_project_dir)
      dothis.absolute_path.write_file(
        transf.omegat_project_dir.rechnung_md_path(omegat_project_dir),
        transf.omegat_project_dir.raw_rechnung(omegat_project_dir)
      )
    end,
    generate_rechnung_pdf = function(omegat_project_dir, do_after)
      dothis.md_file.to_file_in_same_dir(
        transf.omegat_project_dir.rechnung_md_path(omegat_project_dir),
        "pdf",
        transf.omegat_project_dir.rechnung_pdf_path(omegat_project_dir),
        do_after
      )
    end,
    generate_rechnung = function(path, do_after)
      dothis.omegat_project_dir.generate_target_txts(path, function()
        dothis.omegat_project_dir.generate_rechnung_md(path)
        dothis.omegat_project_dir.generate_rechnung_pdf(path, do_after)
      end)
    end,
    finalize_rechnung = function(path)

    end,
    finalize_project = function(path)
      dothis.omegat_project_dir.push_project_materials(path)
      dothis.omegat_project_dir.file_rechnung(path)
      dothis.omegat_project_dir.file_source_target(path)
    end,

      
  },
  latex_project_dir = {      
    open_pdf = function(latex_project_dir)
      dothis.local_path.open(
        transf.latex_project_dir.main_pdf_file(latex_project_dir)
      )
    end,
    build_and_open_pdf = function(latex_project_dir)
      dothis.latex_project_dir.build(
        latex_project_dir,
        get.fn.first_n_args_bound_fn(dothis.latex_project_dir.open_pdf, latex_project_dir)
      )
    end,
    write_bib = function(latex_project_dir)
      dothis.citations_file.write_bib(
        transf.latex_project_dir.citations_file(latex_project_dir),
        transf.latex_project_dir.main_bib_file(latex_project_dir)
      )
    end,
    add_indicated_citable_object_id_raw = function(latex_project_dir, indicated_citable_object_id)
      dothis.citations_file.add_indicated_citable_object_id(
        transf.latex_project_dir.citations_file(latex_project_dir),
        indicated_citable_object_id
      )
    end,
    remove_indicated_citable_object_id_raw = function(latex_project_dir, indicated_citable_object_id)
      dothis.citations_file.remove_indicated_citable_object_id(
        transf.latex_project_dir.citations_file(latex_project_dir),
        indicated_citable_object_id
      )
    end,
    add_indicated_citable_object_id = function(latex_project_dir, indicated_citable_object_id)
      dothis.latex_project_dir.add_indicated_citable_object_id_raw(
        latex_project_dir,
        indicated_citable_object_id
      )
      dothis.latex_project_dir.write_bib(latex_project_dir)
    end,
    remove_indicated_citable_object_id = function(latex_project_dir, indicated_citable_object_id)
      dothis.latex_project_dir.remove_indicated_citable_object_id_raw(
        latex_project_dir,
        indicated_citable_object_id
      )
      dothis.latex_project_dir.write_bib(latex_project_dir)
    end,
  },
  youtube_playlist_id = {
    --- @param id str
    --- @param do_after? fun(result: str): nil
    delete = function(id, do_after)
      rest({
        api_name = "youtube",
        endpoint = "playlists",
        params = { id = id },
        request_verb = "DELETE",
      }, do_after)
    end,
    --- @param id str
    --- @param video_id str
    --- @param index? number
    --- @param do_after? fun(): nil
    add_youtube_video_id = function(id, video_id, index, do_after)
      local req = {
        api_name = "youtube",
        endpoint = "playlistItems",
        request_table = {
          snippet = {
            playlistId = id,
            position = index,
            resourceId = {
              kind = "youtube#video",
              videoId = video_id
            }
          }
        },
      }
      if index then
        req.request_table.snippet.position = index
      end
      rest(req, do_after)
    end,
    --- @param id str
    --- @param video_ids str[]
    --- @param do_after? fun(id: str): nil
    add_youtube_video_id_arr = function(id, video_ids, do_after)
      local next_vid = transf.arr.pos_int_vt_stateful_iter(video_ids)
      local add_next_vid
      add_next_vid = function ()
        local index, video_id = next_vid()
        if index then
          dothis.youtube_playlist_id.add_youtube_video_id(id, video_id, nil, add_next_vid)
        else
          if do_after then
            do_after(id)
          end
        end
      end
      add_next_vid()
    end
    

  },
  handle = {
    add_to_newsboat_urls_file = function(handle, category)
      dothis.youtube_channel_id.add_to_newsboat_urls_file(
        transf.handle.youtube_channel_id(handle),
        category
      )
    end
  },
  youtube_playlist_creation_specifier = {
    --- @param spec {title?: str, description?: str, privacyStatus?: str, youtube_video_id_arr?: str[]}
    --- @param do_after? fun(id: str): nil
    create_youtube_playlist = function(spec, do_after)
      rest({
        api_name = "youtube",
        endpoint = "playlists",
        params = { part = "snippet,status" },
        request_table = {
          snippet = {
            title = spec.title or get.str.str_by_formatted_w_n_anys("Playlist from %s", os.date("%Y-%m-%dT%H:%M:%S%Z")),
            description = spec.description or get.str.str_by_formatted_w_n_anys("Created at %s", os.date("%Y-%m-%dT%H:%M:%S%Z")),
          }
        },
      }, function(result)
        local id = result.id
        hs.timer.doAfter(3, function () -- wait for playlist to be created, seems to not happen instantly
          if spec.youtube_video_id_arr then
            dothis.youtube_playlist_id.add_youtube_video_id_arr(id, spec.youtube_video_id_arr, do_after)
          else
            if do_after then
              do_after(id)
            end
          end
        end)
      end)
    end
    
  },
  arr = {
    choose_item = function(arr, callback, target_item_chooser_item_specifier_name)
      dothis.choosing_hschooser_specifier.choose_identified_item(
        get.arr.choosing_hschooser_specifier(arr, target_item_chooser_item_specifier_name),
        callback
      )
    end,
    choose_item_truncated = function(arr, callback)
      dothis.arr.choose_item(arr, callback, "truncated_text")
    end,
    push = function(arr, item)
      arr[#arr + 1] = item
      return true
    end,
    unshift = function(arr, item)
      dothis.arr.insert_at_index(arr, 1, item)
      return true
    end,
    sort = table.sort,
    remove_by_index = table.remove,
    revove_by_first_item_w_any = function(arr, item)
      local index = get.arr.pos_int_or_nil_by_first_match_w_t(arr, item)
      if index then
        dothis.arr.remove_by_index(arr, index)
      end
    end,
    insert_at_index = table.insert,
    move_to_index_by_index = function(arr, source_index, target_index)
      local item = dothis.arr.remove_by_index(arr, source_index)
      dothis.arr.insert_at_index(arr, target_index, item)
    end,
    move_to_index_by_item = function(arr, item, index)
      local source_index = get.arr.pos_int_or_nil_by_first_match_w_t(arr, item)
      if source_index then
        dothis.arr.move_to_index_by_index(arr, source_index, index)
      end
    end,
    move_to_front_by_item = function(arr, item)
      dothis.arr.move_to_index_by_item(arr, item, 1)
    end,
    move_to_front_or_unshift = function(arr, item)
      local index = get.arr.pos_int_or_nil_by_first_match_w_t(arr, item)
      if index then
        dothis.arr.move_to_index_by_index(arr, index, 1)
      else
        dothis.arr.unshift(arr, item)
      end
    end,
    move_to_end_by_item = function(arr, item)
      dothis.arr.move_to_index_by_item(arr, item, #arr)
    end,
    move_to_end_or_push = function(arr, item)
      local index = get.arr.pos_int_or_nil_by_first_match_w_t(arr, item)
      if index then
        dothis.arr.move_to_index_by_index(arr, index, #arr)
      else
        dothis.arr.push(arr, item)
      end
    end,
    filter_in_place = function(arr, filterfn)
      local i = 1
      while i <= #arr do
        if not filterfn(arr[i]) then
          dothis.arr.remove_by_index(arr, i)
        else
          i = i + 1
        end
      end
    end,
    each = hs.fnutils.ieach,
    each_with_delay = function(arr, delay, fn, do_after)
      local next_item = transf.arr.pos_int_vt_stateful_iter(arr)
      local do_next_item
      do_next_item = function()
        local index, item = next_item()
        if index then
          fn(item)
          hs.timer.doAfter(delay, do_next_item)
        else
          if do_after then
            do_after()
          end
        end
      end
      do_next_item()
    end,
  },
  action_specifier = {
    execute = function(spec, target)
      
      if spec.getfn then
        target = spec.getfn(target)
      end

      if spec.dothis then
        spec.dothis(target)
      end

      dothis.any.choose_action(target)
    end
  },
  action_specifier_arr = {

  },
  chooser_item_specifier_arr = {

  },
  thing_name = {
    
  },
  hschooser_specifier = {
    choose = function(spec, callback)
      local hschooser = get.hschooser_specifier.partial_hschooser(spec, callback)
      hschooser:rows(spec.rows or 30)
      for k, v in transf.table.kt_vt_stateless_iter(spec.whole_chooser_style_keys) do
        hschooser[k](hschooser, v)
      end
      local choices = get.chooser_item_specifier_arr.styled_chooser_item_specifier_arr(
        spec.chooser_item_specifier_arr,
        spec.chooser_item_specifier_text_key_styledtext_attributes_specifier_assoc
      )
      hschooser:placeholderText(spec.placeholder_text)
      hschooser:choices(choices)
      hschooser:show()
      if spec.initial_selected_index then
        hschooser:selectedRow(spec.initial_selected_index)
      end
    end,
    choose_get_key = function(spec, key_name, callback)
      dothis.hschooser_specifier.choose(spec, function(result)
        callback(result[key_name])
      end)
    end,
    choose_identified_item = function(spec, key_name, tbl, callback)
      dothis.hschooser_specifier.choose_get_key(spec, key_name, function(key)
        callback(tbl[key])
      end)
    end,
  },
  choosing_hschooser_specifier = {
    choose_identified_item = function(spec, callback)
      dothis.hschooser_specifier.choose_identified_item(
        spec.hschooser_specifier,
        spec.key_name,
        spec.tbl,
        callback
      )
    end,
  },
  any = {
    choose_action_specifier = function(any, callback)
      dothis.choosing_hschooser_specifier.choose_identified_item(
        transf.any.choosing_hschooser_specifier(any),
        callback
      )
    end,
    choose_action = function(any)
      dothis.any.choose_action_specifier(
        any, 
        get.fn.arbitrary_args_bound_or_ignored_fn(dothis.action_specifier.execute, {a_use, any})
      )
    end,
  },
  mpv_ipc_socket_id = {
    set = function(id, key, ...)
      get.ipc_socket_id.response_table_or_nil(id, { command = { "set_property", key, ... } })
    end,
    cycle = function(id, key)
      get.ipc_socket_id.response_table_or_nil(id, { command = { "cycle", key } })
    end,
    cycle_inf_no = function(id, key)
      dothis.mpv_ipc_socket_id.set(
        id, 
        key,
        get.bin_specifier.str_or_bool_by_inverted(
          tblmap.bin_specifier_name.bin_specifier["inf_no"],
          get.mpv_ipc_socket_id.str(id, key)
        )
      )
    end,
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
    exec = function(id, ...)
      get.ipc_socket_id.response_table_or_nil(id, { command = { ... } })
    end,
    stop = function(id)
      dothis.mpv_ipc_socket_id.exec(id, "stop")
    end,
    set_playlist_index = function(id, index)
      dothis.mpv_ipc_socket_id.set(id, "playlist-pos", index)
    end,
    set_playlist_first = function(id)
      dothis.mpv_ipc_socket_id.set(id, "playlist-pos", 0)
    end,
    set_playlist_last = function(id)
      dothis.mpv_ipc_socket_id.set(id, "playlist-pos", transf.mpv_ipc_socket_id.playlist_length_int(id))
    end,
    set_playback_seconds = function(id, seconds)
      dothis.mpv_ipc_socket_id.set(id, "time-pos", seconds)
    end,
    set_playback_percent = function(id, percent)
      dothis.mpv_ipc_socket_id.set(id, "percent-pos", percent)
    end,
    set_playback_first = function(id)
      dothis.mpv_ipc_socket_id.set_playback_seconds(id, 0)
    end,
    set_playback_seconds_relative = function(id, seconds)
      dothis.mpv_ipc_socket_id.set_playback_seconds(
        id,
        transf.mpv_ipc_socket_id.playback_seconds_int(id) + seconds
      )
    end,
    set_chapter = function(id, chapter)
      dothis.mpv_ipc_socket_id.set(id, "chapter", chapter)
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
      dothis.mpv_ipc_socket_id.set_playlist_first(id)
      dothis.mpv_ipc_socket_id.set_playback_first(id)
    end,
  },
  stream_creation_specifier = {
    create_inner_item = function(spec)
      local ipc_socket_id = os.time() .. "-" .. math.random(1000000)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("mpv " .. transf.stream_creation_specifier.flags_str(spec) .. 
        " --msg-level=all=warn --input-ipc-server=" .. transf.ipc_socket_id.ipc_socket_path(ipc_socket_id) .. " --start=" .. spec.values.start .. " " .. transf.str_arr.single_quoted_escaped_str(spec.urls))
      return {
        ipc_socket_id = ipc_socket_id,
        state = "booting"
      }
    end,
  },
  hotkey_creation_specifier = {
    create_inner_item = function(spec)
      local hotkey = hs.hotkey.new(
        spec.modifiers or {"cmd", "shift", "alt"},
        spec.key, 
        spec.fn
      )
      hotkey:enable()
      return hotkey
    end,
  },
  watcher_creation_specifier = {
    create_inner_item = function(spec)
      local watcher = transf.watcher_creation_specifier.hswatcher_creation_fn(spec)(spec.fn)
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
  created_item_specifier = {
    recreate = function(spec)
      return dothis.creation_specifier.create(spec.creation_specifier)
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
  created_item_specifier_arr = {
    create = function(arr, creation_specifier)
      local itm = dothis.creation_specifier.create(creation_specifier)
      dothis.arr.push(arr, itm)
      return itm
    end,
    create_all = function(arr, creation_specifier_arr)
      hs.fnutils.each(creation_specifier_arr, function(creation_specifier)
        dothis.created_item_specifier_arr.create(arr, creation_specifier)
      end)
    end,
    --- shouldn't I be adding them to the arr too????
    get_or_create = function(arr, creation_specifier)
      local created_item_specifier = get.created_item_specifier_arr.created_item_specifier_w_creation_specifier(arr, creation_specifier)
      if created_item_specifier then
        return created_item_specifier
      else
        return dothis.created_item_specifier_arr.create(arr, creation_specifier)
      end
    end,
    create_or_recreate = function(arr, creation_specifier)
      local idx = get.created_item_specifier_arr.pos_int_w_creation_specifier(arr, creation_specifier)
      if idx then
        arr[idx] = dothis.created_item_specifier.recreate(arr[idx])
        return arr[idx]
      else
        return dothis.created_item_specifier_arr.create(arr, creation_specifier)
      end
    end,
    create_or_recreate_all = function (arr, creation_specifier_arr)
      dothis.arr.each(creation_specifier_arr, function(creation_specifier)
        dothis.created_item_specifier_arr.create_or_recreate(arr, creation_specifier)
      end)
    end
  },
  hotkey_created_item_specifier_arr = {
    create_or_recreate_all = function (arr, key_partial_creation_specifier_assoc)
      local creation_specifier_arr = get.table_of_assocs.assoc_arr(key_partial_creation_specifier_assoc, "key")
      dothis.created_item_specifier_arr.create_or_recreate_all(
        arr,
        creation_specifier_arr
      )
    end
  },
  stream_created_item_specifier = {
    exec = function(spec, ...)
      return dothis.mpv_ipc_socket_id.exec(spec.inner_item.ipc_socket_id, ...)
    end,
    set_playlist_index = function(spec, index)
      return dothis.mpv_ipc_socket_id.set_playlist_index(spec.inner_item.ipc_socket_id, index)
    end,
    set_playback_seconds = function(spec, seconds)
      return dothis.mpv_ipc_socket_id.set_playback_seconds(spec.inner_item.ipc_socket_id, seconds)
    end,
    set_playback_percent = function(spec, percent)
      return dothis.mpv_ipc_socket_id.set_playback_percent(spec.inner_item.ipc_socket_id, percent)
    end,
    set_playback_seconds_relative = function(spec, seconds)
      return dothis.mpv_ipc_socket_id.set_playback_seconds_relative(spec.inner_item.ipc_socket_id, seconds)
    end,
  },
  stream_created_item_specifier_arr = {
    create_background_stream = function(arr, spec)
      local copied_spec = get.table.table_by_copy(spec)
      copied_spec.flag_profile_name = "background"
      copied_spec.type = "stream"
      dothis.created_item_specifier_arr.create(arr, copied_spec)
    end,
    create_background_streams = nil -- TODO
  },
  timer_spec = {
    set_next_timestamp_s = function(spec)
      spec.next_timestamp_s = transf.cronspec_str.timestamp_s_by_next(spec.cronspec_str)
    end,
    postpone_next_timestamp_s = function(spec, s)
      spec.next_timestamp_s = spec.next_timestamp_s + s
    end,
    fire = function(spec)
      spec.fn()
      dothis.timer_spec.set_next_timestamp_s(spec)
      spec.largest_interval = transf.two_comparables.bool_by_larger(spec.largest_interval, transf.timer_spec.int_by_interval_left(spec))
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
            dothis.timer_spec.fire(v)
            fired = true
          else
            dothis.timer_spec.postpone_next_timestamp_s(v, 1)
          end
        end
      end
    end,
    create = function(arr, spec)
      dothis.arr.push(arr, spec)
      dothis.timer_spec.set_next_timestamp_s(spec)
    end,
    create_by_default_interval = function(arr, fn)
      dothis.timer_spec_arr.create(
        arr,
        {
          fn = fn,
          cronspec_str = "*/10 * * * *",
        }
      )
    end
  },
  preference_domain_str = {
    write_default = function(domain, key, value, type)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("defaults write" .. transf.str.str_by_single_quoted_escaped(domain) .. transf.str.str_by_single_quoted_escaped(key) .. " -" .. type .. " " .. transf.str.str_by_single_quoted_escaped(value))
    end

  },
  move_input_spec = {
    final_exec = function(spec)
      hs.mouse.absolutePosition(
        transf.declared_position_change_input_spec.target_hs_geometry_point(spec)
      )
    end,
    exec_position_change_state_spec = function(spec, position_change_state_spec)
      hs.mouse.absolutePosition(position_change_state_spec.current_hs_geometry_point)
    end,
    exec = function(spec, do_after)
      dothis.declared_position_change_input_spec.exec(
        get.input_spec.declared_input_spec(spec, "move"),
        do_after
      )
    end,
  },
  scroll_input_spec = {
    final_exec = function() end,
    exec_position_change_state_spec = function(spec, position_change_state_spec)
      hs.eventtap.scrollWheel({position_change_state_spec.delta_hs_geometry_point.x, position_change_state_spec.delta_hs_geometry_point.y}, {}, "pixel")
    end,
    exec = function(spec, do_after)
      dothis.declared_position_change_input_spec.exec(
        get.input_spec.declared_input_spec(spec, "scroll"),
        do_after
      )
    end,
  },
  declared_position_change_input_spec = {
    exec = function(spec, do_after)
      local position_change_state_spec = transf.declared_position_change_input_spec.starting_position_change_state_spec(spec)
      local timer = hs.timer.doWhile(function() 
        if 
          not transf.position_change_state_spec.should_continue(position_change_state_spec)
        then
          dothis[
            spec.mode .. "_input_spec"
          ].final_exec(spec, do_after)
          if do_after then
            hs.timer.doAfter(0.2, do_after)
          end
          return false
        else
          position_change_state_spec = transf.position_change_state_spec.next_position_change_state_spec(position_change_state_spec)
          return true
        end
      end, function()
        dothis[
          spec.mode .. "_input_spec"
        ].exec_position_change_state_spec(spec, position_change_state_spec)
      end, POLLING_INTERVAL)
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
      dothis[
        spec.mode .. "_input_spec"
      ].exec(spec, do_after)
    end,
  },
  input_spec_arr = {
    exec = function(specarr, wait_time, do_after)
      wait_time = wait_time or transf.number_interval_specifer.number_by_random({start=0.10, stop=0.12})
      if #specarr == 0 then
        if do_after then
          do_after()
        end
        return
      end
      hs.timer.doAfter(
        wait_time, 
        function()
          local subspecifier = act.arr.shift(specarr)
          dothis.input_spec.exec(subspecifier, function()
            dothis.input_spec_arr.exec(subspecifier, do_after)
          end)
        end
      )
    end
  },
  input_spec_str_arr = {
    exec = function(strarr, wait_time, do_after)
      dothis.input_spec_arr.exec(
        transf.input_spec_str_arr.input_spec_arr(strarr),
        wait_time,
        do_after
      )
    end
  },
  input_spec_series_str = {
    exec = function(str, wait_time, do_after)
      dothis.input_spec_arr.exec(
        transf.input_spec_series_str.input_spec_arr(str),
        wait_time,
        do_after 
      )
    end

  },
  ["nil"] = {
    vdirsyncer_sync = function()
      dothis.str.env_bash_eval_async("vdirsyncer sync")
    end,
    newsboat_reload = function()
      dothis.str.env_bash_eval_async("newsboat -x reload")
    end,
    sox_rec_start_cache = function(do_after)
      dothis.local_absolute_path.start_recording_to(transf.str.in_cache_local_absolute_path(os.time(), "recording"), do_after)
    end,
    sox_rec_stop = function(do_after)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped("killall rec", do_after)
    end,
    sox_rec_toggle_cache = function(do_after)
      if transf["nil"].sox_is_recording() then
        dothis.sox.sox_rec_stop()
      else
        dothis.sox.sox_rec_start_cache(do_after)
      end
    end,
    mullvad_connect = function()
      dothis.str.env_bash_eval_async("mullvad connect")
    end,
    mullvad_disconnect = function()
      dothis.str.env_bash_eval_async("mullvad disconnect")
    end,
    mullvad_toggle = function()
      if transf["nil"].mullvad_bool_connected() then
        dothis["nil"].mullvad_disconnect()
      else
        dothis["nil"].mullvad_connect()
      end
    end,
    mbsync_sync  = function()
      dothis.str.env_bash_eval('mbsync -c "$XDG_CONFIG_HOME/isync/mbsyncrc" mb-channel')
    end,
    purge_memstore_cache = function()
      memstore = {}
    end,
    purge_fsmemoize_cache = function()
      dothis.absolute_path.delete(
        dothis.absolute_path.empty_dir(env.XDG_CACHE_HOME .. "/hs/fsmemoize")
      )
    end,
    firefox_dump_state = function(do_after)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped('lz4jsoncat "$MAC_FIREFOX_PLACES_SESSIONSTORE_RECOVERY" > "$TMP_FIREFOX_STATE_JSON', do_after)
    end,
    newpipe_extract_backup = function(do_after)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped('cd "$NEWPIPE_STATE_DIR" && unzip *.zip && rm *.zip *.settings', do_after)
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
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped("jsonify-tachiyomi-backup", function()
        local tmst_assoc = transf.tachiyomi_json_table.timestamp_ms_key_assoc_value_assoc(transf.json_file.not_userdata_or_function(env.TMP_TACHIYOMI_JSON))
        tmst_assoc = get.timestamp_ms_key_assoc_value_assoc.timestamp_ms_key_assoc_value_assoc_by_filtered_timestamp(tmst_assoc, "tachiyomi")
        dothis.logging_dir.log_timestamp_ms_key_assoc_value_assoc(
          env.MMANGA_LOGS,
          tmst_assoc
        )
        dothis.backuped_thing_identifier.write_current_timestamp_ms("tachiyomi")
      end)
    end,
    --- do once ff is quit
    ff_backup = function()
      local timestamp = transf.backuped_thing_identifier.timestamp_ms("firefox")
      if transf.mac_application_name.bool_by_running_application("Firefox") then
        return -- don't try to backup while firefox is running
      end
      dothis.sqlite_file.query_w_table_arg_fn(
        env.MAC_FIREFOX_PLACES_SQULITE,
        "SELECT json_group_object(visit_date/1000, json_object('title', title, 'url', url))" .. 
        "FROM moz_places " ..
        "INNER JOIN moz_historyvisits ON moz_places.id = moz_historyvisits.place_id " ..
        "WHERE visit_date > " .. timestamp * 1000 .. " " ..
        "ORDER BY timestamp DESC;",
        function(tbl)
          dothis.logging_dir.log_timestamp_ms_key_assoc_value_assoc(
            env.MBROWSER_LOGS,
            tbl
          )
          dothis.backuped_thing_identifier.write_current_timestamp_ms("firefox")
        end
      )
    end,
    newpipe_backup = function()
      dothis["nil"].newpipe_extract_backup(function()
        local timestamp = transf.backuped_thing_identifier.timestamp_ms("newpipe")
        dothis.sqlite_file.query_w_table_arg_fn(
          env.env.NEWPIPE_STATE_DIR .. "/history.db",
          "SELECT json_group_object(access_date, json_object('title', title, 'url', url))" .. 
          "FROM stream_history " ..
          "INNER JOIN streams ON stream_history.stream_id = streams.uid " ..
          "WHERE access_date > " .. timestamp  .. " " ..
          "ORDER BY timestamp DESC;",
          function(tbl)
            dothis.logging_dir.log_timestamp_ms_key_assoc_value_assoc(
              env.MMEDIA_LOGS,
              tbl
            )
            dothis.backuped_thing_identifier.write_current_timestamp_ms("newpipe")
          end
        )
      end)
    end,
    git_backup = function()
      local tbl = {}
      for file in transf.dir.absolute_path_stateful_iter_by_children(env.TMP_GIT_LOG_PARENT) do
        local commit = transf.json_file.not_userdata_or_function(file)
        local timestamp_s = commit.epoch
        commit.epoch = nil
        tbl[timestamp_s * 1000] = commit
      end
      dothis.logging_dir.log_timestamp_ms_key_assoc_value_assoc(
        env.MDIARY_COMMITS,
        tbl
      )
      dothis.extant_path.empty_dir(env.TMP_GIT_LOG_PARENT)
    end,
    telegram_generate_backup = function(_, do_after)
      dothis.fn_queue_specifier.push(main_qspec,
        function()
          local window = transf.running_application.main_window(
            transf.mac_application_name.running_application("Telegram")
          )
          dothis.window.focus(window)
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
          transf.str.in_cache_local_absolute_path("signal", "export") .. "/chats"
        ) .. "&& sigtop export-attachments" ..
        transf.str.str_by_single_quoted_escaped(
          transf.str.in_cache_local_absolute_path("signal", "export") .. "/media"
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
              transf.mac_application_name.running_application("Firefox")
            )
            dothis.window.focus(ff_window)
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
          transf.str.in_cache_local_absolute_path("discord", "export")
        ),
        do_after
      )
    end,
    facebook_preprocess_backup = function()
      local dlchildren = transf.dir.absolute_path_arr_by_children(env.DOWNLOADS)
      local fbfiles = get.path_arr.path_arr_by_filter_to_filename_starting(dlchildren, "facebook-samswartzberg")
      local fbzips = get.path_arr.path_arr_by_filter_to_same_extension(fbfiles, "zip")
      local newest_fbzip = transf.extant_path_arr.extant_path_by_newest_creation(fbzips)
      local tmploc = transf.str.in_tmp_local_absolute_path("facebook", "export")
      dothis.local_zip_file.unzip_to_absolute_path(newest_fbzip, tmploc)
      dothis.file.delete_file(newest_fbzip)
      dothis.facebook_raw_export_dir.process_to_facebook_export_dir(tmploc)
    end,
    telegram_backup = function()
      dothis["nil"].telegram_generate_backup(nil, function()
        dothis.telegram_raw_export_dir.process_to_telegram_export_dir(
          transf["nil"].telegram_raw_export_dir_by_current()
        )
        dothis.backup_type.log("telegram")
      end)
    end,
    signal_backup = function()
      dothis["nil"].signal_generate_backup(nil, function()
        dothis.backup_type.log("signal")
      end)
    end,
    discord_backup = function()
      dothis["nil"].discord_generate_backup(nil, function()
        dothis.backup_type.log("discord")
      end)
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
        transf.str.in_cache_local_absolute_path("telegram", "export")
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
        transf.str.in_cache_local_absolute_path("facebook", "export")
      )
    end
  },
  backuped_thing_identifier = {
    write_current_timestamp_ms = function(identifier)
      dothis.local_file.write_file(
        transf.path.path_by_ending_with_slash(env.MLAST_BACKUP) .. identifier,
        (os.time() - 30) * 1000
      )
    end,

  },
  fn = {
    reset_by_all = function(fn)
      dothis.fnid.reset_by_all(
        transf.fn.fnid(fn)
      )
    end,
  },
  fnid = {
    put_memo = function(fnid, opts_as_str, params, result, opts)
      memstore[fnid] = memstore[fnid] or {}
      memstore[fnid][opts_as_str] = memstore[fnid][opts_as_str] or {}
      local node = memstore[fnid][opts_as_str]
      for i=1, #params do
        local param = params[i]
        if param == nil then param = nil_singleton 
        elseif opts.strify_table_params and is.any.table(param) then
          if opts.table_param_subset == "json" then
            param = json.encode(param)
          elseif opts.table_param_subset == "no-fn-userdata-loops" then
            param = shelve.marshal(param)
          elseif opts.table_param_subset == "any" then
            param = hs.inspect(param, { depth = 4 })
          end
        end
        node.children = node.children or {}
        node.children[param] = node.children[param] or {}
        node = node.children[param]
      end
      node.results = get.table.table_by_copy(result, true)
    end,
    reset_by_opts = function(fnid, opts_as_str)
      memstore[fnid] = memstore[fnid] or {}
      memstore[fnid][opts_as_str] = {}
    end,
    reset_by_all = function(fnid)
      memstore[fnid] = nil
    end,
  },
  fnname = {
    put_memo = function(fnid, opts_as_str, params, result, opts)
      local cache_path = get.fnname.local_absolute_path_by_in_cache_w_str_and_arr_or_nil(fnid, opts_as_str, params)
      dothis.absolute_path.write_file(cache_path, json.encode(result))
    end,
    reset_by_opts = function(fnid, opts_as_str)
      local cache_path = get.fnname.local_absolute_path_by_in_cache_w_str_and_arr_or_nil(fnid, opts_as_str)
      dothis.absolute_path.delete(cache_path)
    end,
    reset_by_all = function(fnname)
      dothis.absolute_path.delete(
        transf.fnname.local_absolute_path_by_in_cache(fnname)
      )
    end,
    set_timestamp_s_created_time = function(fnid, opts_as_str, created_time)
      dothis.absolute_path.write_file(get.fnname.local_absolute_path_by_in_cache_w_str_and_arr_or_nil(fnid, opts_as_str, "~~~created~~~"), transf.any.str(created_time))
    end
  },
  fn_queue_specifier = {
    update = function(qspec)
      hs.alert.closeSpecific(qspec.alert)
      if #qspec.fn_arr == 0 then 
        dothis.hotkey_created_item_specifier.pause(qspec.hotkey_created_item_specifier)
      else
        qspec.alert = dothis.str.alert(
          transf.fn_queue_specifier.str_by_waiting_message(qspec),
          "indefinite"
        )
        dothis.hotkey_created_item_specifier.resume(qspec.hotkey_created_item_specifier)
      end
    end,
    push = function(qspec, fn)
      dothis.arr.push(qspec.fn_arr, fn)
      dothis.fn_queue_specifier.update(qspec)
    end,
    pop = function(qspec)
      local fn = act.arr.pop(qspec.fn_arr)
      fn()
      dothis.fn_queue_specifier.update(qspec)
    end,
  },
  export_chat_main_object = {
    log = function(obj, typ, source_media_dir)
      local logging_dir = get.export_chat_main_object.logging_dir(obj, typ)
      dothis.absolute_path.create_dir(
        logging_dir
      )
      local media_dir = get.export_chat_main_object.media_dir(obj, typ)
      dothis.absolute_path.create_dir(
        media_dir
      )
      dothis.logging_dir.log_timestamp_ms_key_assoc_value_assoc(
        logging_dir,
        get.export_chat_main_object.timestamp_ms_key_msg_spec_value_assoc_by_filtered(
          obj,
          typ
        )
      )
      dothis.backuped_thing_identifier.write_current_timestamp_ms(
        get.export_chat_main_object.backuped_thing_identifier(obj, typ)
      )
      dothis.dir.move_children_absolute_path_arr_into_absolute_path(
        source_media_dir,
        media_dir
      )
    end,
      
  },
  telegram_export_dir = {
    
  },
  export_dir = {
    log = function(dir, typ)
      local arr = transf[typ .. "_export_dir"].export_chat_main_object_and_media_dir_arr(dir)
      for _, two_anys_arr in transf.arr.pos_int_vt_stateless_iter(arr) do
        dothis.export_chat_main_object.log(two_anys_arr[1], typ, two_anys_arr[2])
      end
    end
  },
  backup_type = {
    log = function(typ)
      dothis.export_dir.log(
        transf.str.in_cache_local_absolute_path(typ, "export"),
        typ
      )
    end
  },
  search_engine_id = {
    search = function(engine, query)
      dothis.str.search(query, engine)
    end
  }
}