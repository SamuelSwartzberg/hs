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
  ai_request_str = slice(ai_request_str, 1, -1)
  if opts.format then
    ai_request_str = ai_request_str .. ", formatted as " .. opts.format
  end
  ai_request_str = ai_request_str .. "."
  local ai_request = string.format(ai_request_str, opts.amount)
  print(ai_request)
  gpt3(ai_request, do_after)
end

local thing_formulation_map = {
  emoji = "emoji that could represent %s"
}

--- @param string_opts string
function dummyTxt(string_opts)
  takeShellikeArgsAsOpts(generateDummyText)(string_opts, function(res)
    CreateStringItem(res):doThis("choose-action")
  end)
end

--- @param opts { amount?: integer, thing?: string, forwhat?: string }
--- @param do_after fun(result: string): nil
function generateList(opts, do_after)
  opts.amount = opts.amount or 10
  local formulation = thing_formulation_map[opts.thing] or opts.thing or "things"
  if opts.forwhat then
    formulation = formulation:format(opts.forwhat)
  end
  local ai_request_str = ("Generate a list of %d %s in the format <item>\\n<item>\\n..."):format(opts.amount, formulation)
  gpt3(ai_request_str, do_after)
end

--- @param string_opts string
function genList(string_opts)
  takeShellikeArgsAsOpts(generateList)(string_opts, function(res)
    CreateArray(stringy.split(res, "\n")):doThis("choose-action")
  end)
end

