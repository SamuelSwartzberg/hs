assertMessage(
  queryPage({
    url = "https://example.com",
    selector = "h1"
  }),
  "<h1>Example Domain</h1>"
)

-- run twice since it uses memoization internally and I need to test if it's working

assertMessage(
  queryPage({
    url = "https://example.com",
    selector = "h1"
  }),
  "<h1>Example Domain</h1>"
)

assertMessage(
  queryPage({
    url = "https://example.com",
    selector = "h1",
    only_text = true
  }),
  "Example Domain"
)