assertMessage(
  replace("foo", to.case.capitalized),
  "Foo"
)

assertMessage(
  replace("Foo", to.case.capitalized),
  "Foo"
)

assertMessage(
  replace("Foo", to.case.notcapitalized),
  "foo"
)

local teststr = " Testfile (1) - ver 1.0.0 Copy (2).txt"

assertMessage(
  replace(teststr, to.case.snake),
  "Testfile_1_ver_1_0_0_Copy_2_txt"
)

assertMessage(
  replace(teststr, to.case.kebap),
  "Testfile-1-ver-1-0-0-Copy-2-txt"
)

local encoded_url = "https://foobar.com/this%20is%20a%20test%20file%20%28with%20special%20chars%29.txt"

assertMessage(
  replace(encoded_url, to.url.decoded),
  "https://foobar.com/this is a test file (with special chars).txt"
)

local unescaped_regex = "(for some reason I want to match %this% as a [literal]+)"

assertMessage(
  replace(unescaped_regex, to.regex.lua_escaped),
  "%(for some reason I want to match %%this%% as a %[literal%]%+%)"
)

assertMessage(
  replace(unescaped_regex, to.regex.general_escaped),
  "\\(for some reason I want to match %this% as a \\[literal\\]\\+\\)"
)

local doi1 = "doi:10.1234/5678"
local doi2 = "https://doi.org/10.1234/5678"

assertMessage(
  replace(doi1, to.resolved.doi),
  doi2
)

assertMessage(
  replace(doi2, to.resolved.doi),
  doi2
)