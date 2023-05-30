if mode == "full-test" then -- making a bunch of json requests non-async takes time



-- ensure that the stuff gotten for various ways of assembling the url seems right

local url_query_res = rest({
  url = "https://dummyjson.com/products?limit=10&skip=10"
})

assertMessage(
  #url_query_res.products,
  10
)

local assembled_query_res = rest({
  host = "dummyjson.com",
  endpoint = "products",
  params = {
    limit = 10,
    skip = 10
  }
})

assertMessage(
  #assembled_query_res.products,
  10
)

-- ensure that the results are the same

assertMessage(
  url_query_res,
  assembled_query_res
)

-- local post with wrong request verb

local post_res = rest({
  host = "dummyjson.com",
  endpoint = "products/add",
  params = {
    limit = 10,
    skip = 10
  },
  request_verb = "GET"
})

assertMessage(
  post_res,
  {
    message = 	"Product with id 'add' not found"
  }
)

-- local post with correct request verb, but no data

local post_res = rest({
  host = "dummyjson.com",
  endpoint = "products/add",
  params = {
    limit = 10,
    skip = 10
  },
  request_verb = "POST"
})

assertMessage(
  post_res,
  {
    id = 101.0
  }
)

-- local post with correct request verb, and title data

local post_res = rest({
  host = "dummyjson.com",
  endpoint = "products/add",
  params = {
    limit = 10,
    skip = 10
  },
  request_table = {
    title = "test"
  }
})

assertMessage(
  post_res,
  {
    id = 101.0,
    title = "test"
  }
)

-- request_table_type "form-urlencoded"

local rest_res = rest({
  host = "httpbin.org",
  endpoint = "post",
  request_table = {
    foo = "bar"
  },
  request_table_type = "form-urlencoded"
})

assertMessage(
  rest_res.form,
  {
    foo = "bar"
  }
)

local rest_res = rest({
  host = "httpbin.org",
  endpoint = "post",
  request_table = {
    foo = "bar",
    lol = "what is a space",
    kore = "は日本語の例。"
  },
  request_table_type = "form-urlencoded"
})

assertMessage(
  rest_res.form,
  {
    foo = "bar",
    lol = "what is a space",
    kore = "は日本語の例。"
  }
)

-- request_table_type "form"

local rest_res = rest({
  host = "httpbin.org",
  endpoint = "post",
  request_table = {
    foo = "bar"
  },
  request_table_type = "form"
})

assertMessage(
  rest_res.form,
  {
    foo = "bar"
  }
)

local rest_res = rest({
  host = "httpbin.org",
  endpoint = "post",
  request_table = {
    foo = "bar",
    lol = "what is a space",
    kore = "は日本語の例。"
  },
  request_table_type = "form"
})

assertMessage(
  rest_res.form,
  {
    foo = "bar",
    lol = "what is a space",
    kore = "は日本語の例。"
  }
)

-- with files (uses curl notation for files)

local timestamp = os.time()
local filepath = env.TMPDIR .. "/rest-form-file-" .. timestamp .. ".txt"

writeFile(filepath, "test")

local rest_res = rest({
  host = "httpbin.org",
  endpoint = "post",
  request_table = {
    foo = "bar",
    lol = "what is a space",
    kore = "は日本語の例。",
    afile = "@" .. filepath
  },
  request_table_type = "form"
})

assertMessage(
  rest_res.form,
  {
    foo = "bar",
    lol = "what is a space",
    kore = "は日本語の例。"
  }
)

assertMessage(
  rest_res.files,
  {
    afile = "test"
  }
)

-- non_json_response

local uuid_response = rest({
  host = "httpbin.org",
  endpoint = "uuid",
  non_json_response = true
})

-- since the response is actually json, but we've told rest to not parse it, we have to parse it ourselves

local actual_uuid = json.decode(uuid_response).uuid

assert(
  onig.match(actual_uuid, whole(mt._r.id.uuid))
)

-- get auth token

local auth_response = rest({
  host = "dummyjson.com",
  endpoint = "auth/login",
  request_table = { -- data of some user from https://dummyjson.com/docs/users
    username = "atuny0",
    password = "9uQFF1Lh"
  },
  request_verb = "POST"
})

local auth_token = auth_response.token

assertMessage(auth_token ~= nil, true)


-- authentication

-- auth_process: basic

-- auto username/pw

local basic_auth_response = rest({
  host = "httpbin.org",
  endpoint = "basic-auth/me%40samswartzberg.com/testpw",
  username_pw_where = "header",
  api_name = "httpbin"
})

assert(basic_auth_response.authenticated, true)

-- manual username/pw

local basic_auth_response = rest({
  host = "httpbin.org",
  endpoint = "basic-auth/me%40samswartzberg.com/testpw",
  username_pw_where = "header",
  api_name = "httpbin",
  username = env.MAIN_EMAIL,
  password = "testpw"
})

