if mode == "full-test" then

  --- @param eventType string ("mouse" or "key")
  --- @param type string
  --- @param doAfter fun()
  local function checkEvent(eventType, type, doAfter)
    local eventTap

    --- @param e hs.eventtap.event.event
    local function handleEvent(e)
      if eventType == "mouse" then
        local button = e:getProperty(hs.eventtap.event.properties['mouseEventButtonNumber'])
        local correctButton = 0

        if type == "right" then
          correctButton = 1
        elseif type == "middle" then
          correctButton = 2
        end

        if button == correctButton then
          eventTap:stop()
          doAfter()
          return true
        else
          return false
        end
      elseif eventType == "key" then
        local keyCode = e:getKeyCode()
        local correctKeyCode = hs.keycodes.map[type]

        if keyCode == correctKeyCode then
          eventTap:stop()
          doAfter()
          return true
        else
          return false
        end
      end
    end

    if eventType == "mouse" then
      eventTap = hs.eventtap.new({hs.eventtap.event.types[type.."MouseDown"]}, handleEvent)
    elseif eventType == "key" then
      eventTap = hs.eventtap.new({hs.eventtap.event.types.keyDown}, handleEvent)
    end

    eventTap:start()
  end


  doInput(
    {
      mode="move",
      target_point={x=500, y=500},
    },
    function ()
      assert(
        hs.geometry.new(hs.mouse.absolutePosition()) ==
        hs.geometry.new({x = 500, y = 500})
      )
      hs.mouse.absolutePosition({x = 0, y = 0})
      checkEvent("mouse", "left", function() 
        checkEvent("mouse", "right", function() 
          checkEvent("key", "l", function()
            assertMessage(
              transf.input_spec_string.input_spec("."),
              { mode = "click", button = "l" }
            )
            assertMessage(
              transf.input_spec_string.input_spec(".r"),
              { mode = "click", button = "r" }
            )
            assertMessage(
              transf.input_spec_string.input_spec(".m"),
              { mode = "click", button = "m" }
            )
            assertMessage(
              transf.input_spec_string.input_spec(":a"),
              { mode = "key", keys = {"a"}}
            )
            assertMessage(
              transf.input_spec_string.input_spec(":cmd+a"),
              { mode = "key", keys = {"cmd", "a"}}
            )
            assertMessage(
              transf.input_spec_string.input_spec(":cmd+shift+a"),
              { mode = "key", keys = {"cmd", "shift", "a"}}
            )
            assertMessage(
              transf.input_spec_string.input_spec("m500 500"),
              { mode = "move", target_point = {x = 500, y = 500} }
            )
            assertMessage(
              transf.input_spec_string.input_spec("s500 500"),
              { mode = "scroll", target_point = {x = 500, y = 500} }
            )
            assertMessage(
              transf.input_spec_string.input_spec("m500 500 %tl"),
              { mode = "move", target_point = {x = 500, y = 500}, relative_to = "tl" }
            )
            print("Finished testing doInput")
          end)
          doInput({
            mode="key",
            keys={"l"}
          })
        end)
        doInput({
          mode="click",
          button="r"
        })
      end)
      doInput({
        mode="click",
        button="l"
      })
      

    end
  )
else
  print("skipping...")
end