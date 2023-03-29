function BuildIPCSocket(name)
  local ipc_socket = { id = name or rand({len=10}) }

  function ipc_socket:getResponse(tbl)

    local succ, res = pcall(runJSON, {
      args = 
        "echo '" .. json.encode(tbl) .. "' | /opt/homebrew/bin/socat UNIX-CONNECT:" .. self:getSocket() .. " STDIO"
      ,
      key_that_contains_payload = "data"
    })

    inspPrint(res)

    if succ then
      return res
    else
      return nil
    end

  end

  function ipc_socket:getSocket()
    return "/tmp/sockets/" .. self.id
  end

  return ipc_socket
end
