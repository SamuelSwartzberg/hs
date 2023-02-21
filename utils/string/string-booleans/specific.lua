--- @param str string
--- @return boolean
function isDoi(str)
  local str_lower = eutf8.lower(str)
  return not not eutf8.find(str_lower, "^10.%d%d%d%d%d?%d?%d?%d?%d?/[-._;()/:A-Z0-9]+$")
end

--- @param str string
--- @return boolean
function isIsbn(str)
  local filtered_str = eutf8.gsub(str, "-", "")
  if eutf8.len(filtered_str) == 10 then
    return not eutf8.find(filtered_str, "[^0-9X]")
  elseif eutf8.len(filtered_str) == 13 then
    return not eutf8.find(filtered_str, "[^0-9]")
  else
    return false
  end
end

--- @param str string
--- @return boolean
function isIssn(str)
  local filtered_str = eutf8.gsub(str, "-", "")
  return eutf8.len(filtered_str) == 8 and not eutf8.find(filtered_str, "[^0-9X]")
end

--- @param str string
--- @return boolean
function isSnakeCase(str)
  return asciiStringContainsOnly(str, "a-z0-9_")
end

--- @param str string
--- @return boolean
function isDiceSyntaxString(str)
  return onig.match(str, "^\\d+d\\d+[/x]\\d+[+-]\\d+$")
end

--- @param str string
--- @return boolean
function isRFC3339Datelike(str)
  return onig.match(str, 
    "^\\d{4}(?:" ..
      "\\-\\d{2}(?:" ..
        "\\-\\d{2}(?:" ..
          "T\\d{2}(?:" ..
            "\\:\\d{2}(?:" ..
              "\\:\\d{2}(?:" ..
                "\\.\\d{1,9}"
              ..")?"
            ..")?"
          ..")?Z?"
        ..")?"
      ..")?"
    ..")?$"
  )
end

--- @param str string
--- @return boolean
function isPotentiallyPhoneNumber(str)
  if #str > 16 then return false end
  local _, amount_of_digits = eutf8.gsub(str, "%d", "")
  local _, amount_of_non_digits = eutf8.gsub(str, "%D", "")
  local digit_non_digit_ratio = amount_of_digits / amount_of_non_digits
  return digit_non_digit_ratio > 0.5
end

--- @param str string
--- @return boolean
function isUrlBase64(str)
  return onig.match(str, "^[A-Za-z0-9_\\-=]+$")
end

--- @param str string
--- @return boolean
function isGeneralBase64(str)
  return onig.match(str, "^[A-Za-z0-9+/=]+$")
end

--- @param str string
--- @return boolean
function isGeneralBase32(str)
  return onig.match(str, "^[A-Za-z2-7=]+$")
end

--- @param str string
--- @return boolean
function isCrockfordBase32(str)
  return onig.match(str, "^[0-9A-HJKMNP-TV-Z=]+$")
end

--- @param str string
--- @return boolean
function containsLowercase(str)
  return not not eutf8.find(str, "%l")
end

--- @param str string
--- @return boolean
function containsUppercase(str)
  return not not eutf8.find(str, "%u")
end

--- @param str string
--- @return boolean
function doesNotContainLowercase(str)
  return not eutf8.find(str, "%l")
end

--- @param str string
--- @return boolean
function doesNotContainUppercase(str)
  return not eutf8.find(str, "%u")
end

--- @param str string
--- @return boolean
function potentialEnvVar(str)
  return asciiStringContainsOnly(str, "A-Z0-9_")
end

--- @param str string
--- @return boolean
function containsLargeWhitespace(str)
  return asciiStringContainsSome(str, {"\t", "\r", "\n"})
end

--- @param str string
--- @return boolean
function isPackageManager(str)
  local package_managers = stringy.split(
    stringy.strip(
      getOutputArgsSimple(
        "upkg",
        "list-package-managers"
      )
    ),
    "\n"
  )
  return not not valueFindKeyString(package_managers, str)
end