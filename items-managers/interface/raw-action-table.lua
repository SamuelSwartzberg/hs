--- @class CopySpecifier
--- @field key string
--- @field description string
--- @field i string
--- @field args any
--- @field check? boolean

--- @param specifiers CopySpecifier[]
--- @return action_table
function getChooseItemTable(specifiers)
  local action_table = {}

  for _, specifier in ipairs(specifiers) do
    if specifier.check then 
      specifier.condition = function(item)
        return item:get(specifier.key, specifier.args) ~= nil
      end
    end

    action_table[#action_table + 1] =  {
      text = string.format("%s%s %s%s.", "👉", specifier.i, "c", specifier.description),
      key = "choose-action-on-str-item-result-of-get",
      condition = specifier.condition,
      args = {
        key = specifier.key,
        args = specifier.args
      }
    }
  end
  return action_table
end