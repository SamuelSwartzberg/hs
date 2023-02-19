--- @type pl.stringx
stringx = require("pl.stringx")
--- @type pl.dir
dir = require("pl.dir")
--- @type pl.file
file = require("pl.file")
--- @type pl.tablex
tablex = require("pl.tablex")
--- @type pl.array2d
array2d = require("pl.array2d")
--- @type pl.data 
data = require("pl.data")
--- @type ftcsv
ftcsv = require('ftcsv')
--- @type date
date = require("date")
curl = require("cURL")
--- @type lyaml
yaml = require("lyaml")
--- @type cjson
json = require("cjson")
--- @type toml
toml = require("toml")
oldutf8 = utf8
--- @type eutf8
eutf8 = require 'lua-utf8'
onig = require("rex_onig") -- oniguruma regex engine. Not faster than lua's built in regex engine, but has more features, and can deal with unicode.
--- @type stringy
stringy = require("stringy")
xml = require "xmllpegparser"
--- @type basexx
basexx = require("basexx")
--- @type memoize
memoize = require 'memoize'
--- @type mimetypes
mimetypes = require "mimetypes"
combine = require "combine"

--- @type hashings 
hashings = require("hashings")

--- @type promiselib | fun(fn: promisefn): PromiseObj
Promise = require 'promise'