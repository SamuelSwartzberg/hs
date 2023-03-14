--- @class findOpts : tableProcOpts
--- @field findall boolean

---@alias findOptsWShorthand kvmult | kvmult[] | findOpts

--- @param indexable? indexable
--- @param cond? conditionSpec
--- @param opts? findOptsWShorthand
--- @return any
function find(indexable, cond, opts)
  cond = cond or false
  opts = defaultOpts(opts)
  indexable = getDefaultInput(indexable, opts)

  local finalres 

  if not type(indexable) == "string" then
     local iterator = getIterator(indexable, opts)

    
    if opts.findall then finalres = {} end

    for k, v in wdefarg(iterator)(indexable) do
      local retriever = {
        k = k,
        v = v
      }
      local res = {}
      for _, arg in ipairs(opts.args) do
        push(res, findsingle(retriever[arg], cond, {
          ret = opts.ret
        }))
      end
      if opts.findall then
        table.insert(finalres, res)
      else
        return table.unpack(res)
      end

    end
  else
    local matchkey, matchvalue
    while true do
      matchkey, matchvalue = findsingle(indexable, cond, {
        ret = "kv"
      })
      local res = {}
      local retriever = {
        k = matchkey,
        v = matchvalue
      }
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

  return finalres
end