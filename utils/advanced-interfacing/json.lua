

--- @class RESTApiSpecifier
--- @field url? string the url to send the request to, if not using host, endpoint, and params
--- @field host? string
--- @field endpoint? string
--- @field params? table
--- @field request_table? { [string]: any } | nil the body of the request, if any
--- @field request_table_type? "json" | "form-urlencoded"
--- @field request_verb? string the HTTP verb to use for the request, defaults to GET, or POST if request_table is specified
--- @field auth_process? "bearer" | "basic" | "manual" | "none" Which authentication process to use. Defaults to "none" if nothing related to tokens is specified, or to token otherwise.
--- @field token? string manually specify the token. Typically, prefer automatic retrieval of token. Usage of token in any way precludes the usage of username/password
--- @field username? string necessary when auth_process "basic", but we will try and fetch it from disk for api_name if not manually provided, or default to env.MAIN_EMAIL
--- @field password? string necessary when auth_process "basic", but we will try and fetch it from disk for api_name if not manually provided
--- @field token_header? string allows for different HTTP header to be used for token, for apis that don't use the "Authorization: " header
--- @field api_name? string the name of the api, used for retrieving tokens and usernames/passwords
--- @field oauth2_subname? string the name of the oauth2 scope, used for retrieving tokens. will default to api_name if not specified
--- @field token_param? string allows for token to be passed as a param instead of a header, for apis that don't accept the key in a HTTP header
--- @field token_type? "simple" | "oauth2" | "telegram"
--- @field oauth2_url? string the url to send the oauth2 request to
--- @field oauth2_authorization_url? string the url to send the oauth2 authorization request to, if different from oauth2_url. Is frequently different as it is shown to the user, but will default to oauth2_url if not specified

--- @param specifier? RESTApiSpecifier
--- @param do_after? fun(result: table): nil Using this function to decide whether to do sync or async, so for async requests that do nothing with their output (e.g. boring POST requests), you can just pass in any truthy value
--- @param have_tried_access_refresh? boolean
--- @return any
function rest(specifier, do_after, have_tried_access_refresh)
  specifier = copy(specifier) or {}

  if specifier.token_type == "oauth2" and  not specifier.oauth2_subname then
    specifier.oauth2_subname = specifier.api_name
  end

  local api_keys_location = env.MAPI .. "/" .. specifier.api_name .. "/" 
  local oauth_keys_location = env.MAPI .. "/" .. specifier.oauth2_subname .. "/" 

  -- if we have an api_name, used for fetching tokens, we can be pretty sure we need an token
  if specifier.api_name then
    specifier.token_type = specifier.token_type or "simple"
  end
  if specifier.oauth2_subname then specifier.token_type = "oauth2" end
  

  local token
  if not specifier.token then
    local keyloc
    if specifier.token_type == "simple" then
      keyloc = api_keys_location .. "key"
    elseif specifier.token_type == "oauth2" then
      keyloc = oauth_keys_location .. "access_token"
    elseif specifier.token_type == "telegram" then
      -- todo
    end
    token = readFile(keyloc)
  else
    token = specifier.token
  end

  local catch_auth_error
  if specifier.token_type == "oauth2"  then

    if not do_after then
      error("Oauth2 requests must be async. Please pass in a do_after function. (This is because some of the steps required cannot be done in a blocking manner, as they require user input and hammerspoon is single-threaded)")
    end

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

    local clientid = readFile(api_keys_location .. "clientid")
    local clientsecret = readFile(api_keys_location .. "clientsecret")
    if not clientid or not clientsecret then
      error("Failed to get clientid or clientsecret from " .. api_keys_location ". Oauth2 apis must have these. Are you sure you've already set up the api?")
    end
    local refresh_token = readFile(oauth_keys_location .. "refresh_token")

    local function initial_authorize()
      if listContains(mt._list.apis_that_dont_support_authorization_code_fetch, specifier.api_name) then
        error("Cannot fetch access token for " .. specifier.api_name .. " because it doesn't support authorization code flow")
      end
      specifier.oauth2_authorization_url = specifier.oauth2_authorization_url or specifier.oauth2_url
      -- authorize the app by opening a browser window
      
      
      open({ 
        url = specifier.oauth2_authorization_url,
        params = {
          response_type = "code",
          client_id = clientid,
          redirect_uri = "http://127.0.0.1:8412/?api_name=" .. specifier.oauth2_subname
        }
      }, function() -- our server listening on the above port will save the authorization code to the proper location
        local authorization_code = readFile(oauth_keys_location .. "authorization_code")
        delete( oauth_keys_location .. "authorization_code")
        if not authorization_code then
          error("Failed to get authorization code from server")
        end
        local token_request_body = {
          client_id = clientid,
          client_secret = clientsecret,
          code = authorization_code,
          grant_type = "authorization_code",
          redirect_uri = "http://127.0.0.1:8412/?api_name=" .. specifier.oauth2_subname
        }
        rest({
          url = specifier.oauth2_url,
          request_table = token_request_body
        }, process_tokenres)
        
      end)
    end

    local function do_refresh_token()
      local token_request_body = {
        client_id = clientid,
        client_secret = clientsecret,
        refresh_token = refresh_token,
        grant_type = "refresh_token"
      }
      local request = {
        url = specifier.oauth2_url,
        request_table = token_request_body
      }
      rest(request, process_tokenres, true)
    end

    if token == nil then -- initial token request
      if refresh_token then
        do_refresh_token()
      else
        initial_authorize()
      end
    end

    catch_auth_error = function(res)
      if have_tried_access_refresh then
        error("Access token expired, and already tried to refresh token, but failed. Response was:\n" .. json.encode(res))
      end
      if refresh_token then
        do_refresh_token()
      else
        initial_authorize()
      end
    end
  end

  if specifier.token_param then
    specifier.params = specifier.params or {}
    specifier.params[specifier.token_param] = token
  end

  local url = transf.url_components.url(specifier) or "https://dummyjson.com/products?limit=10&skip=10"

  if (specifier.token and not specifier.token_param) then
    specifier.auth_process = specifier.auth_process or "bearer"
  end

  if specifier.auth_process == "basic" then
    specifier.username = specifier.username or readFile(env.MPASSUSERNAME .. "/" .. specifier.api_name .. ".txt")
    specifier.password = specifier.password or run("pass passw/" .. specifier.api_name )
  end
  
  
  local curl_command = {
    "curl", {
      value = url,
      type = "quoted"
    },
    "-H",
    { value = "Accept: application/json", type = "quoted"},
  }
  
  if listContains(mt._list.auth_processes, specifier.auth_process) then
    local auth_header = specifier.token_header or "Authorization: "
    auth_header = mustEnd(auth_header, ": ")
    if specifier.auth_process == "bearer" then
      auth_header = auth_header .. "Bearer " .. specifier.token
    elseif specifier.auth_process == "basic" then
      auth_header = auth_header .. "Basic " .. transf.string.base64_url(specifier.username .. ":" .. specifier.password)
    else
      auth_header = auth_header .. specifier.token
    end

    push(curl_command, "-H")
    push(curl_command, 
      { value =  specifier.token_header .. " " .. specifier.token, type = "quoted"}
    )
  end
  if specifier.request_verb then
    push(curl_command, "--request")
    push(curl_command, 
      { value = specifier.request_verb, type = "quoted"}
    )
  end
  if specifier.request_table then
    specifier.request_verb = specifier.request_verb or "POST"
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