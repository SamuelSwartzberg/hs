--- @type ItemSpecifier
MailtoURLItemSpecifier = {
  type = "mailto-url",
  properties = {
    getables = {
      ["first-email"] = function (self)
        return get.mailto_url.first_email(self:get("c"))
      end,
      ["emails-array"] = function (self)
        return ar(transf.mailto_url.emails(self:get("c")))
      end,
      ["mailto-subject"] = function (self)
        return get.mailto_url.subject(self:get("c"))
      end,
      ["mailto-body"] = function (self)
        return get.mailto_url.body(self:get("c"))
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