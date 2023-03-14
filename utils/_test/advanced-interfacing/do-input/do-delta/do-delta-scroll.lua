function runScrollTests()

end


-- ensure that the movement tests are done before the scroll tests

local do_delta_move_is_finished = false
local past_3_mouse_positions = {}

hs.timer.doWhile(
  function ()
    return not do_delta_move_is_finished
  end, 
  function ()
    do_delta_move_is_finished = find(
      past_3_mouse_positions,
      function(pos)
        return pos == hs.mouse.absolutePosition()
      end,
      "boolean"
    )
    if do_delta_move_is_finished then
      runScrollTests()
    else
      push(past_3_mouse_positions, hs.mouse.absolutePosition())
      if #past_3_mouse_positions > 3 then
        table.remove(past_3_mouse_positions, 1)
      end
    end
  end, 
  0.3
)


