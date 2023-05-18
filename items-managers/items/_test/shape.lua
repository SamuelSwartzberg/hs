
-- test code to make sure all the items are correct
local passes = true

print("testing item shape...")

local is_method_ignore_map = { -- contains keys of specifiers and values of arrays of 'is' methods where it is not an error if there is not a corresponding potential_interface
  AudiodeviceItemSpecifier = { "is-default-device" },
  PathItemSpecifier = { "is-in-path" },
  PathLeafSpecifier = { "is-usable-as-filetype" },
  InputMethodItemSpecifier = { "is-active" },
  TimerItemSpecifier = { "is-running", "is-primed" },
  ApplicationItemSpecifier = { "is-running" },
  MullvadCommandSpecifier = { "is-connected" },
  KhardCommandSpecifier = { "is-contact" },
  InterfaceValueTableSpecifier = {
    "is-single-address-table-value-table"
  },
  HeterogeneousValueTableSpecifier = {
    "is-string-and-table-value-table",
    "is-string-and-number-value-table",
    "is-env-value-table"
  },
  StringKeyTableSpecifier = {
    "is-vcard-email-key-table",
    "is-vcard-phone-key-table",
    "is-single-address-key-table",
    "is-unicode-prop-key-table",
    "is-emoji-prop-key-table",
    "is-csl-key-table",
    "is-synonyms-key-table",
    "is-shrink-specifier-key-table",
    "is-tree-node-key-table",
    "is-env-var-key-table",
    "is-menu-item-key-table",
  },
  ArrayOfDateRelatedItemsSpecifier = {
    "is-in-range"
  },
  NoninterfaceValueTableInterfaceSpecifier = {
    "is-plain-table-value-table"
  },
  CargoProjectDirItemSpecifier = {
    "is-actually-project-dir"
  },
  LatexProjectDirItemSpecifier = {
    "is-actually-project-dir"
  },
  NpmProjectDirItemSpecifier = {
    "is-actually-project-dir"
  },
  OmegatProjectDirItemSpecifier = {
    "is-actually-project-dir"
  },
  SassProjectDirItemSpecifier = {
    "is-actually-project-dir"
  },
  UpkgCommandSpecifier = {
    "is-installed"
  },
}

local potential_interfaces_ignore_map = {
  ManagedArraySpecifier = {
    "managed-clipboard-array",
    "managed-creatable-array",
    "managed-stream-array",
    "managed-timer-array",
    "managed-api-array",
    "managed-input-method-array",
  },
  ArraySpecifier = {
    "managed-array"
  }
}

for key, item in prs(_G) do
  if stringy.endswith(key, "Specifier") and type(item) == "table" then
    --- @cast item ItemSpecifier
    local res = shapeMatches(item, {
      type = "string",
      properties = {
        ["getables?"] = {
          ["[string]"] = "function"
        },
        ["doThisables?"] = {
          ["[string]"] = "function"
        }
      },
      ["potential_interfaces?"] = { 
        ["[string]"] = "function"
      },
      ["action_table?"] = {
        ["[number]"] = {
          text = "string",
          key = "string",
          ["args?"] = "any",
          ["condition?"] = "function"
        }
      }
    }, key)
    if not res then
      passes = false
    end
    if item.potential_interfaces then
      for k, v in prs(item.potential_interfaces) do 
        if not find(potential_interfaces_ignore_map[key], {_exactly = k}, "boolean") then
          if not item.properties.getables["is-" .. k] then
            passes = false
            print("potential_interfaces key " .. k .. " of item " .. key ..
            " does not have a corresponding is-" .. k .. " getable")
          end
        end
      end
    end
    if item.properties.getables then 
      for k, v in prs(item.properties.getables) do
        if stringy.startswith(k, "is-") then
          if not find(is_method_ignore_map[key], {_exactly = k}, "boolean") then 
            local interface_name = k:sub(4)
            if not item.potential_interfaces or not item.potential_interfaces[interface_name] then
              passes = false
              print("is-" .. interface_name .. " getable" .. " of item " .. key .. " does not have a corresponding potential_interfaces key " .. interface_name)
            end
          end
        end
      end
    end
  elseif stringy.startswith(key, "Create") then
    assert(type(item) == "function", key .. " is not a function")
  end
end

if not passes then
  error("Errors in shape check of items, cannot proceed.", 0)
end