assert(basic_auth_response.authenticated, true)

-- only username

local basic_auth_response = rest({
  host = "httpbin.org",
  endpoint = "basic-auth/me%40samswartzberg.com/testpw",
  username_pw_where = "header",
  api_name = "httpbin",
  username = env.MAIN_EMAIL,
})

assert(basic_auth_response.authenticated, true)

-- only password

local basic_auth_response = rest({
  host = "httpbin.org",
  endpoint = "basic-auth/me%40samswartzberg.com/testpw",
  username_pw_where = "header",
  api_name = "httpbin",
  password = "testpw"
})

assert(basic_auth_response.authenticated, true)

-- username password in url (not recommended, but we support it)

local username_password_in_url_response = rest({
  host = "httpbin.org",
  endpoint  = "get",
  username_pw_where = "param",
  api_name = "httpbin"
})

assertMessage(
  username_password_in_url_response.args,
  {
    username = env.MAIN_EMAIL,
    password = "testpw"
  }
)

-- custom username/pw param

local username_password_in_url_response = rest({
  host = "httpbin.org",
  endpoint  = "get",
  username_pw_where = "param",
  api_name = "httpbin",
  username_param = "user",
  password_param = "pass"
})

assertMessage(
  username_password_in_url_response.args,
  {
    user = env.MAIN_EMAIL,
    pass = "testpw"
  }
)

local manual_basic_auth_response = rest({
  host = "httpbin.org",
  endpoint = "headers",
  token_where = "header",
  api_name = "httpbin",
  token = "foobar"
})

assertMessage(
  manual_basic_auth_response.headers.Authorization,
  "Bearer foobar"
)

local manual_basic_auth_response = rest({
  host = "httpbin.org",
  endpoint = "headers",
  token_where = "header",
  auth_process = "",
  api_name = "httpbin",
  token = "foobar"
})

assertMessage(
  manual_basic_auth_response.headers.Authorization,
  "foobar"
)

-- different auth_header

local diff_auth_header_response = rest({
  host = "httpbin.org",
  endpoint = "headers",
  username_pw_where = "header",
  api_name = "httpbin",
  auth_header = "X-Test-Token-Header"
})

assertMessage(
  diff_auth_header_response.headers["X-Test-Token-Header"],
  "Basic " .. transf.string.base64_url("me@samswartzberg.com:testpw")
)

-- different auth_header w/ bearer

writeFile(env.MAPI .. "/httpbin/key", "123456")

local diff_auth_header_response = rest({
  host = "httpbin.org",
  endpoint = "headers",
  token_where = "header",
  api_name = "httpbin",
  auth_header = "X-Test-Token-Header"
})

assertMessage(
  diff_auth_header_response.headers["X-Test-Token-Header"],
  "Bearer 123456"
)

-- get request with auth token

-- missing token (no api_name for auto retrieval)

local succ, res = pcall(rest,{
  host = "danbooru.donmai.us",
  endpoint = "profile.json",
  token_where = "param",
  params = {
    login = "reirui"
  }
})

assert(not succ)
assertMessage(
  res,
  "Cannot fetch token without api_name"
)

-- wrong token manually

local problem_token_res = rest({
  host = "danbooru.donmai.us",
  endpoint = "profile.json",
  params = {
    login = "reirui"
  },
  token_where = "param",
  token = "wrong",
  run_json_opts = {
    accept_error_payload = true
  }
})

assertMessage(
  problem_token_res.error,
  "SessionLoader::AuthenticationFailure"
)

-- correct token manually

local correct_token_res = rest({
  host = "danbooru.donmai.us",
  endpoint = "profile.json",
  params = {
    login = "reirui"
  },
  token_where = "param",
  token = readFile(env.MAPI .. "/danbooru/key")
})

assertMessage(
  correct_token_res.name,
  "reirui"
)

-- correct token automatically

correct_token_res = rest({
  host = "danbooru.donmai.us",
  endpoint = "profile.json",
  params = {
    login = "reirui"
  },
  token_where = "param",
  api_name = "danbooru",
})

-- prefer manual token over auto

correct_token_res = rest({
  host = "danbooru.donmai.us",
  endpoint = "profile.json",
  params = {
    login = "reirui"
  },
  api_name = "wronglol",
  token_where = "param",
  token = readFile(env.MAPI .. "/danbooru/key"),
})

assertMessage( 
  correct_token_res.name,
  "reirui"
)

-- correct token automatically with automatic retrieval of host, token_where

correct_token_res = rest({
  endpoint = "profile.json",
  params = {
    login = "reirui"
  },
  api_name = "danbooru",
})

assertMessage(
  correct_token_res.name,
  "reirui"
)

