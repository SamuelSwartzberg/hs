local rrq = bindArg(relative_require, "items-managers.items.array.non-empty-array")

rrq("does-not-contain-nil-array")
rrq("contains-nil-array")
rrq("pair")
rrq("non-empty-array")