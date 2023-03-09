
--- @class KhalEventSpecifier
--- @field calendar string
--- @field start string
--- @field title string
--- @field description string
--- @field location string
--- @field end string
--- @field alarms string[]
--- @field url string
--- @field repeat KhalRepeatSpecifier
--- @field timezone string

--- @class KhalRepeatSpecifier
--- @field freq string
--- @field interval string
--- @field until string
--- @field count string
--- @field byday string[]
--- @field bymonthday string[]
--- @field bymonth string[]
--- @field byyearday string[]

--- @class KhalListSpecifier
--- @field include_calendar string[]
--- @field exclude_calendar string[]
--- @field start string
--- @field end string
--- @field once boolean if true, show events with a duration of multiple days only once. Some things that accept a KhalListSpecifier will not accept this option.
--- @field notstarted boolean if true, only show events that have not started by the time of start. Some things that accept a KhalListSpecifier will not accept this option.
--- @field day_format string format string for the day. Some things that accept a KhalListSpecifier will not accept this option.
--- @field format string 

FIELD_SEPARATOR = "Y:z:Y"
RECORD_SEPARATOR = "__ENDOFRECORD5579__"

function addFormatToCommand(command, specifier)
  local format_spec = (specifier.format or "{uid}") .. RECORD_SEPARATOR
  if specifier.format then
    table.insert(command, "--format")
    table.insert(command, { value = format_spec, type = "quoted" })
  end
end

function addInclExclToCommand(command, specifier)
  if specifier.include_calendar then
    for _, cal in ipairs(specifier.include_calendar) do
      table.insert(command, "--include-calendar")
      table.insert(command, { value = cal, type = "quoted" })
    end
  end
  if specifier.exclude_calendar then
    for _, cal in ipairs(specifier.exclude_calendar) do
      table.insert(command, "--exclude-calendar")
      table.insert(command, { value = cal, type = "quoted" })
    end
  end
end

function parseParseableKhalToSpecification(event)
  local components = stringx.split(event, FIELD_SEPARATOR)
  local parsed = ovtable.new()
  for i, component in ipairs(components) do
    local key = PARSEABLE_FORMAT_COMPONENTS[i]
    if key == "alarms" then
      parsed[key] = stringy.split(component, ",")
    elseif key == "description" then
      parsed[key] = component
    else
      parsed[key] = stringx.replace(component, "\n", "")
    end
  end
  return parsed
end

