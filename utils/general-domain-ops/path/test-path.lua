--- @class sliceTest
--- @field slice sliceSpec | string
--- @field condition? anyCondition
--- @field sliceOpts? sliceOpts

--- @alias dirness "dir" | "not-dir"

--- @class testPathOpts
--- @field slice? sliceTest | (sliceTest | (string|table)[] )[]
--- @field existence? boolean | dirness | { exists?: boolean, dirness?: dirness, contents?: anyCondition}

--- @param path string
--- @param opts? testPathOpts | string | boolean
--- @return boolean
function testPath(path, opts)

  if opts == nil then
    opts = {existence = true}
  elseif type(opts) == "string" then
    opts = {dirness = opts}
  else
    opts = tablex.deepcopy(opts)
  end
  path = path or env.HOME
  path = resolveTilde(path)
  local remote = pathIsRemote(path)

  local results = {}

  -- process slice shorthand

  if opts.slice and not isListOrEmptyTable(opts.slice) then
    opts.slice = {opts.slice}
  end

  -- test slices

  if opts.slice then

    for _, slice_spec in ipairs(opts.slice) do

      if isListOrEmptyTable(slice_spec) then
        slice_spec = {
          slice = slice_spec[1],
          condition = slice_spec[2],
          sliceOpts = slice_spec[3],
        }
      end

      slice_spec.sliceOpts = slice_spec.sliceOpts or {}
      slice_spec.sliceOpts.rejoin_at_end = true
      local slice = pathSlice(path, slice_spec.slice,slice_spec.sliceOpts )

      if type(slice_spec.condition) == "string" then
        slice_spec.condition = {slice_spec.condition}
      end

      push(results, findsingle(slice, slice_spec.condition))

      if results[#results] == false then -- return early if any slice test fails. This may be removed at some point if I allow for 'or'-logic at some point
        return false
      end
        
  end

  -- test existence

  if opts.existence ~= nil then 

    -- process existence shorthand

    if type(opts.existence) == "boolean" then 
      opts.existence = {exists = opts.existence}
    elseif type(opts.existence) == "string" then
      opts.existence = {dirness = opts.existence}
    end

    if opts.existence.dirness ~= nil or opts.existence.contents ~= nil then
      opts.existence.exists = true -- if we need a certain dirness or contents, the path must exist, obviously
    end

    -- test existence

    local exists

    if not remote then
      local file = io.open(path, "r")
      pcall(io.close, file)
      exists =  file ~= nil
    else
      exists = pcall(run,{"rclone", "ls", {value = path, type = "quoted"}})
    end

    push(results, exists == opts.existence.exists)

    if exists and opts.existence.exists then -- if the path exists and we want it to exist, test the dirness and contents

      -- test dirness

      local dirness

      if opts.existence.dirness ~= nil then
        if not remote then
          dirness = not not hs.fs.chdir(path)
        else 
          dirness = pcall(runJSON,{
            args = {"rclone", "lsjson", "--stat", {value = path, type = "quoted"}},
            key_that_contains_payload = "IsDir"
          })

        end
        push(results, dirness == (opts.existence.dirness == "dir"))

        if results[#results] == false then -- return early if the dirness test fails. This may be removed at some point if I allow for 'or'-logic at some point
          return false
        end

        if opts.existence.contents ~= nil then
          local contents
          if dirness then 
            contents = itemsInPath(path)
            if #contents == 0 then
              contents = nil
            end
          else
            contents = readFile(path, "nil")
          end

          if contents == nil then
            push(results, opts.existence.contents == (contents ~= nil))
          else
            if dirness then
              error("not implemented yet")
            else
              if type(opts.existence.contents) == "string" then
                opts.existence.contents = {opts.existence.contents}
              end
              if type(opts.existence.contents) == "table" then
                if opts.existence.contents.r then
                  push(results, not not onig.find(contents, opts.existence.contents.r))
                else
                  push(results, find(opts.existence.contents, contents))
                end
              end
            end
          end
    end

  end



  return not find(results, returnSame)
end