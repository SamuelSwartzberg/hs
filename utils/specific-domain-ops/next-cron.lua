--- @param cronspec string
--- @return number
function getCronNextTime(cronspec)
  return tonumber(run({
    "ncron",
    { value = cronspec, type = "quoted"}
  }), 10)
end