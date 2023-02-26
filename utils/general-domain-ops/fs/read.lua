
--- @alias readFileResult fun(path: string, mode?: "nil"): string | nil
--- @alias readFileOrError fun(path: string, mode: "error"): string

--- @type readFileResult | readFileOrError
function readFile(path, mode)
  path = resolveTilde(path)
  mode = mode or "nil"
  local path_is_remote = pathIsRemote(path)
  if not path_is_remote then 
    local file = io.open(path, "r")
    if file ~= nil then
      local contents = file:read("*a")
      io.close(file)
      return contents
    else
      if mode == "error" then
        error("Could not read file: " .. path)
      else
        return nil
      end
    end
  else
    local opts = {
      args = {"rclone", "cat", {value = path, type = "quoted"}},
      catch = function()
        return mode == "error" -- if catch returns true, then the default error handler will be called, which will error, which is what we want
      end,
    }
    return run(opts)
  end
end