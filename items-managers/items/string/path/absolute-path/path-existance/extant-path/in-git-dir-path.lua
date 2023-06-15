--- @type ItemSpecifier
InGitDirPathItemSpecifier = {
  type = "in-git-dir-path",
  action_table = {
    {
      text = "🐙⬆️ gtpsh.",
      dothis = dothis.in_git_dir.push
    },{
      text = "🐙⬇️ gtpll.",
      dothis = dothis.in_git_dir.pull
    },{
      text = "🐙🔄 gtftch.",
      dothis = dothis.in_git_dir.fetch
    },
    {
      i = "🐙❗️",
      d = "gtig",
      getfn = transf.in_git_dir.gitignore_path
    },{
      i = "🐙👩🏽‍💻🔗",
      d = "gtremurl",
      getfn = transf.in_git_dir.remote_url
    },{
      i = "🐙👩🏽‍💻📄🔗",
      d = "gtremblburl",
      getfn = get.in_git_dir.remote_blob_url
    },{
      i = "🐙👩🏽‍💻🍣🔗",
      d = "gtremrawurl",
      getfn = get.in_git_dir.remote_raw_url
    },{
      i = "🐙🙋🏽‍♀️💼",
      d = "gtremownitm",
      getfn = transf.in_git_dir.remote_owner_item
    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateInGitDirPathItem = bindArg(NewDynamicContentsComponentInterface, InGitDirPathItemSpecifier)