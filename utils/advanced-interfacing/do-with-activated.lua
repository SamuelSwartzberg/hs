


--- @param app string|hs.application
--- @param fn function
--- @param reactivate_last_app? boolean
--- @return any
function doWithActivated(app, fn, reactivate_last_app)
  local app_obj = app
  if type(app) == "string" then
    app_obj = hs.application.get(app)
  end
  local last_app = hs.application.frontmostApplication()
  app_obj:activate()
  local retval = {fn()}
  if last_app and reactivate_last_app then 
    last_app:activate()
  end
  return table.unpack(retval)
end