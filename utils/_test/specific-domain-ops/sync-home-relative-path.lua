if mode == "full-test" then 
  -- Test 1: Push local file to remote
do
  local timestamp = tostring(os.time())
  local dirname = "/test_push_local_" .. timestamp
  local localPath = env.TMPDIR .. dirname
  local localFile = localPath .. "/file1.txt"
  local remotePath = remote(localPath)
  local remoteFile = remote(localFile)
  writeFile(localFile, "This is a test file.", true)

  syncHomeRelativePath(".tmp" .. dirname, "push", nil, true) -- 3rd param should default to "copy"

  local remoteFileContents = transf.file.contents(remoteFile, "error")
  assertMessage(remoteFileContents, "This is a test file.")

  dothis.absolute_path.delete_dir
  dothis.absolute_path.delete_dir
end

-- Test 2: Pull remote file to local
do
  local timestamp = tostring(os.time())
  local dirname = "/test_push_local_" .. timestamp
  local localPath = env.TMPDIR .. dirname
  local localFile = localPath .. "/file2.txt"
  local remotePath = remote(localPath)
  local remoteFile = remote(localFile)
  writeFile(remoteFile, "This is another test file.", true)
  syncHomeRelativePath(".tmp" .. dirname, "pull", "copy", true)

  local localFileContents = transf.file.contents(localFile, "error")
  assertMessage(localFileContents, "This is another test file.")

  dothis.absolute_path.delete_dir
  dothis.absolute_path.delete_dir
end

-- Test 3: Push local directory to remote using "move" action
do
  local timestamp = tostring(os.time())
  local dirname = "/test_push_local_" .. timestamp
  local localPath = env.TMPDIR .. dirname
  local localFile = localPath .. "/file3.txt"
  local remotePath = remote(localPath)
  local remoteFile = remote(localFile)
  writeFile(localFile, "This is a test file for move action.", true)
  syncHomeRelativePath(".tmp" .. dirname, "push", "move", true)

  local remoteFileContents = transf.file.contents(remoteFile, "error")
  assertMessage(remoteFileContents, "This is a test file for move action.")
  assertMessage(is.path.extant_path(localFile), false)

  dothis.absolute_path.delete_dir
  dothis.absolute_path.delete_dir
end

-- Test 4: Invalid push_or_pull parameter
do
  local success, errorMessage = pcall(syncHomeRelativePath, ".tmp/test_invalid_param", "invalid")
  assertMessage(errorMessage, "push_or_pull must be 'push' or 'pull'")
end
else
  print("skipping...")
end