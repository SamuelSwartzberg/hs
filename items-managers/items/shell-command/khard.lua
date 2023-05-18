--- @type ItemSpecifier
KhardCommandSpecifier = {
  type = "khard-command",
  properties = {
    getables = {
      ["khard-list"] = function(self)
        return stringy.strip(memoize(run)(
          "khard list --parsable"
        ))
      end,
      ["all-contact-uids"] = function(self)
        local res = map(
          stringy.split(self:get("khard-list"), "\n"), 
          function (line)
            return stringy.split(line, "\t")[1]
          end
        )
        return res
      end,
      ["all-contact-uuids-to-string-items"] = function(self)
        return map(
          self:get("all-contact-uids"),
          function (contact)
            return CreateStringItem(contact)
          end
        )
      end,
      
      ["show-contact"] = function(self, uid)
        return memoize(run)( "khard show --format=yaml uid:" .. uid, {catch = true} )
      end,
      ["find-contact"] = function(self, searchstr)
        return memoize(run)("khard show --format=yaml " .. searchstr, {catch = true} )
      end,
      ["show-contact-yaml"] = function(self, uid)
        local cntct = yamlLoad(self:get("show-contact", uid))
        cntct.uid = uid
        return cntct
      end,
      ["find-contact-yaml"] = function(self, searchstr)
        local cntct = yamlLoad(self:get("find-contact", searchstr))
        cntct.uid = searchstr
        return cntct
      end,
      ["is-contact"] = function(self, uuid)
        local _, status = self:get("show-contact", uuid)
        return status
      end,
      ["show-contact-to-contact-table"] = function(self, uid)
        return CreateContactTableItem(yamlLoad(self:get("show-contact-yaml", uid)))
      end,
      ["find-contact-to-contact-table"] = function(self, searchstr)
        return CreateContactTableItem(yamlLoad(self:get("find-contact-yaml", searchstr)))
      end
    },
    doThisables = {
      ["get-array-of-contact-tables"] = function(self, do_after)
        runThreaded(map(self:get("all-contact-uids"), function(uid)
          return uid, {"khard", "show", "--format=yaml", "uid:" .. uid }
        end, {"v", "kv"}), 10, function(raw_contact_table)
          local arr = map(raw_contact_table, function(uid, contact)
            contact = yamlLoad(contact)
            contact.uid = uid
            return false, CreateContactTableItem(contact)
          end, {"kv", "kv"})
          do_after(CreateArray(arr))
        end)
      end,
    },
  },
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateKhardCommand = bindArg(NewDynamicContentsComponentInterface, KhardCommandSpecifier)
