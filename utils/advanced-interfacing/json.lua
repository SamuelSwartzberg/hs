--- @class RESTApiSpecifier
--- @field url? string 
--- @field host? string
--- @field endpoint? string
--- @field params? table
--- @field request_table? { [string]: any } | nil
--- @field api_key? string 
--- @field api_key_header? string
--- @field request_verb? string 

--- @param specifier? RESTApiSpecifier
--- @param do_after? fun(result: table): nil Using this function to decide whether to do sync or async, so for async requests that do nothing with their output (e.g. boring POST requests), you can just pass in any truthy value
--- @return any
function rest(specifier, do_after)
  local url
  specifier = copy(specifier) or {}
  if specifier.url then
    url = specifier.url
  elseif specifier.host or specifier.endpoint or specifier.params then
    url = ensureAdfix(specifier.host, "/", false, false, "suf")
    if specifier.endpoint then
      url = url .. (ensureAdfix(specifier.endpoint, "/") or "/")
    inspPrint(map(specifier.params, {_f = "%s=%s"}, { args = "kv", ret = "v", tolist = true }))
    end
    if specifier.params then
      url = url .. "?" .. concat({ sep = "&", isopts="isopts" }, map(specifier.params, {_f = "%s=%s"}, { args = "kv", ret = "v", tolist = true }) )
    end
  else
    url = "https://dummyjson.com/products?limit=10&skip=10"
  end
  
  local curl_args = {"curl"}

  curl_args = concat(curl_args, { {
    value = url,
    type = "quoted"
  } })

  curl_args = concat(curl_args, {
    "-H", 
    { value = "Content-Type: application/json", type = "quoted"},
    "-H",
    { value = "Accept: application/json", type = "quoted"},
  })
  if specifier.api_key then 
    specifier.api_key_header = specifier.api_key_header or "Authorization: Bearer"
    curl_args = concat(curl_args, {
      "-H",
      { value =  specifier.api_key_header .. " " .. specifier.api_key, type = "quoted"}
    })
  end
  if specifier.request_verb then
    curl_args = concat(curl_args, {
      "--request",
      { value = specifier.request_verb, type = "quoted"}
    })
  end
  if specifier.request_table then
    local request_json = json.encode(specifier.request_table)
    inspPrint(request_json)
    curl_args = concat(curl_args, {
      "-d",
      { value = request_json, type = "quoted"}
    })
  end
  
  return runJSON(curl_args, do_after)
end