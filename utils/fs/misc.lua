function resolveTilde(path)
  return path:gsub("^~", env.HOME)
end

--- @param list_of_paths string[]
--- @return string
function commonAncestorPath(list_of_paths)
  local list_of_path_components = mapValueNewValue(list_of_paths, function(path)
    return stringy.split(path, "/")
  end)
  local common_path_components = listOfListsGetCommonBeginningElements(list_of_path_components)
  return "/" .. table.concat(common_path_components, "/")
end

--- @param path string
--- @return string
function filesize(path)
  return hs.fs.attributes(path, "size")
end

--- @alias NodeSpecifier { [string]: NodeSpecifier | string }

--- @param path string
--- @return NodeSpecifier
function fsTreeToContentsTable(path)
  local res = {}
  path = ensureAdfix(path, "/", true, false, "suf")
  for file in hs.fs.dir(path) do
    if file ~= "." and file ~= ".." and file ~= ".DS_Store" and usefulFileValidator(path)  then
      local full_path = path .. file
      if isDir(full_path) then 
        res[file] = fsTreeToContentsTable(full_path)
      else
        res[file] = readFile(full_path)
      end
    end
  end
  return res
end

--- @param path string
--- @return NodeSpecifier
function fsTreeToPathTable(path)
  local res = {}
  path = ensureAdfix(path, "/", true, false, "suf")
  for file in hs.fs.dir(path) do
    if file ~= "." and file ~= ".." and file ~= ".DS_Store" and usefulFileValidator(path)  then
      local full_path = path .. file
      if isDir(full_path) then 
        res[file] = fsTreeToPathTable(full_path)
      else
        listPush(res, full_path)
      end
    end
  end
  return res
end

--- @param path string
--- @param also_include_json? boolean
--- @return NodeSpecifier
function hybridFsDictFileTreeToTable(path, also_include_json)
  local res = {}
  path = ensureAdfix(path, "/", true, false, "suf")
  for file in hs.fs.dir(path) do
    if file ~= "." and file ~= ".." and file ~= ".DS_Store" and usefulFileValidator(path) then
      local full_path = path .. file
      local nodename = getFilenameWithoutExtension(file)
      if isDir(full_path) then 
        res[nodename] = hybridFsDictFileTreeToTable(full_path, also_include_json)
      elseif stringy.endswith(file, ".yaml") then
        res[nodename] = yamlLoad(readFile(full_path, "error"))
      elseif also_include_json and stringy.endswith(file, ".json") then
        res[nodename] = json.decode(readFile(full_path, "error"))
      else
        res[nodename] = readFile(full_path, "error")
      end
    end
  end
  return res
end

--- @param path string
--- @return string
function asAttach(path)
  local mimetype = mimetypes.guess(path) or "text/plain"
  return "#" .. mimetype .. " " .. path
end

--- @param specifier { source: string, target?: string, target_ext?: string }
--- @return string, string
function getSourceAndTarget(specifier)
  local source = specifier.source
  local target
  if specifier.target then
    target = specifier.target
  else
    local raw_path = getPathWithoutExtension(source)
    target = raw_path .. (specifier.target_ext or ".pdf")
  end
---@diagnostic disable-next-line: return-type-mismatch
  return source, target
end


--- @param path string
--- @param prefix? string
function resolveRelativePath(path, prefix)
  prefix = prefix or ""
  prefix = ensureAdfix(prefix, "/", false, false, "suf") -- ensure no trailing slash
  local preprefix = ""
  if pathIsRemote(path) then
    preprefix, path = path:match("^([^/:]-:)(.*)$")
  end
  path = ensureAdfix(path, "/", true, false, "pre") -- ensure leading slash
  if stringy.startswith(path, prefix) then
    prefix = ""
  end
  return preprefix .. prefix .. path
end