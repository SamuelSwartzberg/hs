
--- @param chooser hs.chooser
--- @param row_style row_style
--- @param no_choices integer
--- @return nil
function styleRows(chooser, row_style, no_choices)
  local rows = clamp(no_choices, 30, row_style.max_rows or 30)
  chooser:rows(rows)
end

--- @param chooser hs.chooser
--- @param style_object whole_chooser_style
--- @return nil
function styleWholeChooser(chooser, style_object)
  for k, v in pairs(style_object) do
    chooser[k](chooser, v)
  end
end

--- @type item_style
DefaultStylesForChooser = {
  styledtext = {
    text = {
      font = {size = 14 },
      color = { red = 0, green = 0, blue = 0, alpha = 0.7 },
    },
    subText = {
      font = {size = 11 },
      color = { red = 0, green = 0, blue = 0, alpha = 0.7 },
    }
  },
  image = hs.image.imageFromASCII("")
}

--- @param style_specifier item_style
--- @param choices chooser_item[]
--- @return chooser_item[]
function getStyledChooserItems(style_specifier, choices)
  --- @type item_style
  local item_style = mergeAssocArrRecursive(DefaultStylesForChooser, style_specifier)
  local new_choices = {}
  for i, choice in ipairs(choices) do
    choice.image = choice.image or item_style.image
    for _, text in ipairs({"text", "subText"}) do
      if choice[text] then
        local text_string_or_styledtext = choice[text]
        local styled_text
        if type(text_string_or_styledtext) == "string" then 
          styled_text = hs.styledtext.new(text_string_or_styledtext, item_style.styledtext[text])
        else
          local existing_style = text_string_or_styledtext:asTable()
          local text_string = slice(existing_style, 1, 1)[1]
          local style = slice(existing_style, 2, #existing_style)
          styled_text = hs.styledtext.new(text_string, item_style.styledtext[text])
          for _, v in ipairs(style) do
            styled_text = styled_text:setStyle(v.attributes, v.starts, v.ends)
          end
        end
        choice[text] = styled_text
      end
    end
    new_choices[i] = choice
  end
  return new_choices
end

--- @param chooser hs.chooser
--- @param style_object? style_object
--- @param choices chooser_item[]
--- @return nil
function styleChooser(chooser, style_object, choices)
  if not style_object then style_object = {} end
  styleRows(chooser, style_object.row or {}, #choices)

  styleWholeChooser(chooser, style_object.whole_chooser or {}) -- can contain   keys
  chooser:choices(getStyledChooserItems(style_object.items or {}, choices))

end

--- @alias row_style { min_rows?: integer, max_rows?: integer}
--- @alias whole_chooser_style {bgDark?: boolean, fgColor?: hs.drawing.color | nil, subTextColor?: hs.drawing.color | nil, width: number, placeholderText?: string}
--- @alias styletext_attributes { font?: { size?: number }, color?: hs.drawing.color }
--- @alias item_style { image?: hs.image, styledtext?: { text?: styletext_attributes, subText?: styletext_attributes } }

--- @class style_object
--- @field row? row_style
--- @field whole_chooser? whole_chooser_style
--- @field items? item_style

--- @param choices chooser_item[]
--- @param process_chooser_table fun(chosen: chooser_item): nil
--- @param hschooser_postprocessing_callback? fun(hschooser: hs.chooser, choices: chooser_item[]): nil
--- @param style_object? style_object
--- @return nil
function buildChooser(choices, process_chooser_table, hschooser_postprocessing_callback, style_object) -- final two args are optional
  local hschooser = hs.chooser.new(function(chosen_item)
    if chosen_item then
      process_chooser_table(chosen_item)
    else
      log.i("No item chosen, doing nothing.")
    end
  end)  
  local initial_row = find(choices, function (choice)
    return (not not choice["initial-selected"]) == true
  end, {"v", "k"})
  styleChooser(hschooser, style_object, choices)
  
  hschooser:show()
  if initial_row then hschooser:selectedRow(initial_row) end -- must be after :show() or it won't work
  if hschooser_postprocessing_callback then
    hschooser_postprocessing_callback(hschooser, choices)
  end
end

