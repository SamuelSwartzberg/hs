assertMessage(
  clamp(4, 2, 6),
  4
)

assertMessage(
  clamp(1, 2, 6),
  2
)

assertMessage(
  clamp(7, 2, 6),
  6
)

assertMessage(
  clamp("d", "b", "f"),
  "d"
)

assertMessage(
  clamp("a", "b", "f"),
  "b"
)

assertMessage(
  clamp("g", "b", "f"),
  "f"
)

assertMessage(
  clamp("ee", "b", "f"),
  "ee"
)

assertMessage(
  clamp("aa", "b", "f"),
  "b"
)

assertMessage(
  clamp(hs.geometry.point(4, 4), hs.geometry.point(2, 2), hs.geometry.point(6, 6)),
  hs.geometry.point(4, 4)
)

assertMessage(
  clamp(hs.geometry.point(1, 1), hs.geometry.point(2, 2), hs.geometry.point(6, 6)),
  hs.geometry.point(2, 2)
)

assertMessage(
  clamp(hs.geometry.point(7, 7), hs.geometry.point(2, 2), hs.geometry.point(6, 6)),
  hs.geometry.point(6, 6)
)

local three_days_ago = date():adddays(-3)
local three_days_from_now = date():adddays(3)
local two_days_ago = date():adddays(-2)
local two_days_from_now = date():adddays(2)

local now = date()

assertMessage(
  clamp(now, two_days_ago, two_days_from_now),
  now
)

assertMessage(
  clamp(three_days_ago, two_days_ago, two_days_from_now),
  two_days_ago
)

assertMessage(
  clamp(three_days_from_now, two_days_ago, two_days_from_now),
  two_days_from_now
)

assertMessage(
  isClose(1, 2, 0.99),
  false
)

assertMessage(
  isClose(1, 2, 1.01),
  true
)

assertMessage(
  isClose(hs.geometry.point(1, 1), hs.geometry.point(2, 2), hs.geometry.point(0.99, 0.99)),
  false
)

assertMessage(
  isClose(hs.geometry.point(1, 1), hs.geometry.point(2, 2), hs.geometry.point(1.01, 1.01)),
  true
)

assertMessage(
  seq(1, 5),
  {1, 2, 3, 4, 5}
)

assertMessage(
  seq(1, 5, 2),
  {1, 3, 5}
)

assertMessage(
  seq("a", "e"),
  {"a", "b", "c", "d", "e"}
)

assertMessage(
  seq("a", "e", 2),
  {"a", "c", "e"}
)

assertMessage(
  seq(
    hs.geometry.point(1, 1),
    hs.geometry.point(5, 5)
  ),
  {
    hs.geometry.point(1, 1),
    hs.geometry.point(2, 2),
    hs.geometry.point(3, 3),
    hs.geometry.point(4, 4),
    hs.geometry.point(5, 5),
  }
)

assertMessage(
  seq(
    hs.geometry.point(1, 1),
    hs.geometry.point(5, 5),
    hs.geometry.point(2, 2)
  ),
  {
    hs.geometry.point(1, 1),
    hs.geometry.point(3, 3),
    hs.geometry.point(5, 5),
  }
)

local test_date = date("2013-02-03T09:56:22Z")

assertMessage(
  seq(test_date:copy():adddays(-3), test_date:copy():adddays(3)),
  {
    date("2013-01-31T09:56:22Z"),
    date("2013-02-01T09:56:22Z"),
    date("2013-02-02T09:56:22Z"),
    date("2013-02-03T09:56:22Z"),
    date("2013-02-04T09:56:22Z"),
    date("2013-02-05T09:56:22Z"),
    date("2013-02-06T09:56:22Z"),
  }
)

assertMessage(
  seq(test_date:copy():addhours(-5), test_date:copy():addhours(4), 2, "hours"),
  {
    date("2013-02-03T04:56:22Z"),
    date("2013-02-03T06:56:22Z"),
    date("2013-02-03T08:56:22Z"),
    date("2013-02-03T10:56:22Z"),
    date("2013-02-03T12:56:22Z")
  }
)