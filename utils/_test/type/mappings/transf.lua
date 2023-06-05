
assertMessage(
  transf.string.tilde_resolved("~"),
  env.HOME
)

assertMessage(
  transf.string.tilde_resolved("~/foo/bar"),
  env.HOME .. "/foo/bar"
)

assertMessage(
  transf.string.tilde_resolved("/~/foo/bar"),
  "/~/foo/bar"
)

assertMessage(
  transf.string.path_resolved("~/foo/bar", true),
  env.HOME .. "/foo/bar"
)

assertMessage(
  transf.string.path_resolved("~/foo/bar", false),
  "~/foo/bar"
)

assertMessage(
  transf.string.path_resolved("/usr/./bin"),
  "/usr/bin"
)

assertMessage(
  transf.string.path_resolved("/usr/././bin"),
  "/usr/bin"
)

assertMessage(
  transf.string.path_resolved("/usr/../bin"),
  "/bin"
)

assertMessage(
  transf.string.path_resolved("/usr/../../bin"),
  "/bin"
)

assertMessage(
  transf.string.path_resolved("/usr/bin/../.."),
  "/"
)

assertMessage(
  transf.string.path_resolved("/usr/bin/././"),
  "/usr/bin"
)

assertMessage(
  transf.string.path_resolved("/./foo"),
  "/foo"
)

assertMessage(
  transf.string.path_resolved("/././usr/bin"),
  "/usr/bin"
)

assertMessage(
  transf.string.path_resolved("/../bar"),
  "/bar"
)

assertMessage(
  transf.string.path_resolved("/../../bar"),
  "/bar"
)

assertMessage(
  transf.string.path_resolved("./foo"),
  "foo"
)

assertMessage(
  transf.string.path_resolved("././foo"),
  "foo"
)

assertMessage(
  transf.string.path_resolved("../bar"),
  "../bar"
)

assertMessage(
  transf.string.path_resolved("../../bar"),
  "../../bar"
)

assertMessage(
  transf.string.path_resolved("foo/."),
  "foo"
)

assertMessage(
  transf.string.path_resolved("foo/./."),
  "foo"
)

assertMessage(
  transf.string.path_resolved("foo/.."),
  "."
)

assertMessage(
  transf.string.path_resolved("foo/../.."),
  ".."
)

assertMessage(
  transf.string.path_resolved("foo/./bar"),
  "foo/bar"
)

assertMessage(
  transf.string.path_resolved("foo/../foo"),
  "foo"
)

assertMessage(
  transf.string.path_resolved("foo/./../bar"),
  "bar"
)

assertMessage(
  transf.string.path_resolved("foo/.././bar"),
  "bar"
)


assertMessage(
  transf.hex.char("6d"),
  "m"
)

assertMessage(
  transf.char.hex("m"),
  "6D"
)

assertMessage(
  transf.char.percent("m"),
  "%6D"
)

assertMessage(
  transf.path.attachment("/Library/User Pictures/Flowers/Dahlia.tif"),
  "#image/tiff /Library/User Pictures/Flowers/Dahlia.tif"
)

assertMessage(
  transf.string.escaped_csv_field('A "beetle" is an insect, a fact which is relevant only because this is a teststring using quotes and a comma.'),
  '"A ""beetle"" is an insect, a fact which is relevant only because this is a teststring using quotes and a comma."'
)

assertMessage(
  transf.string.bits("a"),
  "01100001"
)

assertMessage(
  transf.string.hex("a"),
  "61"
)

assertMessage(
  transf.string.base64_gen("a"),
  "YQ=="
)

assertMessage(
  transf.string.base64_url("a"),
  "YQ"
)

assertMessage(
  transf.string.base32_gen("a"),
  "ME======"
)

assertMessage(
  transf.string.base32_crock("a"),
  "C4"
)

assertMessage(
  transf.word.title_case_policy("a"),
  "a"
)

assertMessage(
  transf.word.title_case_policy("tale"),
  "Tale"
)

assertMessage(
  transf.word.title_case_policy("of"),
  "of"
)

assertMessage(
  transf.word.title_case_policy("two"),
  "Two"
)

assertMessage(
  transf.word.title_case_policy("cities"),
  "Cities"
)

assertMessage(
  transf.word.title_case_policy("and"),
  "and"
)

assertMessage(
  transf.word.title_case_policy("also"),
  "Also"
)

assertMessage(
  transf.word.title_case_policy("9/11"),
  "9/11"
)

assertMessage(
  transf.word.title_case_policy("sWAG"),
  "sWAG"
)

assertMessage(
  transf.string.title_case("A tale of two cities, and also 9/11, and also sWAG"),
  "A Tale of Two Cities, and Also 9/11, and Also SWAG"
)

assertMessage(
  transf.string.title_case("A tale of two cities, and also 9/11, and sWAG also"),
  "A Tale of Two Cities, and Also 9/11, and sWAG Also"
)

assertMessage(
  transf.string.romanized("ねえ もう少しだけ で いい の"),
  "nee mou sukoshi dake de ii no"
)

