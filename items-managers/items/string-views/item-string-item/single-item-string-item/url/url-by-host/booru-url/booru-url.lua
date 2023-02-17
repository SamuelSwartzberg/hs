--- @type ItemSpecifier
BooruURLItemSpecifier = {
  type = "booru-url",
  properties = {
    getables = {
      ["is-danbooru-url"] = function(self)
        return stringy.find(self:get("url-host"), "danbooru")
      end,
      ["is-gelbooru-url"] = function(self)
        return stringy.find(self:get("url-host"), "gelbooru")
      end
    }, 
    doThisables = {
      ["add-to-local"] = function(self)
        CreateStringItem(env.MBOORU_FAVORITE_LOGS):doThis("log-timestamp-table", {
          [os.time] = "add," .. self:get("contents")
        })
        CreateStringItem("Hydrus Network"):doThis("add-url-to-hydrus", self)
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "danbooru-url", value = CreateDanbooruURLItem },
    { key = "gelbooru-url", value = CreateGelbooruURLItem },
  }),

  action_table = {
    {
      text = "📌 addtbru.",
      key = "add-to-local",
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateBooruURLItem = bindArg(NewDynamicContentsComponentInterface, BooruURLItemSpecifier)