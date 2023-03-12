
assertMessage(
  getViaOSA("js", '"hello world"'),
  "hello world"
)

assertMessage(
  getViaOSA("as", 'return "hello world"'),
  "hello world"
)