--- @alias header_or_param "header" | "param" | "header+param"

--- @class RESTApiSpecifier
--- @field url? str The URL to send the request to. This is used if not making use of the scheme, host and endpoint params fields.
--- @field scheme? str The scheme to use for the request. If nil, it will be fetched from a stored default for the api, or default to "https://".
--- @field host? str The host of the API server. If nil, tries to fetch it from a stored default for the api.
--- @field endpoint? str The API endpoint to call.
--- @field params? table Any URL parameters to include in the request.
--- @field request_table? { [str]: any } | nil The body of the request. This is used for POST/PUT/PATCH requests.
--- @field request_table_type? "json" | "form" | "form-urlencoded" The format to use for the request body. Defaults to JSON.
--- @field request_verb? str The HTTP verb to use for the request. Defaults to GET, or POST if request_table is specified.
--- @field auth_process? str The type of authentication process to use. Will be Bearer/Basic for token/username-password if not specified.
--- @field token? str The authentication token to use. If not specified, it will be fetched automatically.
--- @field username? str The username for Basic authentication. It can be retrieved from disk for the specified API or default to env.MAIN_EMAIL.
--- @field password? str The password for Basic authentication. It can be retrieved from disk for the specified API.
--- @field auth_header? str The header to use for authentication. If nil, it will be fetched from a stored default for the api, or default to "Authorization".
--- @field api_name? str The name of the API. This is used for retrieving tokens and usernames/passwords.
--- @field token_param? str The parameter name for the token when it's passed as a parameter. Defaults to "access_token" if token_type is "oauth2" and "api_key" if token_type is "simple".
--- @field token_where? header_or_param | boolean Where to specify the token, if at all. If nil, it will  be fetched from a stored default for the api, or default to false/nil.
--- @field username_param? str The parameter name for the username when it's passed as a parameter.
--- @field password_param? str The parameter name for the password when it's passed as a parameter.
--- @field username_pw_where? header_or_param | boolean Where to specify the username/password, if at all. If nil, it will  be fetched from a stored default for the api, or default to false/nil.
--- @field token_type? "simple" | "oauth2" | "telegram" The type of token to use. If nil, it will be fetched from a stored default for the api, or default to "simple".
--- @field oauth2_url? str The URL to send the OAuth2 request to. If nil but required, tries to fetch it from a stored default for the api.
--- @field oauth2_authorization_url? str The URL to send the OAuth2 authorization request to. If not specified, it will default to oauth2_url. If nil but required, tries to fetch it from a stored default for the api.
--- @field non_json_response? boolean Indicates whether the response is not JSON. Some REST apis may return non-JSON responses in certain cases, this is used to handle those cases. Defaults to false. If using this, oauth2 token refresh with a refresh token will not work.
--- @field accept_json_different_header? str Some data may be sent as JSON but not have the content type "application/json", for example vnd.citationstyles.csl+json. This is used to handle those cases.

