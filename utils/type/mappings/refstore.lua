-- often, it is useful to be able to have tables that don't need to be recreated, but are all just the same object. For example, this allows memoization to be performed without stringification, and may make code more readable. this is what refstore is for.

refstore = {
  params = {
    path_slice = {
      opts = {
        ext_sep = {
          ext_sep = true
        },
        rejoin_at_end = {
          rejoin_at_end = true
        },
      }
    },
    memoize = {
      opts = {
        stringify_table_params = {
          stringify_table_params = true
        },
        table_param_subset = {
          table_param_subset = "json"
        },
        stringify_json = {
          stringify_table_params = true,
          table_param_subset = "json"
        }
      }
    }
  }
}