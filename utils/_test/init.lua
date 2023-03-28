local rrq = bindArg(relative_require, "utils._test")

local orig_relative_require = relative_require

function test_relative_require(currmod, modname)
  print("Testing: " .. currmod .. " -> " .. modname)
  orig_relative_require(currmod, modname)
end
relative_require = test_relative_require
  

rrq("type")
rrq("externals")
rrq("language-features")
env = getEnvAsTable()
rrq("basic-interfacing")


rrq("advanced-interfacing")
rrq("general-domain-ops")
rrq("specific-domain-ops")
rrq("test")
relative_require = orig_relative_require