--- @type ItemSpecifier
PackageManagerItemSpecifier = {
  type = "package-manager",
  properties = {
    getables = {
      ["list-packages-array"] = function (self)
        return CreateArray(get.upkg.list(self:get("contents")))
      end
    }
  },
  action_table = concat(getChooseItemTable({
   
  }),{
   {
      key = "choose-item-and-then-action-on-result-of-get",
      args = {
        key = "list-packages-array",
      },
      text = "📦 lpkg."
    }
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePackageManagerItem = bindArg(NewDynamicContentsComponentInterface, PackageManagerItemSpecifier)