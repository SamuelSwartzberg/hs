if mode=="full-test" then
  -- Test 1: Basic existence test
  local tempDir = env.TMPDIR
  local testPath1 = tempDir .. "/testPath1_" .. tostring(os.time())
  dothis.absolute_path.create_dir(testPath1)
  assertMessage(testPath(testPath1, {exists = true}), true)
  dothis.absolute_path.delete(testPath1)

  -- Test 2: Basic non-existence test
  local testPath2 = tempDir .. "/testPath2_" .. tostring(os.time())
  assertMessage(testPath(testPath2, false), true)

  -- Test 3a: Test dirness
  local testPath3 = tempDir .. "/testPath3_" .. tostring(os.time())
  dothis.absolute_path.create_dir(testPath3)
  assertMessage(testPath(testPath3, "dir"), true)
  dothis.absolute_path.delete(testPath3)

  -- Test 3b: Test dirness
  local testPath3 = tempDir .. "/testPath3_" .. tostring(os.time())
  dothis.absolute_path.create_dir(testPath3)
  assertMessage(testPath(testPath3, {dirness = "dir"}), true)
  dothis.absolute_path.delete(testPath3)

  -- Test 4: Test existenceTest with contents condition
  local testPath4 = tempDir .. "/testPath4_" .. tostring(os.time())
  dothis.absolute_path.create_dir(testPath4)
  writeFile(testPath4 .. "/file.txt", "sample content", "any", true, "w")
  assertMessage(testPath(testPath4 .. "/file.txt", {exists = true, contents = {_contains = "sample content"}}), true)
  dothis.absolute_path.delete(testPath4)

  -- Test 1: Basic existence test (remote)
  local tempDirRemote = env.HSFTP_TMPDIR
  local testPath1Remote = tempDirRemote .. "/testPath1_" .. tostring(os.time())
  dothis.absolute_path.create_dir(testPath1Remote)
  assertMessage(testPath(testPath1Remote, true), true)
  dothis.absolute_path.delete(testPath1Remote)

  -- Test 2: Basic non-existence test (remote)
  local testPath2Remote = tempDirRemote .. "/testPath2_" .. tostring(os.time())
  assertMessage(testPath(testPath2Remote, false), true)

  -- Test 3: Test dirness (remote)
  local testPath3Remote = tempDirRemote .. "/testPath3_" .. tostring(os.time())
  dothis.absolute_path.create_dir(testPath3Remote)
  assertMessage(testPath(testPath3Remote, {dirness = "dir"}), true)
  dothis.absolute_path.delete(testPath3Remote)

  -- Test 4: Test existenceTest with contents condition (remote)
  local testPath4Remote = tempDirRemote .. "/testPath4_" .. tostring(os.time())
  dothis.absolute_path.create_dir(testPath4Remote)
  writeFile(testPath4Remote .. "/file.txt", "sample content", "any", true, "w")
  assertMessage(testPath(testPath4Remote .. "/file.txt", {exists = true, contents = {_contains = "sample content"}}), true)
  dothis.absolute_path.delete(testPath4Remote)


  assertMessage(
    pathSlice("/a/b/c", "-1:-1", {rejoin_at_end=true}),
    "c" -- this is to expose a bug that would cause this to return "/c", falsely readding the leading slash even though c was not the first element of the path
  )

  assertMessage(
    pathSlice("/a/b/a", "-1:-1", {rejoin_at_end=true}),
    "a" -- aggravated case of the above bug
  )

  -- test empty dir

  -- success case

  local emptyDir = tempDir .. "/emptyDir_" .. tostring(os.time())
  dothis.absolute_path.create_dir(emptyDir)
  assert(
    testPath(emptyDir, {dirness = "dir", contents = false})
  )

  -- fail case: does not exist

  local nonExtantDir = tempDir .. "/nonExtantDir_" .. tostring(os.time())
  assertMessage(
    testPath(nonExtantDir, {dirness = "dir", contents = false}),
    false
  )

  -- fail case: not a dir

  local nonDir = tempDir .. "/nonDir_" .. tostring(os.time())

  writeFile(nonDir, "sample content", "any", true, "w")

  assertMessage(
    testPath(nonDir, {dirness = "dir", contents = false}),
    false
  )

  delete(nonDir, "any", "delete", "error")

  -- fail case: not empty

  local nonEmptyDir = tempDir .. "/nonEmptyDir_" .. tostring(os.time())

  dothis.absolute_path.create_dir(nonEmptyDir)
  writeFile(nonEmptyDir .. "/file.txt", "sample content", "any", true, "w")

  assertMessage(
    testPath(nonEmptyDir, {dirness = "dir", contents = false}),
    false
  )
else
  print("skipping...")
end