is = {
  string = {
    package_manager = function(str)
      return find(lines(
        memoize(run)("upkg list-package-managers")
      ), {_exactly = str})
    end,
  }
}