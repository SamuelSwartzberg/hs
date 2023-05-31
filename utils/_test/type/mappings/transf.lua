
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

assertValuesContain(
  transf.package_manager.array.backed_up_packages("os"),
  {"mpv"}
)

assert(
  type(transf.package_manager.array.missing_packages("os")) == "table"
)
assert(
  type(transf.package_manager.array.added_packages("os")) == "table"
)
assert(
  type(transf.package_manager.array.difference_packages("os")) == "table"
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

local os_pkg_manager_semver = transf.package_manager.array.package_manager_version("os")
local os_pkg_manager_semver_components = transf.semver.components(os_pkg_manager_semver)

assert(os_pkg_manager_semver_components.major >= 0)
assert(os_pkg_manager_semver_components.minor >= 0)
assert(os_pkg_manager_semver_components.patch >= 0)

assertValuesContain(
  transf.package_manager.array.list("os"),
  {"mpv"}
)

assert(
  find(
    transf.package_manager.array.version("os"),
    { _start = "1." } -- there will always be some package with a version starting with 1., so this is a safe test
  )
)

assert(
  tonumber(transf.package_manager.array.count("os")) > 50  -- 50 is a safe number to assume there are more than (at time of writing, 388)
)

assert(
  find(
    transf.package_manager.array.with_version("os", "mpv"),
    { _start = "mpv@" }
  )
)

assertValuesContain(
  transf.package_manager.array.which("os", "mpv"),
  {"/opt/homebrew/opt/mpv"}
)

assert(
  transf.package_manager.array.is_installed("os", "mpv")
)

local array_of_tables = {
  { foo = "bar" },
  { baz = "quuz" }
}

local item_array_of_item_tables = transf.raw_array_of_tables.item_array_of_item_tables(array_of_tables)

assertMessage(
  item_array_of_item_tables.type,
  "array"
)

assertMessage(
  item_array_of_item_tables:get("contents")[1].type,
  "table"
)


function(command)
  local khard_list = command:get("khard-list")
  assertMessage(
    type(khard_list),
    "string"
  )
  local khard_list_first_field = stringy.split(khard_list, "\t")[1]
  assertMessage(
    onig.match(khard_list_first_field, whole(mt._r.id.uuid)),
    true
  )
  local all_contact_uuids = command:get("all-contact-uuids")
  assertMessage(
    type(all_contact_uuids),
    "table"
  )
  for _, uuid in ipairs(all_contact_uuids) do
    assertMessage(
      onig.match(uuid, whole(mt._r.id.uuid)),
      true
    )
  end
  local all_contact_uuids_string_items = command:get("all-contact-uuids-to-string-items")
  assertMessage(
    type(all_contact_uuids_string_items),
    "table"
  )
  for _, item in ipairs(all_contact_uuids_string_items) do
    assert(
      find(item:get_all("type"), {_exactly = "contact"})
    )
  end
  local contact_by_uuid = command:get("show-contact", "a615b162-a203-4a24-a392-87ba3a7ca80c")
  assertMessage(
    type(contact_by_uuid),
    "string"
  )
  local contact_by_find = command:get("find-contact", "Test Contact Germany English 001")
  assertMessage(
    type(contact_by_find),
    "string"
  )
  local yaml_contact_by_uuid = command:get("show-contact-yaml", "a615b162-a203-4a24-a392-87ba3a7ca80c")
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
  local yaml_contact_by_find = command:get("find-contact-yaml", "Test Contact Germany English 001")
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
  local contact_by_uuid_to_contact_table = command:get("show-contact-to-contact-table", "a615b162-a203-4a24-a392-87ba3a7ca80c")
  assert(
    find(contact_by_uuid_to_contact_table:get_all("type"), {_exactly = "contact"})
  )
  assertMessage(
    contact_by_uuid_to_contact_table:get("uid"),
    "a615b162-a203-4a24-a392-87ba3a7ca80c"
  )
  local contact_by_find_to_contact_table = command:get("find-contact-to-contact-table", "Test Contact Germany English 001")
  assert(
    find(contact_by_find_to_contact_table:get_all("type"), {_exactly = "contact"})
  )
  assertMessage(
    contact_by_find_to_contact_table:get("uid"),
    "a615b162-a203-4a24-a392-87ba3a7ca80c"
  )
  command:doThis("get-array-of-contact-tables", function(arr_cont_tbls)
    assertMessage(
      type(arr_cont_tbls),
      "table"
    )
    assertMessage(
      arr_cont_tbls.type,
      "array"
    )
    assert(
      arr_cont_tbls:get("all-pass", function(cont_tbl)
        return find(cont_tbl:get_all("type"), {_exactly = "contact-table"})
      end)
    )
  end)
end