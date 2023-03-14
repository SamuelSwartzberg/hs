if mode=="full-test" then
  assertMessage(
    getStartingDelta(500, 1, 5),
    100
  )

  local original_mouse_position = hs.mouse.absolutePosition()
  hs.mouse.absolutePosition({x = 0, y = 0})

  doDelta({target_point = {x = 500, y = 500}}, function()
    assertMessage(
      hs.mouse.absolutePosition(),
      {x = 500, y = 500}
    )
    hs.mouse.absolutePosition({x = 0, y = 0})

    doDelta({target_point = "500x500"}, function()
      assertMessage(
        hs.mouse.absolutePosition(),
        {x = 500, y = 500}
      )
      hs.mouse.absolutePosition({x = 0, y = 0})

      doDelta({target_point = "500..this should work even with arbitrary text between the numbers#@#$@500"}, function()
        assertMessage(
          hs.mouse.absolutePosition(),
          {x = 500, y = 500}
        )
        hs.mouse.absolutePosition({x = 0, y = 0})


        hs.application.launchOrFocus("TextEdit")

        local textedit_window_item = CreateRunningApplicationItem(hs.application.find("TextEdit")):get("main-window-item")

        textedit_window_item:doThis("set-position", {x = 300, y = 300})

        assertMessage(
          textedit_window_item:get("point-tl"),
          {x = 300, y = 300}
        )

        doDelta({target_point = "500x500", relative_to = "tl"}, function()
          assertMessage(
            hs.mouse.absolutePosition(),
            {x = 800, y = 800}
          )
          hs.mouse.absolutePosition({x = 0, y = 0})

          textedit_window_item:doThis("set-size", {w = 500, h = 500})

          assertMessage(
            textedit_window_item:get("size"),
            {w = 500, h = 500}
          )

          doDelta({target_point = { x = 200, y = 200 }, relative_to = "c" }, function()
            assertMessage(
              hs.mouse.absolutePosition(),
              {x = 300 + 250 + 200, y = 300 + 250 + 200}
            )
            hs.mouse.absolutePosition({x = 0, y = 0})

            doDelta({target_point = { x = -200, y = -200 }, relative_to = "br"}, function()
              assertMessage(
                hs.mouse.absolutePosition(),
                {x = 300 + 500 - 200, y = 300 + 500 - 200}
              )
              hs.mouse.absolutePosition({x = 0, y = 0})

              hs.mouse.absolutePosition(original_mouse_position)

            end)

          end)

        end)

      end)

    end)

  end)
end