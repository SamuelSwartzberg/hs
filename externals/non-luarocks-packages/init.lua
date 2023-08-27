local rrq = hs.fnutils.partial(relative_require, "utils.externals.non-luarocks-packages")


htmlEntities = rrq("html-entities")
url = rrq("url")