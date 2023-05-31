dothis = {
  mullvad = {
    connect = function()
      run("mullvad connect", true)
    end,
    disconnect = function()
      run("mullvad disconnect", true)
    end,
    toggle = function()
      if get.mullvad.connected() then
        dothis.mullvad.disconnect()
      else
        dothis.mullvad.connect()
      end
    end,
    relay_set = function(hostname)
      run("mullvad relay set hostname " .. hostname, true)
    end,
  }
}