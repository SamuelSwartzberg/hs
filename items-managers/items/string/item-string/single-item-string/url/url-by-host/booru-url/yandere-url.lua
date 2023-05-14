--- @type ItemSpecifier
YandereURLItemSpecifier = {
  type = "Yandere-url",
  properties = {
    getables = {
      ["booru-post-id"] = function(self)
        return eutf8.match(self:get("url-path"), "/post/show/(%d+)")
      end,
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateYandereURLItem = bindArg(NewDynamicContentsComponentInterface, YandereURLItemSpecifier)