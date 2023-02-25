--- @param doi string
--- @return string
function getBibtexFromDoi(doi)
  return run({
    "curl",
    "-LH",
    "Accept: application/x-bibtex",
    {
      value = toResolvedDoi(doi),
      type = "quoted"
    }
  })
end

--- @param isbn string
--- @return string
function getBibtexFromIsbn(isbn)
  return run({
    "isbn_meta",
    {
      value = isbn,
      type = "quoted"
    },
    "bibtex"
  })
end

--- @param bibtex string
--- @return string
function convertBibtexToRawJson(bibtex)
  return run({
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
end

--- @param bibtex string
--- @return table
function convertBibtexToTable(bibtex)
  return json.decode(convertBibtexToRawJson(bibtex))
end
