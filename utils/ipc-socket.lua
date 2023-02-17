function BuildIPCSocket()
  local ipc_socket = { id = randomInt(10) }
  function ipc_socket:writeMessage(tbl)
    local ipc_message = json.encode(tbl)
    local command = "LC_ALL=en_US.UTF-8 && LANG=en_US.UTF-8 && LANGUAGE=en_US.UTF-8 && echo '" ..
        ipc_message .. "' | /opt/homebrew/bin/socat - " .. self:getSocket()
    log.v("Executing: " .. command)
    return hs.execute(command)
  end

  function ipc_socket:getResponse(tbl)
    local ipc_response_raw_json, status, type, error_code = self:writeMessage(tbl)
    if status == nil then
      log.w("Status was nil."
      .. "\n  ipc_response_raw_json: " .. ipc_response_raw_json
      .. "\n  type: " .. type
      .. "\n  error_code: " .. error_code)
      return nil
    end
    if ipc_response_raw_json == "" then
      log.wf("Response was empty. Command was: %s", hs.inspect(tbl, {depth = 2}))
      return nil
    end
    local ipc_response = json.decode(ipc_response_raw_json)
    if ipc_response and ipc_response.error ~= "success" then
      log.wf("Writing to socket, got error.\nResponse: (caused error)\n%s", hs.inspect(ipc_response, {depth = 2}))
      return nil
    end
    if ipc_response.data then
      return ipc_response.data
    else
      log.i("No data in response, but no error and no nil status. Returning nil.")
      return nil
    end

  end

  function ipc_socket:getSocket()
    return "/tmp/socket-" .. self.id
  end

  return ipc_socket
end
