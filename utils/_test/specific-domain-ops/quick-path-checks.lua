-- Test looksLikePath
assertMessage(looksLikePath("test/path"), true)
assertMessage(looksLikePath("test/path/"), true)
assertMessage(looksLikePath("/test/path"), true)
assertMessage(looksLikePath("  test/path"), false)
assertMessage(looksLikePath("test/path  "), false)
assertMessage(looksLikePath("test\n/path"), false)
assertMessage(looksLikePath("test\t/path"), false)
assertMessage(looksLikePath("test\r/path"), false)
assertMessage(looksLikePath("test\f/path"), false)

-- Test pathIsRemote
assertMessage(pathIsRemote("http://example.com/test.git"), true)
assertMessage(pathIsRemote("https://example.com/test.git"), true)
assertMessage(pathIsRemote("git@example.com:test.git"), true)
assertMessage(pathIsRemote("ftp://example.com/test.git"), true)
assertMessage(pathIsRemote("test.git"), false)
assertMessage(pathIsRemote("example.com/test.git"), false)
assertMessage(pathIsRemote("test/path/test.git"), false)

-- Test isGitRootDir
-- Prepare a simple helper function to mock itemsInPath
function mockItemsInPath(nonGitPath)
  return function(path)
    if path == "gitRootDir" then
      return {"file1", "file2", ".git"}
    elseif path == "nonGitRootDir" then
      return {"file1", "file2"}
    else
      return nonGitPath or {}
    end
  end
end

local originalItemsInPath = itemsInPath
itemsInPath = mockItemsInPath()

assertMessage(isGitRootDir("gitRootDir"), true)
assertMessage(isGitRootDir("nonGitRootDir"), false)

-- Restore the original itemsInPath function
itemsInPath = originalItemsInPath