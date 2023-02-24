
--- @param _ hs_geometry_point_like
--- @param deltas hs_geometry_point_like
function scrollBy(_, deltas)
  hs.eventtap.scrollWheel({toInt(deltas.x), toInt(deltas.y)}, {}, "pixel") 
end

--- @return { x: number, y: number }
function getOrigin() return { x = 0, y = 0 } end

POLLING_INTERVAL = 0.01 -- seconds, seems like good compromise between what applications might expect and performance

--- @param distance number
--- @param factor_of_deceleration number
--- @param steps number
--- @return number
function getStartingDelta(distance, factor_of_deceleration, steps)
  if factor_of_deceleration >= 1 then -- invalid deceleration factor, would never reach target ≙ we're just going to move linearly
    return distance / steps 
  else 
    return distance * (1 - factor_of_deceleration) / (1 - factor_of_deceleration ^ steps)
  end
end

--- @param delta number
--- @param jitter_factor? number
--- @return number
function getJitter(delta, jitter_factor)
  local jitter_factor = jitter_factor or 0.1
  local jitter_delta = delta * jitter_factor
  return randBetween(-jitter_delta, jitter_delta)
end

--- naive implementations of moving a thing such that applications that expect human-like movement will not notice / get confused
--- not sure if this is necessary, but it's a good idea to be careful
--- @param specifier { target_point: hs_geometry_point_like, duration?: number, get_starting_point: fun(): (hs_geometry_point_like), factor_of_deceleration?: number, set_pos_func: fun(point: hs_geometry_point_like, deltas?: hs_geometry_point_like): (nil), jitter_factor?: number }
--- @param do_after? fun(): nil
--- @return nil
function doDelta(specifier, do_after)
  specifier.factor_of_deceleration = specifier.factor_of_deceleration or 0.95
  specifier.duration = specifier.duration or randBetween(0.1, 0.3)
  local current_point = specifier.get_starting_point()
  local total_delta = pointdelta(specifier.target_point, current_point)
  local num_steps = math.ceil(specifier.duration / POLLING_INTERVAL)
  local deltas = {
    x = getStartingDelta(total_delta.x, specifier.factor_of_deceleration, num_steps),
    y = getStartingDelta(total_delta.y, specifier.factor_of_deceleration, num_steps)
  }
  local past_ideal_points = {
    x = current_point.x,
    y = current_point.y
  }

  local steps_left = num_steps
  local timer = hs.timer.doWhile(function() 
      local continue = (
        math.abs(deltas.x) > 0.1 or
        math.abs(deltas.y) > 0.1 
      ) and steps_left > 0
      if not continue then 
        if do_after then 
          local after_timer = hs.timer.doAfter(
            POLLING_INTERVAL * 5, -- wait a bit for everything to settle
            do_after
          )
          after_timer:start()
        end
      end
      return continue
    end, function()
    steps_left = steps_left - 1
    if steps_left > 0 then
      past_ideal_points.x = past_ideal_points.x + deltas.x
      past_ideal_points.y = past_ideal_points.y + deltas.y
      current_point.x = past_ideal_points.x + getJitter(deltas.x, specifier.jitter_factor)
      current_point.y = past_ideal_points.y + getJitter(deltas.y, specifier.jitter_factor)
      specifier.set_pos_func(current_point, deltas)
      deltas.x = deltas.x * specifier.factor_of_deceleration
      deltas.y = deltas.y * specifier.factor_of_deceleration
    else
      specifier.set_pos_func(specifier.target_point, deltas)
    end
  end, POLLING_INTERVAL)
  timer:start()
end

--- @param target_point hs_geometry_point_like
--- @param duration? number
--- @param factor_of_deceleration? number
--- @param do_after? fun(): nil
--- @return nil
function moveMouse(target_point, duration, factor_of_deceleration, do_after)
  doDelta({
    target_point = target_point,
    duration = duration,
    get_starting_point = hs.mouse.absolutePosition,
    factor_of_deceleration = factor_of_deceleration,
    set_pos_func = function (point) -- needs wrapper to ignore deltas (second argument)
      hs.mouse.absolutePosition(point)
    end
  }, do_after)
end

--- @param target_point hs_geometry_point_like
--- @param duration? number
--- @param factor_of_deceleration? number
--- @param do_after? fun(): nil
--- @return nil
function scrollSmooth(target_point, duration, factor_of_deceleration, do_after)
  doDelta({
    target_point = target_point,
    duration = duration,
    get_starting_point = getOrigin, -- starting point for scrolling is always 0,0, since we're scrolling relative to current position
    factor_of_deceleration = factor_of_deceleration,
    set_pos_func = scrollBy,
    jitter_factor = 0.1
  }, do_after)
end

--- @param target_point hs_geometry_point_like
--- @param do_after? fun(): nil
--- @return nil
function leftclick(target_point, do_after)
  hs.eventtap.leftClick(target_point)
  if do_after then 
    local after_timer = hs.timer.doAfter(
      POLLING_INTERVAL * 2, -- wait a bit for everything to settle
      do_after
    )
    after_timer:start()
  end
end

--- @param target_point hs_geometry_point_like
--- @param duration? number
--- @param factor_of_deceleration? number
--- @param do_after? fun(): nil
--- @return nil
function moveAndClick(target_point, duration, factor_of_deceleration, do_after)
  moveMouse(target_point, duration, factor_of_deceleration, function ()
    leftclick(target_point, do_after)
  end)
end

--- @param target_point hs_geometry_point_like
--- @param duration number
--- @return nil
function moveMouseLinear(target_point, duration)
  moveMouse(target_point, duration, 1)
end

--- @param target_point hs_geometry_point_like
--- @param duration number
--- @return nil
function scrollSmoothLinear(target_point, duration)
  scrollSmooth(target_point, duration, 1)
end

--- @alias mouse_series_specifier { mode: "move"|"scroll"|"moveandclick"|"click"|"rightclick", target_point: hs_geometry_point_like, duration?: number, factor_of_deceleration?: number }

--- @param specifier { wait_time?: number, specifier_list: mouse_series_specifier[] }
function doMouseSeries(specifier)
  if #specifier.specifier_list == 0 then
    return
  else 
    hs.timer.doAfter(
      specifier.wait_time or randBetween(0.07, 0.15), 
      function()
        local subspecifier = listShift(specifier.specifier_list)
        function do_after()
          doMouseSeries(specifier)
        end
        if subspecifier.mode == "scroll" then
          scrollSmooth(subspecifier.target_point, subspecifier.duration, subspecifier.factor_of_deceleration, do_after)
        elseif subspecifier.mode == "move" then
          moveMouse(subspecifier.target_point, subspecifier.duration, subspecifier.factor_of_deceleration, do_after)
        elseif subspecifier.mode == "moveandclick" then
          moveAndClick(subspecifier.target_point, subspecifier.duration, subspecifier.factor_of_deceleration, do_after)
        elseif subspecifier.mode == "click" then
          leftclick(subspecifier.target_point, do_after)
        else 
          error("unknown mode: " .. subspecifier.mode)
        end
      end
    )
  end
end