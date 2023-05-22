global_store = nil

--- @class BenchmarkSpecifier
--- @field funcs benchspec[]
--- @field iterations number

--- @alias benchspec { name?: string, func: function, args?: any[] }

--- @param specifier BenchmarkSpecifier | benchspec
--- @return nil
function benchmarkFunctions(specifier, args, iters)
  if not specifier.funcs then
    specifier = { funcs = specifier }
  end
  specifier.iterations = specifier.iterations or iters or 100
  for _, func_specifier in ipairs(specifier.funcs) do
    local start = os.clock()
    if type(func_specifier) == "function" then
      func_specifier = { func = func_specifier }
    elseif isList(func_specifier) then
      func_specifier = {
        func = func_specifier[1],
        name = func_specifier[2],
        args = func_specifier[3],
      }
    end
    local func = func_specifier.func
    for i = 1, specifier.iterations do
      if func_specifier.args then
        global_store = func(returnUnpackIfTable(func_specifier.args))
      elseif args then
        global_store = func(returnUnpackIfTable(args))
      else
        global_store = func()
      end
    end
    local stop = os.clock()
    local elapsed = stop - start
    local res = string.format(
      "Benchmarked %s at %s iterations, took %s seconds",
      (func_specifier.name or "unnamed"), specifier.iterations, elapsed
    )
    print(res)
  end
end

--- @param func function
--- @param args any[]
--- @param iterations number
--- @param acc "inline" | "var"
--- @param memoopts memoOpts
function benchmarkMemoization(func, args, iterations, acc, memoopts)
  local mmzd
  if acc == "var" then
    mmzd = memoize(func, memoopts)
  else
    mmzd = function (...)
      return memoize(func, memoopts)(...)
    end
  end
  benchmarkFunctions({
    funcs = {
      {
        name = "memoized",
        func = mmzd,
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

function expensiveFunction(n)
  n = n * 5000 -- so we can use small values of n to test
  local sum = 0
  for i=1, n do
    for j=1, n do
      sum = sum + i*j
    end
  end
  return sum
end