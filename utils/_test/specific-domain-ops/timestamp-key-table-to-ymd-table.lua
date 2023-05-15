-- example timestamp-key ovtable
local example_table = ovtable.init({
  {key="1634271457", value={"event1"}},
  {key="1634271469", value={"event3"}},
  {key="1634271481", value={"event4"}},
  {key="1634366282", value={"event5"}},
  {key="1634366294", value={"event6"}},
  {key="1634366306", value={"event7"}},
  {key="1634366318", value={"event8"}},
})

-- example output table
local example_output = {
  ["2021"] = {
    ["2021-10"] = {
      ["2021-10-15"] = {
        {"06:18:01", "event4"},
        {"06:17:49", "event3"},
        {"06:17:37", "event1"},
      },
      ["2021-10-16"] = {
        {"08:38:38", "event8"},
        {"08:38:26", "event7"},
        {"08:38:14", "event6"},
        {"08:38:02", "event5"},
      }
    }
  }
}

-- test the function with the example table
assertMessage(
  timestampKeyTableToYMDTable(example_table),
  example_output
)

-- test the function with an empty table
assertMessage(
  timestampKeyTableToYMDTable(ovtable.new()),
  {}
)


-- test the function with a table containing a single element
assertMessage(
  timestampKeyTableToYMDTable(ovtable.init({{key="1634366282", value={"event5"}}})),
  {
    ["2021"] = {
      ["2021-10"] = {
        ["2021-10-16"] = {
          {"08:38:02", "event5"}
        }
      }
    }
  }
)

-- test the function with a table containing elements from different years
assertMessage(
  timestampKeyTableToYMDTable(ovtable.init({
    {key="1634271457", value={"event1"}},
    {key="1634271469", value={"event2"}},
    {key="1641024841", value={"event4"}},
    {key="1641024853", value={"event5"}},
  })),
  {
    ["2021"] = {
      ["2021-10"] = {
        ["2021-10-15"] = {
          {"06:17:49", "event2"},
          {"06:17:37", "event1"},
        }
      }
    },
    ["2022"] = {
      ["2022-01"] = {
        ["2022-01-01"] = {
          {"09:14:13", "event5"},
          {"09:14:01", "event4"},
        }
      }
    }
  }
)
-- test the function with a table containing elements from different months
assertMessage(
  timestampKeyTableToYMDTable(ovtable.init({
    {key="1633075200", value={"event1"}},
    {key="1635763200", value={"event2"}},
    {key="1638355200", value={"event3"}},
    {key="1641033600", value={"event4"}},
    {key="1643625600", value={"event5"}},
  })),
  {
    ["2021"] = {
      ["2021-10"] = {
        ["2021-10-01"] = {
          {"10:00:00", "event1"}
        }
      },
      ["2021-11"] = {
        ["2021-11-01"] = {
          {"11:40:00", "event2"}
        }
      },
      ["2021-12"] = {
        ["2021-12-01"] = {
          {"11:40:00", "event3"}
        }
      }
    },
    ["2022"] = {
      ["2022-01"] = {
        ["2022-01-01"] = {
          {"11:40:00", "event4"},
        },
        ["2022-01-31"] = {
          {"11:40:00", "event5"},
        }
      }
    }
  }
)

-- test the function with a table containing multiple events for the same timestamp
assertMessage(
  timestampKeyTableToYMDTable(ovtable.init({
    {key="1633075200", value={"event1", "event2", "event3"}},
    {key="1635763200", value={"event4"}},
    {key="1638355200", value={"event5"}},
    {key="1641033600", value={"event6"}},
    {key="1643625600", value={"event7", "event8"}},
  })),
  {
    ["2021"] = {
      ["2021-10"] = {
        ["2021-10-01"] = {
          {"10:00:00", "event1", "event2", "event3"}
        }
      },
      ["2021-11"] = {
        ["2021-11-01"] = {
          {"11:40:00", "event4"}
        }
      },
      ["2021-12"] = {
        ["2021-12-01"] = {
          {"11:40:00", "event5"}
        }
      }
    },
    ["2022"] = {
      ["2022-01"] = {
        ["2022-01-01"] = {
          {"11:40:00", "event6"}
        },
        ["2022-01-31"] = {
          {"11:40:00", "event7", "event8"}
        }
      }
    }
  }
)
