-- Test data
local tbl = {10, 20, 30, 40, 50}
local emptyTbl = {}

-- Test ipairs
-- Test default start and stop
local result = {}
for i, v in ipairs(tbl) do
  table.insert(result, v)
end
assertMessage(result, tbl, "ipairs with default start and stop failed")

-- Test empty table
result = {}
for i, v in ipairs(emptyTbl) do
  table.insert(result, v)
end
assertMessage(result, emptyTbl, "ipairs with empty table failed")

-- Test ipairs
-- Test start and stop
result = {}
for i, v in ipairs(tbl, 2, 4) do
  result[i] = v
end
assertMessage(result, { nil, 20, 30, 40 }, "ipairs with start and stop failed")

-- Test revipairs
-- Test default start and stop
result = {}
for i, v in revipairs(tbl) do
  result[i] = v
end
assertMessage(result, tbl, "revipairs with default start and stop failed")

-- Test start and stop
result = {}
for i, v in revipairs(tbl, 2, 4) do
  result[i] = v
end
assertMessage(result,  { nil, 20, 30, 40 }, "revipairs with start and stop failed")

-- Test empty table
result = {}
for i, v in revipairs(emptyTbl) do
  result[i] = v
end
assertMessage(result, emptyTbl, "revipairs with empty table failed")

assertMessage(
  iterToTbl({tolist=true, ret="v"},string.gmatch("abc", ".")),
  { "a", "b", "c" }
)

assertMessage(
  iterToTbl({tolist=true, ret="v"},string.gmatch("abc", "d")),
  {}
)

assertMessage(
  iterToTbl({noovtable=true},ipairs({"a", "b", "c"})),
  { "a", "b", "c" }
)

assertMessage(
  iterToTbl(pairs({a = "a", b = "b", c = "c"})),
  { a = "a", b = "b", c = "c" }
)