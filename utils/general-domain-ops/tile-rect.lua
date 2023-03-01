local screen_rect = hs.screen.mainScreen():frame()

AxisToDimension = {
  x = "w",
  y = "h"
}

DimensionToAxis = {
  w = "x",
  h = "y"
}

--- @param divisor integer > 0
--- @param side "w" | "h"
--- @return number[]
function getStops(divisor, side)
  local stops = {}
  local axis_length = screen_rect[side]
  local stop_length = axis_length / divisor
  for i = 1, divisor + 1 do
    stops[i] = stop_length * (i - 1)
  end
  return stops
end


--- @param divisors integer[]
--- @return integer[][]
function getStopsForCoords(divisors)
  return {
    getStops(divisors[1], "w"),
    getStops(divisors[2], "h")
  }
end

--- @param stops integer[][]
--- @param coords integer[]
--- @return integer[]
function coordsFromStops(stops, coords)
  return {
    stops[1][coords[1]],
    stops[2][coords[2]]
  }
end


--- @alias tile_specifier { matrix: integer[], position?: integer[], span?: integer[] }

--- @param tile_specifier tile_specifier
--- @return hs.geometry.rect
function getTileRect(tile_specifier)
  tile_specifier.position = tile_specifier.position or { 1, 1 }
  tile_specifier.span = tile_specifier.span or { 1, 1 }
  local stops = getStopsForCoords(tile_specifier.matrix)
  local position = coordsFromStops(stops, tile_specifier.position)
  local span = coordsFromStops(stops, map(tile_specifier.span, function (value)
    return value + 1
  end))
  return hs.geometry.rect(
    position[1],
    position[2],
    span[1],
    span[2]
  )
end