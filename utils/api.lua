--- @class RESTApiSpecifier
--- @field url? string 
--- @field host? string
--- @field endpoint? string
--- @field params? table
--- @field request_table? { [string]: any } | nil
--- @field api_key? string 
--- @field api_key_header? string
--- @field request_verb? string 

--- @param specifier RESTApiSpecifier
--- @param do_after? fun(result: table): nil
function makeSimpleRESTApiRequest(specifier, do_after)
  local url
  if specifier.url then
    url = specifier.url
  elseif specifier.host or specifier.endpoint or specifier.params then
    url = ensureAdfix(specifier.host, "/", false, false, "suf")
    url = url .. (ensureAdfix(specifier.endpoint, "/") or "/")
    url = url .. toUrlParams(specifier.params, "initial")
  else
    url = "https://dummyjson.com/products?limit=10&skip=10"
  end
  
  local curl_args = {"curl"}

  curl_args = listConcat(curl_args, { {
    value = url,
    type = "quoted"
  } })

  curl_args = listConcat(curl_args, {
    "-H", 
    { value = "Content-Type: application/json", type = "quoted"},
    "-H",
    { value = "Accept: application/json", type = "quoted"},
  })
  if specifier.api_key then 
    specifier.api_key_header = specifier.api_key_header or "Authorization: Bearer"
    curl_args = listConcat(curl_args, {
      "-H",
      { value =  specifier.api_key_header .. " " .. specifier.api_key, type = "quoted"}
    })
  end
  if specifier.request_verb then
    curl_args = listConcat(curl_args, {
      "--request",
      { value = specifier.request_verb, type = "quoted"}
    })
  end
  if specifier.request_table then
    local request_json = json.encode(specifier.request_table)
    curl_args = listConcat(curl_args, {
      "-d",
      { value = request_json, type = "quoted"}
    })
  end
  
  runHsTaskProcessOutput(
    curl_args, 
    function(std_out)
      local parsed_successfully, response = pcall(json.decode, std_out)
      if parsed_successfully then 
        if response.error then
          inspPrint(response)
          error("2xx response code but error in JSON response. See above.")
        end
        if do_after then
           do_after(response)
        end
      else
        error("Could not parse JSON response: " .. std_out)
      end
    end
  )
end

--- @param text_content string
--- @param do_after fun(result: string): nil
--- @param opts? { model?: string, max_tokens?: integer, temperature?: number, echo?: boolean }
function makeSimpleGPT3Request(text_content, do_after, opts)
  local request = mergeAssocArrRecursive({
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

--- @param opts { language?: string, amount?: integer, unit?: "list" | "paragraph" | "document", format?: string, topic?: string, use_only?: string }
--- @param do_after fun(result: string): nil
function generateDummyText(opts, do_after)
  -- no default for language, format, topic, use_only, since that's just extra load on the AI
  opts.amount = opts.amount or 50 
  opts.unit = opts.unit or "document"
  local ai_request_str = "The following "
  if opts.unit == "list" then
    ai_request_str = ai_request_str .. "is a list of %d words "
  elseif opts.unit == "paragraph" then
    ai_request_str = ai_request_str .. "is %d paragraphs "
  elseif opts.unit == "document" then
    ai_request_str = ai_request_str .. "is a short document of roughly %d words "
  end
  ai_request_str = ai_request_str .. "of dummy text "
  if opts.language then
    ai_request_str = ai_request_str .. "in " .. opts.language .. " "
  end
  if opts.topic then
    ai_request_str = ai_request_str .. "about " .. opts.topic .. " "
  elseif opts.use_only then
    ai_request_str = ai_request_str .. "using only " .. opts.use_only .. " "
  end
  ai_request_str = stringSlice(ai_request_str, 1, -2)
  if opts.format then
    ai_request_str = ai_request_str .. ", formatted as " .. opts.format
  end
  ai_request_str = ai_request_str .. "."
  local ai_request = string.format(ai_request_str, opts.amount)
  print(ai_request)
  makeSimpleGPT3Request(ai_request, do_after)
end

--- @param string_opts string
function dummyTxt(string_opts)
  takeShellikeArgsAsOpts(generateDummyText)(string_opts, function(res)
    CreateStringItem(res):doThis("choose-action")
  end)
end

--- @param opts { in_fields: {[string]: string}, out_fields: {value: string, alias?: string, explanation?: string}[] }
--- @param do_after fun(result: {[string]: string}): nil
function fillTemplateFromFieldsWithAI(opts, do_after)
  local ai_request_str = "Fill the following template\n\n"
  for _, field in ipairs(opts.out_fields) do
    ai_request_str = ai_request_str .. field.value
    if field.explanation then
      ai_request_str = ai_request_str .. " (" .. field.explanation .. ")"
    end
    ai_request_str = ai_request_str .. ":\n"
  end
  ai_request_str = ai_request_str .. "\nby extracting the data from the following fields\n\n"
  for field, value in pairs(opts.in_fields) do
    ai_request_str = ai_request_str .. field .. ": " .. value .. "\n"
  end
  ai_request_str = ai_request_str .. "\nIf there seems to be no data for a field, just leave it blank.\n\n"

  makeSimpleGPT3Request(ai_request_str, function (result)
    print(result)
    local out_fields = {}
    for _, field in ipairs(opts.out_fields) do
      local field_value = string.match(result, field.value .. "[^\n]-: *(.-)\n") or string.match(result, field.value .. "[^\n]-: *(.-)$")
      if field_value then
        out_fields[field.alias or field.value] = field_value
      end
    end
    do_after(out_fields)
  end, { temperature = 0})
end

local thing_formulation_map = {
  emoji = "emoji that could represent %s"
}

--- @param opts { amount?: integer, thing?: string, forwhat?: string }
--- @param do_after fun(result: string): nil
function generateList(opts, do_after)
  opts.amount = opts.amount or 10
  local formulation = thing_formulation_map[opts.thing] or opts.thing or "things"
  if opts.forwhat then
    formulation = formulation:format(opts.forwhat)
  end
  local ai_request_str = ("Generate a list of %d %s in the format <item>\\n<item>\\n..."):format(opts.amount, formulation)
  makeSimpleGPT3Request(ai_request_str, do_after)
end

--- @param string_opts string
function genList(string_opts)
  takeShellikeArgsAsOpts(generateList)(string_opts, function(res)
    print(res)
    CreateArray(stringy.split(res, "\n")):doThis("choose-action")
  end)
end

