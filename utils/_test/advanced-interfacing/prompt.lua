if mode == "full-test" then
  
-- promptStringInner

assertMessage(
  doGui("Hello World!\n",promptStringInner),
  "Hello World!"
)

assertMessage(
  doGui("\n", function ()
    return promptStringInner({
      default = "Hello World!",
    })
  end),
  "Hello World!"
)

assertMessage(
  doGui("\n", promptStringInner),
  nil -- "" -> nil conversion
)

assertMessage(
  doGui(" 2 + 2\n", promptStringInner),
  4
)

local rawreturn, ok_button_pressed = doGui("Hello World!\n", promptStringInner)

assertMessage(ok_button_pressed, true)

-- promptPathInner

assertMessage(
  doGui("De\n", promptPathInner),
  env.DESKTOP
)

assertMessage(
  doGui("\n", promptPathInner),
  env.HOME
)

assertMessage(
  doGui("\n", function ()
    return promptPathInner({
      default = env.DESKTOP,
    })
  end),
  env.DESKTOP
)

local rawres, succ = doGui(
  function ()
    hs.eventtap.keyStroke({}, "escape")
  end,
  promptPathInner
)

assertMessage(succ, false)
assertMessage(rawres, nil)

assertMessage(
  doGui("sudoer\n", function ()
    return promptPathInner({
      default = "/private/etc",
      can_choose_directories = false,
      can_choose_files = true,
    })
  end),
  "/private/etc/sudoers"
)

assertMessage(
  doGui("sudoer\n", function ()
    return promptPathInner({
      default = "/private/etc",
      can_choose_directories = true,
      can_choose_files = false,
    })
  end),
  "/private/etc/sudoers.d"
)

local choosetc = function()
  hs.eventtap.keyStroke({ "cmd", "shift"}, ".") -- show hidden files
  hs.eventtap.keyStrokes("etc")
  hs.eventtap.keyStroke({}, "return")
end

assertMessage(
  doGui(choosetc, function ()
    return promptPathInner({
      default = "/",
      resolves_aliases = true,
    })
  end),
  "/private/etc"
)

assertMessage(
  doGui(choosetc, function ()
    return promptPathInner({
      default = "/",
      resolves_aliases = false,
    })
  end),
  "/etc"
)

assertMessage(
  doGui("\n", function ()
    return promptPathInner({
      default = env.HOME,
      allows_loop_selection = true,
    })
  end),
  {env.HOME}
)


-- promptNopolicy

local mockPrompterReturnsNil = function()
  return nil, true
end
local getMockPrompterReturnsNilFirstTry = function()
  local first_try = true
  return function()
    if first_try then
      first_try = false
      return nil, true
    else
      return "Hello World!", true
    end
  end
end
local mockPrompterCancelled = function()
  return nil, false
end
local getMockPrompterCancelledFirstTry = function()
  local first_try = true
  return function()
    if first_try then
      first_try = false
      return nil, false
    else
      return "Hello World!", true
    end
  end
end

local mockPrompterReturnsString = function()
  return "Hello World!", true
end

local mockPrompterInvalidWhenTransformed = function()
  return "Invalid when transformed", true
end

local getMockPrompterInvalidWhenTransformedFirstTry = function()
  local first_try = true
  return function()
    if first_try then
      first_try = false
      return "Invalid when transformed", true
    else
      return "Hello World!", true
    end
  end
end

local mockTransformerRejectsInvalidWhenTransformed = function(x)
  return ternary(x == "Invalid when transformed", nil, x), true
end

-- try permutations of on_raw_invalid, on_transformed_invalid, on_cancel and "return_nil", "error", "reprompt"

assertMessage(
  promptNopolicy({
    prompter = mockPrompterReturnsNil,
    on_raw_invalid = "return_nil",
  }),
  nil
)

local succ, res = pcall(promptNopolicy, {
  prompter = mockPrompterReturnsNil,
  on_raw_invalid = "error"
})

assertMessage(succ, false)
assertMessage(res, "WARN: User input was invalid (before transformation).")

assertMessage(
  promptNopolicy({
    prompter = getMockPrompterReturnsNilFirstTry(),
    on_raw_invalid = "reprompt",
  }),
  "Hello World!"
)

