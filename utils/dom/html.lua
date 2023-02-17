local rrq = bindArg(relative_require, "utils.dom")

htmlEntities = rrq("html-entities")

--- @param url string
--- @param selector string
--- @param only_text boolean
--- @return string
function querySelector(url, selector, only_text)
  return getOutputArgsSimple(
    "curl",
    "-Ls",
    { value = url, type = "quoted"},
    "|",
    "htmlq",
    only_text and "--text" or nil,
    { value = selector, type = "quoted" }
  )
end
 