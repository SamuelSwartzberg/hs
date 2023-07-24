



--- @type ItemSpecifier
DateSpecifier = {
  type = "date",
  properties = {
    getables = {
      ["weekday-str"] = function(self)
        return transf.mon1_int.weekday_en[self:get("weekday-number-start-1")] 
      end,
      ["weekday-offset"] = function(self, specifier) -- get the nth previous/next weekday
        -- specifier has keys "weekday" and "offset"
        if type(specifier.weekday) == "string" then
          specifier.weekday = transf.weekday_en.mon1_int[specifier.weekday]
        end

        local weekday_number = self:get("weekday-number-start-0")
        local nearest_day_offset
        if specifier.direction == "+" then
          nearest_day_offset = get.two_numbers.difference_modulo_n(weekday_number, specifier.weekday, 7)
        elseif specifier.direction == "-" then
          nearest_day_offset = -get.two_numbers.difference_modulo_n(specifier.weekday, weekday_number, 7)
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
      ["to-string"] = function(self)
        return self:get("c"):fmt("%A, %Y-%m-%d %H:%M:%S")
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
          st(format):doThis("choose-action")
        end)
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
      d = "wkd.",
      i = "🌞",
      key = "weekday-str"
    }
  }))
}


--- @type BoundNewDynamicContentsComponentInterface
dat = bindArg(RootInitializeInterface, DateSpecifier)