
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
  transf.hex_string.char("6d"),
  "m"
)

assertMessage(
  transf.potentially_indicated_hex_string.indicated_hex_string("6d"),
  "0x6d"
)

assertMessage(
  transf.hex_string.utf8_unicode_prop_table("6d").name,
  "LATIN SMALL LETTER M"
)

-- Test for hex -> unicode_codepoint
assertMessage(
  transf.hex_string.unicode_codepoint("6d"),
  "U+6d"
)

-- Test for unicode_codepoint -> number
assertMessage(
  transf.unicode_codepoint.number("U+6D"),
  109 -- This is the decimal equivalent of 6D in hexadecimal
)

-- Test for unicode_codepoint -> unicode_prop_table
assertMessage(
  transf.unicode_codepoint.unicode_prop_table("U+6D").name,
  "LATIN SMALL LETTER M"
)

-- Test for number -> decimal_string
assertMessage(
  transf.number.decimal_string(109),
  "109"
)

-- Test for number -> indicated_decimal_string
assertMessage(
  transf.number.indicated_decimal_string(109),
  "0d109"
)

-- Test for number -> hex_string
assertMessage(
  transf.number.hex_string(109),
  "6D"
)

-- Test for number -> indicated_hex_string
assertMessage(
  transf.number.indicated_hex_string(109),
  "0x6D"
)

-- Test for number -> unicode_codepoint
assertMessage(
  transf.number.unicode_codepoint(109),
  "U+6D"
)

-- Test for number -> octal_string
assertMessage(
  transf.number.octal_string(109),
  "155"
)

-- Test for number -> indicated_octal_string
assertMessage(
  transf.number.indicated_octal_string(109),
  "0o155"
)

-- Test for number -> binary_string
assertMessage(
  transf.number.binary_string(109),
  "1101101"
)

-- Test for number -> indicated_binary_string
assertMessage(
  transf.number.indicated_binary_string(109),
  "0b1101101"
)

-- Test for number -> unicode_prop_table
assertMessage(
  transf.number.unicode_prop_table(109).name,
  "LATIN SMALL LETTER M"
)

-- Test for number -> utf8_unicode_prop_table
assertMessage(
  transf.number.utf8_unicode_prop_table(109).name,
  "LATIN SMALL LETTER M"
)

assertMessage(
  transf.char.hex("m"),
  "6D"
)


-- Test for percent -> char
assertMessage(
  transf.percent.char("%6d"),
  "m"
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
  transf.stringable_value_dict.url_params({foo = "bar", baz = "quux"}),
  {
    "baz=quux&foo=bar",
    "foo=bar&baz=quux"
  }
)

