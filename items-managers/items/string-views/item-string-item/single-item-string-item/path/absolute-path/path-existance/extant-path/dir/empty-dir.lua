local project_type_init_map = {
  npm = function(path)
    run({
      "cd",
      { value = path, type = "quoted" },
      "&&",
      "npm",
      "init",
      "--yes",
      "&&",
      "npm",
      "pkg",
      "set",
      { value = "name=" .. getLeafWithoutPath(path), type = "quoted" },
    }, true)
  end,
  omegat = function(path)
    writeFile(path .. "/omegat.project", comp.templates.omegat, "not-exists")
  end,
}


--- @type ItemSpecifier
EmptyDirItemSpecifier = {
  type = "empty-dir",
  properties = {
    getables = {
      ["descendant-string-array"] = function(self)
        return CreateArray(self.root_super) -- while self is not technically a descendant, in most cases where I want a descendant, but the dir is empty, I actually probably want the dir itself, so this is a good default
      end,
    },
    doThisables = {
      ["initalize-as-project-dir"] = function(self, type)
        project_type_init_map[type](self:get("contents"))
        CreateStringItem(self:get("contents")):doThis("initialize")
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