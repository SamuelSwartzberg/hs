
--- @alias kbd_specifier { text: string, modifiers?: string[] }

--- @param specifier { wait_time?: number, specifier_list: kbd_specifier[] }
function doKeyboardSeries(specifier)
  if #specifier.specifier_list == 0 then
    return
  else 
    hs.timer.doAfter(
      specifier.wait_time or rand({low = 0.10, high = 0.12}), 
      function()
        local subspecifier = listShift(specifier.specifier_list)
        function do_after()
          doKeyboardSeries(specifier)
        end
        if subspecifier.modifiers then 
          hs.eventtap.keyStroke(subspecifier.modifiers, subspecifier.text)
          do_after()
        else 
          hs.eventtap.keyStrokes(subspecifier.text)
          do_after()
        end
      end
    )
  end
end