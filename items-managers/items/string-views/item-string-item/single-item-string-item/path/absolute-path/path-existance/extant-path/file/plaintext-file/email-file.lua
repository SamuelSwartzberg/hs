

--- @type ItemSpecifier
EmailFileItemSpecifier = {
  type = "email-file",
  properties = {
    getables = {
      ["email-body-rendered-task"] = function(self)
        return {
          "mshow",
          "-R",
          { value = self:get("contents"), type = "quoted"}
        }
      end,
      ["email-body-rendered"] = function(self)
        return run(
          self:get("email-body-rendered-task")
        )
      end,
      ["email-body-quoted"] = function(self)
        return stringx.join(
          "\n",
          map(
            stringx.splitlines(
              stringy.strip(self:get("email-body-rendered"))
            ),
            function(v)
              if stringy.startswith(v, ">") then
                return ">" .. v
              else
                return ">" .. " " .. v
              end
            end
          )
        )
      end,
      ["with-email-body-quoted"] = function(self, response)
        return response .. "\n\n" .. self:get("email-body-quoted")
      end,
      ["email-useful-headers"] = function (self)
        return run({
          "mshow",
          "-q",
          { value = self:get("contents"), type = "quoted"}
        })
      end,
      ["email-all-decoded-headers"] = function(self)
        return run({
          "mshow",
          "-L",
          { value = self:get("contents"), type = "quoted"}
        })
      end,
      ["email-header"] = function(self, type)
        local raw_res = run({
          "mhdr",
          "-h",
          { value = type, type = "quoted" },
          "-d",
          { value = self:get("contents"), type = "quoted"}
        })
        return raw_res
      end,
      -- there is also -r to get the raw body, and -H to get all raw headers. However, those present a possible attack vector, so it's better to see if I can get by without them.
      ["mime-parts-raw"] = function(self)
        return run({
          "mshow",
          "-t",
          { value = self:get("contents"), type = "quoted"}
        })
      end,
      ["attachments"] = function(self)
        local raw_mime = self:get("mime-parts-raw")
        local attachments = {}
        for line in stringx.lines(raw_mime) do
          local name = line:match("name=\"(.-)\"")
          if name then
            table.insert(attachments, name)
          end
        end
        return attachments
      end,
      --- @param type "from"|"sender"|"reply-to"|"to"|"cc"|"bcc"
      ["involved-email-addresses"] = function(self, type)
        local raw_res
        if type then
          raw_res = run({
            "maddr",
            "-h",
            { value = type, type = "quoted" },
            { value = self:get("contents"), type = "quoted"}  
          })
        else
          raw_res = run({
            "maddr",
            { value = self:get("contents"), type = "quoted"}  
          })
        end
        local all_addr = stringy.split(raw_res, "\n")
        local addr = toSet(filter(all_addr, true))
        return addr
      end,
      ["email-summary-task"] = function(self, format_specifier)
        format_specifier = format_specifier or "%D **%f** %200s"
        return {
          "mscan",
          "-f",
          { value = format_specifier, type = "quoted" },
          { value = self:get("contents"), type = "quoted" }
        }
      end,
      ["email-summary"] = function(self, format_specifier)
        return run(self:get("email-summary-task", format_specifier))
      end,

    },
    doThisables = {
      ["download-attachment"] = function(self, name)
        run({
          "cd",
          env.TMPDIR,
          "&&",
          "mshow",
          "-x",
          { value = self:get("contents"), type = "quoted" },
          { value = name, type = "quoted" },
        }, true)
      end,
      ["choose-save-act-on-attachment"] = function(self)
        CreateArray(self:get("attachments")):doThis("choose-item", function(attachment)
          self:doThis("download-attachment", attachment)
          local path = ensureAdfix(env.TMPDIR, "/", true, false, "suf") .. attachment
          local file = CreateStringItem(path)
          file:doThis("choose-action")
        end)
      end,
      ["email-reply"] = function(self, specifier)
        sendEmailInteractive({
          from = env.MAIN_EMAIL,
          to = self:get("email-header", "from"),
          subject = "Re: " .. self:get("email-header", "subject")
        }, self:get("with-email-body-quoted", specifier.response or ""), specifier.edit_func)
      end,
      ["email-reply-interactive"] = function(self, response)
        self:doThis("email-reply", {
          response = response,
          edit_func = editorEditFunc
        })
      end,
      ["choose-involved-email"] = function(self)
        CreateArray(self:get("involved-email-addresses")):doThis("choose-item", function(email)
          CreateStringItem(email):doThis("choose-action")
        end)
      end,
      ["email-forward"] = function (self, specifier)
        sendEmailInteractive({
          from = env.MAIN_EMAIL,
          subject = "Fwd: " .. self:get("email-header", "subject"),
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
          { value = self:get("contents"), type = "quoted" }
        }, {
          "minc", -- incorporate the message (/cur -> /new, rename in accordance with the mblaze rules and maildir spec)
          { value = path, type = "quoted" }
        }, {
          "rm",
          { value = self:get("contents"), type = "quoted" }
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
      key = "choose-involved-email"
    }
  }, getChooseItemTable({
    {
      description = "sbj",
      emoji_icon = "👒",
      key = "email-header",
      args = "subject"
    },{
      description = "bdy",
      emoji_icon = "📜",
      key = "email-body"
    },{
      description = "bdyqt",
      emoji_icon = "📜💬",
      key = "email-body-quoted"
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