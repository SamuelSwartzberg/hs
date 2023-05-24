local response = hydrus({
  endpoint = "api_version",
})

assert(
  type(response.version) == "number"
)