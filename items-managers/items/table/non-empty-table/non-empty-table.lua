NonEmptyTableSpecifier = {
  type = "non-empty-table",
  properties = {
    getables = {
      ["keys"] = function(self)
        return keys(self:get("contents"))
      end,
      ["keys-to-new-array"] = function(self)
        return CreateArray(self:get("keys"))
      end,
      ["value"] = function(self, key)
        return self:get("contents")[key]
      end,
      ["key"] = function(self, value)
        return valueFindKeyString(self:get("contents"), value)
      end,
      ["first-match-in-list-of-keys"] = function (self, list_of_keys)
        local contents = self:get("contents")
        for _, key in ipairs(list_of_keys) do
          if contents[key] then
            return contents[key]
          end
        end
      end,
      ["values"] = function(self)
        return values(self:get("contents"))
      end,
      ["values-to-new-array"] = function(self)
        return CreateArray(self:get("values"))
      end,
      ["pairs"] = function(self)
        return pairsList(self:get("contents"))
      end,
      ["pairs-to-new-array"] = function(self)
        return CreateArray(self:get("pairs"))
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
        return allKeysPass(self:get("contents"), predicate)
      end,
      ["all-values-pass"] = function(self, predicate)
        return allValuesPass(self:get("contents"), predicate)
      end,
      ["all-pairs-pass"] = function(self, predicate)
        return allPairsPass(self:get("contents"), predicate)
      end,
      ["some-keys-pass"] = function(self, predicate)
        return someKeysPass(self:get("contents"), predicate)
      end,
      ["some-values-pass"] = function(self, predicate)
        return someValuesPass(self:get("contents"), predicate)
      end,
      ["some-pairs-pass"] = function(self, predicate)
        return somePairsPass(self:get("contents"), predicate)
      end,
      ["none-keys-pass"] = function(self, predicate)
        return noKeysPass(self:get("contents"), predicate)
      end,
      ["none-values-pass"] = function(self, predicate)
        return noValuesPass(self:get("contents"), predicate)
      end,
      ["none-pairs-pass"] = function(self, predicate)
        return noPairsPass(self:get("contents"), predicate)
      end,
      ["all-keys-are-in-list"] = function(self, list)
        return allKeysPass(self:get("contents"), function(key)
          return listHasValue(list, key)
        end)
      end,
      ["all-values-are-in-list"] = function(self, list)
        return allValuesPass(self:get("contents"), function(value)
          return listHasValue(list, value)
        end)
      end,
      ["all-pairs-are-in-list"] = function(self, list)
        return allPairsPass(self:get("contents"), function(pair)
          return listHasValue(list, pair)
        end)
      end,
      ["find-key"] = function(self, predicate)
        return keyFind(self:get("contents"), predicate)
      end,
      ["find-value"] = function (self, predicate)
        return valueFind(self:get("contents"), predicate)
      end,
      ["find-pair"] = function (self, predicate)
        return pairFind(self:get("contents"), predicate)
      end,
      ["map-table"] = function(self, callback)
        return map(self:get("contents"), callback, {"kv", "kv"})
      end,
      ["map-keys"] = function(self, callback)
        return map(self:get("keys"), callback)
      end,
      ["map-values"] = function(self, callback)
        return map(self:get("values"), callback)
      end,
      ["map-keys-to-new-array"] = function(self, callback)
        return CreateArray(self:get("map-keys", callback))
      end,
      ["map-values-to-new-array"] = function(self, callback)
        return CreateArray(self:get("map-values", callback))
      end,
      ["map-to-flat-path-dot-table"] = function(self)
        return CreateTable(nestedAssocArrToFlatPathAssocArrWithDotNotation(self:get("contents")))
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
        return map(self:get("contents"), function(k, v)
          local pair_value_as_text
          if type(v) == "table" and v.get then 
            pair_value_as_text = v:get("to-string")
          else 
            pair_value_as_text = tostring(v)
          end
          pair_value_as_text = foldStr(pair_value_as_text)
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
        for k, v in wdefarg(pairs)(self:get("map-pairs-to-string")) do
          list[#list + 1] = {
            text = v,
            value = k
          }
        end
        return list
      end,
      ["parse-to-env-map"] = function(self)
        return CreateTable(self:get("map-table", function(key, val)
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
            callback(self:get("contents")[choice.value], choice)
          end,
          nil,
          { whole_chooser = { placeholderText = self:get("to-string") } }
        )
      end,
      ["choose-key-act-on-value"] = function(self, callback)
        buildChooser(
          self:get("chooser-list-of-keys"),
          function(choice)
            callback(self:get("contents")[choice.value])
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
  action_table = listConcat({
    {
      text = "👉 c.",
      key = "choose-item-and-then-action"
    } 
  }, getChooseItemTable({
    {
      description = "tstr",
      emoji_icon = "💻🔡",
      key = "to-string",
    },
    {
      description = "tstrml",
      emoji_icon = "💻🔡📜",
      key = "to-string-multiline",
    },
  })),
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateNonEmptyTable = bindArg(NewDynamicContentsComponentInterface, NonEmptyTableSpecifier)
