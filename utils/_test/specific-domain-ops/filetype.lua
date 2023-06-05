-- Test 1: Positive test for plaintext-table
local test1 = is.path.usable_as_filetype("example.csv", "plaintext-table")
assertMessage(test1, true)

-- Test 2: Negative test for plaintext-table
local test2 = is.path.usable_as_filetype("example.txt", "plaintext-table")
assertMessage(test2, false)

-- Test 3: Positive test for plaintext-dictionary
local test3 = is.path.usable_as_filetype("example.json", "plaintext-dictionary")
assertMessage(test3, true)

-- Test 4: Negative test for plaintext-dictionary
local test4 = is.path.usable_as_filetype("example.md", "plaintext-dictionary")
assertMessage(test4, false)