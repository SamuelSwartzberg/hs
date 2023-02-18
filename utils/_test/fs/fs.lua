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
  dirIsEmpty("/Applications"),
  false
)

assertMessage(
  dirIsEmpty("/Library/User Pictures/sam"), -- this may not always be empty, but it is on my machine. if it changes, I'll have to find a new example
  true
)

--- all in path 
assertValuesContain(
  getAllInPath(env.HOME),
  { env.HOME .. "/Desktop", env.HOME .. "/.profile" }
)

--- all in path, exclude dirs
assertValuesContain(
  getAllInPath(env.HOME, false, false, true),
  { env.HOME .. "/.profile" }
)

--- all in path, exclude files
assertValuesContain(
  getAllInPath(env.HOME, false, true, false),
  { env.HOME .. "/Desktop" }
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

createDir(temp_subdir_1_path)

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