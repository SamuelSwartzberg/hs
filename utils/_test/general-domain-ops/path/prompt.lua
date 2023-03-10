--- @param path string
--- @param file? string
--- @return string
function promptPathChildren(path, file)
  return promptPipeline({
    {"dir", {prompt_args = {default = path}}},
    {"string-path", {prompt_args = {message = "Subdirectory name"}}, "pipeline"},
    file and {"string-filepath", {prompt_args = {message = "File name", default = file}}, "pipeline"},
  }) --[[ @as string ]]
end