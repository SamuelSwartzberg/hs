--- @type ItemSpecifier
GrandparentDirItemSpecifier = {
  type = "grandparent-dir",
  properties = {
    getables = {
      ["is-git-root-dir"] = bc(is.dir.git_root_dir)
    },
  },
  ({
    { key = "git-root-dir", value = CreateGitRootDirItem },
  }),
  action_table = {
    

  }
}


--- @type BoundNewDynamicContentsComponentInterface
CreateGrandparentDirItem = bindArg(NewDynamicContentsComponentInterface, GrandparentDirItemSpecifier)