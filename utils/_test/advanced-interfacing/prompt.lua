-- promptStringInner

assertMessage(
  doGui("Hello World!\n",promptStringInner),
  "Hello World!"
)

assertMessage(
  doGui("\n", function ()
    promptStringInner({
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
  "4"
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
    promptPathInner({
      default = env.PROFILEFILE,
    })
  end),
  env.PROFILEFILE
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
    promptPathInner({
      default = "/private/etc",
      can_choose_directories = false,
      can_choose_files = true,
    })
  end),
  "/private/etc/sudoers"
)

assertMessage(
  doGui("sudoer\n", function ()
    promptPathInner({
      default = "/private/etc",
      can_choose_directories = true,
      can_choose_files = false,
    })
  end),
  "/private/etc/sudoers.d"
)

assertMessage(
  doGui("etc\n", function ()
    promptPathInner({
      default = "/",
      resolves_aliases = true,
    })
  end),
  "/private/etc"
)

assertMessage(
  doGui("etc\n", function ()
    promptPathInner({
      default = "/",
      resolves_aliases = false,
    })
  end),
  "/etc"
)

assertMessage(
  doGui("\n", function ()
    promptPathInner({
      default = env.HOME,
      allows_loop_selection = true,
    })
  end),
  {env.HOME}
)

-- promptNopolicy

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

assertValuesContainExactly(
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

assertValuesContainExactly(
  doGui("foo-bar\n", function ()
    return prompt("pair")
  end),
  {"foo", "bar"}
)

assertValuesContainExactly(
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

assertValuesContainExactly(
  doGui(pair_multiple, function ()
    return prompt("pair", {}, "array")
  end),
  {{"foo", "bar"}, {"baz", "qux"}}
)

assertValuesContainExactly(
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

assertMessage(
  doGui(function ()
    hs.eventtap.keyStrokes("/illegal")
    hs.eventtap.keyStroke({}, "return")
    hs.timer.doAfter(0.001, function()
      hs.eventtap.keyStrokes(env.DESKTOP)
      hs.eventtap.keyStroke({}, "return")
    end)
  end, function ()
    return prompt("dir", env.DOCUMENTS)
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
        hs.eventtap.keyStrokes(tmppath)
        hs.eventtap.keyStroke({}, "return")
      end)
    end,
    function ()
      return prompt("string-filepath", tmppath .. "2")
    end
  ),
  tmppath
)