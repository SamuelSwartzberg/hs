--- @type ItemSpecifier
OmegatProjectDirItemSpecifier = {
  type = "omegat-project-dir-item",
  properties = {
    getables = {
      ["corresponding-application-name"] = function(self)
        return "OmegaT"
      end,
      ["local-data-object-path"] = function(self)
        return self:get("contents") .. "/data.yaml"
      end,
      ["local-data-object"] = function(self)
        return yamlLoad(
          readFile(
            self:get("local-data-object-path"),
            "error"
          )
        )
      end,
      ["client"] = function (self)
        return self:get("local-data-object").client
      end,
      ["rechnung"] = function (self)
        return self:get("local-data-object").rechnung
      end,
      ["dictionary-dir"] = function(self)
        return self:get("contents") .. "/dictionary"
      end,
      ["glossary-dir"] = function(self)
        return self:get("contents") .. "/glossary"
      end,
      ["local-client-glossary"] = function(self)
        return self:get("glossary-dir") .. "/" .. self:get("client") .. ".txt"
      end,
      ["local-universal-glossary"] = function(self)
        return self:get("glossary-dir") .. "/universal.txt"
      end,
      ["global-client-glossary"] = function(self)
        return env.MGLOSSARIES .. "/" .. self:get("client") .. ".txt"
      end,
      ["global-universal-glossary"] = function(self)
        return env.MGLOSSARIES .. "/universal.txt"
      end,
      ["local-resultant-tm"] = function(self)
        return self:get("contents") .. "/" .. self:get("path-leaf") .. "-omegat.tmx"
      end,
      ["global-client-tm"] = function(self) -- is a dir
        return env.MTM_MEMORY .. "/" .. self:get("client") 
      end,
      ["global-universal-tm"] = function(self)
        return env.MTM_MEMORY .. "/universal"
      end,
      ["omegat-dir"] = function(self)
        return self:get("contents") .. "/omegat"
      end,
      ["source-dir"] = function(self)
        return self:get("contents") .. "/source"
      end,
      ["source-files"] = function(self)
        return self:get("str-item", { key = "source-dir" }):get("child-string-item-array")
      end,
      ["source-files-extension"] = function(self, ext)
        return self:get("str-item", { key = "source-dir" }):get("child-string-item-array"):get("filter-to-extension", ext)
      end,
      ["target-dir"] = function(self)
        return self:get("contents") .. "/target"
      end,
      ["target-files"] = function(self)
        return self:get("str-item", { key = "target-dir" }):get("child-string-item-array")
      end,
      ["target-files-extension"] = function(self, ext)
        return self:get("str-item", { key = "target-dir" }):get("child-string-item-array"):get("filter-to-extension", ext)
      end,
      ["length-target-files"] = function(self)
        return self:get("target-files-extension", "txt"):get("map", function(file)
          return file:get("file-contents-utf8-chars")
        end)
      end,
      
      ["data-object"] = function(self)
        local d = {}
        local local_data = self:get("local-data-object")
        d.rechnung = local_data.rechnung
        d.client = comp.clients[local_data.client]
        d.translations = self:get("length-target-files")
        return d
      end,
      ["tm-dir"] = function(self)
        return self:get("contents") .. "/tm"
      end,
      ["rechnung-noext-path"] = function (self)
        return self:get("contents") .. "/" .. os.date(tblmap.dt_component.rfc3339["day"]) .. "--" .. self:get("client") .. "_" .. self:get("rechnung").nr
      end,
      ["rechnung-raw-path"] = function (self)
        return self:get("rechnung-noext-path") .. ".md"
      end,
      ["rechnung-pdf-path"] = function (self)
        return self:get("rechnung-noext-path") .. ".pdf"
      end,
      ["rechnung-email"] = function(self)
        local d = self:get("data-object")
        local email = le(comp.documents.translation.rechnung_email_de, d)
        email = email .. "\n\n" .. transf.path.attachment(self:get("rechnung-pdf-path"))
        return email
      end,
      ["is-actually-project-dir"] = returnTrue,
      ["initial-dir-structure-specifier"] = function(self)
        return {
          mode = "write",
          overwrite = false,
          payload = {
            dictionary = false,
            glossary = false,
            omegat = false,
            source = false,
            target = false,
            tm = false,
          }
        }
      end,
    },
    doThisables = {
      ["create-and-open-new-source-odt"] = function(self, name)
        local path = self:get("source-dir") .. "/" .. name .. ".odt"
        open({path = path, app =  "LibreOffice"})
      end,
      ["open-project"] = function(self)
        self:doThis("do-running-application-ensure", function(application)
          application:doThis("open-recent", self:get("contents"))
          application:doThis("focus-main-window")
        end)
      end,
      ["choose-and-open-odt"] = function(self, source_or_target)
        self:get(source_or_target .. "-files", "odt"):doThis("choose-item", function(file)
          file:doThis("open-with-application", "LibreOffice")
        end)
      end,
      ["create-all-translated-documents"] = function(self)
        self:doThis("do-running-application-ensure", function(app)
          app:doThis("create-all-translated-documents")
        end)
      end,
      ["create-current-translated-document"] = function(self)
        self:doThis("do-running-application-ensure", function(app)
          app:doThis("create-current-translated-document")
        end)
      end,
      ["refresh-open-target-odts"] = function(self) -- the purpose of this method is to refresh the open libreoffice windows that hold the generated documents after changes in omegat, allowing for manual 'hot reloading'
        self:get("target-files-extension", "odt"):doThis("choose-item", function(file)
          local libreoffice_windows_with_file = file:get("window-items-of-app-path-leaf-as-title", 'LibreOffice') -- generally probably only one, but this is a list because we can't be sure
          for _, window in iprs(libreoffice_windows_with_file) do
            window:doThis("do-on-application-w-window-as-main", function(application)
              application:doThis("reload")
            end)
          end
         
        end)
      end,
      ["pull-glossaries"] = function(self)
        srctgt("copy", self:get("global-universal-glossary"), self:get("local-universal-glossary"))
        srctgt("copy", self:get("global-client-glossary"), self:get("local-client-glossary"))
      end,
      ["push-glossaries"] = function(self)
        srctgt("copy", self:get("local-universal-glossary"), self:get("global-universal-glossary"))
        srctgt("copy", self:get("local-client-glossary"), self:get("global-client-glossary"))
      end,
      ["pull-tm"] = function(self)
        srctgt("copy", self:get("global-universal-tm"), self:get("tm-dir"), "any", false, false, true)
        srctgt("copy", self:get("global-client-tm"), self:get("tm-dir"), "any", false, false, true)
      end,
      ["push-tm"] = function(self)
        srctgt("copy", self:get("local-resultant-tm"), self:get("global-client-tm"), "any", false, true)
      end,
      ["pull-omegat"] = function(self)
        self:doThis("pull-glossaries")
        self:doThis("pull-tm")
      end,
      ["push-omegat"] = function(self)
        self:doThis("push-glossaries")
        self:doThis("push-tm")
      end,
      ["generate-target-txts"] = function(self, do_after)
        local generation_tasks = self:get("target-files-extension", "odt"):get("map", function(odt)
          return CreateShellCommand("libreoffice"):get("to-txt-command", odt:get("contents"))
        end)
        runThreaded(generation_tasks, 1, do_after)
      end,
      ["generate-raw-rechnung"] = function(self, do_after)
        self:doThis("generate-target-txts", function()
          local d = self:get("data-object")
          local interpolated = le(comp.documents.translation.rechnung_de, d)
          writeFile(self:get("rechnung-raw-path"), interpolated)
          do_after()
        end)
      end,
      ["generate-rechnung"] = function(self)
        self:doThis("generate-raw-rechnung", function()
          CreateShellCommand("pandoc"):doThis("md-to-latexlike-pdf", {
            source = self:get("rechnung-raw-path"),
          })
        end)
        
      end,
      ["send-rechnung-email"] = function(self)
        CreateArray(
          getSortedEmailPaths(env.MBSYNC_ARCHIVE, true, "from:" .. self:get("local-data-object").email)
        )
          :get("to-string-item-array")
          :doThis("to-summary-line-body-path-table-parallel", function(table)
            table:doThis("choose-item", function(_, choice)

              CreateStringItem(choice.value)
                :doThis(
                  "email-reply-interactive", 
                  self:get("rechnung-email")
                )
            end)
          end)
  
      end,
      ["file-rechnung"] = function(self)
        local rechnung_target = CreateStringItem(env.MDIARY .. "/moments/work"):get("find-child", function(child) return stringy.endswith(child, "translation") end) .. "/rechnungen"
        self:get("str-item", "rechnung-pdf-path"):doThis("move-into-dir", rechnung_target)
      end,
      ["file-source-and-target"] = function(self)
        local source_odts = self:get("source-files-extension", "odt"):get("contents")
        local target_odts = self:get("target-files-extension", "odt"):get("contents")
        local odts = tablex.zip(source_odts, target_odts)
        for i, odt_pair in iprs(odts) do 
          for j, odt in iprs(odt_pair) do
            local client = self:get("local-data-object").client
            local path = CreatePathLeafParts({
              date = os.date(tblmap.dt_component.rfc3339["day"]),
              path = env.MDIARY .. "/i_made_this/translations/",
              ["general-name"] = pathSlice(odt:get("contents"), "-2:-2", { ext_sep = true })[1],
              extension = "odt",
              tag = {
                client = client,
                n = i,
                tcrea = j == 1 and client or "me"
              }
            }):get("path-leaf-parts-as-string")
            odt:doThis("move-safe",  path)
          end
        end
      end,
      ["finalize"] = function(self)
        self:doThis("push-omegat")
        self:doThis("generate-rechnung")
        self:doThis("send-rechnung-email")
        self:doThis("file-rechnung")
        self:doThis("file-source-and-target")
      end,
      ["create-default-data-yaml"] = function(self)
        writeFile(self:get("local-data-object-path"), yamlDump({
          rechnung = {
            nr = 1,
            delivery_date = os.date("%d.%m.%Y")
          },
          client = "jetbelt",
          email = "jetbelt@me.com"
        }))
      end,
      ["specific-initialize"] = function(self)
        self:doThis("create-default-data-yaml")
        CreateStringItem(self:get("local-data-object-path")):doThis("edit-file-interactive", function()
          self:doThis("pull-omegat")
          self:doThis("do-interactive", {
            thing = "Initial source document name",
            key = "create-and-open-new-source-odt"
          })
        end)
      end,

    }
  },
  action_table = concat({
    {
      text = "👉🌀🗄 copsrc.",
      key = "choose-and-open-odt",
      args = "source"
    },
    {
      text = "👉💥🗄 copstgt.",
      key = "choose-and-open-odt",
      args = "target"
    },
    {
      text = "♻️💥 reftgt.",
      key = "refresh-open-target-odts"
    },
    {
      text = "🌄全🌍 cralltransdoc.",
      key = "create-all-translated-documents"
    },
    {
      text = "🌄全🌍 crcurtransdoc.",
      key = "create-current-translated-document"
    },
    {
      text = "🌄🧾 crrcpt.",
      key = "generate-rechnung"
    },
    {
      text = "🌄🗄🌀 cropsrc.",
      key = "do-interactive",
      args = { key = "create-and-open-new-source-odt" }
    },

  }, getChooseItemTable({}))
}

--- @type BoundNewDynamicContentsComponentInterface
CreateOmegatProjectDirItem = bindArg(NewDynamicContentsComponentInterface, OmegatProjectDirItemSpecifier)