local rrq = bindArg(relative_require, "utils._test.advanced-interfacing.do-input")

rrq("do-delta")
rrq("do-input")
error("stop")
rrq("do-series")