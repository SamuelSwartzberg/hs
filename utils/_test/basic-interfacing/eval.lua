-- test singleLe:

-- test simple expressions

assertMessage(
  singleLe("1"),
  1
)

assertMessage(
  singleLe("2 * 3"),
  6
)

-- test that _G injection works

assertMessage(
  singleLe("env.HOME"),
  env.HOME
)

-- test statements

assertMessage(
  singleLe([[
    local foo = 1
    if (true) {
      foo = foo + 1;
    } else {
      return 27;
    }
    return foo;
  ]]),
  2
)


-- test le:

-- no interpolation

assertMessage(
  le("Foo bar baz"),
  "Foo bar baz"
)

-- simple interpolation

assertMessage(
  le("I got {{[ 11 * 9 ]}} problems, but lack of {{[ 'interpolation' ]}} ain't one"),
  "I got 99 problems, but lack of interpolation ain't one"
)

-- interpolation with statements

assertMessage(
  le([[
    Lines: 

    {{[
      for i = 1, 10 do
        print(i)
      end
      _G.injectionstore = 27
    ]}}

    Value in injectionstore: {{[ injectionstore ]}}
  ]]),
  [[
    Lines: 

    1
    2
    3
    4
    5
    6
    7
    8
    9
    10

    Value in injectionstore: 27
  ]]
)