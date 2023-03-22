local stringdefaultops =  defaultOpts("foo")

assertMessage(
  stringdefaultops.args,
  {"f", "o", "o"}
)

assertMessage(
  stringdefaultops.ret,
  {"f", "o", "o"}
)

local listdefaultops =  defaultOpts({"foo", "bar"})

assertMessage(
  listdefaultops.args,
  {"f", "o", "o"}
)

assertMessage(
  listdefaultops.ret,
  {"b", "a", "r"}
)

local listdefaultopslen1 =  defaultOpts({"foo"})

assertMessage(
  listdefaultopslen1.args,
  {"f", "o", "o"}
)

assertMessage(
  listdefaultopslen1.ret,
  {"v"} -- default
)

local listdefaultopslen0 =  defaultOpts({})


assertMessage(
  listdefaultopslen0.args,
  {"v"} -- default
)

assertMessage(
  listdefaultopslen0.ret,
  {"v"} -- default
)

local tblops =  defaultOpts({args = "foo", ret = "bar"})

assertMessage(
  tblops.args,
  {"f", "o", "o"}
)

assertMessage(
  tblops.ret,
  {"b", "a", "r"}
)

local booleanops = defaultOpts("boolean")

assertMessage(
  booleanops.args,
  {"b", "o", "o", "l", "e", "a", "n"}
)

assertMessage(
  booleanops.ret,
  "boolean" -- boolean is only special for ret
)

assertMessage(
  getEmptyResult({1, 2, 3}, {}).revpairs,
  nil
)

assertMessage(
  getEmptyResult("whatever", {tolist = true}),
  {}
)

assertMessage(
  getEmptyResult("whatever", {noovtable = true}),
  {}
)

assertMessage(
  getEmptyResult(ovtable.init({{"foo", "bar"}}), {noovtable = false}).revpairs,
  ovtable.revpairs
)

assertMessage(
  getArgs(
    "key",
    "val",
    {
      args = {"k"},
    }
  ),
  {"key"}
)

assertMessage(
  getArgs(
    "key",
    "val",
    {
      args = {"v"},
    }
  ),
  {"val"}
)

assertMessage(
  getArgs(
    "key",
    "val",
    {
      args = {"k", "v", "k", "k", "v", "v"},
    }
  ),
  {"key", "val", "key", "key", "val", "val"}
)

local succ, res = pcall(getDefaultInput,false)

assertMessage(
  succ,
  false
)

assertMessage(
  getDefaultInput("string"),
  "string"
)

assertMessage(
  getIsLeaf(false)({1, 2}),
  false
)

assertMessage(
  getIsLeaf(false)({a = 1, b = 2}),
  false
)

assertMessage(
  getIsLeaf("assoc")({1, 2}),
  false
)

assertMessage(
  getIsLeaf("assoc")({a = 1, b = 2}),
  true
)

assertMessage(
  getIsLeaf("list")({1, 2}),
  true
)

assertMessage(
  getIsLeaf("list")({a = 1, b = 2}),
  false
)

assertMessage(
  addToRes({"itemreskey", "itemresval"}, {}, {ret = {"k", "v"}}, "origkey", "origval"),
  {itemreskey = "itemresval"}
)

assertMessage(
  addToRes({"itemreskey", "itemresval"}, {}, {ret = {"k"}}, "origkey", "origval"),
  {itemreskey = "origval"}
)

assertMessage(
  addToRes({"itemreskey", "itemresval"}, {}, {ret = {"discard", "v"}}, "origkey", "origval"),
  {origkey = "itemresval"}
)

assertMessage(
  addToRes({"itemreskey", "itemreskey"}, {}, {ret = {"k", "v"}}, "origkey", "origval"),
  {itemreskey = "itemreskey"}
)

assertMessage(
  addToRes({"itemresval", "itemresval"}, {}, {ret = {"k", "v"}}, "origkey", "origval"),
  {itemresval = "itemresval"}
)

assertMessage(
  addToRes({"itemreskey", "itemresval"}, {}, {ret = {"k", "v"}, tolist = true}, "origkey", "origval"),
  {"itemresval"}
)

assertMessage(
  addToRes({false, "itemresval"}, {}, {ret = {"k", "v"}}, "origkey", "origval"),
  {"itemresval"}
)

assertMessage(
  addToRes({"itemreskey", "itemresval"}, {itemreskey = "priorval"}, {ret = {"k", "v"}}, "origkey", "origval"),
  {itemreskey = "itemresval"}
)

assertMessage(
  addToRes({"itemreskey", "itemresval"}, {itemreskey = "priorval"}, {ret = {"k", "v"}, nooverwrite = true}, "origkey", "origval"),
  {itemreskey = "priorval"}
)

-- key is nil 

assertMessage(
  addToRes({nil, "itemresval"}, {}, {ret = {"k", "v"}}, "origkey", "origval"),
  {}
)

-- val is nil

assertMessage(
  addToRes({"itemreskey", nil}, {}, {ret = {"k", "v"}}, "origkey", "origval"),
  {}
)