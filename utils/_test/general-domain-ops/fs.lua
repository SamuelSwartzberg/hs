if mode == "full-test" then

delete(env.HSFTP_TMPDIR .. "/foo/")



assertMessage(
  pathIsRemote("/Applications"),
  false
)

assertMessage(
  pathIsRemote("foo:/bar"),
  true
)

assertMessage(
  testPath("/Applications"),
  true
)

local remote_dir_path = env.HSFTP_TMPDIR .. "/foo/bar"

createPath(remote_dir_path)

assertMessage(
  testPath(remote_dir_path),
  true
)

assertMessage(
  testPath("/Applications", "dir"),
  true
)

assertMessage(
  testPath("/Applications/", "dir"),
  true
)

assertMessage(
  testPath("/nonextant", "dir"),
  false
)

assertMessage(
  testPath(env.ENVFILE, "dir"),
  false
)

assertMessage(
  testPath("/", "dir"),
  true
)

assertMessage(
  testPath(remote_dir_path, "dir"),
  true
)

local remote_file_path = env.HSFTP_TMPDIR .. "/foo/bar/baz.txt"



writeFile(remote_file_path, "hello world", "any", true)

assertMessage(
  readFile(remote_file_path),
  "hello world"
)

assertMessage(
  testPath(remote_file_path, "dir"),
  false
)

assertMessage(
  testPath("/Applications", {
    existence = {
      dirness = "dir",
      contents = true
    }
  }),
  true
)

assertMessage(
  testPath(remote_file_path, {
    existence = {
      dirness = "not-dir",
      contents = "hello world"
    }
  })
)

delete(remote_file_path)


assertMessage(
  testPath(remote_dir_path, {
    existence = {
      dirness = "dir",
      contents = false
    }
  })
)

assertMessage(
  testPath("/Library/User Pictures/sam",{
    existence = {
      dirness = "dir",
      contents = false
    }
  }),
  true
)

writeFile(env.HSFTP_TMPDIR .. "/foo/test1.txt", "hello world", "any", true)
writeFile(env.HSFTP_TMPDIR .. "/foo/test2.txt", "hello world", "any", true)

--- all in path 

assertValuesContain(
  itemsInPath(env.HOME),
  { env.HOME .. "/Desktop", env.HOME .. "/.profile" }
)

--- same but remote

assertMessage(
  itemsInPath(env.HSFTP_TMPDIR .. "/foo"),
  { 
    env.HSFTP_TMPDIR .. "/foo/test1.txt", 
    env.HSFTP_TMPDIR .. "/foo/test2.txt",
    env.HSFTP_TMPDIR .. "/foo/bar"
  }
)

--- all in path, exclude dirs
assertValuesContain(
  itemsInPath({path = env.HOME, include_dirs = false}),
  { env.HOME .. "/.profile" }
)

--- same but remote
assertMessage(
  itemsInPath({path = env.HSFTP_TMPDIR .. "/foo", include_dirs = false}),
  { 
    env.HSFTP_TMPDIR .. "/foo/test1.txt", 
    env.HSFTP_TMPDIR .. "/foo/test2.txt"
  }
)

--- all in path, exclude files
assertValuesContain(
  itemsInPath({path = env.HOME, include_files = false}),
  { env.HOME .. "/Desktop" }
)

--- same but remote
assertMessage(
  itemsInPath({path = env.HSFTP_TMPDIR .. "/foo", include_files = false}),
  { 
    env.HSFTP_TMPDIR .. "/foo/bar"
  }
)

--- all in path, don't search recursively
assertValuesNotContain(
  itemsInPath({path = "/", recursion = false}),
  { env.HOME }
)

writeFile(env.TMPDIR .. "/ff/rr/bb.txt", "hello world", "any", true)

--- all in path, search recursively
assertValuesContain(
  itemsInPath({path = env.TMPDIR .. "/ff", recursion = true}),
  { env.TMPDIR .. "/ff/rr/bb.txt" }
)

delete(env.TMPDIR .. "/ff")

--- same but remote

writeFile(env.HSFTP_TMPDIR .. "/foo/bar/new.txt", "hello world", "any", true)


assertMessage(
  itemsInPath({path = env.HSFTP_TMPDIR .. "/foo", recursion = true}),
  { 
    env.HSFTP_TMPDIR .. "/foo/test1.txt", 
    env.HSFTP_TMPDIR .. "/foo/test2.txt",
    env.HSFTP_TMPDIR .. "/foo/bar",
    env.HSFTP_TMPDIR .. "/foo/bar/new.txt"
  }
)



