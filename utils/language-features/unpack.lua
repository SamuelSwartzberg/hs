--- @generic T 
--- @param potential_tbl primitive | T[]
--- @return primitive | ...<T>
function tableUnpackIfTable(potential_tbl)
  if type(potential_tbl) == "table" then
    return table.unpack(potential_tbl)
  else
    return potential_tbl
  end
end