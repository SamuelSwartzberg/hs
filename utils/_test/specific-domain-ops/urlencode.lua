-- Test 1: Basic URL encoding
local test1 = urlencode("https://www.example.com/test url")
assertMessage(test1, "https%3A%2F%2Fwww.example.com%2Ftest+url")

-- Test 2: Spaces encoded as %20
local test2 = urlencode("https://www.example.com/test url", true)
assertMessage(test2, "https%3A%2F%2Fwww.example.com%2Ftest%20url")

-- Test 3: Spaces encoded as + (default behavior)
local test3 = urlencode("https://www.example.com/test url", false)
assertMessage(test3, "https%3A%2F%2Fwww.example.com%2Ftest+url")

-- Test 4: Special characters encoding
local test4 = urlencode("https://www.example.com/test?query=parameter&value=10")
assertMessage(test4, "https%3A%2F%2Fwww.example.com%2Ftest%3Fquery%3Dparameter%26value%3D10")