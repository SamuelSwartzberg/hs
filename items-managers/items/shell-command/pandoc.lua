

function addMetadata(rawsource, metadata)
  local metadata_string = yamlDump(metadata or {})
  local final_metadata, final_contents
  if stringy.startswith(rawsource, "---") then
    -- splice in the metadata
    local parts = filter(stringy.split(rawsource, "---", true))
    final_metadata = parts[1] .. "\n" .. metadata_string
    final_contents = parts[2]
  else
    final_metadata = metadata_string
    final_contents = rawsource
  end
  return "---\n" .. final_metadata .. "\n---\n" .. final_contents 
end

function preProcess(rawsource, preprocess)
  if not preprocess then
    return rawsource
  end
  if preprocess.enforce_space_blank_lines then
    rawsource = eutf8.gsub(rawsource, "\n +\n", "\n&nbsp;\n")
  end
  return rawsource
end

--- @type ItemSpecifier
PandocCommandSpecifier = {
  type = "pandoc-command",
  properties = {
    getables = {
      
    },
    doThisables = {
      ["convert-md"] = function(self, specifier)
        local source, target = resolve({s = {path = specifier.source}, t = {path = specifier.target, suffix = "." .. specifier.target_ext}}) -- the resolve function ensures that if one of these is nil, a path in the same dir as the other is returned, but with the target_ext
        local rawsource = readFile(source)
        local processedsource = addMetadata(rawsource, specifier.metadata)
        processedsource = preProcess(processedsource, specifier.preprocess)
        local temp_path = source .. ".tmp"
        writeFile(temp_path, processedsource) 
        local command_parts = {
          "pandoc",
        }
        if not specifier.wrap then
          table.insert(command_parts, "--wrap=preserve")
        end
        table.insert(command_parts, "-f")
        if specifier.soft_line_breaks then 
          table.insert(command_parts, "gfm")
        else 
          table.insert(command_parts, "gfm+hard_line_breaks")
        end
        if not specifier.not_standalone then
          table.insert(command_parts, "--standalone")
        end
        table.insert(command_parts, "-t")
        table.insert(command_parts, specifier.format)
        table.insert(command_parts, "-i")
        table.insert(command_parts, {value = temp_path, type ="quoted"})
        table.insert(command_parts, "-o")
        table.insert(command_parts, {value = target, type ="quoted"})
        command_parts = listConcat(command_parts, specifier.extra_args)
        runHsTaskProcessOutput(command_parts, function ()
          -- deleteFile(temp_path)
          if specifier.do_after then
            specifier.do_after(target)
          end
        end)
      end,
      ["md-to-latexlike-pdf"] = function (self, specifier)
        self:doThis("convert-md", mergeAssocArrRecursive({
          format = "pdf",
          metadata = {
            geometry = "margin=3cm"
          },
          preprocess = {
            enforce_space_blank_lines = true
          }
        }, specifier))
      end,
      ["md-to-latex-beamer-pdf"] = function(self, specifier)
        self:doThis("convert-md", mergeAssocArrRecursive({
          format = "beamer",
          preprocess = {
            enforce_space_blank_lines = true
          }
        }, specifier))
      end,
      ["md-to-revealjs"] = function(self, specifier)
        self:doThis("convert-md", mergeAssocArrRecursive({
          format = "revealjs",
          target_ext = ".html",
          extra_args = {
            "-V",
            "theme='white'",
          }
        }, specifier))
      end,
    }
  },
  
}

--- @type BoundNewDynamicContentsComponentInterface
CreatePandocCommand = bindArg(NewDynamicContentsComponentInterface, PandocCommandSpecifier)
