local frontmost_application = hs.application.frontmostApplication()

doWithActivated("TextEdit", function()
  assertMessage(
    hs.application.frontmostApplication():name(),
    "TextEdit"
  )
end)

assertMessage(
  hs.application.frontmostApplication():name(),
  "TextEdit"
)

frontmost_application:activate()

doWithActivated("TextEdit", function()
  assertMessage(
    hs.application.frontmostApplication():name(),
    "TextEdit"
  )
end, true)

assertMessage(
  hs.application.frontmostApplication():name(),
  frontmost_application:name()
)