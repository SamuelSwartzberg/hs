
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

--- @type ItemSpecifier
KhalCommandSpecifier = {
  type = "khal-command",
  properties = {
    getables = {
      
    },
    doThisables = {
      ["choose-writable-calendar"] = function(self, do_after)
        CreateArray(get.khal.writeable_calendars()):doThis("choose-item", do_after)
      end,
        
    },
  },
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateKhalCommand = bindArg(NewDynamicContentsComponentInterface, KhalCommandSpecifier)
