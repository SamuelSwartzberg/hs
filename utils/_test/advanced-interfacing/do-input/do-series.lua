if mode == "full-test" then

  doSeries({
    specifier_list = {
      "m300 300",
      "m100 400",
      "m200 200",
    }
  }, function ()
    assert(
      hs.geometry.new(hs.mouse.absolutePosition()) ==
      hs.geometry.new({x = 200, y = 200})
    )
    doSeries({
      "m100 200",
      "m100 100 %curpos",
      "m200 200 %curpos", 
    }, function ()
      assert(
        hs.geometry.new(hs.mouse.absolutePosition()) ==
        hs.geometry.new({x = 400, y = 500})
      )
      doSeries("m0 0,:escape,.,m200 200,m100 0 %curpos", function()
        assert(
          hs.geometry.new(hs.mouse.absolutePosition()) ==
          hs.geometry.new({x = 300, y = 200})
        )
        print("do-series test passed")
      end)
    end)
  end)
else
  print("skipping...")
end