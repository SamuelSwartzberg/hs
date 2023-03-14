local timestamp = os.time()

local manual_socket = BuildIPCSocket("test-" .. timestamp)

assertMessage(
  manual_socket:getSocket(),
  "/tmp/sockets/test-" .. timestamp
)

run(
  "socat UNIX-LISTEN:/tmp/sockets/test-" .. timestamp .. " -",
  function (stdout)
    assertMessage(
      stdout,
      "Hello World!"
    )
  end
)

assertMessage(
  manual_socket:getResponse("Hello World!"),
  nil
)

local auto_socket = BuildIPCSocket()

run(
  "socat UNIX-LISTEN:" .. auto_socket:getSocket() .. ",fork SYSTEM 'socat - UNIX-CONNECT:" .. auto_socket:getSocket() .. "'",
  true
)

assertMessage(
  auto_socket:getResponse("Hello World!"),
  "Hello World!"
)

