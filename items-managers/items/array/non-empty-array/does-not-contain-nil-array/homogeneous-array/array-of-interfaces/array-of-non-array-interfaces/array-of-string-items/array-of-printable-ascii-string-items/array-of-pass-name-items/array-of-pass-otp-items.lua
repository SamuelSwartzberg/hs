
ArrayOfPassOtpItemsSpecifier = {
  type = "array-of-pass-otps",
  properties = {
    getables = {
      
    },
    doThisables = {
      ["choose-item-and-paste-otp"] = function(self)
        self:doThis("choose-item", function(item) 
          item:doThis("paste-result-of-get", {key = "pass-otp"})
        end)
      end,
    },
  },
  action_table = {},
  
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateArrayOfPassOtpItems = bindArg(NewDynamicContentsComponentInterface, ArrayOfPassOtpItemsSpecifier)