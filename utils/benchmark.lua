global_store = nil

--- @class BenchmarkSpecifier
--- @field funcs { name: string, func: function, args: any[] }[]
--- @field iterations number

--- @param specifier BenchmarkSpecifier
--- @return nil
function benchmarkFunctions(specifier)
  for _, func_specifier in ipairs(specifier.funcs) do
    local start = os.clock()
    local func = func_specifier.func
    for i = 1, specifier.iterations do
      global_store = func(table.unpack(func_specifier.args))
    end
    local stop = os.clock()
    local elapsed = stop - start
    local res = string.format(
      "Benchmarked %s at %s iterations, took %s seconds",
      func_specifier.name, specifier.iterations, elapsed
    )
    print(res)
  end
end

--- @param func function
--- @param args any[]
--- @param iterations number
function benchmarkMemoization(func, args, iterations)
  local memoized = memoize(func)
  benchmarkFunctions({
    funcs = {
      {
        name = "memoized",
        func = memoized,
        args = args,
      },
      {
        name = "unmemoized",
        func = func,
        args = args,
      },
    },
    iterations = iterations,
  })
end