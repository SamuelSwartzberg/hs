--- @type ItemSpecifier
URLItemSpecifier = {
  type = "url",
  properties = {
    doThisables = {
      ["add-to-urls"] = function(self, name)
        local path = st(env.MURLS):get("related-path-with-subdirs-gui")
        path:doThis('create-file-with-contents', {
          contents = self:get("c"),
          name = ((name and #name > 0) and name) or self:get("html-title") .. ".url2"
        })
      end,
      ["subscribe-to-calendar"] = function(self)
        local name = self:get("url-domain")
        local khal_config = st(env.KHAL_CONFIG .. "/config")
        local vdirsyncer_config = st(env.VDIRSYNCER_CONFIG .. "/config" )
        local vdirsyncer_pair_specifier = vdirsyncer_config:get("vdirsyncer-pair-and-corresponding-storages-for-webcal", self:get("c"))
        local path  = env.XDG_STATE_HOME .. "/vdirsyncer/" .. vdirsyncer_pair_specifier.name
        local khal_data = khal_config:get("table-to-ini-section", {
          header = "[ro:" .. name .. "]", -- this results in double [[ ]] in the file, which is the format khal expects (don't ask me why)
          body = {
            path = path,
            priority = 0
          }
        })
        khal_config:doThis("append-file-contents", "\n\n" .. khal_data)
        vdirsyncer_config:doThis("append-file-contents", "\n\n" .. transf.vdirsyncer_pair_specifier.ini_string(vdirsyncer_pair_specifier))
        dothis.absolute_path.create_dir(path)
        dothis.string.env_bash_eval_w_string_or_nil_arg_fn_by_stripped(
          "vdirsyncer discover" ..
          transf.string.single_quoted_escaped(vdirsyncer_pair_specifier.name),
          get.fn.first_n_args_bound_fn(
            dothis.string.env_bash_eval_async,
            "vdirsyncer sync" .. transf.string.single_quoted_escaped(vdirsyncer_pair_specifier.name)
          )
        )
        khal_config:doThis("git-commit-self", "Add web-calendar " .. name)
        khal_config:doThis("git-push")
      end,

    }
  }
}

--- @type BoundNewDynamicContentsComponentInterface
CreateURLItem = bindArg(NewDynamicContentsComponentInterface, URLItemSpecifier)