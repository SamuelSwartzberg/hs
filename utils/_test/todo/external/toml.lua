local tomlStr = [[
a = 1275892
b = 'Hello, World!'
c = true
d = 124.2548

[e]
f = [ 2, 3, '4', 5.5 ]
g = "1979-05-27"
]]

local decoded_toml = toml.decode(tomlStr)

assertMessage(decoded_toml.a, 1275892)
assertMessage(decoded_toml.b, 'Hello, World!')
assertMessage(decoded_toml.c, true)
assertMessage(decoded_toml.d, 124.2548)
assertValuesContainExactly(decoded_toml.e.f, { 2, 3, '4', 5.5 })
assertMessage(decoded_toml.e.g, '1979-05-27')

local encoded_toml = toml.encode(decoded_toml)
local redecoded_toml = toml.decode(encoded_toml)

assertMessage(redecoded_toml.a, 1275892)
assertMessage(redecoded_toml.b, 'Hello, World!')
assertMessage(redecoded_toml.c, true)
assertMessage(redecoded_toml.d, 124.2548)
assertValuesContainExactly(redecoded_toml.e.f, { 2, 3, '4', 5.5 })
assertMessage(redecoded_toml.e.g, '1979-05-27')

local tomlAsJson = toml.toJSON(tomlStr)
local jsonBackToToml = json.decode(tomlAsJson)

assertMessage(jsonBackToToml.b, 'Hello, World!')
assertMessage(jsonBackToToml.c, true)
assertMessage(jsonBackToToml.e.g, '1979-05-27')