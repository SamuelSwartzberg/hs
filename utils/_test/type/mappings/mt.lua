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
  eutf8.match("3d8x2+2", whole(mt._r.syntax.dice))
  "3d8x2+2"
)

assertMessage(
  eutf8.match("1d2", whole(mt._r.syntax.dice))
  "1d2"
)

assertMessage(
  eutf8.match("1d2-3", whole(mt._r.syntax.dice))
  "1d2-3"
)

assertMessage(
  eutf8.match("77d2/7", whole(mt._r.syntax.dice))
  "77d2/7"
)

local b64_gen_str = "U28/PHA+VGhpcyA0LCA1LCA2LCA3LCA4LCA5LCB6LCB7LCB8LCB9IHRlc3RzIEJhc2U2NCBlbmNvZGVyLiBTaG93IG1lOiBALCBBLCBCLCBDLCBELCBFLCBGLCBHLCBILCBJLCBKLCBLLCBMLCBNLCBOLCBPLCBQLCBRLCBSLCBTLCBULCBVLCBWLCBXLCBYLCBZLCBaLCBbLCBcLCBdLCBeLCBfLCBgLCBhLCBiLCBjLCBkLCBlLCBmLCBnLCBoLCBpLCBqLCBrLCBsLCBtLCBuLCBvLCBwLCBxLCByLCBzLg==="
local b64_url_str = "U28_PHA-VGhpcyA0LCA1LCA2LCA3LCA4LCA5LCB6LCB7LCB8LCB9IHRlc3RzIEJhc2U2NCBlbmNvZGVyLiBTaG93IG1lOiBALCBBLCBCLCBDLCBELCBFLCBGLCBHLCBILCBJLCBKLCBLLCBMLCBNLCBOLCBPLCBQLCBRLCBSLCBTLCBULCBVLCBWLCBXLCBYLCBZLCBaLCBbLCBcLCBdLCBeLCBfLCBgLCBhLCBiLCBjLCBkLCBlLCBmLCBnLCBoLCBpLCBqLCBrLCBsLCBtLCBuLCBvLCBwLCBxLCByLCBzLg==="

assertMessage(
  eutf8.match(b64_gen_str, whole(mt._r.b.b64.gen)),
  b64_gen_str
)


assertMessage(
  eutf8.match(b64_url_str, whole(mt._r.b.b64.url)),
  b64_url_str
)

assertMessage(
  eutf8.match(b64_gen_str, whole(mt._r.b.b64.url)),
  nil
)

assertMessage(
  eutf8.match(b64_url_str, whole(mt._r.b.b64.gen)),
  nil
)

local b32_gen_str = "JBSWY3DPEBLW64TMMQ======"
local b32_crock_str = "JBSWY3DPEBLW64TMMQ===="

assertMessage(
  eutf8.match(b32_gen_str, whole(mt._r.b.b32.gen)),
  b32_gen_str
)

assertMessage(
  eutf8.match(b32_crock_str, whole(mt._r.b.b32.crockford)),
  b32_crock_str
)

assertMessage(
  eutf8.match(b32_gen_str, whole(mt._r.b.b32.crockford)),
  nil
)

assertMessage(
  eutf8.match(b32_crock_str, whole(mt._r.b.b32.gen)),
  nil
)

local issn = "1234-5679"
local isbn_cleaned = "9783161484100"
local uuid = "6ba7b810-9dad-11d1-80b4-00c04fd430c8"
local doi = "10.1000/182"
local doi_prefix = "https://doi.org/"

assertMessage(
  eutf8.match(issn, whole(mt._r.id.issn)),
  issn
)

assertMessage(
  eutf8.match(isbn_cleaned, whole(mt._r.id.isbn)),
  isbn_cleaned
)

assertMessage(
  eutf8.match(uuid, whole(mt._r.id.uuid)),
  uuid
)

assertMessage(
  eutf8.match(doi, whole(mt._r.id.doi)),
  doi
)

assertMessage(
  eutf8.match(doi_prefix, whole(mt._r.id.doi_prefix)),
  doi_prefix
)