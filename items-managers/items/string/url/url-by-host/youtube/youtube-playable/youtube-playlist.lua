--- @type ItemSpecifier
YoutubePlaylistItemSpecifier = {
  type = "youtube-playlist",
  properties = {
    getables = {
      ["playlist-attr"] = function(self, attr)
        return run(
          {
            "youtube-dl -no-warnings",
            "--dump-single-json",
            transf.string.single_quoted_escaped(self:get("c")),
            "|",
            "jq",
            "-r",
            transf.string.single_quoted_escaped("." .. attr),
          }
        )
      end,
      ["all-attrs"] = function(self, attr)
        self:get("attr-inner", attr) -- attr-inner gets all values for a playlist
      end,
      ["single-attr"] = function(self, attr)
        self:get("playlist-attr", attr) 
      end,
      ["playlist-id"] = function(self)
        return self:get("url-query"):match("list=([^&]+)")
      end,
    },
  
    doThisables = {
    }
  },
  action_table = {}
}