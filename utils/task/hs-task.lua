local rrq = bindArg(relative_require, "utils.task")
rrq("args")



local function doNothingCallback(_, std_out, std_err)
  log.v("stdout: " .. std_out)
  log.v("stderr: " .. std_err)
  return true
end

--- @param command_parts command_parts
--- @param end_callback? end_callback
--- @return hs.task
function buildHsTask(command_parts, end_callback)
  local task = hs.task.new(
    "/opt/homebrew/bin/bash",
    end_callback or doNothingCallback,
    buildTaskArgs(command_parts)
  )
  return task
end

--- @param command_parts command_parts
--- @param end_callback? end_callback
--- @return hs.task
function runHsTask(command_parts, end_callback)
  local task = buildHsTask(command_parts, end_callback)
  task:start()
  return task
end

--- @param command_parts command_parts
--- @param end_callback? fun(std_out: string)
--- @return hs.task
function runHsTaskProcessOutput(command_parts, end_callback)
  local task = buildHsTask(command_parts, function(exitCode, std_out, std_err)
    if exitCode == 0 then
      end_callback(std_out)
    else
      local err_str = "exit code " .. exitCode .. "\nstderr: \n" .. std_err
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
    local task = runHsTask(command_parts, function (exitCode, std_out, std_err)
      if exitCode == 0 then 
        results[command_id] = std_out
      else
        results[command_id] = {
          exitCode = exitCode,
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
  return runHsTask(command_parts, function (exitCode, std_out, std_err)
    local command_run = table.concat(command_parts, " ")
    local outstr = "Command\n  " .. 
      command_run ..
      "\nexited with code " .. exitCode ..
      "\n\nstdout:\n\n````\n" .. std_out ..
      "\n```\n\nstderr:\n\n```\n" .. std_err
      .. "\n```"
    alertCode(outstr)
  end)
end

--- @param command_parts command_parts
--- @param end_callback? end_callback
--- @return hs.task
function runHsTaskErrorOnError(command_parts, end_callback)
  return runHsTask(command_parts, function (exitCode, std_out, std_err)
    if exitCode ~= 0 then 
      error("Exited with non-zero code: " .. exitCode .. "\nstderr:\n\n" .. std_err .. "\n\nstdout:\n\n" .. std_out)
    else 
      if end_callback then
        end_callback(exitCode, std_out, std_err)
      end
    end
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

local lang_voice_map = {
  ["en"] = "Ava",
  ["ja"] = "Kyoko",
}

---@param text string
---@param lang "en" | "ja"
function say(text, lang)
  return runHsTask({"say", "-v", lang_voice_map[lang], {value = text, type = "quoted"}})
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