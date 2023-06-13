

NonEmptyArraySpecifier = {
  type = "non-empty-array",
  properties = {
    getables = {
      ["is-pair"] = function(self) return self:get("length") == 2 end,
      ["is-contains-nil-array"] = bc(isSparseList),
      ["is-does-not-contain-nil-array"] = function(self) return not isSparseList(self:get("c")) end,
      ["remove-by-index"] = function(self, index) -- semantically a doThisable, but doThisables are not allowed to return values
        if index and self:get("c")[index] then
          return table.remove(self:get("c"), index)
        end
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
