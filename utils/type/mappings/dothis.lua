dothis = {
  mullvad = {
    connect = function()
      run("mullvad connect", true)
    end,
    disconnect = function()
      run("mullvad disconnect", true)
    end,
    toggle = function()
      if get.mullvad.connected() then
        dothis.mullvad.disconnect()
      else
        dothis.mullvad.connect()
      end
    end,
    relay_set = function(hostname)
      run("mullvad relay set hostname " .. hostname, true)
    end,
  },
  upkg = {
    install = function(mgr, pkg)
      run("upkg " .. mgr .. " install " .. transf.string.single_quoted_escaped(pkg), true)
    end,
    install_self = function(mgr)
      run("upkg " .. mgr .. " install-self", true)
    end,
    install_missing = function(mgr)
      run("upkg " .. mgr .. " install-missing", true)
    end,
    remove = function(mgr, pkg)
      run("upkg " .. mgr .. " remove " .. transf.string.single_quoted_escaped(pkg), true)
    end,
    upgrade = function(mgr, pkg)
      local target
      if pkg then target = transf.string.single_quoted_escaped(pkg)
      else target = "" end
      run("upkg " .. mgr .. " upgrade " .. target, true)
    end,
    link = function(mgr, pkg)
      run("upkg " .. mgr .. " link " .. transf.string.single_quoted_escaped(pkg), true)
    end,
    upgrade_all = function(mgr)
      run("upkg " .. mgr .. " upgrade-all", true)
    end,
    do_backup_and_commit = function(mgr, action, msg)
      run("upkg " .. mgr .. " " .. action, function()
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
    backup = function(mgr)
      dothis.upkg.do_backup_and_commit(mgr, "backup", "backup packages")
    end,
    delete_backup = function(mgr)
      dothis.upkg.do_backup_and_commit(mgr, "delete-backup", "delete backup of packages")
    end,
    replace_backup = function(mgr)
      dothis.upkg.do_backup_and_commit(mgr, "replace-backup", "replace backup of packages")
    end,
  },
  khard = {
    edit = function(uid, do_after)
      run("khard edit " .. uid, do_after)
    end,
  },
  khal = {
    add_event_from_file = function(calendar, path)
      run("khal import --include-calendar " .. calendar .. " " .. transf.string.single_quoted_escaped(path), true)
    end,
    add_event_from_url = function(calendar, url)
      local temp_path_arg = transf.string.single_quoted_escaped(env.TMPDIR .. "/event_downloaded_at_" .. os.time() .. ".ics")
      run('curl' .. transf.string.single_quoted_escaped(url) .. ' -o' .. temp_path_arg .. '&& khal import --include-calendar ' .. calendar .. temp_path_arg, true)
    end,
    add_event_from_specifier = function(specifier)
      specifier = specifier or {}
      specifier = map(specifier, stringy.strip, {
        mapcondition = { _type = "string"}
      })
      local command = {"khal", "new" }
      if specifier.calendar then
        command = concat(
          command,
          {
            "--calendar",
            { value = specifier.calendar, type = "quoted" }
          }
        )
      end

      if specifier.location then
        command = concat(
          command,
          {
            "--location",
            { value = specifier.location, type = "quoted" }
          }
        )
      end

      if specifier.alarms then
        local alarms_str = table.concat(
          map(specifier.alarms, stringy.strip, {
            mapcondition = { _type = "string"}
          }),
          ","
        )
        command = concat(
          command,
          {
            "--alarm",
            { value = alarms_str , type = "quoted" }
          }
        )
      end

      if specifier.url then 
        command = concat(
          command,
          {
            "--url",
            { value = specifier.url, type = "quoted" }
          }
        )
      end

      -- needed for postcreation modifications 
      command = concat(
        command,
        {
          "--format",
          { value = "{uid}", type = "quoted" }
        }
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
        command = concat(
          command,
          {
            "::",
            { value = specifier.description, type = "quoted" }
          }
        )
      end

      run(command, function(std_out)
        -- todo: build RRULE, add it to event
        if specifier.do_after then 
          specifier.do_after(stringy.strip(std_out))
        end
      end)
    end,
    add_event_interactive = function(event_table)
      event_table = event_table or {}
      local temp_file_contents = le(transf.event_table.calendar_template(event_table))
      local do_after = event_table.do_after
      event_table.do_after = nil
      doWithTempFile({edit_before = true, contents = temp_file_contents, use_contents = true}, function(tmp_file)
        local new_specifier = transf.yaml_string.not_userdata_or_function(tmp_file)
        new_specifier.do_after = do_after
        dothis.khal.add_event_from_specifier(new_specifier)
      end)
    end,
    --- edit event by adding new event and deleting old one (necessary since khal won't allow us to use a GUI editor (Don't try, I've spent hours on this, it's not possible))
    edit_event = function(searchstr, include, exclude) 
      local event_table = get.khal.search_event_tables(searchstr)[1]
      event_table.do_after = function()
        dothis.khal.delete_event(searchstr, include, exclude)
      end
      dothis.khal.add_event_interactive(event_table)
    end,

    delete_event = function(searchstr, include, exclude)
      local command = 
        "echo $'D\ny\n' | khal edit " .. get.khal.basic_command_parts(include, exclude) .. transf.string.single_quoted_escaped(searchstr)
      run(command, true)
    end,
  },
  event_table = {
    delete = function(event_table)
      dothis.khal.delete_event(event_table.uid, event_table.calendar)
    end,
    edit = function(event_table)
      dothis.khal.edit_event(event_table.uid, event_table.calendar)
    end,
    create_similar = function(event_table)
      dothis.khal.add_event_interactive(event_table)
    end,
  },
  pandoc = {
    markdown_to = function(source, format, metadata, do_after)
      local source, target = resolve({s = {path = source}, t = {suffix = "." .. tblmap.pandoc_format.extension[format]}})
      local rawsource = readFile(source)
      local processedsource = join.string.table.with_yaml_metadata(rawsource, metadata)
      rawsource = eutf8.gsub(rawsource, "\n +\n", "\n&nbsp;\n")
      local temp_path = source .. ".tmp"
      writeFile(temp_path, processedsource) 
      local command_parts = {
        "pandoc",
      }
      table.insert(command_parts, "--wrap=preserve")
      table.insert(command_parts, "-f")
      table.insert(command_parts, "markdown+" .. table.concat(get.pandoc.extensions(), "+"))
      table.insert(command_parts, "--standalone")
      table.insert(command_parts, "-t")
      table.insert(command_parts, format)
      table.insert(command_parts, "-i")
      table.insert(command_parts, {value = temp_path, type ="quoted"})
      table.insert(command_parts, "-o")
      table.insert(command_parts, {value = target, type ="quoted"})
      run(command_parts, function ()
        delete(temp_path)
        if do_after then
          do_after(target)
        end
      end)
    end,
  },
  grid = {
    show_certain = function(grid)
      hs.grid.setGrid(grid)
      hs.grid.show()
    end,
  },
  pass = {
    add_otp_url = function(url, name)
      run({
        "echo",
        {value = url, type = "quoted"},
        "|",
        "pass otp insert otp/" .. name
      })
    end,
    add_item = function(data, type, name)
      run("yes " .. transf.not_userdata_or_function.single_quoted_escaped(data) .. " | pass add " .. type .. "/" .. name, true)
    end,
    add_json = function(data, type, name)
      dothis.pass.add_item(json.encode(data), type, name)
    end,
    add_contact_data = function(data, type, uid)
      type = "contacts/" .. type
      dothis.pass.add_json(data, type, uid)
    end,
    add_password = function(password, name)
      dothis.pass.add_item(password, "passw", name)
    end,
    delete = function(type, name)
      run("pass rm " .. type .. "/" .. name, true)
    end,
    rename = function(type, old_name, new_name)
      run("pass mv " .. type .. "/" .. old_name .. " " .. type .. "/" .. new_name, true)
    end,
    edit = function(data, type, name)
      run("pass rm " .. type .. "/" .. name, function()
        dothis.pass.add_item(data, type, name)
      end)
    end,
  },
  pass_name = {
    fill = function(name)
      dothis.string_array.fill_with({
        transf.pass_name.username(name),
        transf.pass_name.password(name),
      })
    end
  },
  contact_table = {
    add_iban = function(contact_table, iban)
      dothis.pass.add_contact_data(iban, "iban", transf.contact_table.uid(contact_table))
    end,
    edit = function(contact_table)
      dothis.khard.edit_contact(transf.contact_table.uid(contact_table))
    end,
  },
  youtube = {
    do_extracted_attrs_via_ai = function(video_id, do_after)
      fillTemplateGPT({
        in_fields = {
          title = transf.youtube_video_id.title(video_id),
          channel_title = transf.youtube_video_id.channel_title(video_id),
          description = slice(transf.youtube_video_id.description(video_id), { stop = 400, sliced_indicator = "... (truncated)" }),
        },
        out_fields = {
          {
            alias = "tcrea",
            value = "Artist"
          },
          {
            alias = "title",
            value = "Title"
          },
          {
            alias = "srs",
            value = "Series"
          },
          {
            alias = "srsrel",
            value = "Relation to series",
            explanation = "op, ed, ost, insert song, etc."
          },
          {
            alias = "srsrelindex",
            value = "Index in the relation to series",
            explanation = "positive integer"
          }
        },
      },do_after)
    end,
  },
  sox = {
    rec_start = function(path, do_after)
      run("rec " .. transf.string.single_quoted_escaped(path), function()
        if do_after then
          do_after(path)
        end
      end)
    end,
    rec_start_cache = function(do_after)
      dothis.sox.rec_start(transf.string.in_cache_dir(os.time(), "recording"), do_after)
    end,
    rec_stop = function(do_after)
      run("killall rec", do_after)
    end,
    rec_toggle_cache = function(do_after)
      if get.sox.is_recording() then
        dothis.sox.rec_stop()
      else
        dothis.sox.rec_start_cache(do_after)
      end
    end,
  },
  vdirsyncer = {
    sync = function()
      run("vdirsyncer sync", true)
    end
  },
  newsboat = {
    reload = function()
      run("newsboat -x reload", true)
    end,
  },
  mbsync = {
    sync = function()
      run('mbsync -c "$XDG_CONFIG_HOME/isync/mbsyncrc" mb-channel', true)
    end,
  },
  url = {
    download = function(url, target)
      run("curl -L " .. transf.string.single_quoted_escaped(url) .. " -o " .. transf.string.single_quoted_escaped(target))
    end,
  },
  booru_url = {
    add_to_local = function(url)
      rest({
        api_name = "hydrus",
        endpoint = "add_urls/add_url",
        request_table = { url = url },
        request_verb = "POST",
      })
    end
  },
  table = {
    write_ics_file = function(tbl, path)
      local tmpdir_json_path = transf.not_userdata_or_function.in_tmp_dir(arr) .. ".json"
      local tmpdir_ics_path = transf.not_userdata_or_function.in_tmp_dir(arr) .. ".ics"
      writeFile(tmpdir_json_path, json.encode(tbl))
      run({
        "ical2json",
        "-r",
        { value = tmpdir_ics_path, type = "quoted" }
      })
      delete(tmpdir_json_path)
      if path then
        srctgt("move", tmpdir_ics_path, path)
        delete(tmpdir_ics_path)
      end
    end
  },
  string = {
    generate_qr_png = function(data, path)
      if not testPath(path) then
        run("qrencode -l M -m 2 -t PNG -o" .. transf.string.single_quoted_escaped(path) .. transf.string.single_quoted_escaped(data))
      end -- else: don't do anything: QR code creation is deterministic, so we don't need to do it again. This relies on the path not changing, which our consumers are responsible for.
    end,
    alert = function(str, opts)
      opts = get.table.copy(opts) or {}
      opts.duration = opts.duration or 10
      return hs.alert.show(str, {textSize = 12, textFont = "Noto Sans Mono", atScreenEdge = 1, radius = 3}, opts.duration)
    end,
    say = function(str, lang)
      lang = lang or "en"
      speak:voice(tblmap.lang.voice[lang]):speak(transf.string.folded(str))
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
      dothis.string.paste(le(str))
    end,
    copy = hs.pasteboard.setContents,
    fill_with_lines = function(str)
      dothis.string_array.fill_with(transf.string.lines(str))
    end,
    fill_with_content_lines = function(path)
      dothis.string_array.fill_with(transf.string.content_lines(path))
    end,
    fill_with_nocomment_noindent_content_lines = function(path)
      dothis.string_array.fill_with(transf.string.nocomment_noindent_content_lines(path))
    end,
    search = function(str, search_engine)
      dothis.url_or_path.open_browser(
        get.string.search_engine_search_url(search_engine, str)
      )
    end,
    write_to_temp_file = function(str)
      local path = transf.string.in_tmp_dir(os.time(), "temp_file")
      writeFile(path, str)
      return path
    end,
    open_temp_file = function(str)
      dothis.path.open_app(
        transf.string.write_to_temp_file(str),
        env.GUI_EDITOR
      )
    end,
    create_url_array_as_session_in_msessions = function(str)
      dothis.url_array.create_as_session_in_msessions(
        transf.string.url_array(str)
      )
    end

  },
  url_or_path = {
    open_browser = function(url, browser, do_after)
      url = transf.url.ensure_scheme(url)
      browser = browser or "Firefox"
      if do_after then -- if we're opening an url, typically, we would exit immediately, negating the need for a callback. Therefore, we want to wait. The only easy way to do this is to use a completely different browser. 
        run("open -a Safari -W" .. transf.string.single_quoted_escaped(url), do_after)
        -- Annoyingly, due to a 15 (!) year old bug, Firefox will open the url as well, even if we specify a different browser. I've tried various fixes, but for now we'll just have to live with it and click the tab away manually.
      else
        run("open -a" .. transf.string.single_quoted_escaped(browser))
      end
    end,
    open_ff = function(url)
      dothis.url_or_path.open_browser(url, "Firefox")
    end,
    open_safari = function(url)
      dothis.url_or_path.open_browser(url, "Safari")
    end,
    open_chrome = function(url)
      dothis.url_or_path.open_browser(url, "Google Chrome")
    end,
  },
  path = {
    open_default = function(path, do_after)
      run("open " .. transf.string.single_quoted_escaped(path), do_after)
    end,
    open_app = function(path, app, do_after)
      run("open -a " .. transf.string.single_quoted_escaped(app) .. " " .. transf.string.single_quoted_escaped(path), do_after)
    end,
    write_relative_path_dict = function(path, relative_path_dict, extension)
      dothis.dynamic_absolute_path_dict.write(
        get.relative_path_dict.absolute_path_dict(relative_path_dict, path, extension)
      )
    end,
    write_dynamic_path_dict = function(path, assoc_arr, extension)
      dothis.path.write_relative_path_dict(
        transf.assoc_arr.relative_path_dict(path), 
        assoc_arr, 
        extension
      )
    end,
    write_dynamic_structure = function(path, name)
      dothis.path.write_dynamic_path_dict(
        path,
        tblmap.dynamic_structure_name.dynamic_structure[name]
      )
    end,
  },
  absolute_path = {
    write_file = function(path, content)
      writeFile(path, content, "any", true)
    end,
    write_template = function(path, template_path)
      dothis.absolute_path.write_file(
        path,
        le(
          singleLe(template_path),
          path
        )
      )
    end,
    create_file = function(path, contents)
      writeFile(path, contents, "not-exists", true)
    end,
    replace_file = function(path, contents)
      writeFile(path, contents, "exists", true)
    end,
    create_path = function(path)
      createPath(path)
    end,
    copy_single_into = function(path, tgt)
      srctgt("copy", path, tgt, "any", true, false)
    end,
    copy_all_in_into = function(path, tgt)
      srctgt("copy", path, tgt, "any", true, true)
    end,
    delete = function(path)
      delete(path, "any", "delete", "any", "error")
    end,
    empty = function(path)
      delete(path, "any", "empty", "any", "error")
    end,
    initialize_omegat_project = function (path)
      dothis.path.write_dynamic_structure(path, "omegat")
      dothis.omegat_project_dir.pull_project_materials(path)
    end
  },
  extant_path = {
    make_executable = function(path)
      run("chmod +x " .. transf.string.single_quoted_escaped(path))
    end,
    do_in_path = function(path, cmd, do_after)
      if is.path.dir(path) then
        dothis.dir.do_in_path(path, cmd, do_after)
      else
        dothis.dir.do_in_path(transf.path.parent_path(path), cmd, do_after)
      end
    end,
    
  },
  file = {
    do_in_path = function(path, cmd, do_after)
      run("cd " .. transf.string.single_quoted_escaped(transf.path.parent_path(path)) .. " && " .. cmd, do_after)
    end
  },
  audio_file = {
    play = function(path, do_after)
      run("play " .. transf.string.single_quoted_escaped(path), do_after)
    end
  },
  image_file = {

  },
  plaintext_file = {
    append_contents = function(path, str)
      writeFile(path, str, "exists", "a")
    end,
    replace_contents = function(path, str)
      writeFile(path, str, "exists", "w")
    end,
    append_lines = function(path, lines)
      local contents = transf.plaintext_file.one_final_newline(path)
      writeFile(path, contents .. table.concat(lines, "\n"), "exists", "w")
    end,
    append_line = function(path, line)
      dothis.plaintext_file.append_lines(path, {line})
    end,
    append_line_and_commit = function(path, line)
      dothis.plaintext_file.append_line(path, line)
      dothis.in_git_dir.commit_self(path, "Added line " .. line .. " to " .. get.absolute_path.relative_path_from(path, transf.in_git_dir.git_root_dir(path)))
    end,
    write_lines = function(path, lines)
      writeFile(path, table.concat(lines, "\n"), nil, "w")
    end,
    set_line = function(path, line, line_number)
      local lines = transf.plaintext_file.lines(path)
      lines[line_number] = line
      dothis.plaintext_file.write_lines(path, lines)
    end,
    pop_line = function(path)
      local lines = transf.plaintext_file.lines(path)
      local line = table.remove(lines, #lines)
      dothis.plaintext_file.write_lines(path, lines)
      return line
    end,
    remove_line = function(path, line_number)
      local lines = transf.plaintext_file.lines(path)
      table.remove(lines, line_number)
      dothis.plaintext_file.write_lines(path, lines)
    end,
    find_remove_line = function(path, cond, opts)
      local lines = transf.plaintext_file.lines(path)
      local index = get.string_array.find(lines, cond, {ret = "i"})
      dothis.plaintext_file.remove_line(path, index)
    end,
    find_remove_nocomment_noindent_line = function(path, cond, opts)
      local lines = transf.plaintext_file.lines(path)
      local index = find(lines, function(line)
        local nocomment_noindent = transf.line.nocomment_noindent(line)
        return findsingle(nocomment_noindent, cond)
      end, {ret = "i"})
      dothis.plaintext_file.remove_line(path, index)
    end,

  },
  plaintext_table_file = {
    append_array_of_arrays_of_fields = function(path, array_of_arrays_of_fields)
      local lines = hs.fnutils.imap(array_of_arrays_of_fields, function (arr)
        return table.concat(arr, transf.plaintext_table_file.field_separator())
      end)
      dothis.plaintext_file.append_lines(path, lines)
    end,

  },
  plaintext_url_or_path_file = {
    open_all = function(path, browser)
      hs.fnutils.ieach(
        transf.plaintext_file.nocomment_noindent_content_lines(path),
        bind(dothis.url_or_path.open_browser, {a_use, browser})
      )
    end,
  },
  email_file ={
    download_attachment = function(path, name, do_after)
      local cache_path = env.XDG_CACHE_HOME .. '/hs/email_attachments'
      local att_path = cache_path .. '/' .. name
      if type(do_after) == "function" then
        local old_do_after = do_after
        do_after = function()
          old_do_after(att_path)
        end
      end
      run(
        'cd ' .. transf.single_quoted_escaped(cache_path) .. ' && mshow -x'
        .. transf.string.single_quoted_escaped(path) .. transf.string.single_quoted_escaped(name),
        do_after
      )
    end,
    send = function(path, do_after)
      run({
        args = {
          "msmtp",
          "-t",
          "<",
          { value = path, type = "quoted" },
        },
        catch = function()
          writeFile(env.FAILED_EMAILS .. "/" .. os.date("%Y-%m-%dT%H:%M:%S"), readFile(path, "error"))
        end,
        finally = function()
          delete(path)
        end,
      }, 
      {
        "cat",
        { value = path, type = "quoted" },
        "|",
        "msed",
        { value = "/Date/a/"..os.date(tblmap.date_format_name.date_format.email, os.time()), type = "quoted" },
        "|",
        "msed",
        { value = "/Status/a/S/", type = "quoted" },
        "|",
        "mdeliver",
        "-c",
        { value = env.MBSYNC_ARCHIVE, type = "quoted" },
      }, function()
        delete(path)
        if do_after then
          do_after()
        end
      end, true)
    end,
    edit_then_send = function(path, do_after)
      doWithTempFile({
        path = path,
        edit_before = true,
      }, function(path)
        writeFile(path, le(readFile(path))) -- re-eval
        dothis.email_file.send(path, do_after)
      end)
    end,
    reply = function(path, specifier, do_after)
      specifier = glue(transf.email_file.reply_email_specifier(path), specifier)
      dothis.email_specifier.send(specifier, do_after)
    end,
    edit_then_reply = function(path, do_after)
      dothis.email_specifier.edit_then_send(transf.email_file.reply_email_specifier(path), do_after)
    end,
    forward = function(path, specifier, do_after)
      specifier = glue(transf.email_file.forward_email_specifier(path), specifier)
      dothis.email_specifier.send(specifier, do_after)
    end,
    edit_then_forward = function(path, do_after)
      dothis.email_specifier.edit_then_send(transf.email_file.forward_email_specifier(path), do_after)
    end,
    move = function(source, target)
      run({
        "mdeliver",
        { value = target, type = "quoted" },
        "<",
        { value = source, type = "quoted" }
      }, {
        "minc", -- incorporate the message (/cur -> /new, rename in accordance with the mblaze rules and maildir spec)
        { value = target, type = "quoted" }
      }, {
        "rm",
        { value = source, type = "quoted" }
      }, true)
    end,
      
    
  },
  dir = {
    pull_all = function(path)
      dothis.in_git_dir_array.pull_all(
        transf.dir.git_root_dir_descendants(path)
      )
    end,
    do_in_path = function(path, cmd, do_after)
      run("cd " .. transf.string.single_quoted_escaped(path) .. " && " .. cmd, do_after)
    end,
    delete_child_with_leaf_ending = function(path, ending)
      dothis.absolute_path.delete(
        get.dir.find_child_with_leaf_ending(path, ending)
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
    write_to_csv = function(sqlite_file, query, output_path, do_after)
      run({
        "sqlite3",
        {value = sqlite_file, type = "quoted"},
        "-csv",
        {value = query, type = "quoted"},
        ">",
        {value = output_path, type = "quoted"},
      }, do_after)
    end,
    write_to_csv_cache = function(sqlite_file, query, do_after)
      dothis.sqlite_file.write_to_csv(
        sqlite_file, 
        query, 
        transf.string.in_cache_dir(
          query .. "@" .. transf.path.filename(sqlite_file) .. ".csv",
          "sqlite_csv"
        )
      )
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
  audiodevice = {
    set_default = function(device, type)
      device["setDefault" .. transf.word.capitalized(type) .. "Device"](device)
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
  source_id = {
    activate = function(source_id)
      hs.keycodes.currentSourceID(source_id)
      hs.alert.show(transf.source_id.language(source_id))
    end,
  },
  ics_file = {
    generate_json_file = function(path)
      return run({
        "ical2json",
        {
          value = path,
          type = "quoted"
        }
      })
    end,
  },
  git_root_dir = {
    run_hook =  function(path, hook)
      local hook_path = get.git_root_dir.hook_path(path, hook)
      run(hook_path, true)
    end,
    add_hook = function(path, hook_path, name)
      name = name or transf.path.filename(hook_path)
      srctgt("copy", hook_path, get.git_root_dir.hook_path(path, name))
      dothis.extant_path.make_executable(get.git_root_dir.hook_path(path, name))
    end,
    copy_hook = function(path, type, name)
      type = type or "default"
      local source_hook = env.GITCONFIGHOOKS .. "/" .. type .. "/" .. name
      dothis.extant_path.make_executable(source_hook)
      srctgt("copy", source_hook, get.git_root_dir.hook_path(path, name))
    end,
    link_hook = function(path, type, name)
      type = type or "default"
      local source_hook = env.GITCONFIGHOOKS .. "/" .. type .. "/" .. name
      dothis.extant_path.make_executable(source_hook)
      srctgt("link", source_hook, get.git_root_dir.hook_path(path, name))
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
      dothis.extant_path.do_in_path(path, "git pull")
    end,
    push = function(path)
      dothis.extant_path.do_in_path(path, "git push")
    end,
    fetch = function(path)
      dothis.extant_path.do_in_path(path, "git fetch")
    end,
    add_self = function(path, do_after)
      dothis.extant_path.do_in_path(path, "git add" .. transf.string.single_quoted_escaped(path), do_after)
    end,
    commit_self = function(path, message, do_after)
      dothis.extant_path.do_in_path(
        path, 
        "git commit -m" .. transf.string.single_quoted_escaped(message or ("Programmatic commit of " .. path .. " at " .. os.date(tblmap.date_format_name.date_format["rfc3339-datetime"]))),
        do_after
      )
    end,
    -- will also add untracked files
    add_all = function(path, do_after)
      dothis.extant_path.do_in_path(path, "git add -A", do_after)
    end,
    add_all_root = function(path, do_after)
      dothis.in_git_dir.add_all(transf.in_git_dir.git_root_dir(path), do_after)
    end,
    commit_staged = function(path, message, do_after)
      dothis.extant_path.do_in_path(
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
      dothis.extant_path.do_in_path(
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
    end
  },
  logging_dir = {
    log_ymd_nested_key_array_of_arrays_value_assoc_arr = function(path, ymd_nested_key_array_of_arrays_value_assoc_arr)
      local abs_path_dict = get.assoc_arr.absolute_path_dict(
        ymd_nested_key_array_of_arrays_value_assoc_arr,
        path,
        ".csv"
      )
      for path, array_of_arrays in abs_path_dict do 
        dothis.plaintext_table_file.append_array_of_arrays_of_fields(path, array_of_arrays)
      end
    end,
    log_timestamp_key_array_value_dict = function(path, timestamp_key_array_value_dict)
      dothis.logging_dir.log_ymd_nested_key_array_of_arrays_value_assoc_arr(
        path,
        transf.timestamp_key_array_value_dict.ymd_nested_key_array_of_arrays_value_assoc_arr(timestamp_key_array_value_dict)
      )
    end,
    log_dict_with_timestamp = function(path, dict)
      dothis.logging_dir.log_timestamp_key_array_value_dict(
        path,
        transf.dict_with_timestamp.timestamp_key_array_value_dict_by_array(dict, transf.logging_dir.headers(path))
      )
    end,
    write_header_file = function(path, headers)
      dothis.plaintext_file.write_lines(
        transf.logging_dir.header_file(path),
        headers
      )
    end
  },
  entry_logging_dir = {
    log_string = function(path, str)
      dothis.logging_dir.log_dict_with_timestamp(path, {
        timestamp = os.time(),
        entry = str
      })
    end,
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
    open_all = function(url_array)
      for _, url in transf.array.index_value_stateless_iter(url_array) do
        dothis.url_or_path.open_browser(url)
      end
    end,
    create_as_url_files = function(url_array, path)
      local abs_path_dict = get.url_array.absolute_path_dict_of_url_files(url_array, path)
      dothis.absolute_path_string_value_dict.write(abs_path_dict)
    end,
    create_as_url_files_in_murls = function(url_array)
      local path = transf.extant_path.prompted_path_relative_to(env.MURLS)
      dothis.url_array.create_as_url_files(url_array, path)
    end,
    create_as_session = function(url_array, root)
      local path = transf.extant_path.prompted_file_relative_to(root)
      path = mustEnd(path, ".session")
      dothis.absolute_path.write_file(
        path,
        transf.url_array.session_string(url_array)
      )
    end,
    create_as_session_in_msessions = function(url_array)
      dothis.url_array.create_as_session(url_array, env.MSESSIONS)
    end,
  },
  html_url_array = {
   
  },
  absolute_path_dict = {

  },
  dynamic_absolute_path_dict = {
    write = function(dynamic_absolute_path_dict)
      for absolute_path, contents in transf.native_table.key_value_stateless_iter(dynamic_absolute_path_dict) do
        local fn = eutf8.match(contents, "^(%w-):")
        local contents = eutf8.sub(contents, #fn + 2)
        dothis.absolute_path[fn](absolute_path, contents)
      end
    end,
  },
  absolute_path_string_value_dict = {
    write = function(absolute_path_string_value_dict)
      for absolute_path, contents in transf.native_table.key_value_stateless_iter(absolute_path_string_value_dict) do
        dothis.absolute_path.write_file(absolute_path, contents)
      end
    end,
  },
  application_name = {
    backup = function(application_name)
      local before_backup = tblmap.application_name.before_backup[application_name]
      if before_backup then
        before_backup(function ()
          dothis.application_name.backup_once_ready(application_name)
        end)
      else
        dothis.application_name.backup_once_ready(application_name)
      end
    end,
    backup_once_ready = function(application_name)
      local histfile =tblmap.application_name.history_file_path[application_name]
      local csv_export_histfile = get.application_name.in_tmp_dir(application_name, transf.path.leaf(histfile))
      dothis.sqlite_file.write_to_csv(
        histfile,
        tblmap.application_name.history_sql_query[application_name],
        csv_export_histfile,
        function()
        end)
    end
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
        append(
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
  },
  firefox = {
    dump_state = function(do_after)
      run('lz4jsoncat "$MAC_FIREFOX_PLACES_SESSIONSTORE_RECOVERY" > "$TMP_FIREFOX_STATE_JSON', do_after)
    end

  },
  newpipe = {
    extract_backup = function(do_after)
      run('cd "$NEWPIPE_STATE_DIR" && unzip *.zip && rm *.zip *.settings', do_after)
    end
  },
  omegat = {
    create_all_translated_documents = function()
      dothis.mac_application_name.execute_full_action_path(
        "OmegaT",
        {
          "Project",
          "Create Translated Documents"
        }
      )
    end,
    create_current_translated_document = function()
      dothis.mac_application_name.execute_full_action_path(
        "OmegaT",
        {
          "Project",
          "Create Current Translated Document"
        }
      )
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
      getViaOSA("js", ("Application('%s').windows()[%d].activeTabIndex = %d"):format(
        jxa_tab_specifier.application_name,
        jxa_tab_specifier.window_index,
        jxa_tab_specifier.tab_index
      ))
    end,
    close = function(jxa_tab_specifier)
      getViaOSA("js", ("Application('%s').windows()[%d].tabs()[%d].close()"):format(
        jxa_tab_specifier.application_name,
        jxa_tab_specifier.window_index,
        jxa_tab_specifier.tab_index
      ))
    end,
  },
  path_with_intra_file_locator_specifier = {
    go_to = function(specifier)
      doSeries(
        transf.path_with_intra_file_locator_specifier.series_specifier(specifier)
      )
    end,
    open_go_to = function(specifier)
      dothis.path.open_app(
        transf.path_with_intra_file_locator_specifier.path(specifier),
        env.GUI_EDITOR,
        hs.fnutils.partial(dothis.path_with_intra_file_locator_specifier.go_to, specifier)
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
      writeFile(path, str)
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
  env_yaml_file_container = {
    write_env_and_check = function(env_yaml_file_container)
      dothis.env_string.write_env_and_check(
        transf.env_yaml_file_container.env_string(env_yaml_file_container)
      )
    end,
  },
  citable_object_id = {
    save_local_csl_file = function(citable_object_id, indication)
      local csl_table = transf[indication].online_csl_table(citable_object_id)
      writeFile(
        env.MCITATIONS .. "/" .. transf.csl_table.citable_filename(csl_table),
        transf.not_userdata_or_function.json_string(csl_table)
      )
    end,
  },
  indicated_citable_object_id = {
    edit_local_csl_file = function(indicated_citable_object_id)
      dothis.path.open_app(
        transf.indicated_citable_object_id.local_csl_file_path(indicated_citable_object_id),
        env.GUI_EDITOR
      )
    end,
    open_local_citable_object_file = function(indicated_citable_object_id)
      dothis.path.open(
        transf.indicated_citable_object_id.local_citable_object_file_path(indicated_citable_object_id)
      )
    end,

  },
  citations_file = {
    write_bib = function(citations_file, path)
      writeFile(
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
      srctgt("copy", 
        get.project_dir.global_subtype_project_material_path(project_dir, type, subtype),
        get.project_dir.local_subtype_project_material_path(project_dir, type, subtype),
      "any", true, false, true)
    end,
    push_subtype_project_materials = function(project_dir, type, subtype)
      srctgt("copy", 
        get.project_dir.local_subtype_project_material_path(project_dir, type, subtype),
        get.project_dir.global_subtype_project_material_path(project_dir, type, subtype),
      "any", false, false, true)
    end,
    pull_universal_project_materials = function(project_dir, type)
      srctgt("copy", 
        get.project_dir.global_universal_project_material_path(project_dir, type),
        get.project_dir.local_universal_project_material_path(project_dir, type),
      "any", true, false, true)
    end,
    push_universal_project_materials = function(project_dir, type)
      srctgt("copy", 
        get.project_dir.local_universal_project_material_path(project_dir, type),
        get.project_dir.global_universal_project_material_path(project_dir, type),
      "any", false, false, true)
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
      srctgt("copy",
        transf.omegat_project_dir.local_resultant_tm(omegat_project_dir),
        get.project_dir.global_subtype_project_material_path(
          omegat_project_dir,
          "tm",
          transf.omegat_project_dir.client_name(omegat_project_dir)
        ),
        "any", true, true)
    end,
    create_all_translated_documents = dothis.omegat.create_all_translated_documents,
    create_current_translated_document = dothis.omegat.create_current_translated_document,
    create_and_open_new_source_odt = function(omegat_project_dir, name) -- while we support any source file, if we manually create a file, it should be an odt
      dothis.absolute_path.create_file(
        transf.omegat_project_dir.source_dir(omegat_project_dir) .. "/" .. name .. ".odt"
      )
      dothis.path.open(
        transf.omegat_project_dir.source_dir(omegat_project_dir) .. "/" .. name .. ".odt"
      )
    end,
    open_project = function(omegat_project_dir)
      local running_application = transf.mac_application_name.ensure_running_application("OmegaT")
      dothis.mac_application_name.open_recent("OmegaT", omegat_project_dir)
      dothis.running_application.focus_main_window(running_application)
    end,
    generate_target_txts = function(dir, do_after)
      local generation_tatransf.indexable.key_stateful_iter = map(
        transf.omegat_project_dir.target_files(dir),
        function(file)
          return file, "soffice --headless --convert-to txt:Text --outdir"..
          transf.string.single_quoted_escaped(
            transf.omegat_project_dir.target_txt_dir(dir)
          ) ..
          transf.string.single_quoted_escaped(file)
        end,
        {"v", "kv"}
      )
      runThreaded(generation_tatransf.indexable.key_stateful_iter, 1, do_after)
    end,
    generate_rechnung_md = function(omegat_project_dir)
      writeFile(
        transf.omegat_project_dir.rechnung_md_path(omegat_project_dir),
        transf.omegat_project_dir.raw_rechnung(omegat_project_dir)
      )
    end,
    generate_rechnung_pdf = function(omegat_project_dir, do_after)
      dothis.pandoc.markdown_to(
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
      dothis.path.open(
        transf.latex_project_dir.main_pdf_file(latex_project_dir)
      )
    end,
    build_and_open_pdf = function(latex_project_dir)
      dothis.latex_project_dir.build(
        latex_project_dir,
        hs.fnutils.partial(dothis.latex_project_dir.open_pdf, latex_project_dir)
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
      dothis.absolute_path.copy_single_into(
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
      dothis.absolute_path.copy_single_into(
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
  array = {
    choose_item = function(array, callback)
      dothis.choosing_hschooser_specifier.choose_identified_item(
        transf.array.choosing_hschooser_specifier(array),
        callback
      )
    end,
    choose_item_and_action = function(array)
      dothis.array.choose_item(array, dothis.any.choose_action)
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
  },
  action_specifier = {
    execute = function(spec, target)
      local args = {}
      if not is.any.array(spec.args) then
        args = {spec.args}
      end
      for k, v in transf.native_table.key_value_stateless_iter(spec.args) do
        if args.isprompttbl then
          args[k] = map(v, {_pm = false}, {tolist = true})[1]
        else
          args[k] = v
        end
      end
      
      local doargs = args
      if spec.getfn then
        target = spec.getfn(target, table.unpack(args))
        doargs = {}
      end

      spec.dothis = spec.dothis or dothis.any.choose_action
      spec.dothis(target, table.unpack(doargs))
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
      for k, v in transf.native_table.key_value_stateless_iter(spec.whole_chooser_style_keys) do
        hschooser[k](hschooser, v)
      end
      local choices = get.chooser_item_specifier_array.styled_chooser_item_specifier_array(
        spec.chooser_item_specifier_array,
        spec.chooser_item_specifier_text_key_styledtext_attributes_specifier_dict
      )
      hschooser:placeholderText(spec.placeholder_text)
      hschooser:choices(choices)
      hschooser:show()
      if spec.inital_selected then
        hschooser:selectedRow(spec.inital_selected)
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
        bind(dothis.action_specifier.execute, {a_use, any})
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
    exec = function(id, ...)
      get.ipc_socket_id.response_table_or_nil(id, { command = { ... } })
    end,
  },
  stream_creation_specifier = {
    create = function(spec)
      local ipc_socket_id = os.time() .. "-" .. math.random(1000000)
      run("mpv " .. transf.stream_creation_specifier.flags_string(spec.flags) .. 
        " --msg-level=all=warn --input-ipc-server=" .. transf.ipc_socket_id.ipc_socket_path(ipc_socket_id) .. " --start=" .. spec.values.start .. " " .. transf.string_array.single_quoted_escaped_string(spec.urls))
      return {
        ipc_socket_id = ipc_socket_id,
        stream_creation_specifier = spec,
        state = "booting"
      }
    end,
  },
  stream_specifier = {
    set_state_transitioned_state = function(spec)
      spec.state = transf.stream_specifier.transitioned_stream_state(spec)
    end,
  },
  stream_specifier_array = {
    set_state_transitioned_state_all = function(array)
      hs.fnutils.ieach(array, dothis.stream_specifier.set_state_transitioned_state)
    end,
  }
}