--- correct token automatically, specify token type manually

correct_token_res = rest({
  host = "danbooru.donmai.us",
  endpoint = "profile.json",
  params = {
    login = "reirui"
  },
  token_where = "param",
  token_type = "simple",
  api_name = "danbooru",
})

assertMessage(
  correct_token_res.name,
  "reirui"
)

-- token in both header and param

local token_res = rest({
  host = "httpbin.org",
  endpoint = "get",
  token_where = "both",
  api_name = "httpbin"
})

assertMessage(
  token_res.headers.Authorization,
  "Bearer " .. readFile(env.MAPI .. "/httpbin/key")
)

assertMessage(
  token_res.args.api_key,
  readFile(env.MAPI .. "/httpbin/key")
)

-- token in both header and param, auto retrieval of host

local token_res = rest({
  endpoint = "get",
  token_where = "both",
  api_name = "httpbin"
})

assertMessage(
  token_res.headers.Authorization,
  "Bearer " .. readFile(env.MAPI .. "/httpbin/key")
)

assertMessage(
  token_res.args.api_key,
  readFile(env.MAPI .. "/httpbin/key")
)


-- token in both header and param with different token_param

local token_res = rest({
  host = "httpbin.org",
  endpoint = "get",
  token_where = "both",
  api_name = "httpbin",
  token_param = "apikey"
})

assertMessage(
  token_res.headers.Authorization,
  "Bearer " .. readFile(env.MAPI .. "/httpbin/key")
)

assertMessage(
  token_res.args.apikey,
  readFile(env.MAPI .. "/httpbin/key")
)

-- username and password in both header and param

local user_pass_res = rest({
  host = "httpbin.org",
  endpoint = "get",
  username_pw_where = "both",
  api_name = "httpbin"
})

assertMessage(
  user_pass_res.headers.Authorization,
  "Basic " .. transf.string.base64_url(env.MAIN_EMAIL .. ":" .. "testpw")
)

assertMessage(
  user_pass_res.args.username,
  env.MAIN_EMAIL
)

assertMessage(
  user_pass_res.args.password,
  "testpw"
)

-- test various apis

hs.application.open("Hydrus Network")

local hydrus_response = rest({
  api_name = "hydrus",
  endpoint = "api_version",
})

assert(
  type(hydrus_response.version) == "number"
)

-- oauth requests

-- prepare

local dropbox_request = {
  api_name = "dropbox",
  endpoint = "users/get_current_account",
  request_verb = "POST",
  token_type = "oauth2",
  token_where = "header",
  oauth2_url = "https://api.dropboxapi.com/oauth2/token",
  oauth2_authorization_url = "https://www.dropbox.com/oauth2/authorize"
}

local oauth2callbacktask = run({
  args = "oauth2callback",
  catch = true
}, true)
hs.timer.doAfter(1, function()

  -- test that the local server run by the oauth2callback script is running

  delete(env.MAPI .. "/oauth2callbacktest/authorization_code")

  run("curl \"http://127.0.0.1:8412/?api_name=oauth2callbacktest&code=1234\"")

  assertMessage(
    readFile(env.MAPI .. "/oauth2callbacktest/authorization_code"),
    "1234"
  )

  -- initial: neither refresh nor access token exists

  delete(env.MAPI .. "/dropbox/access_token")
  delete(env.MAPI .. "/dropbox/refresh_token")
  delete(env.MAPI .. "/dropbox/authorization_code")

  local time_pre_auth = os.time()

  rest(dropbox_request, function(response)

    local now = os.time()

    assert(
      now - time_pre_auth > 2, "there's no way we manually authorized in 2 seconds or less, so we failed to wait for the authorization, or something else went wrong!"
    )
    
    assertMessage(
      response.email,
      "korehabetsumei@mailbox.org"
    )

    -- access token exists

    assert(#readFile(env.MAPI .. "/dropbox/access_token") > 0)

    rest(dropbox_request, function (response)
  
      assertMessage(
        response.email,
        "korehabetsumei@mailbox.org"
      )

      -- automatically retrieve token_where, token_type, oauth2_url and oauth2_authorization_url

      dropbox_request = {
        api_name = "dropbox",
        endpoint = "users/get_current_account",
        request_verb = "POST",
      }

      rest(dropbox_request, function (response)
  
        assertMessage(
          response.email,
          "korehabetsumei@mailbox.org"
        )

        local youtube_request = {
          api_name = "youtube",
          endpoint = "channels",
          params = { forUsername = "GoogleDevelopers" }
        }

        rest(youtube_request, function(response)

          assertMessage(
            response.items[1].id,
            "UC_x5XG1OV2P6uZZ5FSM9Ttw"
          )

          
        end)
      end)

    end)

  end)
end)

else
  print("skipping...")
end