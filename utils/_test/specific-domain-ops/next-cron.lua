-- Test 1: Test the getCronNextTime function for a simple cron expression
local cronExpression1 = "*/5 * * * *"
local currentMinutes1 = date():getminutes()
local nextInterval1 = 5 - currentMinutes1 % 5
local expectedNextRun1 = date():addminutes(nextInterval1):setseconds(0):setticks(0)
local nextRun1 = getCronNextTime(cronExpression1)
assertMessage(nextRun1, expectedNextRun1, "Test 1: Next run time should be at the next 5-minute interval.")

-- Test 2: Test the getCronNextTime function for a specific time of day
local cronExpression2 = "0 12 * * *"
local expectedNextRun2 = date():sethours(12, 0, 0, 0)
if date() > expectedNextRun2 then
  expectedNextRun2 = expectedNextRun2:adddays(1)
end
local nextRun2 = getCronNextTime(cronExpression2)
assertMessage(nextRun2, expectedNextRun2, "Test 2: Next run time should be at 12:00 PM today or tomorrow.")

-- Test 3: Test the getCronNextTime function for a specific day of the week
local cronExpression3 = "0 0 * * 1"
local expectedNextRun3 = date():sethours(0, 0, 0, 0)
while expectedNextRun3:getweekday() ~= 2 do
  expectedNextRun3 = expectedNextRun3:adddays(1)
end
local nextRun3 = getCronNextTime(cronExpression3)
assertMessage(nextRun3, expectedNextRun3, "Test 3: Next run time should be at the start of the next Monday.")
