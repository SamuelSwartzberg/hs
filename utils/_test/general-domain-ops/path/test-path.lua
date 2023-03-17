-- Test 1: Basic existence test
local tempDir = env.TMPDIR
local testPath1 = tempDir .. "/testPath1_" .. tostring(os.time())
createPath(testPath1)
assertMessage(testPath(testPath1, {existence = true}), true)
delete(testPath1, "any", "delete", "any")

-- Test 2: Basic non-existence test
local testPath2 = tempDir .. "/testPath2_" .. tostring(os.time())
assertMessage(testPath(testPath2, {existence = false}), true)

-- Test 3: Test dirness
local testPath3 = tempDir .. "/testPath3_" .. tostring(os.time())
createPath(testPath3)
assertMessage(testPath(testPath3, {dirness = "dir"}), true)
delete(testPath3, "any", "delete", "any")

-- Test 4: Test existenceTest with contents condition
local testPath4 = tempDir .. "/testPath4_" .. tostring(os.time())
createPath(testPath4)
writeFile(testPath4 .. "/file.txt", "sample content", "any", true, "w")
assertMessage(testPath(testPath4, {existence = {exists = true, contents = {_contains = "sample content"}}}), true)
delete(testPath4, "any", "delete", "any")

-- Test 5: Test sliceTest with single slice
local testPath5 = tempDir .. "/testPath5_" .. tostring(os.time())
createPath(testPath5 .. "/a/b/c")
assertMessage(testPath(testPath5 .. "/a/b/c", {slice = {slice = "1:-1", condition = {_contains = "a"}}}), true)
delete(testPath5, "any", "delete", "any")

-- Test 6: Test sliceTest with multiple slices
local testPath6 = tempDir .. "/testPath6_" .. tostring(os.time())
createPath(testPath6 .. "/x/y/z")
local testSlices = {{"1:2", {_contains = "x"}}, {"2:3", {_contains = "y"}}, {"3", {_contains = "z"}}}
assertMessage(testPath(testPath6 .. "/x/y/z", {slice = testSlices}), true)
delete(testPath6, "any", "delete", "any")

-- Test 7: Test sliceTest with sliceOpts
local testPath7 = tempDir .. "/testPath7_" .. tostring(os.time())
createPath(testPath7 .. "/a/b/c")
local testSliceOpts = {rejoin_at_end = true}
assertMessage(testPath(testPath7 .. "/a/b/c", {slice = {slice = "1:-1", condition = {_contains = "a"}, sliceOpts = testSliceOpts}}), true)
delete(testPath7, "any", "delete", "any")

-- Test 1: Basic existence test (remote)
local tempDirRemote = env.HSFTP_TMPDIR
local testPath1Remote = tempDirRemote .. "/testPath1_" .. tostring(os.time())
createPath(testPath1Remote)
assertMessage(testPath(testPath1Remote, {existence = true}), true)
delete(testPath1Remote, "any", "delete", "any")

-- Test 2: Basic non-existence test (remote)
local testPath2Remote = tempDirRemote .. "/testPath2_" .. tostring(os.time())
assertMessage(testPath(testPath2Remote, {existence = false}), true)

-- Test 3: Test dirness (remote)
local testPath3Remote = tempDirRemote .. "/testPath3_" .. tostring(os.time())
createPath(testPath3Remote)
assertMessage(testPath(testPath3Remote, {dirness = "dir"}), true)
delete(testPath3Remote, "any", "delete", "any")

-- Test 4: Test existenceTest with contents condition (remote)
local testPath4Remote = tempDirRemote .. "/testPath4_" .. tostring(os.time())
createPath(testPath4Remote)
writeFile(testPath4Remote .. "/file.txt", "sample content", "any", true, "w")
assertMessage(testPath(testPath4Remote, {existence = {exists = true, contents = {_contains = "sample content"}}}), true)
delete(testPath4Remote, "any", "delete", "any")

-- Test 5: Test sliceTest with single slice (remote)
local testPath5Remote = tempDirRemote .. "/testPath5_" .. tostring(os.time())
createPath(testPath5Remote .. "/a/b/c")
assertMessage(testPath(testPath5Remote .. "/a/b/c", {slice = {slice = "1:-1", condition = {_contains = "a"}}}), true)
delete(testPath5Remote, "any", "delete", "any")

-- Test 6: Test sliceTest with multiple slices (remote)
local testPath6Remote = tempDirRemote .. "/testPath6_" .. tostring(os.time())
createPath(testPath6Remote .. "/x/y/z")
local testSlicesRemote = {{"1:2", {_contains = "x"}}, {"2:3", {_contains = "y"}}, {"3", {_contains = "z"}}}
assertMessage(testPath(testPath6Remote .. "/x/y/z", {slice = testSlicesRemote}), true)
delete(testPath6Remote, "any", "delete", "any")

-- Test 7: Test sliceTest with sliceOpts (remote)
local testPath7Remote = tempDirRemote .. "/testPath7_" .. tostring(os.time())
createPath(testPath7Remote .. "/a/b/c")
local testSliceOptsRemote = {rejoin_at_end = true}
assertMessage(testPath(testPath7Remote .. "/a/b/c", {slice = {slice = "1:-1", condition = {_contains = "a"}, sliceOpts = testSliceOptsRemote}}), true)
delete(testPath7Remote, "any", "delete", "any")
