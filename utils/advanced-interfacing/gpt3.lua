--- @param text_content string
--- @param opts { model?: string, max_tokens?: integer, temperature?: number, echo?: boolean, ai_role: "completion" | "chat" } | fun(result: string): nil
--- @param do_after? fun(result: string): nil
function gpt(text_content, opts, do_after)
  if type(opts) == "function" then
    do_after = opts
    opts = {}
  end
  opts = opts or {}
  local request = {}
  request.model = opts.model or "gpt-3.5-turbo"
  request.max_tokens = opts.max_tokens or 300
  request.temperature = opts.temperature or 0.7
  request.echo = opts.echo or false
  request.prompt = text_content

  local base_url = "https://api.openai.com/v1/"
  local endpoint
  if opts.ai_role == "completion" then
    endpoint = "completions"
  elseif opts.ai_role == "chat" then
    endpoint = "chat/completions"
  else
    error("Invalid ai_role: " .. tostring(opts.ai_role))
  end

  local url = base_url .. endpoint

  rest({
    url = url,
    request_table = request,
    api_key = env.OPENAI_API_KEY
  },
  function(result)
---@diagnostic disable-next-line: need-check-nil
    do_after(stringy.strip(result.choices[1].text))
  end
  )
end