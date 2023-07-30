-- often, it is useful to be able to have tables that don't need to be recreated, but are all just the same object. For example, this allows memoization to be performed without stringification, and may make code more readable. this is what refstore is for.

refstore = {
  params = {
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
        },
        invalidate_5_min = {
          invalidation_mode = "invalidate",
          interval = 5 * 60
        },
        invalidate_5_min_stringify_json = {
          stringify_table_params = true,
          table_param_subset = "json",
          invalidation_mode = "invalidate",
          interval = 5 * 60
        },
        invalidate_1_day = {
          invalidation_mode = "invalidate",
          interval = 24 * 60 * 60
        },
        invalidate_1_day_stringify_json = {
          stringify_table_params = true,
          table_param_subset = "json",
          invalidation_mode = "invalidate",
          interval = 24 * 60 * 60
        },
        invalidate_1_day_fs = {
          mode = "fs",
          invalidation_mode = "invalidate",
          interval = 24 * 60 * 60
        },
        invalidate_1_week_fs = {
          mode = "fs",
          invalidation_mode = "invalidate",
          interval = 7 * 24 * 60 * 60
        },
        invalidate_1_month_fs = {
          mode = "fs",
          invalidation_mode = "invalidate",
          interval = 30 * 24 * 60 * 60
        },
        invalidate_1_year_fs = {
          mode = "fs",
          invalidation_mode = "invalidate",
          interval = 365 * 24 * 60 * 60
        },
        permanent_fs = {
          mode = "fs",
        },
      }
    },
    ftcsv_parse = {
      opts = {
        noheaders = {
          headers = false
        },
      }
    }
  },
  consts = {
    POLLING_INTERVAL = 0.01 -- seconds, seems like good compromise between what applications might expect and performance
  }
}