assertMessage(
  transf.string.romanized_snake("ねえ もう少しだけ で いい の"),
  "nee_mou_sukoshi_dake_de_ii_no"
)

assertMessageAny(
  transf.table.url_params({foo = "bar", baz = "quux"}),
  {
    "baz=quux&foo=bar",
    "foo=bar&baz=quux"
  }
)

assertMessageAny(
  transf.table.url_params({
    foo="I am a cat", 
    bar="吾輩は猫である"
  }),
  {
    "foo=I%20am%20a%20cat&bar=%E5%90%BE%E8%BC%A9%E3%81%AF%E7%8C%AB%E3%81%A7%E3%81%82%E3%82%8B",
    "bar=%E5%90%BE%E8%BC%A9%E3%81%AF%E7%8C%AB%E3%81%A7%E3%81%82%E3%82%8B&foo=I%20am%20a%20cat"
  }
)

assertMessage(
  transf.url_components.url({
    url = "https://example.com/foo/bar"
  }),
  "https://example.com/foo/bar"
)

assertMessage(
  transf.url_components.url({
    host = "example.com",
    endpoint = "foo/bar"
  }),
  "https://example.com/foo/bar"
)

assertMessage(
  transf.url_components.url({
    host = "example.com",
    endpoint = "/foo/bar"
  }),
  "https://example.com/foo/bar"
)

assertMessageAny(
  transf.url_components.url({
    url = "https://example.com/foo/bar",
    params = {
      foo = "bar",
      baz = "a space"
    }
  }),
  {
    "https://example.com/foo/bar?foo=bar&baz=a%20space",
    "https://example.com/foo/bar?baz=a%20space&foo=bar",
  }
)

assertMessageAny(
  transf.url_components.url({
    url = "https://example.com/foo/bar",
    params = {
      foo = "bar",
      baz = "a space"
    },
    host = "example.com",
    endpoint = "foo/bar"
  }),
  {
    "https://example.com/foo/bar?foo=bar&baz=a%20space",
    "https://example.com/foo/bar?baz=a%20space&foo=bar",
  }
)

assertMessageAny(
  transf.table.curl_form_field_list({ foo = "bar", lol = "what"}),
  {
    { "-F", {value = "foo=bar", type = "quoted"}, "-F",{ value = "lol=what", type = "quoted"}},
    { "-F", {value = "lol=what", type = "quoted"}, "-F",{ value = "foo=bar", type = "quoted"}}
  }
)

assertMessageAny(
  transf.table.curl_form_field_list({ foo = "bar", lol = "1"}),
  {
    { "-F", {value = "foo=bar", type = "quoted"}, "-F",{ value = "lol=1", type = "quoted"}},
    { "-F", {value = "lol=1", type = "quoted"}, "-F",{ value = "foo=bar", type = "quoted"}}
  }
)

assertMessageAny(
  transf.table.curl_form_field_list({ foo = "bar", lol = "@~/foo.txt"}),
  {
    { "-F", {value = "foo=bar", type = "quoted"}, "-F",{ value = "lol=@" .. env.HOME .. "/foo.txt", type = "quoted"}},
    { "-F", {value = "lol=@" .. env.HOME .. "/foo.txt", type = "quoted"}, "-F",{ value = "foo=bar", type = "quoted"}}
  }
)

assert(
  findsingle(
    transf.word.synonyms.raw_syn("love"),
    "affection"
  )
)

assertValuesContain(
  transf.word.synonyms.array_syn_tbls("love")[1].synonyms,
  { "affection" }
)

assertValuesContain(
  transf.word.synonyms.array_syn_tbls("love")[1].antonym,
  { "hate" }
)

assert(
  findsingle(
    transf.word.synonyms.raw_av("love"),
    "screw"
  )
)

assertValuesContain(
  transf.word.synonyms.array_av("love"),
  { "screw" }
)

local semver_components = transf.semver.components("1.2.3")

assertMessage(
  semver_components,
  {
    major = 1,
    minor = 2,
    patch = 3
  }
)

local semver_components = transf.semver.components("1.2.3-alpha.1")

assertMessage(
  semver_components,
  {
    major = 1,
    minor = 2,
    patch = 3,
    pre_release = "alpha.1"
  }
)

local semver_components = transf.semver.components("1.2.3+build.1")

assertMessage(
  semver_components,
  {
    major = 1,
    minor = 2,
    patch = 3,
    build = "build.1"
  }
)

local semver_components = transf.semver.components("1.2.3-alpha.1+build.1")

assertMessage(
  semver_components,
  {
    major = 1,
    minor = 2,
    patch = 3,
    pre_release = "alpha.1",
    build = "build.1"
  }
)

local os_pkg_manager_semver = get.upkg.array.package_manager_version("os")
local os_pkg_manager_semver_components = transf.semver.components(os_pkg_manager_semver)

assert(os_pkg_manager_semver_components.major >= 0)
assert(os_pkg_manager_semver_components.minor >= 0)
assert(os_pkg_manager_semver_components.patch >= 0)

local array_of_tables = {
  { foo = "bar" },
  { baz = "quuz" }
}

