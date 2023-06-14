--- Get the next time a cron expression will run
--- @param cronspec string a time specification in cron format
--- @return number
function getCronNextTime(cronspec)
  return get.string_or_number.number(run({
    "ncron",
    { value = cronspec, type = "quoted"}
  }), 10)
end