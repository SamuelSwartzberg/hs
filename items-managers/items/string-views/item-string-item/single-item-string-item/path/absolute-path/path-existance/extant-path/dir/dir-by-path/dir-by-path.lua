--- @type ItemSpecifier
DirByPathItemSpecifier = {
  type = "dir-by-path-dir",
  properties = {
    getables = {
      ["is-applications-dir"] = function(self)
        return self:get("path-ensure-final-slash") == env.MAC_APPLICATIONS
      end,
      ["is-diary-dir"] = function(self)
        return self:get("path-ensure-final-slash") == env.MDIARY .. "/"
      end,
      ["is-menv-dir"] = function(self)
        return self:get("path-ensure-final-slash") == env.MENV .. "/"
      end,
      ["is-mcur-proj-dir"] = function(self)
        return self:get("path-ensure-final-slash") == env.MCUR_PROJ .. "/"
      end,

    },
  },
  potential_interfaces = ovtable.init({
    { key = "applications-dir", value = CreateApplicationsDirItem },
    { key = "diary-dir", value = CreateDiaryDirItem },
    { key = "menv-dir", value = CreateMenvDirItem },
    { key = "mcur-proj-dir", value = CreateMCurProjDirItem },  
  })
}


--- @type BoundNewDynamicContentsComponentInterface
createPathByPathItem = bindArg(NewDynamicContentsComponentInterface, DirByPathItemSpecifier)