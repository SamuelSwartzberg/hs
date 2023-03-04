StringKeyTableSpecifier = {
  type = "string-key-table",
  properties = {
    getables = {
      ["is-vcard-email-key-table"] = function(self)
        return self:get("all-keys-are-in-list", {"home", "internet", "pref", "work"})
      end,
      ["is-vcard-phone-key-table"] = function(self)
        return self:get("all-keys-are-in-list", {"home", "cell", "work", "pref", "pager", "voice", "fax", "voice"}) -- only those in both vcard 3.0 and 4.0
      end,
      ["is-single-address-key-table"] = function(self)
        return self:get("all-keys-are-in-list", {"Formatted name", "First name", "Last name", "Street", "Code", "City", "Region", "Country", "Box", "Extended"})
      end,
      ["is-unicode-prop-key-table"] = function(self) -- keys are those provided by the `uni` command provided by the unicode consortium itself
        return self:get("all-keys-are-in-list", {
          "bin",
          "block",
          "cat",
          "char",
          "cpoint",
          "dec",
          "digraph",
          "hex",
          "html",
          "json",
          "keysym",
          "name",
          "plane",
          "props",
          "utf16be",
          "utf16le",
          "eutf8",
          "width",
          "xml"
        }
      )
      end,
      ["is-emoji-prop-key-table"] = function(self) -- keys are those provided by the `uni emoji` subcommand of the aforementioned `uni` command
        return self:get("all-keys-are-in-list", {
          "cldr",
          "cldr_full",
          "cpoint",
          "emoji",
          "group",
          "name",
          "subgroup",
        })
      end,
      ["is-csl-key-table"] = function(self)
        return self:get("all-keys-are-in-list", {
          "type",
          "id",
          "categories",
          "language",
          "journalAbbreviation",
          "shortTitle",
          "author",
          "chair",
          "collection-editor",
          "compiler",
          "compiler",
          "composer",
          "container-author",
          "contributor",
          "curator",
          "director",
          "editor",
          "editorial-director",
          "executive-producer",
          "guest",
          "url-host",
          "illustrator",
          "interviewer",
          "narrator",
          "original-author",
          "performer",
          "producer",
          "recipient",
          "reviewed-author",
          "script-writer",
          "series-creator",
          "translator",
          "accessed",
          "available-date",
          "event-date",
          "issued",
          "original-date",
          "submitted",
          "abstract",
          "annote",
          "archive",
          "archive_collection",
          "archive_location",
          "archive-place",
          "authority",
          "call-number",
          "chapter-number",
          "citation-number",
          "citation-label",
          "collection-number",
          "collection-title",
          "container-title",
          "container-title-short",
          "dimensions",
          "division",
          "DOI",
          "edition",
          "event",
          "event-title",
          "event-place",
          "first-reference-note-number",
          "genre",
          "ISBN",
          "ISSN",
          "issue",
          "jurisdiction",
          "keyword",
          "locator",
          "medium",
          "note",
          "number",
          "number-of-pages",
          "number-of-volumes",
          "original-publisher",
          "original-publisher-place",
          "original-title",
          "page",
          "page-first",
          "part",
          "part-title",
          "PMCID",
          "PMID",
          "printing",
          "publisher",
          "publisher-place",
          "references",
          "reviewed-genre",
          "reviewed-title",
          "scale",
          "section",
          "source",
          "status",
          "supplement",
          "title",
          "title-short",
          "URL",
          "version",
          "volume",
          "volume-title",
          "volume-title-short",
          "year-suffix",
        })
      end,
      ["is-synonyms-key-table"] = function(self)
        return self:get("all-keys-are-in-list", {"synonyms", "antonyms", "term"})
      end,
      ["is-shrink-specifier-key-table"] = function(self)
        return self:get("all-keys-are-in-list", {"type", "format", "quality", "resize", "result"})
      end,
      ["is-tree-node-key-table"] = function(self)
        return self:get("all-keys-are-in-list", {"pos", "children", "parent", "text", "tag", "attrs", "cdata"})
      end,
      ["is-env-var-key-table"] = function(self)
        return not find(self:get("keys"), {_r = whole(matchers.case.upper_snake._r), _invert = true}, "boolean") == nil
      end,
      ["is-menu-item-key-table"] = function(self)
        return self:get("all-keys-are-in-list", {"path", "application", "AXTitle", "AXEnabled", "AXRole", "AXMenuItemMarkChar", "AXMenuItemCmdChar", "AXMenuItemCmdModifiers", "AXMenuItemCmdGlyph"})
      end,
    },
    doThisables = {
   
    },
  },
  
  action_table = {}
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateStringKeyTable = bindArg(NewDynamicContentsComponentInterface, StringKeyTableSpecifier)
