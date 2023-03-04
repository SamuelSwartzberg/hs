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
      ["all-contacts-to-string-items"] = function(self)
        return map(
          self:get("all-contact-uids"),
          function (contact)
            return CreateStringItem(contact)
          end
        )
      end,
      
      ["show-contact"] = function(self, uid)
        return memoize(run)( "khard show --format=yaml uid:" .. uid )
      end,
      ["find-contact"] = function(self, searchstr)
        return memoize(run)("khard show --format=yaml " .. searchstr )
      end,
      ["is-contact"] = function(self, uuid)
        local _, status = self:get("show-contact", uuid)
        return status
      end,
      ["show-contact-to-contact-table"] = function(self, uid)
        local contact_raw =  yamlLoad(self:get("show-contact", uid))
        contact_raw.uid = uid
        return CreateContactTableItem(contact_raw)
      end,
      ["find-contact-to-contact-table"] = function(self, searchstr)
        local contact_raw =  yamlLoad(self:get("find-contact", searchstr))
        contact_raw.uid = searchstr
        return CreateContactTableItem(contact_raw)
      end
    },
    doThisables = {
      ["get-array-of-contact-tables"] = function(self, do_after)
        runHsTaskNThreadsOnArray(self:get("all-contact-uids"), function(_, uid)
          return uid, {"khard", "show", "--format=yaml", "uid:" .. uid }
        end, function(raw_contact_table)
          local arr = map(raw_contact_table, function(uid, contact)
            contact = yamlLoad(contact)
            contact.uid = uid
            return false, CreateContactTableItem(contact)
          end, {"kv", "kv"})
          do_after(CreateArray(arr))
        end, 10)
      end,
    },
  },
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateKhardCommand = bindArg(NewDynamicContentsComponentInterface, KhardCommandSpecifier)
