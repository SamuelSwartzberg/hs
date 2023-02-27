--- @return action_table_item[]
function createAllCreationEntryCombinations()
  return allTransformedCombinations(
    { "no-video", "loop-playlist", "shuffle" },
    function (combination)
      local chars = mapValueNewValue(combination, bind(string.sub, {["2"] = {1, 1}}))
      return {
        text =  "🎸 pl" .. stringx.join("", chars) .. ".",
        key = "to-stream",
        args = { 
          initial_flags = listToBoolTable(combination)
        }
      }
    end
  )
end



