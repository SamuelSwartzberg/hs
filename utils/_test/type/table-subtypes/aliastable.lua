local test_saliastable = newAliastable({
  a = 1,
  foo = 2,
  ab = 3,
  foo_bar = 4,
}, "s")

assertMessage(
  test_saliastable.a,
  1
)

assertMessage(
  test_saliastable.aaa,
  nil
)

assertMessage(
  test_saliastable.f,
  2
)

assertMessage(
  test_saliastable.foo,
  2
)

assertMessage(
  test_saliastable.c,
  nil
)

assertMessage(
  test_saliastable.ab,
  3
)

assertMessage(
  test_saliastable.aaa_bbb,
  nil
)

assertMessage(
  test_saliastable.fb,
  4
)

assertMessage(
  test_saliastable.foo_bar,
  4
)

assertMessage(
  test_saliastable.aaa_bbb_ccc,
  nil
)

local test_laliastable = newAliastable({
  a = 1,
  foo = 2,
  c = 5,
  car = 6,
  ab = 3,
  foo_bar = 4,
  ccc_bbb = 7,
  cb = 8,
}, "l")

assertMessage(
  test_laliastable.a,
  1
)

assertMessage(
  test_laliastable.aaa,
  1
)

assertMessage(
  test_laliastable.f,
  nil
)

assertMessage(
  test_laliastable.foo,
  2
)

assertMessage(
  test_laliastable.c,
  5
)

assertMessage(
  test_laliastable.car,
  6
)

assertMessage(
  test_laliastable.ab,
  3
)

assertMessage(
  test_laliastable.afu_boo,
  3
)

assertMessage(
  test_laliastable.fb,
  nil
)

assertMessage(
  test_laliastable.foo_bar,
  4
)

assertMessage(
  test_laliastable.ccc_bbb,
  7
)

assertMessage(
  test_laliastable.cb,
  8
)