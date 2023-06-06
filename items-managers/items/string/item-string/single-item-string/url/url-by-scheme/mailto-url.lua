--- @type ItemSpecifier
MailtoURLItemSpecifier = {
  type = "mailto-url",
  properties = {
    getables = {
      ["first-email"] = function (self)
        return get.mailto_url.first_email(self:get("contents"))
      end,
      ["emails-array"] = function (self)
        return CreateArray(transf.mailto_url.emails(self:get("contents")))
      end,
      ["mailto-subject"] = function (self)
        return get.mailto_url.subject(self:get("contents"))
      end,
      ["mailto-body"] = function (self)
        return get.mailto_url.body(self:get("contents"))
      end,
    }, 
    doThisables = {
      
    }
  },

  action_table = concat(getChooseItemTable({
    {
      description = "sbj",
      emoji_icon = "👒",
      key = "mailto-subject"
    },{
      description = "bdy",
      emoji_icon = "📜",
      key = "mailto-body"
    },{
      description = "1steml",
      emoji_icon = "📧",
      key = "first-email"
    },
  }),{
    {
      key = "choose-item-and-then-action-on-result-of-get",
      args = { key = "emails-array"},
      text = "👉📧 ceml."
    }
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateMailtoURLItem = bindArg(NewDynamicContentsComponentInterface, MailtoURLItemSpecifier)