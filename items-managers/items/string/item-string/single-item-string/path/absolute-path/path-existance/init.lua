local rrq = bindArg(relative_require, "items-managers.items.string.path.absolute-path.path-existance")

rrq("non-extant-path")
rrq("extant-path")
