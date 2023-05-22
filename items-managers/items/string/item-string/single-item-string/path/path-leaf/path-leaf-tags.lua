--- @type ItemSpecifier
PathLeafTagsSpecifier = {
  type = "path-leaf-tags",
  properties = {
    getables = {
      ["path-leaf-tags"] = function(self) 
        local leaf_without_extension = self:get("leaf-without-extension")
        return leaf_without_extension:match("^[^%%]*(%%.*)$") or ""
      end,
      ["tag-string-inner-list"] = function (self)
        return memoize(filter)(stringy.split(self:get("path-leaf-tags"), "%"), true)
      end,
      ["tag-raw-value-map"] = function (self)
        local tag_string_inner_list = self:get("tag-string-inner-list")
        local tag_raw_value_map = {}
        for _, tag_string_inner in iprs(tag_string_inner_list) do
          local tag_name, tag_value_raw = tag_string_inner:match("^(.-)-(.+)$")
          tag_raw_value_map[tag_name] = tag_value_raw
        end
        return tag_raw_value_map
      end,
      ["tag-value-map"] = function (self)
        local tag_raw_value_map = self:get("tag-raw-value-map")
        local tag_value_map = {}
        for tag_name, tag_value_raw in fastpairs(tag_raw_value_map) do
          tag_value_map[tag_name] = stringy.split(tag_value_raw, ",")
        end
        return tag_value_map
      end,
      ["tag-raw-value"] = function (self, tag_name)
        local tag_raw_value_map = self:get("tag-raw-value-map")
        return tag_raw_value_map[tag_name]
      end,
      ["tag-value"] = function (self, tag_name)
        local tag_value_map = self:get("tag-value-map")
        return tag_value_map[tag_name]
      end,
      ["tag-name-list"] = function (self)
        local tag_raw_value_map = self:get("tag-raw-value-map")
        local tag_name_list = {}
        for tag_name, _ in fastpairs(tag_raw_value_map) do
          table.insert(tag_name_list, tag_name)
        end
        return tag_name_list
      end,
      ["has-tag-name"] = function (self, tag_name)
        local tag_name_list = self:get("tag-name-list")
        for _, tag_name_in_list in iprs(tag_name_list) do
          if tag_name_in_list == tag_name then
            return true
          end
        end
        return false
      end,
      ["has-tag-value"] = function (self, tag_name)
        local tag_value_map = self:get("tag-value-map")
        return not not tag_value_map[tag_name]
      end,
      ["has-tag-value-raw"] = function (self, tag_name)
        local tag_raw_value_map = self:get("tag-raw-value-map")
        return not not tag_raw_value_map[tag_name]
      end,
      ["tag-audiovisual"] = function(self)
        if self:get("has-tag-value", "title")
            or self:get("has-tag-value", "srs")
            or self:get("has-tag-value", "tcrea")
            or self:get("has-tag-value", "char")
        then
          local filename = ""
          if self:get("has-tag-value", "srs") then

            filename = filename .. string.format("<%s", self:get("tag-raw-value", "srs"))

            if self:get("has-tag-value", "vol") then
              filename = filename .. string.format("/V%s", self:get("tag-raw-value", "vol"))
            end
            if self:get("has-tag-value", "season") then
              filename = filename .. string.format("/S%s", self:get("tag-raw-value", "season"))
            end
            if self:get("has-tag-value", "ep") then
              filename = filename .. string.format("/E%s", self:get("tag-raw-value", "ep"))
            end
            if self:get("has-tag-value", "ch") then
              filename = filename .. string.format("/C%s", self:get("tag-raw-value", "ch"))
            end
            if self:get("has-tag-value", "srsrel") then
              filename = filename .. string.format(":%s", self:get("tag-raw-value", "srsrel"))
              if self:get("has-tag-value", "srsrelindex") then
                filename = filename .. string.format("%s", self:get("tag-raw-value", "srsrelindex"))
              end
            end
            filename = filename .. "> "
          end

          if self:get("has-tag-value", "char") then
            filename = filename .. string.format(" w/ %s", self:get("tag-raw-value", "char"))
          end

          if self:get("has-tag-value", "title") then
            filename = filename ..  self:get("tag-raw-value", "title")
          end

          if self:get("has-tag-value", "orig") then
            filename = filename .. string.format(" (%s)", self:get("tag-raw-value", "orig"))
          end

          if self:get("has-tag-value", "tcrea") then
            filename = filename .. string.format(" BY %s", self:get("tag-raw-value", "tcrea"))
          end

          if self:get("has-tag-value", "n") then
            filename = filename .. string.format(" #%s", self:get("tag-raw-value", "n"))
          end

          return filename
        else
          return self:get("tag-full-basic")
        end
      end
    }
  },
  action_table = {},
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePathLeafTags = bindArg(NewDynamicContentsComponentInterface, PathLeafTagsSpecifier)