local format_map = tblmap.date_format_name.date_format
local formats = keys(format_map)
local format_array = CreateArray(formats)



--- @type ItemSpecifier
DateSpecifier = {
  type = "date",
  properties = {
    getables = {
      ["with-added"] = function(self, specifier)
        local date = self:get("contents"):copy()
        return CreateDate(
          date["add" .. specifier["unit"]](date, specifier["amount"])
        )
      end,
      ["with-subtracted"] = function(self, specifier)
        return self:get("with-added", {
          unit = specifier["unit"],
          amount = -specifier["amount"]
        })
      end,
      ["addable-units"] = function(self)
        return { "years", "months", "days", "hours", "minutes", "seconds", "ticks" }
      end,
      ["val"] = function(self, unit)
        local dt = self:get("contents")
        return dt["get" .. unit](dt)
      end,
      ["gettable-units"] = function(self)
        return { "date", "year", "isoyear", "month", "yearday", "weekday", "isoweekday", "weeknum", "isoweeknum", "day", "time", "hours", "minutes", "seconds", "fracs", "ticks" }
      end,
      ["span"] = function(self, unit)
        local dt = self:get("contents")
        return dt["span" .. unit](dt)
      end,
      ["diff"] = function(self, other_date)
        return date.diff(self:get("contents"), other_date)
      end,
      ["diff-item"] = function(self, other_date)
        return CreateDate(self:get("diff", other_date))
      end,
      ["diff-span"] = function(self, specifier)
        return self:get("diff-item", specifier["end"]):get("span", specifier["unit"])
      end,
      ["start-end"] = function(self, specifier)
        local startdt = processDateSpecification(specifier.start, self:get("contents"))
        local enddt = processDateSpecification(specifier["end"], self:get("contents"))
        return {startdt, enddt}
      end,
      ["range"] = function(self, specifier)
        local startdt, enddt = table.unpack(self:get("start-end", specifier))
        return seq(startdt, enddt, specifier.step, specifier.unit)
      end,
      ["item-range"] = function(self, specifier)
        return map(
          self:get("range", specifier),
          function(dt)
            return CreateDate(dt)
          end
        )
      end,
      ["hours-in-day-range"] = function(self)
        return self:get("range", {
          start = { precision = "day" },
          ["end"] = { precision = "day", unit = "days", amount = 1 },
          unit = "hours"
        })
      end,
      ["hours-in-day-item-range"] = function(self)
        return map(
          self:get("hours-in-day-range"),
          function(dt)
            return CreateDate(dt)
          end
        )
      end,
      ["quarters-in-day-range"] = function(self)
        return self:get("range", {
          start = { precision = "day" },
          ["end"] = { precision = "day", unit = "days", amount = 1 },
          unit = "minutes",
          step = 15
        })
      end,
      ["quarters-in-day-item-range"] = function(self)
        return map(
          self:get("quarters-in-day-range"),
          function(dt)
            return CreateDate(dt)
          end
        )
      end,
      ["surrounding-days-range"] = function(self, amount)
        amount = amount or 45
        local res = self:get("item-range", {
          start = { unit = "days", amount = -amount, precision = "day" },
          ["end"] = { unit = "days", amount = amount, precision = "day" },
          unit = "days"
        })
        res[amount + 1].properties.getables["chooser-initial-selected"] = returnTrue
        return res
      end,
      ["event-items-between"] = function(self, specifier)
        specifier["end"] = specifier["end"] or self:get("contents"):copy():adddays(30)
        local startdt, enddt = table.unpack(self:get("start-end", specifier))
        return CreateArray({
          CreateDate(startdt),
          CreateDate(enddt)
        }):get("map-to-event-items")
      end,
      ["to-formatted"] = function(self, format_str)
        return self:get("contents"):fmt(format_str)
      end,
      ["format-map"] = function(self)
        return format_map
      end,
      ["to-given-format"] = function(self, format)
        return self:get("to-formatted", self:get("format-map")[format])
      end,
      ["has-time"] = function(self)
        local dt = self:get("contents")
        return 
          dt.gethours(dt) ~= 0 or
          dt.getminutes(dt) ~= 0 or
          dt.getseconds(dt) ~= 0 or
          dt.getfracs(dt) ~= 0
      end,
      ["weekday-number-start-1"] = function(self) 
        return self:get("contents"):getisoweekday()
      end,
      ["weekday-number-start-0"] = function(self) 
        return self:get("contents"):getisoweekday() - 1
      end,
      ["weekday-str"] = function(self)
        return transf.mon1_int.weekday_en[self:get("weekday-number-start-1")] 
      end,
      ["weeknumber"] = function(self)
        return self:get("contents"):getweeknumber()
      end,
      ["weekday-offset"] = function(self, specifier) -- get the nth previous/next weekday
        -- specifier has keys "weekday" and "offset"
        if type(specifier.weekday) == "string" then
          specifier.weekday = transf.weekday_en.mon1_int[specifier.weekday]
        end

        local weekday_number = self:get("weekday-number-start-0")
        local nearest_day_offset
        if specifier.direction == "+" then
          nearest_day_offset = subtractionRingModuloN(weekday_number, specifier.weekday, 7)
        elseif specifier.direction == "-" then
          nearest_day_offset = -subtractionRingModuloN(specifier.weekday, weekday_number, 7)
        else
          error("Invalid direction: " .. specifier.direction)
        end

        local nearest_date_with_correct_weekday = self:get("with-added",{
          unit = "days",
          amount = nearest_day_offset
        })

        return nearest_date_with_correct_weekday:get("with-added",{
          unit = "weeks",
          amount = math.abs(specifier.offset - 1)
        })
      end,

      ["timestamp"] = function(self)
        return date.diff(self:get("contents"), date.epoch()):spanseconds()
      end,
      
      ["to-precision"] = function(self, component) -- component is a string, either "year", "month", "day", "hour", "minute", "second"
        return self:get("contents"):fmt(tblmap.dt_component.rfc3339[component])
      end,
      ["date-to-precision"] = function (self, component)
        return date(self:get("to-precision", component))
      end,
      ["date-item-to-precision"] = function(self, component)
        return CreateDate(self:get("date-to-precision", component))
      end,
      ["format-array"] = function()
        return format_array
      end,
      ["to-string"] = function(self)
        return self:get("contents"):fmt("%A, %Y-%m-%d %H:%M:%S")
      end,
      ["to-y-ym-ymd-array"] = function(self)
        local contents = self:get("contents")
        return {
          contents:fmt("%Y"),
          contents:fmt("%Y-%m"),
          contents:fmt("%Y-%m-%d"),
        }
      end,
      ["corresponding-logfile"] = function(self, logging_dir)
        return CreateStringItem(logging_dir):get("log-for-date", self:get("contents"))
      end,
    },
    doThisables = {
      ["choose-format"] = function(self, do_after)
        format_array:doThis("choose-item", function(format)
          do_after(self:get("to-given-format", format))
        end)
      end,
      ["choose-format-and-action"] = function(self)
        self:doThis("choose-format", function(format)
          CreateStringItem(format):doThis("choose-action")
        end)
      end,
      ["create-log-entry"] = function(self, specifier)
        CreateStringItem(specifier.path):doThis("log-timestamp-table", ovtable.init({{
          key = tostring(self:get("timestamp")),
          value = specifier.contents
        }}))
      end,
      ["create-empty-log-entry"] = function(self, path)
        self:doThis("create-log-entry", {
          path = path,
          contents = {}
        })
      end,
      ["log-open-diary"] = function(self)
        self:doThis("create-empty-log-entry", env.MENTRY_LOGS)
        open(CreateStringItem(env.MENTRY_LOGS):get("log-for-date", self:get("contents")))
      end,
      ["choose-surrounding-day"] = function(self, amount)
        CreateArray(self:get(
          "surrounding-days-range",
          amount
        )):doThis("choose-item-and-then-action")
      end,
      ["create-event-with-start"] = function(self)
        CreateShellCommand("khal"):doThis("add-event-interactive", {
          specifier = {
            start = self:get("to-precision", "min")
          }
        })
      end,
    }
  },
  
  action_table = concat({
    {
      text = "👉📏 cfmt.",
      key = "choose-format-and-action"
    }, {
      text = "📓🗄🦄 logop-dia.",
      key = "log-open-diary",
    }, {
      text = "👉🤗📅 csrdy.",
      key = "choose-surrounding-day",
    }, {
      text = "👉🕚 ctm.",
      key = "choose-item-and-then-action-on-result-of-get",
      args = {
        key = "array",
        args = {
          key = "quarters-in-day-item-range"
        }
      }
    }, {
      text = "🌄🍾 crev.",
      key = "create-event-with-start"
    }, {
      text = "👉🍾 cev.",
      key = "choose-item-and-then-action-on-result-of-get",
      args = {
        key = "array",
        args = {
          key = "event-items-between"
        }
      }
    }
  }, getChooseItemTable({
    {
      description = "wkd.",
      emoji_icon = "🌞",
      key = "weekday-str"
    }
  }))
}


--- @type BoundNewDynamicContentsComponentInterface
CreateDate = bindArg(RootInitializeInterface, DateSpecifier)