--- @alias NodeSpecifier { [string]: NodeSpecifier | string }


--- @param path string
--- @param do_files? "read" | "append" | "as-tree"
--- @param tree_files? ("json" | "yaml")[]
--- @return NodeSpecifier
function fsTree(path, do_files, tree_files)
  do_files = do_files or "read"
  tree_files = tree_files or {"json", "yaml"}
  local res = {}
  path = ensureAdfix(path, "/", true, false, "suf")
  for _,full_path in ipairs(itemsInPath(path)) do
    local file = pathSlice(full_path, "-1:-1")[1]
    if testPath(full_path, "dir") then 
      res[file] = fsTree(full_path, do_files, tree_files)
    else
      if do_files == "read" then 
        res[file] = readFile(full_path)
      elseif do_files == "append" then
        push(res, full_path)
      elseif do_files == "as-tree" then
        local nodename = pathSlice(file, "-2:-2", { ext_sep = true })[1]
        if stringy.endswith(file, ".yaml") and find(tree_files, "yaml") then
          res[nodename] = yamlLoad(readFile(full_path, "error"))
        elseif stringy.endswith(file, ".json") and find(tree_files, "json") then
          res[nodename] = json.decode(readFile(full_path, "error"))
        end
      end
    end

  end
  return res
end