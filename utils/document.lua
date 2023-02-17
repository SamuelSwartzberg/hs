--- @param doi string
--- @return string
function getBibtexFromDoi(doi)
  local res = getOutputTask({
    "curl",
    "-LH",
    "Accept: application/x-bibtex",
    {
      value = toResolvedDoi(doi),
      type = "quoted"
    }
  })
  return res
end

--- @param isbn string
--- @return string
function getBibtexFromIsbn(isbn)
  local res = getOutputTask({
    "isbn_meta",
    {
      value = isbn,
      type = "quoted"
    },
    "bibtex"
  })
  return res
end

--- @param bibtex string
--- @return string
function convertBibtexToRawJson(bibtex)
  local res = getOutputTask({
    "echo",
    "-n",
    {
      value = bibtex,
      type = "quoted"
    },
    "|",
    "pandoc",
    "-f",
    "bibtex",
    "-t",
    "csljson"
  })
  return res
end

--- @param bibtex string
--- @return table
function convertBibtexToTable(bibtex)
  return json.decode(convertBibtexToRawJson(bibtex))
end
