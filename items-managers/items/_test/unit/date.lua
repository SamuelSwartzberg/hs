local test_date_1 = date("2021-05-07T12:08:25")
local test_date_item_1 = CreateDate(test_date_1:copy())

assertMessage(
  test_date_item_1:get("contents"),
  test_date_1
)

assertMessage(
  test_date_item_1:get("with-added", {
    unit = "years",
    amount = 1
  }):get("contents"),
  test_date_1:copy():addyears(1)
)

assertMessage(
  test_date_item_1:get("with-subtracted", {
    unit = "years",
    amount = 1
  }):get("contents"),
  test_date_1:copy():addyears(-1)
)

assertMessage(
  test_date_item_1:get("val", "year"),
  test_date_1:getyear()
)

assertMessage(
  test_date_item_1:get("diff-span", {
    unit = "days",
    ["end"] = test_date_1:copy():adddays(8)
  }),
  -8
)

assertMessage(
  test_date_item_1:get("start-end", {
    start = { dt = test_date_1:copy():adddays(-1) },
    ["end"] = { dt = test_date_1:copy():adddays(1) }
  }),
  {
    test_date_1:copy():adddays(-1),
    test_date_1:copy():adddays(1)
  }
)

assertMessage(
  test_date_item_1:get("start-end", {
    ["end"] = { unit = "days", amount = 1 }
  }),
  {
    test_date_1:copy(),
    test_date_1:copy():adddays(1)
  }
)

assertMessage(
  test_date_item_1:get("start-end", {
    ["end"] = { unit = "hours", amount = 1,precision = "min" },
    
  }),
  {
    test_date_1:copy(),
    test_date_1:copy():addhours(1):setseconds(0)
  }
)

assertMessage(
  test_date_item_1:get("range", {
    start = { dt = test_date_1:copy():addhours(-4) },
    unit = "hours"
  }),
  {
    test_date_1:copy():addhours(-4),
    test_date_1:copy():addhours(-3),
    test_date_1:copy():addhours(-2),
    test_date_1:copy():addhours(-1),
    test_date_1:copy(),
  }
)

local time_cleaned_test_date_1 = test_date_1:copy():sethours(0):setminutes(0):setseconds(0)

assertMessage(
  test_date_item_1:get("hours-in-day-range"),
  {
    time_cleaned_test_date_1:copy():addhours(0),
    time_cleaned_test_date_1:copy():addhours(1),
    time_cleaned_test_date_1:copy():addhours(2),
    time_cleaned_test_date_1:copy():addhours(3),
    time_cleaned_test_date_1:copy():addhours(4),
    time_cleaned_test_date_1:copy():addhours(5),
    time_cleaned_test_date_1:copy():addhours(6),
    time_cleaned_test_date_1:copy():addhours(7),
    time_cleaned_test_date_1:copy():addhours(8),
    time_cleaned_test_date_1:copy():addhours(9),
    time_cleaned_test_date_1:copy():addhours(10),
    time_cleaned_test_date_1:copy():addhours(11),
    time_cleaned_test_date_1:copy():addhours(12),
    time_cleaned_test_date_1:copy():addhours(13),
    time_cleaned_test_date_1:copy():addhours(14),
    time_cleaned_test_date_1:copy():addhours(15),
    time_cleaned_test_date_1:copy():addhours(16),
    time_cleaned_test_date_1:copy():addhours(17),
    time_cleaned_test_date_1:copy():addhours(18),
    time_cleaned_test_date_1:copy():addhours(19),
    time_cleaned_test_date_1:copy():addhours(20),
    time_cleaned_test_date_1:copy():addhours(21),
    time_cleaned_test_date_1:copy():addhours(22),
    time_cleaned_test_date_1:copy():addhours(23),
    time_cleaned_test_date_1:copy():addhours(24),
  }
)