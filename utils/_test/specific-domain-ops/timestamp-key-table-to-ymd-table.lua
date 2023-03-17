-- example timestamp-key ovtable
local example_table = ovtable.init({
  {key="1634271457", value={"event1"}},
  {key="1634271469", value={"event2"}},
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
        {"23:01:18", "event8"},
        {"23:01:06", "event7"},
        {"23:01:02", "event6"},
        {"23:01:00", "event5"}
      },
      ["2021-10-14"] = {
        {"23:08:01", "event4"},
        {"23:04:29", "event3"},
        {"23:04:17", "event1"}
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
        ["2021-10-15"] = {
          {"23:01:22", "event5"}
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
    {key="1634271469", value={"event3"}},
    {key="1641024841", value={"event4"}},
    {key="1641024853", value={"event5"}},
  })),
  {
    ["2021"] = {
      ["2021-10"] = {
        ["2021-10-15"] = {
          {"23:08:01", "event4"},
          {"23:04:29", "event2", "event3"},
          {"23:04:17", "event1"}
        }
      }
    },
    ["2022"] = {
      ["2022-12"] = {
        ["2022-12-31"] = {
          {"23:20:53", "event5"}
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
{"00:00:00", "event1"}
}
},
["2021-11"] = {
["2021-11-01"] = {
{"00:00:00", "event2"}
}
},
["2021-12"] = {
["2021-12-01"] = {
{"00:00:00", "event3"}
}
}
},
["2022"] = {
["2022-01"] = {
["2022-01-01"] = {
{"00:00:00", "event4"}
}
},
["2022-02"] = {
["2022-02-01"] = {
{"00:00:00", "event5"}
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
{"00:00:00", "event1", "event2", "event3"}
}
},
["2021-11"] = {
["2021-11-01"] = {
{"00:00:00", "event4"}
}
},
["2021-12"] = {
["2021-12-01"] = {
{"00:00:00", "event5"}
}
}
},
["2022"] = {
["2022-01"] = {
["2022-01-01"] = {
{"00:00:00", "event6"}
}
},
["2022-02"] = {
["2022-02-01"] = {
{"00:00:00", "event7", "event8"}
}
}
}
})