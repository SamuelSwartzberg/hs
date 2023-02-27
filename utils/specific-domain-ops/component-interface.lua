--- @param val any
--- @return boolean
function valueIsComponentInterface(val)
  return type(val) == "table" and val.is_interface == true
end