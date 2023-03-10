--- makes a function that takes an options table into a function that takes a string of shell-like arguments
--- e.g. one that takes { foo: <val1>, bar_baz: <val2> } into a function that takes "-f <val1> -bb <val2>"
--- @param fn fun(opts: { [string]: any }, ...: any): any
--- @return fun(opts: string, ...: any): any
function takeShellikeArgsAsOpts(fn)
  return function(opts, ...)
    local opts_tbl = newAliastable(shellLikeArgsToOpts(opts), "l")
    return fn(opts_tbl, ...)
  end
end

--- @param opts string
--- @return { [string]: any }
function shellLikeArgsToOpts(opts)
  local opts_tbl = {}
  local opts_list = stringy.split(opts, " ")
  opts_list = filter(opts_list, true)
  local prev_opt_was_key = false
  local prev_opt_key = nil
  for _, opt_part in ipairs(opts_list) do
    if stringy.startswith(opt_part, "-") then
      if prev_opt_was_key then
        opts_tbl[prev_opt_key] = true
      end
      prev_opt_was_key = true
      prev_opt_key = eutf8.sub(opt_part, 2)
    else -- not a key
      if prev_opt_was_key then -- prev opt was a key
        opts_tbl[prev_opt_key] = opt_part
        prev_opt_was_key = false
      else -- prev opt was a value
        if prev_opt_key then
          opts_tbl[prev_opt_key] = opts_tbl[prev_opt_key] .. " " .. opt_part
        else 
          error("no key for value: " .. opt_part)
        end
      end
    end
  end
  if prev_opt_was_key then
-- (prev_opt_key is always set when prev_opt_was_key is true)
---@diagnostic disable-next-line: need-check-nil
    opts_tbl[prev_opt_key] = true
  end
  return opts_tbl
end