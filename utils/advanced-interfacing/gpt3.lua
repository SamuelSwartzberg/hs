--- @param text_content string
--- @param opts? { model?: string, max_tokens?: integer, temperature?: number, echo?: boolean, system_msg?: string } | fun(result: string): nil
--- @param do_after? fun(result: string): nil
function gpt(text_content, opts, do_after)
  if type(opts) == "function" then
    do_after = opts
    opts = {}
  end
  opts = opts or {}

  local request = {}
  request.model = opts.model or "gpt-4"
  request.max_tokens = opts.max_tokens or 300
  request.temperature = opts.temperature or 0.7


  local endpoint = "chat/completions"

  request.messages = {}
  table.insert(request.messages, {
    role = "system",
    content = opts.system_msg or "You are a helpful assistant being queried through an API. Your output will be parsed, so adhere to any instructions given as to the format or content of the output."
  })

  table.insert(request.messages, {
    role = "user",
    content = text_content
  })

  local request_opts = {
    endpoint = endpoint,
    request_table = request,
    api_name = "openai",
  }

  if do_after then
    rest(request_opts, function(result)
      do_after(transf.gpt_response_table.response_text(result))
    end)
  else
    local result = rest(request_opts)
    return transf.gpt_response_table.response_text(result)
  end
end