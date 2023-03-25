--- @alias command_part string | {value: string | command_parts, type: "quoted"  | "interpolated" | nil}
--- @alias command_parts command_part[]

--- @param command_parts command_parts | string list of things to assemble into a command
--- @return string
function buildInnerCommand(command_parts)
  local command = ""
  if type(command_parts) == "string" then
    return " " .. command_parts
  end
  command_parts = fixListWithNil(command_parts) -- this allows us to have optional args simply by having them be nil
  for _, command_part in iprs(command_parts) do
    if type(command_part) == "string" then
      command = command .. " " .. command_part
    elseif type(command_part) == "table" then
      if command_part.type == "quoted" then
        command = command .. ' "' .. replace(command_part.value, {matcher = '"'}) .. '"'
      elseif command_part.type == "interpolated" then
        command = command .. '"$('  .. buildInnerCommand(command_part.value) .. ')"'
      else
        error("Unknown command_part type: " .. command_part.type)
      end
    else
      error("Unknown command_part type: " .. type(command_part))
    end
  end

  return command
end

--- @param command_parts command_parts | string list of things to assemble into a command
--- @return string[]
function buildTaskArgs(command_parts)
  local hs_task_args = {
    "-c",
    "cd && source \"$HOME/.target/envfile\" &&" .. buildInnerCommand(command_parts)
  }
  return hs_task_args

end

--- @class run_options_object
--- @field args command_parts | string
--- @field catch? fun(exit_code: integer, std_err: string): any
--- @field finally? fun(exit_code: integer, std_err_or_out: string): any currently, finally may run before and_then if and_then is async or has a delay
--- @field force_sync? boolean if true, will run the task synchronously, even if and_then is provided
--- @field dont_clean_output? boolean
--- @field run_raw_shell? boolean if true, will run the task in a raw shell, rather than first switching to bash and loading the envfile
--- @field error_on_empty_output? boolean error also if the output is empty
--- @field accept_error_payload? boolean only relevant for JSON. If true, will accept a payload even it contains an error key.
--- @field error_that_is_success? string only relevant for JSON, if the error message matches this, it will be treated as a success. For badly designed JSON APIs.
--- @field key_that_contains_payload? string only relevant for JSON. If set, this key must be present for the request to be considered a success, and the value of that key will be returned / passed to and_then
--- @field json_catch? fun(error_msg: string): any only relevant for JSON. If set, will be called if one of the JSON-specific errors occurs
--- @field and_then? fun(std_out: string): any this shouldn't be here, but rather the second argument of run, but if it's here, we'll still accept it

--- @class run_options_object_async : run_options_object
--- @field delay? number
--- @field run_immediately? boolean if true, will run the task immediately, otherwise, you need to call :start() manually on the returned task object

--- @alias run_first_arg run_options_object_async | command_parts | string
--- @alias run_and_then fun(std_out: string): (any) | true | run_first_arg

--- @alias run fun(opts: run_first_arg, and_then?: run_and_then, ...?: run_and_then ): any

--- @type run
function run(opts, and_then, ...)
  local varargs = {...}
  local args 
  if not opts.args then
    error("No args provided")
  else
    if isListOrEmptyTable(opts) then -- handle providing command_parts directly
      opts = {args = args}
    end
    args = buildTaskArgs(opts.args)
  end
  opts.dont_clean_output = defaultIfNil(opts.dont_clean_output, false)
  opts.catch = function(exit_code, std_err)
    local should_run_default_catch = true
    if opts.catch then
      should_run_default_catch = opts.catch(exit_code, std_err) -- if the user-provided catch returns true, run the default catch, otherwise, don't
    end
    if should_run_default_catch == true then
      local err_str = ("Error running command:\n\n%s\n\nExit code: %s\n\nStderr: %s"):format(buildInnerCommand(opts.args), exit_code, std_err)
      error(err_str)
    end
  end

  if opts.and_then then and_then = opts.and_then end
  opts.run_immediately = defaultIfNil(opts.run_immediately, true)

  if and_then and not opts.force_sync then
    if and_then == true then -- in this case, we're only using and_then to indicate that we want to run the task asyncly
      and_then = function() end
    elseif type(and_then) == "table" then -- shorthand for and_then being another call to `run`, with and_then being opts of the second call, and the varargs being the and_then of the second call, and potentially further
      and_then = function()
        run(and_then, table.unpack(varargs))
      end
    end
    local task =  hs.task.new(
      "/opt/homebrew/bin/bash",
      function(exit_code, std_out, std_err)
        local error_to_rethrow
        if exit_code ~= 0 then
          local status, res = pcall(opts.catch, exit_code, std_err) -- temporarily catch the error so we can run the finally block
          if not status then
            error_to_rethrow = res
          end
        else
          if not opts.dont_clean_output then
            std_out = stringy.strip(std_out)
          end
          if opts.error_on_empty_output and std_out == "" then
            opts.catch(-1, "Output was empty and error_on_empty_output was true.")
          end
          if opts.delay then
            hs.timer.doAfter(opts.delay, function()
              and_then(std_out)
            end)
          else
            and_then(std_out)
          end
        end
        if opts.finally then
          opts.finally(exit_code, std_out or std_err)
          if error_to_rethrow then -- rethrow the error if it was caught
            error(error_to_rethrow)
          end
        end
      end,
      args
    )
    if opts.run_immediately then
      task:start()
    end
    return task
  else
    local command
    if opts.run_raw_shell then
      command = "LC_ALL=en_US.UTF-8 && LANG=en_US.UTF-8 && LANGUAGE=en_US.UTF-8 && " .. buildInnerCommand(opts.args)
    else 
      command = string.format(
        "/opt/homebrew/bin/bash %s '%s'",
        args[1],
        args[2]
      )
    end
    local output, status, reason, code = hs.execute(command)
    local error_to_rethrow
    if status then
      if not opts.dont_clean_output then
        output = stringy.strip(output)
      end
      if opts.error_on_empty_output and output == "" then
        opts.catch(-1, "Output was empty and error_on_empty_output was true.")
      end
      if and_then then
        return and_then(output)
      else
        return output
      end
    else
      local status, res = pcall(opts.catch, code, output)
      if not status then
        error_to_rethrow = res
      end
    end

    if opts.finally then
      opts.finally(code, output)
    end

    if error_to_rethrow then
      error(error_to_rethrow)
    end

    return nil
  end

end
