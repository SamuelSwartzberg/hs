print("t1")

runThreaded(
  {
    a = "echo 1",
    b = "echo 2",
    c = "echo 3"
  },
  3,
  function(results)
    assertMessage(
      results,
      {
        a = "1",
        b = "2",
        c = "3"
      }
    )
  end
)

error("stop")

print("t2")

runThreaded(
  {
    a = "echo 1",
    b = "echo 2",
    c = "echo 3"
  },
  1,
  function(results)
    assertMessage(
      results,
      {
        a = "1",
        b = "2",
        c = "3"
      }
    )
  end
)

print("t3")


runThreaded(
  {
    a = "echo 1",
    b = "echo 2",
    c = "echo 3"
  },
  2,
  function(results)
    assertMessage(
      results,
      {
        a = "1",
        b = "2",
        c = "3"
      }
    )
  end
)

print("t4")

runThreaded(
  {
    a = "echo 1",
    b = "sleep 0.1 && echo 2",
    c = "echo 3"
  },
  2,
  function(results)
    assertMessage(
      results,
      {
        a = "1",
        b = "2",
        c = "3"
      }
    )
  end
)

print("t5")

runThreaded(
  {
    a = "echo 1",
    b = "echo 2",
    c = "echo 3",
    d = "echo foo",
    e = "echo bar",
    f = "sleep 0.1 && echo baz",
    g = "echo 恋",
    h = "echo 愛"
  },
  3,
  function(results)
    assertMessage(
      results,
      {
        a = "1",
        b = "2",
        c = "3",
        d = "foo",
        e = "bar",
        f = "baz",
        g = "恋",
        h = "愛"
      }
    )
  end
)

list_from_1_to_10 = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }
cmds_from_1_to_10 = map(
  list_from_1_to_10,
  function (ind)
    return tostring(ind), {"echo", tostring(ind)}
  end,
  {"k", "kv"}
)

results_from_1_to_10 = map(
  list_from_1_to_10,
  function (ind)
    return tostring(ind), tostring(ind)
  end,
  {"k", "kv"}
)

for i, v in iprs(list_from_1_to_10) do
  runThreaded(
    cmds_from_1_to_10,
    i,
    function(results)
      assertMessage(
        results,
        results_from_1_to_10
      )
    end
  )
end