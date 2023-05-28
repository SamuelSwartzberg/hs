--- @alias header_or_param "header" | "param" | "both"

--- @class RESTApiSpecifier
--- @field url? string The URL to send the request to. This is used if not making use of the scheme, host and endpoint params fields.
--- @field scheme? string The scheme to use for the request. Defaults to "https://".
--- @field host? string The host of the API server. If nil, tries to fetch it from a stored default for the api.
--- @field endpoint? string The API endpoint to call.
--- @field params? table Any URL parameters to include in the request.
--- @field request_table? { [string]: any } | nil The body of the request. This is used for POST/PUT/PATCH requests.
--- @field request_table_type? "json" | "form" | "form-urlencoded" The format to use for the request body. Defaults to JSON.
--- @field request_verb? string The HTTP verb to use for the request. Defaults to GET, or POST if request_table is specified.
--- @field auth_process? string The type of authentication process to use. Will be Bearer/Basic for token/username-password if not specified.
--- @field token? string The authentication token to use. If not specified, it will be fetched automatically.
--- @field username? string The username for Basic authentication. It can be retrieved from disk for the specified API or default to env.MAIN_EMAIL.
--- @field password? string The password for Basic authentication. It can be retrieved from disk for the specified API.
--- @field auth_header? string The header to use for authentication. If nil, it will be fetched from a stored default for the api, or default to "Authorization".
--- @field api_name? string The name of the API. This is used for retrieving tokens and usernames/passwords.
--- @field token_param? string The parameter name for the token when it's passed as a parameter. Defaults to "access_token" if token_type is "oauth2" and "api_key" if token_type is "simple".
--- @field token_where? header_or_param | boolean Where to specify the token, if at all. If nil, it will  be fetched from a stored default for the api, or default to false/nil.
--- @field username_param? string The parameter name for the username when it's passed as a parameter.
--- @field password_param? string The parameter name for the password when it's passed as a parameter.
--- @field username_pw_where? header_or_param | boolean Where to specify the username/password, if at all. If nil, it will  be fetched from a stored default for the api, or default to false/nil.
--- @field token_type? "simple" | "oauth2" | "telegram" The type of token to use. Defaults to "simple".
--- @field oauth2_url? string The URL to send the OAuth2 request to. If nil but required, tries to fetch it from a stored default for the api.
--- @field oauth2_authorization_url? string The URL to send the OAuth2 authorization request to. If not specified, it will default to oauth2_url. If nil but required, tries to fetch it from a stored default for the api.
--- @field non_json_response? boolean Indicates whether the response is not JSON. Some REST apis may return non-JSON responses in certain cases, this is used to handle those cases. Defaults to false. If using this, oauth2 token refresh with a refresh token will not work.
--- @field run_json_opts run_first_arg args to pass through to runJSON. Mainly used for testing.

