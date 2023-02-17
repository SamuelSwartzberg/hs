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

deleteFile(unique_temp_file)

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