--- @param specifier? RESTApiSpecifier
--- @param do_after? fun(result: table): nil Function to execute after the request is completed. This is used to make the request synchronous or asynchronous.
--- @param have_tried_access_refresh? boolean Indicates whether an attempt to refresh the access token has been made.
--- @return any
function rest(specifier, do_after, have_tried_access_refresh)
  local original_specifier = specifier
  specifier = get.table.table_by_copy(specifier) or {}

  local catch_auth_error, secondary_api_name

  if specifier.api_name then
    if tblmap.secondary_api_name.api_name[specifier.api_name] then
      secondary_api_name = specifier.api_name
      specifier.api_name = tblmap.secondary_api_name.api_name[specifier.api_name]
    end

    specifier.token_where = specifier.token_where or tblmap.api_name.api_request_kv_location_by_token_where[specifier.api_name]
    specifier.username_pw_where = specifier.username_pw_where or tblmap.api_name.api_request_kv_location_by_username_pw_where[specifier.api_name]
  end

  -- fetch tokens

  if specifier.token_where then

    specifier.token_type = specifier.token_type or tblmap.api_name.token_type[specifier.api_name] or "simple"

    if not specifier.token then
      if not specifier.api_name then
        error("Cannot fetch token without api_name", 0)
      end
      local keyloc
      if specifier.token_type == "simple" then
        keyloc = transf.api_name.local_absolute_path_by_api_key_file(specifier.api_name)
      elseif specifier.token_type == "oauth2" then
        keyloc = transf.api_name.local_absolute_path_by_access_token_file(specifier.api_name)
      end
      specifier.token = transf.file.str_by_contents(keyloc)
    end

    if specifier.token_type == "oauth2"  then

      local function process_tokenres(tokenres)
        if tokenres.refresh_token then
          dothis.api_name.write_refresh_token(specifier.api_name, tokenres.refresh_token)
        end
        if tokenres.access_token then
          dothis.api_name.write_access_token(specifier.api_name, tokenres.access_token)
          return rest(original_specifier, do_after) -- try again
        else
          error("Failed to refresh access token. Result was:\n" .. json.encode(tokenres))
        end
      end

      local clientid = transf.api_name.str_or_nil_by_client_id(specifier.api_name)
      local clientsecret = transf.api_name.str_or_nil_by_client_secret(specifier.api_name)
      if not clientid or not clientsecret then
        error("Failed to get clientid or clientsecret for " .. specifier.api_name ". Oauth2 apis must have these. Are you sure you've already set up the api?")
      end
      local refresh_token = transf.api_name.str_or_nil_by_refresh_token(specifier.api_name)

      specifier.oauth2_url = specifier.oauth2_url or tblmap.api_name.http_protocol_url_by_oauth2_url[specifier.api_name]
      specifier.oauth2_authorization_url = specifier.oauth2_authorization_url or tblmap.api_name.oauth2_authorization_url[specifier.api_name] or specifier.oauth2_url

      local function authorize_app()

        -- authorize the app by opening a browser window
        
        local open_spec ={ 
          clean_url = specifier.oauth2_authorization_url,
          params = {
            response_type = "code",
            client_id = clientid,
            reblob_uri = "http://127.0.0.1:8412/?api_name=" .. specifier.api_name
          }
        }
        if tblmap.api_name.bool_by_needs_scopes[specifier.api_name] then
          open_spec.params.scope = tblmap.api_name.str_by_scopes[specifiper.api_name]
        end
        if tblmap.api_name.str_key_str_value_assoc_by_additional_auth_params[specifier.api_name] then
          open_spec.params = transf.two_table_or_nils.table_by_take_new(open_spec.params, tblmap.api_name.str_key_str_value_assoc_by_additional_auth_params[specifier.api_name])
        end
        
        dothis.url_components.open_browser(open_spec, nil, function() -- our server listening on the above port will save the authorization code to the proper location
          local authorization_code = transf.api_name.str_or_nil_by_authorization_code(specifier.api_name)
          act.api_name.delete_authorization_code(specifier.api_name)
          if not authorization_code then
            error("Failed to get authorization code from server")
          end
          local token_request_body = {
            client_id = clientid,
            client_secret = clientsecret,
            code = authorization_code,
            grant_type = "authorization_code",
            reblob_uri = "http://127.0.0.1:8412/?api_name=" .. specifier.api_name
          }
          rest({
            url = specifier.oauth2_url,
            request_table = token_request_body,
            request_table_type = "form-urlencoded"
          }, process_tokenres, true)
          
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
          request_table = token_request_body,
          request_table_type = "form-urlencoded"
        }
        rest(request, process_tokenres, true)
      end

      if specifier.token == nil then -- initial token request
        local original_do_after = do_after
        if not original_do_after then
          do_after = transf['nil']['nil']
        end
        if refresh_token then
          do_refresh_token()
        else
          authorize_app()
        end
        if not do_after then
          print("Needed to (re)fetch access token, which must be done asynchronously. Returning nil for now, must be called again after token is fetched. This behavior is not ideal, but at least it doesn't permanently brick the program.")
        end
        return -- we're done here, we'll retry after we get the token
      end

      catch_auth_error = function(res)
        if have_tried_access_refresh then
          error("Access token expired, and already tried to refresh token, but failed. Response was:\n" .. res)
        end
        if refresh_token then
          do_refresh_token()
        else
          authorize_app()
        end
      end
    end

  end

  -- fetch username/password

  if specifier.username_pw_where then
    specifier.username = specifier.username or transf.file.str_by_contents(dynamic_permanents.str_key_str_value_assoc_by_env.MPASSUSERNAME .. "/" .. specifier.api_name .. ".txt") or dynamic_permanents.str_key_str_value_assoc_by_env.MAIN_EMAIL
    specifier.password = specifier.password or transf.str.str_or_nil_by_evaled_env_bash_stripped("pass passw/" .. specifier.api_name )
    if not specifier.username then
      error("Username required but could not be fetched. Specifier: " .. json.encode(specifier))
    end
    if not specifier.password then
      error("Password required but could not be fetched. Specifier: " .. json.encode(specifier))
    end
  end

  -- add authentication deets to params

  if specifier.token_where == "param" or specifier.token_where == "header+param" then
    if specifier.token_type == "oauth2" then
      specifier.token_param = specifier.token_param or "access_token"
    elseif specifier.token_type == "simple" then
      specifier.token_param = specifier.token_param or "api_key"
    end

    specifier.params = specifier.params or {}
    specifier.params[specifier.token_param] = specifier.token
  end

  if specifier.username_pw_where == "param" or specifier.username_pw_where == "header+param" then
    specifier.params = specifier.params or {}
    specifier.username_param = specifier.username_param or "username"
    specifier.password_param = specifier.password_param or "password"
    specifier.params[specifier.username_param] = specifier.username
    specifier.params[specifier.password_param] = specifier.password
  end

  -- adjust url

  if not specifier.host and not specifier.url then
    specifier.host = tblmap.api_name.host[specifier.api_name]
  end

  if secondary_api_name and tblmap.secondary_api_name.noweirdwhitespace_line_by_endpoint_prefix[secondary_api_name] and specifier.endpoint then
    specifier.endpoint = get.str.str_by_with_suffix(tblmap.secondary_api_name.noweirdwhitespace_line_by_endpoint_prefix[secondary_api_name], "/") .. get.str.str_by_no_prefix(specifier.endpoint, "/")
  end

  if secondary_api_name and tblmap.secondary_api_name.str_key_str_value_assoc_by_default_params[secondary_api_name] then
    specifier.params = specifier.params or {}
    specifier.params = transf.two_table_or_nils.table_by_take_new(get.table.table_by_copy(tblmap.secondary_api_name.str_key_str_value_assoc_by_default_params[secondary_api_name], true), specifier.params)
  end

  specifier.scheme = specifier.scheme or tblmap.api_name.url_scheme[specifier.api_name]

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
    dothis.arr.push(curl_command, "-H")
    dothis.arr.push(curl_command, { 
      value = "Accept: " .. (specifier.accept_json_different_header or "application/json"),
      type = "quoted"}
    )
  end

  if specifier.api_name then
    specifier.auth_header = specifier.auth_header or tblmap.api_name.alphanum_minus_underscore_by_auth_header[specifier.api_name]
  end

  specifier.auth_header = specifier.auth_header or "Authorization"
  specifier.auth_header = get.str.str_by_with_suffix(specifier.auth_header, ": ")

  -- add auth to curl command

  if specifier.api_name then
    specifier.auth_process = specifier.auth_process or tblmap.api_name.http_authentication_scheme[specifier.api_name]
  end

  if specifier.token_where == "header" or specifier.token_where == "header+param" then
    local auth_header = specifier.auth_header .. get.str.str_by_with_suffix(specifier.auth_process or "Bearer", " ")
    dothis.arr.push(curl_command, "-H")
    dothis.arr.push(curl_command, 
      transf.str.str_by_single_quoted_escaped(auth_header .. specifier.token))
  end

  if specifier.username_pw_where == "header" or specifier.username_pw_where == "header+param" then
    local auth_header = specifier.auth_header .. get.str.str_by_with_suffix(specifier.auth_process or "Basic", " ")
    dothis.arr.push(curl_command, "-H")
    dothis.arr.push(curl_command, 
      transf.str.str_by_single_quoted_escaped(auth_header .. transf.str.base64_url_str_by_string_as_binary(specifier.username .. ":" .. specifier.password)))
  end

  -- assembole other parts of curl commmand

  -- request_verb handling

  if specifier.request_verb then
    specifier.request_verb = specifier.request_verb:upper()
    dothis.arr.push(curl_command, "--request")
    dothis.arr.push(curl_command, 
      transf.str.str_by_single_quoted_escaped(specifier.request_verb)
    )
  end

  -- some APIs require a specific kind of body for empty POST requests, e.g. "null" or "{}", which we handle here
  if 
    specifier.request_verb == "POST"
    and not specifier.request_table
    and tblmap.api_name.str_by_empty_post_body[specifier.api_name]
  then
    dothis.arr.push(curl_command, "-d")
    dothis.arr.push(curl_command, 
      transf.str.str_by_single_quoted_escaped(tblmap.api_name.str_by_empty_post_body[specifier.api_name])
    )
    dothis.arr.push(curl_command, "-H")
    dothis.arr.push(curl_command, 
    transf.str.str_by_single_quoted_escaped("Content-Type: " .. tblmap.api_name.empty_post_body_content_type[specifier.api_name])
  )
  end

  if specifier.request_table then
    specifier.request_verb = specifier.request_verb or "POST"
    local request_str, content_type

    specifier.request_table_type = specifier.request_table_type or "json"

    if specifier.request_table_type ~= "form" then
      if specifier.request_table_type == "json" then
        request_str = json.encode(specifier.request_table)
        content_type = "application/json"
      elseif specifier.request_table_type == "form-urlencoded" then
        request_str = transf.assoc.query_str(specifier.request_table)
        content_type = "application/x-www-form-urlencoded"
      end
      dothis.arr.push(curl_command, "-d")
      dothis.arr.push(curl_command, 
        transf.str.str_by_single_quoted_escaped(request_str)
      )
    else
      content_type = "multipart/form-data"
      local form_field_args = transf.assoc.curl_form_field_arr(specifier.request_table)
      curl_command = transf.two_arrs.arr_by_appended(
        curl_command,
        form_field_args
      )
    end
    
    dothis.arr.push(curl_command, "-H")
    dothis.arr.push(curl_command, 
      transf.str.str_by_single_quoted_escaped("Content-Type: " .. content_type)
    )
  
  end
  local cmd = get.str_or_number_arr.str_by_joined(curl_command, " ")
  if not specifier.non_json_response then
    if do_after then
      dothis.str.env_bash_eval_w_table_arg_fn_str_arg_fn_fail_error_key(
        cmd,
        do_after,
        catch_auth_error
      )
    else 
      local succ,res = pcall(transf.str.table_or_err_by_evaled_env_bash_parsed_json_err_error_key,cmd)
      if succ then
        return res
      else
        catch_auth_error(res)
      end
    end
  else 
    return dothis.str.env_bash_eval_w_str_or_nil_arg_fn_by_stripped(cmd, do_after)
  end
end