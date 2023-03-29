local timestamp = os.time()

local manual_socket = BuildIPCSocket("test-" .. timestamp)

assertMessage(
  manual_socket:getSocket(),
  "/tmp/sockets/test-" .. timestamp
)

run(
  "socat UNIX-LISTEN:/tmp/sockets/test-" .. timestamp .. ",fork EXEC:'/bin/cat'",
  true
)

assertMessage(
  manual_socket:getResponse({data = "Hello World!"}),
  "Hello World!"
)

local auto_socket = BuildIPCSocket()

run(
  "socat UNIX-LISTEN:" .. auto_socket:getSocket() .. ",fork EXEC:'/bin/cat'",
  true
)

assertMessage(
  auto_socket:getResponse({data = "Hello World!"}),
  "Hello World!"
)

