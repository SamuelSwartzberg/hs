assertMessage(
  processCronlikeLine("@startup\tbar baz", "foo"),
  {
    conditionType = "startup",
    fn = "foo",
    args = {"bar", "baz"}
  }
)

assertMessage(
  processCronlikeLine("* * * * *\tbar baz", "foo"),
  {
    conditionType = "timer",
    condition = "* * * * *",
    fn = "foo",
    args = {"bar", "baz"}
  }
)

local three_lines_nocomment = [[
* * * * *	bar
@startup	baz bam
2 3 * * *	1 2 3
]]


assertMessage(
  processCronlikeContents(three_lines_nocomment, "foo"),
  {
    {
      conditionType = "timer",
      condition = "* * * * *",
      fn = "foo",
      args = {"bar"}
    },
    {
      conditionType = "startup",
      fn = "foo",
      args = {"baz", "bam"}
    },
    {
      conditionType = "timer",
      condition = "2 3 * * *",
      fn = "foo",
      args = {"1", "2", "3"}
    }
  }
)

local three_lines_comment = [[
* * * * *	bar
# @startup	baz bam
2 3 * * *	1 2 3
]]

assertMessage(
  processCronlikeContents(three_lines_comment, "foo"),
  {
    {
      conditionType = "timer",
      condition = "* * * * *",
      fn = "foo",
      args = {"bar"}
    },
    {
      conditionType = "timer",
      condition = "2 3 * * *",
      fn = "foo",
      args = {"1", "2", "3"}
    }
  }
)

local three_lines_comment_and_blank = [[
* * * * *	bar

# @startup	baz bam
]]

local line_w_env_var = "2 5/2 * * *	$HOME"

assertMessage(
	processCronlikeContents(line_w_env_var, "foo"),
	{{
		conditionType = "timer",
		condition = "2 5/2 * * *",
		fn = "foo",
		args = {env.HOME}
	}}
)

assertMessage(
  processCronlikeContents(three_lines_comment_and_blank, "foo"),
  {
    {
      conditionType = "timer",
      condition = "* * * * *",
      fn = "foo",
      args = {"bar"}
    }
  }
)

local tmp_file_path = env.TMPDIR .. "/test-cronlike/" .. os.time() .. "/cron-like"

dothis.absolute_path.write_file(tmp_file_path, three_lines_comment)

assertMessage(
  processCronlikeFile(tmp_file_path),
  {
    {
      conditionType = "timer",
      condition = "* * * * *",
      fn = "cronLike",
      args = {"bar"}
    },
    {
      conditionType = "timer",
      condition = "2 3 * * *",
      fn = "cronLike",
      args = {"1", "2", "3"}
    }
  }
)

dothis.absolute_path.delete