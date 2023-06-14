-- Test 1: Test the getCronNextTime function for a simple cron expression
local cronExpression1 = "*/5 * * * *"
local nextRun1 = getCronNextTime(cronExpression1)
local diff = get.string_or_number.number(run("datediff @" .. nextRun1 .. " now -f '%S'"))
assertMessage(diff < 300, true)
local mins = get.string_or_number.number(run("date -d @" .. nextRun1 .. " +'%M'"))
assertMessage(mins % 5, 0)

-- Test 2: Test the getCronNextTime function for a specific time of day
local cronExpression2 = "0 12 * * *"
local nextRun2 = getCronNextTime(cronExpression2)
local diff = get.string_or_number.number(run("datediff @" .. nextRun2 .. " now -f '%H'"))
assertMessage(diff < 24, true)
local hours = get.string_or_number.number(run("date -d @" .. nextRun2 .. " +'%H'"))
assertMessage(hours, 12)

-- Test 3: Test the getCronNextTime function for a specific day of the week
local cronExpression3 = "0 0 * * 1"
local nextRun3 = getCronNextTime(cronExpression3)
local diff = get.string_or_number.number(run("datediff @" .. nextRun3 .. " now -f '%d'"))
assertMessage(diff < 7, true)
local day = get.string_or_number.number(run("date -d @" .. nextRun3 .. " +'%w'"))
assertMessage(day, 1)