assertMessage(
  promptNopolicy({
    prompter = mockPrompterCancelled,
    on_cancel = "return_nil",
  }),
  nil
)

local succ, res = pcall(promptNopolicy, {
  prompter = mockPrompterCancelled,
  on_cancel = "error"
})

assertMessage(succ, false)
assertMessage(res, "WARN: User cancelled modal.")

assertMessage(
  promptNopolicy({
    prompter = getMockPrompterCancelledFirstTry(),
    on_cancel = "reprompt",
  }),
  "Hello World!"
)

assertMessage(
  promptNopolicy({
    prompter = mockPrompterInvalidWhenTransformed,
    transformer = mockTransformerRejectsInvalidWhenTransformed,
    on_transformed_invalid = "return_nil",
  }),
  nil
)

local succ, res = pcall(promptNopolicy, {
  prompter = mockPrompterInvalidWhenTransformed,
  transformer = mockTransformerRejectsInvalidWhenTransformed,
  on_transformed_invalid = "error"
})

assertMessage(succ, false)
assertMessage(res, "WARN: User input was invalid (after transformation).")

assertMessage(
  promptNopolicy({
    prompter = getMockPrompterInvalidWhenTransformedFirstTry(),
    transformer = mockTransformerRejectsInvalidWhenTransformed,
    on_transformed_invalid = "reprompt",
  }),
  "Hello World!"
)

-- success

assertMessage(
  promptNopolicy({
    prompter = mockPrompterReturnsString,
  }),
  "Hello World!"
)

-- final_postprocessor

assertMessage(
  promptNopolicy({
    prompter = mockPrompterReturnsString,
    final_postprocessor = function(x)
      return x .. "!"
    end,
  }),
  "Hello World!!"
)

-- prompt

-- test on_cancel behavior once

local succ, res = pcall(doGui, function()
  hs.eventtap.keyStroke({}, "escape")
end, prompt)

assertMessage(succ, false)
assertMessage(res, "WARN: User cancelled modal.")

-- test raw_validator behavior once

assertMessage(
  doGui("\n", prompt),
  nil
)

-- for each type, test: transformed_validator, result once for loop = nil, "array", "pipeline" (as well as some behavior unique to some types)

-- type: string

assertMessage(
  doGui("Hello World!\n", function ()
    return prompt("string")
  end),
  "Hello World!"
)

-- no transformed_validator for string

local function string_multiple()
  hs.eventtap.keyStrokes("Hello World!")
  hs.eventtap.keyStroke({}, "return")
  hs.timer.doAfter(0.001, function()
    hs.eventtap.keyStrokes("Konnichiwa Sekai!")
    hs.eventtap.keyStroke({}, "return")
    hs.timer.doAfter(0.001, function()
      hs.eventtap.keyStrokes("Bonjour le Monde!")
      hs.eventtap.keyStroke({}, "return")
      hs.timer.doAfter(0.001, function()
        hs.eventtap.keyStroke({}, "return")
      end)
    end)
  end)
end

assertMessage(
  doGui(
    string_multiple,
    function ()
      return prompt("string", {}, "array")
    end
  ),
  {"Hello World!", "Konnichiwa Sekai!", "Bonjour le Monde!"}
)

assertMessage(
  doGui(
    string_multiple,
    function ()
      return prompt("string", {}, "pipeline")
    end
  ),
  "Bonjour le Monde!"
)

-- type: int

assertMessage(
  doGui("42\n", function ()
    return prompt("int")
  end),
  42
)

assertMessage(
  doGui(function()
    hs.eventtap.keyStrokes("notanumber")
    hs.eventtap.keyStroke({}, "return")
    hs.timer.doAfter(0.001, function()
      hs.eventtap.keyStrokes("42")
      hs.eventtap.keyStroke({}, "return")
    end)
  end, function ()
    return prompt("int")
  end),
  42
)

local function int_multiple()
  hs.eventtap.keyStrokes("2")
  hs.eventtap.keyStroke({}, "return")
  hs.timer.doAfter(0.001, function()
    hs.eventtap.keyStrokes("4")
    hs.eventtap.keyStroke({}, "return")
    hs.timer.doAfter(0.001, function()
      hs.eventtap.keyStroke({}, "return")
    end)
  end)
end

