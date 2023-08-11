dothis = {
  package_manager_name = {
    install = function(mgr, pkg)
      dothis.string.env_bash_eval("upkg " .. mgr .. " install " .. transf.string.single_quoted_escaped(pkg))
    end,
    remove = function(mgr, pkg)
      dothis.string.env_bash_eval("upkg " .. mgr .. " remove " .. transf.string.single_quoted_escaped(pkg))
    end,
    upgrade = function(mgr, pkg)
      local target
      if pkg then target = transf.string.single_quoted_escaped(pkg)
      else target = "" end
      dothis.string.env_bash_eval("upkg " .. mgr .. " upgrade " .. target)
    end,
    link = function(mgr, pkg)
      dothis.string.env_bash_eval("upkg " .. mgr .. " link " .. transf.string.single_quoted_escaped(pkg))
    end,
    do_backup_and_commit = function(mgr, action, msg)
      dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped("upkg " .. mgr .. " " .. action, function()
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
      specifier = get.table.table_by_mapped_w_vt_arg_vt_ret_fn_and_vt_arg_bool_ret_fn(specifier, stringy.strip, is.any.string)
      local command = {"khal", "new" }
      if specifier.calendar then
        command = transf.two_arrays.array_by_appended(
          command,
            "--calendar" ..
            transf.string.single_quoted_escaped(specifier.calendar)
        )
      end

      if specifier.location then
        command = transf.two_arrays.array_by_appended(
          command,
            "--location" ..
            transf.string.single_quoted_escaped(specifier.location)
        )
      end

      if specifier.alarms then
        local alarms_str = get.string_or_number_array.string_by_joined(
          get.table.table_by_mapped_w_vt_arg_vt_ret_fn_and_vt_arg_bool_ret_fn(specifier.alarms, stringy.strip, is.any.string),
          ","
        )
        command = transf.two_arrays.array_by_appended(
          command,
            "--alarm" ..
            transf.string.single_quoted_escaped(alarms_str )
        )
      end

      if specifier.url then 
        command = transf.two_arrays.array_by_appended(
          command,
            "--url" ..
            transf.string.single_quoted_escaped(specifier.url)
        )
      end

      -- needed for postcreation modifications 
      command = transf.two_arrays.array_by_appended(
        command,
          "--format" ..
          transf.string.single_quoted_escaped("{uid}")
      )

      if specifier.start then
        dothis.array.push(command, specifier.start)
      end

      if specifier["end"] then
        dothis.array.push(command, specifier["end"])
      end

      if specifier.timezone then
        dothis.array.push(command, specifier.timezone)
      end

      if specifier.title then
        dothis.array.push(command, specifier.title)
      end

      if specifier.description then
        command = transf.two_arrays.array_by_appended(
          command,
            "::" ..
            transf.string.single_quoted_escaped(specifier.description)
        )
      end

      if do_after then
        dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped(
          get.string_or_number_array.string_by_joined(command, " "), 
          do_after
        )
      else
        dothis.string.env_bash_eval_sync(
          get.string_or_number_array.string_by_joined(command, " ")
        )
      end
    end,
    add_event_interactive = function(event_table, do_after)
      event_table = event_table or {}
      local temp_file_contents = get.string.evaled_as_template(transf.event_table.calendar_template(event_table))
      dothis.string.edit_temp_file_in_vscode_act_on_contents(temp_file_contents, function(cnt)
        local new_specifier = transf.yaml_string.not_userdata_or_function(cnt)
        dothis.event_table.add_event_from(new_specifier, do_after)
      end)
    end,
  },
  md_file = {
    to_file_in_same_dir = function(source, format, metadata, do_after)
      local target = transf.path.path_without_extension(source) .. "." .. tblmap.pandoc_format.extension[format]
      local rawsource = transf.file.contents(source)
      local processedsource = get.string.string_by_with_yaml_metadata(rawsource, metadata)
      rawsource = eutf8.gsub(rawsource, "\n +\n", "\n&nbsp;\n")
      local temp_path = source .. ".tmp"
      dothis.absolute_path.write_file(temp_path, processedsource) 
      local cmd = 
        "pandoc" ..
        "--wrap=preserve -f markdown+" .. get.string_or_number_array.string_by_joined(get.pandoc.extensions(), "+") .. " --standalone -t" ..
        format ..
        "-i" ..
        transf.string.single_quoted_escaped(temp_path)
        "-o" ..
        transf.string.single_quoted_escaped(target)
      dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped(cmd, function ()
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
  uuid = {
    add_contact_data = function(uuid, data, type)
      type = "contacts/" .. type
      dothis.alphanum_minus_underscore.set_pass_json(uuid, type, data)
    end,
    edit_contact = function(uuid, do_after)
      dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped("khard edit " .. uuid, do_after)
    end,
  },
  pass_item_name = {
    replace = function(name, type, data)
      dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped("pass rm " .. type .. "/" .. name, function()
        dothis.alphanum_minus_underscore.add_as_pass_item_name(name, type, data)
      end)
    end,
    rename = function(name, type, new_name)
      dothis.string.env_bash_eval("pass mv " .. type .. "/" .. name .. " " .. type .. "/" .. new_name)
    end,
    remove = function(name, type)
      dothis.string.env_bash_eval("pass rm " .. type .. "/" .. name)
    end,
  },
  alphanum_minus_underscore = {
    add_as_pass_item_name_with_json = function(name, type, data)
      dothis.alphanum_minus_underscore.add_as_pass_item_name(name, type, json.encode(data))
    end,
    add_as_pass_item_name = function(name, type, data)
      dothis.string.env_bash_eval("yes " .. transf.not_userdata_or_function.single_quoted_escaped(data) .. " | pass add " .. type .. "/" .. name)
    end,
    add_as_passw_pass_item_name = function(name, password)
      dothis.alphanum_minus_underscore.add_as_pass_item_name(name, "passw", password)
    end,
    add_as_username_pass_item_name = function(name, username)
      dothis.absolute_path.write_file(
        get.pass_item_name.path(name, "username", "txt"),
        username
      )
    end,
  },
  contact_table = {
    add_iban = function(contact_table, iban)
      dothis.uuid.add_contact_data(transf.contact_table.uid(contact_table), "iban", iban)
    end,
    edit = function(contact_table)
      dothis.uuid.edit_contact(transf.contact_table.uid(contact_table))
    end,
  },
  youtube_video_id = {
    
  },
  url = {
    download_to_async = function(url, target)
      dothis.string.env_bash_eval_async("curl -L " .. transf.string.single_quoted_escaped(url) .. " -o " .. transf.string.single_quoted_escaped(target))
    end,
    download_to_sync = function(url, target)
      dothis.string.env_bash_eval_sync("curl -L " .. transf.string.single_quoted_escaped(url) .. " -o " .. transf.string.single_quoted_escaped(target))
    end,
    download_into_async = function(url, target_dir)
      dothis.string.env_bash_eval_async("cd " .. transf.string.single_quoted_escaped(target_dir) .. "&& curl -L " .. transf.string.single_quoted_escaped(url) .. " -O")
    end,
    download_into_sync = function(url, target_dir)
      dothis.string.env_bash_eval_sync("cd " .. transf.string.single_quoted_escaped(target_dir) .. "&& curl -L " .. transf.string.single_quoted_escaped(url) .. " -O")
    end,
      
    add_event_from_url = function(url, calendar)
      local temp_path_arg = transf.string.single_quoted_escaped(env.TMPDIR .. "/event_downloaded_at_" .. os.time() .. ".ics")
      dothis.string.env_bash_eval('curl' .. transf.string.single_quoted_escaped(url) .. ' -o' .. temp_path_arg .. '&& khal import --include-calendar ' .. calendar .. temp_path_arg)
    end,
  },
  otp_url = {
    add_otp_pass_item = function(url, name)
      dothis.string.env_bash_eval_async(
        "echo" ..
        transf.string.single_quoted_escaped(url) ..
        "| pass otp insert otp/" .. name
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
  table = {
    write_ics_file = function(tbl, path)
      local tmpdir_json_path = transf.not_userdata_or_function.in_tmp_dir(tbl) .. ".json"
      local tmpdir_ics_path = transf.not_userdata_or_function.in_tmp_dir(tbl) .. ".ics"
      dothis.absolute_path.write_file(tmpdir_json_path, json.encode(tbl))
      dothis.string.env_bash_eval_sync(
        "ical2json" ..
        "-r" ..
        transf.string.single_quoted_escaped(tmpdir_ics_path)
      )
      dothis.absolute_path.delete(tmpdir_json_path)
      if path then
        dothis.extant_path.move_to_absolute_path(tmpdir_ics_path, path)
        dothis.absolute_path.delete(tmpdir_ics_path)
      end
    end,
    choose_w_pair_arg_fn = function(tbl, fn, target_item_chooser_item_specifier_name)
      dothis.array.choose_item(
        transf.table.pair_array_by_sorted_smaller_key_first(tbl),
        fn,
        target_item_chooser_item_specifier_name
      )
    end,
    choose_w_kt_vt_arg_fn = function(tbl, fn, target_item_chooser_item_specifier_name)
      dothis.array.choose_item(
        transf.table.pair_array_by_sorted_smaller_key_first(tbl),
        function(pair)
          fn(transf.pair.key_value(pair))
        end,
        target_item_chooser_item_specifier_name
      )
    end,
    choose_w_kt_fn = function(tbl, fn, target_item_chooser_item_specifier_name)
      dothis.array.choose_item(
        transf.table.pair_array_by_sorted_smaller_key_first(tbl),
        function(pair)
          fn(transf.pair.key(pair))
        end,
        target_item_chooser_item_specifier_name
      )
    end,
    choose_w_vt_fn = function(tbl, fn, target_item_chooser_item_specifier_name)
      dothis.array.choose_item(
        transf.table.pair_array_by_sorted_smaller_key_first(tbl),
        function (pair)
          fn(transf.pair.value(pair))
        end,
        target_item_chooser_item_specifier_name
      )
    end,
    choose_kt_w_kt_fn = function(tbl, fn, target_item_chooser_item_specifier_name)
      dothis.array.choose_item(
        transf.table.kt_array_by_sorted_smaller_first(tbl),
        fn,
        target_item_chooser_item_specifier_name
      )
    end,
    choose_vt_w_vt_fn = function(tbl, fn, target_item_chooser_item_specifier_name)
      dothis.array.choose_item(
        transf.table.vt_array_by_sorted_smaller_first(tbl),
        fn,
        target_item_chooser_item_specifier_name
      )
    end,
  },
  string = {
    generate_qr_png = function(data, path)
      if not is.path.extant_path(path) then
        transf.string.string_or_nil_by_evaled_env_bash_stripped("qrencode -l M -m 2 -t PNG -o" .. transf.string.single_quoted_escaped(path) .. transf.string.single_quoted_escaped(data))
      end -- else: don't do anything: QR code creation is deterministic, so we don't need to do it again. This relies on the path not changing, which our consumers are responsible for.
    end,
    alert = function(str, opts)
      opts = get.table.table_by_copy(opts) or {}
      opts.duration = opts.duration or 10
      return hs.alert.show(str, {textSize = 12, textFont = "Noto Sans Mono", atScreenEdge = 1, radius = 3}, opts.duration)
    end,
    say = function(str, lang)
      lang = lang or "en"
      speak:voice(tblmap.lang.voice[lang]):speak(transf.string.singleline_string_by_folded(str))
    end,
    paste = function(str)
      local lines = stringy.split(str, "\n")
      local is_first_line = true
      for _, line in transf.array.index_value_stateless_iter(lines) do
        if is_first_line then
          is_first_line = false
        else
          hs.eventtap.keyStroke({}, "return")
        end
        hs.eventtap.keyStrokes(line)
      end
    end,
    paste_le = function(str)
      dothis.string.paste(get.string.evaled_as_template(str))
    end,
    add_to_clipboard = hs.pasteboard.setContents,
    fill_with_lines = function(str)
      dothis.string_array.fill_with(transf.string.lines(str))
    end,
    fill_with_content_lines = function(path)
      dothis.string_array.fill_with(transf.string.noempty_line_string_array(path))
    end,
    fill_with_nocomment_noindent_content_lines = function(path)
      dothis.string_array.fill_with(transf.string.nocomment_noindent_content_lines(path))
    end,
    search = function(str, search_engine)
      dothis.url_or_local_path.open_browser(
        get.string.search_engine_search_url(search_engine, str)
      )
    end,
    write_to_temp_file = function(str)
      local path = transf.string.in_tmp_dir(os.time(), "temp_file")
      dothis.absolute_path.write_file(path, str)
      return path
    end,
    open_temp_file = function(str, do_after)
      dothis.local_path.open_app(
        transf.string.write_to_temp_file(str),
        env.GUI_EDITOR,
        do_after
      )
    end,
    edit_temp_file_in_vscode_act_on_path = function(str, do_after)
      local path = transf.string.write_to_temp_file(str)
      dothis.local_file.edit_file_in_vscode_act_on_path(path, do_after)
    end,
    edit_temp_file_in_vscode_act_on_contents = function(str, do_after)
      local path = transf.string.write_to_temp_file(str)
      dothis.local_file.edit_file_in_vscode_act_on_contents(path, do_after)
    end,
    create_url_array_as_session_in_msessions = function(str)
      dothis.url_array.create_as_session_in_msessions(
        transf.string.url_array(str)
      )
    end,
    raw_bash_eval_w_string_or_string_and_8_bit_pos_int_arg_fn = function(str, fn)
      local task = hs.task.new(
        "/opt/homebrew/bin/bash",
        function (...) fn(transf.number_and_two_anys.any_or_any_and_number_by_zero(...)) end,
        { "-c", transf.string.string_by_minimal_locale_setter_commands_prepended(
          str
        )}
      )
      task:start()
      return task
    end,
    env_bash_eval_w_string_or_string_and_8_bit_pos_int_arg_fn = function(str, fn)
      local task = hs.task.new(
        "/opt/homebrew/bin/bash",
        function (...) fn(transf.number_and_two_anys.any_or_any_and_number_by_zero(...)) end,
        { "-c", transf.string.string_by_env_getter_comamnds_prepended(
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
        { "-c", transf.string.string_by_env_getter_comamnds_prepended(
          str
        )}
      )
      task:start()
      return task
    end,
    env_bash_eval_sync = function(str)
      hs.execute(
        transf.string.string_by_env_getter_comamnds_prepended(
          str
        )
      )
    end,
    env_bash_eval_w_string_or_string_and_8_bit_pos_int_arg_fn_by_stripped = function(str, fn)
      dothis.string.env_bash_eval_w_string_or_string_and_8_bit_pos_int_arg_fn(
        str,
        get.n_any_arg_fn.n_t_arg_fn_w_n_any_arg_n_t_ret_fn(fn, transf.string_and_n_anys.string_and_n_anys_by_stripped)
      )
    end,
    env_bash_eval_w_string_or_nil_arg_fn_by_stripped = function(str, fn)
      dothis.string.env_bash_eval_w_string_or_string_and_8_bit_pos_int_arg_fn_by_stripped(
        str,
        get.n_any_arg_fn.n_t_arg_fn_w_n_any_arg_n_t_ret_fn(fn, transf.string_and_number_or_nil.string_or_nil_by_number)
      )
    end,
    env_bash_eval_w_string_arg_fn_string_arg_fn_by_stripped = function(str, succfn, failfn)
      dothis.string.env_bash_eval_w_string_or_string_and_8_bit_pos_int_arg_fn_by_stripped(
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
    env_bash_eval_w_string_or_nil_arg_fn_by_stripped_noempty = function(str,fn)
      dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped(
        str,
        function(str_or_nil)
          if str_or_nil == "" then str_or_nil = nil end
          fn(str_or_nil)
        end
      )
    end,
    env_bash_eval_w_string_arg_fn_string_arg_fn_by_stripped_noempty = function(str, succfn, failfn)
      dothis.string.env_bash_eval_w_string_arg_fn_string_arg_fn_by_stripped(
        str,
        function(str)
          if str == "" then failfn("Empty string for command " .. str) else succfn(str) end
        end,
        failfn
      )
    end,
    env_bash_eval_w_not_userdata_or_function_or_nil_arg_fn_by_parsed_json = function(str, fn)
      dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped_noempty(
        str,
        function(str_or_nil)
          str_or_nil = transf.fn.rt_or_nil_fn_by_pcall(transf.json_string.not_userdata_or_function)(str_or_nil)
          fn(str_or_nil)
        end
      )
    end,
    env_bash_eval_w_not_userdata_or_function_arg_fn_string_arg_fn_by_parsed_json = function(str, succfn, failfn)
      dothis.string.env_bash_eval_w_string_arg_fn_string_arg_fn_by_stripped_noempty(
        str,
        function(str)
          local succ, res = pcall(transf.json_string.not_userdata_or_function, str)
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
      dothis.string.env_bash_eval_w_not_userdata_or_function_or_nil_arg_fn_by_parsed_json(
        str,
        function(arg)
          if not is.any.table(arg) then arg = nil end
          fn(arg)
        end
      )
    end,
    env_bash_eval_w_table_arg_fn_string_arg_fn = function(str, succfn, failfn)
      dothis.string.env_bash_eval_w_not_userdata_or_function_arg_fn_string_arg_fn_by_parsed_json(
        str,
        function(arg)
          if not is.any.table(arg) then failfn("Not a table: " .. arg) else succfn(arg) end
        end,
        failfn
      )
    end,
    env_bash_eval_w_table_or_nil_arg_fn_by_parsed_json_nil_error_key = function(str, fn)
      dothis.string.env_bash_eval_w_table_or_nil_arg_fn_by_parsed_json(
        str,
        function(arg)
          if arg.error then arg = nil end
          fn(arg)
        end
      )
    end,
    env_bash_eval_w_table_arg_fn_string_arg_fn_fail_error_key = function(str, succfn, failfn)
      dothis.string.env_bash_eval_w_table_arg_fn_string_arg_fn(
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
      url = transf.url.url_by_ensure_scheme(url)
      browser = browser or "Firefox"
      if do_after then -- if we're opening an url, typically, we would exit immediately, negating the need for a callback. Therefore, we want to wait. The only easy way to do this is to use a completely different browser. 
        transf.string.string_or_nil_by_evaled_env_bash_stripped("open -a Safari -W" .. transf.string.single_quoted_escaped(url), do_after)
        -- Annoyingly, due to a 15 (!) year old bug, Firefox will open the url as well, even if we specify a different browser. I've tried various fixes, but for now we'll just have to live with it and click the tab away manually.
      else
        transf.string.string_or_nil_by_evaled_env_bash_stripped("open -a" .. transf.string.single_quoted_escaped(browser))
      end
    end,
  },
  local_path = {
    open_default = function(path, do_after)
      dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped("open " .. transf.string.single_quoted_escaped(path), do_after)
    end,
    open_app = function(path, app, do_after)
      dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped("open -a " .. transf.string.single_quoted_escaped(app) .. " " .. transf.string.single_quoted_escaped(path), do_after)
    end,
    open_gui_editor = function(path, do_after)
      dothis.local_path.open_app(path, env.GUI_EDITOR, do_after)
    end,
    open_and_reveal = function(path)
      dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped("open -R " .. transf.string.single_quoted_escaped(path))
    end,
    write_nonabsolute_path_key_dict = function(path, nonabsolute_path_key_dict, extension)
      dothis.dynamic_absolute_path_key_dict.write(
        get.nonabsolute_path_key_dict.absolute_path_key_dict(nonabsolute_path_key_dict, path, extension)
      )
    end,
    write_dynamic_path_dict = function(path, assoc, extension)
      dothis.local_path.write_nonabsolute_path_key_dict(
        transf.table.nonabsolute_path_key_dict(path), 
        assoc, 
        extension
      )
    end,
    write_dynamic_structure = function(path, name)
      dothis.local_path.write_dynamic_path_dict(
        path,
        tblmap.dynamic_structure_name.dynamic_structure[name]
      )
    end,
    serve = function(path, port)
      port = port or env.FS_HTTP_SERVER_PORT
      dothis.created_item_specifier_array.create_or_recreate(
        task_created_item_specifier_array,
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
        get.string.evaled_as_template(
          get.string.evaled_as_lua(template_path),
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
      transf.string.string_or_nil_by_evaled_env_bash_stripped("rec " .. transf.string.single_quoted_escaped(path), function()
        if do_after then
          do_after(path)
        end
      end)
    end,
  },
  local_nonextant_path = {
    create_dir = function(path)
      transf.string.string_or_nil_by_evaled_env_bash_stripped("mkdir -p " .. transf.string.single_quoted_escaped(path))
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
      transf.string.string_or_nil_by_evaled_env_bash_stripped("rclone mkdir " .. transf.string.single_quoted_escaped(path))
    end,
  },
  remote_absolute_path = {
    
  },
  remote_extant_path = {
    zip_to_absolute_path = function(path, tgt)
      local tmppath = transf.string.in_tmp_dir(tgt, "temp_zip")
      dothis.extant_path.copy_to_absolute_path(
        path,
        tmppath
      )
      dothis.local_extant_path.zip_to_absolute_path_and_delete(tmppath, tgt)
    end,
  },
  remote_extant_path_array = {
    zip_to_absolute_path = function(arr, tgt)
      local tmppath = transf.string.in_tmp_dir(tgt, "temp_zip")
      dothis.extant_path_array.copy_into_absolute_path(
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
      transf.string.string_or_nil_by_evaled_env_bash_stripped("chmod +x " .. transf.string.single_quoted_escaped(path))
    end,
    do_in_path = function(path, cmd, do_after)
      if is.path.dir(path) then
        dothis.dir.do_in_path(path, cmd, do_after)
      else
        dothis.dir.do_in_path(transf.path.parent_path(path), cmd, do_after)
      end
    end,
    delete = os.remove,
    move_to_local_absolute_path = function(path, tgt)
      dothis.local_extant_path.create_parent_dir(tgt)
      os.rename(path, tgt)
    end,
    zip_to_local_absolute_path = function(path, tgt)
      dothis.local_extant_path.create_parent_dir(tgt)
      transf.string.string_or_nil_by_evaled_env_bash_stripped("zip -r " .. transf.string.single_quoted_escaped(tgt) .. " " .. transf.string.single_quoted_escaped(path))
    end,
    zip_to_absolute_path = function(path, tgt)
      local tmptgt = transf.string.in_tmp_dir(tgt, "temp_zip_target")
      dothis.local_extant_path.zip_to_local_absolute_path(path, tmptgt)
      dothis.extant_path.move_to_absolute_path(tmptgt, tgt)
    end,
    zip_to_absolute_path_and_delete = function(path, tgt)
      dothis.local_extant_path.zip_to_absolute_path(path, tgt)
      dothis.local_extant_path.delete(path)
    end,
    link_to_local_absolute_path = function(path, tgt)
      dothis.absolute_path.create_parent_dir(tgt)
      hs.fs.link(path, tgt, true)
    end,
    link_into_local_absolute_path = function(path, tgt)
      local finaltgt = transf.path.ending_with_slash(tgt) .. transf.path.leaf(path)
      dothis.local_extant_path.link_to_local_absolute_path(path, finaltgt)
    end,
    link_descendant_file_array_into_local_absolute_path = function(path, tgt)
      dothis.local_extant_path_array.link_into_local_absolute_path(
        transf.path.descendant_file_array(path),
        tgt
      )
    end,
    
  },
  local_extant_path_array = {
    zip_to_local_absolute_path = function(arr, tgt)
      dothis.local_extant_path.create_parent_dir(tgt)
      transf.string.string_or_nil_by_evaled_env_bash_stripped("zip -r " .. transf.string.single_quoted_escaped(tgt) .. " " .. transf.string.single_quoted_escaped(get.string_or_number_array.string_by_joined(arr, " ")))
    end,
    zip_to_absolute_path = function(arr, tgt)
      local tmptgt = transf.string.in_tmp_dir(tgt, "temp_zip_target")
      dothis.local_absolute_path_array.zip_to_local_absolute_path(arr, tmptgt)
      dothis.extant_path.move_to_absolute_path(tmptgt, tgt)
    end,
    zip_to_absolute_path_and_delete = function(arr, tgt)
      dothis.local_absolute_path_array.zip_to_absolute_path(arr, tgt)
      dothis.local_absolute_path_array.delete(arr)
    end,
    link_into_local_absolute_path = function(arr, tgt)
      hs.fnutils.ieach(
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
      local temp_file = transf.string.in_tmp_dir(path, "labelled_remote_temp_file")
      dothis.local_extant_path.write_file(temp_file, contents)
      transf.string.string_or_nil_by_evaled_env_bash_stripped("rclone copyto" .. transf.string.single_quoted_escaped(temp_file) .. " " .. transf.string.single_quoted_escaped(path))
      dothis.absolute_path.delete(temp_file)
    end,
    append_or_write_file = function(path, contents)
      local temp_file = transf.string.in_tmp_dir(path, "labelled_remote_temp_file")
      dothis.local_extant_path.append_or_write_file(temp_file, contents)
      dothis.labelled_remote_file.write_file(path, transf.local_file.contents(temp_file))
    end,
  },
  labelled_remote_dir = {
    empty_dir = function(path)
      dothis.labelled_remote_dir.delete_dir(path)
      dothis.labelled_remote_nonextant_path.create_dir(path)
    end,
    delete_dir = function(path)
      transf.string.string_or_nil_by_evaled_env_bash_stripped("rclone purge " .. transf.string.single_quoted_escaped(path))
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
      dothis.string.env_bash_eval_w_string_or_string_and_8_bit_pos_int_arg_fn("code --wait --disable-extensions " .. transf.string.single_quoted_escaped(path), function()
        if do_after then
          do_after(path)
        end
        dothis.absolute_path.delete(path)
      end)
    end,
    edit_file_in_vscode_act_on_contents = function(path, do_after)
      dothis.string.env_bash_eval_w_string_or_string_and_8_bit_pos_int_arg_fn("code --wait --disable-extensions " .. transf.string.single_quoted_escaped(path), function()
        local contents = transf.file.contents(path)
        dothis.absolute_path.delete(path)
        do_after(contents)
      end)
    end
  },
  local_dir = {
    empty_dir = function(path)
      transf.string.string_or_nil_by_evaled_env_bash_stripped("rm -rf " .. transf.string.single_quoted_escaped(
        transf.path.ending_with_slash(path) .. "*"
      ) .. "/*")
    end,
    copy_to_local_absolute_path = function(path, tgt)
      dothis.local_extant_path.create_parent_dir(tgt)
      pldir.clonetree(path, tgt)
    end,
    link_children_absolute_path_array_into_local_absolute_path = function(path, tgt)
      dothis.local_absolute_path_array.link_into_local_absolute_path(
        transf.path.children_absolute_path_array(path),
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
      dothis.extant_path.move_to_absolute_path(path, transf.path.parent_path(path))
    end,
    move_to_downloads = function(path)
      dothis.extant_path.move_to_absolute_path(path, env.DOWNLOADS)
    end,
    move_to_parent_path_with_extension_if_any = function(path)
      dothis.extant_path.move_to_absolute_path(path, transf.path.parent_path_with_extension_if_any(path))
    end,
    copy_to_absolute_path = function(path, tgt)
      dothis.absolute_path.create_parent_dir(tgt)
      transf.string.string_or_nil_by_evaled_env_bash_stripped("rclone copyto " .. transf.string.single_quoted_escaped(path) .. " " .. transf.string.single_quoted_escaped(tgt))
    end,
    copy_into_absolute_path = function(path, tgt)
      local finaltgt = transf.path.ending_with_slash(tgt) .. transf.path.leaf(path)
      dothis.extant_path.copy_to_absolute_path(path, finaltgt)
    end,
    copy_descendant_file_array_into_absolute_path = function(path, tgt)
      dothis.extant_path_array.copy_into_absolute_path(
        transf.extant_path.file_array_by_descendants(path),
        tgt
      )
    end,
    move_to_absolute_path = function(path, tgt)
      dothis.absolute_path.create_parent_dir(tgt)
      transf.string.string_or_nil_by_evaled_env_bash_stripped("rclone moveto " .. transf.string.single_quoted_escaped(path) .. " " .. transf.string.single_quoted_escaped(tgt))
    end,
    move_into_absolute_path = function(path, tgt)
      local finaltgt = transf.path.ending_with_slash(tgt) .. transf.path.leaf(path)
      dothis.extant_path.move_to_absolute_path(path, finaltgt)
    end,
    move_descendant_file_array_into_absolute_path = function(path, tgt)
      dothis.extant_path_array.move_into_absolute_path(
        transf.extant_path.file_array_by_descendants(path),
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
      local finaltgt = transf.path.ending_with_slash(tgt) .. transf.path.leaf(path)
      dothis.extant_path.zip_to_absolute_path(path, finaltgt)
    end,
    zip_descendant_file_array_to_absolute_path = function(path, tgt)
      dothis.extant_path_array.zip_to_absolute_path(
        transf.extant_path.file_array_by_descendants(path),
        tgt
      )
    end,
    create_stream = function(path, flag_profile_name)

    end,
  },
  extant_path_array = {
    copy_into_absolute_path = function(arr, tgt)
      hs.fnutils.ieach(
        arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(dothis.extant_path.copy_into_absolute_path, {a_use, tgt})
      )
    end,
    move_into_absolute_path = function(arr, tgt)
      hs.fnutils.ieach(
        arr,
        get.fn.arbitrary_args_bound_or_ignored_fn(dothis.extant_path.move_into_absolute_path, {a_use, tgt})
      )
    end,
    zip_to_absolute_path = function(arr, tgt)
      if is.path_array.remote_path_array(arr) then
          dothis.remote_extant_path_array.zip_to_absolute_path(arr, tgt)
      elseif is.path_array.local_path_array(arr) then
          dothis.local_extant_path_array.zip_to_absolute_path(arr, tgt)
      else
          error("Cannot currently zip mixed local & remote paths")
      end
    end,      
  },
  file = {
    do_in_path = function(path, cmd, do_after)
      transf.string.string_or_nil_by_evaled_env_bash_stripped("cd " .. transf.string.single_quoted_escaped(transf.path.parent_path(path)) .. " && " .. cmd, do_after)
    end,
    write_file = function(path, contents)
      dothis[
        transf.path.local_or_remote_string(path) .. "_extant_path"
      ].write_file(path, contents)
    end,
    append_or_write_file = function(path, contents)
      dothis[
        transf.path.local_or_remote_string(path) .. "_extant_path"
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
        transf.path.local_or_remote_string(path) .. "_extant_path"
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
      transf.string.string_or_nil_by_evaled_env_bash_stripped("play " .. transf.string.single_quoted_escaped(path), do_after)
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
      dothis.absolute_path.write_file_if_file(path, contents .. get.string_or_number_array.string_by_joined(lines, "\n"))
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
        get.string.string_by_prompted_once_from_default(
          "",
          "Enter line to add to " .. path
        )
      )
    end,
    write_lines = function(path, lines)
      dothis.absolute_path.write_file_if_file(path, get.string_or_number_array.string_by_joined(lines, "\n"))
    end,
    set_line = function(path, line, line_number)
      local lines = transf.plaintext_file.string_array_by_lines(path)
      lines[line_number] = line
      dothis.plaintext_file.write_lines(path, lines)
    end,
    pop_line = function(path)
      local lines = transf.plaintext_file.string_array_by_lines(path)
      local line = table.remove(lines, #lines)
      dothis.plaintext_file.write_lines(path, lines)
      return line
    end,
    remove_line_w_pos_int = function(path, line_number)
      local lines = transf.plaintext_file.string_array_by_lines(path)
      table.remove(lines, line_number)
      dothis.plaintext_file.write_lines(path, lines)
    end,
    remove_line_w_fn = function(path, cond)
      local lines = transf.plaintext_file.string_array_by_lines(path)
      local index = get.array.pos_int_or_nil_by_first_match_w_fn(lines, cond)
      dothis.plaintext_file.remove_line_w_pos_int(path, index)
    end,
    remove_line_w_string = function(path, cond)
      local lines = transf.plaintext_file.string_array_by_lines(path)
      local index = get.array.pos_int_or_nil_by_first_match_w_t(lines, cond)
      dothis.plaintext_file.remove_line_w_pos_int(path, index)
    end,
    find_remove_nocomment_noindent_line = function(path, cond)
      local lines = transf.plaintext_file.string_array_by_lines(path)
      local index = hs.fnutils.find(lines, function(line)
        local nocomment_noindent = transf.line.nocomment_noindent(line)
        return findsingle(nocomment_noindent, cond)
      end)
      dothis.plaintext_file.remove_line_w_pos_int(path, index)
    end,

  },
  plaintext_table_file = {
    append_array_of_arrays_of_fields = function(path, array_of_arrays_of_fields)
      local lines = hs.fnutils.imap(array_of_arrays_of_fields, function (arr)
        return get.string_or_number_array.string_by_joined(arr, transf.plaintext_table_file.field_separator())
      end)
      dothis.plaintext_file.append_lines(path, lines)
    end,

  },
  plaintext_url_or_local_path_file = {
    open_all = function(path, browser)
      hs.fnutils.ieach(
        transf.plaintext_file.nocomment_noindent_content_lines(path),
        get.fn.arbitrary_args_bound_or_ignored_fn(dothis.url_or_local_path.open_browser, {a_use, browser})
      )
    end,
  },
  email_file ={
    download_attachment = function(path, name, do_after)
      local cache_path = env.XDG_CACHE_HOME .. '/hs/email_attachments'
      local att_path = cache_path .. '/' .. name
      dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped(
        'cd ' .. transf.single_quoted_escaped(cache_path) .. ' && mshow -x'
        .. transf.string.single_quoted_escaped(path) .. transf.string.single_quoted_escaped(name),
        function()
          do_after(att_path)
        end
      )
    end,
    choose_attachment_and_download = function(path, fn)
      dothis.array.choose_item(
        transf.email_file.attachments(path),
        function(att)
          dothis.email_file.download_attachment(path, att, fn)
        end
      )
    end,
    send = function(path, do_after)
      dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped(
        "msmtp -t <" .. transf.string.single_quoted_escaped(path),
        function(res)
          if not res then
            dothis.absolute_path.write_file(env.FAILED_EMAILS .. "/" .. os.date("%Y-%m-%dT%H:%M:%S"), transf.file.contents(path))
            dothis.absolute_path.delete(path)
          else
            dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped(
              "cat" ..
              transf.string.single_quoted_escaped(path) .. "| msed" ..
              transf.string.single_quoted_escaped("/Date/a/"..os.date(tblmap.date_format_name.date_format.email, os.time())) ..
              "| msed".. transf.string.single_quoted_escaped("/Status/a/S/") ..
              "| mdeliver -c" .. transf.string.single_quoted_escaped(env.MBSYNC_ARCHIVE),
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
        dothis.absolute_path.write_file(path, get.string.evaled_as_template(str)) -- re-eval
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
      dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped(
        "mdeliver" .. transf.string.single_quoted_escaped(target) ..
        "<" .. transf.string.single_quoted_escaped(source),
        function()
          dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped(
            "minc" .. transf.string.single_quoted_escaped(target), -- incorporate the message (/cur -> /new, rename in accordance with the mblaze rules and maildir spec)
            function ()
              dothis.string.env_bash_eval_async(
                "rm" .. transf.string.single_quoted_escaped(source)
              )
            end
          )
        end
      )
        
    end,
      
    
  },
  dir = {
    pull_all = function(path)
      dothis.in_git_dir_array.pull_all(
        transf.dir.git_root_dir_descendants(path)
      )
    end,
    do_in_path = function(path, cmd, do_after)
      transf.string.string_or_nil_by_evaled_env_bash_stripped("cd " .. transf.string.single_quoted_escaped(path) .. " && " .. cmd, do_after)
    end,
    delete_child_with_leaf_ending = function(path, ending)
      dothis.absolute_path.delete(
        get.dir.find_child_with_leaf_ending(path, ending)
      )
    end,
    empty_dir = function(path)
      dothis[
        transf.path.local_or_remote_string(path) .. "_extant_path"
      ].empty_dir(path)
    end,
    delete_dir = function(path)
      dothis[
        transf.path.local_or_remote_string(path) .. "_extant_path"
      ].delete_dir(path)
    end,
    delete_dir_if_empty_dir = function(path)
      if is.dir.empty_dir(path) then
        dothis.dir.delete_dir(path)
      end
    end,
    copy_children_absolute_path_array_into_absolute_path = function(path, tgt)
      dothis.extant_path_array.copy_into_absolute_path(
        transf.dir.absolute_path_array_by_children(path),
        tgt
      )
    end,
    move_children_absolute_path_array_into_absolute_path = function(path, tgt)
      dothis.extant_path_array.move_into_absolute_path(
        transf.dir.absolute_path_array_by_children(path),
        tgt
      )
    end,
    zip_children_absolute_path_array_to_absolute_path = function(path, tgt)
      dothis.extant_path_array.zip_to_absolute_path(
        transf.dir.absolute_path_array_by_children(path),
        tgt
      )
    end,
    
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
  email_address = {
    edit_then_send = function(address, do_after)
      dothis.email_specifier.edit_then_send({to = address}, do_after)
    end,
  },
  empty_dir = {

  },
  sqlite_file = {
    query_w_csv_string_arg_fn = function(sqlite_file, query, fn)
      dothis.string.env_bash_eval_w_string_arg_fn_string_arg_fn_by_stripped(
        "sqlite3" ..
        transf.string.single_quoted_escaped(sqlite_file) ..
        "-csv" ..
        transf.string.single_quoted_escaped(query)
      , fn, error)
    end,
    query_w_table_arg_fn = function(sqlite_file, query, fn)
      dothis.string.env_bash_eval_w_table_arg_fn_string_arg_fn(
        "sqlite3" ..
        transf.string.single_quoted_escaped(sqlite_file) ..
        "-json" ..
        transf.string.single_quoted_escaped(query),
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
          title = transf.sgml_url.string_or_nil_by_title(url),
          category = category,
        }
      )
    end,
  },
  audiodevice = {
    set_default = function(device, type)
      device["setDefault" .. transf.string.string_by_first_eutf8_upper(type) .. "Device"](device)
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
  audiodevice_system = {
    ensure_sound_played_on_speakers = function()
      local device = hs.audiodevice.findOutputByName("Built-in Output")
      dothis.audiodevice.ensure_sound_will_be_played(device)
      dothis.audiodevice.set_default(device, "output")
    end,
  },
  audiodevice_array = {
    choose_item_and_set_default = function(array)
      dothis.array.choose_item(
        array,
        dothis.audiodevice_specifier.set_default
      )
    end,
  },
  source_id = {
    activate = function(source_id)
      hs.keycodes.currentSourceID(source_id)
      hs.alert.show(transf.source_id.language(source_id))
    end,
    activate_next = function(source_id)
      dothis.source_id.activate(
        transf.source_id.next_to_be_activated(source_id)
      )
    end,
  },
  ics_file = {
    generate_json_file = function(path)
      return dothis.string.env_bash_eval_async(
        "ical2json" .. transf.string.single_quoted_escaped(path)
      )
    end,
    add_events_from_file = function(path, calendar)
      dothis.string.env_bash_eval("khal import --include-calendar " .. calendar .. " " .. transf.string.single_quoted_escaped(path))
    end,
  },
  git_root_dir = {
    run_hook =  function(path, hook)
      local hook_path = get.git_root_dir.hook_path(path, hook)
      dothis.string.env_bash_eval(hook_path)
    end,
    add_hook = function(path, hook_path, name)
      name = name or transf.path.filename(hook_path)
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
      dothis.local_extant_path.link_to_local_absolute_path(source_hook, get.git_root_dir.hook_path(path, name))
    end,
    link_all_hooks = function(path, type)
      local source_hooks = transf.path.join(env.GITCONFIGHOOKS, type)
      for _, hook in transf.array.index_value_stateless_iter(get.dir.files(source_hooks)) do
        dothis.git_root_dir.link_hook(path, type, hook)
      end
    end,
    copy_all_hooks = function(path, type)
      local source_hooks = transf.path.join(env.GITCONFIGHOOKS, type)
      for _, hook in transf.array.index_value_stateless_iter(get.dir.files(source_hooks)) do
        dothis.git_root_dir.copy_hook(path, type, hook)
      end
    end,

  },
  git_root_dir_array = {
    
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
      dothis.local_extant_path.do_in_path(path, "git add" .. transf.string.single_quoted_escaped(path), do_after)
    end,
    commit_self = function(path, message, do_after)
      dothis.local_extant_path.do_in_path(
        path, 
        "git commit -m" .. transf.string.single_quoted_escaped(message or ("Programmatic commit of " .. path .. " at " .. os.date(tblmap.date_format_name.date_format["rfc3339-datetime"]))),
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
        "git commit -m" .. transf.string.single_quoted_escaped(message or ("Programmatic commit of staged files at " .. os.date(tblmap.date_format_name.date_format["rfc3339-datetime"]))),
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
        "git commit -am" .. transf.string.single_quoted_escaped(message or ("Programmatic commit of all tracked files at " .. os.date(tblmap.date_format_name.date_format["rfc3339-datetime"]))),
        do_after
      )
    end
  },
  in_git_dir_array = {
    pull_all = function(paths)
      for _, path in transf.array.index_value_stateless_iter(paths) do
        dothis.in_git_dir.pull(path)
      end
    end,
  },
  date = {
    create_log_entry = function(date, path, contents)
      error("todo")
    end,
    choose_format = function(dt, fn)
      dothis.table.choose_w_vt_fn(
        tblmap.date_format_name.date_format,
        function(date_format)
          fn(get.date.string_w_date_format_indicator(dt, date_format))
        end
      )
    end
  },
  logging_dir = {
    log_nonabsolute_path_key_timestamp_ms_key_dict_value_dict_by_ymd = function(path, dict)
      local abs_path_dict = get.nonabsolute_path_key_dict.absolute_path_key_dict(
        dict,
        path,
        ".json"
      )
      for path, dict in abs_path_dict do 
        dothis.json_file.merge_w_table(path, dict)
      end
    end,
    log_timestamp_ms_key_dict_value_dict = function(path, timestamp_ms_key_dict_value_dict)
      dothis.logging_dir.log_nonabsolute_path_key_timestamp_ms_key_dict_value_dict_by_ymd(
        path,
        transf.timestamp_ms_key_dict_value_dict.nonabsolute_path_key_timestamp_ms_key_dict_value_dict_by_ymd(timestamp_ms_key_dict_value_dict)
      )
    end,
  },
  json_file = {
    merge_w_table = function(path, table)
      local tblcnt = get.json_file.table_or_nil(path)
      local newcnt = transf.two_table_or_nils.table_by_take_new(tblcnt, table)
      dothis.local_file.write_file(
        path,
        transf.not_userdata_or_function.json_string(newcnt)
      )
    end
  },
  entry_logging_dir = {
    log_string = function(path, str)
      dothis.logging_dir.log_timestamp_ms_key_dict_value_dict(path, {
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
  string_array = {
    join_and_paste = function(array, sep)
      dothis.string.paste_le(transf.string.join(array, sep))
    end,
    fill_with = function(array)
      dothis.string_array.join_and_paste(array, "\t")
    end
  },
  url_array = {
    open_all = function(url_array, browser)
      for _, url in transf.array.index_value_stateless_iter(url_array) do
        dothis.url_or_local_path.open_browser(url, browser)
      end
    end,
    create_as_url_files = function(url_array, path)
      local abs_path_dict = get.url_array.absolute_path_key_dict_of_url_files(url_array, path)
      dothis.absolute_path_string_value_dict.write(abs_path_dict)
    end,
    create_as_session = function(url_array, root)
      local path = transf.local_absolute_path.prompted_multiple_local_absolute_path_from_default(root)
      path = get.string.string_by_with_suffix(path, ".session")
      dothis.absolute_path.write_file(
        path,
        transf.url_array.session_string(url_array)
      )
    end,
    
  },
  sgml_url_array = {
   
  },
  absolute_path_key_dict = {

  },
  dynamic_absolute_path_key_dict = {
    write = function(dynamic_absolute_path_key_dict)
      for absolute_path, contents in transf.table.key_value_stateless_iter(dynamic_absolute_path_key_dict) do
        if is.any.array(contents) then
          dothis.absolute_path[dothis.array.shift(contents)](absolute_path, table.unpack(contents))
        else
          act.absolute_path[contents](absolute_path)
        end
      end
    end,
  },
  absolute_path_string_value_dict = {
    write = function(absolute_path_string_value_dict)
      for absolute_path, contents in transf.table.key_value_stateless_iter(absolute_path_string_value_dict) do
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
        transf.array_and_any.array(
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
      return table.unpack(retval)
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
      get.string.evaled_js_osa( ("Application('%s').windows()[%d].activeTabIndex = %d"):format(
        jxa_tab_specifier.application_name,
        jxa_tab_specifier.window_index,
        jxa_tab_specifier.tab_index
      ))
    end,
    close = function(jxa_tab_specifier)
      get.string.evaled_js_osa( ("Application('%s').windows()[%d].tabs()[%d].close()"):format(
        jxa_tab_specifier.application_name,
        jxa_tab_specifier.window_index,
        jxa_tab_specifier.tab_index
      ))
    end,
  },
  path_with_intra_file_locator_specifier = {
    go_to = function(specifier)
      dothis.input_spec_array.exec(
        transf.path_with_intra_file_locator_specifier.input_spec_array(specifier)
      )
    end,
    open_go_to = function(specifier)
      dothis.local_path.open_app(
        transf.path_with_intra_file_locator_specifier.path(specifier),
        env.GUI_EDITOR,
        get.fn.first_n_args_bound_fn(dothis.path_with_intra_file_locator_specifier.go_to, specifier)
      )
    end
  },
  path_with_intra_file_locator = {
    open_go_to = function(path_with_intra_file_locator)
      dothis.path_with_intra_file_locator_specifier.open_go_to(
        transf.path_with_intra_file_locator.path_with_intra_file_locator_specifier(path_with_intra_file_locator)
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
      dothis.string_array.fill_with(transf.iban.iban_bic_bank_name_array(iban))
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
  env_string = {
    write_and_check = function(str, path)
      dothis.absolute_path.write_file(path, str)
      local errors = transf.shellscript_file.gcc_string_errors(path)
      if errors then
        error("env file " .. path .. " has errors:\n" .. errors)
      end
    end,
    write_env_and_check = function(str)
      dothis.env_string.write_and_check(
        str,
        env.ENVFILE
      )
    end,
  },
  citable_object_id = {
    save_local_csl_file = function(citable_object_id, indication)
      local csl_table = transf[indication].online_csl_table(citable_object_id)
      dothis.absolute_path.write_file(
        env.MCITATIONS .. "/" .. transf.csl_table.citable_filename(csl_table),
        transf.not_userdata_or_function.json_string(csl_table)
      )
    end,
  },
  citations_file = {
    write_bib = function(citations_file, path)
      dothis.absolute_path.write_file(
        path,
        transf.citations_file.bib_string(citations_file)
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
        tblmap.project_type.build_command[project_type],
        do_after
      )
    end,
    pull_subtype_project_materials = function(project_dir, type, subtype)
      dothis.dir.copy_children_absolute_path_array_into_absolute_path( 
        get.project_dir.global_subtype_project_material_path(project_dir, type, subtype),
        get.project_dir.local_subtype_project_material_path(project_dir, type, subtype)
      )
    end,
    push_subtype_project_materials = function(project_dir, type, subtype)
      dothis.dir.copy_children_absolute_path_array_into_absolute_path( 
        get.project_dir.local_subtype_project_material_path(project_dir, type, subtype),
        get.project_dir.global_subtype_project_material_path(project_dir, type, subtype)
      )
    end,
    pull_universal_project_materials = function(project_dir, type)
      dothis.dir.copy_children_absolute_path_array_into_absolute_path( 
        get.project_dir.global_universal_project_material_path(project_dir, type),
        get.project_dir.local_universal_project_material_path(project_dir, type)
      )
    end,
    push_universal_project_materials = function(project_dir, type)
      dothis.dir.copy_children_absolute_path_array_into_absolute_path( 
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
      for _, type in transf.array.index_value_stateless_iter(tblmap.project_type.project_materials_list["omegat"]) do
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
      hs.fnutils.ieach(
        transf.omegat_project_dir.target_files(dir),
        function(file)
          transf.string.string_or_nil_by_evaled_env_bash_stripped("soffice --headless --convert-to txt:Text --outdir"..
          transf.string.single_quoted_escaped(
            transf.omegat_project_dir.target_txt_dir(dir)
          ) ..
          transf.string.single_quoted_escaped(file))
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
    add_local_citable_object_file = function(latex_project_dir, indicated_citable_object_id)
      local local_citable_object_file = transf.indicated_citable_object_id.local_citable_object_file(indicated_citable_object_id)
      dothis.absolute_path.copy_into_absolute_path(
        transf.latex_project_dir.citable_object_files(latex_project_dir),
        local_citable_object_file
      )
    end,
    remove_local_citable_object_file = function(latex_project_dir, indicated_citable_object_id)
      dothis.dir.delete_child_with_leaf_ending(
        transf.latex_project_dir.citable_object_files(latex_project_dir),
        indicated_citable_object_id
      )
    end,
    add_local_citable_object_notes_file = function(latex_project_dir, indicated_citable_object_id)
      local local_citable_object_notes_file = transf.indicated_citable_object_id.local_citable_object_notes_file(indicated_citable_object_id)
      dothis.absolute_path.copy_into_absolute_path(
        transf.latex_project_dir.citable_object_notes_files(latex_project_dir),
        local_citable_object_notes_file
      )
    end,
    remove_local_citable_object_notes_file = function(latex_project_dir, indicated_citable_object_id)
      dothis.dir.delete_child_with_leaf_ending(
        transf.latex_project_dir.citable_object_notes_files(latex_project_dir),
        indicated_citable_object_id
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
      dothis.latex_project_dir.add_local_citable_object_file(
        latex_project_dir,
        indicated_citable_object_id
      )
      dothis.latex_project_dir.add_local_citable_object_notes_file(
        latex_project_dir,
        indicated_citable_object_id
      )
      dothis.latex_project_dir.add_indicated_citable_object_id_raw(
        latex_project_dir,
        indicated_citable_object_id
      )
      dothis.latex_project_dir.write_bib(latex_project_dir)
    end,
    remove_indicated_citable_object_id = function(latex_project_dir, indicated_citable_object_id)
      dothis.latex_project_dir.remove_local_citable_object_file(
        latex_project_dir,
        indicated_citable_object_id
      )
      dothis.latex_project_dir.remove_local_citable_object_notes_file(
        latex_project_dir,
        indicated_citable_object_id
      )
      dothis.latex_project_dir.remove_indicated_citable_object_id_raw(
        latex_project_dir,
        indicated_citable_object_id
      )
      dothis.latex_project_dir.write_bib(latex_project_dir)
    end,
  },
  youtube_playlist_id = {
    --- @param id string
    --- @param do_after? fun(result: string): nil
    delete = function(id, do_after)
      rest({
        api_name = "youtube",
        endpoint = "playlists",
        params = { id = id },
        request_verb = "DELETE",
      }, do_after)
    end,
    --- @param id string
    --- @param video_id string
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
    --- @param id string
    --- @param video_ids string[]
    --- @param do_after? fun(id: string): nil
    add_youtube_video_id_array = function(id, video_ids, do_after)
      local next_vid = transf.array.index_value_stateful_iter(video_ids)
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
    --- @param spec {title?: string, description?: string, privacyStatus?: string, youtube_video_id_array?: string[]}
    --- @param do_after? fun(id: string): nil
    create_youtube_playlist = function(spec, do_after)
      rest({
        api_name = "youtube",
        endpoint = "playlists",
        params = { part = "snippet,status" },
        request_table = {
          snippet = {
            title = spec.title or string.format("Playlist from %s", os.date("%Y-%m-%dT%H:%M:%S%Z")),
            description = spec.description or string.format("Created at %s", os.date("%Y-%m-%dT%H:%M:%S%Z")),
          }
        },
      }, function(result)
        local id = result.id
        hs.timer.doAfter(3, function () -- wait for playlist to be created, seems to not happen instantly
          if spec.youtube_video_id_array then
            dothis.youtube_playlist_id.add_youtube_video_id_array(id, spec.youtube_video_id_array, do_after)
          else
            if do_after then
              do_after(id)
            end
          end
        end)
      end)
    end
    
  },
  array = {
    choose_item = function(array, callback, target_item_chooser_item_specifier_name)
      dothis.choosing_hschooser_specifier.choose_identified_item(
        get.array.choosing_hschooser_specifier(array, target_item_chooser_item_specifier_name),
        callback
      )
    end,
    choose_item_and_action = function(array)
      dothis.array.choose_item(array, dothis.any.choose_action)
    end,
    choose_item_truncated = function(array, callback)
      dothis.array.choose_item(array, callback, "truncated_text")
    end,
    pop = function(array)
      local last = array[#array]
      array[#array] = nil
      return last
    end,
    push = function(array, item)
      array[#array + 1] = item
      return true
    end,
    shift = function(array)
      local first = array[1]
      table.remove(array, 1)
      return first
    end,
    unshift = function(array, item)
      table.insert(array, 1, item)
      return true
    end,
    to_empty_table = function(array)
      for i, v in transf.array.index_value_stateless_iter(array) do
        array[i] = nil
      end
    end,
    sort = table.sort,
    shuffle = get.fn.arbitrary_args_bound_or_ignored_fn(table.sort, {a_use, transf["nil"].random_boolean}),
    remove_by_index = table.remove,
    revove_by_first_item_w_any = function(array, item)
      local index = get.array.pos_int_or_nil_by_first_match_w_t(array, item)
      if index then
        dothis.array.remove_by_index(array, index)
      end
    end,
    insert_at_index = table.insert,
    move_to_index_by_index = function(array, source_index, target_index)
      local item = dothis.array.remove_by_index(array, source_index)
      dothis.array.insert_at_index(array, target_index, item)
    end,
    move_to_index_by_item = function(array, item, index)
      local source_index = get.array.pos_int_or_nil_by_first_match_w_t(array, item)
      if source_index then
        dothis.array.move_to_index_by_index(array, source_index, index)
      end
    end,
    move_to_front_by_item = function(array, item)
      dothis.array.move_to_index_by_item(array, item, 1)
    end,
    move_to_front_or_unshift = function(array, item)
      local index = get.array.pos_int_or_nil_by_first_match_w_t(array, item)
      if index then
        dothis.array.move_to_index_by_index(array, index, 1)
      else
        dothis.array.unshift(array, item)
      end
    end,
    move_to_end_by_item = function(array, item)
      dothis.array.move_to_index_by_item(array, item, #array)
    end,
    filter_in_place = function(array, filterfn)
      local i = 1
      while i <= #array do
        if not filterfn(array[i]) then
          table.remove(array, i)
        else
          i = i + 1
        end
      end
    end,
    each_with_delay = function(array, delay, fn, do_after)
      local next_item = transf.array.index_value_stateful_iter(array)
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
  action_specifier_array = {

  },
  chooser_item_specifier_array = {

  },
  thing_name = {
    
  },
  hschooser_specifier = {
    choose = function(spec, callback)
      local hschooser = get.hschooser_specifier.partial_hschooser(spec, callback)
      hschooser:rows(spec.rows or 30)
      for k, v in transf.table.key_value_stateless_iter(spec.whole_chooser_style_keys) do
        hschooser[k](hschooser, v)
      end
      local choices = get.chooser_item_specifier_array.styled_chooser_item_specifier_array(
        spec.chooser_item_specifier_array,
        spec.chooser_item_specifier_text_key_styledtext_attributes_specifier_dict
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
        get.binary_specifier.inverted(
          tblmap.binary_specifier_name.binary_specifier["inf_no"],
          get.mpv_ipc_socket_id.string(id, key)
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
      transf.string.string_or_nil_by_evaled_env_bash_stripped("mpv " .. transf.stream_creation_specifier.flags_string(spec) .. 
        " --msg-level=all=warn --input-ipc-server=" .. transf.ipc_socket_id.ipc_socket_path(ipc_socket_id) .. " --start=" .. spec.values.start .. " " .. transf.string_array.single_quoted_escaped_string(spec.urls))
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
      return transf.string.string_or_nil_by_evaled_env_bash_stripped(
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
  created_item_specifier_array = {
    create = function(arr, creation_specifier)
      local itm = dothis.creation_specifier.create(creation_specifier)
      dothis.array.push(arr, itm)
      return itm
    end,
    create_all = function(arr, creation_specifier_arr)
      hs.fnutils.each(creation_specifier_arr, function(creation_specifier)
        dothis.created_item_specifier_array.create(arr, creation_specifier)
      end)
    end,
    --- shouldn't I be adding them to the array too????
    get_or_create = function(arr, creation_specifier)
      local created_item_specifier = get.created_item_specifier_array.created_item_specifier_w_creation_specifier(arr, creation_specifier)
      if created_item_specifier then
        return created_item_specifier
      else
        return dothis.created_item_specifier_array.create(arr, creation_specifier)
      end
    end,
    create_or_recreate = function(arr, creation_specifier)
      local idx = get.created_item_specifier_array.pos_int_w_creation_specifier(arr, creation_specifier)
      if idx then
        arr[idx] = dothis.created_item_specifier.recreate(arr[idx])
        return arr[idx]
      else
        return dothis.created_item_specifier_array.create(arr, creation_specifier)
      end
    end,
    create_or_recreate_all = function (arr, creation_specifier_arr)
      hs.fnutils.ieach(creation_specifier_arr, function(creation_specifier)
        dothis.created_item_specifier_array.create_or_recreate(arr, creation_specifier)
      end)
    end
  },
  hotkey_created_item_specifier_array = {
    create_or_recreate_all = function (arr, key_partial_creation_specifier_dict)
      local creation_specifier_arr = get.table_of_assocs.array_of_assocs(key_partial_creation_specifier_dict, "key")
      dothis.created_item_specifier_array.create_or_recreate_all(
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
  stream_created_item_specifier_array = {
    create_background_stream = function(arr, spec)
      local copied_spec = get.table.table_by_copy(spec)
      copied_spec.flag_profile_name = "background"
      copied_spec.type = "stream"
      dothis.created_item_specifier_array.create(arr, copied_spec)
    end,
    create_background_streams = nil -- TODO
  },
  timer_spec = {
    set_next_timestamp_s = function(spec)
      spec.next_timestamp_s = transf.cronspec_string.next_timestamp_s(spec.cronspec_string)
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
  timer_spec_array = {
    fire_all_if_ready_and_space_if_necessary = function(arr)
      local fired = false
      for _, v in transf.array.index_value_stateless_iter(arr) do
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
      dothis.array.push(arr, spec)
      dothis.timer_spec.set_next_timestamp_s(spec)
    end,
    create_by_default_interval = function(arr, fn)
      dothis.timer_spec_array.create(
        arr,
        {
          fn = fn,
          cronspec_string = "*/10 * * * *",
        }
      )
    end
  },
  preference_domain_string = {
    write_default = function(domain, key, value, type)
      transf.string.string_or_nil_by_evaled_env_bash_stripped("defaults write" .. transf.string.single_quoted_escaped(domain) .. transf.string.single_quoted_escaped(key) .. " -" .. type .. " " .. transf.string.single_quoted_escaped(value))
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
      end, refstore.consts.POLLING_INTERVAL)
      timer:start()
    end,
  },
  key_input_spec = {
    exec = function(spec, do_after)
      if spec.mods then
        local mods = get.array.array_by_mapped_w_t_key_dict(spec.mods, normalize.mod)
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
  input_spec_array = {
    exec = function(specarr, wait_time, do_after)
      wait_time = wait_time or transf.float_interval_specifier.random({start=0.10, stop=0.12})
      if #specarr == 0 then
        if do_after then
          do_after()
        end
        return
      end
      hs.timer.doAfter(
        wait_time, 
        function()
          local subspecifier = dothis.array.shift(specarr)
          dothis.input_spec.exec(subspecifier, function()
            dothis.input_spec_array.exec(subspecifier, do_after)
          end)
        end
      )
    end
  },
  input_spec_series_string = {
    exec = function(str, wait_time, do_after)
      dothis.input_spec_array.exec(
        transf.input_spec_series_string.input_spec_array(str),
        wait_time,
        do_after 
      )
    end

  },
  ["nil"] = {
    vdirsyncer_sync = function()
      dothis.string.env_bash_eval_async("vdirsyncer sync")
    end,
    newsboat_reload = function()
      dothis.string.env_bash_eval_async("newsboat -x reload")
    end,
    sox_rec_start_cache = function(do_after)
      dothis.local_absolute_path.start_recording_to(transf.string.in_cache_dir(os.time(), "recording"), do_after)
    end,
    sox_rec_stop = function(do_after)
      dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped("killall rec", do_after)
    end,
    sox_rec_toggle_cache = function(do_after)
      if transf["nil"].sox_is_recording() then
        dothis.sox.sox_rec_stop()
      else
        dothis.sox.sox_rec_start_cache(do_after)
      end
    end,
    mullvad_connect = function()
      dothis.string.env_bash_eval_async("mullvad connect")
    end,
    mullvad_disconnect = function()
      dothis.string.env_bash_eval_async("mullvad disconnect")
    end,
    mullvad_toggle = function()
      if transf["nil"].mullvad_boolean_connected() then
        dothis["nil"].mullvad_disconnect()
      else
        dothis["nil"].mullvad_connect()
      end
    end,
    mbsync_sync  = function()
      dothis.string.env_bash_eval('mbsync -c "$XDG_CONFIG_HOME/isync/mbsyncrc" mb-channel')
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
      dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped('lz4jsoncat "$MAC_FIREFOX_PLACES_SESSIONSTORE_RECOVERY" > "$TMP_FIREFOX_STATE_JSON', do_after)
    end,
    newpipe_extract_backup = function(do_after)
      dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped('cd "$NEWPIPE_STATE_DIR" && unzip *.zip && rm *.zip *.settings', do_after)
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
      dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped("jsonify-tachiyomi-backup", function()
        local tmst_dict = transf.tachiyomi_json_table.timestamp_ms_key_dict_value_dict(transf.json_file.not_userdata_or_function(env.TMP_TACHIYOMI_JSON))
        tmst_dict = get.timestamp_ms_key_dict_value_dict.timestamp_ms_key_dict_value_dict_by_filtered_timestamp(tmst_dict, "tachiyomi")
        dothis.logging_dir.log_timestamp_ms_key_dict_value_dict(
          env.MMANGA_LOGS,
          tmst_dict
        )
        dothis.backup_type_identifier.write_current_timestamp_ms("tachiyomi")
      end)
    end,
    --- do once ff is quit
    ff_backup = function()
      local timestamp = transf.backup_type_identifier.timestamp_ms("firefox")
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
          dothis.logging_dir.log_timestamp_ms_key_dict_value_dict(
            env.MBROWSER_LOGS,
            tbl
          )
          dothis.backup_type_identifier.write_current_timestamp_ms("firefox")
        end
      )
    end,
    newpipe_backup = function()
      dothis["nil"].newpipe_extract_backup(function()
        local timestamp = transf.backup_type_identifier.timestamp_ms("newpipe")
        dothis.sqlite_file.query_w_table_arg_fn(
          env.env.NEWPIPE_STATE_DIR .. "/history.db",
          "SELECT json_group_object(access_date, json_object('title', title, 'url', url))" .. 
          "FROM stream_history " ..
          "INNER JOIN streams ON stream_history.stream_id = streams.uid " ..
          "WHERE access_date > " .. timestamp  .. " " ..
          "ORDER BY timestamp DESC;",
          function(tbl)
            dothis.logging_dir.log_timestamp_ms_key_dict_value_dict(
              env.MMEDIA_LOGS,
              tbl
            )
            dothis.backup_type_identifier.write_current_timestamp_ms("newpipe")
          end
        )
      end)
    end,
    git_backup = function()
      local tbl = {}
      for file in transf.dir.children_absolute_path_value_stateful_iter(env.TMP_GIT_LOG_PARENT) do
        local commit = transf.json_file.not_userdata_or_function(file)
        local timestamp_s = commit.epoch
        commit.epoch = nil
        tbl[timestamp_s * 1000] = commit
      end
      dothis.logging_dir.log_timestamp_ms_key_dict_value_dict(
        env.MDIARY_COMMITS,
        tbl
      )
      dothis.extant_path.empty_dir(env.TMP_GIT_LOG_PARENT)
    end

  },
  backup_type_identifier = {
    write_current_timestamp_ms = function(identifier)
      dothis.local_file.write_file(
        transf.path.ending_with_slash(env.MLAST_BACKUP) .. "tachiyomi",
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
        elseif opts.stringify_table_params and type(param) == "table" then
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
      local cache_path = get.fnname.local_absolute_path_by_in_cache_w_string_and_array_or_nil(fnid, opts_as_str, params)
      dothis.absolute_path.write_file(cache_path, json.encode(result))
    end,
    reset_by_opts = function(fnid, opts_as_str)
      local cache_path = get.fnname.local_absolute_path_by_in_cache_w_string_and_array_or_nil(fnid, opts_as_str)
      dothis.absolute_path.delete(cache_path)
    end,
    reset_by_all = function(fnname)
      dothis.absolute_path.delete(
        transf.fnname.local_absolute_path_by_in_cache(fnname)
      )
    end,
    set_timestamp_s_created_time = function(fnid, opts_as_str, created_time)
      dothis.absolute_path.write_file(get.fnname.local_absolute_path_by_in_cache_w_string_and_array_or_nil(fnid, opts_as_str, "~~~created~~~"), tostring(created_time))
    end
  },
  fn_queue_specifier = {
    update = function(qspec)
      hs.alert.closeSpecific(qspec.alert)
      if #qspec.fn_array == 0 then 
        dothis.hotkey_created_item_specifier.pause(qspec.hotkey_created_item_specifier)
      else
        qspec.alert = dothis.string.alert(
          transf.fn_queue_specifier.string_by_waiting_message(qspec),
          {duration = "indefinite"}
        )
        dothis.hotkey_created_item_specifier.resume(qspec.hotkey_created_item_specifier)
      end
    end,
    push = function(qspec, fn)
      dothis.array.push(qspec.fn_array, fn)
      dothis.fn_queue_specifier.update(qspec)
    end,
    pop = function(qspec)
      local fn = dothis.array.pop(qspec.fn_array)
      fn()
      dothis.fn_queue_specifier.update(qspec)
    end,
  }
}