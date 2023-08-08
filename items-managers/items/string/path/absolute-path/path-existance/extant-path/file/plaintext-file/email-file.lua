

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
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateEmailFileItem = bindArg(NewDynamicContentsComponentInterface, EmailFileItemSpecifier)