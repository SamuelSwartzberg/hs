function doGui(action, func)
  local act
  if type(action) == "string" then
    if stringy.endswith(action, "\n") then
      act = function() 
        hs.eventtap.keyStrokes(action)
        hs.eventtap.keyStroke({}, "return")
      end
    else
      act = function() 
        hs.eventtap.keyStrokes(action)
      end
    end
  elseif type(action) == "nil" then
    act = function() end
  else
    act = action
  end
  hs.timer.doAfter(0.001, act)
  return func()
end