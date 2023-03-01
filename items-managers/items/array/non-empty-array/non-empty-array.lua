

NonEmptyArraySpecifier = {
  type = "non-empty-array",
  properties = {
    getables = {
      ["length"] = function(self)
        return #self:get("contents")
      end,
      ["first"] = function(self) return self:get("contents")[1] end,
      ["last"] = function(self) return self:get("contents")[#self:get("contents")] end,
      ["nth-element"] = function(self, n) return self:get("contents")[n] end,
      ["tail"] = function(self, n)
        n = n or 10
        local contents = self:get("contents")
        return slice(contents, #contents - n + 1, #contents)
      end,
      ["head"] = function(self, n)
        n = n or 10
        return slice(self:get("contents"), 1, n)
      end,
      ["range"] = function(self, specifier) return slice(self:get("contents"), specifier) end,
      ["range-to-new-array"] = function(self, specifier)
        return CreateArray(self:get("range", specifier))
      end,
      ["map"] = function(self, callback)
        return map(self:get("contents"), callback)
      end,
      ["map-to-new-array"] = function(self, callback)
        return CreateArray(self:get("map", callback))
      end,
      ["sorted"] = function(self, callback)
        local res = tablex.copy(self:get("contents"))
        table.sort(res, callback)
        return res
      end,
      ["sorted-to-new-array"] = function(self, callback)
        return CreateArray(self:get("sorted", callback))
      end,
      ["reverse"] = function(self)
        return listReverse(self:get("contents"))
      end,
      ["reverse-to-new-array"] = function(self)
        return CreateArray(self:get("reverse"))
      end,
      ["revsorted"] = function(self, callback)
        local res = tablex.copy(self:get("contents"))
        table.sort(res, callback)
        return listReverse(res)
      end,
      ["revsorted-to-new-array"] = function(self, callback)
        return CreateArray(self:get("revsorted", callback))
      end,
      ["revsorted-to-new-array-default"] = function(self)
        return self:get("sorted-to-new-array-default"):get("reverse-to-new-array")
      end,
      ["filter"] = function(self, callback)
        return filter(self:get("contents"), callback)
      end,
      ["filter-to-new-array"] = function(self, callback)
        local res = CreateArray(self:get("filter", callback))
        return res
      end,
      ["filter-to-unique-array"]= function(self)
        return CreateArray(listFilterUnique(self:get("contents")))
      end,
      ["find"] = function(self, callback)
        return valueFind(self:get("contents"), callback)
      end,
      ["find-index"] = function(self, callback)
        return valueFindKey(self:get("contents"), callback)
      end,
      ["next"] = function(self, index)
        return self:get("contents")[index + 1]
      end,
      ["next-wrapping"] = function(self, index)
        return self:get("contents")[index + 1] or self:get("contents")[1]
      end,
      ["previous"] = function(self, index)
        return self:get("contents")[index - 1]
      end,
      ["previous-wrapping"] = function(self, index)
        return self:get("contents")[index - 1] or self:get("contents")[#self:get("contents")]
      end,
      ["reduce"] = function(self, specifier)
        return reduceValues(self:get("contents"), specifier.callback, specifier.initial_value)
      end,
      ["all-pass"] = function(self, callback)
        return allValuesPass(self:get("contents"), callback)
      end,
      ["some-pass"] = function(self, callback)
        return someValuesPass(self:get("contents"), callback)
      end,
      ["none-pass"] = function (self, callback)
        return noValuesPass(self:get("contents"), callback)
      end,
      ["item-by-index"] = function(self, index)
        return self:get("contents")[index]
      end,
      ["is-pair"] = function(self) return self:get("length") == 2 end,
      ["is-contains-nil-array"] = function(self) 
        return isSparseList(self:get("contents"))
      end,
      ["is-does-not-contain-nil-array"] = function(self)
         return not isSparseList(self:get("contents"))
      end,
      ["remove-by-index"] = function(self, index) -- semantically a doThisable, but doThisables are not allowed to return values
        if index and self:get("contents")[index] then
          return table.remove(self:get("contents"), index)
        end
      end,
      ["flatten"] = function(self, recursive)
        local new_arr = {}
        for i, item in ipairs(self:get("contents")) do
          if type(item) == "table" and item.get and item:get("is-array") then
            if recursive then
              new_arr = listConcat(new_arr, item:get("flatten", recursive))
            else
              new_arr = listConcat(new_arr, item:get("contents"))
            end
          elseif isListOrEmptyTable(item) then
            new_arr = listConcat(new_arr, item)
          else
            table.insert(new_arr, item)
          end
        end
        return new_arr
      end,
      ["flatten-to-new-array"] = function(self)
        return CreateArray(self:get("flatten"))
      end,
      ["flat-map"] = function(self, callback)
        local res = flatMap(self:get("contents"), callback)
        return CreateArray(res)
      end,
      ["filter-nil-map"] = function(self, callback)
        return filterNilMap(self:get("contents"), callback)
      end,
      ["filter-nil-map-to-new-array"] = function(self, callback)
        return CreateArray(self:get("filter-nil-map", callback))
      end,

    },
    doThisables = {
      ["for-all"] = function(self, callback)
        for i, item in ipairs(self:get("contents")) do
          callback(item)
        end
      end,
      ["for-all-staggered"] = function(self, specifier) -- specifier = { interval = ..., fn = ... }
        local next_pair = sipairs(self:get("contents"))
        System:get("contents")["global-timer-manager"]:doThis("create", { 
          interval = specifier.interval,
          fn = function()
            local _, item = next_pair()
            if item then
              specifier.fn(item)
            else
              error("Finished iterating through array, stop timer.", 0)
            end
          end
        })
      end,

    },
  },
  potential_interfaces = ovtable.init({
    { key = "pair", value = CreatePair },
    { key = "does-not-contain-nil-array", value = CreateDoesNotContainNilArray },
    { key = "contains-nil-array", value = CreateContainsNilArray },

  }),
  action_table = {
    {
      text = "👉✂️ cslc.",
      key = "choose-action-on-result-of-get",
      args = { key = "do-interactive", args = { key = "range", thing = "python slice notation" } },
    },
    {
      text = "👉👊全 cal.",
      key = "choose-action-for-all",
    },
    {
      text = "👉📈 csrtasc.",
      key = "choose-action-on-result-of-get",
      args = { key = "sorted-to-new-array-default" },
    },
    {
      text = "👉📉 csrtdesc.",
      key = "choose-action-on-result-of-get",
      args = { key = "revsorted-to-new-array-default" },
    },{
      text = "👉👆 chd.",
      key = "choose-action-on-result-of-get",
      args = { 
        key = "array",
        args = { key = "head" },
      }
    },{
      text = "👉👇 ctl.",
      key = "choose-action-on-result-of-get",
      args = { 
        key = "array",
        args = { key = "tail" },
      }
    },{
      text = "👉#️⃣ cln.",
      key = "choose-action-on-string-item-result-of-get",
      args = { key = "length" },
    }

    
  }
}


--- @type BoundNewDynamicContentsComponentInterface
CreateNonEmptyArray = bindArg(NewDynamicContentsComponentInterface, NonEmptyArraySpecifier)
