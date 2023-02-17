--- @type ItemSpecifier
DanbooruURLItemSpecifier = {
  type = "danbooru-url",
  properties = {
    getables = {
      ["booru-post-id"] = function(self)
        return eutf8.match(self:get("url-path"), "/posts/(%d+)")
      end,
    }
  },
  
  action_table = {},
}

--- @type BoundNewDynamicContentsComponentInterface
CreateDanbooruURLItem = bindArg(NewDynamicContentsComponentInterface, DanbooruURLItemSpecifier)