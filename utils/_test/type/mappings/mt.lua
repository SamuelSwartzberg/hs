assertMessage(
  string.match("foo_BAR_89", mt._r.case.snake),
  "foo_BAR_89"
)

assertMessage(
  string.match("foo_BAR_89", mt._r.case.upper_snake),
  "_BAR_89"
)

assertMessage(
  string.match("foo_BAR_89", mt._r.case.lower_snake),
  "foo_"
)

assertMessage(
  string.match("foo_BAR_89", mt._r.case.lower),
  "foo"
)

assertMessage(
  string.match("foo_BAR_89", mt._r.case.upper),
  "BAR"
)

assertMessage(
  onig.match("foo_BAR_89", mt._r.case.upper),
  "BAR"
)

assertMessage(
  onig.match("3d8x2+2", mt._r.syntax.dice),
  "3d8x2+2"
)

assertMessage(
  onig.match("3d8x2+2", whole(mt._r.syntax.dice)),
  "3d8x2+2"
)

assertMessage(
  onig.match("1d2", whole(mt._r.syntax.dice)),
  "1d2"
)

assertMessage(
  onig.match("1d2-3", whole(mt._r.syntax.dice)),
  "1d2-3"
)

assertMessage(
  onig.match("77d2/7", whole(mt._r.syntax.dice)),
  "77d2/7"
)

local b64_gen_str = "U28/PHA+VGhpcyA0LCA1LCA2LCA3LCA4LCA5LCB6LCB7LCB8LCB9IHRlc3RzIEJhc2U2NCBlbmNvZGVyLiBTaG93IG1lOiBALCBBLCBCLCBDLCBELCBFLCBGLCBHLCBILCBJLCBKLCBLLCBMLCBNLCBOLCBPLCBQLCBRLCBSLCBTLCBULCBVLCBWLCBXLCBYLCBZLCBaLCBbLCBcLCBdLCBeLCBfLCBgLCBhLCBiLCBjLCBkLCBlLCBmLCBnLCBoLCBpLCBqLCBrLCBsLCBtLCBuLCBvLCBwLCBxLCByLCBzLg==="
local b64_url_str = "U28_PHA-VGhpcyA0LCA1LCA2LCA3LCA4LCA5LCB6LCB7LCB8LCB9IHRlc3RzIEJhc2U2NCBlbmNvZGVyLiBTaG93IG1lOiBALCBBLCBCLCBDLCBELCBFLCBGLCBHLCBILCBJLCBKLCBLLCBMLCBNLCBOLCBPLCBQLCBRLCBSLCBTLCBULCBVLCBWLCBXLCBYLCBZLCBaLCBbLCBcLCBdLCBeLCBfLCBgLCBhLCBiLCBjLCBkLCBlLCBmLCBnLCBoLCBpLCBqLCBrLCBsLCBtLCBuLCBvLCBwLCBxLCByLCBzLg==="

assertMessage(
  onig.match(b64_gen_str, whole(mt._r.b.b64.gen)),
  b64_gen_str
)


assertMessage(
  onig.match(b64_url_str, whole(mt._r.b.b64.url)),
  b64_url_str
)

assertMessage(
  onig.match(b64_gen_str, whole(mt._r.b.b64.url)),
  nil
)

assertMessage(
  onig.match(b64_url_str, whole(mt._r.b.b64.gen)),
  nil
)

local b32_gen_str = "JBSWY3DPEBLW64TMMQ======"
local b32_crock_str = "JBSWY3DPEBW64TMMQ===="

assertMessage(
  onig.match(b32_gen_str, whole(mt._r.b.b32.gen)),
  b32_gen_str
)

assertMessage(
  onig.match(b32_crock_str, whole(mt._r.b.b32.crockford)),
  b32_crock_str
)

assertMessage(
  onig.match(b32_gen_str, whole(mt._r.b.b32.crockford)),
  nil
)

local issn = "1234-5679"
local isbn_cleaned = "9783161484100"
local uuid = "6ba7b810-9dad-11d1-80b4-00c04fd430c8"
local doi = "10.1000/182"
local doi_prefix = "https://doi.org/"

assertMessage(
  onig.match(issn, whole(mt._r.id.issn)),
  issn
)

assertMessage(
  onig.match(isbn_cleaned, whole(mt._r.id.isbn)),
  isbn_cleaned
)

assertMessage(
  onig.match(uuid, whole(mt._r.id.uuid)),
  uuid
)

assertMessage(
  onig.match(doi, whole(mt._r.id.doi)),
  doi
)

assertMessage(
  onig.match(doi_prefix, whole(mt._r.id.doi_prefix)),
  doi_prefix
)

assertMessage(
  onig.match("\0\0asdfa%Q@8)I#\0", mt._r.charset.printable_ascii),
  "asdfa%Q@8)I#"
)

assertMessage(
  onig.match("\0\0asdfa%Q@8)I#\0", whole(mt._r.charset.printable_ascii)),
  nil
)

assertMessage(
  onig.match("\0\0asdfa%Q@8)I#\0", mt._r.charset.ascii),
  "\0\0asdfa%Q@8)I#\0"
)

assertMessage(
  onig.match("\0\0asdfa%Q@8)I#\0", whole(mt._r.charset.ascii)),
  "\0\0asdfa%Q@8)I#\0"
)

local major = onig.match("1", mt._r.version.semver)

assertMessage(major, "1")

local major, minor = onig.match("1.2", mt._r.version.semver)

assertMessage(major, "1")
assertMessage(minor, "2")

local major, minor, patch = onig.match("1.2.3", mt._r.version.semver)

assertMessage(major, "1")
assertMessage(minor, "2")
assertMessage(patch, "3")

local major, minor, patch, pre = onig.match("1.2.3-alpha", mt._r.version.semver)

assertMessage(major, "1")
assertMessage(minor, "2")
assertMessage(patch, "3")
assertMessage(pre, "alpha")

local major, minor, patch, pre, build = onig.match("1.2.3-alpha+build", mt._r.version.semver)

assertMessage(major, "1")
assertMessage(minor, "2")
assertMessage(patch, "3")
assertMessage(pre, "alpha")
assertMessage(build, "build")

local major, minor, patch, pre, build = onig.match("1.2.3+build", mt._r.version.semver)

assertMessage(major, "1")
assertMessage(minor, "2")
assertMessage(patch, "3")
assertMessage(pre, nil)
assertMessage(build, "build")

local major, minor, patch, pre, build = onig.match("1.2.3-alpha.1+build.11.e0f985a", mt._r.version.semver)

assertMessage(major, "1")
assertMessage(minor, "2")
assertMessage(patch, "3")
assertMessage(pre, "alpha.1")
assertMessage(build, "build.11.e0f985a")


assert(onig.match("de-bln-wg-101", mt._r.id.relay_identifier))
