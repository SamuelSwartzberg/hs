--- @class findOpts : tableProcOpts
--- @field findall boolean return all matches instead of just the first one

---@alias findOptsWShorthand kvmult | kvmult[] | findOpts may be string, array, array of arrays, or table

--- @param indexable? indexable
--- @param cond? conditionSpec the condition that is being searched for
--- @param opts? findOptsWShorthand default {ret = "boolean"}
--- @return any
function find(indexable, cond, opts)
  cond = defaultIfNil(cond, false)
  opts = defaultOpts(opts, "boolean")
  indexable = getDefaultInput(indexable)


  local finalres

  if not (type(indexable) == "string") then
    local iterator = getIterator(opts)
    local manual_counter = 0
    for k, v in wdefarg(iterator)(indexable) do
      local retriever
      retriever, manual_counter = getRetriever(indexable, k, v, manual_counter)
      local res = findsingle(retriever[opts.args[1]], cond, "boolean")
      if res == true then
        --- @type table | boolean
        local retres = {}
        if opts.ret == "boolean" then
          retres = true
        else
          for _, retarg in ipairs(opts.ret) do 
            push(retres, retriever[retarg])
          end
        end
        if opts.findall then
          if #retres == 1 then retres = retres[1] end
          if not finalres then finalres = {} end
          push(finalres, retres)
        else
          return returnUnpackIfTable(retres)
        end
      end

    end
  else
    local matchkey, matchvalue
    local start = 1
    local iters = 0
    finalres = {}
    while true do
      iters = iters + 1
      if opts.limit and iters > opts.limit then break end
      matchkey, matchvalue = findsingle(indexable, cond, {
        ret = "kv",
        start = start
      })
      local res = {}
      local retriever = {
        k = matchkey,
        v = matchvalue,
        i = getIndex(indexable, matchkey)
      }
      for _, retarg in ipairs(opts.ret) do 
        push(res, retriever[retarg])
      end
      if opts.findall then
        if matchkey == -1 then break end
        table.insert(finalres, res)
        start = matchkey + #matchvalue 
      else
        return table.unpack(res)
      end

      -- to think about: if matchkey is -1 and opts.findall is false, it will return the non-match result (indicated by -1) instead of a perhaps more expected nil or something else
        
    end
  end
  if opts.ret == "boolean" and not opts.findall and finalres == nil then finalres = false end
  if opts.findall and finalres == nil then finalres = {} end
  return finalres
end