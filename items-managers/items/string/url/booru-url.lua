--- @type ItemSpecifier
BooruURLItemSpecifier = {
  type = "booru-url",
  properties = {

    }, 
    doThisables = {
      ["add-to-local"] = function(self)
        st(env.MBOORU_FAVORITE_LOGS):doThis("log-timestamp-table", {
          [os.time] = "add," .. self:get("c")
        })
        
      end,
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateBooruURLItem = bindArg(NewDynamicContentsComponentInterface, BooruURLItemSpecifier)