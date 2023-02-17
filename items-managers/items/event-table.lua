--- @type ItemSpecifier
EventTableSpecifier = {
  type = "event-table",
  properties = {
    getables = {
      ["val"] = function(self, key)
        return self:get("contents")[key]
      end,
      ["date"] = function(self, key)
        return date(self:get("val", key))
      end,
      ["date-item"] = function(self, key)
        return CreateDate(self:get("date", key))
      end,
      ["to-string"] = function (self)
        local contents = self:get("contents")
        local str = contents.start
        if contents["end"] then
          str = str .. " - " .. contents["end"]
        end
        str = str .. " " .. contents.calendar .. ":"
        if contents.title then
          str = str .. " " .. contents.title
        end
        if contents.location then
          str = str .. " @ " .. contents.location
        end
        if contents.description then
          str = str .. " :: " .. contents.description
        end
        if contents.url then
          str = str .. " Link: " .. contents.url
        end
        return str
      end
    },
    doThisables = {
      ["delete-event"] = function(self)
        CreateShellCommand("khal"):doThis("delete-event", self:get("contents").uid)
      end,
      ["edit-event"] = function(self)
        CreateShellCommand("khal"):doThis("edit-event", self:get("contents").uid)
      end,
      ["create-similar"] = function(self)
        CreateShellCommand("khal"):doThis("add-event-interactive", {
          specifier = self:get("contents")
        })
      end,

    }
  },
  
  action_table = listConcat(
    getChooseItemTable({
      { emoji_icon = "📇", description = "cl", key = "val", args = "calendar"},
      
      { emoji_icon = "🏧", description = "ttl", key = "val", args = "title"},
      { emoji_icon = "💬", description = "dsc", key = "val", args = "description", check = true},
      { emoji_icon = "🔗", description = "url", key = "val", args = "url", check = true},
      { emoji_icon = "📍", description = "lc", key = "val", args = "location"},

    }),
    {
      { 
        text = "👉🎬📅 cst.",
        key = "choose-item-on-result-of-get",
        args = {
          key ="date-item",
          args = "start"
        } 
      },{
        text = "👉🏁📅 ced.",
        key = "choose-item-on-result-of-get",
        args = {
          key ="date-item",
          args = "end"
        }
      },{
        text = "👉⏰ cal.",
        key = "choose-item-on-result-of-get",
        args = {
          key ="array",
          args = {
            key = "val",
            args = "alarms"
          }
        }
      },{
        text = "🗑 rmev.",
        key = "delete-event"
      },{
        text = "✏️ edev.",
        key = "edit-event"
      },{
        text = "🌄 crsev.",
        key = "create-similar"
      }
    }
  )
}




--- @type BoundRootInitializeInterface
function CreateEventTableItem(contents)
  return RootInitializeInterface(EventTableSpecifier, contents)
end

