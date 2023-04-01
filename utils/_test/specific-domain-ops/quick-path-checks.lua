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
assertMessage(isGitRootDir(env.MENV), true)
assertMessage(isGitRootDir(env.DESKTOP), false)