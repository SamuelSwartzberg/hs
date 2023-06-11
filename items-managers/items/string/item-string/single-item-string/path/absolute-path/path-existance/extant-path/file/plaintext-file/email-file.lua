

--- @type ItemSpecifier
EmailFileItemSpecifier = {
  type = "email-file",
  properties = {
    doThisables = {
      ["download-attachment"] = function(self, name)
        run({
          "cd",
          env.TMPDIR,
          "&&",
          "mshow",
          "-x",
          { value = self:get("completely-resolved-path"), type = "quoted" },
          { value = name, type = "quoted" },
        }, true)
      end,
      ["choose-save-act-on-attachment"] = function(self)
        ar(self:get("attachments")):doThis("choose-item", function(attachment)
          self:doThis("download-attachment", attachment)
          local path = mustEnd(env.TMPDIR, "/") .. attachment
          local file = st(path)
          file:doThis("choose-action")
        end)
      end,
      ["email-reply"] = function(self, specifier)
        sendEmailInteractive({
          from = env.MAIN_EMAIL,
          to = transf.email_file.to(self:get("completely-resolved-path")),
          subject = "Re: " .. transf.email_file.subject(self:get("completely-resolved-path")),
        }, self:get("with-email-body-quoted", specifier.response or ""), specifier.edit_func)
      end,
      ["email-reply-interactive"] = function(self, response)
        self:doThis("email-reply", {
          response = response,
          edit_func = editorEditFunc
        })
      end,

      ["email-forward"] = function (self, specifier)
        sendEmailInteractive({
          from = env.MAIN_EMAIL,
          subject = "Fwd: " .. transf.email_file.subject(self:get("completely-resolved-path")),
          to = specifier.to or ""
        }, self:get("with-email-body-quoted", specifier.response or ""), specifier.edit_func)
      end,
      ["email-forward-interactive"] = function(self, response)
        self:doThis("email-forward", {
          response = response,
          edit_func = editorEditFunc
        })
      end,
      ["email-move-to"] = function(self, path)
        run({
          "mdeliver",
          { value = path, type = "quoted" },
          "<",
          { value = self:get("completely-resolved-path"), type = "quoted" }
        }, {
          "minc", -- incorporate the message (/cur -> /new, rename in accordance with the mblaze rules and maildir spec)
          { value = path, type = "quoted" }
        }, {
          "rm",
          { value = self:get("completely-resolved-path"), type = "quoted" }
        }, true)
      end,
    }
  },
  action_table = concat({
    {
      text = "👉📎 cattch.",
      key = "choose-save-act-on-attachment"
    },{
      text = "↩️📧 re.",
      key = "email-reply-interactive"
    },{
      text = "↪️📧 fwd.",
      key = "email-forward-interactive"
    },{
      text = "☑️ arch.",
      key = "email-move-to",
      args = env.MBSYNC_ARCHIVE
    },{
      text = "👉📬 cemladdr.",
      getfn = get.email_file.addresses,
      filter = ar,
      act = "cia"
    }
  }, getChooseItemTable({
    {
      description = "sbj",
      emoji_icon = "👒",
      getfn = transf.email_file.subject,
    },{
      description = "bdy",
      emoji_icon = "📜",
      key = "email-body"
    },{
      description = "bdyqt",
      emoji_icon = "📜💬",
      getfn = transf.email_file.quoted_body,
      get = "email-body-rendered"
    },{
      description = "smm",
      emoji_icon = "⋯",
      key = "email-summary"
    },{
      description = "hdrs",
      emoji_icon = "📊",
      key = "email-all-decoded-headers"
    }
  }))
}

--- @type BoundNewDynamicContentsComponentInterface
CreateEmailFileItem = bindArg(NewDynamicContentsComponentInterface, EmailFileItemSpecifier)