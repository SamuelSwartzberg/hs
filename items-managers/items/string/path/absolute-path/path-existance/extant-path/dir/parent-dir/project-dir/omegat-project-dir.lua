--- @type ItemSpecifier
OmegatProjectDirItemSpecifier = {
  type = "omegat-project-dir",
  properties = {
    doThisables = {
      ["choose-and-open-odt"] = function(self, source_or_target)
        self:get(source_or_target .. "-files", "odt"):doThis("choose-item", function(file)
          file:doThis("open-with-application", "LibreOffice")
        end)
      end,
      ["refresh-open-target-odts"] = function(self) -- the purpose of this method is to refresh the open libreoffice windows that hold the generated documents after changes in omegat, allowing for manual 'hot reloading'
        self:get("target-files-extension", "odt"):doThis("choose-item", function(file)
          local libreoffice_windows_with_file = file:get("window-items-of-app-path-leaf-as-title", 'LibreOffice') -- generally probably only one, but this is a list because we can't be sure
          for _, window in ipairs(libreoffice_windows_with_file) do
            window:doThis("do-on-application-w-window-as-main", function(application)
              application:doThis("reload")
            end)
          end
         
        end)
      end,
      ["send-rechnung-email"] = function(self)
        ar(
          get.maildir_dir.sorted_email_paths(env.MBSYNC_ARCHIVE, true, "from:" .. self:get("local-data-object").email)
        )
          :get("to-string-item-array")
          :doThis("to-summary-line-body-path-table-parallel", function(table)
            table:doThis("choose-item", function(_, choice)

              st(choice.value)
                :doThis(
                  "email-reply-interactive", 
                  self:get("rechnung-email")
                )
            end)
          end)
  
      end,
      ["file-rechnung"] = function(self)
        local rechnung_target = get.dir.find_child(env.MDIARY .. "/moments/work", {_stop =  "translation"}) .. "/rechnungen"

        self:get("str-item", "rechnung-pdf-path"):doThis("move-into-dir", rechnung_target)
      end,
      ["file-source-and-target"] = function(self)
        local source_odts = self:get("source-files-extension", "odt"):get("c")
        local target_odts = self:get("target-files-extension", "odt"):get("c")
        local odts = tablex.zip(source_odts, target_odts)
        for i, odt_pair in ipairs(odts) do 
          for j, odt in ipairs(odt_pair) do
            local client = self:get("local-data-object").client
            local path = transf.path_leaf_parts.full_path({
              date = os.date(tblmap.dt_component.rfc3339["day"]),
              path = env.MDIARY .. "/i_made_this/translations/",
              ["general-name"] = pathSlice(odt:get("completely-resolved-path"), "-2:-2", { ext_sep = true })[1],
              extension = "odt",
              tag = {
                client = client,
                n = i,
                tcrea = j == 1 and client or "me"
              }
            })
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