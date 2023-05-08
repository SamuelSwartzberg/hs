local rrq = bindArg(relative_require, "utils._test")

local orig_relative_require = relative_require

function test_relative_require(currmod, modname)
  print("Testing: " .. currmod .. " -> " .. modname)
  orig_relative_require(currmod, modname)
end
relative_require = test_relative_require

manual_tests = {} -- some tests don't work well when run automatically, especially those that perform async actions which may interfere with each other. These tests are added to this table, to be run manually.

rrq("type")
rrq("externals")
rrq("language-features")
env = getEnvAsTable()
rrq("basic-interfacing")


rrq("advanced-interfacing")
rrq("general-domain-ops")
rrq("specific-domain-ops")
relative_require = orig_relative_require

-- alert manual tests if mode == "full-test"

if mode == "full-test" then
  print("The following tests are manual tests. Please run them manually by calling manual_tests.<test_name>():")
  for k, v in pairs(manual_tests) do
    print(k)
  end
end