function getCalendarTemplate()
  CALENDAR_TEMPLATE_SPECIFIER = ovtable.new()
  CALENDAR_TEMPLATE_SPECIFIER.calendar = { 
    comment = 'one of: {{[ CreateShellCommand("khal"):get("writable-calendar-string") ]}}' ,
    value = "default"
  }
  CALENDAR_TEMPLATE_SPECIFIER.start = {
    value = date():fmt("%Y-%m-%dT%H:%M"),
  }
  CALENDAR_TEMPLATE_SPECIFIER.title = {}
  CALENDAR_TEMPLATE_SPECIFIER.description = {}
  CALENDAR_TEMPLATE_SPECIFIER.location = {}
  CALENDAR_TEMPLATE_SPECIFIER["end"] = {
    comment = 'end of the event, either as a date, or as a delta in the form of [<n>d][<n>h][<n>m][<n>s]'
  }
  CALENDAR_TEMPLATE_SPECIFIER.alarms = {
    comment = 'array of alarms as deltas'
  }
  CALENDAR_TEMPLATE_SPECIFIER.url = {}
  CALENDAR_TEMPLATE_SPECIFIER.timezone = {
    comment = 'leave empty for local timezone'
  }
  CALENDAR_TEMPLATE_SPECIFIER["repeat"] = ovtable.new()
  CALENDAR_TEMPLATE_SPECIFIER["repeat"].freq = {
    comment = 'valid values: d[aily], w[eekly], m[onthly], y[early]. leave empty for no repeat'
  }
  CALENDAR_TEMPLATE_SPECIFIER["repeat"].interval = {
    comment = 'number of freq units between repeats'
  }
  CALENDAR_TEMPLATE_SPECIFIER["repeat"]["until"] = {
    comment = 'date to stop repeating'
  }
  CALENDAR_TEMPLATE_SPECIFIER["repeat"].count = {
    comment = 'number of times to repeat'
  }
  CALENDAR_TEMPLATE_SPECIFIER["repeat"].wkst = {
    comment = 'day to start week on (MO, TU, WE, TH, FR, SA, SU)',
    value = "MO"
  }
  CALENDAR_TEMPLATE_SPECIFIER["repeat"].byday = {
    comment = 'valid values: valid values: array of [sign]<integer><weekday>; meaning: occurrences to repeat on within freq'
  }
  CALENDAR_TEMPLATE_SPECIFIER["repeat"].bymonthday = {
    comment = 'only if freq is m[onthly]; valid values: array of [sign]<integer>; meaning: days of month to repeat on'
  }
  CALENDAR_TEMPLATE_SPECIFIER["repeat"].bymonth = {
    comment = 'only if freq is y[early]; valid values: array of [sign]<integer>; meaning: months to repeat on'
  }
  CALENDAR_TEMPLATE_SPECIFIER["repeat"].byyearday = {
    comment = 'only if freq is y[early]; valid values: array of [sign]<integer>; meaning: days of year to repeat on'
  }
  return CALENDAR_TEMPLATE_SPECIFIER
end

function fillCalenderTemplate(specifier)
  local template = getCalendarTemplate()
  for key, value in pairs(specifier) do
    if template[key] then
      if key == "repeat" then
        for subkey, subvalue in pairs(value) do
          template[key][subkey].value = subvalue
        end
      else
        template[key].value = value
      end
    end
  end
  return template
end

function stringifyCalendarTemplate(template)
  if template.alarms.value then 
    template.alarms.value = table.concat(template.alarms.value, ",")
  end
  return yamlDumpAligned(template)
end

function generateCalendarTemplate(specifier)
  return stringifyCalendarTemplate(fillCalenderTemplate(specifier))
end



PARSEABLE_FORMAT_COMPONENTS = {
  "uid",
  "calendar",
  "start",
  "title",
  "description",
  "location",
  "end",
  "url",
}

PARSEABLE_FORMAT_SPECIFIER = table.concat(
  map(
    PARSEABLE_FORMAT_COMPONENTS,
    function (component)
      return "{" .. component .. "}"
    end
  ), FIELD_SEPARATOR
) 

