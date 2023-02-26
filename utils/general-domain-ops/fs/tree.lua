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
  for file in hs.fs.dir(path) do
    if file ~= "." and file ~= ".." and file ~= ".DS_Store" and usefulFileValidator(path)  then
      local full_path = path .. file
      if isDir(full_path) then 
        res[file] = fsTree(full_path, do_files, tree_files)
      else
        if do_files == "read" then 
          res[file] = readFile(full_path)
        elseif do_files == "append" then
          listPush(res, full_path)
        elseif do_files == "as-tree" then
          local nodename = getFilenameWithoutExtension(file)
          if stringy.endswith(file, ".yaml") and valueFindString(tree_files, "yaml") then
            res[nodename] = yamlLoad(readFile(full_path, "error"))
          elseif stringy.endswith(file, ".json") and valueFindString(tree_files, "json") then
            res[nodename] = json.decode(readFile(full_path, "error"))
          end
        end
      end
    end
  end
  return res
end