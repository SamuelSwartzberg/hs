

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
    return tostring(ind), tostring(ind) .. "\n"
  end,
  {"k", "kv"}
)

runHsTaskParallel(
  cmds_from_1_to_10,
  function(results)
    assertTable(
      results,
      results_from_1_to_10
    )
  end
)


for i, v in ipairs(list_from_1_to_10) do
  runHsTaskNThreads(
    cmds_from_1_to_10,
    i,
    function(results)
      assertTable(
        results,
        results_from_1_to_10
      )
    end
  )
end