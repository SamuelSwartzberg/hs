--- @param specifier { dt?: dateObj, unit?: string, amount?: number, precision?: string }
--- @param orig_date dateObj
--- @return dateObj
function processDateSpecification(specifier, orig_date)
  local dt
  local date_copy = orig_date:copy() -- copy to avoid modifying the original
  if not specifier then 
    return date_copy
  elseif specifier.dt then
    dt = specifier.dt
  elseif specifier.unit then
    specifier.amount = specifier.amount or 1
    dt = date_copy["add" .. specifier.unit](date_copy, specifier.amount)
  else
    dt = date_copy
  end
  if specifier.precision then
    dt = dt:fmt(tblmap.dt_component.rfc3339[normalize.dt_component[specifier.precision]])
  end
  return dt
end