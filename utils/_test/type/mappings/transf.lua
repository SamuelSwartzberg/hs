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

env = realenv