assert(
  is.string.package_manager("os")
)

assert(
  not is.string.package_manager("not a package manager")
)

assert(
  is.uuid.contact("a615b162-a203-4a24-a392-87ba3a7ca80c")
)

assert(
  not is.uuid.contact(mt._exactly.null_uuid)
)