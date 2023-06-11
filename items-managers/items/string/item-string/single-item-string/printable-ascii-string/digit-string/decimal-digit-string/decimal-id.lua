--- @type ItemSpecifier
DecimalIdItemSpecifier = {
  type = "decimal-id",
  properties = {
    getables = {
      ["get-gelbooru-url"] = function(self)
        return "https://gelbooru.com/index.php?page=post&s=view&id=" .. self:get("decimal-numeric-value")
      end,
      ["get-danbooru-url"] = function(self)
        return "https://danbooru.donmai.us/posts/" .. self:get("decimal-numeric-value")
      end,
      ["get-gelbooru-url-string-item"] = function(self)
        return st(self:get("get-gelbooru-url"))
      end,
      ["get-danbooru-url-string-item"] = function(self)
        return st(self:get("get-danbooru-url"))
      end,
    },
    doThisables = { }
  },
  
  action_table = {},
}

--- @type BoundNewDynamicContentsComponentInterface
CreateDecimalIdItem = bindArg(NewDynamicContentsComponentInterface, DecimalIdItemSpecifier)
