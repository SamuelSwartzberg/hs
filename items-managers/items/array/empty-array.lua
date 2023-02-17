EmptyArraySpecifier = {
  type = "empty-array",
  properties = {
    getables = {
      ["range"] = function() return {} end,
      ["range-to-new-array"] = function() return CreateArray({}) end,
      ["map"] = function() return {} end,
      ["map-to-new-array"] = function() return CreateArray({}) end,
      ["filter"] = function() return {} end,
      ["filter-to-new-array"] = function() return CreateArray({}) end,
      ["all-pass"] = function() return true end,
      ["some-pass"] = function() return true end,
      ["none-pass"] = function() return false end,
      ["chooser-list-of-all"] = function() return {} end,
      ["flatten"] = function() return {} end,
      ["to-string"] = function() return "<empty-array>" end,
    },
    doThisables = {
      ["for-all"] = function() end,
      ["set-all"] = function() end,
      ["choose-item"] = function() error("Can't choose item on empty array.", 0) end,
    },
  },
  
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateEmptyArray = bindArg(NewDynamicContentsComponentInterface, EmptyArraySpecifier)
