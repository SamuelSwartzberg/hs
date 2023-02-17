--- @type ItemSpecifier
GelbooruURLItemSpecifier = {
  type = "gelbooru-url",
  properties = {
    getables = {
      ["booru-post-id"] = function(self)
        return eutf8.match(self:get("url-query"), "?page=post&s=view&id=(%d+)")
      end,
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateGelbooruURLItem = bindArg(NewDynamicContentsComponentInterface, GelbooruURLItemSpecifier)