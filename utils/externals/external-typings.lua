--- @alias primitive string | number | boolean | nil | function

--- @class pl.stringx
--- @field lines fun(s: string): string[]
--- @field split fun(s: string, sep?: string, n?: integer): string[]
--- @field join fun(joiner: string, list: string[]): string
--- @field splitlines fun(s: string, keep_ends?: boolean): string[]
--- @field replace fun(s: string, old: string, new: string, n?: integer): string
--- @field shorten fun(s: string, n: integer, tail?: boolean): string

--- @class pl.file 
--- @field copy fun(src: string, dest: string, flag?: boolean): boolean flag is for overwrite
--- @field move fun(src: string, dest: string): boolean

--- @class pl.dir
--- @field copyfile fun(src: string, dest: string, flag?: boolean): boolean flag is for overwrite
--- @field movefile fun(src: string, dest: string): boolean
--- @field clonetree fun(path1: string, path2: string, file_func?: function, verbose?: boolean | function): boolean

--- @class pl.tablex
--- @field deepcopy fun(tbl: table): table
--- @field copy fun(tbl: table): table
--- @field zip fun(...: table[]): table[]

--- @class pl.array2d
--- @field column fun(a: any[][], col: integer): any[]

--- @class pl.data.read.cnfg
--- @field delim string a string pattern to split fields
--- @field fieldnames string[] (i.e. don't read from first line)
--- @field no_convert boolean (default is to try conversion on first data line)
--- @field convert table table of custom conversion functions with column keys
--- @field numfields integer indices of columns known to be numbers
--- @field last_field_collect boolean only split as many fields as fieldnames.
--- @field thousands_dot integer thousands separator in Excel CSV is '.'
--- @field csv boolean fields may be double-quoted and contain commas; Also, empty fields are considered to be equivalent to zero. 

--- @class pl.data
--- @field read fun(file: string, cnfg?: pl.data.read.cnfg): any[][]

--- @alias date_table { year: integer, month: integer|string, day: integer, hour?: number, min?: number, sec?: number}
--- @alias date_specifier number | date_table | string | boolean
--- @class date
--- @field diff fun(var_date1: dateObj, var_date2: dateObj): dateObj
--- @field epoch fun(): dateObj
--- @field getcenturyflip fun(): number
--- @field isleapyear fun(var_year: number | dateObj | date_specifier): boolean
--- @field setcenturyflip fun(var_century: number): nil
--- @field __call fun(var_date: date_specifier): dateObj

--- @class dateObj
--- @field addays fun(days: integer): dateObj
--- @field addhours fun(hours: number): dateObj
--- @field addminutes fun(minutes: number): dateObj
--- @field addmonths fun(months: integer): dateObj
--- @field addseconds fun(seconds: number): dateObj
--- @field addticks fun(ticks: number): dateObj
--- @field addyears fun(years: integer): dateObj
--- @field copy fun(): dateObj
--- @field fmt fun(self: dateObj, format: string): string
--- @field getbias fun(): unknown
--- @field getclockhour fun(): integer the hour of the day, in 12-hour clock format
--- @field getdate fun(): integer, integer, integer the day, month, and year
--- @field getday fun(): integer the day of the month
--- @field getfracs fun(): number seconds as a fraction
--- @field gethours fun(): integer the hour of the day, in 24-hour clock format
--- @field getisoweekday fun(): integer the day of the week, mon = 1, sun = 7
--- @field getisoweeknum fun(): integer the ISO week number (01 to 53)
--- @field getisoyear fun(): integer the ISO year (relates to the ISO week number)
--- @field getminutes fun(): integer the minute of the hour
--- @field getmonth fun(): integer the month of the year
--- @field getseconds fun(): integer the second of the minute
--- @field getticks fun(): number ticks after seconds value
--- @field gettime fun(): integer, integer, integer, integer the hour, minute, second, and ticks
--- @field getweekday fun(): integer the day of the week, sun = 1, sat = 7
--- @field getweeknum fun(): integer the week number
--- @field getyear fun(): integer the year
--- @field getyearday fun(): integer the day of the year
--- @field setday fun(day: integer): dateObj
--- @field sethours fun(hours?: number, minutes?: number, seconds?: number, ticks?: number): dateObj
--- @field setisoweekday fun(day?: integer): dateObj
--- @field setisoweeknum fun(week?: integer, weekday?: integer): dateObj
--- @field setisoyear fun(year?: integer, week?: integer, weekday?: integer): dateObj
--- @field setminutes fun(minutes?: number, seconds?: number, ticks?: number): dateObj
--- @field setmonth fun(month?: integer, day?: integer): dateObj
--- @field setseconds fun(seconds?: number, ticks?: number): dateObj
--- @field setticks fun(ticks?: number): dateObj
--- @field setyear fun(year?: integer, month?: integer, day?: integer): dateObj
--- @field spandays fun(var_date: dateObj): integer
--- @field spanhours fun(var_date: dateObj): number
--- @field spanminutes fun(var_date: dateObj): number
--- @field spanseconds fun(var_date: dateObj): number
--- @field spanticks fun(var_date: dateObj): number
--- @field tolocaltime fun(): dateObj
--- @field toutc fun(): dateObj

--- @class ftcsv_opts 
--- @field loadFromString boolean If you want to load a csv from a string instead of a file, set loadFromString to true (default: false)
--- @field rename { [string]: string} If you want to rename a field, you can set rename to change the field names. The following example will change the headers from a,b,c to d,e,f: `local options = {loadFromString=true, rename={["a"] = "d", ["b"] = "e", ["c"] = "f"}}`
--- @field fieldsToKeep string[] If you only want to keep certain fields from the CSV, send them in as a table-list and it should parse a little faster and use less memory.
--- @field ignoreQuotes boolean If ignoreQuotes is true, it will leave all quotes in the final parsed output. This is useful in situations where the fields aren't quoted, but contain quotes, or if the CSV didn't handle quotes correctly and you're trying to parse it.
--- @field headerFunc fun(header: string): string Applies a function to every field in the header. If you are using rename, the function is applied after the rename.
--- @field headers boolean Set headers to false if the file you are reading doesn't have any headers. This will cause ftcsv to create indexed tables rather than a key-value tables for the output.
--- @field bufferSize integer The size of the buffer to read from the file. Defaults to 2^16 bytes (which provides the fastest parsing on most unix-based systems).

--- @alias string_arr_or_table string[] | {[string]: string}

--- @class ftcsv
--- @field parse fun(csv: string, delimiter: string, options?: table): string_arr_or_table[] ftcsv.parse will load the entire csv file into memory, then parse it in one go, returning a lua table with the parsed data and a lua table containing the column headers.
--- @field parseLine fun(line: string, delimiter: string, options?: table): fun(): string_arr_or_table ftcsv.parseLine will open a file and read options.bufferSize bytes of the file. bufferSize defaults to 2^16 bytes (which provides the fastest parsing on most unix-based systems), or can be specified in the options. ftcsv.parseLine is an iterator and returns one line at a time. When all the lines in the buffer are read, it will read in another bufferSize bytes of a file and repeat the process until the entire file has been read. If specifying bufferSize there are a couple of things to remember: - bufferSize must be at least the length of the longest row. - If bufferSize is too small, an error is returned. - If bufferSize is the length of the entire file, all of it will be read and returned one line at a time (performance is roughly the same as ftcsv.parse).
--- @field encode fun(inputTable: any[][], delimiter: string, options?: table): string ftcsv.encode takes in a lua table and turns it into a text string that can be written to a file. It has two required parameters, an inputTable and a delimiter. 


--- @class lyaml
--- @field load fun(s: string): any
--- @field dump fun(t: any): string
--- @field null {}

--- @class cjson
--- @field encode fun(t: any): string
--- @field decode fun(s: string): any

--- @class tomlopts
--- @field quoteDatesAndTimes boolean Dates and times will be emitted as quoted strings.
--- @field quoteInfinitesAndNaNs boolean Infinities and NaNs will be emitted as quoted strings.,
--- @field allowLiteralStrings boolean Strings will be emitted as single-quoted literal strings where possible.,
--- @field allowMultiLineStrings boolean Strings containing newlines will be emitted as triple-quoted 'multi-line' strings where possible.,
--- @field allowRealTabsInStrings boolean Allow real tab characters in string literals (as opposed to the escaped form `\t`).,
--- @field allow_unicode_strings boolean Allow non-ASCII characters in strings (as opposed to their escaped form, e.g. `\u00DA`).
--- @field allowBinaryIntegers boolean Allow integers with `formatAsBinary` to be emitted as binary. (Not implemented yet)
--- @field allowOctalIntegers boolean Allow integers with `formatAsOctal` to be emitted as octal. (Not implemented yet)
--- @field allowHexadecimalIntegers boolean Allow integers with `formatAsHexadecimal` to be emitted as hexadecimal. (Not implemented yet)
--- @field indentSubTables boolean Apply indentation to tables nested within other tables/arrays.
--- @field indentArrayElements boolean Apply indentation to array elements when the array is forced to wrap over multiple lines.
--- @field indentation boolean Combination of `indentSubTables` and `indentArrayElements`.
--- @field relaxedFloatPrecision boolean Emit floating-point values with relaxed (human-friendly) precision.

--- @class toml
--- @field encode fun(t: any, opts?: tomlopts): string
--- @field decode fun(s: string): any
--- @field toJSON fun(s: string, opts?: tomlopts): string
--- @field toYAML fun(s: string, opts?: tomlopts): string

--- @class eutf8
--- @field byte fun(s: string, i?: integer, j?: integer): integer, ... Returns the internal numeric codes of the characters s[i], s[i+1], ..., s[j]. The default value for i is 1; the default value for j is i. These indices are corrected following the same rules of function string.sub.
--- @field char fun(byte: integer, ...: integer): string Receives zero or more integers. Returns a string with length equal to the number of arguments, in which each character has the internal numeric code equal to its corresponding argument.
--- @field find fun(s: string, pattern: string, init?: integer, plain?: boolean): integer, integer, ... Looks for the first match of pattern (see §6.4.1) in the string s. If it finds a match, then find returns the indices of s where this occurrence starts and ends; otherwise, it returns fail. A third, optional numeric argument init specifies where to start the search; its default value is 1 and can be negative. A true as a fourth, optional argument plain turns off the pattern matching facilities, so the function does a plain "find substring" operation, with no characters in pattern being considered magic. If the pattern has captures, then in a successful match the captured values are also returned, after the two indices.
--- @field gmatch fun(s: string, pattern: string): fun(): string, ... Returns an iterator function that, each time it is called, returns the next captures from pattern (see §6.4.1) over the string s. If pattern specifies no captures, then the whole match is produced in each call. A third, optional numeric argument init specifies where to start the search; its default value is 1 and can be negative.
--- @field gsub fun(s: string, pattern: string, repl: string | number | table | function, n?: integer): string, integer Returns a copy of s in which all (or the first n, if given) occurrences of the pattern (see §6.4.1) have been replaced by a replacement string specified by repl, which can be a string, a table, or a function. gsub also returns, as its second value, the total number of matches that occurred. The name gsub comes from Global SUBstitution. If repl is a string, then its value is used for replacement. The character % works as an escape character: any sequence in repl of the form %d, with d between 1 and 9, stands for the value of the d-th captured substring; the sequence %0 stands for the whole match; the sequence %% stands for a single %. If repl is a table, then the table is queried for every match, using the first capture as the key. If repl is a function, then this function is called every time a match occurs, with all captured substrings passed as arguments, in order. In any case, if the pattern specifies no captures, then it behaves as if the whole pattern was inside a capture. If the value returned by the table query or by the function call is a string or a number, then it is used as the replacement string; otherwise, if it is false or nil, then there is no replacement (that is, the original match is kept in the string).
--- @field len fun(s: string): integer
--- @field lower fun(s: string): string
--- @field match fun(s: string, pattern: string, init?: integer): ... Looks for the first match of the pattern (see §6.4.1) in the string s. If it finds one, then match returns the captures from the pattern; otherwise it returns fail. If pattern specifies no captures, then the whole match is returned. A third, optional numeric argument init specifies where to start the search; its default value is 1 and can be negative.
--- @field sub fun(s: string, i: integer, j?: integer): string Returns the substring of s that starts at i and continues until j; i and j can be negative. If j is absent, then it is assumed to be equal to -1 (which is the same as the string length). In particular, the call string.sub(s,1,j) returns a prefix of s with length j, and string.sub(s, -i) (for a positive i) returns a suffix of s with length i.
--- @field upper fun(s: string): string
--- @field reverse fun(s: string): string

--- @class stringy Fast string manipulation library for Lua written in C. Typically only supports strings, not patterns
--- @field count fun(s: string, substr: string): integer count number of occurences of a substring in a string
--- @field find fun(s: string, substr: string): integer
--- @field endswith fun(s: string, substr: string): boolean
--- @field startswith fun(s: string, substr: string): boolean
--- @field split fun(s: string, sep: string): string[] split a string by a separator
--- @field strip fun(s: string): string

--- @class basexx
--- @field from_bit fun(s: string): string get normal string from bitfield representation
--- @field to_bit fun(s: string): string get bitfield representation from normal string
--- @field from_hex fun(s: string): string get normal string from hex representation
--- @field to_hex fun(s: string): string get hex representation from normal string
--- @field from_base32 fun(s: string): string get normal string from base32 representation
--- @field to_base32 fun(s: string): string get base32 representation from normal string
--- @field from_crockford fun(s: string): string get normal string from crockford base32 representation
--- @field to_crockford fun(s: string): string get crockford base32 representation from normal string
--- @field from_base64 fun(s: string): string get normal string from base64 representation
--- @field to_base64 fun(s: string): string get base64 representation from normal string
--- @field from_url64 fun(s: string): string get normal string from urlsafe base64 representation
--- @field to_url64 fun(s: string): string get urlsafe base64 representation from normal string
--- @field from_z85 fun(s: string): string get normal string from z85 representation
--- @field to_z85 fun(s: string): string get z85 representation from normal strin|

--- @generic F
--- @alias memoize fun(f: F): F

--- @class mimetypes
--- @field guess fun(filename: string): string

--- @alias resolve fun(value: any): nil
--- @alias reject fun(reason: any): nil
--- @alias promisefn fun(resolve: resolve, reject: reject): nil


--- @class PromiseObj
--- @field thenCall fun(self: PromiseObj, onFulfilled: fun(value: any): (any), onRejected?: fun(reason: any): any): PromiseObj thenCall instead of then since then is a reserved word in lua
--- @field catch fun(self: PromiseObj, onRejected: fun(reason: any): any): PromiseObj
--- @field finally fun(self: PromiseObj, onFinally: fun(): any): PromiseObj


--- @class promiselib Promise library for Lua, like ES6 promises
--- @field new fun(fn: promisefn): PromiseObj
--- @field resolve fun(value: any): PromiseObj
--- @field reject fun(reason: any): PromiseObj
--- @field race fun(promises: PromiseObj[]): PromiseObj
--- @field all fun(promises: PromiseObj[]): PromiseObj
--- @field serial fun(promiseFuncs: promisefn[]): PromiseObj do promises serially


--- @alias inspect_options { depth: integer, newline: string, indent: string, process: fun(item: any, path: any[]): any }

--- @class hashingsobj
--- @field hexdigest fun(self: hashingsobj): string
--- @field digest fun(self: hashingsobj): string
--- @field update fun(self: hashingsobj, data: string): nil
--- @field copy fun(self: hashingsobj): hashingsobj
--- @field new fun(self: hashingsobj, data: string): hashingsobj


--- @alias hashings fun(type: "adler32" | "blake2b" | "blake2s" | "crc32" | "md5" | "ripemd160" | "sha1" | "sha256" | "sha3_256" | "sha3_512" | "sha512" | "whirlpool"): hashingsobj

--- @class hs
--- @field pasteboard hs.pasteboard
--- @field sound hs.sound
--- @field ipc hs.ipc
--- @field logger hs.logger
--- @field reload fun(): nil
--- @field inspect fun(value: any, options?: inspect_options): string
--- @field alert hs.alert
--- @field timer hs.timer
--- @field fs hs.fs
--- @field application hs.application
--- @field eventtap hs.eventtap
--- @field execute fun(command: string, with_user_env?: boolean): output: string, status: boolean, type: "exit" | "signal", rc: integer
--- @field styledtext hs.styledtext
--- @field image hs.image
--- @field chooser hs.chooser
--- @field task hs.task
--- @field geometry hs.geometry
--- @field drawing hs.drawing
--- @field screen hs.screen
--- @field window hs.window
--- @field urlevent hs.urlevent
--- @field hotkey hs.hotkey
--- @field dialog hs.dialog
--- @field axuielement hs.axuielement
--- @field osascript hs.osascript
--- @field audiodevice hs.audiodevice
--- @field keycodes hs.keycodes
--- @field host hs.host
--- @field mouse hs.mouse
--- @field http hs.http
--- @field fnutils hs.fnutils
--- @field httpserver hs.httpserver
--- @field settings hs.settings
--- @field hash hs.hash
--- @field math hs.math
--- @field speech hs.speech


--- @alias urltable { url: string }

--- @alias pasteboard_object string | hs.styledtext | hs.sound | hs.image | urltable | hs.drawing.color

--- @class hs.pasteboard
--- @field watcher hs.pasteboard_watcher
--- @field setContents fun(contents: string, name?:string): boolean
--- @field readString fun(name?: string, all?:boolean): string
--- @field writeObjects fun(objects: pasteboard_object | pasteboard_object[], name?: string): boolean

--- @class hs.pasteboard_watcher

--- @class hs.audiodevice

--- @class hs.http
--- @field asyncGet fun(url: string, headers?: {[string]: any}, callback: fun(status: integer, body: string, headers: {[string]: any}): nil): nil
--- @field asyncPost fun(url: string, body: string, headers?: {[string]: any}, callback: fun(status: integer, body: string, headers: {[string]: any}): nil): nil
--- @field asyncPut fun(url: string, body: string, headers?: {[string]: any}, callback: fun(status: integer, body: string, headers: {[string]: any}): nil): nil
--- @field get fun(url: string, headers?: {[string]: any}): integer, string, {[string]: any}
--- @field post fun(url: string, body: string, headers?: {[string]: any}): integer, string, {[string]: any}
--- @field put fun(url: string, body: string, headers?: {[string]: any}): integer, string, {[string]: any}

--- @class hs.httpserver

--- @class hs.fnutils

--- @class hs.settings

--- @class hs.sound

--- @class hs.hash

--- @class hs.math

--- @class hs.speech
--- @field new fun(voice?: string): hs.speech
--- @field availableVoices fun(full?: boolean): string[]
--- @field continue fun(self: hs.speech): hs.speech
--- @field pause fun(self: hs.speech, where?: "immediate" | "word" | "sentence"): hs.speech
--- @field stop fun(self: hs.speech, where?: "immediate" | "word" | "sentence"): hs.speech
--- @field isSpeaking fun(self: hs.speech): boolean | nil
--- @field isPuased fun(self: hs.speech): boolean | nil
--- @field modulation fun(self: hs.speech, modulation: number): hs.speech
--- @field phonemes fun(self: hs.speech, text: string): string
--- @field rate fun(self: hs.speech, rate: number): hs.speech
--- @field pitch fun(self: hs.speech, pitch: number): hs.speech
--- @field reset fun(self: hs.speech): hs.speech
--- @field speak fun(self: hs.speech, text: string): hs.speech
--- @field speakToFile fun(self: hs.speech, text: string, path: string): hs.speech
--- @field volume fun(self: hs.speech, volume: number): hs.speech
--- @field voice (fun(self: hs.speech, voice: string): hs.speech) | (fun(self: hs.speech, full?: boolean): string)

speak = hs.speech.new()

--- @class hs.ipc
--- @field cliInstall fun(path: string, silent?: boolean): boolean

--- @alias loglevel_str "verbose" | "debug" | "info" | "warning" | "error" | "nothing"
--- @alias loglevel_int 0 | 1 | 2 | 3 | 4 | 5
--- @alias loglevel loglevel_str | loglevel_int
--- @alias log_history_entry {time: integer, level: loglevel_int, id: string, message: string}
--- @class hs.logger Despite what you would expect, things that should be object methods are actually class methods here
--- @field new fun(id: string, level?: loglevel): hs.logger
--- @field defaultLogLevel loglevel
--- @field history fun(): log_history_entry[]
--- @field historySize fun(size?: integer): integer Sets or gets the global log history size
--- @field printHistory fun(entries?: integer, level?: loglevel, filter?: string, caseSensitive?: boolean): nil
--- @field setGlobalLogLevel fun(level: loglevel): nil
--- @field setModulesLogLevel fun(level: loglevel): nil
--- @field setLogLevel fun(level: loglevel): nil
--- @field getLogLevel fun(): loglevel_int
--- @field d fun(...: any): nil log at debug level
--- @field df fun (format: string, ...: any): nil log at debug level using format string
--- @field e fun(...: any): nil log at error level
--- @field ef fun (format: string, ...: any): nil log at error level using format string
--- @field f fun (format: string, ...: any): nil log at info level using format string (not if, as one might expect)
--- @field i fun(...: any): nil log at info level
--- @field v fun(...: any): nil log at verbose level
--- @field vf fun (format: string, ...: any): nil log at verbose level using format string
--- @field w fun(...: any): nil log at warning level
--- @field wf fun (format: string, ...: any): nil log at warning level using format string

--- @alias alertfunc fun(message: string | hs.styledtext, style: table, screen: hs.screen, seconds: any): (string)  |  fun(message: string | hs.styledtext, style: table, seconds: any): (string) | fun(message: string | hs.styledtext, seconds: any): (string) | fun(message: string | hs.styledtext, style: table, screen: hs.screen): (string) | fun(message: string | hs.styledtext, screen: hs.screen, seconds: any): (string) | fun(message: string | hs.styledtext, screen: hs.screen): (string) | fun(message: string | hs.styledtext, style: table): (string) | fun(message: string | hs.styledtext): (string)

--- @class hs.alert
--- @field show alertfunc if seconds is not a number, show indefinitely
--- @field closeSpecific fun(uuid: string, fade_out_duration?: number): nil

--- @class hs.timer
--- @field new fun(interval: integer, fn: fun(): (nil), continueOnError?: boolean): hs.timer
--- @field doAfter fun(interval: integer, fn: fun(): nil): hs.timer
--- @field doEvery fun(interval: integer, fn: fun(): nil): hs.timer
--- @field doWhile fun(predicateFn: fun(): (boolean), actionFn: fun(timer: hs.timer): (nil), interval: integer): hs.timer
--- @field start fun(self: hs.timer): hs.timer
--- @field stop fun(self: hs.timer): hs.timer

--- @class hs.styledtext
--- @field new fun(text: string, attributes?: table): hs.styledtext
--- @field __concat fun(self: hs.styledtext|string, other: hs.styledtext|string): hs.styledtext|string
--- @field __len fun(self: hs.styledtext): integer
--- @field __eq fun(self: hs.styledtext, other: hs.styledtext): boolean
--- @field __lt fun(self: hs.styledtext, other: hs.styledtext|string): boolean
--- @field __le fun(self: hs.styledtext, other: hs.styledtext|string): boolean
--- @field byte fun(s: string, i?: integer, j?: integer): integer, ... Returns the internal numeric codes of the characters s[i], s[i+1], ..., s[j]. The default value for i is 1; the default value for j is i. These indices are corrected following the same rules of function string.sub.
--- @field find fun(s: string, pattern: string, init?: integer, plain?: boolean): integer, integer, ... Looks for the first match of pattern (see §6.4.1) in the string s. If it finds a match, then find returns the indices of s where this occurrence starts and ends; otherwise, it returns fail. A third, optional numeric argument init specifies where to start the search; its default value is 1 and can be negative. A true as a fourth, optional argument plain turns off the pattern matching facilities, so the function does a plain "find substring" operation, with no characters in pattern being considered magic. If the pattern has captures, then in a successful match the captured values are also returned, after the two indices.
--- @field gmatch fun(s: string, pattern: string): fun(): string, ... Returns an iterator function that, each time it is called, returns the next captures from pattern (see §6.4.1) over the string s. If pattern specifies no captures, then the whole match is produced in each call. A third, optional numeric argument init specifies where to start the search; its default value is 1 and can be negative.
--- @field len fun(s: string): integer
--- @field lower fun(s: string): string
--- @field match fun(s: string, pattern: string, init?: integer): ... Looks for the first match of the pattern (see §6.4.1) in the string s. If it finds one, then match returns the captures from the pattern; otherwise it returns fail. If pattern specifies no captures, then the whole match is returned. A third, optional numeric argument init specifies where to start the search; its default value is 1 and can be negative.
--- @field sub fun(s: string, i: integer, j?: integer): string Returns the substring of s that starts at i and continues until j; i and j can be negative. If j is absent, then it is assumed to be equal to -1 (which is the same as the string length). In particular, the call string.sub(s,1,j) returns a prefix of s with length j, and string.sub(s, -i) (for a positive i) returns a suffix of s with length i.
--- @field upper fun(s: string): string
--- @field rep fun(s: string, n: integer): string Returns a string that is the concatenation of n copies of the string s.
--- @field asTable fun(self: hs.styledtext, starts?: integer, ends?: integer): table
--- @field setStyle fun(self: hs.styledtext, attributes: table, starts?: integer, ends?: integer, clear?: boolean): hs.styledtext

--- @class hs.screen
--- @field allScreens fun(): hs.screen[]
--- @field mainScreen fun(): hs.screen
--- @field primaryScreen fun(): hs.screen
--- @field frame fun(self: hs.screen): hs.geometry.rect
--- @field fullFrame fun(self: hs.screen): hs.geometry.rect

--- @class hs.drawing
--- @field color hs.drawing.color

--- @class hs.urlevent
--- @field openURL fun(url: string): boolean

--- @class hs.window
--- @field filter hs.window.filter
--- @field find fun(hint: string | number): hs.window


--- @alias window_sort_option "created" | "focused" | "focusedLast" | "focusedMostRecent

--- @class hs.window.filter
--- @field default hs.window.filter
--- @field sortByCreated "created"
--- @field sortByFocused "focused"
--- @field sortByFocusedLast "focusedLast"
--- @field sortByFocusedMostRecent "focusedMostRecent"
--- @field getWindows fun(self: hs.window.filter, sort?: window_sort_option): hs.window[]
--- @field new fun(fn: nil | boolean | string | string[] | table | fun(window: hs.window): (boolean), logname?: string, loglevel?: loglevel): hs.window.filter
--- @field setAppFilter fun(self: hs.window.filter, appname: string, filter?: boolean | nil | table): hs.window.filter

--- @class hs.axuielement
--- @field windowElement fun(window: hs.window): hs.axuielement

--- @class hs.osascript
--- @field javascript fun(source: string): boolean, any, string
--- @field applescript fun(source: string): boolean, any, string

--- @alias alert_style "informational" | "warning" | "critical"

--- @class hs.dialog
--- @field blockAlert fun(message: string, informativeText: string, buttonOne?: string, buttonTwo?: string, style?: alert_style): string
--- @field textPrompt fun(message: string, informativeText: string, defaultText?: string, buttonOne?: string, buttonTwo?: string, secureField?: boolean): button_value: string, text_input_value: string
--- @field chooseFileOrFolder fun(message?: string, defaultPath?: string, canChooseFiles?: boolean, canChooseDirectories?: boolean, allowsMultipleSelection?: boolean, allowedFileTypes?: string[], resolvesAliases?: boolean): {[string]: string} return value has integer keys as strings, so e.g. ["1"] is the first file chosen. No idea why.

--- @alias modifier "fn" | "ctrl" | "alt" | "cmd" | "shift"

--- @alias hs_hotkey_newfn_no_message fun(mods: modifier[], key: string, pressedfn?: fun(), releasedfn?: fun(), repeatfn?: fun()): hs.hotkey | nil
--- @alias hs_hotkey_newfn_with_message fun(mods: modifier[], key: string, message?: string, pressedfn?: fun(), releasedfn?: fun(), repeatfn?: fun()): hs.hotkey | nil
--- @alias hs_hotkey_newfn hs_hotkey_newfn_no_message | hs_hotkey_newfn_with_message

--- @class hs.hotkey
--- @field bind hs_hotkey_newfn
--- @field new hs_hotkey_newfn
--- @field delete fun(self: hs.hotkey): nil
--- @field enable fun(self: hs.hotkey): hs.hotkey | nil
--- @field disable fun(self: hs.hotkey): hs.hotkey

--- @alias rgba_color { red: number, green: number, blue: number, alpha: number }
--- @alias hsba_color { hue: number, saturation: number, brightness: number, alpha: number }
--- @alias greyscale_color { white: number, alpha: number }
--- @alias listed_color { list: string, name: string}
--- @alias hex_color_table { hex: string, alpha: number }
--- @alias image_color { image: hs.image }

--- @alias hs.drawing.color
---| rgba_color
---| hsba_color
---| greyscale_color
---| listed_color
---| hex_color_table
---| image_color

--- @alias chooser_item { text: string | hs.styledtext, subText?: string, valid?: boolean, image?: hs.image, [string]: any }
--- @alias completion_fn fun(chosen: chooser_item | nil): nil


--- @class hs.chooser
--- @field new fun(completion_fn: completion_fn): hs.chooser
--- @field show fun(self: hs.chooser, topLeftPoint?: hs.geometry): hs.chooser
--- @field selectedRow fun(self: hs.chooser, row?: integer): hs.chooser | integer
--- @field choices fun(self: hs.chooser, choices: chooser_item[] | fun(...): chooser_item[]): hs.chooser | chooser_item[]
--- @field rows fun(self: hs.chooser, rows?: integer): hs.chooser | integer

--- @alias and_then fun(exit_code?: number, std_out?: string, std_err?: string): nil
--- @alias stream_callback fun(task?: hs.task, std_out?: string, std_err?: string): boolean

--- @class hs.task
--- @field new fun(launchPath: string, terminationCallbackFn: and_then, streamCallbackFn?: stream_callback, arguments?: string[]): hs.task
--- @field start fun(self: hs.task): nil

--- @class hs.image
--- @field imageFromPath fun(path: string): hs.image
--- @field imageFromASCII fun(ascii: string, context?: table): hs.image
--- @field imageFromAppBundle fun(appBundlePath: string): hs.image

--- @alias fs_attributes { dev: number, ino: number, mode:string, nlink: number, uid: number, gid: number, rdev: number, access: number, change: number, modification: number, permissions: string, creation: number, size: number, blocks: number, blksize: number }


--- @alias hs_geometry_point_table { x: number, y: number }
--- @alias hs_geometry_size_table { w: number, h: number }
--- @alias hs_geometry_rect_table { x: number, y: number, w: number, h: number }
--- @alias hs_geometry_point_like hs_geometry_point_table | hs.geometry.point
--- @alias hs_geometry_size_like hs_geometry_size_table | hs.geometry.size
--- @alias hs_geometry_rect_like hs_geometry_rect_table | hs.geometry.rect

--- @alias coords_table { x1: number, y1: number, x2: number, y2: number }

--- @alias hs_geometry_table hs_geometry_point_table | hs_geometry_size_table | hs_geometry_rect_table

--- @alias hs_geometry_like hs_geometry_point_like | hs_geometry_size_like | hs_geometry_rect_like

--- @alias hs_geometry_point_constructor fun(x: number, y: number): hs.geometry.point
--- @alias hs_geometry_size_constructor fun(x: nil, y: nil, w: number, h: number): hs.geometry.size
--- @alias hs_geometry_rect_constructor fun(x: number, y: number, w: number, h: number): hs.geometry.rect
--- @alias hs_geometry_list_constructor fun(list: number[]): hs.geometry must be either {x, y} or {x, y, w, h}
--- @alias hs_geometry_point_table_constructor fun(table: hs_geometry_point_table): hs.geometry.point
--- @alias hs_geometry_size_table_constructor fun(table: hs_geometry_size_table): hs.geometry.size
--- @alias hs_geometry_rect_table_constructor fun(table: hs_geometry_rect_table): hs.geometry.rect
--- @alias hs_geometry_coord_table_constructor fun(table: coords_table): hs.geometry.rect
--- @alias hs_geometry_string_constructor fun(string: string): hs.geometry
--- @alias hs_geometry_constructor hs_geometry_point_constructor | hs_geometry_size_constructor | hs_geometry_rect_constructor | hs_geometry_list_constructor | hs_geometry_point_table_constructor | hs_geometry_size_table_constructor | hs_geometry_rect_table_constructor | hs_geometry_coord_table_constructor | hs_geometry_string_constructor

--- a vector2 is a hs.geometry.point that represents a vector in 2D space from the origin

--- @class hs.geometry
--- @field point fun(x: number, y: number): hs.geometry.point
--- @field size fun(w: number, h: number): hs.geometry.size
--- @field rect fun(x: number, y: number, w: number, h: number): hs.geometry.rect
--- @field copy fun(self: hs.geometry): hs.geometry
--- @field new hs_geometry_constructor
--- @field string string The `"X,Y/WxH"` string for this hs.geometry object (*reduced precision*); useful e.g. for logging
--- @field angle fun(self: hs.geometry): number Returns the angle between the positive x axis and this vector2
--- @field angleTo fun(self: hs.geometry, other: hs.geometry): number Returns the angle between the positive x axis and the vector connecting this point or rect's center to another point or rect's center
--- @field equals fun(self: hs.geometry, other: hs_geometry_like): boolean true if this hs.geometry object perfectly overlaps other, false otherwise
--- @field floor fun(self: hs.geometry): hs.geometry Truncates all coordinates in this object to integers
--- @field scale fun(self: hs.geometry, size: hs.geometry): hs.geometry Scales this vector2/size, or this rect *keeping its center constant* by `size` - an hs.geometry object, or a table or string or parameter list to construct one, indicating the factors for scaling this rect's width and height; if a number, the rect will be scaled by the same factor in both axes

--- @class hs.geometry.sizeandrect : hs.geometry
--- @field w number
--- @field h number
--- @field area number
--- @field aspect number
--- @field length number A number representing the length of the diagonal of this rect, or the length of this vector2; changing it will scale the rect/vector - see `hs.geometry:scale()`
--- @field wh hs.geometry.size


--- @class hs.geometry.point : hs.geometry
--- @field x number
--- @field y number
--- @field xy hs.geometry.point
--- @field table hs_geometry_point_table
--- @field type fun(): "point"
--- @field distance fun(self: hs.geometry.point | hs.geometry.rect, other: hs_geometry_point_like | hs_geometry_rect_like): number Finds the distance between this point or rect's center and another point or rect's center
--- @field move fun(self: hs.geometry.point, point: hs_geometry_point_like): hs.geometry.point Moves this point by the given point
--- @field rotateCCW fun(self: hs.geometry.point, other: hs.geometry.point, ntimes: number): hs.geometry.point Rotates a point around another point N times counter-clockwise
--- @field vector fun(self: hs.geometry.point, other: hs_geometry_point_like | hs_geometry_rect_like): hs.geometry.point Returns the vector2 from this point to another point or rect's center

--- @class hs.geometry.size : hs.geometry.sizeandrect
--- @field table hs_geometry_size_table
--- @field type fun(): "size"

--- @class hs.geometry.rect : hs.geometry.sizeandrect
--- @field x number
--- @field y number
--- @field table hs_geometry_rect_table
--- @field center hs.geometry.point
--- @field bottomright hs.geometry.point
--- @field topleft hs.geometry.point
--- @field xy hs.geometry.point
--- @field x1 number
--- @field y1 number
--- @field x2 number
--- @field y2 number
--- @field x2y2 hs.geometry.point
--- @field type fun(): "rect"
--- @field union fun(self: hs.geometry.rect, other: hs_geometry_rect_like): hs.geometry.rect Returns the smallest rect that encloses both this rect and another rect
--- @field intersection fun(self: hs.geometry.rect, other: hs_geometry_rect_like): hs.geometry.rect Returns the intersection rect between this rect and another rect
--- @field bounds fun(self: hs.geometry.rect, other: hs_geometry_rect_like): hs.geometry.rect Ensure this rect is fully inside `bounds`, by scaling it down if it's larger (preserving its aspect ratio) and moving it if necessary
--- @field inside fun(self: hs.geometry.rect, other: hs_geometry_rect_like): boolean Returns true if this rect is fully inside another rect
--- @field move fun(self: hs.geometry.rect, point: hs_geometry_point_like): hs.geometry.rect Moves this rect by the given point
--- @field vector fun(self: hs.geometry.rect, other: hs_geometry_point_like | hs_geometry_rect_like): hs.geometry.point Returns the vector2 from this rect's center to another point or rect's center

--- @class hs.fs
--- @field volume hs.fs.volume
--- @field attributes fun(path: string, aName: string): (string) |  fun(path: string): fs_attributes
--- @field mkdir fun(dirname: string): boolean
--- @field rmdir fun(dirname: string): true | nil, err: string | nil
--- @field chdir fun(path: string): true | nil, err: string | nil
--- @field dir fun(path): function, table, nil, table
--- @field touch fun(filepath: string, atime?: number, mtime?: number): boolean | nil, err: string | nil

--- @class hs.fs.volume
--- @field didMount 0
--- @field didUnmount 1
--- @field willUnmount 2
--- @field didRename 3
--- @field allVolumes fun(showHidden?: boolean): {[string]:table}
--- @field eject fun(path: string): boolean | nil, err: string | nil

--- @class hs.application
--- @field frontmostApplication fun(): hs.application
--- @field find fun(hint: string | number): hs.application
--- @field get fun(name: string | number): hs.application
--- @field open fun(app: string | number): hs.application
--- @field launchOrFocus fun(name: string): boolean
--- @field getMenuItems fun(): {[string]: table}
--- @field activate fun(allWindows?: boolean): boolean

--- @class hs.eventtap
--- @field keyStroke fun(modifiers: modifier[], character: string, delay?: integer, application?: hs.application): nil
--- @field keyStrokes fun(text: string, application?: hs.application): nil
--- @field scrollWheel fun(offsets: integer[], modifiers?: modifier[], unit?: "line" | "pixel"): nil

--- @class hs.keycodes
--- @field currentSourceID fun(sourceID: string): (boolean) | fun(): string

--- @class hs.host
--- @field localizedName fun(): string

--- @class hs.mouse
--- @field absolutePosition fun(): (hs.geometry.point) | fun(point: hs_geometry_point_like): hs.geometry.point 