if mode == "full-test" then -- making a bunch of json requests non-async takes time

-- ensure that the stuff gotten for various ways of assembling the url seems right

local default_query_res = rest() -- without args, it queries a default api endpoint (dummyjson.com)

assertMessage(
  #default_query_res.products, 
  10
)

local url_query_res = rest({
  url = "https://dummyjson.com/products?limit=10&skip=10"
})

assertMessage(
  #url_query_res.products,
  10
)

local assembled_query_res = rest({
  host = "https://dummyjson.com",
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
  default_query_res,
  url_query_res
)

assertMessage(
  default_query_res,
  assembled_query_res
)

assertMessage(
  url_query_res,
  assembled_query_res
)

-- local post with wrong request verb

local post_res = rest({
  host = "https://dummyjson.com",
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
  host = "https://dummyjson.com",
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
  host = "https://dummyjson.com",
  endpoint = "products/add",
  params = {
    limit = 10,
    skip = 10
  },
  request_verb = "POST",
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

-- get auth token for the next test

local auth_response = rest({
  host = "https://dummyjson.com",
  endpoint = "auth/login",
  request_table = { -- data of some user from https://dummyjson.com/docs/users
    username = "atuny0",
    password = "9uQFF1Lh"
  },
  request_verb = "POST"
})

local auth_token = auth_response.token

assertMessage(auth_token ~= nil, true)

-- get request with auth token

-- missing token

local problem_token_res = rest({
  host = "https://danbooru.donmai.us",
  endpoint = "profile.json",
  params = {
    login = "reirui"
  }
})


assertMessage(
  problem_token_res.error,
  "SessionLoader::AuthenticationFailure"
) 

-- wrong token manually

problem_token_res = rest({
  host = "https://danbooru.donmai.us",
  endpoint = "profile.json",
  params = {
    login = "reirui"
  },
  api_key_param = "api_key",
  api_key = "wrong"
})

assertMessage(
  problem_token_res.error,
  "SessionLoader::AuthenticationFailure"
)

-- wrong token automatically

problem_token_res = rest({
  host = "https://danbooru.donmai.us",
  endpoint = "profile.json",
  params = {
    login = "reirui"
  },
  api_name = "wronglol",
})

assertMessage(
  problem_token_res.error,
  "SessionLoader::AuthenticationFailure"
)

-- correct token manually

local correct_token_res = rest({
  host = "https://danbooru.donmai.us",
  endpoint = "profile.json",
  params = {
    login = "reirui"
  },
  api_key_param = "api_key",
  api_key = readFile(env.MAPI .. "/danbooru/key") .. "wrong"
})

assertMessage(
  correct_token_res.name,
  "reirui"
)

-- correct token automatically

 correct_token_res = rest({
  host = "https://danbooru.donmai.us",
  endpoint = "profile.json",
  params = {
    login = "reirui"
  },
  api_key_param = "api_key",
  api_name = "danbooru",
})

assertMessage(
  correct_token_res.name,
  "reirui"
)
else
  print("skipping...")
end