--- @param specifier? RESTApiSpecifier
--- @param do_after? fun(result: table): nil Function to execute after the request is completed. This is used to make the request synchronous or asynchronous.
--- @param have_tried_access_refresh? boolean Indicates whether an attempt to refresh the access token has been made.
--- @return any
function rest(specifier, do_after, have_tried_access_refresh)
  specifier = copy(specifier) or {}

  local api_keys_location, catch_auth_error

  if specifier.api_name then
    specifier.token_where = specifier.token_where or tblmap.api_name.token_where[specifier.api_name]
    specifier.username_pw_where = specifier.username_pw_where or tblmap.api_name.username_pw_where[specifier.api_name]
  end

  -- fetch tokens

  if specifier.token_where then

    if specifier.api_name then
      api_keys_location = env.MAPI .. "/" .. specifier.api_name .. "/" 
    end

    specifier.token_type = specifier.token_type or "simple"

    if not specifier.token then
      if not specifier.api_name then
        error("Cannot fetch token without api_name", 0)
      end
      local keyloc
      if specifier.token_type == "simple" then
        keyloc = api_keys_location .. "key"
      elseif specifier.token_type == "oauth2" then
        keyloc = api_keys_location .. "access_token"
      elseif specifier.token_type == "telegram" then
        -- todo
      end
      specifier.token = readFile(keyloc)
    end

    if specifier.token_type == "oauth2"  then

      if not do_after then
        error("Oauth2 requests must be async. Please pass in a do_after function. (This is because some of the steps required cannot be done in a blocking manner, as they require user input and hammerspoon is single-threaded)")
      end

      local function process_tokenres(tokenres)
        if tokenres.access_token then
          writeFile(api_keys_location .. "access_token", tokenres.access_token)
          if tokenres.refresh_token then
            writeFile(api_keys_location .. "refresh_token", tokenres.refresh_token)
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
      local refresh_token = readFile(api_keys_location .. "refresh_token")

      local function initial_authorize()
        if listContains(mt._list.apis_that_dont_support_authorization_code_fetch, specifier.api_name) then
          error("Cannot fetch access token for " .. specifier.api_name .. " because it doesn't support authorization code flow")
        end
        specifier.oauth2_url = specifier.oauth2_url or tblmap.api_name.oauth2_url[specifier.api_name]
        specifier.oauth2_authorization_url = specifier.oauth2_authorization_url or tblmap.api_name.oauth2_authorization_url[specifier.api_name] or specifier.oauth2_url


        -- authorize the app by opening a browser window
        
        local open_spec ={ 
          url = specifier.oauth2_authorization_url,
          params = {
            response_type = "code",
            client_id = clientid,
            redirect_uri = "http://127.0.0.1:8412/?api_name=" .. specifier.api_name
          }
        }
        if tblmap.api_name.needs_scopes[specifier.api_name] then
          open_spec.params.scope = tblmap.api_name.scopes[specifier.api_name]
        end
        
        open(open_spec, function() -- our server listening on the above port will save the authorization code to the proper location
          local authorization_code = readFile(api_keys_location .. "authorization_code")
          delete( api_keys_location .. "authorization_code")
          if not authorization_code then
            error("Failed to get authorization code from server")
          end
          local token_request_body = {
            client_id = clientid,
            client_secret = clientsecret,
            code = authorization_code,
            grant_type = "authorization_code",
            redirect_uri = "http://127.0.0.1:8412/?api_name=" .. specifier.api_name
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

      if specifier.token == nil then -- initial token request
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

  end

  -- fetch username/password

  if specifier.username_pw_where then
    specifier.username = specifier.username or readFile(env.MPASSUSERNAME .. "/" .. specifier.api_name .. ".txt") or env.MAIN_EMAIL
    specifier.password = specifier.password or run("pass passw/" .. specifier.api_name )
    if not specifier.username then
      error("Username required but could not be fetched. Specifier: " .. json.encode(specifier))
    end
    if not specifier.password then
      error("Password required but could not be fetched. Specifier: " .. json.encode(specifier))
    end
  end

  -- add authentication deets to params

  if specifier.token_where == "param" or specifier.token_where == "both" then
    if specifier.token_type == "oauth2" then
      specifier.token_param = specifier.token_param or "access_token"
    elseif specifier.token_type == "simple" then
      specifier.token_param = specifier.token_param or "api_key"
    end

    specifier.params = specifier.params or {}
    specifier.params[specifier.token_param] = specifier.token
  end

  if specifier.username_pw_where == "param" or specifier.username_pw_where == "both" then
    specifier.params = specifier.params or {}
    specifier.username_param = specifier.username_param or "username"
    specifier.password_param = specifier.password_param or "password"
    specifier.params[specifier.username_param] = specifier.username
    specifier.params[specifier.password_param] = specifier.password
  end

  if not specifier.host and not specifier.url then
    specifier.host = tblmap.api_name.host[specifier.api_name]
  end

  local url = transf.url_components.url(specifier)

  if not url then
    error("Failed to get url from specifier:\n" .. json.encode(specifier))
  end

 -- basic curl command
  
  local curl_command = {
    "curl", {
      value = url,
      type = "quoted"
    }
  }

  if not specifier.non_json_response then
    push(curl_command, "-H")
    push(curl_command, { value = "Accept: application/json", type = "quoted"})
  end

  if specifier.api_name then
    specifier.auth_header = specifier.auth_header or tblmap.api_name.auth_header[specifier.api_name]
  end

  specifier.auth_header = specifier.auth_header or "Authorization"
  specifier.auth_header = mustEnd(specifier.auth_header, ": ")

  -- add auth to curl command

  if specifier.api_name then
    specifier.auth_process = specifier.auth_process or tblmap.api_name.auth_process[specifier.api_name]
  end

  if specifier.token_where == "header" or specifier.token_where == "both" then
    local auth_header = specifier.auth_header .. mustEnd(specifier.auth_process or "Bearer", " ")
    push(curl_command, "-H")
    push(curl_command, 
      { value =  auth_header .. specifier.token, type = "quoted"})
  end

  if specifier.username_pw_where == "header" or specifier.username_pw_where == "both" then
    local auth_header = specifier.auth_header .. mustEnd(specifier.auth_process or "Basic", " ")
    push(curl_command, "-H")
    push(curl_command, 
      { value =  auth_header .. transf.string.base64_url(specifier.username .. ":" .. specifier.password), type = "quoted"})
  end

  -- assembole other parts of curl commmand

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

    if specifier.request_table_type ~= "form" then
      if specifier.request_table_type == "json" then
        request_string = json.encode(specifier.request_table)
        content_type = "application/json"
      elseif specifier.request_table_type == "form-urlencoded" then
        request_string = transf.table.url_params(specifier.request_table)
        content_type = "application/x-www-form-urlencoded"
      end
      push(curl_command, "-d")
      push(curl_command, 
        { value = request_string, type = "quoted"}
      )
    else
      content_type = "multipart/form-data"
      local form_field_args = transf.table.curl_form_field_list(specifier.request_table)
      curl_command = concat(
        curl_command,
        form_field_args
      )
    end
    
    push(curl_command, "-H")
    push(curl_command, 
      { value = "Content-Type: " .. content_type, type = "quoted"}
    )
  
  end
  local args = {
    args = curl_command,
  }
  if specifier.run_json_opts then
    args = glue(args, specifier.run_json_opts)
  end
  if not specifier.non_json_response then
    args.json_catch = catch_auth_error
    return runJSON(args, do_after)
  else 
    return run(args, do_after)
  end
end