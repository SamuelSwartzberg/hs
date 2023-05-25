

--- @class RESTApiSpecifier
--- @field url? string the url to send the request to, if not using host, endpoint, and params
--- @field host? string
--- @field endpoint? string
--- @field params? table
--- @field request_table? { [string]: any } | nil the body of the request, if any
--- @field request_table_type? "json" | "form-urlencoded"
--- @field request_verb? string the HTTP verb to use for the request, defaults to GET
--- @field api_key? string manually specify the api key. Typically, prefer automatic retrieval of api key
--- @field api_name? string the name of the api, used for retrieving api keys
--- @field oauth2_subname? string the name of the oauth2 scope, used for retrieving api keys. will default to api_name if not specified
--- @field api_key_header? string allows for different HTTP header to be used for api key, for apis that don't use the "Authoirzation: Bearer" header
--- @field api_key_param? string allows for api_key to be passed as a param instead of a header, for apis that don't accept the key in a HTTP header
--- @field api_key_type? "simple" | "access_norefresh" | "oauth2" | "telegram"
--- @field oauth2_url? string the url to send the oauth2 request to
--- @field oauth2_authorization_url? string the url to send the oauth2 authorization request to, if different from oauth2_url. Is frequently different as it is shown to the user, but will default to oauth2_url if not specified

--- @param specifier? RESTApiSpecifier
--- @param do_after? fun(result: table): nil Using this function to decide whether to do sync or async, so for async requests that do nothing with their output (e.g. boring POST requests), you can just pass in any truthy value
--- @param have_tried_access_refresh? boolean
--- @return any
function rest(specifier, do_after, have_tried_access_refresh)
  specifier = copy(specifier) or {}

  if specifier.api_key_type == "oauth2" and  not specifier.oauth2_subname then
    specifier.oauth2_subname = specifier.api_name
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
    local function process_tokenres(tokenres)
      if tokenres.access_token then
        writeFile(oauth_keys_location .. "access_token", tokenres.access_token)
        if tokenres.refresh_token then
          writeFile(oauth_keys_location .. "refresh_token", tokenres.refresh_token)
        end
        return rest(specifier, do_after) -- try again
      else
        error("Failed to refresh access token. Result was:\n" .. json.encode(tokenres))
      end
    end
    if specifier.api_key == nil then -- initial token request
      if listContains(mt._list.apis_that_dont_support_authorization_code_fetch, specifier.api_name) then
        error("Cannot fetch access token for " .. specifier.api_name .. " because it doesn't support authorization code flow")
      end
      specifier.oauth2_authorization_url = specifier.oauth2_authorization_url or specifier.oauth2_url
      -- authorize the app by opening a browser window
      open({ 
        url = specifier.oauth2_authorization_url,
        params = {
          response_type = "code",
          client_id = readFile(api_keys_location .. "clientid"),
          redirect_uri = "http://127.0.0.1:8412/?api_name=" .. specifier.oauth2_subname
        }
      }, function() -- our server listening on the above port will save the authorization code to the proper location
        local authorization_code = readFile(oauth_keys_location .. "authorization_code")
        local token_request_body = {
          client_id = readFile(api_keys_location .. "clientid"),
          client_secret = readFile(api_keys_location .. "clientsecret"),
          code = authorization_code,
          grant_type = "authorization_code",
          redirect_uri = "http://127.0.0.1:8412/?api_name=" .. specifier.oauth2_subname
        }
        rest({
          url = specifier.oauth2_url,
          request_verb = "POST",
          request_table = token_request_body
        }, process_tokenres) -- typically, I would separate sync and async cases here, but there's no way to use open sync while waiting, since that'd block hammerspoon potentially for minutes, which is unacceptable. Therefore, only an async version is provided
        
      end)
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
        local request = {
          url = specifier.oauth2_url,
          request_verb = "POST",
          request_table = token_request_body
        }

        if do_after then
          rest(request, process_tokenres)
        else
          local tokenres = rest(request)
          return process_tokenres(tokenres)
        end
        
      else return true -- throw default error
      end
    end
  end

  if specifier.api_key_param then
    specifier.params = specifier.params or {}
    specifier.params[specifier.api_key_param] = specifier.api_key
  end

  local url = transf.url_components.url(specifier) or "https://dummyjson.com/products?limit=10&skip=10"
  
  
  local curl_command = {
    "curl", {
      value = url,
      type = "quoted"
    },
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
    local request_string, content_type

    specifier.request_table_type = specifier.request_table_type or "json"

    if specifier.request_table_type == "json" then
      request_string = json.encode(specifier.request_table)
      content_type = "application/json"
    elseif specifier.request_table_type == "form-urlencoded" then
      request_string = transf.table.url_params(specifier.request_table)
      content_type = "application/x-www-form-urlencoded"
    end
    
    push(curl_command, "-H")
    push(curl_command, 
      { value = "Content-Type: " + content_type, type = "quoted"}
    )
    push(curl_command, "-d")
    push(curl_command, 
      { value = request_string, type = "quoted"}
    )
  end
  
  return runJSON({
    args = curl_command,
    json_catch = catch_auth_error,
  }, do_after)
end