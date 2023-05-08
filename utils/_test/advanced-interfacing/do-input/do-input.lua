-- no parse
--- @param type string
--- @param doAfter fun()
local function checkClick(type, doAfter)
  local mouseClickEventTap -- Declare outside the function scope

  --- @param e hs.eventtap.event.event
  local function handleClick(e)
    local button = e:getProperty(hs.eventtap.event.properties['mouseEventButtonNumber'])
    local correctButton = 0

    if type == "right" then
      correctButton = 1
    elseif type == "middle" then
      correctButton = 2
    end

    if button == correctButton then
      doAfter()
      mouseClickEventTap:stop() -- Stop the event handler after a single run
      return true     -- Stop the event from propagating
    else
      return false     -- Pass the event through, allowing other applications to process the event as well
    end
  end

  mouseClickEventTap = hs.eventtap.new({hs.eventtap.event.types[type.."MouseDown"]}, handleClick)
  mouseClickEventTap:start() -- Start the eventtap
end


doInput(
  {
    mode="move",
    x=500,
    y=500
  },
  function ()
    assert(
      hs.geometry.new(hs.mouse.absolutePosition()) ==
      hs.geometry.new({x = 500, y = 500})
    )
    hs.mouse.absolutePosition({x = 0, y = 0})
    checkClick("left", function() 
      checkClick("right", function() 
        
        print()
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