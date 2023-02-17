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

--- @param tcp_port string|integer
--- @param path string
function runJsonServerAtPort(tcp_port, path)
  buildJsonServerDbFromSources(path)
  killAtTcpPort(tcp_port, function ()
    runHsTask({
      "mockrs",
      "serve",
      "--port=" .. tcp_port,
      path .. "/db.json"
    })
  end)
end