--- @param header_name string
--- @param header_value string
--- @return string
function buildEmailHeader(header_name, header_value)
  return string.format("%s: %s", replace(header_name, to.case.capitalized), le(header_value))
end


--- @param headers { [string]: string }
--- @return string
function buildEmailHeaders(headers)
  local header_lines = {}
  local initial_headers = {"from", "to", "cc", "bcc", "subject"}
  for _, header_name in ipairs(initial_headers) do
    local header_value = headers[header_name]
    if header_value then
      table.insert(header_lines, buildEmailHeader(header_name, header_value))
      headers[header_name] = nil
    end
  end
  for key, value in pairs(headers) do
    table.insert(header_lines, buildEmailHeader(key, value))
  end
  return table.concat(header_lines, "\n")
end

--- @param headers { [string]: string }
--- @param body string
--- @param edit_func fun(mail: string, do_after: fun(mail: string))
--- @param do_after fun(mail: string)
function buildEmailInteractive(headers, body, edit_func, do_after)
  local header = buildEmailHeaders(headers)
  local mail = string.format("%s\n\n%s", header, body)
  edit_func(mail, function(mail)
    local evaled_mail = le(mail)
    local temp_file = writeFile(nil, evaled_mail)
    local new_file = writeFile(nil, "")
    run({
      "mmime",
      "<",
      { value = temp_file, type = "quoted" },
      ">",
      { value = new_file, type = "quoted" },
    }, function ()
      delete(temp_file)
      do_after(new_file)
    end)
  end)
end

--- @param email_file string
--- @param do_after? fun()
function sendEmail(email_file, do_after)
  run({
      args = {
        "msmtp",
        "-t",
        "<",
        { value = email_file, type = "quoted" },
      },
      catch = function()
        writeFile(env.FAILED_EMAILS .. "/" .. os.date("%Y-%m-%dT%H:%M:%S"), readFile(email_file, "error"))
      end,
      finally = function()
        delete(email_file)
      end,
    }, 
    {
      "cat",
      { value = email_file, type = "quoted" },
      "|",
      "msed",
      { value = "/Date/a/"..os.date(tblmap.date_format_name.date_format.email, os.time()), type = "quoted" },
      "|",
      "msed",
      { value = "/Status/a/S/", type = "quoted" },
      "|",
      "mdeliver",
      "-c",
      { value = env.MBSYNC_ARCHIVE, type = "quoted" },
    }, function()
      delete(email_file)
      if do_after then
        do_after()
      end
    end, true)
end
--- @param headers { [string]: string }
--- @param body string
--- @param edit_func? fun(mail: string, do_after: fun(mail: string))
--- @param do_after? fun()
function sendEmailInteractive(headers, body, edit_func, do_after)
  edit_func = edit_func or function(mail, do_after)
    do_after(mail)
  end
  buildEmailInteractive(headers, body, edit_func, function(mail_file)
    sendEmail(mail_file, do_after)
  end)
end

function editorEditFunc(mail, do_after)
  doWithTempFile({
    path = mail,
    edit_before = true,
    use_contents = true,
  }, do_after)
end

--- @param path string
--- @param reverse? boolean
--- @param magrep? string
--- @param mpick? string
--- @return string[]
function getSortedEmailPaths(path, reverse, magrep, mpick)
  local flags = "-d"
  if reverse then
    flags = flags .. "r"
  end
  local steps = {{
    "mlist",
    { value = path, type = "quoted" }
  }}
  if magrep then
    push(steps, {
      "magrep",
      "-i",
      { value = magrep, type = "quoted" }
    })
  end
  if mpick then
    push(steps, {
      "mpick",
      "-t",
      { value = mpick, type = "quoted" }
    })
  end
  push(steps, {
    "msort",
    flags
  })

  local command_parts = concat({ isopts = "isopts", sep = "|" }, table.unpack(steps))

  return stringy.split(run(command_parts), "\n")
end

