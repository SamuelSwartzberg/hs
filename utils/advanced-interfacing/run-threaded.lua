--- Executes multiple commands concurrently using a specified number of threads.
--- @param command_specifier_list { [string|number]: command_parts } A table where the key is either a string or a number and the value is a table representing the command parts to be executed. The key is used to identify the command in the results table.
--- @param threads? integer Optional. The maximum number of concurrent threads to be used for executing the commands. If not provided, defaults to 10.
--- @param do_after? fun(command_results: { [string]: string }) Optional. A function to be executed after all commands have run successfully. The function takes a table where the key is the command key from the command_specifier_list and the value is the string result of the successful command execution.
--- @param catch? fun(command_results: { [string]: {exit_code: integer, std_err: string} }) Optional. A function to handle any errors from the command execution. The function takes a table where the key is the command key from the command_specifier_list and the value is a table with the 'exit_code' and 'std_err' from the unsuccessful command execution.
function runThreaded(command_specifier_list, threads, do_after, catch)
  local threads = threads or 10 -- sensible default
  local results = {}
  local chunked_table = chunk(command_specifier_list, threads)
  local next_pair = transf.indexable.index_value_stateful_iter(chunked_table)
  local function runNextChunk()
    local _, chunk = next_pair()
    if chunk then
      for command_id, command_parts in transf.table.key_value_iter(chunk) do
        local task = run({
          args = command_parts,
          catch = function(exit_code, std_err)
            results[command_id] = {
              exit_code = exit_code,
              std_err = std_err
            }
          end,
          finally = function()
            if #transf.native_table_or_nil.value_array(results) == #transf.native_table_or_nil.value_array(command_specifier_list) then
              runNextChunk()
            end
          end
          }, function (std_out)
            results[command_id] = std_out
          end)
      end
    else
      local failures = filter(results, {_type = "table"})
      local successes = filter(results, {_type = "string"})
      if catch  then
        catch(failures)
      end
      if do_after then
        do_after(successes)
      end
    end
  end
  runNextChunk()
end

