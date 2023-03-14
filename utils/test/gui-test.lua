function doGui(action, func)
  if type(action) == "string" then
    if stringy.endswith(action, "\n") then
      action = function() 
        hs.eventtap.keyStrokes(action)
        hs.eventtap.keyStroke({}, "return")
      end
    else
      action = function() 
        hs.eventtap.keyStrokes(action)
      end
    end
  elseif type(action) == "nil" then
    action = function() end
  end
  hs.timer.doAfter(0.001, action)
  return func()
end