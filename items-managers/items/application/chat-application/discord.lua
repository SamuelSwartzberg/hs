--- @type ItemSpecifier
DiscordItemSpecifier = {
  type = "discord",
  properties = {
    doThisables = {
      ["generate-backup"] = function(self, do_after)
        dothis.absolute_path.empty_dir(env.TMP_DISCORD_EXPORT_PARENT)
        dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped(
          "dscexport exportdm --media --reuse-media -f json --dateformat unix -o" .. transf.string.single_quoted_escaped("$TMP_DISCORD_EXPORT_ITEM"),
          do_after
        )
      end,
    }
  },
  
 

}