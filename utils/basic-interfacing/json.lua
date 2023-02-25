
--- run a json command, decode the output, and handle errors
--- @param opts run_first_arg
--- @param and_then? fun(std_out: table): (any) | boolean 
function runJSON(opts, and_then)
  if isListOrEmptyTable(opts) then
    opts = {
      args = opts
    }
  end
  if not and_then then -- since we're populating and_then when calling run(), we can't use it as a heuristic for if we're async or not, so we need to communicate that via force_sync
    opts.force_sync = true
  end
  return run(
    opts,
    function(std_out)
      local status, res = pcall(json.decode, std_out)
      if not status then
        error("Error decoding JSON: \n\n" .. res .. "\n\nInput was:\n\n" .. std_out)
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
function runJSONMessage(opts, and_then)
  if not and_then then -- since we're populating and_then when calling run(), we can't use it as a heuristic for if we're async or not, so we need to communicate that via force_sync
    opts.force_sync = true
  end
  return runJSON(
    opts,
    function(res)
      if res.error then
        error("JSON has .error field:\n\n" .. res.error .. "\n\nFull JSON:\n\n" .. json.encode(res))
      end
      if type(and_then) == "function" then
        return and_then(res)
      else 
        return res
      end
    end
  )
end