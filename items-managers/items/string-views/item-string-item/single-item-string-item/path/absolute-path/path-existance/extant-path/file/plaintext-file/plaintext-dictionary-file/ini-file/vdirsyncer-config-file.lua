

--- @type ItemSpecifier
VdirsyncerConfigFileItemSpecifier = {
  type = "vdirsyncer-config-file",
  properties = {
    getables = {
      ["vdirsyncer-config-sections"] = function(self, type)
        local res = {}
        local config_table = self:get("parse-to-lua-table")
        for k, v in prs(config_table) do
          local key_parts = stringy.split(k, " ")
          if key_parts[1] == type then
            res[key_parts[2]] = v
          end
        end
        return res
      end,
      ["table-to-vdirsyncer-config-section"] = function(self, specifier)
        specifier.header = specifier.type .. " " .. specifier.name
        return self:get("table-to-ini-section", specifier)
      end,
      ["vdirsyncer-config-pair"] = function(self, name)
        return self:get("vdirsyncer-config-sections", "pair")[name]
      end,
      ["vdirsyncer-config-storage"] = function(self, name)
        return self:get("vdirsyncer-config-sections", "storage")[name]
      end,
      ["vdirsyncer-config-next-webcal-readonly-index"] = function(self)
        local pairs = self:get("vdirsyncer-config-sections", "pair")
        local webcal_pair_keys = filter(pairs, {
          _start = "webcal_readonly_"
        }, "k")
        local indices = map(keys(webcal_pair_keys), function(k)
          return tonumber(k:match("webcal_readonly_(%d+)"))
        end)
        return reduce(indices) + 1
      end,
      ["vdirsyncer-pair-and-corresponding-storages"] = function(self, specifier)
        local local_name = specifier.name .. "_local"
        local remote_name = specifier.name .. "_remote"
        local pair = self:get("table-to-vdirsyncer-config-section", {
          type = "pair",
          name = specifier.name,
          body = {
            a = local_name,
            b = remote_name,
            collections = specifier.collections,
            conflict_resolution = specifier.conflict_resolution,
          }
        })
        local local_storage = self:get("table-to-vdirsyncer-config-section", {
          type = "storage",
          name = local_name,
          body = {
            type = specifier.local_storage_type,
            path = specifier.local_storage_path,
            fileext = specifier.local_storage_fileext,
          }
        })
        local remote_storage = self:get("table-to-vdirsyncer-config-section", {
          type = "storage",
          name = remote_name,
          body = {
            type = specifier.remote_storage_type,
            url = specifier.remote_storage_url,
            username = specifier.remote_storage_username,
            password = specifier.remote_storage_password,
          }
        })
        return table.concat({
          pair,
          local_storage,
          remote_storage,
        }, "\n\n")
      end,
      ["vdirsyncer-pair-and-corresponding-storages-for-webcal"] = function(self, url)
        local index = self:get("vdirsyncer-config-next-webcal-readonly-index")
        local name = "webcal_readonly_" .. index
        local local_storage_path =  env.XDG_STATE_HOME .. "/vdirsyncer/" .. name
        return {
          value = self:get("vdirsyncer-pair-and-corresponding-storages", {
            name = name,
            collections = "noquote:null",
            conflict_resolution = "b wins",
            local_storage_type = "filesystem",
            local_storage_path = local_storage_path,
            local_storage_fileext = ".ics",
            remote_storage_type = "http",
            remote_storage_url = url,
          }),
          name = name,
          at = local_storage_path
        }
      end,

    },
    doThisables = {
    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateVdirsyncerConfigFileItem = bindArg(NewDynamicContentsComponentInterface, VdirsyncerConfigFileItemSpecifier)