NonEmptyTableSpecifier = {
  type = "non-empty-table",
  properties = {
    getables = {
      ["keys"] = function(self)
        return keys(self:get("c"))
      end,
      ["keys-to-new-array"] = function(self)
        return ar(self:get("keys"))
      end,
      ["value"] = function(self, key)
        return self:get("c")[key]
      end,
      ["key"] = function(self, value)
        return find(self:get("c"), value, {"v", "k"})
      end,
      ["first-match-in-list-of-keys"] = function (self, list_of_keys)
        local contents = self:get("c")
        for _, key in ipairs(list_of_keys) do
          if contents[key] then
            return contents[key]
          end
        end
      end,
      ["values"] = function(self)
        return values(self:get("c"))
      end,
      ["values-to-new-array"] = function(self)
        return ar(self:get("values"))
      end,
      ["pairs"] = function(self)
        return map(self:get("c"), function(k,v) return false, {k,v} end, "kv")
      end,
      ["pairs-to-new-array"] = function(self)
        return ar(self:get("pairs"))
      end,
      ["first-key"] = function(self)
        return self:get("keys")[1]
      end,
      ["first-value"] = function(self)
        return self:get("values")[1]
      end,
      ["first-pair"] = function(self)
        return self:get("pairs")[1]
      end,
      ["last-key"] = function(self)
        return self:get("keys")[self:get("amount-of-elements")]
      end,
      ["last-value"] = function(self)
        return self:get("values")[self:get("amount-of-elements")]
      end,
      ["last-pair"] = function(self)
        return self:get("pairs")[self:get("amount-of-elements")]
      end,
      ["all-keys-pass"] = function(self, predicate)
        return not find(self:get("c"), function(k) return not predicate(k) end, "k")
      end,
      ["all-values-pass"] = function(self, predicate)
        return not find(self:get("c"), function(v) return not predicate(v) end, "v")
      end,
      ["all-pairs-pass"] = function(self, predicate)
        return not find(self:get("c"), function(k,v) return not predicate(k,v) end, "kv")
      end,
      ["some-keys-pass"] = function(self, predicate)
        return find(self:get("c"), predicate, {"k", "boolean"})
      end,
      ["some-values-pass"] = function(self, predicate)
        return find(self:get("c"), predicate, {"v", "boolean"})
      end,
      ["some-pairs-pass"] = function(self, predicate)
        return find(self:get("c"), predicate, {"kv", "boolean"})
      end,
      ["none-keys-pass"] = function(self, predicate)
        return not find(self:get("c"), predicate, {"k", "boolean"})
      end,
      ["none-values-pass"] = function(self, predicate)
        return not find(self:get("c"), predicate, {"v", "boolean"})
      end,
      ["none-pairs-pass"] = function(self, predicate)
         return not find(self:get("c"), predicate, {"kv", "boolean"})
      end,
      ["all-keys-are-in-list"] = function(self, list)
        return not find(self:get("c"), {
          _list = list,
          _invert = true,
        }, "k")
      end,
      ["all-values-are-in-list"] = function(self, list)
        return not find(self:get("c"), {
          _list = list,
          _invert = true,
        }, "v")
      end,
      ["all-pairs-are-in-list"] = function(self, list)
        return not find(self:get("c"), {
          _list = list,
          _invert = true,
        }, "kv")
      end,
      ["find-key"] = function(self, predicate)
        return find(self:get("c"), predicate, "k")
      end,
      ["find-value"] = function (self, predicate)
        return find(self:get("c"), predicate)
      end,
      ["find-pair"] = function (self, predicate)
        return find(self:get("c"), predicate, "kv") 
      end,
      ["map-table"] = function(self, callback)
        return map(self:get("c"), callback, {"kv", "kv"})
      end,
      ["map-keys"] = function(self, callback)
        return map(self:get("keys"), callback)
      end,
      ["map-values"] = function(self, callback)
        return map(self:get("values"), callback)
      end,
      ["map-keys-to-new-array"] = function(self, callback)
        return ar(self:get("map-keys", callback))
      end,
      ["map-values-to-new-array"] = function(self, callback)
        return ar(self:get("map-values", callback))
      end,
      ["map-to-flat-path-dot-table"] = function(self)
        return tb(flatten(self:get("c"), {
          mode = "path-assoc",
          val = "plain",
          join_path = ".",
          treat_as_leaf = "list",
        }))
      end,
      ["type-of-first-is-type-of-all"] = function(self, kv)
        local first = self:get("first-" .. kv)
        local type = typeOfPrimitiveOrInterface(first)
        return self:get("all-" .. kv .. "s-pass", function(item) return typeOfPrimitiveOrInterface(item) == type end)
      end,
      ["is-homogeneous-key-table"] = function(self)
        return self:get("type-of-first-is-type-of-all", "key")
      end,
      ["is-homogeneous-value-table"] = function(self)
        return self:get("type-of-first-is-type-of-all", "value")
      end,
      ["is-heterogeneous-key-table"] = returnTrue,
      ["is-heterogeneous-value-table"] = returnTrue, -- as 'heterogeneous' is to be interpreted as 'possibly heterogeneous', this is always true
      ["is-homo-k-homo-v-table"] = function(self)
        return self:get("is-homogeneous-key-table") and self:get("is-homogeneous-value-table")
      end,
      ["is-homo-k-hetero-v-table"] = function(self)
        return self:get("is-homogeneous-key-table") and self:get("is-heterogeneous-value-table")
      end,
      ["is-hetero-k-homo-v-table"] = function(self)
        return self:get("is-heterogeneous-key-table") and self:get("is-homogeneous-value-table")
      end,
      ["is-hetero-k-hetero-v-table"] = returnTrue, -- can't be false
      ["chooser-list-of-keys"] = function(self)
        return self:get("keys-to-new-array"):get("chooser-list-of-all")
      end,
      ["chooser-list-of-values"] = function(self)
        return self:get("values-to-new-array"):get("chooser-list-of-all")
      end,
      ["map-pairs-to-string"] = function(self)
        return map(self:get("c"), function(k, v)
          local pair_value_as_text
          if type(v) == "table" and v.get then 
            pair_value_as_text = v:get("to-string")
          else 
            pair_value_as_text = tostring(v)
          end
          pair_value_as_text = eutf8.gsub(pair_value_as_text, "\n", " ")
          return "[" .. tostring(k) .. "] = " .. pair_value_as_text
        end, {"kv", "v"})
      end,
      ["to-string"] = function(self)
        return "table: " .. table.concat(values(self:get("map-pairs-to-string")), ", ")
      end,
      ["to-string-multiline"] = function(self)
        return table.concat(values(self:get("map-pairs-to-string")), ",\n")
      end,
      ["chooser-list-of-pairs"] = function(self)
        local list = {}
        for k, v in wdefarg(fastpairs)(self:get("map-pairs-to-string")) do
          list[#list + 1] = {
            text = v,
            value = k
          }
        end
        return list
      end,
      ["parse-to-env-map"] = function(self)
        return tb(self:get("map-table", function(key, val)
          if type(val) == "table" then 
            return key, CreateEnvItem(val)
          else
            return key, val
          end
        end))
      end
    },
    doThisables = {
      ["choose-item"] = function(self, callback)
        buildChooser(
          self:get("chooser-list-of-pairs"),
          function(choice)
            callback(self:get("c")[choice.value], choice)
          end,
          nil,
          { whole_chooser = { placeholderText = self:get("to-string") } }
        )
      end,
      ["choose-key-act-on-value"] = function(self, callback)
        buildChooser(
          self:get("chooser-list-of-keys"),
          function(choice)
            callback(self:get("c")[choice.value])
          end,
          nil,
          { whole_chooser = { placeholderText = self:get("to-string") } }
        )
      end,
      ["choose-value-act-on-key"] = function (self, callback)
        buildChooser(
          self:get("chooser-list-of-values"),
          function(choice)
            callback(self:get("key", choice.value))
          end,
          nil,
          { whole_chooser = { placeholderText = self:get("to-string") } }
        )
      end,
    },
  },
  potential_interfaces = ovtable.init({
    { key = "homogeneous-key-table", value = CreateHomogeneousKeyTable },
    { key = "homogeneous-value-table", value = CreateHomogeneousValueTable },
    { key = "heterogeneous-key-table", value = CreateHeterogeneousKeyTable },
    { key = "heterogeneous-value-table", value = CreateHeterogeneousValueTable },
    { key = "homo-k-homo-v-table", value = CreateHomoKHomoVTable },
    { key = "hetero-k-homo-v-table", value = CreateHeteroKHomoVTable },
    { key = "homo-k-hetero-v-table", value = CreateHomoKHeteroVTable },
    { key = "hetero-k-hetero-v-table", value = CreateHeteroKHeteroVTable },

  }),
  action_table = {
    {
      text = "👉 c.",
      key = "choose-item-and-then-action"
    },
    {
      d = "tstr",
      i = "💻🔡",
      key = "to-string",
    },
    {
      d = "tstrml",
      i = "💻🔡📜",
      key = "to-string-multiline",
    },
  }
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateNonEmptyTable = bindArg(NewDynamicContentsComponentInterface, NonEmptyTableSpecifier)
