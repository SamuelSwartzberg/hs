local identifier = createIdentifier()

local identifier_of_string = identifier("foo")
local temp_table = {}
local identifier_of_table = identifier(temp_table)
local identifier_of_table_again = identifier(temp_table)
local identifier_of_table_same_shape = identifier({})
local temp_fn = function() end
local identifier_of_function = identifier(temp_fn)
local identifier_of_function_again = identifier(temp_fn)
local identifier_of_function_same_shape = identifier(function() end)

assert(identifier_of_string ~= identifier_of_table)
assert(identifier_of_table == identifier_of_table_again)
assert(identifier_of_table ~= identifier_of_table_same_shape)

assert(identifier_of_function == identifier_of_function_again)
assert(identifier_of_function ~= identifier_of_function_same_shape)
