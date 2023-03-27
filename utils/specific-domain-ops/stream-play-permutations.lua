--- @return action_table_item[]
function createAllCreationEntryCombinations()
  return map(
    powerset({ "no-video", "loop-playlist", "shuffle" }),
    function (combination)
      local chars = map(combination, bind(string.sub, {{a_use,  = {1, 1}}))
      return {
        text =  "🎸 pl" .. stringx.join("", chars) .. ".",
        key = "to-stream",
        args = { 
          initial_flags = map(combination, function(flag) return flag, true end, {"k", "kv"})
        }
      }
    end
  )
end



