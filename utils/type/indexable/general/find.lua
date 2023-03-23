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
  indexable = getDefaultInput(indexable)


  local finalres

  if not (type(indexable) == "string") then
    print("notstr")
    local iterator = getIterator(indexable, opts)

    for k, v in wdefarg(iterator)(indexable) do
      
      local retriever = {
        k = k,
        v = v,
        i = getIndex(indexable, k)
      }
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
      print("finalres")
      inspPrint(finalres)

    end
  else
    local matchkey, matchvalue
    local rest = indexable
    local index_accum = 0
    finalres = {}
    while true do
      preventInfiniteLoop(json.encode(indexable), 100)
      matchkey, matchvalue = findsingle(rest, cond, {
        ret = "kv"
      })
      local res = {}
      local retriever = {
        k = matchkey + index_accum,
        v = matchvalue,
        i = getIndex(indexable, matchkey + index_accum)
      }
      for _, retarg in ipairs(opts.ret) do 
        push(res, retriever[retarg])
      end
      print(matchkey, matchvalue)
      inspPrint(res)
      if opts.findall then
        if matchkey == -1 then break end
        table.insert(finalres, res)
        index_accum = index_accum + matchkey
        rest = slice(rest, matchkey + 1)
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