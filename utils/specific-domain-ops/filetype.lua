local filetype_list = {
  ["plaintext-table"] = {"csv", "tsv"},
  ["plaintext-dictionary"] = { "", "yaml", "json", "toml", "ini", "bib", "ics"},
  ["plaintext-tree"] = {"html", "xml", "svg", "rss", "atom"},
  ["xml"] = {"html", "xml", "svg", "rss", "atom"},
  ["image"] = {"png", "jpg", "gif", "webp", "svg"},
  ["db"] = {".db", ".dbf", ".mdb", ".accdb", ".db3", ".sdb", ".sqlite", ".sqlite3", ".nsf", ".fp7", ".fp5", ".fp3", ".fdb", ".gdb", ".dta", ".pdb", ".mde", ".adf", ".mdf", ".ldf", ".myd", ".myi", ".frm", ".ibd", ".ndf", ".db2", ".dbase", ".tps", ".dat", ".dbase3", ".dbase4", ".dbase5", ".edb", ".kdb", ".kdbx", ".sdf", ".ora", ".dbk", ".rdb", ".rpd", ".dbc", ".dbx", ".btr", ".btrieve", "db3", "s3db", "sl3", "db2", "s2db", "sqlite2", "sl2"},
  ["sql"] = {"db", "sdb", "sqlite", "db3", "s3db", "sqlite3", "sl3", "db2", "s2db", "sqlite2", "sl2", ".sql", ".mdf", ".ldf", ".ndf", ".myd", ".frm", ".ibd", ".ora", ".rdb"},
  ["possibly-sqlite"] = {"db", "sdb", "sqlite", "db3", "s3db", "sqlite3", "sl3", "db2", "s2db", "sqlite2", "sl2"},
  ["shell-script"] = { "sh", "bash", "zsh", "fish", "csh", "tcsh", "ksh", "zsh", "ash", "dash", "elvish", "ion", "nu", "oksh", "osh", "rc", "rksh", "xonsh", "yash", "zsh" },
  ["binary"] = "jpg", "jpeg", "png", "gif", "pdf", "mp3", "mp4", "mov", "avi", "zip", "gz", 
  "tar", "tgz", "rar", "7z", "dmg", "exe", "app", "pkg", "m4a", "wav", "doc", 
  "docx", "xls", "xlsx", "ppt", "pptx", "psd", "ai", "mpg", "mpeg", "flv", "swf",
  "sketch", "db", "sql", "sqlite", "sqlite3", "sqlitedb", "odt", "odp", "ods", 
  "odg", "odf", "odc", "odm", "odb", "jar", "pyc",
}


--- @param path string
--- @param filetype string
--- @return boolean
function isUsableAsFiletype(path, filetype)
  path = transf.string.path_resolved(path)
  local extension = pathSlice(path, "-1:-1", { ext_sep = true, standartize_ext = true })[1]
  if find(filetype_list[filetype], extension) then
    return true
  else
    return false
  end
end
