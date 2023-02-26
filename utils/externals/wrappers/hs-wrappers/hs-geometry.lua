--- @param p1 hs_geometry_point_table
--- @param p2 hs_geometry_point_table
--- @return hs_geometry_point_table
function pointdelta(p1, p2)
  return {
    x = p1.x - p2.x,
    y = p1.y - p2.y
  }
end