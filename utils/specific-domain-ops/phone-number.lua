--- @param str string
--- @return boolean
function isPotentiallyPhoneNumber(str)
  if #str > 16 then return false end
  local _, amount_of_digits = eutf8.gsub(str, "%d", "")
  local _, amount_of_non_digits = eutf8.gsub(str, "%D", "")
  local digit_non_digit_ratio = amount_of_digits / amount_of_non_digits
  return digit_non_digit_ratio > 0.5
end