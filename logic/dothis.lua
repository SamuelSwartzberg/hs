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
  md_file = {
    to_file_in_same_dir = function(source, format, metadata, do_after)
      local target = transf.path.path_by_without_extension(source) .. "." .. tblmap.pandoc_basic_format.extension[format]
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
        act.absolute_path.delete(temp_path)
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
    add_contact_data = function(uuid, type, data)
      type = "contacts/" .. type
      dothis.alphanum_minus_underscore.set_pass_json(uuid, type, data)
    end,
    add_iban = function(uuid, iban)
      dothis.contact_uuid.add_contact_data(uuid, "iban", iban)
    end,
    edit_contact = function(uuid, do_after)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped("khard edit " .. uuid, do_after or function() end)
    end,
  },
  hydrus_file_hash = {
    add_tags = function(str, str_arr, do_after)
      rest({
        api_name = "hydrus",
        endpoint = "add_tags/add_tags",
        request_table = { 
          hash = str,
          service_keys_to_tags = {
            ["6c6f63616c2074616773"] = str_arr
          }
        },
        request_verb = "POST",
      }, do_after)
    end,
    add_url = function(str, url, do_after)
      rest({
        api_name = "hydrus",
        endpoint = "add_urls/associate_url",
        request_table = { 
          hash = str,
          url_to_add = url
        },
        request_verb = "POST",
      }, do_after)
    end,
    add_urls = function(str, url_arr, do_after)
      rest({
        api_name = "hydrus",
        endpoint = "add_urls/associate_urls",
        request_table = { 
          hash = str,
          urls_to_add = url_arr
        },
        request_verb = "POST",
      }, do_after)
    end,
    add_notes = function(str, str_arr, do_after)
      rest({
        api_name = "hydrus",
        endpoint = "add_notes/set_notes",
        request_table = { 
          hash = str,
          notes = transf.two_anys__arr_arr.assoc(str_arr)
        },
        request_verb = "POST",
      }, do_after)
    end,
    add_tags_and_notes = function(str, str_arr, do_after)
      local notes, tags = transf.two_strs__arr_arr.two_two_strs__arr_arrs_by_sep_note_and_tag(str_arr)
      dothis.hydrus_file_hash.add_notes(str, notes, function()
        dothis.hydrus_file_hash.add_tags(str, tags, do_after)
      end)

    end,
    save_into_async_by_hydrus_item = function(str, path)
      dothis.url.download_into_async(
        get.sha256_hex_str.url_by_hydrus_item(str),
        path
      )
    end,
    save_into_sync_by_hydrus_item = function(str, path)
      dothis.url.download_into_sync(
        get.sha256_hex_str.url_by_hydrus_item(str),
        path
      )
    end,
  },
  hydrus_file_hash_arr = {
    create_stream = function(arr, flag_profile_name)
      dothis.created_item_specifier_arr.create(
        stream_arr,
        get.hydrus_file_hash_arr.stream_creation_specifier(arr, flag_profile_name)
      )
    end,
    write_stream_metadata_to_cache_and_create_stream = function(arr, flag_profile_name)
      act.hydrus_file_hash_arr.write_stream_metadata_to_cache(arr)
      dothis.hydrus_file_hash_arr.create_stream(arr, flag_profile_name)
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
      dothis.str.env_bash_eval("yes " .. transf.not_userdata_or_fn.single_quoted_escaped(data) .. " | pass add " .. type .. "/" .. name)
    end,
    add_as_passw_pass_item_name = function(name, password)
      dothis.alphanum_minus_underscore.add_as_pass_item_name(name, "p/passw", password)
    end,
    add_as_username_pass_item_name = function(name, username)
      dothis.absolute_path.write_file(
        get.pass_item_name.local_absolute_path(name, "p/username", "txt"),
        username
      )
    end,
  },
  auth_pass_item_name = {
    rename = function(name, type, new_name)
      dothis.pass_item_name.rename(name, "p/" .. type, new_name)
    end,
    remove = function(name, type)
      dothis.pass_item_name.remove(name, "p/" .. type)
    end,
  },
  contact_table = {
    add_iban = function(contact_table, iban)
      dothis.contact_uuid.add_iban(transf.contact_table.contact_uuid(contact_table), iban)
    end,
  },
  youtube_video_id = {
    
  },
  youtube_video_url = {
    --- max info ≙ try to get the best quality of everything, and try to embed as much metadata as possible.
    download_to_max_info = function(url, target, do_after)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped(
        "yt-dlp --embed-subs --embed-thumbnail --embed-chapters --embed-metadata --embed-info-json --format bestvideo+bestaudio/best" .. transf.str.str_by_single_quoted_escaped(url) .. " -o" .. transf.str.str_by_single_quoted_escaped(target),
        do_after
      )
    end,
    add_to_hydrus = function(url, str_arr, do_after)
      local video_id = transf.youtube_video_url.youtube_video_id(url)
      local cache_path = transf.str.in_cache_local_absolute_path(video_id, "ytdl")
      dothis.youtube_video_url.download_to_max_info(
        url,
        cache_path,
        function()
          dothis.local_hydrusable_file.add_to_hydrus_by_path(
            cache_path,
            transf.arr_or_nil_and_any.arr(str_arr, {"proximate_source_description", transf.youtube_video_id.str_by_description(url)}),
            function(hash)
              act.file.delete_file(cache_path)
              dothis.hydrus_file_hash.add_url(
                hash,
                url
              )
              do_after(hash)
            end
          )
        end
      )
    end,
  },
  url = {
    download_to_async = function(url, target)
      act.str.env_bash_eval_async("curl -L " .. transf.str.str_by_single_quoted_escaped(url) .. " -o " .. transf.str.str_by_single_quoted_escaped(target))
    end,
    download_to_sync = function(url, target)
      act.str.env_bash_eval_sync("curl -L " .. transf.str.str_by_single_quoted_escaped(url) .. " -o " .. transf.str.str_by_single_quoted_escaped(target))
    end,
    download_into_async = function(url, target_dir)
      act.str.env_bash_eval_async("cd " .. transf.str.str_by_single_quoted_escaped(target_dir) .. "&& curl -L " .. transf.str.str_by_single_quoted_escaped(url) .. " -O")
    end,
    download_into_sync = function(url, target_dir)
      act.str.env_bash_eval_sync("cd " .. transf.str.str_by_single_quoted_escaped(target_dir) .. "&& curl -L " .. transf.str.str_by_single_quoted_escaped(url) .. " -O")
    end,
    download_pdf_to_sync = function(url, target)
      act.str.env_bash_eval_sync("pdfgen" .. transf.str.str_by_single_quoted_escaped(url) .. transf.str.str_by_single_quoted_escaped(target))
    end,
      
    add_event_from_url = function(url, calendar)
      local temp_path_arg = transf.str.str_by_single_quoted_escaped(env.TMPDIR .. "/event_downloaded_at_" .. os.time() .. ".ics")
      dothis.str.env_bash_eval('curl' .. transf.str.str_by_single_quoted_escaped(url) .. ' -o' .. temp_path_arg .. '&& khal import --include-calendar ' .. calendar .. temp_path_arg)
    end,
    add_to_hydrus = function(url, str_arr, do_after)
      local request_table = { url = url }
      if str_arr then
        request_table.service_keys_to_additional_tags = {
          ["6c6f63616c2074616773"] = str_arr
        }
      end
      rest({
        api_name = "hydrus",
        endpoint = "add_urls/add_url",
        request_table = request_table,
        request_verb = "POST",
      }, do_after)
    end,
  },
  otp_url = {
    add_otp_pass_item = function(url, name)
      act.str.env_bash_eval_async(
        "echo" ..
        transf.str.str_by_single_quoted_escaped(url) ..
        "| pass otp insert otp/" .. name
      )
    end,
  },
  table = {
    write_ics_file = function(tbl, path)
      local tmpdir_json_path = transf.not_userdata_or_fn.in_tmp_local_absolute_path(tbl) .. ".json"
      local tmpdir_ics_path = transf.not_userdata_or_fn.in_tmp_local_absolute_path(tbl) .. ".ics"
      dothis.absolute_path.write_file(tmpdir_json_path, json.encode(tbl))
      act.str.env_bash_eval_sync(
        "ical2json" ..
        "-r" ..
        transf.str.str_by_single_quoted_escaped(tmpdir_ics_path)
      )
      act.absolute_path.delete(tmpdir_json_path)
      if path then
        dothis.extant_path.move_to_absolute_path(tmpdir_ics_path, path)
        act.absolute_path.delete(tmpdir_ics_path)
      end
    end,
    choose_w_pair_arg_fn = function(tbl, fn, chooser_item_specifier_modifier)
      dothis.arr.choose_item(
        transf.table.two_anys__arr_by_sorted_smaller_key_first(tbl),
        fn,
        chooser_item_specifier_modifier
      )
    end,
    choose_w_kt_vt_arg_fn = function(tbl, fn, chooser_item_specifier_modifier)
      dothis.arr.choose_item(
        transf.table.two_anys__arr_by_sorted_smaller_key_first(tbl),
        function(two_anys__arr)
          fn(transf.two_anys__arr.two_ts(two_anys__arr))
        end,
        chooser_item_specifier_modifier
      )
    end,
    choose_w_kt_fn = function(tbl, fn, chooser_item_specifier_modifier)
      dothis.arr.choose_item(
        transf.table.two_anys__arr_by_sorted_smaller_key_first(tbl),
        function(two_anys__arr)
          fn(transf.two_anys__arr.t_by_first(two_anys__arr))
        end,
        chooser_item_specifier_modifier
      )
    end,
    choose_w_vt_fn = function(tbl, fn, chooser_item_specifier_modifier)
      dothis.arr.choose_item(
        transf.table.two_anys__arr_by_sorted_smaller_key_first(tbl),
        function (two_anys__arr)
          fn(transf.two_anys__arr.t_by_second(two_anys__arr))
        end,
        chooser_item_specifier_modifier
      )
    end,
    choose_kt_w_kt_fn = function(tbl, fn, chooser_item_specifier_modifier)
      dothis.arr.choose_item(
        transf.table.kt_arr_by_sorted_smaller_first(tbl),
        fn,
        chooser_item_specifier_modifier
      )
    end,
    choose_vt_w_vt_fn = function(tbl, fn, chooser_item_specifier_modifier)
      dothis.arr.choose_item(
        transf.table.vt_arr_by_sorted_smaller_first(tbl),
        fn,
        chooser_item_specifier_modifier
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
      return hs.alert.show(str, {extSize = 12, textFont = "Noto Sans Mono", atScreenEdge = 1, radius = 3} --[[ @as table ]], duration)
    end,
    say = function(str, lang)
      speak:voice(tblmap.iso_639_1_language_code.mac_voice_name_by_default[lang]):speak(transf.str.line_by_folded(str))
    end,
    search = function(str, search_engine_id)
      dothis.url_or_local_path.open_browser(
        get.search_engine_id.url_by_search(search_engine_id, str)
      )
    end,
    raw_bash_eval_w_str_or_str_and_8_bit_pos_int_arg_fn = function(str, fn)
      local callback
      if fn then
        callback = function (...) fn(transf.number_and_two_anys.any_or_any_and_number_by_zero(...)) end
      else
        callback = function (...) end
      end
      local task = hs.task.new(
        "/opt/homebrew/bin/bash",
        callback,
        { "-c", transf.str.str_by_minimal_locale_setter_commands_prepended(
          str
        )}
      )
      task:start()
      return task
    end,
    env_bash_eval_w_str_or_str_and_8_bit_pos_int_arg_fn = function(str, fn)
      local callback 
      if fn then
        callback = function (...) fn(transf.number_and_two_anys.any_or_any_and_number_by_zero(...)) end
      else
        callback = function (...) end
      end
      local task = hs.task.new(
        "/opt/homebrew/bin/bash",
        callback,
        { "-c", transf.str.str_by_env_getter_comamnds_prepended(
          str
        )}
      )
      task:start()
      return task
    end,

    env_bash_eval_w_str_or_str_and_8_bit_pos_int_arg_fn_by_stripped = function(str, fn)
      dothis.str.env_bash_eval_w_str_or_str_and_8_bit_pos_int_arg_fn(
        str,
        get.n_any_arg_fn.n_t_arg_fn_w_n_any_arg_n_t_ret_fn(fn or function(...) end, transf.str_and_n_anys.str_and_n_anys_by_stripped)
      )
    end,
    env_bash_eval_w_str_or_nil_arg_fn_by_stripped = function(str, fn)
      dothis.str.env_bash_eval_w_str_or_str_and_8_bit_pos_int_arg_fn_by_stripped(
        str,
        get.n_any_arg_fn.n_t_arg_fn_w_n_any_arg_n_t_ret_fn(fn or function(...) end, transf.str_and_number_or_nil.str_or_nil_by_number)
      )
    end,
    env_bash_eval_w_str_arg_fn_str_arg_fn_by_stripped = function(str, succfn, failfn)
      dothis.str.env_bash_eval_w_str_or_str_and_8_bit_pos_int_arg_fn_by_stripped(
        str,
        function(res, code)
          if code then
            (failfn or function() end)("Exit code " .. code .. " for command " .. str ". Stderr:\n\n" .. res)
          else
            (succfn or function() end)(res)
          end
        end
      )
    end,
    env_bash_eval_w_str_or_nil_arg_fn_by_stripped_noempty = function(str,fn)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped(
        str,
        function(str_or_nil)
          if str_or_nil == "" then str_or_nil = nil end
          if fn then
            fn(str_or_nil)
          end
        end
      )
    end,
    env_bash_eval_w_str_arg_fn_str_arg_fn_by_stripped_noempty = function(str, succfn, failfn)
      dothis.str.env_bash_eval_w_str_arg_fn_str_arg_fn_by_stripped(
        str,
        function(str)
          if str == "" then (failfn or function() end)("Empty str for command " .. str) else (succfn or function() end)(str) end
        end,
        failfn
      )
    end,
    env_bash_eval_w_not_userdata_or_fn_or_nil_arg_fn_by_parsed_json = function(str, fn)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped_noempty(
        str,
        function(str_or_nil)
          str_or_nil = transf.fn.rt_or_nil_ret_fn_by_pcall(transf.json_str.not_userdata_or_fn)(str_or_nil)
          if fn then
            fn(str_or_nil)
          end
        end
      )
    end,
    env_bash_eval_w_not_userdata_or_fn_arg_fn_str_arg_fn_by_parsed_json = function(str, succfn, failfn)
      dothis.str.env_bash_eval_w_str_arg_fn_str_arg_fn_by_stripped_noempty(
        str,
        function(str)
          local succ, res = pcall(transf.json_str.not_userdata_or_fn, str)
          if succ then
            if succfn then succfn(res) end
          else
            if failfn then failfn(res) end
          end
        end,
        failfn
      )
    end,
    env_bash_eval_w_table_or_nil_arg_fn_by_parsed_json = function(str, fn)
      dothis.str.env_bash_eval_w_not_userdata_or_fn_or_nil_arg_fn_by_parsed_json(
        str,
        function(arg)
          if not is.any.table(arg) then arg = nil end
          if fn then fn(arg) end
        end
      )
    end,
    env_bash_eval_w_table_arg_fn_str_arg_fn = function(str, succfn, failfn)
      dothis.str.env_bash_eval_w_not_userdata_or_fn_arg_fn_str_arg_fn_by_parsed_json(
        str,
        function(arg)
          if not is.any.table(arg) then 
            if failfn then failfn("Not a table: " .. arg) end
          else 
            if succfn then succfn(arg) end
          end
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
          if arg.error then 
            if failfn then failfn(arg.error) end
          else 
            if succfn then succfn(arg) end
          end
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
        dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped("open -a Safari -W" .. transf.str.str_by_single_quoted_escaped(url), do_after)
        -- Annoyingly, due to a 15 (!) year old bug, Firefox will open the url as well, even if we specify a different browser. I've tried various fixes, but for now we'll just have to live with it and click the tab away manually.
      else
        dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped("open -a" .. transf.str.str_by_single_quoted_escaped(browser))
      end
    end,
  },
  local_path = {
    open_app = function(path, app, do_after)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped("open -a " .. transf.str.str_by_single_quoted_escaped(app) .. " " .. transf.str.str_by_single_quoted_escaped(path), do_after)
    end,
    write_nonabsolute_path_key_str_or_str_arr_value_assoc = function(path, nonabsolute_path_key_assoc, extension)
      act.absolute_path_key_str_or_str_arr_assoc.write(
        get.local_nonabsolute_path_key_assoc.local_absolute_path_key_assoc(nonabsolute_path_key_assoc, path, extension)
      )
    end,
    write_dynamic_structure = function(path, name)
      dothis.local_path.write_nonabsolute_path_key_str_or_str_arr_value_assoc(
        path,
        tblmap.dynamic_structure_name.leaflike_key_str_or_str_arr_value_assoc[name]
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
          get.str.any_by_evaled_as_lua(template_path),
          path
        )
      )
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
    write_file = function(path, contents)
      act.absolute_path.create_parent_dir(path)
      dothis.file.write_file(path, contents)
    end,
    append_or_write_file = function(path, contents)
      act.absolute_path.create_parent_dir(path)
      dothis.file.append_or_write_file(path, contents)
    end,
    append_file_if_file = function(path, contents)
      if is.absolute_path.file(path) then
        act.absolute_path.create_parent_dir(path)
        dothis.file.append_file(path, contents)
      end
    end,
    write_file_if_nonextant_path = function(path, contents)
      if is.absolute_path.nonextant_path(path) then
        act.absolute_path.create_parent_dir(path)
        dothis.file.write_file(path, contents)
      end
    end,
    write_file_if_file = function(path, contents)
      if is.absolute_path.file(path) then
        act.absolute_path.create_parent_dir(path)
        dothis.file.write_file(path, contents)
      end
    end,
  },


  labelled_remote_absolute_path = {
    
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
  local_extant_path = {
    do_in_path = function(path, cmd, do_after)
      if is.path.dir(path) then
        dothis.dir.do_in_path(path, cmd, do_after)
      else
        dothis.dir.do_in_path(transf.path.trimmed_noweirdwhitespace_line_by_parent_path(path), cmd, do_after)
      end
    end,
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
      act.local_extant_path.delete(path)
    end,
    link_to_nosudo_nonextant_path = function(path, tgt)
      act.absolute_path.create_parent_dir(tgt)
      hs.fs.link(path, tgt, true)
    end,
    link_to_local_nonextant_path = function(path, tgt)
      act.absolute_path.create_parent_dir(tgt)
      act.str.env_bash_eval_sync(
        "pass passw/os | sudo -S ln -s " .. transf.str.str_by_single_quoted_escaped(path) .. transf.str.str_by_single_quoted_escaped(tgt)
      )
    end,
    link_to_local_absolute_path = function(path, tgt)
      act.absolute_path.delete(tgt)
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
        get.fn.fn_by_arbitrary_args_bound_or_ignored(
          dothis.local_extant_path.link_into_local_absolute_path,
          {consts.use_singleton, tgt}
        )
      )
    end,
  },
  
  labelled_remote_file = {
    write_file = function(path, contents)
      local temp_file = transf.str.in_tmp_local_absolute_path(path, "labelled_remote_temp_file")
      dothis.local_extant_path.write_file(temp_file, contents)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("rclone copyto" .. transf.str.str_by_single_quoted_escaped(temp_file) .. " " .. transf.str.str_by_single_quoted_escaped(path))
      act.absolute_path.delete(temp_file)
    end,
    append_or_write_file = function(path, contents)
      local temp_file = transf.str.in_tmp_local_absolute_path(path, "labelled_remote_temp_file")
      dothis.local_extant_path.append_or_write_file(temp_file, contents)
      dothis.labelled_remote_file.write_file(path, transf.local_file.str_by_contents(temp_file))
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
  local_file = {
    write_file = function(path, contents)
      local file = io.open(path, "w")
      if not file then error("Couldn't open file in mode 'w': " .. path) end
      file:write(contents)
      file:close()
    end,
    append_or_write_file = function(path, contents)
      local file = io.open(path, "a")
      if not file then error("Couldn't open file in mode 'a': " .. path) end
      file:write(contents)
      file:close()
    end,
    copy_to_local_absolute_path = function(path, tgt)
      dothis.local_extant_path.create_parent_dir(tgt)
      plfile.copy(path, tgt)
    end,
  },
  local_dir = {

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
    
    copy_to_absolute_path = function(path, tgt)
      act.absolute_path.create_parent_dir(tgt)
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
      act.absolute_path.create_parent_dir(tgt)
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
      act.extant_path.delete(path)
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
      dothis.created_item_specifier_arr.create(
        stream_arr,
        get.extant_path.stream_creation_specifier_by_descendant_m3u_file_content_lines(path, flag_profile_name)
      )
    end,
  },
  extant_path_arr = {
    copy_into_absolute_path = function(arr, tgt)
      dothis.arr.each(
        arr,
        get.fn.fn_by_arbitrary_args_bound_or_ignored(dothis.extant_path.copy_into_absolute_path, {consts.use_singleton, tgt})
      )
    end,
    move_into_absolute_path = function(arr, tgt)
      dothis.arr.each(
        arr,
        get.fn.fn_by_arbitrary_args_bound_or_ignored(dothis.extant_path.move_into_absolute_path, {consts.use_singleton, tgt})
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
  },
  local_image_file = {
    add_as_otp = function(path, name)
      dothis.otp_url.add_otp_pass_item(
        transf.local_image_file.multiline_str_by_qr_data(path),
        name
      )
    end,
    add_to_hydrus_by_url = function(path, str_arr)
      local booru_url = transf.local_image_file.booru_post_url(path)
      if booru_url then
        act.url.add_to_hydrus(
          booru_url,
          str_arr
        )
      end
    end,
  },
  local_hydrusable_file = {
    add_to_hydrus_by_path = function(path, str_arr, do_after)
      act.local_hydrusable_file.add_to_hydrus_by_path(
        path,
        function(hash)
          dothis.hydrus_file_hash.add_tags_and_notes(hash, str_arr, function()
            do_after(hash)
          end)
        end
      )
    end,
    --- implements smart adding of image files to hydrus
    --- caveat: must be images in danbooru or similar enough to images that might be found in danbooru
    --- for ai tags to work
    --- - all type of art should work
    --- - real life photos mostly work
    --- - screenshots etc. don't work
    --- - physical documents don't really work
    add_to_hydrus_by_path_or_url = function(path, use_ai_tags, do_after)
      local booru_url
      local is_image = is.local_file.local_image_file(path)
      if is_image then
        booru_url = transf.local_image_file.booru_post_url(path)
      end
      if booru_url then
        --- if there's a booru post url, the only thing we will take from the file is the date
        local date = transf.local_file.rfc3339like_dt_by_any_source(path)
        dothis.url.add_to_hydrus(
          booru_url,
          { "date:" .. date },
          do_after
        )
      else
        dothis.local_hydrusable_file.add_to_hydrus_by_path(
          path,
          transf.local_file.line_arr_by_file_tags(path),
          function(sha)
            if use_ai_tags then
              act.hydrus_file_hash.add_tags_to_hydrus_item_by_ai_tags(
                sha,
                function()
                  if do_after then do_after(sha) end
                end
              )
            else
              if do_after then do_after(sha) end
            end
          end
        )
      end
    end
  },
  local_zip_file = {
    unzip_to_absolute_path = function(path, tgt)
      act.absolute_path.create_parent_dir(tgt)
      transf.str.str_or_nil_by_evaled_env_bash_stripped("unzip " .. transf.str.str_by_single_quoted_escaped(path) .. " -d " .. transf.str.str_by_single_quoted_escaped(tgt))
    end,
    unzip_into_absolute_path = function(path, tgt)
      local finaltgt = transf.path.path_by_ending_with_slash(tgt) .. transf.path.leaflike_by_filename(path)
      dothis.local_zip_file.unzip_to_absolute_path(path, finaltgt)
    end,
    
  },
  plaintext_file = {
    append_lines = function(path, lines)
      local contents = transf.plaintext_file.str_by_one_final_newline(path)
      dothis.absolute_path.write_file_if_file(path, contents .. get.str_or_number_arr.str_by_joined(lines, "\n"))
    end,
    append_line = function(path, line)
      dothis.plaintext_file.append_lines(path, {line})
    end,
    append_line_and_commit = function(path, line)
      dothis.plaintext_file.append_line(path, line)
      dothis.in_git_dir.commit_self(path, "Added line " .. line .. " to " .. get.local_absolute_path.local_nonabsolute_path_by_from(path, transf.in_git_dir.git_root_dir(path)))
    end,
    write_lines = function(path, lines)
      dothis.absolute_path.write_file_if_file(path, get.str_or_number_arr.str_by_joined(lines, "\n"))
    end,
    set_line = function(path, line, line_number)
      local lines = transf.plaintext_file.line_arr(path)
      lines[line_number] = line
      dothis.plaintext_file.write_lines(path, lines)
    end,
    remove_line_w_pos_int = function(path, line_number)
      local lines = transf.plaintext_file.line_arr(path)
      dothis.arr.remove_by_index(lines, line_number)
      dothis.plaintext_file.write_lines(path, lines)
    end,
    remove_line_w_fn = function(path, cond)
      local lines = transf.plaintext_file.line_arr(path)
      local index = get.arr.pos_int_or_nil_by_first_match_w_fn(lines, cond)
      dothis.plaintext_file.remove_line_w_pos_int(path, index)
    end,
    remove_line_w_str = function(path, cond)
      local lines = transf.plaintext_file.line_arr(path)
      local index = get.arr.pos_int_or_nil_by_first_match_w_t(lines, cond)
      dothis.plaintext_file.remove_line_w_pos_int(path, index)
    end,
    find_remove_nohashcomment_noindent_line = function(path, cond)
      local lines = transf.plaintext_file.line_arr(path)
      local index = get.arr.pos_int_or_nil_by_first_match_w_fn(lines, function(line)
        local nohashcomment_noindent = transf.line.noempty_nohashcomment_line_by_extract(line)
        return findsingle(nohashcomment_noindent, cond)
      end)
      dothis.plaintext_file.remove_line_w_pos_int(path, index)
    end,

  },
  plaintext_table_file = {
    append_arr_field_arr = function(path, arr_field_arr)
      local lines = get.arr.only_pos_int_key_table_by_mapped_w_t_arg_t_ret_fn(arr_field_arr, function (arr)
        return get.str_or_number_arr.str_by_joined(arr, transf.plaintext_table_file.utf8_char_by_field_separator())
      end)
      dothis.plaintext_file.append_lines(path, lines)
    end,

  },
  plaintext_url_or_local_path_file = {
    open_all = function(path, browser)
      dothis.arr.each(
        transf.plaintext_file.noempty_noindent_nohashcomment_line_arr(path),
        get.fn.fn_by_arbitrary_args_bound_or_ignored(dothis.url_or_local_path.open_browser, {consts.use_singleton, browser})
      )
    end,
  },
  maildir_file ={
    download_attachment_to_cache = function(path, name, do_after)
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
    
    move = function(source, target)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped(
        "mdeliver" .. transf.str.str_by_single_quoted_escaped(target) ..
        "<" .. transf.str.str_by_single_quoted_escaped(source),
        function()
          dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped(
            "minc" .. transf.str.str_by_single_quoted_escaped(target), -- incorporate the message (/cur -> /new, rename in accordance with the mblaze rules and maildir spec)
            function ()
              act.str.env_bash_eval_async(
                "rm" .. transf.str.str_by_single_quoted_escaped(source)
              )
            end
          )
        end
      )
        
    end,
      
    
  },
  dir = {
    do_in_path = function(path, cmd, do_after)
      dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped("cd " .. transf.str.str_by_single_quoted_escaped(path) .. " && " .. cmd, do_after or function() end)
    end,
    delete_child_with_leaf_ending = function(path, ending)
      dothis.absolute_path.delete(
        get.dir.extant_path_by_child_having_leaf_ending(path, ending)
      )
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
          url = transf.youtube_channel_id.youtube_channel_video_feed_url(channel_id),
          title = transf.youtube_channel_id.line_by_channel_title(channel_id),
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
          title = transf.url.str_or_nil_by_sgml_title(url),
          category = category,
        }
      )
    end,
  },
  audiodevice = {
    set_default = function(device, type)
      device["setDefault" .. transf.str.str_by_first_eutf8_upper(type) .. "Device"](device)
    end,
  },

  ics_file = {
    add_events_from_file = function(path, calendar)
      dothis.str.env_bash_eval("khal import --include-calendar " .. calendar .. " " .. transf.str.str_by_single_quoted_escaped(path))
    end,
  },
  git_root_dir = {
    run_hook =  function(path, hook)
      local hook_path = get.git_root_dir.in_git_dir_by_hook_path(path, hook)
      dothis.str.env_bash_eval(hook_path)
    end,
    add_hook = function(path, hook_path, name)
      name = name or transf.path.leaflike_by_filename(hook_path)
      dothis.extant_path.copy_to_absolute_path(hook_path, get.git_root_dir.in_git_dir_by_hook_path(path, name))
      act.local_extant_path.make_executable(get.git_root_dir.in_git_dir_by_hook_path(path, name))
    end,
    copy_hook = function(path, type, name)
      type = type or "default"
      local source_hook = env.GITCONFIGHOOKS .. "/" .. type .. "/" .. name
      act.local_extant_path.make_executable(source_hook)
      dothis.extant_path.copy_to_absolute_path(source_hook, get.git_root_dir.in_git_dir_by_hook_path(path, name))
    end,
    link_hook = function(path, type, name)
      type = type or "default"
      local source_hook = env.GITCONFIGHOOKS .. "/" .. type .. "/" .. name
      act.local_extant_path.make_executable(source_hook)
      dothis.local_extant_path.link_to_nosudo_nonextant_path(source_hook, get.git_root_dir.in_git_dir_by_hook_path(path, name))
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
    commit_self = function(path, message, do_after)
      dothis.local_extant_path.do_in_path(
        path, 
        "git commit -m" ..
        transf.str.str_by_single_quoted_escaped(
          message or 
          (
            "Programmatic commit of " .. path .. " at " .. 
            transf["nil"].full_rfc3339like_dt_by_current()
          )
        ),
        do_after
      )
    end,
    commit_staged = function(path, message, do_after)
      dothis.local_extant_path.do_in_path(
        path, 
        "git commit -m" .. 
        transf.str.str_by_single_quoted_escaped(
          message or 
          (
            "Programmatic commit of staged files at " .. 
            transf["nil"].full_rfc3339like_dt_by_current()
          )
        ),
        do_after
      )
    end,
    commit_all = function(path, message, do_after)
      act.in_git_dir.add_all(path, function()
        dothis.in_git_dir.commit_staged(path, message, do_after)
      end)
    end,
    commit_all_root = function(path, message, do_after)
      act.in_git_dir.add_all_root(path, function()
        dothis.in_git_dir.commit_staged(transf.in_git_dir.git_root_dir(path), message, do_after)
      end)
    end,
    commit_all_root_no_untracked = function(path, message, do_after)
      dothis.local_extant_path.do_in_path(
        transf.in_git_dir.git_root_dir(path), 
        "git commit -am" .. 
        transf.str.str_by_single_quoted_escaped(
          message or 
          (
            "Programmatic commit of all tracked files at " .. 
            transf["nil"].full_rfc3339like_dt_by_current()
          )
        ),
        do_after
      )
    end
  },
  logging_dir = {
    log_nonabsolute_path_key_timestamp_ms_key_assoc_value_assoc_by_ymd = function(path, assoc)
      local abs_path_assoc = get.local_nonabsolute_path_key_assoc.local_absolute_path_key_assoc(
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
        transf.timestamp_ms_key_assoc_value_assoc.local_nonabsolute_path_key_timestamp_ms_key_assoc_value_assoc_by_ymd(timestamp_ms_key_assoc_value_assoc)
      )
    end,
  },
  json_file = {
    merge_w_table = function(path, table)
      local tblcnt = get.json_file.table_or_nil(path)
      local newcnt = transf.two_table_or_nils.table_by_take_new(tblcnt, table)
      dothis.local_file.write_file(
        path,
        transf.not_userdata_or_fn.json_str(newcnt)
      )
    end
  },
  entry_logging_dir = {
    log_str = function(path, str)
      local ts = os.time() * 1000
      dothis.logging_dir.log_timestamp_ms_key_assoc_value_assoc(path, {
        [ts] = {
          entry = str,
          timestamp_ms = ts
        }
      })
    end,
  },
  timestamp_s = {
    do_at = function(timestamp, fn)
      local last_midnight = transf["nil"].timestamp_s_by_last_midnight()
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
      act.str.paste_le(transf.str.join(arr, sep))
    end,
  },
  url_arr = {
    open_all = function(url_arr, browser)
      for _, url in transf.arr.pos_int_vt_stateless_iter(url_arr) do
        dothis.url_or_local_path.open_browser(url, browser)
      end
    end,
    create_as_url_files = function(url_arr, path)
      local abs_path_assoc = get.url_arr.local_absolute_path_key_url_value_assoc(url_arr, path)
      act.absolute_path_str_value_assoc.write(abs_path_assoc)
    end,
    create_as_session = function(url_arr, root)
      local path = transf.local_absolute_path.local_absolute_path_by_prompted_multiple_from_default(root)
      path = get.str.str_by_with_suffix(path, ".session")
      dothis.absolute_path.write_file(
        path,
        transf.url_arr.str_by_urls_potentially_with_comments(url_arr)
      )
    end,
    
  },
  sgml_url_arr = {
   
  },
  absolute_path_key_assoc = {

  },

  mac_application_name = {
    execute_full_action_path = function(application_name, full_action_path)
      dothis.running_application.execute_full_action_path(
        transf.mac_application_name.running_application_or_nil(application_name),
        full_action_path
      )
    end,
    open_recent = function(application_name, item)
      dothis.mac_application_name.execute_full_action_path(
        application_name,
        transf.arr_and_any.arr(
          tblmap.mac_application_name.str_arr_by_recent_full_action_path[application_name],
          item
        )
      )
    end,
    --- if you need `fn` to take args, bind them beforehand
    do_with_activated = function(application_name, fn)
      local prev_app = hs.application.frontmostApplication()
      act.mac_application_name.activate(application_name)
      local retval = {fn()}
      act.running_application.activate(prev_app)
      return transf.arr.n_anys(retval)
    end,
      
  },
  window = {
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
      act.window.make_main(window)
      do_with_window_as_main(application, window)
      act.window.make_main(main_window)
    end,
  },
  api_name = {
    write_api_key = function(api_name, value)
      dothis.absolute_path.write_file(
        transf.api_name.local_absolute_path_by_api_key_file(api_name),
        value
      )
    end,
    write_access_token = function(api_name, value)
      dothis.absolute_path.write_file(
        transf.api_name.local_absolute_path_by_access_token_file(api_name),
        value
      )
    end,
    write_refresh_token = function(api_name, value)
      dothis.absolute_path.write_file(
        transf.api_name.local_absolute_path_by_refresh_token_file(api_name),
        value
      )
    end,
    write_client_id = function(api_name, value)
      dothis.absolute_path.write_file(
        transf.api_name.local_absolute_path_by_client_id_file(api_name),
        value
      )
    end,
    write_client_secret = function(api_name, value)
      dothis.absolute_path.write_file(
        transf.api_name.local_absolute_path_by_client_secret_file(api_name),
        value
      )
    end,
    write_authorization_code = function(api_name, value)
      dothis.absolute_path.write_file(
        transf.api_name.local_absolute_path_by_authorization_code_file(api_name),
        value
      )
    end,
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
  running_application = {
    execute_full_action_path = function(running_application, full_action_path)
      running_application:selectMenuItem(full_action_path)
    end,
  },
  envlike_str = {
    write_and_check = function(str, path)
      dothis.absolute_path.write_file(path, str)
      local errors = transf.shell_script_file.str_or_nil_by_gcc_style_errors(path)
      if errors then
        error("env file " .. path .. " has errors:\n" .. errors)
      end
    end,
   
  },
  citable_object_id = {
    save_mcitations_csl_file = function(citable_object_id, indication)
      local csl_table = transf[indication].csl_table_by_online(citable_object_id)
      dothis.absolute_path.write_file(
        env.MCITATIONS .. "/" .. transf.csl_table.citable_filename(csl_table) .. ".json",
        transf.not_userdata_or_fn.json_str(csl_table)
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
        transf.indicated_citable_object_id.noempty_noindent_hashcomment_line_by_for_citations_file(indicated_citable_object_id)
      )
    end,
    remove_indicated_citable_object_id = function(citations_file, indicated_citable_object_id)
      dothis.plaintext_file.find_remove_nohashcomment_noindent_line(
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
        get.project_dir.local_absolute_path_by_global_subtype_project_material(project_dir, type, subtype),
        get.project_dir.local_absolute_path_local_subtype_project_material(project_dir, type, subtype)
      )
    end,
    push_subtype_project_materials = function(project_dir, type, subtype)
      dothis.dir.copy_children_absolute_path_arr_into_absolute_path( 
        get.project_dir.local_absolute_path_local_subtype_project_material(project_dir, type, subtype),
        get.project_dir.local_absolute_path_by_global_subtype_project_material(project_dir, type, subtype)
      )
    end,
    pull_universal_project_materials = function(project_dir, type)
      dothis.dir.copy_children_absolute_path_arr_into_absolute_path( 
        get.project_dir.local_absolute_path_global_by_universal_project_material(project_dir, type),
        get.project_dir.local_absolute_path_by_local_universal_project_material(project_dir, type)
      )
    end,
    push_universal_project_materials = function(project_dir, type)
      dothis.dir.copy_children_absolute_path_arr_into_absolute_path( 
        get.project_dir.local_absolute_path_by_local_universal_project_material(project_dir, type),
        get.project_dir.local_absolute_path_global_by_universal_project_material(project_dir, type)
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
    create_and_open_new_source_odt = function(omegat_project_dir, name) -- while we support any source file, if we manually create a file, it should be an odt
      dothis.absolute_path.write_file_if_nonextant_path(
        transf.omegat_project_dir.local_extant_path_by_source_dir(omegat_project_dir) .. "/" .. name .. ".odt"
      )
      act.local_path.open_default(
        transf.omegat_project_dir.local_extant_path_by_source_dir(omegat_project_dir) .. "/" .. name .. ".odt"
      )
    end,
   
      
  },
  latex_project_dir = {      
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
      act.latex_project_dir.write_bib(latex_project_dir)
    end,
    remove_indicated_citable_object_id = function(latex_project_dir, indicated_citable_object_id)
      dothis.latex_project_dir.remove_indicated_citable_object_id_raw(
        latex_project_dir,
        indicated_citable_object_id
      )
      act.latex_project_dir.write_bib(latex_project_dir)
    end,
  },
  local_svg_file = {
    to_png = function(local_svg_file, target)
      act.str.env_bash_eval_sync(
        "convert -background none" .. transf.str.str_by_single_quoted_escaped(local_svg_file) .. transf.str.str_by_single_quoted_escaped(target)
      )
    end
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
            title = spec.title or get.str.str_by_formatted_w_n_anys("Playlist from %s", transf["nil"].full_rfc3339like_dt_by_current()),
            description = spec.description or get.str.str_by_formatted_w_n_anys("Created at %s", transf["nil"].full_rfc3339like_dt_by_current()),
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
    choose_item = function(arr, callback, chooser_item_specifier_modifier)
      dothis.choosing_hschooser_specifier.choose_identified_item(
        get.arr.choosing_hschooser_specifier(arr, chooser_item_specifier_modifier),
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
  two_strs__arr_arr = {
    push_ensure_global_namespace = function(two_strs__arr_arr, item)
      item = get.arr.arr_by_mapped_w_t_arg_t_ret_fn(item, transf.str.str_by_ensure_global_namespace_start)
      dothis.arr.push(two_strs__arr_arr, item)
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

      act.any.choose_action(target)
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
      local hschooser = get.hschooser_specifier.hschooser(spec, callback)
      hschooser:rows(spec.rows or 30)
      for k, v in transf.table.kt_vt_stateless_iter(spec.whole_chooser_style_keys) do
        hschooser[k](hschooser, v)
      end
      local choices = get.chooser_item_specifier_arr.chooser_item_specifier_arr_by_styled(
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
  },
  mpv_ipc_socket_id = {
    set = function(id, key, ...)
      get.ipc_socket_id.not_userdata_or_fn_or_nil_by_response(id, { command = { "set_property", key, ... } })
    end,
    cycle = function(id, key)
      get.ipc_socket_id.not_userdata_or_fn_or_nil_by_response(id, { command = { "cycle", key } })
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
    exec = function(id, ...)
      get.ipc_socket_id.not_userdata_or_fn_or_nil_by_response(id, { command = { ... } })
    end,
    set_playlist_index = function(id, index)
      dothis.mpv_ipc_socket_id.set(id, "playlist-pos", index)
    end,
    set_playback_seconds = function(id, seconds)
      dothis.mpv_ipc_socket_id.set(id, "time-pos", seconds)
    end,
    set_playback_percent = function(id, percent)
      dothis.mpv_ipc_socket_id.set(id, "percent-pos", percent)
    end,
    set_playback_seconds_relative = function(id, seconds)
      dothis.mpv_ipc_socket_id.set_playback_seconds(
        id,
        transf.mpv_ipc_socket_id.pos_int_by_playback_seconds(id) + seconds
      )
    end,
    set_chapter = function(id, chapter)
      dothis.mpv_ipc_socket_id.set(id, "chapter", chapter)
    end,
  },
  created_item_specifier_arr = {
    create = function(arr, creation_specifier)
      local itm = act.creation_specifier.create(creation_specifier)
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
        arr[idx] = act.created_item_specifier.recreate(arr[idx])
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
      local creation_specifier_arr = get.assoc_table.assoc_arr(key_partial_creation_specifier_assoc, "key")
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
    postpone_next_timestamp_s = function(spec, s)
      spec.next_timestamp_s = spec.next_timestamp_s + s
    end,
  },
  timer_spec_arr = {
    create = function(arr, spec)
      dothis.arr.push(arr, spec)
      act.timer_spec.set_next_timestamp_s(spec)
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
  move_input_spec = {
    exec_position_change_state_spec = function(spec, position_change_state_spec)
      hs.mouse.absolutePosition(position_change_state_spec.current_hs_geometry_point)
    end,
  },
  scroll_input_spec = {
    exec_position_change_state_spec = function(spec, position_change_state_spec)
      hs.eventtap.scrollWheel({position_change_state_spec.delta_hs_geometry_point.x, position_change_state_spec.delta_hs_geometry_point.y}, {}, "pixel")
    end,
  },
  input_spec_arr = {
    exec = function(specarr, wait_time, do_after)
      wait_time = wait_time or transf.number_interval_specifier.number_by_random({start=0.10, stop=0.12})
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
          act.input_spec.exec(subspecifier, function()
            dothis.input_spec_arr.exec(subspecifier, wait_time, do_after)
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
    
  },

  fn = {
    put_memo_and_created_at_in_memory = function(fn, params, result)
      dynamic_permanents.fn_key_int_key_table_value_assoc_value_assoc_by_memstore[fn] = dynamic_permanents.fn_key_int_key_table_value_assoc_value_assoc_by_memstore[fn] or {}
      local node = dynamic_permanents.fn_key_int_key_table_value_assoc_value_assoc_by_memstore[fn]
      for i=1, #params do
        local param = params[i]
        if param == nil then param = consts.nil_singleton 
        elseif is.any.table(param) then -- otherwise referential equality fucks us up
          param = shelve.marshal(param)
        end
        node = node.children and node.children[param]
        if not node then return nil end
        node.children = node.children or {}
        node.children[param] = node.children[param] or {}
        node = node.children[param]
      end
      node.results = get.table.table_by_copy(result, true)
      node.created_at = os.time()
    end,
    put_memo_and_created_at_in_db_low_priority = function(fn, params, result)
      local fnname = transf.fn.fnname(fn)
      local queryarr = transf.any_and_arr.arr(
        fnname,
        params
      )
      local timestamp_queryarr = transf.arr_and_any.arr(
        queryarr,
        "createdat"
      )
      act.not_userdata_or_fn_arr_and_not_userdata_or_fn.set_key_redis(
        queryarr,
        result
      )
      act.not_userdata_or_fn_arr_and_not_userdata_or_fn.set_key_redis(
        timestamp_queryarr,
        os.time()
      )
    end,
  },
  fn_queue_specifier = {
    push = function(qspec, fn)
      dothis.arr.push(qspec.fn_arr, fn)
      act.fn_queue_specifier.update(qspec)
    end,
  },
  export_chat_main_object = {
    log = function(obj, typ, source_media_dir)
      local logging_dir = get.export_chat_main_object.logging_dir(obj, typ)
      dothis.absolute_path.create_dir(
        logging_dir
      )
      local media_dir = get.export_chat_main_object.local_dir_by_media_dir(obj, typ)
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
      act.backuped_thing_identifier.write_current_timestamp_ms(
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
      local arr = transf[typ .. "_export_dir"].export_chat_main_object_and_local_dir__arr_arr_by_media_dir(dir)
      for _, two_anys__arr in transf.arr.pos_int_vt_stateless_iter(arr) do
        dothis.export_chat_main_object.log(two_anys__arr[1], typ, two_anys__arr[2])
      end
    end
  },
  search_engine_id = {
    search = function(engine, query)
      dothis.str.search(query, engine)
    end
  }
}