if mode == "full-test" then -- testing costs api requests and therefore money!

  gpt(
    "Hey. I am testing if my api access is working. Please respond with 'Hello World!', if you would!",
    function (response)
      assertMessage(response, "Hello World!")
    end
  )

  gpt(
    "Hey. This is an unit test of the max_tokens option of my gpt access function. Please provide any output with no whitespace, but I will trim it to only two tokens.",
    {
      max_tokens = 2
    },
    function (response)
      assertMessage(isClose(#response, 8, 5), true) -- 1 token ≈ 4 chars -> test if within 3 chars of that value
    end
  )
else
  print("skipping...")
end