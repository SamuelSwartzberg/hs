

-- try creating various items to make sure they work

local testtime = os.time()
local TMPDIR_NOW = env.TMPDIR .. '/' .. testtime .. '/'

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
      must_be = { "api", "youtube-api" },
      must_not_be = { "youtube-api-extension" }
    },
    {
      value = "https://yt.lemnoslife.com/",
      must_be = { "api", "youtube-api-extension" },
      must_not_be = { "youtube-api" }
    }
  },
  [CreateApplicationItem] = {
    {
      value = "Facebook",
      must_be = { "application", "chat-application", "facebook" }
    },
    {
      value = "Discord",
      must_be = { "application", "chat-application", "discord" }
    },
    {
      value = "Signal",
      must_be = { "application", "chat-application", "signal" }
    },
    {
      value = "Telegram Lite",
      must_be = { "application", "chat-application", "telegram" }
    },
    {
      value = "Firefox",
      must_be = { "application", "title-url-application", "firefox" }
    },
    {
      value = "Newpipe",
      must_be = { "application", "title-url-application", "newpipe" }
    },
    {
      value = "Git",
      must_be = { "application", "git" }
    },
    {
      value = "Hydrus Network",
      must_be = { "application", "hydrus-network" }
    },
    {
      value = "Tachiyomi",
      must_be = { "application", "tachiyomi" }
    }
  },

  [CreateArray] = {
    {
      value = {},
      must_be = { "array", "empty-array" },
      must_not_be = { "non-empty-array" }
    },
    {
      value = { 1, 2 },
      must_be = { "array", "non-empty-array", "pair",  "does-not-contain-nil-array", "homogeneous-array", "array-of-noninterfaces" },
      must_not_be = { "empty-array", "contains-nil-array", "non-homogeneous-array", "array-of-interfaces" }
    },
    {
      value = { 1, 2, 3 },
      must_not_be = { "pair" }
    },
    {
      value = { 1, 2, nil, 4 },
      must_be = { "array", "non-empty-array", "contains-nil-array"},
      must_not_be = { "empty-array", "does-not-contain-nil-array" }
    },
    {
      value = { 1, 2, "3" },
      must_be = { "array", "non-empty-array", "non-homogeneous-array"},
      must_not_be = { "empty-array", "homogeneous-array" }
    },
    {
      value = { "1", "2", "3" },
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-noninterfaces", "array-of-strings" },
    },
    {
      value = { CreateStringItem("1"), CreateStringItem("2") },
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-strings-item" },
      must_not_be = { "empty-array", "non-homogeneous-array", "array-of-noninterfaces" }
    },
    {
      value = { 
        CreateStringItem("/foo"), CreateStringItem("bar/baz")
      },
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-strings-item", "array-of-paths", "array-of-path-leafs", "array-of-printable-asciis" },
      must_not_be = { "array-of-absolute-paths", "array-of-urls" }
    },
    {
      value = { CreateStringItem("/foo"), CreateStringItem("/home/user/bar/baz")},
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-strings-item", "array-of-absolute-paths", "array-of-paths", "array-of-path-leafs", "array-of-printable-asciis" },
      must_not_be = { "array-of-extant-paths" }
    },
    {
      value = {
        CreateStringItem(env.DESKTOP),
        CreateStringItem(env.DOWNLOADS),
      },
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-strings-item", "array-of-extant-paths", "array-of-paths", "array-of-path-leafs", "array-of-printable-asciis", "array-of-dirs"},
      must_not_be = { "array-of-files" }
    },
    {
      pretest = function()
        writeFile(TMPDIR_NOW .. "test-array-of-files-1")
        writeFile(TMPDIR_NOW .. "test-array-of-files-2")
      end,
      value = {
        CreateStringItem(TMPDIR_NOW .. "test-array-of-files-1"),
        CreateStringItem(TMPDIR_NOW .. "test-array-of-files-2"),
      },
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-strings-item", "array-of-extant-paths", "array-of-paths", "array-of-path-leafs", "array-of-printable-asciis", "array-of-files"},
      must_not_be = { "array-of-dirs" }

    },
    {
      value = {
        CreateStringItem(env.MENV),
        CreateStringItem(env.MDOTCONFIG)
      },
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-strings-item", "array-of-extant-paths", "array-of-paths", "array-of-path-leafs", "array-of-printable-asciis", "array-of-dirs", "array-of-git-root-dirs", "array-of-in-git-dir-paths"},
    },
    {
      value = {
        CreateStringItem(
          itemsInPath({
            path = env.MENV,
            include_dirs = false,
          })[1]
        ),
        CreateStringItem(
          itemsInPath({
            path = env.MDOTCONFIG,
            include_dirs = false,
          })[1]
        )
      },
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-strings-item", "array-of-extant-paths", "array-of-paths", "array-of-path-leafs", "array-of-printable-asciis", "array-of-in-git-dir-paths"},
      must_not_be = { "array-of-dirs", "array-of-git-root-dirs" }
    },
    {
      pretest = function()
        writeFile(TMPDIR_NOW .. "test-array-of-plaintext-dictionary-files.yaml")
        writeFile(TMPDIR_NOW .. "test-array-of-plaintext-dictionary-files.json")
      end,
      value = {
        CreateStringItem(TMPDIR_NOW .. "test-array-of-plaintext-dictionary-files.yaml"),
        CreateStringItem(TMPDIR_NOW .. "test-array-of-plaintext-dictionary-files.json"),
      },
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-strings-item", "array-of-extant-paths", "array-of-paths", "array-of-path-leafs", "array-of-printable-asciis", "array-of-files", "array-of-plaintext-files", "array-of-plaintext-dictionary-files"},
    },
    {
      value = {CreateStringItem("/Volumes/foo"), CreateStringItem("/Volumes/bar")},
      must_be = {"array-of-absolute-paths", "array-of-volumes"},
    },
    {
      value = {CreateStringItem("foo"), CreateStringItem("bar\0baz")},
      must_not_be = { "array-of-printable-asciis" }
    },
    {
      value = {CreateStringItem("a_b-c"), CreateStringItem("def")},
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-strings-item", "array-of-printable-asciis", "array-of-alphanum-minus-underscores" },
      must_not_be = { "array-of-alphanum-minuss" }
    },
    {
      value = {CreateStringItem("b-c"), CreateStringItem("2022-02")},
      must_be = { "array-of-alphanum-minuss" },
      must_not_be = { "array-of-date-relateds" }
    },
    {
      value = {
        CreateStringItem("15af8992-7b9b-094d-a363-1cdb45a90f5f"),
        CreateStringItem("2c05471a-2970-45c4-81f2-44f79566b432"),
        CreateStringItem("123e4567-e89b-12d3-a456-426614174000"),
      },
      must_be = { "array", "non-empty-array", "homogeneous-array",  "array-of-interfaces", "array-of-non-array-interfaces", "array-of-strings-item", "array-of-printable-asciis", "array-of-alphanum-minus-underscores","array-of-alphanum-minuss",
      "array-of-uuids"
      },
      must_not_be = { "array-of-contacts" }
    },
    {
      value = {
        CreateStringItem("15af8992-7b9b-094d-a363-1cdb45a90f5f"),
        CreateStringItem("2c05471a-2970-45c4-81f2-44f79566b432"),
      },
      must_be = { "array", "non-empty-array", "homogeneous-array",  "array-of-interfaces", "array-of-non-array-interfaces", "array-of-strings-item", "array-of-printable-asciis", "array-of-alphanum-minus-underscores","array-of-alphanum-minuss",
      "array-of-uuids",
      "array-of-contacts"
      },
    },
    {
      value = {CreateStringItem("2022-02-01"), CreateStringItem("2022-02-02T08:00")},
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-strings-item", "array-of-printable-asciis", "array-of-date-relateds" },
    },
    {
      value = {CreateStringItem("dsc"), CreateStringItem("ma"), CreateStringItem("uniqlo")},
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-strings-item", "array-of-printable-asciis", "array-of-pass-names", "array-of-pass-passws" },
      must_not_be = { "array-of-pass-otps" }
    },
    {
      value = {CreateStringItem("dsc"), CreateStringItem("ma")},
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-strings-item", "array-of-printable-asciis", "array-of-pass-names", "array-of-pass-passws" , "array-of-pass-otps" }
    },
    {
      value = {CreateStringItem("https://www.youtube.com/watch?v=dQw4w9WgXcQ"), CreateStringItem("https://www.google.com")},
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-strings-item", "array-of-urls", "array-of-urls-by-host" },
      must_not_be = { "array-of-youtubes" }
    },
    {
      value = {CreateStringItem("https://www.youtube.com/watch?v=dQw4w9WgXcQ"), CreateStringItem("https://www.youtube.com/playlist?list=PLYlndC1jl8s3_Sy4zCIU77wQv1zQs38qX"), CreateStringItem("https://www.youtube.com")},
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-strings-item", "array-of-urls", "array-of-urls-by-host", "array-of-youtubes" },
      must_not_be = { "array-of-youtube-playables" }
    },
    {
      value = {CreateStringItem("https://www.youtube.com/watch?v=dQw4w9WgXcQ"), CreateStringItem("https://www.youtube.com/playlist?list=PLYlndC1jl8s3_Sy4zCIU77wQv1zQs38qX"),},
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-strings-item", "array-of-urls", "array-of-urls-by-host", "array-of-youtubes", "array-of-youtube-playables" },
      must_not_be = {  "array-of-youtube-videos" }
    },
    {
      value = {CreateStringItem("https://www.youtube.com/watch?v=dQw4w9WgXcQ"), CreateStringItem("https://www.youtube.com/watch?v=QH2-TGUlwu4")},
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-strings-item", "array-of-urls", "array-of-urls-by-host", "array-of-youtubes", "array-of-youtube-playables", "array-of-youtube-videos" },
      must_not_be = { "array-of-youtube-playlists" }
    },
    {
      value = { CreateArray({1, 2}), CreateArray({3, 4}) },
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-arrays" },
      must_not_be = { "empty-array", "non-homogeneous-array", "array-of-non-array-interfaces" }
    },
    {
      value = { CreateAudiodeviceItem("Test Device 1")},
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-audiodevices" },
    },
    {
      value = { CreateDate(date())},
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-dates" },
    },
    {
      value = { CreateTable({foo = "bar"}), CreateTable({bar = "foo"}) },
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-tables", "array-of-non-empty-tables" },
      must_not_be = { "array-of-empty-tables" }
    },
    {
      value = { CreateTable({}), CreateTable({}) },
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-tables", "array-of-empty-tables" },
      must_not_be = { "array-of-non-empty-tables" }
    },
    {
      local_create_function = CreateManagedClipboardArrayDirectly,
      must_be = { "array", "managed-array", "managed-clipboard-array" },
    },
    {
      local_create_function = CreateManagedCreatableArray,
      must_be = { "array", "managed-array", "managed-creatable-array" },
    }
  },
  [CreateCreatableItem] = {
    {
      value = {
        type = "hotkey"
      },
      must_be = {
        "creatable",
        "fireable",
        "hotkey",
      }
    },
    {
      value = {
        type = "watcher"
      },
      must_be = {
        "creatable",
        "fireable",
        "watcher",
      }
    },
    {
      value = {
        type = "task"
      },
      must_be = {
        "creatable",
        "task",
      },
      must_not_be = {
        "fireable",
        "hotkey",
        "watcher",
      }
    }
  },
  [CreateDate] = {
    {
      value = date(),
      must_be = { "date" }
    }
  },
  [CreateEnvItem] = {
    {
      value = {
        value = {}
      },
      must_be = { "env", "value-env", "list-value-env", "nodependents-env", "noaliases-env" },
      must_not_be = { "no-value-env", "dependents-env", "string-value-env", "aliases-env" }
    },
    {
      value = {
        value = "foo"
      },
      must_be = { "env", "value-env", "string-value-env",  "nodependents-env", "noaliases-env"  },
      must_not_be = { "no-value-env" , "dependents-env", "list-value-env", "aliases-env" }
    },
    {
      value = {
        dependents = {
          FOO = "bar"
        }
      },
      must_be = { "env", "no-value-env", "dependents-env", "noaliases-env" },
      must_not_be = { "value-env", "nodependents-env" , "string-value-env", "list-value-env", "aliases-env" }
    },
    {
      value = {
        aliases = { "FOO "}
      },
      must_be = { "env", "no-value-env", "aliases-env", "nodependents-env" },
    }
  }, -- todo
  [CreateNumber] = {
    {
      value = 1,
      must_be = { "number" , "number-by-sign", "pos", "number-by-number-set", "int", "number-by-combination", "pos-int" }
    },
    {
      value = 0,
      must_be = { "number" , "number-by-sign", "zero", "number-by-number-set", "int", "number-by-combination" }
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
      must_be = { "running-application", "browser-application", "chrome-application" }
    },
    {
      value = function() return hs.application.open("Firefox") end,
      must_be = { "running-application", "browser-application", "firefox-application" }
    },
    {
      value = function() return hs.application.open("LibreOffice") end,
      must_be = { "running-application", "libreoffice" }
    },
    {
      value = function() return hs.application.open("OmegaT") end,
      must_be = { "running-application", "omegat" }
    }
  }, ]] -- stays commented out most of the time since having applications open is annoying while I'm constantly rerunning this while debugging
  [CreateShellCommand] = {
    {
      value = "khal",
      must_be = { "shell-command", "khal-command" }
    },
    {
      value = "khard",
      must_be = { "shell-command", "khard-command" }
    },
    {
      value = "libreoffice",
      must_be = { "shell-command", "libreoffice-command" }
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
      must_be = { "string", "single-item-string", "path", "relative-path" },
      must_not_be = { "absolute-path" }
    },
    {
      value = "/foo/bar",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "non-extant-path", "path-leaf", "path-leaf-general-name" },
      must_not_be = { "relative-path", "tilde-absolute-path", "extant-path", "path-leaf-extension", "path-leaf-date", "path-leaf-tags"}
    },
    {
      value = "/foo/bar.txt",
      must_be = {"path-leaf-extension"}
    },
    {
      value = "/foo/bar/2020-01-01--mou_tokubetsu_da_yo%trcea-kami_sama",
      must_be = {"path-leaf-date", "path-leaf-single-date", "path-leaf-general-name", "path-leaf-tags"},
      must_not_be = {"path-leaf-extension"}
    },
    {
      value = "2018-04-07_to_2019-02-01--foo",
      must_be = {"path-leaf-date", "path-leaf-date-range", "path-leaf-general-name"},
      must_not_be = {"path-leaf-extension", "path-leaf-tags"}
    },
    {
      value = "~/foo/bar",
      must_be = { "string", "single-item-string", "path", "absolute-path", "tilde-absolute-path", "non-extant-path" },
      must_not_be = { "relative-path", "true-absolute-path", "extant-path" }
    }, 
    {
      value = "/Volumes/foobar",
      must_be = { "volume", "non-root-volume"}
    },
    {
      value = env.TMBACKUPVOL,
      must_be = { "volume", "non-root-volume", "time-machine-volume" }
    },
    {
      value = "/Volumes/com.apple.TimeMachine.localsnapshots/Backups.backupdb/" .. hs.host.localizedName() .. "/" .. os.date("%Y-%m-%d-%H"),
      must_be = { "volume", "non-root-volume", "dynamic-time-machine-volume" }
    },
    {
      pretest = function()
        writeFile(TMPDIR_NOW .. "foo.txt")
      end,
      value = TMPDIR_NOW .. "foo.txt",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "file" },
      posttest = function()
        delete(TMPDIR_NOW .. "foo.txt")
      end
    },
    {
      value = env.HOME,
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "dir", "parent-dir", "grandparent-dir", "path-by-start", "path-in-home" },
    },
    {
      value = env.HOMEBREW_SHARE,
      must_be = { "path-by-start", "path-not-in-home"}
    },
    {
      pretest = function()
        writeFile(env.SCREENSHOTS .. "/" .. testtime .. ".png")
      end,
      value = env.SCREENSHOTS .. "/" .. testtime .. ".png",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "file", "path-in-home", "path-in-screenshots" },
      posttest = function()
        delete(env.SCREENSHOTS .. "/" .. testtime .. ".png")
      end
    },
    {
      value = env.MENV,
      must_be = { "path-in-home", "path-in-me", "path-in-mspec" }
    },
    {
      value = env.MPASSPASSW,
      must_be = { "path-in-home", "path-in-me", "path-in-mspec", "path-in-mpass", "path-in-mpassw" },
      must_not_be = { "path-in-mpassotp" }
    },
    {
      value = env.MPASSOTP,
      must_be = { "path-in-home", "path-in-me", "path-in-mspec", "path-in-mpass", "path-in-mpassw", "path-in-mpassotp" },
      must_not_be = { "path-in-mpassw" }
    },
    {
      value = env.MAUDIOVISUAL,
      must_be = { "path-in-home", "path-in-me", "path-in-maudiovisual" }
    },
    {
      value = "/foo/bar:289",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "non-extant-path", "path-with-line-andor-character-number" },
    },
    {
      value = "/foo/bar:289:12",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "non-extant-path", "path-with-line-andor-character-number" },
    },
    {
      value = itemsInPath(env.MENV)[1],
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "in-git-dir-path" }
    },
    {
      value = itemsInPath(env.MDIARY .. "/i_made_this/film")[1],
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "dated-extant-path"}
    },
    {
      value = env.MSPEC .. "/mock/files/plaintext/json/basic.json",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "file", "plaintext-file", "plaintext-dictionary-file", "json-file"}
    },
    {
      value = env.MSPEC .. "/mock/files/plaintext/md/basic.md",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "file", "plaintext-file", "md-file"}
    },
    {
      value = env.MSPEC .. "/mock/files/plaintext/m3u/basic.m3u",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "file", "plaintext-file", "m3u-file"}
    },
    {
      value = env.MSPEC .. "/mock/files/plaintext/gitignore/basic.gitignore",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "file", "plaintext-file", "gitignore-file"}
    },
    {
      value = env.MSPEC .. "/mock/files/plaintext/email/basic.eml",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "file", "plaintext-file", "email-file"}
    },
    {
      value = env.MSPEC .. "/mock/files/plaintext/xml/basic.xml",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "file", "plaintext-file", "plaintext-tree-file", "xml-file"}
    },
    {
      value = env.MSPEC .. "/mock/files/plaintext/yaml/basic.yaml",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "file", "plaintext-file", "plaintext-dictionary-file", "yaml-file"}
    },
    {
      value = env.MSPEC .. "/mock/files/plaintext/csv/basic.csv",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "file", "plaintext-file", "plaintext-table-file", "csv-file"}
    },
    {
      value = env.MSPEC .. "/mock/files/plaintext/tsv/basic.tsv",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path",  "file", "plaintext-file", "plaintext-table-file", "tsv-file"}
    },
    {
      value = env.MSPEC .. "/mock/files/plaintext/csv/timestamp.csv",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path","file", "plaintext-file", "plaintext-table-file", "csv-file", "timestamp-first-column-plaintext-table-file"}
    },
    {
      value = env.MSPEC .. "/mock/files/plaintext/toml/basic.toml",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path","file", "plaintext-file", "plaintext-dictionary-file", "toml-file"}
    },
    {
      value = env.MSPEC .. "/mock/files/plaintext/ini/basic.ini",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path","file", "plaintext-file", "plaintext-dictionary-file", "ini-file"}
    },
    {
      value = env.MSPEC .. "/mock/files/plaintext/bib/basic.bib",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path","file", "plaintext-file", "plaintext-dictionary-file", "bib-file"}
    },
    {
      value = env.MSPEC .. "/mock/files/plaintext/ics/basic.ics",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path","file", "plaintext-file", "plaintext-dictionary-file", "ics-file"}
    },
    {
      value = env.MSPEC .. "/mock/files/plaintext/log/basic.log",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path","file", "plaintext-file", "log-file"}
    },
    {
      value = env.MSPEC .. "/mock/files/plaintext/sh/basic.sh",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path","file", "plaintext-file", "executable-code-file", "shellscript-file"}
    },
    {
      value = env.MSPEC .. "/mock/files/plaintext/json/tachiyomi.json",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path","file", "plaintext-file", "plaintext-dictionary-file", "json-file", "tachiyomi-json-file"}
    },
    {
      value = env.MSPEC .. "/mock/dir/dir_by_structure/config_dir/khal/config.ini",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "dir", "plaintext-file", "plaintext-dictionary-file", "ini-file", "khal-config-file"}
    },
    {
      value = env.MSPEC .. "/mock/dir/dir_by_structure/config_dir/vdirsyncer/config.ini",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "dir", "plaintext-file", "plaintext-dictionary-file", "ini-file", "vdirsyncer-config-file"}
    },
    {
      value = env.MSPEC .. "/mock/dir/dir_by_structure/config_dir/newsboat/urls",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "dir", "plaintext-file", "newsboat-urls-file"}
    },
    {
      value = env.MSPEC .. "/mock/files/binary/image/png/basic.png",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "file", "image-file", "binary-file"}
    },
    {
      value = env.MSPEC .. "/mock/files/binary/db/sql/sqlite/places.sqlite",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "file", "binary-file", "db-file", "sql-file", "sqlite-file", "firefox-places-sqlite-file"}
    },
    {
      value = env.MSPEC .. "/mock/files/binary/db/sql/sqlite/newpipe.db",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "file", "binary-file", "db-file", "sql-file", "sqlite-file", "newpipe-sqlite-file"}
    },
    {
      value = env.MSPEC .. "/mock/dir/dir_by_tree/empty_dir",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "dir", "empty-dir"},
      must_not_be = { "parent-dir", "grandparent-dir"}
    },
    {
      value = env.MSPEC .. "/mock/dir/dir_by_tree/parent_only_dir",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "dir", "parent-dir", "parent-but-not-grandparent-dir"},
      must_not_be = { "empty-dir", "grandparent-dir"}
    },
    {
      value = env.MSPEC .. "/mock/dir/dir_by_tree/grandparent_dir",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "dir", "grandparent-dir", "parent-dir"},
      must_not_be = { "empty-dir", "parent-but-not-grandparent-dir"}
    },
    {
      value = env.MSPEC .. "/mock/dir/dir_by_structure/project_dir/cargo/basic_cargo",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "dir", "parent-dir", "project-dir", "cargo-project-dir"},
    },
    {
      value = env.MSPEC .. "/mock/dir/dir_by_structure/project_dir/latex/basic_latex",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "dir", "parent-dir", "project-dir", "latex-project-dir"},
    },
    {
      value = env.MSPEC .. "/mock/dir/dir_by_structure/project_dir/npm/basic_npm",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "dir", "parent-dir", "project-dir", "npm-project-dir"},
    },
    {
      value = env.MSPEC .. "/mock/dir/dir_by_structure/project_dir/omegat/basic_omegat",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "dir", "parent-dir", "project-dir", "omegat-project-dir"},
    },
    {
      value = env.MSPEC .. "/mock/dir/dir_by_structure/project_dir/sass/basic_sass",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "dir", "parent-dir", "project-dir", "sass-project-dir"},
    },
    {
      value = env.MSPEC .. "/mock/dir/dir_by_structure/git_dir/empty_git_root",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "dir", "parent-dir", "git-root-dir"},
    },
    {
      value = env.MSPEC .. "/mock/dir/dir_by_structure/logging_dir/empty_logs",
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "dir", "logging-dir"}
    },
    {
      value = env.MAC_APPLICATIONS,
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "dir", "dir-by-path", "applications-dir"}
    },
    {
      value = env.MCUR_PROJ,
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "dir", "dir-by-path", "mcur-proj-dir"}
    },
    {
      value = env.MENV,
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "dir", "dir-by-path", "menv-dir"}
    },
    {
      value = env.MDIARY,
      must_be = { "string", "single-item-string", "path", "absolute-path", "true-absolute-path", "extant-path", "dir", "dir-by-path", "mdiary-dir"}
    },
    {
      value = "foo\nbar",
      must_be = {
        "multiline-string"
      },
      must_not_be = {
        "singleline-string"
      }
    },
    {
      value = "foobar",
      must_be = {
        "singleline-string"
      },
    },
    {
      value = multiply("10 charact", 201),
      must_not_be = {"single-item-string"}
    },
    {
      value = "foo\tbar",
      must_not_be = {"single-item-string"}
    },
    {
      value = "oFo",
      must_be = {"has-lowercase-string", "has-uppercase-string"}
    },
    {
      value = "ofo",
      must_be = {"has-lowercase-string"},
      must_not_be = {"has-uppercase-string"}
    },
    {
      value = "OFO",
      must_be = {"has-uppercase-string"},
      must_not_be = {"has-lowercase-string", "might-be-json", "might-be-xml", "might-be-bib"}
    },
    {
      value = "{foo}",
      must_be = {"might-be-json"}
    },
    {
      value = "[foo]",
      must_be = {"might-be-json"}
    },
    {
      value = "<foo>",
      must_be = {"might-be-xml"}
    },
    {
      value = "@foo }",
      must_be = {"might-be-bib"}
    },
    {
      value = "This is this &amp; that is that",
      must_be = {"html-entity-encoded-string"}
    },
    {
      value = "This <b>text</b> needs to be encoded if it's going to be used in HTML",
      must_be = {"html-entity-decoded-string"}
    },
    {
      value = "https://www.google.com",
      must_be = {"string", "single-item-string", "url", "url-by-host"},
      must_not_be = {"url-by-path", "url-by-contenttype"}
    },
    {
      value = "https://www.google.com/foo/bar",
      must_be = {"string", "single-item-string", "url", "url-by-host", "url-by-path", "owner-item-url"},
      must_not_be = {"url-by-contenttype"}
    },
    {
      value = "https://www.google.com/foo/bar.png",
      must_be = {"string", "single-item-string", "url", "url-by-host", "url-by-path", "url-by-contenttype", "image-url"},
    },
    {
      value = "https://youtube.com/",
      must_be = {"url", "url-by-host", "youtube"},
    },
    {
      value = "https://youtube.com/watch?v=foo",
      must_be = {"url", "url-by-host", "youtube", "youtube-playable", "youtube-video"},
    },
    {
      value = "https://youtube.com/playlist?list=foo",
      must_be = {"url", "url-by-host", "youtube", "youtube-playable", "youtube-playlist"},
    },
    {
      value = "https://gelbooru.com/index.php?page=post&s=view&id=foo",
      must_be = {"url", "url-by-host", "booru-url", "gelbooru-url"}
    },
    {
      value = "https://yande.re/post/show/123456",
      must_be = {"url", "url-by-host", "booru-url", "yandere-url"}
    },
    {
      value = "foo392q@#",
      must_be = {"printable-ascii-string"}
    },
    {
      value = "foo32--_bar",
      must_be = {"printable-ascii-string", "alphanum-minus-underscore" }
    },
    {
      value = "DE" .. multiply("0", 32),
      must_be = {"printable-ascii-string", "alphanum-minus-underscore", "iban"}
    },
    {
      value = "10.1000/182",
      must_be = {"printable-ascii-string", "doi", "citeable-object-id", "nonlocal-citeable-object-id"},
      must_not_be = {"local-citeable-object-id"}
    },
    {
      value = "100",
      must_be = {"printable-ascii-string", "num"}
    },
    {
      value = "test@example.com",
      must_be = {"printable-ascii-string", "email-address"}
    },
    {
      value = "01321 1314 134 33",
      must_be = {"printable-ascii-string", "phone-number"}
    },
    {
      value = "-2d.fb",
      must_be = {"printable-ascii-string", "digit-string", "hexadecimal-digit-string"},
      must_not_be = {"binary-digit-string", "octal-digit-string", "decimal-digit-string"}
    },
    {
      value = "901",
      must_be = {"printable-ascii-string", "digit-string", "decimal-digit-string", "hexadecimal-digit-string", "decimal-id"},
      must_not_be = {"binary-digit-string", "octal-digit-string"}
    },
    {
      value = "201,5",
      must_be = {"printable-ascii-string", "digit-string", "decimal-digit-string", "octal-digit-string", "hexadecimal-digit-string"},
      must_not_be = { "binary-digit-string"}
    },
    {
      value = "-101010111",
      must_be = {"printable-ascii-string", "digit-string", "binary-digit-string", "decimal-digit-string", "octal-digit-string", "hexadecimal-digit-string"},
    },
    {
      value = "2021-02",
      must_be = {"printable-ascii-string", "date-related"}
    },
    {
      value = "4d20*2+6",
      must_be = {"printable-ascii-string", "dice-notation"}
    },
    {
      value = "U+2021",
      must_be = {"printable-ascii-string", "unicode-codepoint", "potentially-parseable-date"}
    },
    {
      value = "@choco",
      must_be = {"printable-ascii-string", "handle"}
    },
    {
      value = "JBSWY3DPEBLW64TMMQQQ====",
      must_be = {"printable-ascii-string", "general-base32", "base32"},
      must_not_be = {"crockford-base32"}
    },
    {
      value = "91JPRV3F5GG7EVVJDHJ22",
      must_be = {"printable-ascii-string", "base32", "crockford-base32"},
      must_not_be = {"general-base32"}
    },
    {
      value = "SGVsbG8gd29ybGQ=",
      must_be = {"printable-ascii-string", "base64", "general-base64"},
      must_not_be = {"url-base64"}
    },
    {
      value = "SGVsbG8gd29ybGQ_",
      must_be = {"printable-ascii-string", "base64", "url-base64"},
      must_not_be = {"general-base64"}
    },
    {
      value = "AEBAGBAF",
      must_be = {"printable-ascii-string", "base32", "crockford-base32", "general-base32"},
    },
    {
      value = "SGVsbG8gd29ybGQ",
      must_be = {"printable-ascii-string", "base64", "url-base64", "general-base64"},
    },
    {
      value = "foo-bar",
      must_be = {"alphanum-minus-underscore", "alphanum-minus"}
    },
    {
      value = "foo_bar",
      must_be = {"alphanum-minus-underscore", "word", "lowercase-word"}
    },
    {
      value = "FOO_BAR",
      must_be = {"alphanum-minus-underscore", "word"},
      must_not_be = {"lowercase-word"}
    },
    {
      value = "dsc",
      must_be = {"alphanum-minus-underscore", "word", "lowercase-word", "pass-name", "pass-otp", "pass-passw"},
      must_not_be = {
        "pass-recovery-keys", "pass-security-question", "pass-username"
      }
    },
    {
      value = "signal",
      must_be = {"pass-recovery-keys"}
    },
    {
      value = "elster",
      must_be = {"pass-security-question"}
    },
    {
      value = "barmer",
      must_be = {"pass-username"}
    },
    {
      must_be = {"alphanum-minus", "isbn", "citeable-object-id"},
      value = "978-3-16-148410-0"
    },
    {
      must_be = {"alphanum-minus", "issn"},
      value = "0378-5955"
    },
    {
      must_be = {"alphanum-minus", "uuid"},
      value = "f81d4fae-7dec-11d0-a765-00a0c91e6bf6"
    },
    {
      must_be = {"alphanum-minus", "package-manager"},
      value = "npm"
    },
    {
      must_be = {"alphanum-minus", "mullvad-relay-identifier"},
      value = "us-sea-wg-203"
    }


  },
  [CreateStreamItem] = {

  },
  [CreateTimerItem] = {

  },
  [CreateAudiodeviceItem] = {

  },
  [CreateContactTableItem] = {

  },
  [CreateEventTableItem] = {

  },
  [CreateInputMethodItem] = {

  },
  [CreatePathLeafParts] = {

  },
}




for create_function, test_specifers in prs(item_creation_map) do
  for _, test_specifier in iprs(test_specifers) do
    if test_specifier.pretest then
      test_specifier.pretest()
    end
    local value = test_specifier.value
    local item 
    if value then 
      if type(value) == "function" then
        value = value()
      end
      item = create_function(value)
    else
      item = test_specifier.local_create_function()
    end
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

