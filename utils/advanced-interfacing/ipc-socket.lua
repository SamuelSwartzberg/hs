function BuildIPCSocket(port)
  local ipc_socket = { id = port or rand({len=10}) }

  function ipc_socket:getResponse(tbl)

    local succ, res = pcall(runJSON, {
      args = {
        "echo",
        { value = json.encode(tbl), type = "quoted" },
        "|",
        "/opt/homebrew/bin/socat",
        "-",
        self:getSocket()
      },
      key_that_contains_payload = "data"
    })

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
