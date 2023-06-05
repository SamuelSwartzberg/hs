--- @class out_field  
--- @field value string The field to fill, as we want GPT to see it (i.e. chosing a name that GPT will understand)
--- @field alias? string The field to fill, as we want the user to see it (i.e. chosing a name that the user will understand). May often be unset, in which case the value field is used.
--- @field explanation? string The explanation to show to GPT for the field. May be unset if the field is self-explanatory.

--- @class fillTemplateGPTOpts
--- @field in_fields {[string]: string} The fields to take the data from
--- @field out_fields out_field[] The fields (i.e. the template) to fill

--- fills a template using GPT
--- example use-case: Imagine trying to get the metadata of some song from a youtube video, where the artist name may be in the title, or the channel name, or not present at all, where the title may contain a bunch of other stuff besides the song title
--- in this case you could call this function as
--- ```
--- fillTemplateGPT(
---   {
---     in_fields = {
---       channel_name = "XxAimerLoverxX",
---       video_title = "XxAimerLoverxX - Aimer - Last Stardust",
---     },
---     out_fields = {
---       {value = "artist"},
---       {value = "song_title"},
---     }
---   }, ...
--- )
--- ```
--- @param opts fillTemplateGPTOpts
--- @param do_after fun(result: {[string]: string}): nil
function fillTemplateGPT(opts, do_after)
  local query = le(lemap.gpt.fill_template, opts)
  gpt(query,  { temperature = 0}, function (result)
    local out_fields = map(
      opts.out_fields,
      function (field, value)
        return 
          value.alias or value.value, 
          string.match(result, value.value .. "[^\n]-: *(.-)\n") or string.match(result, value.value .. "[^\n]-: *(.-)$")
      end,
      "kv"
    )
    do_after(out_fields)
  end)
end

