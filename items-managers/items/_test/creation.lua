

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
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-string-items" },
      must_not_be = { "empty-array", "non-homogeneous-array", "array-of-noninterfaces" }
    },
    {
      value = { 
        CreateStringItem("/foo"), CreateStringItem("bar/baz")
      },
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-string-items", "array-of-paths", "array-of-path-leafs", "array-of-printable-ascii-items" },
      must_not_be = { "array-of-absolute-paths", "array-of-urls" }
    },
    {
      value = { CreateStringItem("/foo"), CreateStringItem("/home/user/bar/baz")},
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-string-items", "array-of-absolute-paths", "array-of-paths", "array-of-path-leafs", "array-of-printable-ascii-items" },
      must_not_be = { "array-of-extant-paths" }
    },
    {
      value = {
        CreateStringItem(env.DESKTOP),
        CreateStringItem(env.DOWNLOADS),
      },
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-string-items", "array-of-extant-paths", "array-of-paths", "array-of-path-leafs", "array-of-printable-ascii-items", "array-of-dirs"},
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
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-string-items", "array-of-extant-paths", "array-of-paths", "array-of-path-leafs", "array-of-printable-ascii-items", "array-of-files"},
      must_not_be = { "array-of-dirs" }

    },
    {
      value = {
        CreateStringItem(env.MENV),
        CreateStringItem(env.MDOTCONFIG)
      },
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-string-items", "array-of-extant-paths", "array-of-paths", "array-of-path-leafs", "array-of-printable-ascii-items", "array-of-dirs", "array-of-git-root-dirs", "array-of-in-git-dir-path-items"},
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
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-string-items", "array-of-extant-paths", "array-of-paths", "array-of-path-leafs", "array-of-printable-ascii-items", "array-of-in-git-dir-path-items"},
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
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-string-items", "array-of-extant-paths", "array-of-paths", "array-of-path-leafs", "array-of-printable-ascii-items", "array-of-files", "array-of-plaintext-files", "array-of-plaintext-dictionary-files"},
    },
    {
      value = {CreateStringItem("/Volumes/foo"), CreateStringItem("/Volumes/bar")},
      must_be = {"array-of-absolute-paths", "array-of-volumes"},
    },
    {
      value = {CreateStringItem("foo"), CreateStringItem("bar\0baz")},
      must_not_be = { "array-of-printable-ascii-items" }
    },
    {
      value = {CreateStringItem("a_b-c"), CreateStringItem("def")},
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-string-items", "array-of-printable-ascii-items", "array-of-alphanum-minus-underscore-items" },
      must_not_be = { "array-of-alphanum-minus-items" }
    },
    {
      value = {CreateStringItem("b-c"), CreateStringItem("2022-02")},
      must_be = { "array-of-alphanum-minus-items" },
      must_not_be = { "array-of-date-related-items" }
    },
    {
      value = {
        CreateStringItem("15af8992-7b9b-094d-a363-1cdb45a90f5f"),
        CreateStringItem("2c05471a-2970-45c4-81f2-44f79566b432"),
        CreateStringItem("123e4567-e89b-12d3-a456-426614174000"),
      },
      must_be = { "array", "non-empty-array", "homogeneous-array",  "array-of-interfaces", "array-of-non-array-interfaces", "array-of-string-items", "array-of-printable-ascii-items", "array-of-alphanum-minus-underscore-items","array-of-alphanum-minus-items",
      "array-of-uuid-items"
      },
      must_not_be = { "array-of-contacts" }
    },
    {
      value = {
        CreateStringItem("15af8992-7b9b-094d-a363-1cdb45a90f5f"),
        CreateStringItem("2c05471a-2970-45c4-81f2-44f79566b432"),
      },
      must_be = { "array", "non-empty-array", "homogeneous-array",  "array-of-interfaces", "array-of-non-array-interfaces", "array-of-string-items", "array-of-printable-ascii-items", "array-of-alphanum-minus-underscore-items","array-of-alphanum-minus-items",
      "array-of-uuid-items",
      "array-of-contacts"
      },
    },
    {
      value = {CreateStringItem("2022-02-01"), CreateStringItem("2022-02-02T08:00")},
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-string-items", "array-of-printable-ascii-items", "array-of-date-related-items" },
    },
    {
      value = {CreateStringItem("dsc"), CreateStringItem("ma"), CreateStringItem("uniqlo")},
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-string-items", "array-of-printable-ascii-items", "array-of-pass-name-items", "array-of-pass-passw-items" },
      must_not_be = { "array-of-pass-otp-items" }
    },
    {
      value = {CreateStringItem("dsc"), CreateStringItem("ma")},
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-string-items", "array-of-printable-ascii-items", "array-of-pass-name-items", "array-of-pass-passw-items" , "array-of-pass-otp-items" }
    },
    {
      value = {CreateStringItem("https://www.youtube.com/watch?v=dQw4w9WgXcQ"), CreateStringItem("https://www.google.com")},
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-string-items", "array-of-urls", "array-of-urls-by-host" },
      must_not_be = { "array-of-youtubes" }
    },
    {
      value = {CreateStringItem("https://www.youtube.com/watch?v=dQw4w9WgXcQ"), CreateStringItem("https://www.youtube.com/playlist?list=PLYlndC1jl8s3_Sy4zCIU77wQv1zQs38qX"), CreateStringItem("https://www.youtube.com")},
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-string-items", "array-of-urls", "array-of-urls-by-host", "array-of-youtubes" },
      must_not_be = { "array-of-youtube-playable-items" }
    },
    {
      value = {CreateStringItem("https://www.youtube.com/watch?v=dQw4w9WgXcQ"), CreateStringItem("https://www.youtube.com/playlist?list=PLYlndC1jl8s3_Sy4zCIU77wQv1zQs38qX"),},
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-string-items", "array-of-urls", "array-of-urls-by-host", "array-of-youtubes", "array-of-youtube-playable-items" },
      must_not_be = {  "array-of-youtube-videos" }
    },
    {
      value = {CreateStringItem("https://www.youtube.com/watch?v=dQw4w9WgXcQ"), CreateStringItem("https://www.youtube.com/watch?v=QH2-TGUlwu4")},
      must_be = { "array", "non-empty-array", "homogeneous-array", "array-of-interfaces", "array-of-non-array-interfaces", "array-of-string-items", "array-of-urls", "array-of-urls-by-host", "array-of-youtubes", "array-of-youtube-playable-items", "array-of-youtube-videos" },
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
        "creatable-item",
        "fireable-item",
        "hotkey-item",
      }
    },
    {
      value = {
        type = "watcher"
      },
      must_be = {
        "creatable-item",
        "fireable-item",
        "watcher-item",
      }
    },
    {
      value = {
        type = "task"
      },
      must_be = {
        "creatable-item",
        "task-item",
      },
      must_not_be = {
        "fireable-item",
        "hotkey-item",
        "watcher-item",
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
      must_be = { "env-item", "value-env-item", "list-value-env-item", "nodependents-env-item", "noaliases-env-item" },
      must_not_be = { "no-value-env-item", "dependents-env-item", "string-value-env-item", "aliases-env-item" }
    },
    {
      value = {
        value = "foo"
      },
      must_be = { "env-item", "value-env-item", "string-value-env-item",  "nodependents-env-item", "noaliases-env-item"  },
      must_not_be = { "no-value-env-item" , "dependents-env-item", "list-value-env-item", "aliases-env-item" }
    },
    {
      value = {
        dependents = {
          FOO = "bar"
        }
      },
      must_be = { "env-item", "no-value-env-item", "dependents-env-item", "noaliases-env-item" },
      must_not_be = { "value-env-item", "nodependents-env-item" , "string-value-env-item", "list-value-env-item", "aliases-env-item" }
    },
    {
      value = {
        aliases = { "FOO "}
      },
      must_be = { "env-item", "no-value-env-item", "aliases-env-item", "nodependents-env-item" },
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
      must_be = { "string-item", "single-item-string-item", "path", "relative-path" },
      must_not_be = { "absolute-path" }
    },
    {
      value = "/foo/bar",
      must_be = { "string-item", "single-item-string-item", "path", "absolute-path", "true-absolute-path", "non-extant-path", "path-leaf", "path-leaf-general-name" },
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
    },
    {
      value = "foo\nbar",
      must_be = {
        "multiline-string-item"
      },
      must_not_be = {
        "singleline-string-item"
      }
    },
    {
      value = "foobar",
      must_be = {
        "singleline-string-item"
      },
    },
    {
      value = multiply("10 charact", 201),
      must_not_be = {"single-item-string-item"}
    },
    {
      value = "foo\tbar",
      must_not_be = {"single-item-string-item"}
    },
    {
      value = "oFo",
      must_be = {"has-lowercase-string-item", "has-uppercase-string-item"}
    },
    {
      value = "ofo",
      must_be = {"has-lowercase-string-item"},
      must_not_be = {"has-uppercase-string-item"}
    },
    {
      value = "OFO",
      must_be = {"has-uppercase-string-item"},
      must_not_be = {"has-lowercase-string-item", "might-be-json-item", "might-be-xml-item", "might-be-bib-item"}
    },
    {
      value = "{foo}",
      must_be = {"might-be-json-item"}
    },
    {
      value = "[foo]",
      must_be = {"might-be-json-item"}
    },
    {
      value = "<foo>",
      must_be = {"might-be-xml-item"}
    },
    {
      value = "@foo }",
      must_be = {"might-be-bib-item"}
    },
    {
      value = "This is this &amp; that is that",
      must_be = {"html-entity-encoded-string-item"}
    },
    {
      value = "This <b>text</b> needs to be encoded if it's going to be used in HTML",
      must_be = {"html-entity-decoded-string-item"}
    },
    {
      value = "https://www.google.com",
      must_be = {"string-item", "single-item-string-item", "url", "url-by-host-item"},
      must_not_be = {"url-by-path-item", "url-by-contenttype"}
    },
    {
      value = "https://www.google.com/foo/bar",
      must_be = {"string-item", "single-item-string-item", "url", "url-by-host-item", "url-by-path-item", "owner-item-url"},
      must_not_be = {"url-by-contenttype"}
    },
    {
      value = "https://www.google.com/foo/bar.png",
      must_be = {"string-item", "single-item-string-item", "url", "url-by-host-item", "url-by-path-item", "url-by-contenttype-item", "image-url-item"},
    },
    {
      value = "https://youtube.com/",
      must_be = {"url", "url-by-host-item", "youtube-item"},
    },
    {
      value = "https://youtube.com/watch?v=foo",
      must_be = {"url", "url-by-host-item", "youtube-item", "youtube-playable-item", "youtube-video"},
    },
    {
      value = "https://youtube.com/playlist?list=foo",
      must_be = {"url", "url-by-host-item", "youtube-item", "youtube-playable-item", "youtube-playlist"},
    },
    {
      value = "https://gelbooru.com/index.php?page=post&s=view&id=foo",
      must_be = {"url", "url-by-host-item", "booru-url", "gelbooru-url"}
    },
    {
      value = "https://yande.re/post/show/123456",
      must_be = {"url", "url-by-host-item", "booru-url", "yandere-url"}
    },
    {
      value = "foo392q@#",
      must_be = {"printable-ascii-string-item"}
    },
    {
      value = "foo32--_bar",
      must_be = {"printable-ascii-string-item", "alphanum-minus-underscore-item" }
    },
    {
      value = "DE" .. multiply("0", 32),
      must_be = {"printable-ascii-string-item", "alphanum-minus-underscore-item", "iban-item"}
    },
    {
      value = "10.1000/182",
      must_be = {"printable-ascii-string-item", "doi-item", "citeable-object-id-item", "nonlocal-citeable-object-id-item"},
      must_not_be = {"local-citeable-object-id-item"}
    },
    {
      value = "100",
      must_be = {"printable-ascii-string-item", "num-item"}
    },
    {
      value = "test@example.com",
      must_be = {"printable-ascii-string-item", "email-address-item"}
    },
    {
      value = "01321 1314 134 33",
      must_be = {"printable-ascii-string-item", "phone-number-item"}
    },
    {
      value = "-2d.fb",
      must_be = {"printable-ascii-string-item", "digit-string-item", "hexadecimal-digit-string"},
      must_not_be = {"binary-digit-string", "octal-digit-string", "decimal-digit-string"}
    },
    {
      value = "901",
      must_be = {"printable-ascii-string-item", "digit-string-item", "decimal-digit-string", "hexadecimal-digit-string", "decimal-id"},
      must_not_be = {"binary-digit-string", "octal-digit-string"}
    },
    {
      value = "201,5",
      must_be = {"printable-ascii-string-item", "digit-string-item", "decimal-digit-string", "octal-digit-string", "hexadecimal-digit-string"},
      must_not_be = { "binary-digit-string"}
    },
    {
      value = "-101010111",
      must_be = {"printable-ascii-string-item", "digit-string-item", "binary-digit-string", "decimal-digit-string", "octal-digit-string", "hexadecimal-digit-string"},
    },
    {
      value = "2021-02",
      must_be = {"printable-ascii-string-item", "date-related-item"}
    },
    {
      value = "4d20*2+6",
      must_be = {"printable-ascii-string-item", "dice-notation-item"}
    },
    {
      value = "U+2021",
      must_be = {"printable-ascii-string-item", "unicode-codepoint-item", "potentially-parseable-date-item"}
    },
    {
      value = "@choco",
      must_be = {"printable-ascii-string-item", "handle-item"}
    },
    {
      value = "JBSWY3DPEBLW64TMMQQQ====",
      must_be = {"printable-ascii-string-item", "general-base32-item", "base32-item"},
      must_not_be = {"crockford-base32-item"}
    },
    {
      value = "91JPRV3F5GG7EVVJDHJ22",
      must_be = {"printable-ascii-string-item", "base32-item", "crockford-base32-item"},
      must_not_be = {"general-base32-item"}
    },
    {
      value = "SGVsbG8gd29ybGQ=",
      must_be = {"printable-ascii-string-item", "base64-item", "general-base64-item"},
      must_not_be = {"url-base64-item"}
    },
    {
      value = "SGVsbG8gd29ybGQ_",
      must_be = {"printable-ascii-string-item", "base64-item", "url-base64-item"},
      must_not_be = {"general-base64-item"}
    },
    {
      value = "AEBAGBAF",
      must_be = {"printable-ascii-string-item", "base32-item", "crockford-base32-item", "general-base32-item"},
    },
    {
      value = "SGVsbG8gd29ybGQ",
      must_be = {"printable-ascii-string-item", "base64-item", "url-base64-item", "general-base64-item"},
    },
    {
      value = "foo-bar",
      must_be = {"alphanum-minus-underscore-item", "alphanum-minus-item"}
    },
    {
      value = "foo_bar",
      must_be = {"alphanum-minus-underscore-item", "word-item", "lowercase-word-item"}
    },
    {
      value = "FOO_BAR",
      must_be = {"alphanum-minus-underscore-item", "word-item"},
      must_not_be = {"lowercase-word-item"}
    },
    {
      value = "dsc",
      must_be = {"alphanum-minus-underscore-item", "word-item", "lowercase-word-item", "pass-name-item", "pass-otp-item", "pass-passw-item"},
      must_not_be = {
        "pass-recovery-keys-item", "pass-security-question-item", "pass-username-item"
      }
    },
    {
      value = "signal",
      must_be = {"pass-recovery-keys-item"}
    },
    {
      value = "elster",
      must_be = {"pass-security-question-item"}
    },
    {
      value = "barmer",
      must_be = {"pass-username-item"}
    },
    {
      must_be = {"alphanum-minus-item", "isbn-item", "citeable-object-id-item"},
      value = "978-3-16-148410-0"
    },
    {
      must_be = {"alphanum-minus-item", "issn-item"},
      value = "0378-5955"
    },
    {
      must_be = {"alphanum-minus-item", "uuid-item"},
      value = "f81d4fae-7dec-11d0-a765-00a0c91e6bf6"
    },
    {
      must_be = {"alphanum-minus-item", "package-manager-item"},
      value = "npm"
    },
    {
      must_be = {"alphanum-minus-item", "mullvad-relay-identifier-item"},
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

