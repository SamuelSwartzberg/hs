--- take all json files in sources and build a json server db from them, such that each source is a route on json server
--- @param path string
function buildJsonServerDbFromSources(path)
  local sources = hybridFsDictFileTreeToTable(path .. "/sources", true)
  writeFile(path .. "/db.json", json.encode(sources))
end

--- @param tcp_port string|integer
--- @return string
function getTcpPortUrl(tcp_port)
  return "http://localhost:" .. tcp_port
end

--- @param tcp_port string|integer
--- @return string
function getPIDatTcpPort(tcp_port)
  local pid = getOutputArgsSimple("lsof", "-t", "-i:" .. tcp_port)
  return pid
end

--- @param tcp_port string|integer
--- @param do_after? function
function killAtTcpPort(tcp_port, do_after)
  runHsTask({
    "kill",
    { value = {"lsof", "-t", "-i:" .. tcp_port}, type = "interpolated"}
  }, do_after)
end

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
    buildJsonServerDbFromSources(path)
    args({
      "mockrs",
      "serve",
      "--port=" .. tcp_port,
      path .. "/db.json"
    })
  else
    error("type must be 'http' or 'json'")
  end
  local preexisting_server_with_same_args = taskmanager:get("find-by-args", args)
  if preexisting_server_with_same_args then
    preexisting_server_with_same_args:doThis("recreate")
  else
    taskmanager:doThis("create", args)
  end
end