assertValuesContain(
  getItemsForAllLevelsInSlice("/", { start = -2, stop = -2 }  ),
  {"/Applications"}
  
)

-- same but remote



assertValuesContain(
  getItemsForAllLevelsInSlice(env.HSFTP_TMPDIR .. "/foo/bar", "-2:-2"),
  {env.HSFTP_TMPDIR .. "/foo/test1.txt"}
)

delete(env.HSFTP_TMPDIR .. "/foo", "dir", "empty")

assertMessage(
  itemsInPath({path = env.HSFTP_TMPDIR .. "/foo", recursion = true}),
  {}
)

assertMessage(
  find(
    getItemsForAllLevelsInSlice("/", { start = -2, stop = -2 }  )
    "/nonextant"
  ),
  false
)

--- exclude dirs
assertMessage(
  find(
    getItemsForAllLevelsInSlice('/', { start = -2, stop = -2 }, {include_dirs = false}  ),
    "/Applications"
  ),
  false
)


--- exclude files
assertMessage(
  find(
    getItemsForAllLevelsInSlice('/', { start = -2, stop = -2 }, {include_files = false}  ),
    "/Applications"
  ),
  true
)


local unique_temp_file = writeFile(nil, "foo")
assertMessage(
  readFile(unique_temp_file),
  "foo"
)

delete(unique_temp_file)

assertMessage(
  readFile(unique_temp_file),
  nil
)

doWithTempFile({contents = "foo"}, function(tmp_file)
  assertMessage(
    readFile(tmp_file),
    "foo"
  )
end)

assertMessage(
  transf.path.attachment(env.PROFILEFILE),
  "#text/plain " .. env.PROFILEFILE
)

assertMessage(
  resolve({s = { path = "/foo/bar/baz", root = env.HOME} }),
  env.HOME .. "/foo/bar/baz"
)

assertMessage(
  resolve({s = { path = "/foo/bar/baz", root = env.HOME, prefix = "remote:"} }),
  "remote:" .. env.HOME .. "/foo/bar/baz"
)

local temp_file_1_path = env.TMPDIR .. "/temp_file_lua_test_" .. os.time() .. ".txt"

writeFile(temp_file_1_path, "foo", "any", false, "w")

assertMessage(
  readFile(temp_file_1_path),
  "foo"
)

writeFile(temp_file_1_path, "bar", "any", false, "w")

assertMessage(
  readFile(temp_file_1_path),
  "bar"
)

writeFile(temp_file_1_path, "baz", "any", false, "a")

assertMessage(
  readFile(temp_file_1_path),
  "barbaz"
)

writeFile(temp_file_1_path, "qux", "not-exists", false, "w")

assertMessage(
  readFile(temp_file_1_path),
  "barbaz"
)

delete(temp_file_1_path)

writeFile(temp_file_1_path, "qux", "not-exists", false, "w")

assertMessage(
  readFile(temp_file_1_path),
  "qux"
)

writeFile(temp_file_1_path, "moop", "exists", false, "w")

assertMessage(
  readFile(temp_file_1_path),
  "moop"
)

delete(temp_file_1_path)
writeFile(temp_file_1_path, "moop", "exists", false, "w")

assertMessage(
  readFile(temp_file_1_path),
  nil
)


local temp_file_2_path = env.TMPDIR .. "/temp_file_lua_test_" .. os.time() .. "/file.txt"

writeFile(temp_file_2_path, "meip", "any", false, "w")

assertMessage(
  readFile(temp_file_2_path),
  nil
)

writeFile(temp_file_2_path, "meip", "any", true, "w")

assertMessage(
  readFile(temp_file_2_path),
  "meip"
)

delete(temp_file_2_path, "dir")

assertMessage(
  readFile(temp_file_2_path),
  "meip"
)

delete(temp_file_2_path, "file")

assertMessage(
  readFile(temp_file_2_path),
  nil
)

local temp_file_3_path_ping = env.TMPDIR .. "/temp_file_lua_test_ping" .. os.time() .. ".txt"
local temp_file_3_path_pong = env.TMPDIR .. "/temp_file_lua_test_pong" .. os.time() .. ".txt"

