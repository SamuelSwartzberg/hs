

--- @type ItemSpecifier
EmailFileItemSpecifier = {
  type = "email-file",
  properties = {
    doThisables = {
      ["choose-save-act-on-attachment"] = function(self)
        ar(transf.email_file.attachments(self:get("c"))):doThis("choose-item", function(attachment)
          dothis.email_file.download_attachment(self:get("c"), attachment, function(att_path)
            st(att_path):doThis("choose-action")
          end)
        end)
      end,
        
    }
  },
  action_table = {
    {
      text = "👉📎 cattch.",
      key = "choose-save-act-on-attachment"
    },{
      text = "↩️📧 re.",
      dothis = dothis.email_file.edit_then_reply
    },{
      text = "↪️📧 fwd.",
      dothis = dothis.email_file.edit_then_forward
    },{
      text = "👉📬 cemladdr.",
      getfn = get.email_file.addresses,
      act = "cia"
    },
    {
      d = "sbj",
      i = "👒",
      getfn = transf.email_file.subject,
    },{
      d = "bdy",
      i = "📜",
      getfn = transf.email_file.rendered_body,
    },{
      d = "bdyqt",
      i = "📜💬",
      getfn = transf.email_file.quoted_body,
    },{
      d = "smm",
      i = "⋯",
      getfn = transf.email_file.summary,
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateEmailFileItem = bindArg(NewDynamicContentsComponentInterface, EmailFileItemSpecifier)