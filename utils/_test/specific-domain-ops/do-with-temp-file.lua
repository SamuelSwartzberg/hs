-- Test 1: Check if the temporary file is created with a random name when no path is provided
local test1FileContents = "Test file contents"
doWithTempFile({ contents = test1FileContents }, function(tmp_file)
  local fileContents = readFile(tmp_file)
  assertMessage(fileContents, test1FileContents, "Test 1 failed: Temporary file should have the provided contents")
end)

-- Test 2: Check if the temporary file is created with a specific path when provided
local test2FileName = env.TMPDIR .. "/temp_" .. tostring(os.time()) .. ".txt"
local test2FileContents = "Test 2 file contents"
doWithTempFile({ path = test2FileName, contents = test2FileContents }, function(tmp_file)
  local fileContents = readFile(tmp_file)
  assertMessage(fileContents, test2FileContents, "Test 2 failed: Temporary file should have the provided contents")
end)

-- Test 3: Check if use_contents option returns the contents of the file instead of the path
local test3FileContents = "Test 3 file contents"
doWithTempFile({ contents = test3FileContents, use_contents = true }, function(contents)
  assertMessage(contents, test3FileContents, "Test 3 failed: Function should receive the contents of the file")
end)

-- Test 4: Check if the temporary file is deleted after the do_this function is executed
local test4FileName = env.TMPDIR .. "/temp_" .. tostring(os.time()) .. ".txt"
local test4FileContents = "Test 4 file contents"
doWithTempFile({ path = test4FileName, contents = test4FileContents }, function(tmp_file)
  local fileExists = writeFile(test4FileName, nil, "exists")
  assertMessage(fileExists, nil, "Test 4 failed: Temporary file should be deleted after the do_this function")
end)