writeFile(temp_file_3_path_ping, "lorem ipsum")

srctgt("copy", temp_file_3_path_ping, temp_file_3_path_pong)

assertMessage(
  readFile(temp_file_3_path_pong),
  "lorem ipsum"
)

delete(temp_file_3_path_ping)

srctgt("move", temp_file_3_path_pong, temp_file_3_path_ping)

assertMessage(
  readFile(temp_file_3_path_ping),
  "lorem ipsum"
)

assertMessage(
  readFile(temp_file_3_path_pong),
  nil
)

srctgt("link", temp_file_3_path_ping, temp_file_3_path_pong)

assertMessage(
  readFile(temp_file_3_path_pong),
  "lorem ipsum"
)

assertMessage(
  readFile(temp_file_3_path_ping),
  "lorem ipsum"
)

delete(temp_file_3_path_pong)

local temp_subdir_1_path = env.TMPDIR .. "/temp_subdir_lua_test_" .. os.time() .. "/"
local ping_in_subdir_1_path = temp_subdir_1_path .. pathSlice(temp_file_3_path_ping, "-1:-1")[1]

createPath(temp_subdir_1_path)

srctgt("copy", temp_file_3_path_ping, temp_subdir_1_path, "any", false, true)

assertMessage(
  readFile(ping_in_subdir_1_path),
  "lorem ipsum"
)

delete(temp_subdir_1_path)

assertMessage(
  testPath(temp_subdir_1_path),
  false
)

srctgt("link", temp_file_3_path_ping, ping_in_subdir_1_path, "any", true)

assertMessage(
  readFile(ping_in_subdir_1_path),
  "lorem ipsum"
)

local delres = delete(temp_subdir_1_path, "any", "delete", "empty")

assertMessage(
  delres,
  false
)

local emptyres = delete(temp_subdir_1_path, "any", "empty")

assertMessage(
  emptyres,
  true
)
delres = delete(temp_subdir_1_path, "any", "delete", "empty")

assertMessage(
  delres,
  true
)

assertMessage(
  testPath(temp_subdir_1_path),
  false
)

for _, n in iprs(seq(1, 4)) do
  writeFile( temp_subdir_1_path .. "file_" .. n .. ".txt", "lorem ipsum " .. n, "not-exists", true, "w" )
end

srctgt("link", temp_subdir_1_path, temp_subdir_1_path .. "subdir", "not-exists", false, false, true)

for _, n in iprs(seq(1, 4)) do
  assertMessage(
    readFile( temp_subdir_1_path .. "subdir/file_" .. n .. ".txt" ),
    "lorem ipsum " .. n
  )
end

local remote_writing_file = env.HSFTP_TMPDIR .. "/foo/meep.txt"

writeFile(remote_writing_file, "bar", "exists", false, "w")

assertMessage(
  readFile(remote_writing_file),
  nil
)

writeFile(remote_writing_file, "bar", "not-exists", false, "w")

assertMessage(
  readFile(remote_writing_file),
  "bar"
)

writeFile(remote_writing_file, "baz", "any", false, "a")

assertMessage(
  readFile(remote_writing_file),
  "barbaz"
)

local local_file = writeFile(nil, "local-origin content")

srctgt("copy", local_file, remote_writing_file, "not-exists")

assertMessage(
  readFile(remote_writing_file),
  "barbaz"
)

srctgt("copy", local_file, remote_writing_file, "exists")

assertMessage(
  readFile(remote_writing_file),
  "local-origin content"
)

writeFile(local_file, "local-origin content 2")
srctgt("move", local_file, remote_writing_file, "any")

assertMessage(
  readFile(remote_writing_file),
  "local-origin content 2"
)

assertMessage(
  readFile(local_file),
  nil
)

srctgt("copy", remote_writing_file, env.TMPDIR, "any", false, true)

assertMessage(
  readFile(env.TMPDIR .. "/meep.txt"),
  "local-origin content 2"
)

local tmpdirdir = env.TMPDIR .. "/testdir" .. os.time()

writeFile(tmpdirdir .. "/natsume.txt", "natsume")
writeFile(tmpdirdir .. "/keiko.txt", "keiko")

srctgt("move", tmpdirdir, env.HSFTP_TMPDIR, "any", false, false, true)

assertMessage(
  readFile(env.HSFTP_TMPDIR .. "/natsume.txt"),
  "natsume"
)

