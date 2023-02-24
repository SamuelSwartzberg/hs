--- @param header_name string
--- @param header_value string
--- @return string
function buildEmailHeader(header_name, header_value)
  return string.format("%s: %s", firstCharToUpper(header_name), le(header_value))
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

--- @param iso_time integer
--- @return string|osdate
function formatDateEmail(iso_time)
  return os.date("%a, %d %b %Y %H:%M:%S %z", iso_time)
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
    local temp_file = createUniqueTempFile(evaled_mail)
    local new_file = createUniqueTempFile("")
    runHsTaskProcessOutput({
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
  runHsTask({
    "msmtp",
    "-t",
    "<",
    { value = email_file, type = "quoted" },
  }, function(exitCode, std_out, std_err)
    if exitCode == 0 then
      runHsTask({
        "cat",
        { value = email_file, type = "quoted" },
        "|",
        "msed",
        { value = "/Date/a/"..formatDateEmail(os.time()), type = "quoted" },
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
      end)
    else 
      writeFile(env.FAILED_EMAILS .. "/" .. os.date("%Y-%m-%dT%H:%M:%S"), email_file)
    end
    
  end)
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
  doWithTempFileEditedInEditor(mail, function(mail_file)
    do_after(readFileOrError(mail_file))
  end)
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
    listPush(steps, {
      "magrep",
      "-i",
      { value = magrep, type = "quoted" }
    })
  end
  if mpick then
    listPush(steps, {
      "mpick",
      "-t",
      { value = mpick, type = "quoted" }
    })
  end
  listPush(steps, {
    "msort",
    flags
  })

  local command_parts = listJoin(steps, "|")

  local rawres = stringy.strip(getOutputTaskSimple(command_parts))

  return stringy.split(rawres, "\n")
end