
--- run a json command, decode the output, and handle errors
--- @param opts run_first_arg
--- @param and_then? fun(std_out: table): (any) | boolean 
--- @return any
function runJSON(opts, and_then)
  if isListOrEmptyTable(opts) then
    opts = {
      args = opts
    }
  end
  if not and_then then -- since we're populating and_then when calling run(), we can't use it as a heuristic for if we're async or not, so we need to communicate that via force_sync
    opts.force_sync = true
  end
  opts.error_on_empty_output = defaultIfNil(opts.error_on_empty_output, true) -- a well-formed json api should return something like an empty object or array, not an empty string, even if there's no data
  return run(
    opts,
    function(std_out)
      local status, res = pcall(json.decode, std_out)
      if not status then
        error(("When running command:\n\n%s\n\nGot output:\n\n%s\n\nBut failed to decode it as JSON with error:\n\n%s"):format(
          buildInnerCommand(opts.args),
          std_out,
          res
        ))
      end
      if type(and_then) == "function" then
        return and_then(res)
      else 
        return res
      end
    end
  )
end

--- run a json command, decode the output, and handle error payloads
--- @param opts run_first_arg
--- @param and_then? fun(res: table): (any) | boolean 
--- @return any
function runJSONMessage(opts, and_then)
  if not and_then then -- since we're populating and_then when calling run(), we can't use it as a heuristic for if we're async or not, so we need to communicate that via force_sync
    opts.force_sync = true
  end
  return runJSON(
    opts,
    function(res)
      if res.error and (not opts.error_that_is_success or res.error ~= opts.error_that_is_success) then
        error(("When running command:\n\n%s\n\nGot output:\n\n%s\n\nBut it was an error payload:\n\n%s"):format(
          buildInnerCommand(opts.args),
          json.encode(res),
          res.error
        ))
      end
      if type(and_then) == "function" then
        return and_then(res)
      else 
        return res
      end
    end
  )
end