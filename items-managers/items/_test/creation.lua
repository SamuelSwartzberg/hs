

-- try creating various items to make sure they work

local TMPDIR_NOW = env.TMPDIR .. '/' .. os.time() .. '/'

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
      pretest = function()
        writeFile(TMPDIR_NOW .. "foo.txt")
      end,
      value = TMPDIR_NOW .. "foo.txt",
      must_be = { "string-item", "single-item-string-item", "path", "absolute-path", "true-absolute-path", "extant-path", "file" },
      posttest = function()
        delete(TMPDIR_NOW .. "foo.txt")
      end
    },  
   {
      value = env.HOME,
      must_be = { "string-item", "single-item-string-item", "path", "absolute-path", "true-absolute-path", "extant-path", "dir", "parent-dir", "grandparent-dir"},
    }
  }, -- todo
  [CreateWatcherItem] = {
    {
      value = {
        type = hs.pasteboard
      }
    }
  }
}


for create_function, test_specifers in prs(item_creation_map) do
  for _, test_specifier in iprs(test_specifers) do
    if test_specifier.pretest then
      test_specifier.pretest()
    end
    local value = test_specifier.value
    if type(value) == "function" then
      value = value()
    end
    local item = create_function(value)
    for _, must_be in wdefarg(iprs)(test_specifier.must_be) do
      if not find(item:get_all("type"), must_be, "boolean") then
        error("Item created by " .. 
        tostring(create_function) .. 
        " with value " .. tostring(test_specifier.value) .. 
        " does not have type " .. tostring(must_be) .. ". It has the types " .. 
        item:get("types-of-all-valid-interfaces"))
        
      end
    end
    for _, must_not_be in wdefarg(iprs)(test_specifier.must_not_be) do
      if find(item:get_all("type"), must_not_be, "boolean") then
        error("Item created by " .. tostring(create_function) .. " with value " .. tostring(test_specifier.value) .. " has type " .. tostring(must_not_be) .. " but should not")
      end
    end
    if test_specifier.posttest then
      test_specifier.posttest()
    end
  end
end

