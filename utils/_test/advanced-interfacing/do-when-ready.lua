manual_tests.do_when_ready = function()
  local temp_file_1 = env.TMPDIR .. "/do-when-ready/" .. os.time() .. "-1.txt"
  local temp_file_2 = env.TMPDIR .. "/do-when-ready/" .. os.time() .. "-2.txt"
  local temp_file_3 = env.TMPDIR .. "/do-when-ready/" .. os.time() .. "-3.txt"
  
  local function writeHelloWorld(path)
    writeFile(path, "Hello World!", "any", true)
  end
  
  doWhenReady(writeHelloWorld, temp_file_1)
  doWhenReady(writeHelloWorld, temp_file_2)
  doWhenReady(writeHelloWorld, temp_file_3)
  
  -- check that files have not been written yet
  
  assertMessage(
    readFile(temp_file_1, "nil"),
    nil 
  )
  
  assertMessage(
    readFile(temp_file_2, "nil"),
    nil 
  )
  
  assertMessage(
    readFile(temp_file_3, "nil"),
    nil
  )
  
  hs.eventtap.keyStroke({"cmd", "alt", "shift"}, "/")
  
  
  hs.timer.doAfter(1, function ()
    assertMessage(
      readFile(temp_file_1, "error"),
      "Hello World!"
    )
  
    assertMessage(
      readFile(temp_file_3, "nil"),
      nil
    )
  
    hs.eventtap.keyStroke({"cmd", "alt", "shift"}, "/")
    hs.eventtap.keyStroke({"cmd", "alt", "shift"}, "/")
    hs.timer.doAfter(1, function ()
      
      assertMessage(
        readFile(temp_file_2, "error"),
        "Hello World!"
      )
  
      assertMessage(
        readFile(temp_file_3, "error"),
        "Hello World!"
      )
  
    end)
  end)
end