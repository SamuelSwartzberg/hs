POLLING_INTERVAL = 0.01 -- seconds, seems like good compromise between what applications might expect and performance
DELAY = POLLING_INTERVAL * 5

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

--- @class deltaOpts
--- @field mode "scroll" | "move" sets the type of movement to perform. configures some other options, and is overridden by them if they are set
--- @field target_point hs_geometry_point_like | string
--- @field factor_of_deceleration? number 0 will teleport, 1 will move linearly
--- @field duration? number
--- @field jitter_factor? number
--- @field relative_to? "tl"| "tr"| "bl"| "br"| "c"|"curpos"

--- naive implementations of moving a thing such that applications that expect human-like movement will not notice / get confused
--- not sure if this is necessary, but it's a good idea to be careful
--- @param specifier? deltaOpts
--- @param do_after? fun(): nil
--- @return nil
function doDelta(specifier, do_after)

  -- set general defaults

  specifier = specifier or {}
  specifier.mode = specifier.mode or "move"
  specifier.target_point = specifier.target_point or { x = 0, y = 0}
  specifier.factor_of_deceleration = specifier.factor_of_deceleration or 0.95
---@diagnostic disable-next-line: assign-type-mismatch
  specifier.duration = specifier.duration or rand({low=0.1, high=0.3})
  specifier.jitter_factor = specifier.jitter_factor or 0.1

  if type(specifier.target_point) == "string" then
    local x, y = onig.match(specifier.target_point, whole(mt._r.syntax.point))
    specifier.target_point = hs.geometry.point(toNumber(x, "number", "error"), toNumber(y, "number", "error"))
  elseif type(specifier.target_point) == "table" and not specifier.target_point.type then 
    specifier.target_point = hs.geometry.new(specifier.target_point)
  end

  if specifier.relative_to then
    if specifier.relative_to ~= "curpos" then
      local front_window = CreateRunningApplicationItem(hs.application.frontmostApplication()):get("main-window-item")
      specifier.target_point = front_window:get("point-with-offset-from", {
        from = specifier.relative_to,
        delta = specifier.target_point
      })
    else
      specifier.target_point =  specifier.target_point + hs.mouse.absolutePosition()
    end
  end

  -- set type-specific defaults

  local current_point
  if specifier.mode == "scroll" then
    current_point = { x = 0, y = 0}
    specifier.set_pos_func = function(_, deltas)
      hs.eventtap.scrollWheel({toNumber(deltas.x, "int"), toNumber(deltas.y, "int")}, {}, "pixel") 
    end
  elseif specifier.mode == "move" then
    current_point = hs.mouse.absolutePosition()
    specifier.set_pos_func = function (point) -- needs wrapper to ignore deltas (second argument)
      hs.mouse.absolutePosition(point)
    end
  else
    error("type must be 'scroll' or 'move'")
  end

  local total_delta = specifier.target_point - current_point
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
      specifier.set_pos_func(specifier.target_point, deltas) -- make sure we end up at the right place, and not a little off
      if do_after then 
        local after_timer = hs.timer.doAfter(
          DELAY, -- wait a bit for everything to settle
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
      current_point.x = past_ideal_points.x + deltas.x * specifier.jitter_factor
      current_point.y = past_ideal_points.y + deltas.y * specifier.jitter_factor
      specifier.set_pos_func(current_point, deltas)
      deltas.x = deltas.x * specifier.factor_of_deceleration
      deltas.y = deltas.y * specifier.factor_of_deceleration
    end
  end, POLLING_INTERVAL)
  timer:start()
end

--- @alias series_specifier_inner { mode: "move"|"scroll"|"click"|"key", [string]: any }
--- @alias series_specifier series_specifier_inner | string

