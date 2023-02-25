local rrq = bindArg(relative_require, "utils.task")
rrq("args")

--- @class run_options_object
--- @field args command_parts
--- @field catch? fun(exit_code: integer, std_err: string): any
--- @field finally? fun(exit_code: integer, std_err_or_out: string): any currently, finally may run before and_then if and_then is async or has a delay
--- @field dont_clean_output? boolean

--- @class run_options_object_async : run_options_object
--- @field and_then? fun(std_out: string): any
--- @field delay? number
--- @field run_immediately? boolean

--- @alias run_overload_1 fun(opts: run_options_object_async | command_parts, async: true): hs.task
--- @alias run_overload_2 fun(opts: run_options_object | command_parts, async: false): string|nil
--- @alias run run_overload_1 | run_overload_2

--- @type run
function run(opts, async)
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
  opts.catch = opts.catch or function(exit_code, std_err)
    local err_str = "exit code " .. exit_code .. "\nstderr: \n" .. std_err
    error(err_str)
  end
  async = defaultIfNil(async, true)

  if async then
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
          if opts.delay then
            hs.timer.doAfter(opts.delay, function()
              opts.and_then(std_out)
            end)
          else
            opts.and_then(std_out)
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
    local command = string.format(
      "/opt/homebrew/bin/bash %s '%s'",
      args[1],
      args[2]
    )
    local output, status, reason, code = hs.execute(command)
    local error_to_rethrow
    if status then
      if not opts.dont_clean_output then
        output = stringy.strip(output)
      end
      return output
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

--- @param command_parts command_parts
--- @param and_then? and_then
--- @return hs.task
function runHsTask(command_parts, and_then)
  local task = buildHsTask(command_parts, and_then)
  task:start()
  return task
end

--- @param command_parts command_parts
--- @param and_then? fun(std_out: string)
--- @return hs.task
function runHsTaskProcessOutput(command_parts, and_then)
  local task = buildHsTask(command_parts, function(exit_code, std_out, std_err)
    if exit_code == 0 then
      and_then(std_out)
    else
      local err_str = "exit code " .. exit_code .. "\nstderr: \n" .. std_err
      error(err_str)
    end
  end)
  task:start()
  return task
end

---@param command_specifier_list { [string|number]: command_parts }
---@param do_after? fun(command_results: { [string]: string })
function runHsTaskParallel(command_specifier_list, do_after)
  local results = {}
  for command_id, command_parts in pairsSafe(command_specifier_list) do
    local task = runHsTask(command_parts, function (exit_code, std_out, std_err)
      if exit_code == 0 then 
        results[command_id] = std_out
      else
        results[command_id] = {
          exit_code = exit_code,
          std_err = std_err
        }
      end
      if tableLength(results) == tableLength(command_specifier_list) then
        if do_after then
          do_after(results)
        end
      end
    end)
  end
end

--- @param command_specifier_list { [string|number]: command_parts }
--- @param threads integer
--- @param do_after? fun(command_results: { [string]: string })
function runHsTaskNThreads(command_specifier_list, threads, do_after)
  local results = {}
  local chunked_table = chunk(command_specifier_list, threads)
  local next_pair = sipairs(chunked_table)
  local function runNext()
    local _, chunk = next_pair()
    if chunk then
      runHsTaskParallel(chunk, function (chunk_results)
        for command_id, result in pairsSafe(chunk_results) do
          results[command_id] = result
        end
        runNext()
      end)
    else
      if do_after then
        do_after(results)
      end
    end
  end
  runNext()
end

--- @param command_specifier_list { [string|number]: command_parts }
--- @param do_after? fun(command_results: { [string]: string })
function runHsTaskSequential(command_specifier_list, do_after)
  runHsTaskNThreads(command_specifier_list, 1, do_after)
end

--- @param arr any[]
--- @param arr_to_command_map fun(arr_index: integer, arr_item: any): any, command_parts
--- @param do_after? fun(command_results: { [string]: string })
--- @param threads? integer
function runHsTaskNThreadsOnArray(arr, arr_to_command_map, do_after, threads)
  threads = threads or 10 -- sensible default
  local tasks = mapPairNewPairOvtable(arr, arr_to_command_map)
  runHsTaskNThreads(tasks, threads, do_after)
end


--- @param command_parts command_parts
--- @return hs.task
function runHsTaskQuickLookResult(command_parts)
  return runHsTask(command_parts, function (exit_code, std_out, std_err)
    local command_run = table.concat(command_parts, " ")
    local outstr = "Command\n  " .. 
      command_run ..
      "\nexited with code " .. exit_code ..
      "\n\nstdout:\n\n````\n" .. std_out ..
      "\n```\n\nstderr:\n\n```\n" .. std_err
      .. "\n```"
    alertCode(outstr)
  end)
end

--- @param ... command_part
--- @return hs.task
function runArgs(...)
  return runHsTask({...})
end

--- @param path string
--- @return hs.task
function runOpenCommand(path)
  return runHsTask({"open", path})
end


--- @return hs.task
function emptyTrash()
  return runHsTask({"rm", "-rf", "~/.Trash/*"})
end

--- @param namespace string
--- @param key string
--- @param value string
function writeDefault(namespace, key, value)
  return runHsTask({"defaults", "write", namespace, key, value})
end


--- @param mgr? string
--- @param thing? string
--- @param arg? string
--- @return string[]
function upkgGetInner(mgr, thing, arg)
  return splitLines(getOutputArgsSimple(
    "upkg",
    mgr,
    thing,
    arg
  ))
end