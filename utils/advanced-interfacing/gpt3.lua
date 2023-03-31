--- @param text_content string
--- @param opts { model?: string, max_tokens?: integer, temperature?: number, echo?: boolean, ai_role: "completion" | "chat", system_msg?: string } | fun(result: string): nil
--- @param do_after? fun(result: string): nil
function gpt(text_content, opts, do_after)
  if type(opts) == "function" then
    do_after = opts
    opts = {}
  end
  opts = opts or {}
  opts.ai_role = opts.ai_role or "chat"

  local request = {}
  request.model = opts.model or "gpt-3.5-turbo"
  request.max_tokens = opts.max_tokens or 300
  request.temperature = opts.temperature or 0.7

  local base_url = "https://api.openai.com/v1/"
  local endpoint
  if opts.ai_role == "completion" then
    endpoint = "completions"
  elseif opts.ai_role == "chat" then
    endpoint = "chat/completions"
  else
    error("Invalid ai_role: " .. tostring(opts.ai_role))
  end

  if opts.ai_role == "completion" then
    request.echo = opts.echo or false -- only supported for completions
    request.prompt = text_content
  elseif opts.ai_role == "chat" then
    request.messages = {}
    if opts.system_msg ~= nil then
      table.insert(request.messages, {
        role = "system",
        content = opts.system_msg or "You are a helpful assistant being queried through an API. Your output will be parsed, so adhere to any instructions given as to the format or content of the output."
      })
    end
    table.insert(request.messages, {
      role = "user",
      content = text_content
    })
  end

  local url = base_url .. endpoint

  rest({
    url = url,
    request_table = request,
    api_key = env.OPENAI_API_KEY
  },
  function(result)
    local response
    if opts.ai_role == "completion" then
      response = result.choices[1].text
    elseif opts.ai_role == "chat" then
      response = result.choices[1].message.content
    end
    if do_after then do_after(stringy.strip(response)) end
  end
  )
end