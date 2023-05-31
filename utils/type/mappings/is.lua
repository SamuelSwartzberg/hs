is = {
  string = {
    package_manager = function(str)
      return find(lines(
        memoize(run)("upkg list-package-managers")
      ), {_exactly = str})
    end,
  },
  uuid = {
    contact = function(uuid)
      local succ, res = pcall(transf.uuid.raw_contact, uuid)
      return succ 
    end,
  }
}