assertMessage(
  readFile(env.HSFTP_TMPDIR .. "/keiko.txt"),
  "keiko"
)

delete(env.HSFTP_TMPDIR .. "/natsume.txt")
delete(env.HSFTP_TMPDIR .. "/keiko.txt")

createPath(
  env.TMPDIR .. "/" .. os.time() .. "/foo/bar/baz",
  ":-4"
)

assertMessage(
  testPath(env.TMPDIR .. "/" .. os.time()),
  true
)

assertMessage(
  testPath(env.TMPDIR .. "/" .. os.time() .. "/foo"),
  false
)


writeFile(env.TMPDIR .. "/delete-if-notempty/" .. os.time() .. ".txt", "lorem ipsum", "any", true)


delete(env.TMPDIR .. "/delete-if-notempty", "any", "delete", "empty")

assertMessage(
  testPath(env.TMPDIR .. "/delete-if-notempty"),
  true
)

delete(env.TMPDIR .. "/delete-if-notempty", "any", "delete", "not-empty")

assertMessage(
  testPath(env.TMPDIR .. "/delete-if-notempty"),
  false
)

local succ, res = pcall(
  readFile,
  "/this/path/does/not/exist",
  "nil"
)

assertMessage(
  succ,
  true
)

assertMessage(
  res,
  nil
)

local succ, res = pcall(
  readFile,
  "/this/path/does/not/exist",
  "error"
)

assertMessage(
  succ,
  false
)

assertValuesContain(
  itemsInPath({
    path = env.MAC_LIBRARY,
    slice_results = "-1:-1"
  }),
  {
    "Containers",
    "Cache"
  }
)

assertMessage(
  itemsInPath({
    path = env.MAC_LIBRARY,
    slice_results = "-2:-1",
    slice_results_opts = {
      rejoin_at_end = false
    }
  }),
  {
    {"Library", "Containers"},
    {"Library", "Cache"}
  }
)

assertMessage(
  itemsInPath({
    path = env.MAC_LIBRARY,
    validator_result = function(res)
      return res == env.MAC_LIBRARY .. "/Containers"
    end
  }),
  {
    env.MAC_LIBRARY .. "/Containers"
  }
)

local fstree_test_dir = env.TMPDIR .. "/fstree-" .. os.time() .. "/"

writeFile(fstree_test_dir .. "foo.txt", "gg ez", "any", true)
writeFile(fstree_test_dir .. "abee.json", "{'a': 'b'}", "any", true)
createPath(fstree_test_dir .. "bar/baz")
writeFile(fstree_test_dir .. "bar/rei.yaml", "kore: ha\nchoco: desu\n", "any", true)
writeFile(fstree_test_dir .. "bar/murloc.txt", "mrgl mrgl", "any", true)

assertMessage(
  fsTree(fstree_test_dir, "read"),
  {
    foo = "gg ez",
    abee = "{'a': 'b'}",
    bar = {
      baz = {},
      rei = "kore: ha\nchoco: desu\n",
      murloc = "mrgl mrgl"
    }
  }
)

assertMessage(
  fsTree(fstree_test_dir, "as-tree"),
  {
    abee = {
      a = "b"
    },
    bar = {
      baz = {},
      rei = {
        choco = "desu",
        kore = "ha"
      }
    },
  }
)

assertMessage(
  fsTree(fstree_test_dir, "as-tree", {'yaml'}),
  {
    bar = {
      rei = {
        choco = "desu",
        kore = "ha"
      }
    },
  }
)

assertMessage(
  fsTree(fstree_test_dir, "as-tree", {'json'}),
  {
    abee = {
      a = "b"
    },
  }
)

delete(fstree_test_dir .. "bar/baz")
srctgt("move", fstree_test_dir .. "foo.txt", fstree_test_dir .. "inner", nil, true, true)
srctgt("move", fstree_test_dir .. "abee.json", fstree_test_dir .. "inner", nil, true, true)
createPath(fstree_test_dir .. "sore/are")

assertMessage(
  fsTree(fstree_test_dir, "append"),
  {
    inner = {
      fstree_test_dir .. "/inner/foo.txt",
      fstree_test_dir .. "/inner/abee.json"
    },
    sore = {
      are = {}
    },
    bar = {
      fstree_test_dir .. "/bar/rei.yaml",
      fstree_test_dir .. "/bar/murloc.txt"
    }
  }
)

end

