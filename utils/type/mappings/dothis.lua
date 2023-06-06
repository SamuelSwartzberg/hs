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
          local mgr_backup = CreateStringItem(env.MDEPENDENCIES .. "/" .. mgr)
          mgr_backup:doThis("git-commit-self", message)
          mgr_backup:doThis("git-push")
        else 
          local mdependencies = CreateStringItem(env.MDEPENDENCIES)
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
    edit = function(uid)
      run("khard edit " .. uid, true)
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
          specifier.do_after(std_out)
        end
      end)
    end,
    add_event_interactive = function(event_table)
      event_table = event_table or {}
      local temp_file_contents = le(transf.event_table.calendar_template(event_table))
      local do_after = event_table.do_after
      event_table.do_after = nil
      doWithTempFile({edit_before = true, contents = temp_file_contents, use_contents = true}, function(tmp_file)
        local new_specifier = yamlLoad(tmp_file)
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
      run("yes " .. transf.table.single_quoted_escaped(data) .. " | pass add " .. type .. "/" .. name, true)
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
  },
  youtube = {
    do_extracted_attrs_via_ai = function(video_id, do_after)
      fillTemplateGPT({
        in_fields = {
          title = transf.youtube_video_id.title(video_id),
          channel_title = transf.youtube_video_id.channel_title(video_id),
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
          }
        },
      },do_after)
    end,

  },
  url = {
    download = function(url, target)
      run("curl -L " .. transf.string.single_quoted_escaped(url) .. " -o " .. transf.string.single_quoted_escaped(target))
    end
  },
  string = {
    generate_qr_png = function(data, path)
      if not testPath(path) then
        run("qrencode -l M -m 2 -t PNG -o" .. transf.string.single_quoted_escaped(path) .. transf.string.single_quoted_escaped(data))
      end -- else: don't do anything: QR code creation is deterministic, so we don't need to do it again. This relies on the path not changing, which our consumers are responsible for.
    end,
  }

}