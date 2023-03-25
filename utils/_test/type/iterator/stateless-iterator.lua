-- Test data
local tbl = {10, 20, 30, 40, 50}
local emptyTbl = {}

-- Test ipairs
-- Test default
local manual_counter = 0
for i, v in ipairs(tbl) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(i, 1)
    assertMessage(v, 10)
  elseif manual_counter == 2 then
    assertMessage(i, 2)
    assertMessage(v, 20)
  elseif manual_counter == 3 then
    assertMessage(i, 3)
    assertMessage(v, 30)
  elseif manual_counter == 4 then
    assertMessage(i, 4)
    assertMessage(v, 40)
  elseif manual_counter == 5 then
    assertMessage(i, 5)
    assertMessage(v, 50)
  end
end

-- Test empty table
for i, v in ipairs(emptyTbl) do
  error("Should not iterate")
end

-- Test start and stop
local manual_counter = 0
for i, v in ipairs(tbl, 2, 4) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(i, 2)
    assertMessage(v, 20)
  elseif manual_counter == 2 then
    assertMessage(i, 3)
    assertMessage(v, 30)
  elseif manual_counter == 3 then
    assertMessage(i, 4)
    assertMessage(v, 40)
  end
end

-- Test step

local manual_counter = 0
for i, v in ipairs(tbl, 1, 5, 2) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(i, 1)
    assertMessage(v, 10)
  elseif manual_counter == 2 then
    assertMessage(i, 3)
    assertMessage(v, 30)
  elseif manual_counter == 3 then
    assertMessage(i, 5)
    assertMessage(v, 50)
  end
end

-- Test negative step

local manual_counter = 0
for i, v in ipairs(tbl, 5, 1, -2) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(i, 5)
    assertMessage(v, 50)
  elseif manual_counter == 2 then
    assertMessage(i, 3)
    assertMessage(v, 30)
  elseif manual_counter == 3 then
    assertMessage(i, 1)
    assertMessage(v, 10)
  end
end

-- Test ipairs on assoc arr (use key string equivalent order)

local assocArr = {a = 10, b = 20, c = 30, d = 40, e = 50}

local manual_counter = 0
for i, v in ipairs(assocArr) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(i, 1)
    assertMessage(v, 10)
  elseif manual_counter == 2 then
    assertMessage(i, 2)
    assertMessage(v, 20)
  elseif manual_counter == 3 then
    assertMessage(i, 3)
    assertMessage(v, 30)
  elseif manual_counter == 4 then
    assertMessage(i, 4)
    assertMessage(v, 40)
  elseif manual_counter == 5 then
    assertMessage(i, 5)
    assertMessage(v, 50)
  end
end

-- Test ipairs on assoc arr with start, stop, and negative step

local manual_counter = 0

for i, v in ipairs(assocArr, 1, 3, -2) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(i, 3)
    assertMessage(v, 30)
  elseif manual_counter == 2 then
    assertMessage(i, 1)
    assertMessage(v, 10)
  end
end

-- Test ipairs on ovtable (uses insertion order)

local test_ovtable = ovtable.init({
  {k = "e", v = 10},
  {k = "d", v = 20},
  {k = "c", v = 30},
  {k = "b", v = 40},
  {k = "a", v = 50},
})

local manual_counter = 0
for i, v in ipairs(test_ovtable) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(i, 1)
    assertMessage(v, 10)
  elseif manual_counter == 2 then
    assertMessage(i, 2)
    assertMessage(v, 20)
  elseif manual_counter == 3 then
    assertMessage(i, 3)
    assertMessage(v, 30)
  elseif manual_counter == 4 then
    assertMessage(i, 4)
    assertMessage(v, 40)
  elseif manual_counter == 5 then
    assertMessage(i, 5)
    assertMessage(v, 50)
  end
end

-- Test ipairs on ovtable with start, stop, and negative step

local manual_counter = 0
for i, v in ipairs(test_ovtable, 1, 3, -2) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(i, 3)
    assertMessage(v, 30)
  elseif manual_counter == 2 then
    assertMessage(i, 1)
    assertMessage(v, 10)
  end
end

-- test that revipairs is equivalent to ipairs with negative step

local manual_counter = 0
for i, v in revipairs(tbl) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(i, 5)
    assertMessage(v, 50)
  elseif manual_counter == 2 then
    assertMessage(i, 4)
    assertMessage(v, 40)
  elseif manual_counter == 3 then
    assertMessage(i, 3)
    assertMessage(v, 30)
  elseif manual_counter == 4 then
    assertMessage(i, 2)
    assertMessage(v, 20)
  elseif manual_counter == 5 then
    assertMessage(i, 1)
    assertMessage(v, 10)
  end
end

-- test pairs
-- test default on list

local manual_counter = 0
for k, v in pairs(tbl) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, 1)
    assertMessage(v, 10)
  elseif manual_counter == 2 then
    assertMessage(k, 2)
    assertMessage(v, 20)
  elseif manual_counter == 3 then
    assertMessage(k, 3)
    assertMessage(v, 30)
  elseif manual_counter == 4 then
    assertMessage(k, 4)
    assertMessage(v, 40)
  elseif manual_counter == 5 then
    assertMessage(k, 5)
    assertMessage(v, 50)
  end
end

-- test default on assoc arr

local manual_counter = 0
for k, v in pairs(assocArr) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, "a")
    assertMessage(v, 10)
  elseif manual_counter == 2 then
    assertMessage(k, "b")
    assertMessage(v, 20)
  elseif manual_counter == 3 then
    assertMessage(k, "c")
    assertMessage(v, 30)
  elseif manual_counter == 4 then
    assertMessage(k, "d")
    assertMessage(v, 40)
  elseif manual_counter == 5 then
    assertMessage(k, "e")
    assertMessage(v, 50)
  end
end

-- test default on ovtable

local manual_counter = 0
for k, v in pairs(test_ovtable) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, "e")
    assertMessage(v, 10)
  elseif manual_counter == 2 then
    assertMessage(k, "d")
    assertMessage(v, 20)
  elseif manual_counter == 3 then
    assertMessage(k, "c")
    assertMessage(v, 30)
  elseif manual_counter == 4 then
    assertMessage(k, "b")
    assertMessage(v, 40)
  elseif manual_counter == 5 then
    assertMessage(k, "a")
    assertMessage(v, 50)
  end
end

-- test pairs with start, stop, and negative step on assoc arr

local manual_counter = 0
for k, v in pairs(assocArr, 1, 3, -2) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, "c")
    assertMessage(v, 30)
  elseif manual_counter == 2 then
    assertMessage(k, "a")
    assertMessage(v, 10)
  end
end

-- test pairs with negative step on ovtable

local manual_counter = 0
for k, v in pairs(test_ovtable, 1, 5, -2) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, "a")
    assertMessage(v, 50)
  elseif manual_counter == 2 then
    assertMessage(k, "c")
    assertMessage(v, 30)
  elseif manual_counter == 3 then
    assertMessage(k, "e")
    assertMessage(v, 10)
  end
end

-- test that revpairs with positive step is equivalent to pairs with negative step

local manual_counter = 0
for k, v in revpairs(test_ovtable, 1, 5, 2) do
  manual_counter = manual_counter + 1
  if manual_counter == 1 then
    assertMessage(k, "a")
    assertMessage(v, 50)
  elseif manual_counter == 2 then
    assertMessage(k, "c")
    assertMessage(v, 30)
  elseif manual_counter == 3 then
    assertMessage(k, "e")
    assertMessage(v, 10)
  end
end

-- test iterToTbl


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