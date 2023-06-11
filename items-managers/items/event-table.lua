--- @type ItemSpecifier
EventTableSpecifier = {
  type = "event-table",
  properties = {
    getables = {
      ["val"] = function(self, key)
        return self:get("c")[key]
      end,
      ["date"] = function(self, key)
        return date(self:get("val", key))
      end,
      ["date-item"] = function(self, key)
        return dat(self:get("date", key))
      end,
      ["to-string"] = function (self)
        return transf.event_table.event_tagline(self:get("c"))
      end,
    },
    doThisables = {
      ["delete-event"] = function(self)
        dothis.khal.delete_event(self:get("c").uid)
      end,
      ["edit-event"] = function(self)
        dothis.khal.edit_event(self:get("c").uid)
      end,
      ["create-similar"] = function(self)
        dothis.khal.add_event_interactive(self:get("c"))
      end,

    }
  },
  
  action_table = concat(
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

