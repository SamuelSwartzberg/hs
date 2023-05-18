local rrq = bindArg(relative_require, "items-managers.items._test")

print("--- begin item tests ---")
rrq("general")
rrq("shape")
rrq("creation")
error("stop")
rrq("unit")
print("--- end item tests ---")