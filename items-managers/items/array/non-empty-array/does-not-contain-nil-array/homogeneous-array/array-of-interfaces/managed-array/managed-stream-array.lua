ManagedStreamArraySpecifier = {
  type = "managed-stream-array",
  properties = {
    getables = {
      ["first-playing-stream"] = function(self)
        return self:get("find", function(stream) return not stream:get("key", "pause") end)
      end,
      ["creator"] = function() return CreateStreamItem end,
    },
    doThisables = {
      ["create-background-stream"] = function(self, relative_path)
        st(env.MAUDIOVISUAL .. "/" .. relative_path):doThis("to-stream", {
          initial_flags = {
            shuffle = true,
            ["loop-playlist"] = true,
            ["no-video"] = true,
            pause = true,
          }
        })
      end,
      ["create-background-streams"] = function(self, relative_paths)
        for _, relative_path in ipairs(relative_paths) do
          self:doThis("create-background-stream", relative_path)
        end
      end,
    },
  },
  
  action_table = {}
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreateManagedStreamArray = bindArg(NewDynamicContentsComponentInterface, ManagedStreamArraySpecifier)

--- @type BoundRootInitializeInterface
function CreateManagedStreamArrayDirectly(timer_manager)
  local managed_stream_array = ar({}, "stream")
  timer_manager:doThis("create", {
    interval = "*/3 * * * * *",
    low_impact = true,
    fn = function()
      managed_stream_array:doThis("maintain-state")
    end
  })
  return managed_stream_array
end