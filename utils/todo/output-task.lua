--- @return { [string]: string }
function getEnvAsTable()
  local env = run({"env"})
  local env_table = {}
  for line in stringx.lines(env) do
    local key, value = line:match("^(.-)=(.*)$")
    if key and value then
      env_table[key] = value
    end
  end
  return env_table
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

--- @param namespace string
--- @param key string
--- @param value string
function writeDefault(namespace, key, value)
  return run({"defaults", "write", namespace, key, value})
end