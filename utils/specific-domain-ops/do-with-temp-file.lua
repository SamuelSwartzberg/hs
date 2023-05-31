
--- @class tempFileOpts
--- @field path? string the path to the file, if not given, a random one will be generated
--- @field contents? string
--- @field edit_before? boolean allow user to edit the file before the callback is called
--- @field use_contents? boolean whether to pass the contents of the file to the function instead of the path

--- do an action on a temporary file, optionally editing it before, and delete it afterwards
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

