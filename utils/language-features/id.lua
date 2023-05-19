--- Create a function that returns a unique identifier for a given object.
--- @return fun(any): number
function createIdentifier()
  local fn_id_map = setmetatable({}, {__mode = "k"}) -- weak keys to allow garbage collection
  local next_id = 0

  local function getIdentifier(thing)
    local id = fn_id_map[thing]
    if id == nil then
      next_id = next_id + 1
      id = next_id
      fn_id_map[thing] = id
    end
    return id
  end

  return getIdentifier
end

