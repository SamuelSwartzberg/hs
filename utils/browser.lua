--- @param str string
--- @return nil
function openInBrowser(str)
  if (isUrl(str)) then
    hs.urlevent.openURL(str)
  else
    hs.urlevent.openURL("https://www.google.com/search?q=" .. urlencode(str))
  end

end


-- avaliable search engines: wiktionary, wikipedia, youtube, jisho, glottopedia, ruby apidoc, python docs, merriam webster, dict.cc, deepl en -> ja, deepl de -> en, mdn, scihub, libgen, semantic scholar

local search_engine_name_query_format_string_map = {
  wiktionary = "https://en.wiktionary.org/wiki/%s",
  wikipedia = "https://en.wikipedia.org/wiki/%s",
  youtube = "https://www.youtube.com/results?search_query=%s",
  jisho = "https://jisho.org/search/%s",
  glottopedia = "https://glottopedia.org/index.php?search=",
  ["ruby-apidoc"] = "https://apidock.com/ruby/search?query=%s",
  ["python-docs"] = "https://docs.python.org/3/search.html?q=%s",
  ["merriam-webster"] = "https://www.merriam-webster.com/dictionary/%s",
  ["dict-cc"] = "https://www.dict.cc/?s=%s",
  ["deepl-en-ja"] = "https://www.deepl.com/translator#en/ja/%s",
  ["deepl-de-en"] = "https://www.deepl.com/translator#de/en/%s",
  mdn = "https://developer.mozilla.org/en-US/search?q=%s",
  scihub = "https://sci-hub.st/%s",
  libgen = "https://libgen.rs/search.php?req=%s",
  ["semantic-scholar"] = "https://www.semanticscholar.org/search?q=%s",
  ["google-scholar"] = "https://scholar.google.com/scholar?q=%s",
  ["google-images"] = "https://www.google.com/search?tbm=isch&q=%s",
  ["google-maps"] = "https://www.google.com/maps/search/%s",
  ["danbooru"] = "https://danbooru.donmai.us/posts?tags=%s",
  ["gelbooru"] = "https://gelbooru.com/index.php?page=post&s=list&tags=%s",
}

local spaces_percent = {
  jisho = true,
  ["deepl-en-ja"] = true,
  ["deepl-de-en"] = true,
  
}

--- @param str string
--- @param search_engine string
--- @return nil
function searchWith(str, search_engine)
  local query_format_string = search_engine_name_query_format_string_map[search_engine]
  if query_format_string then
    local url = string.format(query_format_string, urlencode(str, spaces_percent[search_engine]))
    local res = hs.urlevent.openURL(url)
    if not res then
      error("Failed to open url: " .. url)
    end
  else
    error("No search engine named " .. search_engine)
  end
end

local search_engine_name_short_map = {
  wiktionary = "wkt",
  wikipedia = "wp",
  youtube = "yt",
  jisho = "ji",
  glottopedia = "gl",
  ["ruby-apidoc"] = "rb",
  ["python-docs"] = "py",
  ["merriam-webster"] = "mw",
  ["dict-cc"] = "dc",
  ["deepl-en-ja"] = "dej",
  ["deepl-de-en"] = "dde",
  ["semantic-scholar"] = "ss",
  ["google-scholar"] = "gs",
  ["google-images"] = "gi",
  ["google-maps"] = "gm",
  ["danbooru"] = "db",
  ["gelbooru"] = "gb",
}

--- @param name string
--- @return string
function getShortForm(name)
  return search_engine_name_short_map[name] or name
end