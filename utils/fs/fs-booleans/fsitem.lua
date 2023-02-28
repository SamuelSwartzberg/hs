--- @param path string
--- @return boolean
function isDir(path)
  path = resolveTilde(path)
  local remote = pathIsRemote(path)

  if not remote then
    return not not hs.fs.chdir(path)
  else 
    local output, status, reason, code = getOutputTask({"rclone", "lsjson", "--stat", {value = path, type = "quoted"}})
    if status then
      local succ, parsed = pcall(json.decode, output)
      if succ then
        return parsed.IsDir
      else
        return false
      end
    else
      return false
    end
  end
end

--- @param str string
--- @return boolean
function looksLikePath(str)
  return 
    str:find("/") ~= nil
    and str:find("[\n\t\r\f]") == nil
    and str:find("^%s") == nil
    and str:find("%s$") == nil
end

--- @param str string
--- @return boolean
function hasNoExtension(str)
  return str:find("%.") == nil
end

--- @param path string
--- @return boolean
function pathHasExtension(path)
  return not hasNoExtension(pathSlice(path, "-1:-1")[1])
end

local rrq = bindArg(relative_require, "utils.fs.fs-booleans")
local filetype_list = rrq("filetype-list")

--- @param str string
--- @param filetype string
--- @return boolean
function isUsableAsFiletype(str, filetype)
  local extension = getStandartizedExtension(str) or ""
  if valuesContain(filetype_list[filetype], extension) then
    return true
  else
    return false
  end
end


--- Evaluates whether a path exists
--- @param path string The path to the directory
--- @return boolean #Whether the path exists
function pathExists(path)
  path = resolveTilde(path)
  local remote = pathIsRemote(path)

  if not remote then
    local file = io.open(path, "r")
    if file ~= nil then
      io.close(file)
      return true
    else
      return false
    end
  else
    local output, status, reason, code = getOutputTask({"rclone", "ls", {value = path, type = "quoted"}})
    return status
  end
end

local non_user_useful_files = {".git", "node_modules", ".vscode"}

--- @param file_name string
--- @return boolean
function usefulFileValidator(file_name)
  return allValuesPass(non_user_useful_files, function(non_user_useful_file)
    return not stringy.endswith(file_name, non_user_useful_file)
  end)
end

--- @param path string
--- @param start string
--- @param name string
--- @param extension string
--- @return boolean
function pathHasStartFilenameExtension(path, start, name, extension)
  local regex = "^" .. replace(start, "regex") .. "/.*/" .. replace(name, "regex") .. "." .. replace(extension, "regex") .. "$"
  return not not eutf8.find(path, regex)
end


local non_plaintext_extensions = { -- extensions where we can be sure that the file is not plaintext
  "jpg", "jpeg", "png", "gif", "pdf", "mp3", "mp4", "mov", "avi", "zip", "gz", 
  "tar", "tgz", "rar", "7z", "dmg", "exe", "app", "pkg", "m4a", "wav", "doc", 
  "docx", "xls", "xlsx", "ppt", "pptx", "psd", "ai", "mpg", "mpeg", "flv", "swf",
  "sketch", "db", "sql", "sqlite", "sqlite3", "sqlitedb", "odt", "odp", "ods", 
  "odg", "odf", "odc", "odm", "odb", "jar", "pyc",
} 

--- @param path string
--- @return boolean
function isPlaintextFile(path)
  for _, extension in ipairs(non_plaintext_extensions) do
    if stringy.endswith(path, "." .. extension) then
      return false
    end
  end
  return true
end

