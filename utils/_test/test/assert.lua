assertMessageAny( "a", {"a", "b"})
assertMessageAny( "b", {"a", "b"})

local succ, res = pcall(assertMessageAny, "c", {"a", "b"})

assert(not succ)