--- @class RESTApiSpecifier
--- @field url? string 
--- @field host? string
--- @field endpoint? string
--- @field params? table
--- @field request_table? { [string]: any } | nil
--- @field api_key? string 
--- @field api_name? string
--- @field oauth2_subname? string
--- @field api_key_header? string
--- @field api_key_type? "simple" | "access_norefresh" | "oauth2" | "telegram"
--- @field oauth2_url? string
--- @field request_verb? string 

--- @param specifier? RESTApiSpecifier
--- @param do_after? fun(result: table): nil Using this function to decide whether to do sync or async, so for async requests that do nothing with their output (e.g. boring POST requests), you can just pass in any truthy value
--- @param have_tried_access_refresh? boolean
--- @return any
function rest(specifier, do_after, have_tried_access_refresh)
  local url
  specifier = copy(specifier) or {}
  if specifier.url then
    url = specifier.url
  elseif specifier.host or specifier.endpoint or specifier.params then
    url = mustNotEnd(specifier.host, "/")
    if specifier.endpoint then
      url = url .. (mustStart(specifier.endpoint, "/") or "/")
    end
    if specifier.params then
      url = url .. "?" .. transf.table.url_params(specifier.params)
    end
  else
    url = "https://dummyjson.com/products?limit=10&skip=10"
  end

  local api_keys_location = env.MAPI .. "/" .. specifier.api_name .. "/" 
  local oauth_keys_location = env.MAPI .. "/" .. specifier.oauth2_subname .. "/" 

  -- if we have an api_name, used for fetching api keys, we can be pretty sure we need an api key
  if specifier.api_name then
    specifier.api_key_type = specifier.api_key_type or "simple"
  end
  if specifier.oauth2_subname then specifier.api_key_type = "oauth2" end

  if not specifier.api_key then
    local keyloc
    if specifier.api_key_type == "simple" then
      keyloc = api_keys_location .. "key"
    elseif specifier.api_key_type == "access_norefresh" or specifier.api_key_type == "oauth2" then
      keyloc = oauth_keys_location .. "access_token"
    elseif specifier.api_key_type == "telegram" then
      -- todo
    end
    specifier.api_key = readFile(keyloc)
  end

  local catch_auth_error
  if specifier.api_key_type == "oauth2" or specifier.api_key_type == "access_norefresh" then
    if specifier.api_key == nil then
      error("no access token provided, and logic for initial token request not yet implemented")
    end
    catch_auth_error = function(res)
      if res.error and res.error.errors and res.error.errors[1] and res.error.errors[1].reason == "authError" then -- try to refresh token
        if specifier.api_key_type == "access_norefresh" then
          error("Access token expired, but api_key_type is access_norefresh, so cannot refresh token. Response was:\n" .. json.encode(res))
        end
        if have_tried_access_refresh then
          error("Access token expired, and already tried to refresh token, but failed. Response was:\n" .. json.encode(res))
        end
        local token_request_body = {
          client_id = readFile(api_keys_location .. "clientid"),
          client_secret = readFile(api_keys_location .. "clientsecret"),
          refresh_token = readFile(oauth_keys_location .. "refresh_token"),
          grant_type = "refresh_token"
        }
        local tokenres = rest({
          url = specifier.oauth2_url,
          request_verb = "POST",
          request_table = token_request_body
        })
        if tokenres.access_token then
          writeFile(oauth_keys_location .. "access_token", tokenres.access_token)
          if tokenres.refresh_token then
            writeFile(oauth_keys_location .. "refresh_token", tokenres.refresh_token)
          end
          return rest(specifier, do_after) -- try again
        else
          error("Failed to refresh access token. Result was:\n" .. json.encode(tokenres))
        end
      else return true -- throw default error
      end
    end
  end
  
  local curl_command = {
    "curl", {
      value = url,
      type = "quoted"
    },
    "-H", 
    { value = "Content-Type: application/json", type = "quoted"},
    "-H",
    { value = "Accept: application/json", type = "quoted"},
  }
  if specifier.api_key then 
    specifier.api_key_header = specifier.api_key_header or "Authorization: Bearer"
    push(curl_command, "-H")
    push(curl_command, 
      { value =  specifier.api_key_header .. " " .. specifier.api_key, type = "quoted"}
    )
  end
  if specifier.request_verb then
    push(curl_command, "--request")
    push(curl_command, 
      { value = specifier.request_verb, type = "quoted"}
    )
  end
  if specifier.request_table then
    local request_json = json.encode(specifier.request_table)
    push(curl_command, "-d")
    push(curl_command, 
      { value = request_json, type = "quoted"}
    )
  end
  
  return runJSON({
    args = curl_command,
    json_catch = catch_auth_error,
  }, do_after)
end