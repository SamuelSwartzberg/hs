--- @param text_content string
--- @param do_after fun(result: string): nil
--- @param opts? { model?: string, max_tokens?: integer, temperature?: number, echo?: boolean }
function gpt3Request(text_content, do_after, opts)
  local request = merge({
    model = "text-davinci-003",
    max_tokens = 300,
    temperature = 0.7,
    echo = false,
  }, opts or {})
  request.prompt = text_content
  makeSimpleRESTApiRequest({
    url = "https://api.openai.com/v1/completions",
    request_table = request,
    api_key = env.OPENAI_API_KEY
  },
  function(result)
    do_after(stringy.strip(result.choices[1].text))
  end
  )
end