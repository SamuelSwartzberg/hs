join = {
  string = {
    table = {
      with_yaml_metadata = function(str, tbl)
        if not str then return transf.table.yaml_metadata(tbl) end
        if not tbl then return str end
        if transf.indexable.length(tbl) == 0 then return str end
        local stripped_str = stringy.strip(str)
        local final_metadata, final_contents
        if stringy.startswith(stripped_str, "---") then
          -- splice in the metadata
          local parts = filter(stringy.split(str, "---"), true) -- this should now have the existing metadata as [1], and the content as [2] ... [n]
          local extant_metadata = table.remove(parts, 1)
          final_metadata = extant_metadata .. "\n" .. transf.not_userdata_or_string.yaml_string(tbl)
          final_contents = concat(parts, "---")
        else
          final_metadata = transf.not_userdata_or_string.yaml_string(tbl)
          final_contents = str
        end
        return "---\n" .. final_metadata .. "\n---\n" .. final_contents
      end,
    },
  },
}