assertMessageAny(
  transf.stringable_value_dict.url_params({
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
  transf.stringable_value_dict.curl_form_field_list({ foo = "bar", lol = "what"}),
  {
    { "-F", {value = "foo=bar", type = "quoted"}, "-F",{ value = "lol=what", type = "quoted"}},
    { "-F", {value = "lol=what", type = "quoted"}, "-F",{ value = "foo=bar", type = "quoted"}}
  }
)

assertMessageAny(
  transf.stringable_value_dict.curl_form_field_list({ foo = "bar", lol = "1"}),
  {
    { "-F", {value = "foo=bar", type = "quoted"}, "-F",{ value = "lol=1", type = "quoted"}},
    { "-F", {value = "lol=1", type = "quoted"}, "-F",{ value = "foo=bar", type = "quoted"}}
  }
)

assertMessageAny(
  transf.stringable_value_dict.curl_form_field_list({ foo = "bar", lol = "@~/foo.txt"}),
  {
    { "-F", {value = "foo=bar", type = "quoted"}, "-F",{ value = "lol=@" .. env.HOME .. "/foo.txt", type = "quoted"}},
    { "-F", {value = "lol=@" .. env.HOME .. "/foo.txt", type = "quoted"}, "-F",{ value = "foo=bar", type = "quoted"}}
  }
)

assert(
  findsingle(
    transf.word.raw_syn_output("love"),
    "affection"
  )
)

assertValuesContain(
  transf.word.term_syn_specifier_dict("love")[1].synonyms,
  { "affection" }
)

assertValuesContain(
  transf.word.term_syn_specifier_dict("love")[1].antonym,
  { "hate" }
)

assert(
  findsingle(
    transf.word.raw_av("love"),
    "screw"
  )
)

assertValuesContain(
  transf.word.synonym_string_array("love"),
  { "screw" }
)

local semver_components = transf.semver.semver_components("1.2.3")

assertMessage(
  semver_components,
  {
    major = 1,
    minor = 2,
    patch = 3
  }
)

local semver_components = transf.semver.semver_components("1.2.3-alpha.1")

assertMessage(
  semver_components,
  {
    major = 1,
    minor = 2,
    patch = 3,
    pre_release = "alpha.1"
  }
)

local semver_components = transf.semver.semver_components("1.2.3+build.1")

assertMessage(
  semver_components,
  {
    major = 1,
    minor = 2,
    patch = 3,
    build = "build.1"
  }
)

local semver_components = transf.semver.semver_components("1.2.3-alpha.1+build.1")

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
local os_pkg_manager_semver_components = transf.semver.semver_components(os_pkg_manager_semver)

assert(os_pkg_manager_semver_components.major >= 0)
assert(os_pkg_manager_semver_components.minor >= 0)
assert(os_pkg_manager_semver_components.patch >= 0)

local array_of_tables = {
  { foo = "bar" },
  { baz = "quuz" }
}

local item_array_of_item_tables = transf.table_array.item_array_of_item_tables(array_of_tables)

assertMessage(
  item_array_of_item_tables.type,
  "array"
)

assertMessage(
  item_array_of_item_tables:get("c")[1].type,
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

local qr_code_test_contents = "This is a test string って、このstringの中に日本語があるよ！"

local qr_code_utf8_bow = transf.string.qr_utf8_image_bow(qr_code_test_contents)
local qr_code_utf8_wob = transf.string.qr_utf8_image_wob(qr_code_test_contents)
local qr_code_png_path = transf.string.qr_png_in_cache(qr_code_test_contents)

assertMessage(
  type(qr_code_utf8_bow),
  "string"
)
assertMessage(
  type(qr_code_utf8_wob),
  "string"
)
assertMessage(
  type(qr_code_png_path),
  "string"
)
assertMessage(
  qr_code_utf8_bow,
[[█████████████████████████████████████████
██ ▄▄▄▄▄ ██▄▀███ ▀█▀ █▀▄█ ▀▀██▄█ ▄▄▄▄▄ ██
██ █   █ █  ▀  ▀▀▄▀ ██▀█ ▄ ▀ ▄ █ █   █ ██
██ █▄▄▄█ █ ▀▀█ ▀ ▀█ ▄▀▀▄█ ▄▄▄▀▄█ █▄▄▄█ ██
██▄▄▄▄▄▄▄█ █▄▀ ▀▄█ ▀ █▄█ █ ▀▄▀▄█▄▄▄▄▄▄▄██
██▄▀▄ ▄ ▄█▀▄ ██ █▀▄█▀██ ██ ▄█▄██▄▄  ▄████
██▀▀▀▀ ▀▄█▄▀  ▄▄▄ ▄ ▄▄▀█▀▄▀█▄▀▀▀ ▄█▀▀▄ ██
███▀▀▀█▄▄▄▀▀▀▄▄▀ ▄▀█ ▄█ ██   ███▄▀▄  █▀██
██▄ ▀▄█ ▄▀ █▀ ▀ █ ▄█▄ ▄██ ▀ █ ▀▀█████▀███
██▀▀ ██▀▄  ▀▄█▀ ▄▀▀█▄▀▄ ██ █▀ ▄▄██▀█ █▄██
██▀▄▄▄▀█▄██ ▀█ █ █▀▀▄  ▄▀ ▀▄██▀█ ▄▄▄ ▄ ██
██ ▀ ▄▄█▄▄▀██▀█▀ █▀   ▀██▀▄ ▄▄  ▄█▄ ▄▄▄██
██▄ █ ▄▀▄▄  █▄▀ ▀▄█ ▀▄▄█▀▄  ▄▄▄▄▄▄▄▀▄ ███
██▀▄ ▄█ ▄█▀▀  ▀▄▀ ▄▀▀▀▀▀▄▀▄ ▄▄▀▀▀▀ ▄▄  ██
██ █▄▀▀ ▄ ▄▀ ▄▄ ▀ ▄▄▀▄██▄▄▄█▀▀ ▄  ▀ ▀▄ ██
██▄█▄▄█▄▄▄   █ ▀ ▄ ▄█▄█▀▄  ▄▄▄ ▄▄▄ ▀▄▄███
██ ▄▄▄▄▄ █▀  ▄█▄▄ ▀█▄▄██▀▀█ ▀█ █▄█ ▄█▄▄██
██ █   █ █ ▀  ▄█▄ ▀█▄██ ██ ▀█▄▄      ▄▀██
██ █▄▄▄█ █▄██▄▄█ █▀▄▄ ██▀▄▀▄▄▀▀▀▀ █ ▀▄ ██
██▄▄▄▄▄▄▄█▄██▄██▄█▄▄███▄██▄▄▄▄▄▄██▄▄▄▄▄██
█████████████████████████████████████████  ]]
)

assertMessage(
  qr_code_utf8_wob,
[[                                         
█▀▀▀▀▀█  ▀▄   █▄ ▄█ ▄▀ █▄▄  ▀ █▀▀▀▀▀█  
█ ███ █ ██▄██▄▄▀▄█  ▄ █▀█▄█▀█ █ ███ █  
█ ▀▀▀ █ █▄▄ █▄█▄ █▀▄▄▀ █▀▀▀▄▀ █ ▀▀▀ █  
▀▀▀▀▀▀▀ █ ▀▄█▄▀ █▄█ ▀ █ █▄▀▄▀ ▀▀▀▀▀▀▀  
▀▄▀█▀█▀ ▄▀█  █ ▄▀ ▄  █  █▀ ▀  ▀▀██▀    
▄▄▄▄█▄▀ ▀▄██▀▀▀█▀█▀▀▄ ▄▀▄ ▀▄▄▄█▀ ▄▄▀█  
 ▄▄▄ ▀▀▀▄▄▄▀▀▄█▀▄ █▀ █  ███   ▀▄▀██ ▄  
▀█▄▀ █▀▄█ ▄█▄█ █▀ ▀█▀  █▄█ █▄▄     ▄   
▄▄█  ▄▀██▄▀ ▄█▀▄▄ ▀▄▀█  █ ▄█▀▀  ▄ █ ▀  
▄▀▀▀▄ ▀  █▄ █ █ ▄▄▀██▀▄█▄▀  ▄ █▀▀▀█▀█  
█▄█▀▀ ▀▀▄  ▄ ▄█ ▄███▄  ▄▀█▀▀██▀ ▀█▀▀▀  
▀█ █▀▄▀▀██ ▀▄█▄▀ █▄▀▀ ▄▀██▀▀▀▀▀▀▀▄▀█   
▄▀█▀ █▀ ▄▄██▄▀▄█▀▄▄▄▄▄▀▄▀█▀▀▄▄▄▄█▀▀██  
█ ▀▄▄█▀█▀▄█▀▀█▄█▀▀▄▀  ▀▀▀ ▄▄█▀██▄█▄▀█  
▀ ▀▀ ▀▀▀███ █▄█▀█▀ ▀ ▄▀██▀▀▀█▀▀▀█▄▀▀   
█▀▀▀▀▀█ ▄██▀ ▀▀█▄ ▀▀  ▄▄ █▄ █ ▀ █▀ ▀▀  
█ ███ █ █▄██▀ ▀█▄ ▀  █  █▄ ▀▀██████▀▄  
█ ▀▀▀ █ ▀  ▀▀ █ ▄▀▀█  ▄▀▄▀▀▄▄▄▄█ █▄▀█  
▀▀▀▀▀▀▀ ▀  ▀  ▀ ▀▀   ▀  ▀▀▀▀▀▀  ▀▀▀▀▀  
                                       ]]
)

assertMessage(
  transf.image_file.qr_data(qr_code_png_path),
  qr_code_test_contents
)

assertMessage(
  transf.string.single_quoted_escaped("foo"),
  "'foo'"
)

assertMessage(
  transf.string.double_quoted_escaped("foo"),
  '"foo"'
)

assertMessage(
  transf.string.single_quoted_escaped("foon't"),
  "'foon\\'t'"
)

assertMessage(
  transf.string.double_quoted_escaped('foon"t'),
  '"foon\\"t"'
)

local unicode_table =  transf.string.unicode_prop_table_array("a🏞鯉")

assertMessage(
  unicode_table[1].name,
  "LATIN SMALL LETTER A"
)

assertMessage(
  unicode_table[2].cpoint,
  "U+1F3DE"
)

assertMessage(
  unicode_table[3].char,
  "鯉"
)

assertMessage(
  transf.not_userdata_or_function.single_quoted_escaped_json("foo"),
  "'\"foo\"'"
)
assertMessage(
  transf.not_userdata_or_function.double_quoted_escaped_json({1, true, "bar"}),
  '{1,true,"bar"}'
)

assertMessage(
  transf.not_userdata_or_function.single_quoted_escaped_json({
    foo = "foon't",
    bar = false
  }),
  '{"foo":"foon\\\'t","bar":false}'
)

local stritmarr = transf.string_array.item_array_of_string_items({
    "foo",
    "bar",
    "baz"
  })

assertMessage(
  stritmarr:get("c")[1].type,
  "string"
)

assertMessage(
  stritmarr:get("c")[2]:get("c"),
  "bar"
)

assertMessage(
  stritmarr:get("c")[3]:get("c"),
  "baz"
)

local str = "1234" .. mt._contains.unique_field_separator .. "somecalendar" .. mt._contains.unique_field_separator .. "2021-02-08T00:00:00Z"

local event_tbl = transf.string.event_table(str)

assertMessage(
  event_tbl.uid,
  "1234"
)

assertMessage(
  event_tbl.calendar,
  "somecalendar"
)

assertMessage(
  event_tbl.start,
  "2021-02-08T00:00:00Z"
)

local calendar_tmplt = transf.string.calendar_template(event_tbl)

assertMessage(
  calendar_tmplt,
[[calendar: somecalendar         # one of: default,testcalendar,r-:birthdays,reminders,r-:wuerfelpech,r-:schulferien
start:    2021-02-08T00:00:00Z]]
)

local compound_str = str .. mt._contains.unique_record_separator .. str

local compound_tbl = transf.string.compound_table(compound_str)

assertMessage(
  compound_tbl[1].uid,
  "1234"
)

assertMessage(
  compound_tbl[1].calendar,
  "somecalendar"
)

assertMessage(
  compound_tbl[1].start,
  "2021-02-08T00:00:00Z"
)

assertMessage(
  compound_tbl[2].uid,
  "1234"
)

assertMessage(
  compound_tbl[2].calendar,
  "somecalendar"
)

assertMessage(
  compound_tbl[2].start,
  "2021-02-08T00:00:00Z"
)

assertMessage(
  transf.string_array.repeated_option_string({"a", "b"}, "--include"),
  "--include a --include b"
)

local event_tbl_item_arr = transf.array_of_event_tables.item_array_of_event_table_items(compound_tbl)

assertMessage(
  event_tbl_item_arr:get("c")[1].uid,
  "1234"
)

assertMessage(
  transf.table.yaml_metadata({
    title = "foo",
    author = "bar"
  }),
[[---
title: foo
author: bar
---
]]
)

assertMessage(
  transf.path.form_path("/foo/bar"),
  "@/foo/bar"
)

assertMessage(
  transf.audio_file.transcribed(env.MMOCK .. "/files/binary/audio/mp3/myvoice.mp3"),
  "This is a testfile containing my voice."
)

assertMessage(
  transf.youtube_video_id.channel_title("doN4t5NKW-k"),
  "NASA"
)

assertMessage(
  transf.youtube_video_id.youtube_channel_id("doN4t5NKW-k"),
  "UCryGec9PdUCLjpJW2mgCuLw" -- todo: this was generated by Github Copilot, not checked yet
)

assertMessage(
  transf.youtube_video_id.description("doN4t5NKW-k"),
  "In her final days as Commander of the International Space Station, Sunita Williams of NASA recorded an extensive tour of the orbital laboratory and downlinked the video on Nov. 18, just hours before she, cosmonaut Yuri Malenchenko and Flight Engineer Aki Hoshide of the Japan Aerospace Exploration Agency departed in their Soyuz TMA-05M spacecraft for a landing on the steppe of Kazakhstan. The tour includes scenes of each of the station's modules and research facilities with a running narrative by Williams of the work that has taken place and which is ongoing aboard the orbital outpost."
)

assertMessage(
  transf.youtube_video_id.privacy_status("doN4t5NKW-k"),
  "public"
)

assertMessage(
  transf.youtube_video_id.video_title("doN4t5NKW-k"),
  "Departing Space Station Commander Provides Tour of Orbital Laboratory"
)

assertMessage(
  transf.youtube_video_id.youtube_video_url("doN4t5NKW-k"),
  "https://www.youtube.com/watch?v=doN4t5NKW-k"
)

assertMessage(
  transf.youtube_video_url.youtube_video_id("https://www.youtube.com/watch?v=doN4t5NKW-k"),
  "doN4t5NKW-k"
)

assertMessage(
  transf.youtube_video_id.upload_status("doN4t5NKW-k"),
  "processed"
)

assertMessage(
  transf.youtube_playlist_url.youtube_playlist_id("https://www.youtube.com/playlist?list=PL1D946ACB21752C0E"),
  "PL1D946ACB21752C0E"
)

-- youtube_playlist_id: title, uploader, url

assertMessage(
  transf.youtube_playlist_id.title("PL1D946ACB21752C0E"),
  "This Week @NASA"
)

assertMessage(
  transf.youtube_playlist_id.uploader("PL1D946ACB21752C0E"),
  "NASA"
)

assertMessage(
  transf.youtube_playlist_id.youtube_playlist_url("PL1D946ACB21752C0E"),
  "https://www.youtube.com/playlist?list=PL1D946ACB21752C0E"
)

-- youtube_channel_id: feed_url, channel_url, channel_title

assertMessage(
  transf.youtube_channel_id.feed_url("UCryGec9PdUCLjpJW2mgCuLw"),
  "https://www.youtube.com/feeds/videos.xml?channel_id=UCryGec9PdUCLjpJW2mgCuLw"
)

assertMessage(
  transf.youtube_channel_id.channel_url("UCryGec9PdUCLjpJW2mgCuLw"),
  "https://www.youtube.com/channel/UCryGec9PdUCLjpJW2mgCuLw"
)

assertMessage(
  transf.youtube_channel_id.channel_title("UCryGec9PdUCLjpJW2mgCuLw"),
  "NASA"
)

assertMessage(
  transf.youtube_playlist_url.youtube_playlist_id("https://www.youtube.com/playlist?list=PL1D946ACB21752C0E"),
  "PL1D946ACB21752C0E"
)

assertMessage(
  transf.youtube_video_url.youtube_video_id("https://www.youtube.com/watch?v=doN4t5NKW-k"),
  "doN4t5NKW-k"
)

-- cleaning

assertMessage(
  transf.youtube_channel_title.cleaned("Official NASA Channel"),
  "NASA"
)

assertMessage(
  transf.youtube_channel_title.cleaned("The Doors - Topic"),
  "The Doors"
)

assertMessage(
  transf.youtube_video_title.cleaned("Hatenakute mo [Official MV]"),
  "Hatenakute mo"
)

-- handle: youtube_channel_id, channel_title, feed_url, raw_handle

assertMessage(
  transf.handle.youtube_channel_id("@NASA"),
  "UCryGec9PdUCLjpJW2mgCuLw"
)

assertMessage(
  transf.handle.channel_title("@NASA"),
  "NASA"
)

assertMessage(
  transf.handle.feed_url("@NASA"),
  "https://www.youtube.com/feeds/videos.xml?channel_id=UCryGec9PdUCLjpJW2mgCuLw"
)

assertMessage(
  transf.handle.raw_handle("@NASA"),
  "NASA"
)

assertMessage(
  transf.image_url.booru_url("https://cdn.donmai.us/original/82/cf/__kia_and_ati_steampunk_and_1_more_drawn_by_ooishi_ryuuko__82cf8ce1f00c40754920eb87f296f2c8.png"),
  "https://danbooru.donmai.us/posts/199016"
)

assertMessage(
  transf.iban.cleaned_iban("DE02_1203 0000--0000_2020  51"),
  "DE02120300000000202051"
)

assertMessage(
  transf.cleaned_iban.bic("DE02120300000000202051"),
  "BYLADEM1001"
)

assertMessage(
  transf.cleaned_iban.bank_name("DE02120300000000202051"),
  "DEUTSCHE KREDITBANK BERLIN"
)

assertMessage(
  transf.not_userdata_or_function.md5("foo"),
  "acbd18db4cc2f85cedef654fccc4a4d8"
)

assertMessage(
  transf.not_userdata_or_function.md5(1),
  "c4ca4238a0b923820dcc509a6f75849b"
)

assertMessage(
  transf.not_userdata_or_function.md5(true),
  "b326b5062b2f0e69046810717534cb09"
)

assertMessage(
  transf.not_userdata_or_function.md5({"foo", "bar"}),
  "1ea13cb52ddd7c90e9f428d1df115d8f"
)

assertMessage(
  transf.not_userdata_or_function.md5({foo = "bar"}),
  "9bb58f26192e4ba00f01e2e7b136bbd8"
)

assertMessage(
  transf.url.in_wayback_machine("https://www.google.com/"),
  "https://web.archive.org/web/*/https://www.google.com/"
)

assert(
  stringy.startswith(transf.url.default_negotiation_url_contents("example.com"), [[<!doctype html>
<html>
<head>
    <title>Example Domain</title>]]
)
)

assertMessage(
  transf.url.in_cache_dir("https://www.google.com/"),
  env.XDG_CACHE_HOME .. "/hs/url/https:__www.google.com_"
)

assertMessage(
  transf.whisper_url.transcribed(transf.absolute_path.file_url(env.MMOCK .. "/files/binary/audio/mp3/myvoice.mp3")),
  "This is a testfile containing my voice."
)

assert(
  transf.image_file.hs_image(env.MMOCK .. "/files/binary/image/png/basic.png").toASCII
)

assertMessage(
  transf.string.in_cache_dir("foo"),
  env.XDG_CACHE_HOME .. "/hs/default/foo"
)

assertMessage(
  transf.string.in_cache_dir("foo", "bar"),
  env.XDG_CACHE_HOME .. "/hs/bar/foo"
)

assertMessage(
  transf.string.safe_filename("foo"),
  "foo"
)

assertMessage(
  transf.string.safe_filename("foo\abar"),
  "foo_bar"
)

assertMessage(
  transf.string.safe_filename("foo/bar"),
  "foo_bar"
)

assertMessage(
  transf.string.safe_filename("foo \t bar"),
  "foo_bar"
)

assertMessage(
  transf.string.safe_filename("."),
  "_"
)

assertMessage(
  transf.string.safe_filename(multiply("a", 400)),
  multiply("a", 255)
)

assertMessage(
  transf.string.safe_filename(""),
  "_"
)

assertMessage(
  transf.string.in_cache_dir("foo/bar/baz"),
  env.XDG_CACHE_HOME .. "/hs/default/foo_bar_baz"
)

assertMessage(
  transf.string.qr_utf8_image_bow("1"),
[[█████████████████████████
██ ▄▄▄▄▄ █▀██▀██ ▄▄▄▄▄ ██
██ █   █ ██▀▄ ██ █   █ ██
██ █▄▄▄█ █▄▄▄█ █ █▄▄▄█ ██
██▄▄▄▄▄▄▄█▄█▄▀ █▄▄▄▄▄▄▄██
██▄▀▄▀ █▄█▀█▄▄██▀█▄█▀ ███
██▀▀▄▄▀▄▄▀▄█▄█▄█▀█▄█▀▀▄██
██████▄█▄▄▀█ ▀▄▀▄▀▄▀▄ ▄██
██ ▄▄▄▄▄ ██▀█ ▀ ▄ ▀ ▄ ▄██
██ █   █ █▄▀▀▄█▄ ▄█▄ ▀▄██
██ █▄▄▄█ █▄▀▀█▄█▀█▄█▀█▄██
██▄▄▄▄▄▄▄█▄███▄█▄█▄█▄█▄██
█████████████████████████]]
)

assertMessage(
  transf.string.qr_utf8_image_wob("1"),
[[                         
  █▀▀▀▀▀█ ▄  ▄  █▀▀▀▀▀█  
  █ ███ █  ▄▀█  █ ███ █  
  █ ▀▀▀ █ ▀▀▀ █ █ ▀▀▀ █  
  ▀▀▀▀▀▀▀ ▀ ▀▄█ ▀▀▀▀▀▀▀  
  ▀▄▀▄█ ▀ ▄ ▀▀  ▄ ▀ ▄█   
  ▄▄▀▀▄▀▀▄▀ ▀ ▀ ▄ ▀ ▄▄▀  
      ▀ ▀▀▄ █▄▀▄▀▄▀▄▀█▀  
  █▀▀▀▀▀█  ▄ █▄█▀█▄█▀█▀  
  █ ███ █ ▀▄▄▀ ▀█▀ ▀█▄▀  
  █ ▀▀▀ █ ▀▄▄ ▀ ▄ ▀ ▄ ▀  
  ▀▀▀▀▀▀▀ ▀   ▀ ▀ ▀ ▀ ▀  
                         ]]
)

assertMessage(
  transf.string.qr_png_in_cache("This string has emoji 👍 and cool japanese slang like いいね！"),
  env.XDG_CACHE_HOME .. "/hs/qr/This_string_has_emoji_👍_and_cool_japanese_slang_like_いいね！.png"
)

-- Test 1: Basic URL encoding
local test1 = transf.string.urlencoded("https://www.example.com/test url")
assertMessage(test1, "https%3A%2F%2Fwww.example.com%2Ftest+url")

-- Test 2: Spaces encoded as %20
local test2 = transf.string.urlencoded("https://www.example.com/test url", true)
assertMessage(test2, "https%3A%2F%2Fwww.example.com%2Ftest%20url")

-- Test 3: Spaces encoded as + (default behavior)
local test3 = transf.string.urlencoded("https://www.example.com/test url", false)
assertMessage(test3, "https%3A%2F%2Fwww.example.com%2Ftest+url")

-- Test 4: Special characters encoding
local test4 = transf.string.urlencoded("https://www.example.com/test?query=parameter&value=10")
assertMessage(test4, "https%3A%2F%2Fwww.example.com%2Ftest%3Fquery%3Dparameter%26value%3D10")

assertMessage(
  transf.string.urldecode("https%3A%2F%2Fwww.example.com%2Ftest%20url"),
  "https://www.example.com/test url"
)

assertMessage(
  transf.url.param_table("https://www.example.com/test"),
  {}
)

assertMessage(
  transf.url.param_table("https://www.example.com/test?foo=bar"),
  { foo = "bar" }
)

assertMessage(
  transf.url.param_table("https://www.example.com/test?foo=bar&baz=qux"),
  { foo = "bar", baz = "qux" }
)

assertMessage(
  transf.url.param_table("https://www.example.com/test?foo=bar%20baz&baz=qux"),
  { foo = "bar baz", baz = "qux" }
)

assertMessage(
  transf.url.param_table("https://www.example.com/test?foo=bar baz&baz=qux"),
  { foo = "bar baz", baz = "qux" }
)

assertMessage(
  transf.url.no_scheme("https://www.example.com/test"),
  "www.example.com/test"
)

assertMessage(
  transf.url.no_scheme("www.example.com/test"),
  "www.example.com/test"
)

assertMessage(
  transf.url.no_scheme("data:text/plain;base64,SGVsbG8sIFdvcmxkIQ=="),
  "text/plain;base64,SGVsbG8sIFdvcmxkIQ=="
)

assertMessage(
  transf.url.in_cache_dir("https://www.example.com/test"),
  env.XDG_CACHE_HOME .. "/hs/url/https:__www.example.com_test"
)

assertMessage(
  transf.mailto_url.emails("mailto:someone@example.com?subject=This%20is%20the%20subject&cc=someone_else@example.com&body=This%20is%20the%20body"),
  { "someone@example.com" }
)

assertMessage(
  transf.mailto_url.emails("mailto:someone@example.com,someoneelse@example.com"),
  {"someone@example.com","someoneelse@example.com"}
)

assertMessage(
  transf.mailto_url.first_email("mailto:someone@example.com,someoneelse@example.com"),
  "someone@example.com"
)

assertMessage(
  transf.mailto_url.subject("mailto:someone@example.com?subject=This%20is%20the%20subject&cc=someone_else@example.com&body=This%20is%20the%20body"),
  "This is the subject"
)

assertMessage(
  transf.mailto_url.cc("mailto:someone@example.com?subject=This%20is%20the%20subject&cc=someone_else@example.com&body=This%20is%20the%20body"),
  "someone_else@example.com"
)

assertMessage(
  transf.tel_url.phone_number("tel:+1-202-555-0101"),
  "+1-202-555-0101"
)

assertMessage(
  transf.otpauth_url.type("otpauth://totp/Test%20Issuer%3ATest%20Account?secret=12345678901234567890&issuer=Test%20Issuer"),
  "totp"
)

assertMessage(
  transf.otpauth_url.label("otpauth://totp/Test%20Issuer%3ATest%20Account?secret=12345678901234567890&issuer=Test%20Issuer"),
  "Test Issuer:Test Account"
)

assertMessage(
  transf.doi.doi_url("https://doi.org/10.1000/182"),
  "https://doi.org/10.1000/182"
)

assertMessage(
  transf.doi.doi_url("10.1000/182"),
  "https://doi.org/10.1000/182"
)

assert(
  stringy.startswith(
    transf.doi.online_bib("10.1038/nature14539"),
    "@article{LeCun_2015,"
  )
)

assert(
  stringy.startswith(
    transf.isbn.online_bib("978-0-262-13472-9"),
    "@book{9780262134729,"
  )
)

assertMessage(
  transf.not_userdata_or_function.in_cache_dir(false, "test"),
  env.XDG_CACHE_HOME .. "/hs/test/" .. transf.not_userdata_or_function.md5(false)
)

assertMessage(
  transf.bib_string.array_of_csl_tables(transf.doi.online_bib("10.1038/nature14539")),
  json.decode([[
    [
      {
        "DOI": "10.1038/nature14539",
        "URL": "https://doi.org/10.1038%2Fnature14539",
        "author": [
          {
            "family": "LeCun",
            "given": "Yann"
          },
          {
            "family": "Bengio",
            "given": "Yoshua"
          },
          {
            "family": "Hinton",
            "given": "Geoffrey"
          }
        ],
        "container-title": "Nature",
        "id": "LeCun_2015",
        "issue": "7553",
        "issued": {
          "date-parts": [
            [
              2015,
              5
            ]
          ]
        },
        "page": "436-444",
        "publisher": "Springer Science and Business Media LLC",
        "title": "Deep learning",
        "type": "article-journal",
        "volume": "521"
      }
    ]
  ]])
)

local jp_sent = "Ii seibetsu da ne. Sore, ofuku ga eranda no?"

assertMessage(
  transf.string.hiragana_only(jp_sent),
  "いい せいべつ だ ね. それ, おふく が えらんだ の?"
)

assertMessage(
  transf.string.hiragana_punct(jp_sent),
  "いいせいべつだね。それ、おふくがえらんだの？"
)

assertMessage(
  transf.string.katakana_only(jp_sent),
  "イイ セイベツ ダ ネ. ソレ, オフク ガ エランダ ノ?"
)

assertMessage(
  transf.string.katakana_punct(jp_sent),
  "イイセイベツダネ。ソレ、オフクガエランダノ？"
)

assertMessage(
  transf.string.kana_mixed("kore,hiraganade.†Kore, romaji de.ΔKore, katakanade."),
  "これ、ひらがなで。Kore, romaji de. コレ、カタカナデ。"
)

assertMessage(
  transf.string.japanese_writing(jp_sent),
  "いい性別だね。それ、お袋が選んだの？"
)

assertMessage(
  transf.absolute_path.file_url("/home/user/test.txt"),
  "file:///home/user/test.txt"
)

assertMessage(
  transf.path.extension("/home/user/test.txt"),
  "txt"
)

assertMessage(
  transf.path.extension("/home/user/test"),
  ""
)

assertMessage(
  transf.image_file.booru_url(transf.url.in_cache_dir("https://cdn.donmai.us/original/82/cf/__kia_and_ati_steampunk_and_1_more_drawn_by_ooishi_ryuuko__82cf8ce1f00c40754920eb87f296f2c8.png")),
  "https://danbooru.donmai.us/posts/199016"
)

assert(
  stringy.startswith(
    transf.image_file.data_url(env.MMOCK .. "files/binary/image/png/tiny_blank.png"),
    "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKEAYAAADdohP"
  )
)

-- example timestamp-key ovtable
local example_table = ovtable.init({
  {key="1634271457", value={"event1"}},
  {key="1634271469", value={"event3"}},
  {key="1634271481", value={"event4"}},
  {key="1634366282", value={"event5"}},
  {key="1634366294", value={"event6"}},
  {key="1634366306", value={"event7"}},
  {key="1634366318", value={"event8"}},
})

-- example output table
local example_output = {
  ["2021"] = {
    ["2021-10"] = {
      ["2021-10-15"] = {
        {"06:18:01", "event4"},
        {"06:17:49", "event3"},
        {"06:17:37", "event1"},
      },
      ["2021-10-16"] = {
        {"08:38:38", "event8"},
        {"08:38:26", "event7"},
        {"08:38:14", "event6"},
        {"08:38:02", "event5"},
      }
    }
  }
}

-- test the function with the example table
assertMessage(
  transf.timestamp_table.ymd_table(example_table),
  example_output
)

-- test the function with an empty table
assertMessage(
  transf.timestamp_table.ymd_table(ovtable.new()),
  {}
)


-- test the function with a table containing a single element
assertMessage(
  transf.timestamp_table.ymd_table(ovtable.init({{key="1634366282", value={"event5"}}})),
  {
    ["2021"] = {
      ["2021-10"] = {
        ["2021-10-16"] = {
          {"08:38:02", "event5"}
        }
      }
    }
  }
)

-- test the function with a table containing elements from different years
assertMessage(
  transf.timestamp_table.ymd_table(ovtable.init({
    {key="1634271457", value={"event1"}},
    {key="1634271469", value={"event2"}},
    {key="1641024841", value={"event4"}},
    {key="1641024853", value={"event5"}},
  })),
  {
    ["2021"] = {
      ["2021-10"] = {
        ["2021-10-15"] = {
          {"06:17:49", "event2"},
          {"06:17:37", "event1"},
        }
      }
    },
    ["2022"] = {
      ["2022-01"] = {
        ["2022-01-01"] = {
          {"09:14:13", "event5"},
          {"09:14:01", "event4"},
        }
      }
    }
  }
)
-- test the function with a table containing elements from different months
assertMessage(
  transf.timestamp_table.ymd_table(ovtable.init({
    {key="1633075200", value={"event1"}},
    {key="1635763200", value={"event2"}},
    {key="1638355200", value={"event3"}},
    {key="1641033600", value={"event4"}},
    {key="1643625600", value={"event5"}},
  })),
  {
    ["2021"] = {
      ["2021-10"] = {
        ["2021-10-01"] = {
          {"10:00:00", "event1"}
        }
      },
      ["2021-11"] = {
        ["2021-11-01"] = {
          {"11:40:00", "event2"}
        }
      },
      ["2021-12"] = {
        ["2021-12-01"] = {
          {"11:40:00", "event3"}
        }
      }
    },
    ["2022"] = {
      ["2022-01"] = {
        ["2022-01-01"] = {
          {"11:40:00", "event4"},
        },
        ["2022-01-31"] = {
          {"11:40:00", "event5"},
        }
      }
    }
  }
)

-- test the function with a table containing multiple events for the same timestamp
assertMessage(
  transf.timestamp_table.ymd_table(ovtable.init({
    {key="1633075200", value={"event1", "event2", "event3"}},
    {key="1635763200", value={"event4"}},
    {key="1638355200", value={"event5"}},
    {key="1641033600", value={"event6"}},
    {key="1643625600", value={"event7", "event8"}},
  })),
  {
    ["2021"] = {
      ["2021-10"] = {
        ["2021-10-01"] = {
          {"10:00:00", "event1", "event2", "event3"}
        }
      },
      ["2021-11"] = {
        ["2021-11-01"] = {
          {"11:40:00", "event4"}
        }
      },
      ["2021-12"] = {
        ["2021-12-01"] = {
          {"11:40:00", "event5"}
        }
      }
    },
    ["2022"] = {
      ["2022-01"] = {
        ["2022-01-01"] = {
          {"11:40:00", "event6"}
        },
        ["2022-01-31"] = {
          {"11:40:00", "event7", "event8"}
        }
      }
    }
  }
)
