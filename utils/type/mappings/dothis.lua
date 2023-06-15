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
        push(command, specifier.start)
      end

      if specifier["end"] then
        push(command, specifier["end"])
      end

      if specifier.timezone then
        push(command, specifier.timezone)
      end

      if specifier.title then
        push(command, specifier.title)
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
        local new_specifier = transf.yaml_string.table(tmp_file)
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
      local tmpdir_json_path = transf.not_userdata_or_function.in_tmp_dir(t) .. ".json"
      local tmpdir_ics_path = transf.not_userdata_or_function.in_tmp_dir(t) .. ".ics"
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
    say = function(str, lang)
      lang = lang or "en"
      speak:voice(tblmap.lang.voice[lang]):speak(transf.string.folded(str))
    end,
    paste = function(str)
      local lines = stringy.split(str, "\n")
      local is_first_line = true
      for _, line in ipairs(lines) do
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
    copy = hs.pasteboard.setContents
  },
  path = {
    open_default = function(path, do_after)
      run("open " .. transf.string.single_quoted_escaped(path), do_after)
    end,
    open_app = function(path, app, do_after)
      run("open -a " .. transf.string.single_quoted_escaped(app) .. " " .. transf.string.single_quoted_escaped(path), do_after)
    end,
    
  },
  absolute_path = {
    write_file = function(path, content)
      writeFile(path, content, "any", true)
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
    delete = function(path)
      delete(path, "any", "delete", "any", "error")
    end,
    empty = function(path)
      delete(path, "any", "empty", "any", "error")
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

  },
  plaintext_table_file = {
    append_arrays_of_fields = function(path, arrays_of_fields)
      local lines = hs.fnutils.imap(arrays_of_fields, function (arr)
        return table.concat(arr, transf.plaintext_table_file.field_separator())
      end)
      dothis.plaintext_file.append_lines(path, lines)
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
      for _, hook in ipairs(get.dir.files(source_hooks)) do
        dothis.git_root_dir.link_hook(path, type, hook)
      end
    end,
    copy_all_hooks = function(path, type)
      local source_hooks = transf.path.join(env.GITCONFIGHOOKS, type)
      for _, hook in ipairs(get.dir.files(source_hooks)) do
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
        "git commit -m" .. transf.string.single_quoted_escaped(message or ("Programmatic commit at " .. os.date("%Y-%m-%dT%H:%M:%S"))),
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
        "git commit -am" .. transf.string.single_quoted_escaped(message or ("Programmatic commit at " .. os.date("%Y-%m-%dT%H:%M:%S"))),
        do_after
      )
    end
  },
  in_git_dir_array = {
    pull_all = function(paths)
      for _, path in ipairs(paths) do
        dothis.in_git_dir.pull(path)
      end
    end,
  },
  date = {
    create_log_entry = function(date, path, contents)
      error("todo")
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
  absolute_path_dict = {

  },
  absolute_path_string_dict = {
    write = function(absolute_path_string_dict)
      for absolute_path, contents in pairs(absolute_path_string_dict) do
        dothis.absolute_path_string.write(absolute_path, contents)
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
  path_with_intra_file_locator_specifier = {
    go_to = function(specifier)
      doSeries(
        transf.path_with_intra_file_locator_specifier.series_specifier(specifier)
      )
    end,
    open_go_to = function(specifier)
      dothis.path.open_app(
        transf.path_with_intra_file_locator_specifier.path(specifier),
        "Visual Studio Code - Insiders",
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
  }
}