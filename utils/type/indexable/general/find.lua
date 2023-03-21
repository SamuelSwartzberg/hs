--- @class findOpts : tableProcOpts
--- @field findall boolean return all matches instead of just the first one

---@alias findOptsWShorthand kvmult | kvmult[] | findOpts

--- @param indexable? indexable
--- @param cond? conditionSpec the condition that is being searched for
--- @param opts? findOptsWShorthand default {ret = "boolean"}
--- @return any
function find(indexable, cond, opts)
  cond = cond or false
  if not opts then opts = {ret = "boolean"} 
  elseif type(opts) == "table" and not isListOrEmptyTable(opts) and not opts.ret then opts.ret = "boolean" end -- default to returning a boolean, this is different from the general default, which is why we have to do this before calling defaultOpts
  opts = defaultOpts(opts)
  indexable = getDefaultInput(indexable, opts)

  inspPrint(indexable)

  local finalres 

  if not (type(indexable) == "string") then
    local iterator = getIterator(indexable, opts)

    
    if opts.findall then finalres = {} end

    for k, v in wdefarg(iterator)(indexable) do
      print(k, v)
      local retriever = {
        k = k,
        v = v
      }
      local res = findsingle(retriever[opts.args[1]], cond, "boolean")
      inspPrint(res)
      if res == true then
        --- @type table | boolean
        local retres = {}
        if opts.ret == "boolean" then
          retres = true
        else
          for _, retarg in ipairs(opts.ret) do 
            print(retarg)
            push(retres, retriever[retarg])
          end
        end
        if opts.findall then
          concat(finalres, retres)
        else
          return returnUnpackIfTable(retres)
        end
      end

    end
  else
    local matchkey, matchvalue
    while true do
      matchkey, matchvalue = findsingle(indexable, cond, {
        ret = "kv"
      })
      print(matchkey, matchvalue)
      local res = {}
      local retriever = {
        k = matchkey,
        v = matchvalue
      }
      inspPrint(opts.ret)
      for _, retarg in ipairs(opts.ret) do 
        push(res, retriever[retarg])
      end
      if opts.findall then
        if matchkey == -1 then break end
        table.insert(finalres, res)
      else
        return table.unpack(res)
      end

      -- to think about: if matchkey is -1 and opts.findall is false, it will return the non-match result (indicated by -1) instead of a perhaps more expected nil or something else
        
    end

  end
  if opts.ret == "boolean" and not opts.findall and finalres == nil then finalres = false end
  return finalres
end