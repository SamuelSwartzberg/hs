
--- @class tempFileOpts
--- @field path? string
--- @field contents? string
--- @field edit_before? boolean
--- @field use_contents? boolean

--- @param opts tempFileOpts
--- @param do_this fun(tmp_file: string): nil
function doWithTempFile(opts, do_this)
  local tmp_file = writeFile(opts.path, opts.contents) --[[ @as string ]]

  local arg
  if opts.use_contents then
    arg = readFile(tmp_file, "nil")
  else
    arg = tmp_file
  end

  if opts.edit_before then
    run({
      args = {
        "code",
        "--wait",
        "--disable-extensions",
        {value = tmp_file, type = "quoted"},
      },
      finally = function()
        delete(tmp_file)
      end
    }, function()
      do_this(arg)
    end)
  else
    do_this(arg)
    delete(tmp_file)
  end
end

