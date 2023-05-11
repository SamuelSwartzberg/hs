--- @param type "http" | "json"
--- @param tcp_port string|integer
--- @param path string
function serve(type, tcp_port, path)
  local taskmanager = System:get("manager", "task")
  local args
  if type == "http" then
     args = {
      "http-server",
      "-a",
      "127.0.0.1",
      "-p",
      tcp_port,
      "-c60",
      path
    }
  elseif type == "json" then 
    args = {
      "jcwserve",
      "-p",
      tcp_port
    }
  else
    error("type must be 'http' or 'json'")
  end
  local preexisting_server_with_same_args = taskmanager:get("find-by-specifier", args)
  if preexisting_server_with_same_args then
    preexisting_server_with_same_args:doThis("recreate")
  else
    taskmanager:doThis("create", args)
  end
end