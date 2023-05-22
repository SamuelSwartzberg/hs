

--- @type ItemSpecifier
TachiyomiJsonFileItemSpecifier = {
  type = "tachiyomi-json-file",
  properties = {
    getables = {
      ["to-timestamp-key-history-list"] = function(self)
        -- data we care about is in the backupManga array in the json file
        -- each array element is a manga which has general metadata keys such as title, author, url, etc
        -- and a chapters array which has chapter metadata keys such as name, chapterNumber, url, etc
        -- and a history array which has the keys url and lastRead (unix timestamp in ms)
        -- we want to transform this into a table of our own design, where the key is a timestamp (but in seconds) and the value is an array consisting of some of the metadata of the manga and some of the metadata of the chapter
        -- specifically: url (of the manga), title, chapterNumber, name (of the chapter)
        -- for that, we need to match the key url in the history array with the key url in the chapters array, for which we will create a temporary table with the urls as keys and the chapter metadata we will use as values

        local raw_backup = self:get("parse-to-lua-table")
        local manga = raw_backup.backupManga
        local manga_url, manga_title = manga.url, manga.title
        local chapter_map = {}
        for _, chapter in ipairs(manga.chapters) do
          chapter_map[chapter.url] = {
            chapterNumber = chapter.chapterNumber,
            name = chapter.name
          }
        end
        local history_list = {}
        for _, hist_item in ipairs(manga.history) do
          local chapter = chapter_map[hist_item.url]
          history_list[hist_item.lastRead / 1000] = {
            manga_url,
            manga_title,
            chapter.chapterNumber,
            chapter.name
          }
        end
        return history_list
      end,
    },
    doThisables = {
      
    }
  },
}

--- @type BoundNewDynamicContentsComponentInterface
CreateTachiyomiJsonFileItem = bindArg(NewDynamicContentsComponentInterface, TachiyomiJsonFileItemSpecifier)