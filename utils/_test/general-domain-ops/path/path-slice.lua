-- Test 1: Basic slicing
local result1 = pathSlice("/a/b/c", ":")
assertMessage(result1, {"a", "b", "c"})

-- Test 2: Slicing with start and stop
local result2 = pathSlice("/a/b/c", "2:3")
assertMessage(result2, {"b", "c"})

-- Test 3: Slicing with step
local result3 = pathSlice("/a/b/c/d", "::2")
assertMessage(result3, {"a", "c"})

-- Test 4: Slicing with negative start
local result4 = pathSlice("/a/b/c", "-2:")
assertMessage(result4, {"b", "c"})

-- Test 5: Slicing with negative stop
local result5 = pathSlice("/a/b/c", "2:-1")
assertMessage(result5, {"b", "c"})

-- Test 6: Slicing with negative step
local result6 = pathSlice("/a/b/c/d", "4:1:-1")
assertMessage(result6, {"d", "c", "b", "a"})

-- Test 7: Slicing with extension separation
local result7 = pathSlice("/a/b/file.txt", ":", {ext_sep = true})
assertMessage(result7, {"a", "b", "file", "txt"})

-- Test 8: Slicing with standardized extension
local result8 = pathSlice("/a/b/file.yml", ":", {standartize_ext = true})
assertMessage(result8, {"a", "b", "file.yaml"})

-- Test 9: Slicing with rejoining at the end
local result9 = pathSlice("/a/b/c", ":", {rejoin_at_end = true})
assertMessage(result9, "/a/b/c")

-- Test 10: Slicing with entire path for each component
local result10 = pathSlice("/a/b/c", ":", {entire_path_for_each = true})
assertMessage(result10, {"/a", "/a/b", "/a/b/c"})