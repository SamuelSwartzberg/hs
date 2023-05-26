--- @class hydrusRestSpec : RESTApiSpecifier

--- @param spec? hydrusRestSpec
--- @param do_after? fun(result: string): nil
function hydrus(spec, do_after)
  spec.api_name = "hydrus"
  spec.host = "http://127.0.0.1:45869/"
  spec.token_header = "Hydrus-Client-API-Access-Key:"
  if do_after then
    rest(spec, do_after)
  else
    local result = rest(spec)
    return result
  end
end
