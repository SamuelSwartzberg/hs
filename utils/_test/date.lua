local test_date = date("2013-02-03T09:56:22Z")

assertMessage(
  dateToRFC3339Precision(test_date, "hour"),
  date("2013-02-03T09:00:00Z")
)

assertMessage(
  dateToRFC3339Precision(test_date, "min"),
  date("2013-02-03T09:56:00Z")
)

assertMessage(
  dateToRFC3339Precision(test_date, "month"),
  date("2013-02-01T00:00:00Z")
)

assertValuesContainExactly(
  dateRange(test_date:copy():adddays(-3), test_date:copy():adddays(3)),
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
  dateRange(test_date:copy():addhours(-5), test_date:copy():addhours(4), 2, "hours"),
  {
    date("2013-02-03T04:56:22Z"),
    date("2013-02-03T06:56:22Z"),
    date("2013-02-03T08:56:22Z"),
    date("2013-02-03T10:56:22Z"),
    date("2013-02-03T12:56:22Z")
  }
)

assertMessage(
  processDateSpecification({}, test_date),
  test_date
)

assertMessage(
  processDateSpecification({ dt = test_date }, test_date),
  test_date
)

assertMessage(
  processDateSpecification({ unit = "days", amount = 1 }, test_date),
  test_date:adddays(1)
)

assertMessage(
  processDateSpecification({ unit = "days", amount = 1, precision = "hour" }, test_date),
  dateToRFC3339Precision(test_date:adddays(1), "hour")
)