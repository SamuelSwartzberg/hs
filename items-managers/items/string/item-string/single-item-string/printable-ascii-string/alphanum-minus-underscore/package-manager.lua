--- @type ItemSpecifier
PackageManagerItemSpecifier = {
  type = "package-manager",
  properties = {
    getables = {
      ["list-packages-array"] = function (self)
        return ar(get.upkg.list(self:get("c")))
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
