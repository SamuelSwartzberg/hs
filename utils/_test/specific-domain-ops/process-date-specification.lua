
local test_date = date("2013-02-03T09:56:22Z")


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
  test_date:copy():adddays(1)
)
