assertMessage(
  resolveTilde("~"),
  env.HOME
)

assertMessage(
  resolveTilde("~/foo/bar"),
  env.HOME .. "/foo/bar"
)

assertMessage(
  resolveTilde("/~/foo/bar"),
  "/~/foo/bar"
)

assertMessage(
  pathIsRemote("/Applications"),
  false
)

assertMessage(
  pathIsRemote("foo:/bar"),
  true
)

assertMessage(
  pathExists("/Applications"),
  true
)

local remote_dir_path = env.MB_WEBDAV_TMPDIR .. "/foo/bar"

createPath(remote_dir_path)

assertMessage(
  pathExists(remote_dir_path),
  true
)

assertMessage(
  isDir("/Applications"),
  true
)

assertMessage(
  isDir("/Applications/"),
  true
)

assertMessage(
  isDir("/nonextant"),
  false
)

assertMessage(
  isDir(env.ENVFILE),
  false
)

assertMessage(
  isDir("/"),
  true
)

assertMessage(
  isDir(remote_dir_path),
  true
)

local remote_file_path = env.MB_WEBDAV_TMPDIR .. "/foo/bar/baz.txt"

writeFile(remote_file_path, "hello world", "any", true)

assertMessage(
  readFile(remote_file_path),
  "hello world"
)

assertMessage(
  isDir(remote_file_path),
  false
)

assertMessage(
  dirIsEmpty("/Applications"),
  false
)

assertMessage(
  dirIsEmpty(remote_dir_path),
  false
)

delete(remote_file_path)

assertMessage(
  dirIsEmpty(remote_dir_path),
  true
)

assertMessage(
  dirIsEmpty("/Library/User Pictures/sam"), -- this may not always be empty, but it is on my machine. if it changes, I'll have to find a new example
  true
)

writeFile(env.MB_WEBDAV_TMPDIR .. "/foo/test1.txt", "hello world", "any", true)
writeFile(env.MB_WEBDAV_TMPDIR .. "/foo/test2.txt", "hello world", "any", true)

--- all in path 

assertValuesContain(
  getAllInPath(env.HOME),
  { env.HOME .. "/Desktop", env.HOME .. "/.profile" }
)

--- same but remote

assertValuesContainExactly(
  getAllInPath(env.MB_WEBDAV_TMPDIR .. "/foo"),
  { 
    env.MB_WEBDAV_TMPDIR .. "/foo/test1.txt", 
    env.MB_WEBDAV_TMPDIR .. "/foo/test2.txt",
    env.MB_WEBDAV_TMPDIR .. "/foo/bar"
  }
)

--- all in path, exclude dirs
assertValuesContain(
  getAllInPath(env.HOME, false, false, true),
  { env.HOME .. "/.profile" }
)

--- same but remote
assertValuesContainExactly(
  getAllInPath(env.MB_WEBDAV_TMPDIR .. "/foo", false, false, true),
  { 
    env.MB_WEBDAV_TMPDIR .. "/foo/test1.txt", 
    env.MB_WEBDAV_TMPDIR .. "/foo/test2.txt"
  }
)

--- all in path, exclude files
assertValuesContain(
  getAllInPath(env.HOME, false, true, false),
  { env.HOME .. "/Desktop" }
)

--- same but remote
assertValuesContainExactly(
  getAllInPath(env.MB_WEBDAV_TMPDIR .. "/foo", false, true, false),
  { 
    env.MB_WEBDAV_TMPDIR .. "/foo/bar"
  }
)

--- all in path, don't search recursively
assertValuesNotContain(
  getAllInPath("/", false),
  { env.HOME }
)

--- all in path, search recursively
assertValuesContain(
  getAllInPath(env.MAC_FIREFOX, true),
  { env.MAC_FIREFOX_DEFAULT_RELEASE_PROFILE }
)

--- same but remote

writeFile(env.MB_WEBDAV_TMPDIR .. "/foo/bar/new.txt", "hello world", "any", true)

assertValuesContainExactly(
  getAllInPath(env.MB_WEBDAV_TMPDIR .. "/foo", true),
  { 
    env.MB_WEBDAV_TMPDIR .. "/foo/test1.txt", 
    env.MB_WEBDAV_TMPDIR .. "/foo/test2.txt",
    env.MB_WEBDAV_TMPDIR .. "/foo/bar",
    env.MB_WEBDAV_TMPDIR .. "/foo/bar/new.txt"
  }
)

assertMessage(
  getParentPath("/foo/bar"),
  "/foo"
)

assertMessage(
  getParentPath("foo/bar"),
  "foo"
)

assertMessage(
  getGrandparentPath("/foo/bar/baz"),
  "/foo"
)

assertMessage(
  getGrandparentPath("foo/bar/baz"),
  "foo"
)

assertMessage(
  valuesContain(
    getSiblings("/", true, true),
    "/Applications"
  ),
  true
)

