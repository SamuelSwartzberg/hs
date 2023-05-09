if mode == "full-test" then
  assertMessage(
    getStartingDelta(500, 1, 5),
    100
  )

  local original_mouse_position = hs.mouse.absolutePosition()
  hs.mouse.absolutePosition({x = 0, y = 0})

  doDelta({target_point = {x = 500, y = 500}}, function()
    assert(
      hs.geometry.new(hs.mouse.absolutePosition()) == hs.geometry.new({x = 500, y = 500})
    )
    hs.mouse.absolutePosition({x = 0, y = 0})

    doDelta({target_point = "500x500"}, function()
      assert(
        hs.geometry.new(hs.mouse.absolutePosition()) ==
        hs.geometry.new({x = 500, y = 500})
      )
      hs.mouse.absolutePosition({x = 0, y = 0})

      doDelta({target_point = "500..this should work even with arbitrary text between the numbers#@#$@500"}, function()
        assert(
          hs.geometry.new(hs.mouse.absolutePosition()) ==
          hs.geometry.new({x = 500, y = 500})
        )
        hs.mouse.absolutePosition({x = 0, y = 0})


        hs.application.launchOrFocus("TextEdit")

        -- TODO: test beyond here - can't be done until we've arrived at items again
        local textedit_window_item = CreateRunningApplicationItem(hs.application.find("TextEdit")):get("main-window-item")

        textedit_window_item:doThis("set-position", {x = 300, y = 300})

        assert(
          textedit_window_item:get("point-tl") ==
          hs.geometry.new({x = 300, y = 300})
        )

        doDelta({target_point = "500x500", relative_to = "tl"}, function()
          assert(
            hs.geometry.new(hs.mouse.absolutePosition()) ==
            hs.geometry.new({x = 800, y = 800})
          )
          hs.mouse.absolutePosition({x = 0, y = 0})

          textedit_window_item:doThis("set-size", {w = 500, h = 500})

          assertMessage(
            textedit_window_item:get("size"),
            {w = 500, h = 500}
          )

          doDelta({target_point = { x = 200, y = 200 }, relative_to = "c" }, function()
            assert(
              hs.geometry.new(hs.mouse.absolutePosition()) ==
              hs.geometry.new({x = 300 + 250 + 200, y = 300 + 250 + 200})
            )
            hs.mouse.absolutePosition({x = 0, y = 0})

            doDelta({target_point = { x = -200, y = -200 }, relative_to = "br"}, function()
              assert(
                hs.geometry.new(hs.mouse.absolutePosition()) ==
                hs.geometry.new({x = 300 + 500 - 200, y = 300 + 500 - 200})
              )
              hs.mouse.absolutePosition({x = 0, y = 0})

              hs.mouse.absolutePosition(original_mouse_position)

            end)

          end)

        end)

      end)

    end)

  end)
else
  print("skipping...")
end