

--- @type ItemSpecifier
NewsboatUrlsFileItemSpecifier = {
  type = "newsboat-urls-file",
  properties = {
    getables = {
      
    },
    doThisables = {
      ["append-newsboat-url"] = function(self, specifier)
        transf.plaintext_file.append_line(
          self:get('c'), 
          ('%s\t"~%s"\t"_%s"'):format(
            specifier.url,
            specifier.title,
            ((specifier.category and #specifier.category > 0) and specifier.category) or "edu"
          )
        )
      end,
    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateNewsboatUrlsFileItem = bindArg(NewDynamicContentsComponentInterface, NewsboatUrlsFileItemSpecifier)