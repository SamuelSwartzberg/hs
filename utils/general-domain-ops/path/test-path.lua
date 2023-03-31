--- @alias dirness "dir" | "not-dir"

--- @class existenceTest
--- @field exists? boolean whether the path should exist or not
--- @field dirness? dirness whether the path should be a directory or not
--- @field contents? anyCondition a condition(s) (passed to find()) to run on the contents 

--- tests a path based on various conditions. returns true if the path passes all conditions, false otherwise
--- @param path string the path to test
--- @param opts? boolean | dirness | existenceTest
--- @return boolean
function testPath(path, opts)

  if opts == nil then
    opts = {exists = true}
  elseif type(opts) == "boolean" then 
    opts = {exists = opts}
  elseif type(opts) == "string" then
    opts = {dirness = opts} 
  else
    opts = copy(opts)
  end
  path = path or env.HOME
  path = transf.string.tilde_resolved(path)
  local remote = pathIsRemote(path)

  local results = {}

  -- test existence

  -- process existence shorthand

  if opts.dirness ~= nil or opts.contents ~= nil then
    opts.exists = true -- if we need a certain dirness or contents, the path must exist, obviously
  end

  -- test existence

  local exists

  inspPrint(remote)
  if not remote then
    local file = io.open(path, "r")
    pcall(io.close, file)
    exists =  file ~= nil
  else
    exists = pcall(run,{"rclone", "ls", {value = path, type = "quoted"}})
  end

  inspPrint(exists)
  push(results, exists == opts.exists)

  if exists and opts.exists then -- if the path exists and we want it to exist, test the dirness and contents

    -- test dirness

    local dirness

    if opts.dirness ~= nil then
      if not remote then
        dirness = not not hs.fs.chdir(path)
      else 
        dirness = pcall(runJSON,{
          args = {"rclone", "lsjson", "--stat", {value = path, type = "quoted"}},
          key_that_contains_payload = "IsDir"
        })

      end
      push(results, dirness == (opts.dirness == "dir"))

      if results[#results] == false then -- return early if the dirness test fails. This may be removed at some point if I allow for 'or'-logic at some point
        return false
      end
    end

    if opts.contents ~= nil then
      local contents
      print("cont")
      print(dirness)
      -- get contents depending on whether the path is a directory or not
      if dirness then 
        contents = itemsInPath(path)
        if #contents == 0 then
          contents = nil
        end
      else
        print("readin file")
        contents = readFile(path, "nil")
      end

      inspPrint(contents)

      -- test contents
      if contents == nil then -- boolean case: test whether the contents are nil or not
        push(results, opts.contents == (contents ~= nil))
      else
        if dirness then
          error("not implemented yet")
        else
          print("here")
          push(results, find(contents, opts.contents))
        end
      end
    end
  end


  inspPrint(results)

  return reduce(results, returnAnd)
end