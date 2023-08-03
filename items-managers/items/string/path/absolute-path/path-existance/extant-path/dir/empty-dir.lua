local project_type_init_map = {
  npm = function(path)
    run({
      "cd",
      transf.string.single_quoted_escaped(path),
      "&& npm init --yes && npm pkg set",
      transf.string.single_quoted_escaped("name=" .. transf.path.leaf(path)),
    }, true)
  end,
  omegat = function(path)
    dothis.absolute_path.write_file_if_nonextant_path(path .. "/omegat.project", comp.templates.omegat)
  end,
}


--- @type ItemSpecifier
EmptyDirItemSpecifier = {
  type = "empty-dir",
  properties = {
    getables = {
      ["descendants"] = function(self)
        return {self:get("c")} -- while self is not technically a descendant, in most cases where I want a descendant, but the dir is empty, I actually probably want the dir itself, so this is a good default
      end,
    },
    doThisables = {
      ["initalize-as-project-dir"] = function(self, type)
        project_type_init_map[type](self:get("completely-resolved-path"))
        st(self:get("completely-resolved-path")):doThis("initialize")
      end,
    }
  },
  action_table = {
    {
      text = "🌄▶️🏗 crproj.",
      key = "do-interactive",
      args = { thing = "project type (npm, omegat)", key = "initial-as-project-dir" }
    }
  }
}


--- @type BoundNewDynamicContentsComponentInterface
CreateEmptyDirItem = bindArg(NewDynamicContentsComponentInterface, EmptyDirItemSpecifier)