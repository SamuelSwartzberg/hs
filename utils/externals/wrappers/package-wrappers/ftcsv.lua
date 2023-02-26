
--- Wrapper to solve https://github.com/FourierTransformer/ftcsv/issues/28
--- @type fun(line: string, delimiter: string, options?: table): fun(): string_arr_or_table 
function ftcsvParseLine(line, delimiter, options)
  if options and not options.bufferSize then options.bufferSize = 2^16 end
  return ftcsv.parseLine(line, delimiter, options)
end