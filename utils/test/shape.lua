local types = { "string", "number", "boolean", "table", "function", "nil", "thread", "userdata" }
local types_w_any = copy(types, false)
table.insert(types_w_any, "any")

--- @alias shape_table { [string]: string|shape_table }

--- Resolve keys that match a specific type (via (an) `[<type>|any]` key(s)) to any keys of that type in the test table
--- @param test_tbl table 
--- @param shape shape_table
--- @return nil
function resolveTypeMatchingToKeys(test_tbl, shape)
  for _, typ in iprs(types_w_any) do -- for any possible type
    if shape["[" .. typ .. "]"] then -- if shape has a key "[<type>|any]", then this is the type we want for any key (of type|any) not explicitly specified in the shape
      for k, _ in prs(test_tbl) do -- for each key in test_tbl
        if type(k) == typ or typ == "any" then -- if the test_tbl key is of the type we want
          if not shape[k] then -- and if the test_tbl key is not explicitly specified in the shape already
            shape[k] = copy(shape["[" .. typ .. "]"])  -- then add a copy of the type we want to the shape
          end
        end
      end
      shape["[" .. typ .. "]"] = nil
    end
  end
end

--- @param test_tbl table 
--- @param shape shape_table
--- @param path string the table name if root, or the path to the subtable if within recursive 
--- @return boolean
function shapeMatches(test_tbl, shape, path)
  local succ, res = pcall(shapeMatchesInner, test_tbl, shape, path)
  if not succ then
    print(res)
  end
  return succ
end

--- @param test_tbl table 
--- @param shape shape_table
--- @param path string the table name if root, or the path to the subtable if within recursive 
--- @return true|nil
function shapeMatchesInner(test_tbl, shape, path)
  if not test_tbl then error("test_tbl expected", 0) end
  if not shape then error("shape expected", 0) end
  resolveTypeMatchingToKeys(test_tbl, shape)
  local recollected_optional_keys = {}
  for k, v in prs(shape, nil, nil, -1) do -- reverse order, so that if we remove a key, we don't interfere with the iteration. This would not be necessary if we using `pairs`, which is unordered, but prs uses a key order for internal ordering, where deleting a key will break the iteration completely if it comes after the current key. I *think* reverse order is the best way to go here, but if I encounter more bugs, I'll have to rethink this.
    local is_optional = stringy.endswith(k, "?")
    if is_optional then
      local old_k = k
      k = eutf8.sub(k, 1, -2)
      --- following is necessary to prevent throwing an error for key in test_tbl but not in shape
      recollected_optional_keys[k] = v
      shape[old_k] = nil
    end
    if not test_tbl[k] then 
      if not is_optional then
        error(("Key %s in %s is missing"):format(k, path), 0)
      end -- else do nothing, optional key is missing, so who cares
    elseif type(v) == "string" then -- string specifying desired type
      if v == "any" then
        -- do nothing, any type is allowed
      elseif type(test_tbl[k]) ~= v then 
        error(("Key %s in %s is not of type %s, but instead of type %s"):format(k, path, v, type(test_tbl[k])), 0) 
      end
    elseif type(v) == "table" then -- table specifying subtable shape
      if type(test_tbl[k]) ~= "table" then 
        error(("Key %s in %s is not of type table, but instead of type %s"):format(k, path, type(test_tbl[k])), 0) 
      else
        local succ, res = pcall(shapeMatchesInner,test_tbl[k], v, path .. "." .. k)
        if not succ then
          error(res, 0)
        end
      end
    else
      error(("Unexpected value in shape: %s"):format(v), 0)
    end
  end
  for k, v in prs(recollected_optional_keys) do
    shape[k] = v
  end
  for k, v in prs(test_tbl) do
    if not shape[k] then 
      error(("Key %s is in %s but not in shape"):format(k, path), 0) 
    end
  end
  return true
end