--- @param series_specifier string
--- @return series_specifier_inner
function parseSeriesSpecifier(series_specifier)
  local parsed_series_specifier = {}
  if stringy.startswith(series_specifier, ".") then
    parsed_series_specifier.mode = "click"
    if #series_specifier == 1 then
      parsed_series_specifier.button = "l"
    else
      parsed_series_specifier.button = string.sub(series_specifier, 2, 2)
    end
  elseif stringy.startswith(series_specifier, ":") then
    parsed_series_specifier.mode = "key"
    parsed_series_specifier.keys = fixListWithNil(stringy.split(string.sub(series_specifier, 2), "+")) -- separating modifier keys with `+`
  else
    local mode_char, x, y, optional_relative_specifier = onig.match(series_specifier, "^(.)"..mt._r.syntax.point.."( %[a-zA-Z]+)?$")
    if not mode_char or not x or not y then
      error("Tried to parse string series_specifier, but it didn't match any known format:\n\n" .. series_specifier)
    end
    if mode_char == "m" then
      parsed_series_specifier.mode = "move"
    elseif mode_char == "s" then
      parsed_series_specifier.mode = "scroll"
    else
      error("doInput: invalid mode character `" .. mode_char .. "` in series specifier:\n\n" .. series_specifier)
    end
    parsed_series_specifier.target_point = {
      x = tonumber(x),
      y = tonumber(y)
    }
    if optional_relative_specifier and #optional_relative_specifier > 0 then
      parsed_series_specifier.relative_to = string.sub(optional_relative_specifier, 3)
    end
  end
  return parsed_series_specifier
end

--- @param series_specifier series_specifier
--- @param do_after? fun(): nil
--- @return nil
function doInput(series_specifier, do_after)
  local parsed_series_specifier = {}
  do_after = do_after  or returnNil -- dummy function b/c the timer functions require a function
  if type(series_specifier) == "string" then
    parsed_series_specifier = parseSeriesSpecifier(series_specifier)
  elseif type(series_specifier) == "table" then
    parsed_series_specifier = series_specifier
  else
    error("doInput: invalid type of series_specifier (neither string nor table). Got: " .. type(series_specifier))
  end

  if parsed_series_specifier.mode == "click" then 
    local clickmap = { l = "leftClick", r = "rightClick", m = "middleClick" }
    hs.eventtap[clickmap[parsed_series_specifier.button]](hs.mouse.absolutePosition())
    hs.timer.doAfter(0.2 + DELAY, do_after) -- default click delay + a bit of extra time
  elseif parsed_series_specifier.mode == "key" then
    local mods = replace(
      slice(parsed_series_specifier.keys, 1, -2),
      {
        matcher = "matcher_table_keys",
        processor = tblmap.modmap,
        must_match_entire_string = true
      }
    )
    local key = slice(parsed_series_specifier.keys, -1, -1)[1]
    if mods and #mods > 0 then
      hs.eventtap.keyStroke(mods, key)
    elseif #key == 1 then
      hs.eventtap.keyStroke({}, key)
    else
      hs.eventtap.keyStrokes(key)
    end
    hs.timer.doAfter(DELAY, do_after)
  elseif parsed_series_specifier.mode == "move" or parsed_series_specifier.mode == "scroll" then
    doDelta(parsed_series_specifier, do_after)
  else
    error("doInput: invalid mode `" .. parsed_series_specifier.mode .. "` in series specifier:\n\n" .. json.encode(series_specifier))
  end

end

--- @param specifier { wait_time?: number, specifier_list: series_specifier[] } | series_specifier[] | string
--- @param do_after? fun(): nil
function doSeries(specifier, do_after)
  if type(specifier) == "string" then
    specifier = {specifier_list = stringy.split(specifier, ",")}
  elseif isListOrEmptyTable(specifier) then
    specifier = {specifier_list = specifier}
  elseif type(specifier) == "table" then
    -- do nothing, it's already a series_specifier
  else
    error("doSeries: specifier must be a string, list, or table")
  end

  specifier.wait_time = specifier.wait_time or rand({low=0.10, high=0.12}) --[[ @as number ]]

  if #specifier.specifier_list == 0 then
    if do_after then
      do_after()
    end
    return
  end
  hs.timer.doAfter(
    specifier.wait_time, 
    function()
      local subspecifier = table.remove(specifier.specifier_list, 1)
      function do_after_inner()
        doSeries(specifier)
      end
      doInput(subspecifier, do_after_inner)
    end
  )
  
end