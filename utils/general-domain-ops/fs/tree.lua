--- @alias NodeSpecifier { [string]: NodeSpecifier | string }


--- @param path string
--- @param do_files? "read" | "append" | "as-tree"
--- @param tree_files? ("json" | "yaml")[]
--- @return NodeSpecifier
function fsTree(path, do_files, tree_files)
  do_files = do_files or "read"
  tree_files = tree_files or {"json", "yaml"}
  local res = {}
  path = get.string.with_suffix_string(path, "/")
  for _,full_path in transf.array.index_value_stateless_iter(itemsInPath(path)) do
    local file = transf.path.leaf(full_path)
    if is.absolute_path.dir(full_path) then 
      res[file] = fsTree(full_path, do_files, tree_files)
    else
      if do_files == "read" then 
        res[file] = transf.file.contents(full_path)
      elseif do_files == "append" then
        dothis.array.push(res, full_path)
      elseif do_files == "as-tree" then
        local nodename = pathSlice(file, "-2:-2", { ext_sep = true })[1]
        if stringy.endswith(file, ".yaml") and find(tree_files, "yaml") then
          res[nodename] = transf.yaml_string.not_userdata_or_function(transf.file.contents(full_path, "error"))
        elseif stringy.endswith(file, ".json") and find(tree_files, "json") then
          res[nodename] = json.decode(transf.file.contents(full_path, "error"))
        end
      end
    end

  end
  return res
end