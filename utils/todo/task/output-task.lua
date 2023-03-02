local rrq = bindArg(relative_require, "utils.task")
rrq("args")

--- @param command_parts command_parts
--- @return string, boolean, "exit"|"signal", integer
function getOutputTask(command_parts)
  local bash_args = buildTaskArgs(command_parts)
  local command = string.format(
    "/opt/homebrew/bin/bash %s '%s'",
    bash_args[1],
    bash_args[2]
  )
  return hs.execute(command)
end

--- @param ... command_part
--- @return string, boolean, "exit"|"signal", integer
function getOutputArgs(...)
  return getOutputTask({...})
end

--- @return { [string]: string }
function getEnvAsTable()
  local env = getOutputTask({"env"})
  local env_table = {}
  for line in stringx.lines(env) do
    local key, value = line:match("^(.-)=(.*)$")
    if key and value then
      env_table[key] = value
    end
  end
  return env_table
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
  for command_id, command_parts in wdefarg(pairs)(command_specifier_list) do
    local task = runHsTask(command_parts, function (exit_code, std_out, std_err)
      if exit_code == 0 then 
        results[command_id] = std_out
      else
        results[command_id] = {
          exit_code = exit_code,
          std_err = std_err
        }
      end
      if #values(results) == #values(command_specifier_list) then
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
        for command_id, result in wdefarg(pairs)(chunk_results) do
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
    alert(outstr)
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
  return lines(run({
    "upkg",
    mgr,
    thing,
    arg
  }))
end