--- @type ItemSpecifier
KhalCommandSpecifier = {
  type = "khal-command",
  properties = {
    getables = {
      ["calendars"] = function(_)
        local res = run({
          "khal",
          "printcalendars"
        })
        return lines(res)
      end,
      ["writable-calendars"] = function(self)
        return filter(
          self:get("calendars"),
          { _start =  "r-:" }
          function (_, cal)
            return not stringy.startswith(cal,) -- inspired by rwx access rights
          end
        ))
      end,
      ["writable-calendar-string"] = function(self)
        return table.concat(self:get("writable-calendars"), ",")
      end,
      ["search-events"] = function(self, specifier)
        local command = {
          "khal",
          "search",
        }
        addFormatToCommand(command, specifier)
        addInclExclToCommand(command, specifier)
        push(command, { value = specifier.searchstr, type = "quoted" })
        return filter(stringx.split(run(command, true), RECORD_SEPARATOR))
      end,
      ["search-events-parseable"] = function(self, specifier)
        specifier.format = PARSEABLE_FORMAT_SPECIFIER
        return self:get("search-events", specifier)
      end,
      ["search-events-parsed"] = function(self, specifier)
        local res = self:get("search-events-parseable", specifier)
        return map(
          res,
          parseParseableKhalToSpecification
        )
      end,
      ["search-events-items"] = function(self, specifier)
        return map(
          self:get("search-events-parsed", specifier),
          function (event)
            return CreateEventTableItem(event)
          end
        )
      end,
      ["search-events-templates"] = function(self, specifier)
        local res = self:get("search-events-parsed", specifier)
        return map(
          res,
          function (event)
            return generateCalendarTemplate(event)
          end
        )
      end,
      ["list-events"] = function(self, specifier)
        local command = {
          "khal",
          "list",
          "-df", "\"\"" -- don't print an extra day line
        }
        addFormatToCommand(command, specifier)
        addInclExclToCommand(command, specifier)
        if specifier.once then
          push(command, "--once")
        end
        if specifier.notstarted then
          push(command, "--notstarted")
        end
        specifier.start = specifier.start or "today"
        specifier["end"] = specifier["end"] or date(os.time()):adddays(60):fmt("%Y-%m-%d")
        push(command, { value = specifier.start, type = "quoted" })
        push(command, { value = specifier["end"], type = "quoted" })
        return filter(stringx.split(run(command, true), RECORD_SEPARATOR ))
      end,
      ["list-events-parseable"] = function(self, specifier)
        specifier.format = PARSEABLE_FORMAT_SPECIFIER
        return self:get("list-events", specifier)
      end,
      ["list-events-parsed"] = function(self, specifier)
        local res = self:get("list-events-parseable", specifier)
        return map(
          res,
          parseParseableKhalToSpecification
        )
      end,
      ["list-events-items"] = function(self, specifier)
        return map(
          self:get("list-events-parsed", specifier),
          function (event)
            return CreateEventTableItem(event)
          end
        )
      end,
      
    },
    doThisables = {
      ["choose-writable-calendar"] = function(self, do_after)
        CreateArray(self:get("writable-calendars")):doThis("choose-item", do_after)
      end,
      ["delete-event"] = function(self, searchstr)
        -- ideally, the searchstr is an uid. If it is not, khal will delete the first event that matches the searchstr.
        run({ args = {
          "echo",
          "$'D\ny\n'", -- answer D and y to the prompts
          "|",
          "khal",
          "edit",
          { value = searchstr, type = "quoted" },
        }}, true)
      end,
      ["edit-event"] = function(self, searchstr)
        local specifier = self:get("search-events-parsed", { searchstr = searchstr })[1]
        self:doThis("add-event-interactive", {
          specifier = specifier,
          do_after = function()
            self:doThis("delete-event", searchstr)
          end,
        })
      end,
        
      ["add-event-from-url"] = function(self, specifier)
        local tmp_file = writeFile(nil, "")
        run({ args = {
          "curl",
          { value = specifier.url, type = "quoted" },
          "-O",
          { value = tmp_file, type = "quoted" },
          "&&",
          "khal",
          "import",
          "--include_calendar",
          { value = specifier.calendar, type = "quoted" },
          { value = tmp_file, type = "quoted" },
        }}, true)
      end,
      ["add-event-from-file"] = function(self, specifier)
        run({
          "khal",
          "import",
          "--include_calendar",
          { value = specifier.calendar, type = "quoted" },
          { value = specifier.path, type = "quoted" },
        }, specifier.do_after)
      end,
      ["add-event-interactive"] = function(self, specifier)
        specifier = specifier or {}
        local temp_file_contents = le(generateCalendarTemplate(specifier.specifier or {}))
        doWithTempFile({edit_before = true}, function(tmp_file)
          local new_specifier = yamlLoad(readFile(tmp_file, "error"))
          new_specifier.do_after = specifier.do_after
          self:doThis("add-event-from-specifier", new_specifier )
        end)
      end,
      ["add-event-from-specifier"] = function(self, specifier)
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
    },
  },
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateKhalCommand = bindArg(NewDynamicContentsComponentInterface, KhalCommandSpecifier)