assertMessage(
  doGui(int_multiple, function ()
    return prompt("int", {}, "array")
  end),
  {2, 4}
)

assertMessage(
  doGui(int_multiple, function ()
    return prompt("int", {}, "pipeline")
  end),
  4
)

-- type: number

assertMessage(
  doGui("42.5\n", function ()
    return prompt("number")
  end),
  42.5
)


assertMessage(
  doGui(function()
    hs.eventtap.keyStrokes("notanumber")
    hs.eventtap.keyStroke({}, "return")
    hs.timer.doAfter(0.001, function()
      hs.eventtap.keyStrokes("42.5")
      hs.eventtap.keyStroke({}, "return")
    end)
  end, function ()
    return prompt("number")
  end),
  42.5
)

local function number_multiple()
  hs.eventtap.keyStrokes("2.5")
  hs.eventtap.keyStroke({}, "return")
  hs.timer.doAfter(0.001, function()
    hs.eventtap.keyStrokes("4")
    hs.eventtap.keyStroke({}, "return")
    hs.timer.doAfter(0.001, function()
      hs.eventtap.keyStroke({}, "return")
    end)
  end)
end

assertMessage(
  doGui(number_multiple, function ()
    return prompt("number", {}, "array")
  end),
  {2.5, 4}
)

assertMessage(
  doGui(number_multiple, function ()
    return prompt("number", {}, "pipeline")
  end),
  4
)

-- type: pair

assertMessage(
  doGui("foo-bar\n", function ()
    return prompt("pair")
  end),
  {"foo", "bar"}
)

assertMessage(
  doGui(function()
    hs.eventtap.keyStrokes("foobar")
    hs.eventtap.keyStroke({}, "return")
    hs.timer.doAfter(0.001, function()
      hs.eventtap.keyStrokes("foo-bar")
      hs.eventtap.keyStroke({}, "return")
    end)
  end, function ()
    return prompt("pair")
  end),
  {"foo", "bar"}
)

local function pair_multiple()
  hs.eventtap.keyStrokes("foo-bar")
  hs.eventtap.keyStroke({}, "return")
  hs.timer.doAfter(0.001, function()
    hs.eventtap.keyStrokes("baz-qux")
    hs.eventtap.keyStroke({}, "return")
    hs.timer.doAfter(0.001, function()
      hs.eventtap.keyStroke({}, "return")
    end)
  end)
end

assertMessage(
  doGui(pair_multiple, function ()
    return prompt("pair", {}, "array")
  end),
  {{"foo", "bar"}, {"baz", "qux"}}
)

assertMessage(
  doGui(pair_multiple, function ()
    return prompt("pair", {}, "pipeline")
  end),
  {"baz", "qux"}
)

-- type: string-path, string-filepath, path, dir

assertMessage(
  doGui("\n", function ()
    return prompt("dir", env.DESKTOP)
  end),
  env.DESKTOP
)

assertMessage(
  doGui("\n", function ()
    return prompt("path", env.DESKTOP)
  end),
  env.DESKTOP
)

assertMessage(
  doGui("\n", function ()
    return prompt("string-path", env.DESKTOP)
  end),
  env.DESKTOP
)

local tmppath =  env.TMPDIR .. "/prompttest/".. os.time() .. ".txt"

assertMessage(
  doGui("\n", function ()
    return prompt("string-filepath", tmppath)
  end),
  tmppath
)

assertMessage(
  doGui(
    function ()
      hs.eventtap.keyStrokes("/illegal")
      hs.eventtap.keyStroke({}, "return")
      hs.timer.doAfter(0.001, function()
        hs.eventtap.keyStrokes(tmppath .. "2")
        hs.eventtap.keyStroke({}, "return")
      end)
    end,
    function ()
      return prompt("string-filepath", tmppath .. "1")
    end
  ),
  tmppath .. "2"
)


else
  print("skipping...")
end

-- promptPipeline (like the "pipeline" arg, but allowing prompts of different types to be chained)

assertMessage(
  promptPipeline({
    {"string", { prompter = function() return "41", true end }},
    {"integer", { prompter = function(prompt_args) return prompt_args.default, true end }},
    {"number", { prompter = function(prompt_args) return prompt_args.default / 2, true end }},
  }),
  20.5
)