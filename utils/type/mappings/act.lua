
--- `act.\<source>.\<action>` - do action on source
--- Only take one argument, which is the source.
--- For actions that take more than one argument, see op.lua, and `op.\<source>.\<action>`.
act = {
  mullvad_relay_identifier = {
    set_active_mullvad_relay_dentifier = function(id)
      run("mullvad relay set hostname " .. id, true)
    end,
  },
  package_manager_name = {
    install_self = function(mgr)
      run("upkg " .. mgr .. " install-self", true)
    end,
    install_missing = function(mgr)
      run("upkg " .. mgr .. " install-missing", true)
    end,
    upgrade_all = function(mgr)
      run("upkg " .. mgr .. " upgrade-all", true)
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
      run(command, true)
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
      dothis.event_table.add_event_from(event_table, true)
    end,
    add_event_interactive_async = function(event_table)
      dothis.event_table.add_event_interactive(event_table, true)
    end,
  },
  url = {
    add_event_to_default_calendar = function(url)
      dothis.url.add_event_from_url(url, "default")
    end,
    add_event_to_chosen_calendar = function(url)
      dothis.array.choose_item(get.khal.writeable_calendars(), function(calendar)
        dothis.url.add_event_from_url(url, calendar)
      end)
    end,
  },
  ics_file = {
    add_events_to_default_calendar = function(ics_file)
      dothis.ics_file.add_events_from_file(ics_file, "default")
    end,
    add_events_to_chosen_calendar = function(ics_file)
      dothis.array.choose_item(get.khal.writeable_calendars(), function(calendar)
        dothis.ics_file.add_events_from_file(ics_file, calendar)
      end)
    end,
  }
}