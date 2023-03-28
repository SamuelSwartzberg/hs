local simple_json_command = 'echo "foo bar" | wc | jc --wc'

assertMessage(
  runJSON(simple_json_command),
  {{
    lines = 1.0,
    words = 2.0,
    filename = json.null,
    characters = 8.0
  }}
)

-- opt: accept_error_payload

assertMessage(
  runJSON({
    args = simple_json_command,
    accept_error_payload = true
  }),
  {{
    lines = 1.0,
    words = 2.0,
    filename = json.null,
    characters = 8.0
  }}
)

local simulate_error_json_command = 'echo "{ \\"error\\": \\"some error\\" }"'

assertMessage(
  runJSON({
    args = simulate_error_json_command,
    accept_error_payload = true
  }),
  {
    error = "some error"
  }
)

local succ, res = pcall(runJSON,{
  args = simulate_error_json_command,
  accept_error_payload = false
})

assertMessage(succ, false)

runJSON({
  args = simulate_error_json_command,
  accept_error_payload = false,
  json_catch = function(error)
    assertMessage(true, true)
  end
})

local succ, res = pcall(runJSON,{
  args = simulate_error_json_command,
  accept_error_payload = true,
  json_catch = function(error)
    assertMessage(true, true)
    return true -- trigger default error handler additionally
  end
})

assertMessage(succ, false)

-- opt: error_that_is_success

local succ, res = runJSON({
  args = simulate_error_json_command,
  error_that_is_success = "some error"
})

assertMessage(succ, true)

local succ, res = runJSON({
  args = simulate_error_json_command,
  error_that_is_success = "some other error"
})

assertMessage(succ, false)

runJSON({
  args = simulate_error_json_command,
  error_that_is_success = "some error",
  json_catch = function(error)
    assertMessage(true, true)
  end
})

-- opt: key_that_contains_payload

local with_payload_key_json_command = 'echo "{ \\"foo\\": \\"bar\\" }"'
local without_payload_key_json_command = 'echo "{ \\"notfoo\\": \\"bar\\" }"'

local succ, res = runJSON({
  args = with_payload_key_json_command,
  key_that_contains_payload = "foo"
})

assertMessage(succ, true)

assertMessage(res, "bar")

local succ, res = runJSON({
  args = without_payload_key_json_command,
  key_that_contains_payload = "foo"
})

assertMessage(succ, false)

runJSON({
  args = without_payload_key_json_command,
  key_that_contains_payload = "foo",
  json_catch = function(error)
    assertMessage(true, true)
  end
})