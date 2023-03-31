-- Test 1: Basic existence test
local tempDir = env.TMPDIR
local testPath1 = tempDir .. "/testPath1_" .. tostring(os.time())
createPath(testPath1)
assertMessage(testPath(testPath1, {exists = true}), true)
delete(testPath1, "any", "delete", "any")

-- Test 2: Basic non-existence test
local testPath2 = tempDir .. "/testPath2_" .. tostring(os.time())
assertMessage(testPath(testPath2, false), true)

-- Test 3a: Test dirness
local testPath3 = tempDir .. "/testPath3_" .. tostring(os.time())
createPath(testPath3)
assertMessage(testPath(testPath3, "dir"), true)
delete(testPath3, "any", "delete", "any")

-- Test 3b: Test dirness
local testPath3 = tempDir .. "/testPath3_" .. tostring(os.time())
createPath(testPath3)
assertMessage(testPath(testPath3, {dirness = "dir"}), true)
delete(testPath3, "any", "delete", "any")

-- Test 4: Test existenceTest with contents condition
local testPath4 = tempDir .. "/testPath4_" .. tostring(os.time())
createPath(testPath4)
writeFile(testPath4 .. "/file.txt", "sample content", "any", true, "w")
assertMessage(testPath(testPath4 .. "/file.txt", {exists = true, contents = {_contains = "sample content"}}), true)
delete(testPath4, "any", "delete", "any")

-- Test 1: Basic existence test (remote)
local tempDirRemote = env.HSFTP_TMPDIR
local testPath1Remote = tempDirRemote .. "/testPath1_" .. tostring(os.time())
createPath(testPath1Remote)
assertMessage(testPath(testPath1Remote, true), true)
delete(testPath1Remote, "any", "delete", "any")

-- Test 2: Basic non-existence test (remote)
local testPath2Remote = tempDirRemote .. "/testPath2_" .. tostring(os.time())
assertMessage(testPath(testPath2Remote, false), true)

-- Test 3: Test dirness (remote)
local testPath3Remote = tempDirRemote .. "/testPath3_" .. tostring(os.time())
createPath(testPath3Remote)
assertMessage(testPath(testPath3Remote, {dirness = "dir"}), true)
delete(testPath3Remote, "any", "delete", "any")

-- Test 4: Test existenceTest with contents condition (remote)
local testPath4Remote = tempDirRemote .. "/testPath4_" .. tostring(os.time())
createPath(testPath4Remote)
writeFile(testPath4Remote .. "/file.txt", "sample content", "any", true, "w")
assertMessage(testPath(testPath4Remote, {exists = true, contents = {_contains = "sample content"}}), true)
delete(testPath4Remote, "any", "delete", "any")