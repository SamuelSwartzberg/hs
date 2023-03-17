-- Test 1: Push local file to remote
do
  local timestamp = tostring(os.time())
  local localPath = env.TMPDIR .. "/test_push_local_" .. timestamp
  local remotePath = env.HSFTP_TMPDIR .. "/test_push_remote_" .. timestamp
  createPath(localPath)
  writeFile(localPath .. "/file1.txt", "This is a test file.")
  syncHomeRelativePath(".tmp/test_push_local_" .. timestamp, "push")

  local remoteFileContents = readFile(remote("/.tmp/test_push_remote_" .. timestamp .. "/file1.txt"))
  assertMessage(remoteFileContents, "This is a test file.")

  delete(localPath, "dir", "delete", "any")
  delete(remotePath, "dir", "delete", "any")
end

-- Test 2: Pull remote file to local
do
  local timestamp = tostring(os.time())
  local localPath = env.TMPDIR .. "/test_pull_local_" .. timestamp
  local remotePath = env.HSFTP_TMPDIR .. "/test_pull_remote_" .. timestamp
  createPath(remotePath)
  writeFile(remotePath .. "/file2.txt", "This is another test file.")
  syncHomeRelativePath(".tmp/test_pull_remote_" .. timestamp, "pull")

  local localFileContents = readFile(resolve("/.tmp/test_pull_local_" .. timestamp .. "/file2.txt"))
  assertMessage(localFileContents, "This is another test file.")

  delete(localPath, "dir", "delete", "any")
  delete(remotePath, "dir", "delete", "any")
end

-- Test 3: Push local directory to remote using "move" action
do
  local timestamp = tostring(os.time())
  local localPath = env.TMPDIR .. "/test_move_push_local_" .. timestamp
  local remotePath = env.HSFTP_TMPDIR .. "/test_move_push_remote_" .. timestamp
  createPath(localPath)
  writeFile(localPath .. "/file3.txt", "This is a test file for move action.")
  syncHomeRelativePath(".tmp/test_move_push_local_" .. timestamp, "push", "move")

  local remoteFileContents = readFile(remote("/.tmp/test_move_push_remote_" .. timestamp .. "/file3.txt"))
  local localFileExists = readFile(localPath .. "/file3.txt", "nil")
  assertMessage(remoteFileContents, "This is a test file for move action.")
  assertMessage(localFileExists, nil)

  delete(localPath, "dir", "delete", "any")
  delete(remotePath, "dir", "delete", "any")
end

-- Test 4: Invalid push_or_pull parameter
do
  local success, errorMessage = pcall(syncHomeRelativePath, ".tmp/test_invalid_param", "invalid")
  assertMessage(errorMessage, "push_or_pull must be 'push' or 'pull'")
end
