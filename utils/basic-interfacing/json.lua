
--- run a json command, decode the output, and handle errors
--- @param opts run_first_arg
--- @param and_then? fun(std_out: table): (any) | boolean 
--- @return any
function runJSON(opts, and_then)
  if type(opts) ~= "table" or is.table.array(opts) then
    opts = {
      args = opts
    }
  end
  if not and_then then -- since we're populating and_then when calling run(), we can't use it as a heuristic for if we're async or not, so we need to communicate that via force_sync
    opts.force_sync = true
  end

  local function handleOutputfunction(std_out)
    if std_out == "" then -- if we've gotten empty output, that means that error_on_empty_output was false/nil, and therefore we don't want to error. However, decoding it as json will fail, so we need to return nil
      return nil
    end
    local status, res = pcall(json.decode, std_out)
    if not status then
      error(("When running command:\n\n%s\n\nGot output:\n\n%s\n\nBut failed to decode it as JSON with error:\n\n%s"):format(
        buildInnerCommand(opts.args),
        std_out,
        res
      ))
    end
    if 
      res.error 
      and not opts.accept_error_payload 
      and (
        not opts.error_that_is_success 
        or res.error ~= opts.error_that_is_success
      ) 
    then
      error(("When running command:\n\n%s\n\nGot output:\n\n%s\n\nBut it was an error payload:\n\n%s"):format(
        buildInnerCommand(opts.args),
        json.encode(res),
        res.error
      ))
    end
    if opts.key_that_contains_payload  then 
      if res[opts.key_that_contains_payload] then
        res = res[opts.key_that_contains_payload]
      else
        error(("Opts say that the payload is in the key %s, but response contained no such key.\nResponse:\n\n%s"):format(
          opts.key_that_contains_payload,
          json.encode(res)
        ))
      end
    end
    return res
  end

  return run(
    opts,
    function(std_out)
      local succ, res = pcall(handleOutputfunction, std_out)
      if not succ then
        local throw_default_error = true
        if opts.json_catch then
          throw_default_error = opts.json_catch(res)
        end
        if throw_default_error then
          error(res)
        end
      else
        if type(and_then) == "function" then
          return and_then(res)
        else 
          return res
        end
      end
    end
  )
end