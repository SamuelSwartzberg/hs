HomoKHeteroVTableSpecifier = {
  type = "homo-k-hetero-v-table",
  properties = {
    getables = {
      ["is-synonyms-table"] = function(self)
        return self:get("is-synonyms-key-table") and self:get("is-string-and-table-value-table")
      end,
      ["is-csl-table"] = function(self)
        return self:get("is-csl-key-table") and self:get("is-string-and-table-value-table")
      end,
      ["is-env-map"] = function(self)
        return self:get("is-string-key-table") and self:get("is-env-value-table")
      end,
      ["is-shrink-specifier-table"] = function(self)
        return self:get("is-shrink-specifier-key-table") and self:get("is-string-and-number-value-table")
      end,
      ["is-tree-node-table"] = function(self)
        return self:get("is-tree-node-key-table")
      end,
      ["is-menu-item-table"] = function (self)
        return self:get("is-menu-item-key-table")
      end
     },
    doThisables = {
   
    },
  },
  potential_interfaces = ovtable.init({
    { key = "synonyms-table", value = CreateSynonymsTable },
    { key = "csl-table", value = CreateCslTable },
    { key = "env-map", value = CreateEnvMap },
    { key = "shrink-specifier-table", value = CreateShrinkSpecifierTable },
    { key = "tree-node-table", value = CreateTreeNodeTable },
    { key = "menu-item-table", value = CreateMenuItemTable },
  }),
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateHomoKHeteroVTable = bindArg(NewDynamicContentsComponentInterface, HomoKHeteroVTableSpecifier)
