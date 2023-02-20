
-- test code to make sure all the items are correct
local passes = true

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
}

local potential_interfaces_ignore_map = {
  ManagedArraySpecifier = {
    "managed-clipboard-array",
    "managed-hotkey-array",
    "managed-stream-array",
    "managed-timer-array",
    "managed-watcher-array",
    "managed-task-array",
    "managed-api-array",
    "managed-input-method-array",
  },
  ArraySpecifier = {
    "managed-array"
  }
}

for key, item in pairs(_G) do
  if stringy.endswith(key, "Specifier") then
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
      for k, v in pairs(item.potential_interfaces) do 
        if not valuesContain(potential_interfaces_ignore_map[key], k) then
          if not item.properties.getables["is-" .. k] then
            passes = false
            print("potential_interfaces key " .. k .. " of item " .. key ..
            " does not have a corresponding is-" .. k .. " getable")
          end
        end
      end
    end
    if item.properties.getables then 
      for k, v in pairs(item.properties.getables) do
        if stringy.startswith(k, "is-") then
          if not valuesContain(is_method_ignore_map[key], k) then 
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

-- try creating various items to make sure they work



--- @class TestSpecifier
--- @field value any
--- @field must_be? string[]
--- @field must_not_be? string[]
--- @field pretest? fun(): nil
--- @field posttest? fun(): nil

--- @type { [function]: TestSpecifier[] }
local item_creation_map = {
  [CreateApiItem] = {
    {
      value = "https://www.googleapis.com/youtube",
      must_be = { "api-item", "youtube-api-item" },
      must_not_be = { "youtube-api-extension-item" }
    },
    {
      value = "https://yt.lemnoslife.com/",
      must_be = { "api-item", "youtube-api-extension-item" },
      must_not_be = { "youtube-api-item" }
    }
  },
  [CreateApplicationItem] = {
    {
      value = "Facebook",
      must_be = { "application-item", "chat-application-item", "facebook-item" }
    },
    {
      value = "Discord",
      must_be = { "application-item", "chat-application-item", "discord-item" }
    },
    {
      value = "Signal",
      must_be = { "application-item", "chat-application-item", "signal-item" }
    },
    {
      value = "Telegram Lite",
      must_be = { "application-item", "chat-application-item", "telegram-item" }
    },
    {
      value = "Firefox",
      must_be = { "application-item", "title-url-application-item", "firefox-item" }
    },
    {
      value = "Newpipe",
      must_be = { "application-item", "title-url-application-item", "newpipe-item" }
    },
    {
      value = "Git",
      must_be = { "application-item", "git-item" }
    },
    {
      value = "Hydrus Network",
      must_be = { "application-item", "hydrus-network-item" }
    },
    {
      value = "Tachiyomi",
      must_be = { "application-item", "tachiyomi-item" }
    }
  },

  [CreateArray] = {}, -- todo
  [CreateEnvItem] = {}, -- todo
 [CreateNumber] = {
    {
      value = 1,
      must_be = { "number" , "number-by-sign", "pos", "number-by-number-set", "int", "number-by-combination", "pos-int" }
    },
    {
      value = 0,
      must_be = { "number" , "number-by-sign", "zero", "number-by-number-set", "int"}
    },
    {
      value = -1,
      must_be = { "number" , "number-by-sign", "neg", "number-by-number-set", "int"}
    },
    {
      value = 1.23,
      must_be = { "number" , "number-by-sign", "pos", "number-by-number-set", "float"}
    }
  },
  --[[ [CreateRunningApplicationItem] = {
    {
      value = function() return hs.application.open("Google Chrome") end,
      must_be = { "running-application-item", "browser-application", "chrome-application" }
    },
    {
      value = function() return hs.application.open("Firefox") end,
      must_be = { "running-application-item", "browser-application", "firefox-application" }
    },
    {
      value = function() return hs.application.open("LibreOffice") end,
      must_be = { "running-application-item", "libreoffice-item" }
    },
    {
      value = function() return hs.application.open("OmegaT") end,
      must_be = { "running-application-item", "omegat-item" }
    }
  }, ]] -- stays commented out most of the time since having applications open is annoying while I'm constantly rerunning this while debugging
  [CreateShellCommand] = {
    {
      value = "khard",
      must_be = { "shell-command", "khard-command" }
    },
    {
      value = "mullvad",
      must_be = { "shell-command", "mullvad-command" }
    },
    {
      value = "pass",
      must_be = { "shell-command", "pass-command" }
    },
    {
      value = "syn",
      must_be = { "shell-command", "syn-command" }
    },
    {
      value = "synonyms",
      must_be = { "shell-command", "synonyms-command" }
    },
    {
      value = "uni",
      must_be = { "shell-command", "uni-command" }
    } 
  },
  [CreateTable] = {}, -- todo
  [CreateWindowlikeItem] = {}, -- todo
  [CreateStringItem] = {
 {
      value = "foo/bar",
      must_be = { "string-item", "single-item-string-item", "path", "relative-path" },
      must_not_be = { "absolute-path" }
    },
  {
      value = "/foo/bar",
      must_be = { "string-item", "single-item-string-item", "path", "absolute-path", "true-absolute-path", "non-extant-path" },
      must_not_be = { "relative-path", "tilde-absolute-path", "extant-path" }
    },
 {
      value = "~/foo/bar",
      must_be = { "string-item", "single-item-string-item", "path", "absolute-path", "tilde-absolute-path", "non-extant-path" },
      must_not_be = { "relative-path", "true-absolute-path", "extant-path" }
    }, 
   {
      value = "/Users/sam/moz_places.csv",
      must_be = { "string-item", "single-item-string-item", "path", "absolute-path", "true-absolute-path", "extant-path", "file" }
    },  
   {
      value = env.HOME,
      must_be = { "string-item", "single-item-string-item", "path", "absolute-path", "true-absolute-path", "extant-path", "dir", "parent-dir", "grandparent-dir"},
    }
  } -- todo
}


for create_function, test_specifers in pairs(item_creation_map) do
  for _, test_specifier in ipairs(test_specifers) do
    if test_specifier.pretest then
      test_specifier.pretest()
    end
    local value = test_specifier.value
    if type(value) == "function" then
      value = value()
    end
    local item = create_function(value)
    for _, must_be in ipairsSafe(test_specifier.must_be) do
      if not valuesContain(item:get_all("type"), must_be) then
        error("Item created by " .. 
        tostring(create_function) .. 
        " with value " .. tostring(test_specifier.value) .. 
        " does not have type " .. tostring(must_be) .. ". It has the types " .. 
        item:get("types-of-all-valid-interfaces"))
        
      end
    end
    for _, must_not_be in ipairsSafe(test_specifier.must_not_be) do
      if valuesContain(item:get_all("type"), must_not_be) then
        error("Item created by " .. tostring(create_function) .. " with value " .. tostring(test_specifier.value) .. " has type " .. tostring(must_not_be) .. " but should not")
      end
    end
    if test_specifier.posttest then
      test_specifier.posttest()
    end
  end
end

