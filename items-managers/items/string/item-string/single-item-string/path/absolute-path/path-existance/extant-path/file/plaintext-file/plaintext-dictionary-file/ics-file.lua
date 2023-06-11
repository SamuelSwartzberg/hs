

--- @type ItemSpecifier
IcsFileItemSpecifier = {
  type = "ics-file",
  properties = {
    getables = {
      ["parse-to-lua-table"] = bc( transf.ics_file.array_of_tables)
      
    },
    doThisables = {
      ["add-events-to-calendar"] = function(self)
        ar(get.khal.writeable_calendars()):doThis("choose-item", function(calendar)
          dothis.khal.add_event_from_file(calendar, self:get("c"))
        end)
      end,
    }
  },
  action_table = concat(
    {
      {
        {
          key = "add-events-to-calendar",
          text = "➕📅 addevcal",
        }
      }
    }
  )
}

--- @type BoundNewDynamicContentsComponentInterface
CreateIcsFileItem = bindArg(NewDynamicContentsComponentInterface, IcsFileItemSpecifier)