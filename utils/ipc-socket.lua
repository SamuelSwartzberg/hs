function BuildIPCSocket()
  local ipc_socket = { id = rand({len=10}) }

  function ipc_socket:getResponse(tbl)

    local succ, res = pcall(runJSONMessage, {
      args = {
        "echo",
        { value = json.encode(tbl), type = "quoted" },
        "|",
        "/opt/homebrew/bin/socat",
        "-",
        self:getSocket()
      },
      force_sync = true,
    }, function(response)
      if response.data then
        return response.data
      else
        error("No data in response, but no error and no nil status. Returning nil.")
      end
    end)

    if succ then
      return res
    else
      return nil
    end

  end

  function ipc_socket:getSocket()
    return "/tmp/socket-" .. self.id
  end

  return ipc_socket
end
