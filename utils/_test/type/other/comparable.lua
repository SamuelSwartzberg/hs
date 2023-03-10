local test_date = date("2013-02-03T09:56:22Z")

assertValuesContainExactly(
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

assertValuesContainExactly(
  seq(test_date:copy():addhours(-5), test_date:copy():addhours(4), 2, "hours"),
  {
    date("2013-02-03T04:56:22Z"),
    date("2013-02-03T06:56:22Z"),
    date("2013-02-03T08:56:22Z"),
    date("2013-02-03T10:56:22Z"),
    date("2013-02-03T12:56:22Z")
  }
)

assertValuesContainExactly(
  seq(1, 5),
  {1, 2, 3, 4, 5}
)

assertValuesContainExactly(
  seq(1, 5, 2),
  {1, 3, 5}
)

assertMessage(
  isClose(1, 1.1, 0.2),
  true
)

assertMessage(
  isClose(1, 2, 0.1),
  false
)