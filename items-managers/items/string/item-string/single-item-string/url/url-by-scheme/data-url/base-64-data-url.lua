--- @type ItemSpecifier
Base64DataURLItemSpecifier = {
  type = "base64-data-url",
  action_table ={}
}

--- @type BoundNewDynamicContentsComponentInterface
CreateBase64DataURLItem = bindArg(NewDynamicContentsComponentInterface, Base64DataURLItemSpecifier)