-- same but remote

assertMessage(
  valuesContain(
    getSiblings(env.MB_WEBDAV_TMPDIR .. "/foo", true, true),
    env.MB_WEBDAV_TMPDIR .. "/foo/test1.txt"
  ),
  true
)

delete(env.MB_WEBDAV_TMPDIR .. "/foo", "empty")

assertTable(
  getAllInPath(env.MB_WEBDAV_TMPDIR .. "/foo", true),
  {}
)

assertMessage(
  valuesContain(
    getSiblings("/", true, true),
    "/nonextant"
  ),
  false
)

--- exclude dirs
assertMessage(
  valuesContain(
    getSiblings("/", false, true),
    "/Applications"
  ),
  false
)


--- exclude files
assertMessage(
  valuesContain(
    getSiblings("/", true, false),
    "/Applications"
  ),
  true
)

--- extant file which is sibling
assertMessage(
  findInSiblingsOrAncestorSiblings(
    env.MAC_DOWNLOADS,
    "Pictures",
    true,
    true
  ),
  env.MAC_PICTURES
)


--- extant file which is ancestor sibling
assertMessage(
  findInSiblingsOrAncestorSiblings(
    env.HOME,
    "Applications",
    true,
    true
  ),
  "/Applications"
)



--- nonextant file which is sibling
assertMessage(
  findInSiblingsOrAncestorSiblings(
    env.MAC_DOWNLOADS,
    "nonextant",
    true,
    true
  ),
  nil
)


--- nonextant file which is ancestor sibling
assertMessage(
  findInSiblingsOrAncestorSiblings(
    env.HOME,
    "/nonextant",
    true,
    true
  ),
  nil
)

assertMessage(
  pathHasStartFilenameExtension(
    "/foo/bar/baz.txt",
    "/foo",
    "baz",
    "txt"
  ),
  true
)

assertMessage(
  pathHasStartFilenameExtension(
    "/foo/bar/baz.txt",
    "/foo",
    "baz",
    "jpg"
  ),
  false
)

assertMessage(
  pathHasStartFilenameExtension(
    "/foo/bar/baz.txt",
    "/foo",
    "bar",
    "txt"
  ),
  false
)

assertMessage(
  pathHasStartFilenameExtension(
    "/foo/bar/baz.txt",
    "/bar",
    "baz",
    "txt"
  ),
  false
)

local unique_temp_file = createUniqueTempFile("foo")
assertMessage(
  readFile(unique_temp_file),
  "foo"
)

delete(unique_temp_file)

assertMessage(
  readFile(unique_temp_file),
  nil
)

doWithTempFile("foo", function(tmp_file)
  assertMessage(
    readFile(tmp_file),
    "foo"
  )
end)

assertMessage(
  asAttach(env.PROFILEFILE),
  "#text/plain " .. env.PROFILEFILE
)

assertMessage(
  resolveRelativePath("/foo/bar/baz", env.HOME),
  env.HOME .. "/foo/bar/baz"
)

assertMessage(
  resolveRelativePath("/foo/bar/baz", env.HOME .. "/foo"),
  env.HOME .. "/foo/bar/baz"
)

assertMessage(
  resolveRelativePath("remote:/foo/bar/baz", env.HOME),
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
local ping_in_subdir_1_path = temp_subdir_1_path .. getLeafWithoutPath(temp_file_3_path_ping)

createPath(temp_subdir_1_path)

srctgt("copy", temp_file_3_path_ping, temp_subdir_1_path, "any", false, true)

assertMessage(
  readFile(ping_in_subdir_1_path),
  "lorem ipsum"
)

delete(temp_subdir_1_path)

assertMessage(
  pathExists(temp_subdir_1_path),
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
  pathExists(temp_subdir_1_path),
  false
)

for _, n in ipairs(seq(1, 4)) do
  writeFile( temp_subdir_1_path .. "file_" .. n .. ".txt", "lorem ipsum " .. n, "not-exists", true, "w" )
end

srctgt("link", temp_subdir_1_path, temp_subdir_1_path .. "subdir", "not-exists", false, false, true)

for _, n in ipairs(seq(1, 4)) do
  assertMessage(
    readFile( temp_subdir_1_path .. "subdir/file_" .. n .. ".txt" ),
    "lorem ipsum " .. n
  )
end

local remote_writing_file = env.MB_WEBDAV_TMPDIR .. "/foo/meep.txt"

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

local local_file = createUniqueTempFile("local-origin content")

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

srctgt("move", tmpdirdir, env.MB_WEBDAV_TMPDIR, "any", false, false, true)

assertMessage(
  readFile(env.MB_WEBDAV_TMPDIR .. "/natsume.txt"),
  "natsume"
)

assertMessage(
  readFile(env.MB_WEBDAV_TMPDIR .. "/keiko.txt"),
  "keiko"
)

