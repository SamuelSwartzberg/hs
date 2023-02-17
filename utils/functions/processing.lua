

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