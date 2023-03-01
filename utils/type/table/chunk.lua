--- @param tbl table|nil
--- @param chunk_size integer
--- @return table[]
function chunk(tbl, chunk_size)
  local t = {}
  local chunk = {}
  if chunk_size < 1 then return {tbl} end -- chunk size of 0 or less  = no chunking
  for k, v in wdefarg(pairs)(tbl) do
    chunk[k] = v
    if #keys(chunk) == chunk_size then
      t[#t+1] = chunk
      chunk = {}
    end
  end
  if #keys(chunk) > 0 then
    t[#t+1] = chunk
  end
  return t
end