local item_array_of_item_tables = transf.array_of_tables.item_array_of_item_tables(array_of_tables)

assertMessage(
  item_array_of_item_tables.type,
  "array"
)

assertMessage(
  item_array_of_item_tables:get("contents")[1].type,
  "table"
)

-- Test Case 1: String starts with a number and has length 13, expecting a 10 digit timestamp
do
  local input = "1234567890123abc"
  local expected = 1234567890
  local output = mt.string.timestamp_or_nil(input)
  assert(output == expected, string.format("Output: %d; Expected: %d", output, expected))
end

-- Test Case 2: String starts with a number and has length 10, expecting the same number
do
  local input = "1234567890"
  local expected = 1234567890
  local output = mt.string.timestamp_or_nil(input)
  assert(output == expected, string.format("Output: %d; Expected: %d", output, expected))
end

-- Test Case 3: String is a valid date, expecting a timestamp
do
  local input = "2023-06-04"
  local expected = os.time({year = 2023, month = 6, day = 4}) -- Please note that the output will be system dependent
  local output = mt.string.timestamp_or_nil(input)
  assert(output == expected, string.format("Output: %d; Expected: %d", output, expected))
end

-- Test Case 4: String is a valid datetime, expecting a timestamp
do
  local input = "2023-06-04T12:30:45"
  local expected = os.time({year = 2023, month = 6, day = 4, hour = 12, min = 30, sec = 45}) -- Please note that the output will be system dependent
  local output = mt.string.timestamp_or_nil(input)
  assert(output == expected, string.format("Output: %d; Expected: %d", output, expected))
end

-- Test Case 5: String is not a valid date or number, expecting nil
do
  local input = "abcd123456"
  local expected = nil
  local output = mt.string.timestamp_or_nil(input)
  assert(output == expected, string.format("Output: %s; Expected: %s", tostring(output), tostring(expected)))
end

-- Test Case 6: String is a valid date with a long date separator, expecting a timestamp
do
  local input = "2023 at 06 at 04"
  local expected = os.time({year = 2023, month = 6, day = 4}) -- Please note that the output will be system dependent
  local output = mt.string.timestamp_or_nil(input)
  assert(output == expected, string.format("Output: %d; Expected: %d", output, expected))
end

-- Test Case 7: String is a valid datetime with a long date separator, expecting a timestamp
do
  local input = "2023 at 06 at 04 at 12 at 30 at 45"
  local expected = os.time({year = 2023, month = 6, day = 4, hour = 12, min = 30, sec = 45}) -- Please note that the output will be system dependent
  local output = mt.string.timestamp_or_nil(input)
  assert(output == expected, string.format("Output: %d; Expected: %d", output, expected))
end

-- Test Case 8: String is a valid datetime with only hours, expecting a timestamp
do
  local input = "2023-06-04T12"
  local expected = os.time({year = 2023, month = 6, day = 4, hour = 12, min = 0, sec = 0}) -- Please note that the output will be system dependent
  local output = mt.string.timestamp_or_nil(input)
  assert(output == expected, string.format("Output: %d; Expected: %d", output, expected))
end


local relay_table = transf.multiline_string.relay_table(readFile(env.MMOCK .. "/output/shell-command/mullvad_relay_list"))

assert(type(relay_table) == "table")
assert(type(relay_table["au"]) == "table") -- early entry (australia)
assert(type(relay_table["au"]["syd"]) == "table")
assertValuesContain(
  relay_table["au"]["syd"],
  {
    "au-syd-ovpn-001", 
    "au-syd-wg-001"
  }
)
assert(type(relay_table["de"]) == "table") -- some entry in the middle (germany)
assert(type(relay_table["de"]["fra"]) == "table")
assertValuesContain(
  relay_table["de"]["fra"],
  {
    "de-fra-ovpn-001", 
    "de-fra-wg-001"
  }
)



local contact_by_uuid = transf.uuid.raw_contact("a615b162-a203-4a24-a392-87ba3a7ca80c")
assertMessage(
  type(contact_by_uuid),
  "string"
)
local contact_by_find =  transf.string.raw_contact("Test Contact Germany English 001")
assertMessage(
  type(contact_by_find),
  "string"
)
local yaml_contact_by_uuid = transf.uuid.contact_table("a615b162-a203-4a24-a392-87ba3a7ca80c")
assertMessage(
  type(yaml_contact_by_uuid),
  "table"
)
assertMessage(
  yaml_contact_by_uuid.uid,
  "a615b162-a203-4a24-a392-87ba3a7ca80c"
)
assertMessage(
  yaml_contact_by_uuid.Address.home,
  "Teststr. 27, 00000 Testhausen, Deutschland"
)
local yaml_contact_by_find = transf.string.contact_table("Test Contact Germany English 001")
assertMessage(
  type(yaml_contact_by_find),
  "table"
)
assertMessage(
  yaml_contact_by_find.uid,
  "a615b162-a203-4a24-a392-87ba3a7ca80c"
)
assertMessage(
  yaml_contact_by_find.Address.home,
  "Teststr. 27, 00000 Testhausen, Deutschland"
)