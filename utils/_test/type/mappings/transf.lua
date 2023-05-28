local realenv = env
env = {
  HOME = "/Users/sam"
}

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

env = realenv