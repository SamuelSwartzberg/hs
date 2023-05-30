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
      assertMessage(isClose(#response, 8, 7), true) -- 1 token ≈ 4 chars -> test if within 7 chars of that value
    end
  )

  assertMessage(
    transf.string.romanized_gpt("Lipsum dolor sit amet. 草"),
    "Lipsum dolor sit amet. kusa"
  )

  assertMessage(
    transf.string.romanized_gpt("こっちの話です！そう。マッサージはづるづるです。真ん中に行きます。自分を見つけます。これはこれでいいよね。"),
    "kocchi no hanashi desu! sou. massaaji wa duruduru desu. mannaka ni ikimasu. jibun wo mitsukemasu. kore wa kore de ii yo ne."
  )
else
  print("skipping...")
end