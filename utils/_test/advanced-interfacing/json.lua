-- ensure that the stuff gotten for various ways of assembling the url seems right

local default_query_res = rest() -- without args, it queries a default api endpoint (dummyjson.com)

assertMessage(
  #default_query_res, 
  10
)

local url_query_res = rest({
  url = "https://dummyjson.com/products?limit=10&skip=10"
})

assertMessage(
  #url_query_res,
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
  #assembled_query_res,
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
  endpoint = "products",
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
  endpoint = "products",
  params = {
    limit = 10,
    skip = 10
  },
  request_verb = "POST"
})

assertMessage(
  post_res,
  {
    id = 101
  }
)

-- local post with correct request verb, and title data

local post_res = rest({
  host = "https://dummyjson.com",
  endpoint = "products",
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
    id = 101,
    title = "test"
  }
)

-- get auth token for the next test

local auth_response = rest({
  host = "https://dummyjson.com",
  endpoint = "auth/login",
  request_table = {
    username = "foo",
    password = "bar"
  },
  request_verb = "POST"
})

local auth_token = auth_response.token

assertMessage(auth_token ~= nil, true)

-- get request with auth token

-- wrong token first

local problem_token_res = rest({
  host = "https://dummyjson.com",
  endpoint = "auth/products",
  params = {
    limit = 10,
    skip = 10
  },
  api_key = "wrong token"
})

assertMessage(
  problem_token_res,
  {
    message = "Authentication Problem"
  }
)

-- correct token

local correct_token_res = rest({
  host = "https://dummyjson.com",
  endpoint = "auth/products",
  params = {
    limit = 10,
    skip = 10
  },
  api_key = auth_token
})

assertMessage(
  correct_token_res,
  assembled_query_res
)

-- wrong header name

local wrong_header_res = rest({
  host = "https://dummyjson.com",
  endpoint = "auth/products",
  params = {
    limit = 10,
    skip = 10
  },
  api_key = auth_token,
  api_key_header_name = "Authorization: IAmABear"
})

assertMessage(
  wrong_header_res,
  {
    message = "Authentication Problem"
  }
)

-- correct header name, manually set, as well as callback

rest({
  host = "https://dummyjson.com",
  endpoint = "auth/products",
  params = {
    limit = 10,
    skip = 10
  },
  api_key = auth_token,
  api_key_header_name = "Authorization: Bearer",
}, function(res)
  assertMessage(
    res,
    assembled_query_res
  )
end)

