
--- @param command_specifier_list { [string|number]: command_parts }
--- @param threads? integer
--- @param do_after? fun(command_results: { [string]: string })
--- @param catch? fun(command_results: { [string]: {exit_code: integer, std_err: string} })
function runThreaded(command_specifier_list, threads, do_after, catch)
  local threads = threads or 10 -- sensible default
  local results = {}
  local chunked_table = chunk(command_specifier_list, threads)
  local next_pair = sipairs(chunked_table)
  local function runNextChunk()
    local _, chunk = next_pair()
    if chunk then
      for command_id, command_parts in wdefarg(pairs)(command_specifier_list) do
      local task = run({
        args = command_parts,
        catch = function(exit_code, std_err)
          results[command_id] = {
            exit_code = exit_code,
            std_err = std_err
          }
        end,
        finally = function()
          if #values(results) == #values(command_specifier_list) then
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

