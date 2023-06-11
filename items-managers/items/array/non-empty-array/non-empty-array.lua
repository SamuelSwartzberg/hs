

NonEmptyArraySpecifier = {
  type = "non-empty-array",
  properties = {
    getables = {
      ["length"] = function(self)
        return #self:get("c")
      end,
      ["first"] = function(self) return self:get("c")[1] end,
      ["last"] = function(self) return self:get("c")[#self:get("c")] end,
      ["nth-element"] = function(self, n) return self:get("c")[n] end,
      ["tail"] = function(self, n)
        n = n or 10
        local contents = self:get("c")
        return slice(contents, #contents - n + 1, #contents)
      end,
      ["head"] = function(self, n)
        n = n or 10
        return slice(self:get("c"), 1, n)
      end,
      ["range"] = function(self, specifier) return slice(self:get("c"), specifier) end,
      ["range-to-new-array"] = function(self, specifier)
        return ar(self:get("range", specifier))
      end,
      ["map"] = function(self, callback)
        return map(self:get("c"), callback)
      end,
      ["map-to-new-array"] = function(self, callback)
        return ar(self:get("map", callback))
      end,
      ["sorted"] = function(self, callback)
        local res = copy(self:get("c"), false)
        table.sort(res, callback)
        return res
      end,
      ["sorted-to-new-array"] = function(self, callback)
        return ar(self:get("sorted", callback))
      end,
      ["reverse"] = function(self)
        return rev(self:get("c"))
      end,
      ["reverse-to-new-array"] = function(self)
        return ar(self:get("reverse"))
      end,
      ["revsorted"] = function(self, callback)
        local res = copy(self:get("c"), false)
        table.sort(res, callback)
        return rev(res)
      end,
      ["revsorted-to-new-array"] = function(self, callback)
        return ar(self:get("revsorted", callback))
      end,
      ["revsorted-to-new-array-default"] = function(self)
        return self:get("sorted-to-new-array-default"):get("reverse-to-new-array")
      end,
      ["filter"] = function(self, callback)
        return filter(self:get("c"), callback)
      end,
      ["filter-to-new-array"] = function(self, callback)
        local res = ar(self:get("filter", callback))
        return res
      end,
      ["filter-to-unique-array"]= function(self)
        return ar(toSet(self:get("c")))
      end,
      ["find"] = function(self, callback)
        return find(self:get("c"), callback)
      end,
      ["find-index"] = function(self, callback)
        return find(self:get("c"), callback, {"v", "k"})
      end,
      ["next"] = function(self, index)
        return self:get("c")[index + 1]
      end,
      ["next-wrapping"] = function(self, index)
        return self:get("c")[index + 1] or self:get("c")[1]
      end,
      ["previous"] = function(self, index)
        return self:get("c")[index - 1]
      end,
      ["previous-wrapping"] = function(self, index)
        return self:get("c")[index - 1] or self:get("c")[#self:get("c")]
      end,
      ["all-pass"] = function(self, callback)
        return not find(self:get("c"), function(v) return not callback(v) end, {"v", "boolean"})
      end,
      ["some-pass"] = function(self, callback)
        return find(self:get("c"), callback, {"v", "boolean"})
      end,
      ["none-pass"] = function (self, callback)
        return not find(self:get("c"), callback, {"v", "boolean"})
      end,
      ["item-by-index"] = function(self, index)
        return self:get("c")[index]
      end,
      ["is-pair"] = function(self) return self:get("length") == 2 end,
      ["is-contains-nil-array"] = function(self) 
        return isSparseList(self:get("c"))
      end,
      ["is-does-not-contain-nil-array"] = function(self)
         return not isSparseList(self:get("c"))
      end,
      ["remove-by-index"] = function(self, index) -- semantically a doThisable, but doThisables are not allowed to return values
        if index and self:get("c")[index] then
          return table.remove(self:get("c"), index)
        end
      end,
      ["flatten"] = function(self, recursive)
        local new_arr = {}
        for i, item in ipairs(self:get("c")) do
          if type(item) == "table" and item.get and item:get("is-array") then
            if recursive then
              new_arr = concat(new_arr, item:get("flatten", recursive))
            else
              new_arr = concat(new_arr, item:get("c"))
            end
          elseif isListOrEmptyTable(item) then
            new_arr = concat(new_arr, item)
          else
            table.insert(new_arr, item)
          end
        end
        return new_arr
      end,
      ["flatten-to-new-array"] = function(self)
        return ar(self:get("flatten"))
      end,
      ["flat-map"] = function(self, callback)
        local res = map(self:get("c"), callback, {flatten = true})
        return ar(res)
      end,
      ["filter-nil-map"] = function(self, callback)
        return fixListWithNil(map(self:get("c"), callback))
      end,
      ["filter-nil-map-to-new-array"] = function(self, callback)
        return ar(self:get("filter-nil-map", callback))
      end,

    },
    doThisables = {
      ["for-all"] = function(self, callback)
        for i, item in ipairs(self:get("c")) do
          callback(item)
        end
      end,
      ["for-all-staggered"] = function(self, specifier) -- specifier = { interval = ..., fn = ... }
        local next_pair = siprs(self:get("c"))
        System:get("c")["global-timer-manager"]:doThis("create", { 
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
      getfn = get.array.head,
      get = "c",
      
    },{
      text = "👉👇 ctl.",
      getfn = get.array.tail,
      get = "c",
    },{
      text = "👉#️⃣ cln.",
      key = "choose-action-on-string-item-result-of-get",
      args = { key = "length" },
    }

    
  }
}


--- @type BoundNewDynamicContentsComponentInterface
CreateNonEmptyArray = bindArg(NewDynamicContentsComponentInterface, NonEmptyArraySpecifier)
