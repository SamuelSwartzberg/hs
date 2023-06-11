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
      end,
      ["is-yandere-url"] = function(self)
        return stringy.find(self:get("url-host"), "yande.re")
      end,

    }, 
    doThisables = {
      ["add-to-local"] = function(self)
        st(env.MBOORU_FAVORITE_LOGS):doThis("log-timestamp-table", {
          [os.time] = "add," .. self:get("c")
        })
        
      end,
    }
  },
  potential_interfaces = ovtable.init({
    { key = "danbooru-url", value = CreateDanbooruURLItem },
    { key = "gelbooru-url", value = CreateGelbooruURLItem },
    { key = "yandere-url", value = CreateYandereURLItem },
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