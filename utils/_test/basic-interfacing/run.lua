-- buildInnerCommand:

-- mere string passthrough

assertMessage(
  buildInnerCommand("cat ~/.profile | tr -d '\\n'"),
  "cat ~/.profile | tr -d '\\n'"
)

-- command building with only string parts

assertMessage(
  buildInnerCommand({
    "cat",
    "~/.profile",
    "|",
    "tr",
    "-d",
    "'\\n'"
  }),
  "cat ~/.profile | tr -d '\\n'"
)

-- command building with string and quoted parts

assertMessage(
  buildInnerCommand({
    "cat",
    { value = "~/.profile", type = "quoted" },
    "|",
    "tr",
    "-d",
    { value = "\\n", type = "quoted" }
  }),
  "cat \"~/.profile\" | tr -d \"\\n\""
)

-- command building with only string and interpolated parts

assertMessage(
  buildInnerCommand({
    "echo",
    {
      value = "seq 1 10",
      type = "interpolated"
    }
  }),
  'echo "$(seq 1 10)"'
)

-- quoted parts in interpolated parts

assertMessage(
  buildInnerCommand({
    "echo",
    {
      value = {
        "cat",
        {
          value = "~/fake file with spaces",
          type = "quoted"
        }
      },
      type = "interpolated"
    }
  }),
  'echo "$(cat "~/fake file with spaces")"'
)

-- nested interpolated parts

assertMessage(
  buildInnerCommand({
    "echo",
    {
      value = {
        "echo",
        {
          value = {
            "cat",
            {
              value = "~/fake file with spaces",
              type = "quoted"
            }
          },
          type = "interpolated"
        }
      },
      type = "interpolated"
    }
  }),
  'echo "$(echo "$(cat "~/fake file with spaces")")"'
)

-- run:

-- non-async:

-- non-async with no callback

assertMessage(
  run("echo 'hello world'"),
  "hello world"
)

-- default error handling

local succ, res = pcall(run, "false")

assertMessage(succ, false)
assertMessage(res, "Error running command:\n\nfalse\n\nExit code: 1\n\nStderr: ")

-- custom error handling

run({
  args = "false", 
  catch = function(exitcode, stderr)
    assertMessage(exitcode, 1)
    assertMessage(stderr, "")
  end
})

-- custom and default error handling

local succ, res = pcall(run, {
  args = "false",
  catch = function(exitcode, stderr)
    assertMessage(exitcode, 1)
    assertMessage(stderr, "")
    return true
  end
})

assertMessage(succ, false)
assertMessage(res, "Error running command:\n\nfalse\n\nExit code: 1\n\nStderr: ")

-- finally with no callback and no error

local runres

runres = run({
  args = "echo 'hello world'", 
  finally = function()
    assertMessage(runres, nil)
  end
})

assertMessage(runres, "hello world")

-- finally with no callback and error

local catch_called = false

run( {
  args = "false",
  catch = function()
    catch_called = true
  end,
  finally = function()
    assertMessage(catch_called, true)
  end
})

-- non-async with callback and force_sync

assertMessage(
  run({
      args = "echo 'hello world'",
      force_sync = true
    }, function (std_out)
      return std_out .. "!"
    end
  ),
  "hello world!"
)

-- callback specified in options instead of as 2nd argument

assertMessage(
  run({
      args = "echo 'hello world'",
      force_sync = true,
      and_then = function (std_out)
        return std_out .. "!"
      end
    }
  ),
  "hello world!"
)

-- option: dont_clean_output

assertMessage(
  run({
    args = "echo '   hello world   '",
  }),
  "hello world"
)

assertMessage(
  run({
    args = "echo -n '   hello world   '",
    dont_clean_output = true
  }),
  "   hello world   "
)

-- option: error_on_empty_output

local succ, res = pcall(run, {
  args = "echo ",
  error_on_empty_output = true
})

assertMessage(succ, false)

assertMessage(
  run({
    args = "echo ",
    error_on_empty_output = false
  }),
  ""
)

-- option: run_raw_shell

assertMessage(
  run({
    args = 'echo "$ME/foo"'
  }),
  env.ME .. "/foo"
)

assertMessage(
  run({
    args = 'echo "$ME/foo"',
    run_raw_shell = true
  }),
  "/foo"
)

-- async:

-- async with no callback (edits file to prove that it ran)

local file = env.TMPDIR .. "/async_test/" .. os.time()

local runres = run("echo 'hello world' > " .. file, true)

assertMessage(runres, nil)
assertMessage(readFile(file), "hello world")

-- async with callback

run("echo 'hello world'", function (std_out)
  assertMessage(std_out, "hello world")
end)

-- async with callback and delay

local timestamp = os.time()

run({
  args = "echo 'hello world'",
  delay = 1
}, function (std_out)
  assertMessage(std_out, "hello world")
  assertMessage(os.time() - timestamp, 1)
end)

-- async with error 


run({
  args = "false",
  catch = function()
    assertMessage(true, true)
  end
}, function ()
  assertMessage(true, false) -- should not be called
end)

-- async with callback and finally  


local callback_called = false

run({
  args = "echo 'hello world'",
  finally = function()
    assertMessage(callback_called, true)
  end
}, function (std_out)
  assertMessage(std_out, "hello world")
  callback_called = true
end)

-- async with catch and finally

local catch_called = false

run({
  args = "false",
  catch = function()
    catch_called = true
  end,
  finally = function()
    assertMessage(catch_called, true)
  end
}, function ()
  assertMessage(true, false) -- should not be called
end)

