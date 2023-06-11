--- @alias relay_table { [string]: { [string]: string[] } }


transf = {
  hex = { -- a hex string
    char = function(hex)
      return string.char(tonumber(hex, 16))
    end,
    indicated_hex_string = function(hex)
      return "0x" .. hex
    end,
    utf8_unicode_prop_table = function(hex)
      return memoize(runJSON)("uni print -compact -format=all -as=json".. transf.string.single_quoted_escaped("utf8:" .. tostring(hex)))[1]
    end,
    unicode_codepoint = function(hex)
      return "U+" .. hex
    end,
  },
  percent = {
    char = function(percent)
      local num = percent:sub(2, 3)
      return string.char(tonumber(num, 16))
    end,
  },
  unicode_codepoint = { -- U+X...
    number = function(codepoint)
      return tonumber(codepoint:sub(3), 16)
    end,
    unicode_prop_table = function(codepoint)
      return memoize(runJSON)("uni print -compact -format=all -as=json".. transf.string.single_quoted_escaped(codepoint))[1]
    end
  },
  number = {
    decimal_string = function(num)
      return tostring(num)
    end,
    indicated_decimal_string = function(num)
      return "0d" .. transf.number.decimal_string(num)
    end,
    hex_string = function(num)
      return string.format("%X", num)
    end,
    indicated_hex_string = function(num)
      return "0x" .. transf.number.hex_string(num)
    end,
    unicode_codepoint = function(num)
      return "U+" .. transf.number.hex_string(num)
    end,
    octal_string = function(num)
      return string.format("%o", num)
    end,
    indicated_octal_string = function(num)
      return "0o" .. transf.number.octal_string(num)
    end,
    binary_string = function(num)
      return string.format("%b", num)
    end,
    indicated_binary_string = function(num)
      return "0b" .. transf.number.binary_string(num)
    end,
    unicode_prop_table = function(num)
      return transf.unicode_codepoint.unicode_prop_table(transf.number.unicode_codepoint(num))
    end,
    utf8_unicode_prop_table = function(num)
      return transf.hex.utf8_unicode_prop_table(transf.number.hex_string(num))
    end,
  },
  int = {
    length = function(int)
      return #tostring(int)
    end,
  },
  not_nil = {
    string = function(arg)
      if arg == nil then
        return nil
      else
        return tostring(arg)
      end
    end,
  },
  array = {

  },
  char = {
    hex = function(char)
      return string.format("%02X", string.byte(char))
    end,
    percent = function(char)
      return string.format("%%%02X", string.byte(char))
    end,
    unicode_prop_table = function(char)
      return memoize(runJSON)("uni identify -compact -format=all -as=json".. transf.string.single_quoted_escaped(char))[1]
    end
  },
  path = {
    attachment = function(path)
      local mimetype = mimetypes.guess(path) or "text/plain"
      return "#" .. mimetype .. " " .. path
    end,
    no_leading_following_slash_or_whitespace = function(item)
      item = stringy.strip(item)
      return item
    end,
    form_path = function(path)
      return "@" .. path
    end,
    file_url = function(path)
      return "file://" .. path
    end,
    extension = function(path)
      return pathSlice(path, "-1:-1", refstore.params.path_slice.opts.ext_sep)[1]
    end,
    no_extension = function(path)
      return pathSlice(path, "1:-2", refstore.params.path_slice.opts.sep_rejoin)
    end,
    filename = function(path)
      return pathSlice(path, "-2:-2", refstore.params.path_slice.opts.ext_sep)[1]
    end,
    ending_with_slash = function(path)
      return mustEnd(path or "", "/")
    end,
    leaf = function(path)
      return pathSlice(path, "-1:-1")[1]
    end,
    parent_path = function(path)
      return pathSlice(path, "1:-2", refstore.params.path_slice.opts.sep_rejoin)
    end,
    parent_leaf = function(path)
      return pathSlice(path, "-2:-2", refstore.params.path_slice.opts.ext_sep)[1]
    end,

  },
  extant_path = {
    size = function(path)
      return get.extant_path.attr(path, "size")
    end,
    m_date = function(path)
      return get.extant_path.date_attr(path, "modification")
    end,
    c_date = function(path)
      return get.extant_path.date_attr(path, "change")
    end,
    a_date = function(path)
      return get.extant_path.date_attr(path, "access")
    end,
    cr_date = function(path)
      return get.extant_path.date_attr(path, "creation")
    end,
  },
  path_array = {
    leaves_array = function(path_array)
      return hs.fnutils.imap(path_array, transf.path.leaf)
    end,
    filenames_array = function(path_array)
      local filenames = hs.fnutils.imap(path_array, transf.path.filename)
      return toSet(filenames)
    end,
    extensions_array = function(path_array)
      local extensions = hs.fnutils.imap(path_array, transf.path.extension)
      return toSet(extensions)
    end,
  },
  extant_path_array = {
    newest = function(path_array)
      return get.extant_path_array.largest_by_attr(path_array, "creation")
    end
  },
  dir_path = {
    children_array = function(dir_path)
      return itemsInPath(dir_path)
    end,
    children_leaves_array = function(dir_path)
      return transf.path_array.leaves_array(transf.dir_path.children_array(dir_path))
    end,
    children_filenames_array = function(dir_path)
      return transf.path_array.filenames_array(transf.dir_path.children_array(dir_path))
    end,
    children_extensions_array = function(dir_path)
      return transf.path_array.extensions_array(transf.dir_path.children_array(dir_path))
    end,
    newest_child = function(dir_path)
      return transf.extant_path_array.newest(transf.dir_path.children_array(dir_path))
    end,
    descendants_array = function(dir_path)
      return itemsInPath({
        path = dir_path,
        recursive = true,
      })
    end,
    descendants_leaves_array = function(dir_path)
      return transf.path_array.leaves_array(transf.dir_path.descendants_array(dir_path))
    end,
    descendants_filenames_array = function(dir_path)
      return transf.path_array.filenames_array(transf.dir_path.descendants_array(dir_path))
    end,
    descendants_extensions_array = function(dir_path)
      return transf.path_array.extensions_array(transf.dir_path.descendants_array(dir_path))
    end,

  },
  
  path_leaf_parts = {
    general_name_string = function(path_leaf_parts)
      if path_leaf_parts["general-name"] then 
        return "--" .. path_leaf_parts["general-name"]
      else
        return ""
      end
    end,
    extension_string = function(path_leaf_parts)
      if path_leaf_parts["extension"] then 
        return "." .. path_leaf_parts["extension"]
      else
        return ""
      end
    end,
    date_string = function(path_leaf_parts)
      return path_leaf_parts["date"] or ""
    end,
    full_path = function(path_leaf_parts)
      return transf.path.ending_with_slash(path_leaf_parts.path) 
      .. transf.path_leaf_parts.date_string(path_leaf_parts)
      .. transf.path_leaf_parts.general_name_string(path_leaf_parts)
      .. transf.table.fs_tag_string(path_leaf_parts.tag)
      .. transf.path_leaf_parts.extension_string(path_leaf_parts)
    end
  },
  audio_file = {
    transcribed = function(path)
      return memoize(rest, refstore.params.memoize.opts.invalidate_1_year_fs, "rest")({
        api_name = "openai",
        endpoint = "audio/transcriptions",
        request_table_type = "form",
        request_table = {
          model = "whisper-1",
          file = transf.path.form_path(path),
        }
      }).text
    end
  },
  image_file = {
    qr_data = function(path)
      return run("zbarimg -q --raw " .. transf.string.single_quoted_escaped(path))
    end,
    hs_image = function(path)
      return memoize(hs.image.imageFromPath, refstore.params.memoize.opts.invalidate_1_week_fs, "hs.image.imageFromPath")(path)
    end,
    booru_url = function(path)
      return run(
        "saucenao --file" ..
        transf.string.single_quoted_escaped(path)
        .. "--output-properties booru-url"
      )
    end,
    data_url = function(path)
      local ext = transf.path.extension(path)
      return memoize(hs.image.encodeAsURLString)(transf.image_file.hs_image(path), ext)
    end,
  },
  email_file = {
    all_headers_raw = function(path)
      return run(
        "mshow -L" .. transf.string.single_quoted_escaped(path)
      )
    end,
    all_useful_headers_raw = function(path)
      return run(
        "mshow -q" .. transf.string.single_quoted_escaped(path)
      )
    end,
    rendered_body = function(path)
      return run(
        "mshow -R" .. transf.string.single_quoted_escaped(path)
      )
    end,
    quoted_body = function(path)
      transf.string.email_quoted(transf.email_file.rendered_body(path))
    end,
    from = function(path)
      return get.email_file.header(path, "from")
    end,
    to = function(path)
      return get.email_file.header(path, "to")
    end,
    subject = function(path)
      return get.email_file.header(path, "subject")
    end,
    mime_parts_raw = function(path)
      return run(
        "mshow -t" .. transf.string.single_quoted_escaped(path)
      )
    end,
    attachments = function(path)
      return transf.mime_parts_raw.attachments(transf.email_file.mime_parts_raw(path))
    end,
    summary = function(path)
      return run("mscan -f %D **%f** %200s" .. transf.string.single_quoted_escaped(path))
    end,

  },
  mime_parts_raw = {
    attachments = function(mime_parts_raw)
      local attachments = {}
      for line in transf.string.lines(mime_parts_raw) do
        local name = line:match("name=\"(.-)\"")
        if name then
          table.insert(attachments, name)
        end
      end
      return attachments
    end,
  },
  bib_file = {
    array_of_tables = function(path)
      return runJSON({
        "citation-js",
        "--input",
        {
          value = path,
          type = "quoted"
        },
        "--output-language", "json"
      })
    end,

  },

  ics_file = {
    array_of_tables = function(path)
      local temppath = transf.string.in_tmp_dir(transf.path.filename(path) .. ".ics")
      srctgt("copy", path, temppath)
      dothis.ics_file.generate_json_file(temppath)
      local jsonpath = readFile(get.path.with_different_extension(temppath, "json"))
      local res = json.decode(readFile(jsonpath))
      delete(jsonpath)
      delete(temppath)
      return res
    end,
  },
  json_file = {
    table = function(path)
      return transf.json_string.table(readFile(path))
    end,
  },
  ini_file = {
    table = function(path)
      return transf.ini_string.table(readFile(path))
    end,
  },
  toml_file = {
    table = function(path)
      return transf.toml_string.table(readFile(path))
    end,
  },
  xml_file = {
    tree = xml.parseFile
  },

  shellscript_file = {
    gcc_string_errors = function(path)
      return get.shellscript_file.lint_gcc_string(path, "errors")
    end,
    gcc_string_warnings = function(path)
      return get.shellscript_file.lint_gcc_string(path, "warnings")
    end,
  },

  plaintext_file = {
    contents = function(path)
      return readFile(path)
    end,
    lines = function(path)
      return transf.string.lines(transf.plaintext_file.contents(path))
    end,
    first_line = function(path)
      return transf.string.first_line(transf.plaintext_file.contents(path))
    end,
    last_line = function(path)
      return transf.string.last_line(transf.plaintext_file.contents(path))
    end,
    bytechars = function(path)
      return transf.string.bytechars(transf.plaintext_file.contents(path))
    end,
    chars = function(path)
      return transf.string.chars(transf.plaintext_file.contents(path))
    end,
    no_final_newlines = function(path)
      return transf.string.no_final_newlines(transf.plaintext_file.contents(path))
    end,
    one_final_newline = function(path)
      return transf.string.one_final_newline(transf.plaintext_file.contents(path))
    end,

    
  },

  plaintext_table_file = {
    field_separator = function(path)
      return tblmap.extension.likely_field_separator[transf.path.extension(path)]
    end,
    record_separator = function(path)
      return tblmap.extension.likely_record_separator[transf.path.extension(path)]
    end,
    array_of_array_of_fields = function(path)
      return ftcsv.parse(path, transf.plaintext_table_file.field_separator(path), refstore.params.ftcsv_parse.opts.noheaders)
    end,
    iter_of_array_of_fields = function(path)
      local iter = ftcsv.parseLine(path, transf.plaintext_table_file.field_separator(path), refstore.params.ftcsv_parse.opts.noheaders)
      iter() -- skip header, seems to be a bug in ftcsv
      return iter
    end,
    array_of_dicts = function(path)
      return select(1, ftcsv.parse(path, transf.plaintext_table_file.field_separator(path)))
    end,
    iter_of_dicts = function(path)
      return ftcsv.parseLine(path, transf.plaintext_table_file.field_separator(path))
    end,
  },
  timestamp_first_column_plaintext_table_file = {
    last_accessed = function(path)
      return tonumber(readFile(env.MLAST_BACKUP .. transf.path.filename(path)) or 0)
    end,
    new_timestamp_table = function(path)
      local last_access = transf.timestamp_first_column_plaintext_table_file.last_accessed(path)
      local new_timestamp = os.time()
      local new_timestamp_table = get.timestamp_first_column_plaintext_table_file.timestamp_table_newer_than_timestamp(path, last_access)
      if new_timestamp_table then
        writeFile(env.MLAST_BACKUP .. transf.path.filename(path), new_timestamp)
      end
      return new_timestamp_table
    end,

  },

  semver = {
    components = function(str)
      local major, minor, patch, prerelease, build = onig.match(str, mt._r.version.semver)
      return {
        major = tonumber(major),
        minor = tonumber(minor),
        patch = tonumber(patch),
        prerelease = prerelease,
        build = build
      }
    end,
  },
  date = {
    y_ym_ymd_table = function(date)
      return  {
        date:fmt("%Y"),
        date:fmt("%Y-%m"),
        date:fmt("%Y-%m-%d"),
      }
    end,
    y_ym_ymd_path = function(date)
      return table.concat(transf.date.y_ym_ymd_table(date), "/")
    end,

  },
  iban = {
    cleaned_iban = function(iban)
      return select(1, string.gsub(iban, "[ %-_]", ""))
    end
  },
  cleaned_iban = {
    data = function(iban)
      local res = memoize(rest, refstore.params.memoize.opts.invalidate_1_month_fs, "rest")({
        host = "openiban.com/",
        endpoint = "validate/" .. iban,
        params = { getBIC = "true" },
      })
      local data = res.bankData
      data.valid = res.valid
    end,
    bic = function(iban)
      return transf.cleaned_iban.data(iban).bic
    end,
    bank_name = function(iban)
      return transf.cleaned_iban.data(iban).bankName
    end,
  },
  uuid = {
    raw_contact = function(uuid)
      return memoize(run)( "khard show --format=yaml uid:" .. uuid, {catch = true} )
    end,
    contact_table = function(uuid)
      local raw_contact = transf.uuid.raw_contact(uuid)
      local contact_table = transf.yaml_string.table(raw_contact)
      contact_table.uid = uuid
      return contact_table
    end,
  },
  youtube_video_id = {
    youtube_video_item = function(id)
      return memoize(rest, refstore.params.memoize.opts.invalidate_1_month_fs)({
        api_name = "youtube",
        endpoint = "videos",
        params = {
          id = id,
          part = "snippet,status",
        },
      }).items[1]
    end,
    title = function(id)
      return transf.youtube_video_id.youtube_video_item(id).snippet.title
    end,
    channel_title = function(id)
      return transf.youtube_video_id.youtube_video_item(id).snippet.channelTitle
    end,
    youtube_channel_id = function(id)
      return transf.youtube_video_id.youtube_video_item(id).snippet.channelId
    end,
    description = function(id)
      return transf.youtube_video_id.youtube_video_item(id).snippet.description
    end,
    upload_status = function(id)
      return transf.youtube_video_id.youtube_video_item(id).status.uploadStatus
    end,
    privacy_status = function(id)
      return transf.youtube_video_id.youtube_video_item(id).status.privacyStatus
    end,
    youtube_video_url = function(id)
      return "https://www.youtube.com/watch?v=" .. id
    end,
    captions_list = function(id)
      return memoize(rest, refstore.params.memoize.opts.invalidate_1_month_fs)({
        api_name = "youtube",
        endpoint = "captions",
        params = {
          videoId = id,
          part = "snippet",
        },
      }).items
    end,
  },
  youtube_playlist_id = {
    youtube_playlist_item = function(id)
      return rest({
        api_name = "youtube",
        endpoint = "playlists",
        params = {
          id = id,
          part = "snippet,status",
        }
      }).items[1]
    end,
    title = function(id)
      return transf.youtube_playlist_id.youtube_playlist_item(id).snippet.title
    end,
    uploader = function(id)
      return transf.youtube_playlist_id.youtube_playlist_item(id).snippet.channelTitle
    end,
    youtube_playlist_url = function(id)
      return "https://www.youtube.com/playlist?list=" .. id
    end,
  },
  youtube_playlist_url = {
    youtube_playlist_id = function(url)
      return transf.url.param_table(url).list
    end,
  },
  youtube_video_url = {
    youtube_video_id = function(url)
      return transf.url.param_table(url).v
    end,
  },
  youtube_channel_id = {
    feed_url = function(id)
      return "https://www.youtube.com/feeds/videos.xml?channel_id=" .. id
    end,
    channel_url = function(id)
      return "https://www.youtube.com/channel/" .. id
    end,
    youtube_channel_item = function(id)
      return memoize(rest, refstore.params.memoize.opts.invalidate_1_month_fs, "rest")({
        api_name = "youtube",
        endpoint = "channels",
        params = {
          id = id,
          part = "snippet,status",
        }
      }).items[1]
    end,
    channel_title = function(id)
      return transf.youtube_channel_id.youtube_channel_item(id).snippet.title
    end,
  },
  youtube_video_title = {
    cleaned = function(title)
      title = replace(title, {
        { cond = {_r = mt._r.text_bloat.youtube.vieo, _ignore_case = true}, mode="remove" },
        { cond = {_r = mt._r.text_bloat.youtube.misc, _ignore_case = true}, mode="remove" },
      })
      return title
    end,
  },
  youtube_channel_title = {
    cleaned = function(channel)
      channel = replace(channel, {
        { cond = {_r = mt._r.text_bloat.youtube.channel_topic_producer, _ignore_case = true}, mode="remove" },
        { value = {_r = mt._r.text_bloat.youtube.slash_suffix, _ignore_case = true}, mode="remove" },
      })
      return channel
    end,
  },
  handle = {
    youtube_channel_item = function(handle)
      return memoize(rest, refstore.params.memoize.opts.invalidate_1_month_fs, "rest")({
        api_name = "youtube",
        endpoint = "channels",
        params = { handle = handle}
      }).items[1]
    end,
    youtube_channel_id = function(handle)
      return transf.handle.youtube_channel_item(handle).id
    end,
    channel_title = function(handle)
      return transf.handle.youtube_channel_item(handle).snippet.title
    end,
    feed_url = function(handle)
      return transf.youtube_channel_id.feed_url(transf.handle.youtube_channel_id(handle))
    end,
    raw_handle = function(handle)
      return eutf8.sub(handle, 2)
    end,
  },
  string = {
    in_cache_dir = function(data, type)
      return env.XDG_CACHE_HOME .. "/hs/" .. (type or "default") .. "/" .. transf.string.safe_filename(data)
    end,
    in_tmp_dir = function(data, type) -- in contrast to the above method, we also ensure that it's unique by using a timestamp
      return env.TMPDIR .. "/hs/" .. (type or "default") .. "/" .. os.time() .. "-" .. transf.string.safe_filename(data)
    end,
    qr_utf8_image_bow = function(data)
      return memoize(run)("qrencode -l M -m 2 -t UTF8 " .. transf.string.single_quoted_escaped(data))
    end,
    qr_utf8_image_wob = function(data)
      return memoize(run, refstore.params.memoize.opts.stringify_json)({
        args = "qrencode -l M -m 2 -t UTF8i " .. transf.string.single_quoted_escaped(data),
        dont_clean_output = true,
      })
    end,
    qr_png_in_cache = function(data)
      local path = transf.string.in_cache_dir(data, "qr")
      dothis.string.generate_qr_png(data, path)
      return path
    end,
    --- does the minimum to make a string safe for use as a filename, but doesn't impose any policy
    safe_filename = function(filename)
      -- Replace forward slash ("/") with underscore
      filename = eutf8.gsub(filename, "/", "_")

      -- Replace control characters (ASCII values 0 - 31 and 127)
      for i = 0, 31 do
        filename = eutf8.gsub(filename, string.char(i), "_")
      end
      filename = eutf8.gsub(filename, string.char(127), "_")

      -- Replace sequences of whitespace characters with a single underscore
      filename = eutf8.gsub(filename, "%s+", "_")

      if filename == "." then
        filename = "_"
      elseif filename == ".." then
        filename = "__"
      end

      if #filename > 255 then
        filename = eutf8.sub(filename, 1, 255)
      elseif #filename == 0 then
        filename = "_"
      end
      
      return filename
    end,
    snake_case = function(str)
      return replace(str, to.case.snake)
    end,
    lower_snake_case = function(str)
      return eutf8.lower(transf.string.snake_case(str))
    end,
    upper_snake_case = function(str)
      return eutf8.upper(transf.string.snake_case(str))
    end,
    alphanum = function(str)
      return replace(str, to.case.alphanum)
    end,

    --- URL-encodes a string.
    --- @param url string
    --- @param spaces_percent? boolean whether to encode spaces as %20 (true) or + (false)
    --- @return string
    urlencoded = function(url, spaces_percent)
      if url == nil then
        return ""
      end
      url = eutf8.gsub(url, "\n", "\r\n")
      url = eutf8.gsub(url, "([^%w _%%%-%.~])", transf.char.percent)
      if spaces_percent then
        url = eutf8.gsub(url, " ", "%%20")
      else
        url = eutf8.gsub(url, " ", "+")
      end
      return url
    end,
    urldecoded = function(url)
      return replace(url, to.url.decoded)
    end,
    escaped_csv_field = function(field)
      return '"' .. replace(field, to.string.escaped_csv_field_contents)  .. '"'
    end,
    unicode_prop_table_array = function(str)
      return memoize(runJSON)("uni identify -compact -format=all -as=json".. transf.string.single_quoted_escaped(str))
    end,
    single_quoted_escaped = function(str)
      return " '" .. memoize(replace)(str, to.string.escaped_single_quote_safe) .. "'"
    end,
    double_quoted_escaped = function(str)
      return ' "' .. memoize(replace)(str, to.string.escaped_double_quote_safe) .. '"'
    end,
    envsubsted = function(str)
      return run("echo " .. transf.string.single_quoted_escaped(str) .. " | envsubst")
    end,
    bits = basexx.to_bit,
    hex = basexx.to_hex,
    base64_gen = basexx.to_base64,
    base64_url = basexx.to_url64,
    base32_gen = basexx.to_base32,
    base32_crock = basexx.to_crockford,
    title_case = function(str)
      local words, removed = split(str, {_r = "[ :–\\—\\-\\t\\n]", _regex_engine = "onig"})
      local title_cased_words = map(words, transf.word.title_case_policy)
      title_cased_words[1] = replace(title_cased_words[1], to.case.capitalized)
      title_cased_words[#title_cased_words] = replace(title_cased_words[#title_cased_words], to.case.capitalized)
      return concat({
        isopts = "isopts",
        sep = removed,
      }, title_cased_words)
    end,
    romanized = function(str)
      local raw_romanized = run(
        { "echo", "-n",  {value = str, type = "quoted"}, "|", "kakasi", "-iutf8", "-outf8", "-ka", "-Ea", "-Ka", "-Ha", "-Ja", "-s", "-ga" }
      )
      local is_ok, romanized = pcall(eutf8.gsub, raw_romanized, "(%w)%^", "%1%1")
      if not is_ok then
        return str -- if there's an error, just return the original string
      end
      replace(romanized, {{"(kigou)", "'"}, {}}, {
        mode = "remove",
      })
      return romanized
    end,
    romanized_snake = function(str)
      str = eutf8.gsub(str, "[%^']", "")
      str = transf.string.romanized(str)
      str = eutf8.lower(replace(str, to.case.snake))
      return str
    end,
    romanized_gpt = function(str)
      return gpt("Please romanize the following text with wapuro-like romanization, where:\n\nっ -> duplicated letter (e.g. っち -> cchi)\nlong vowel mark -> duplicated letter (e.g. ローマ -> roomaji)\nづ -> du\nんま -> nma\nじ -> ji\nを -> wo\nち -> chi\nparticles are separated by spaces (e.g. これに -> kore ni)\nbut morphemes aren't (真っ赤 -> makka)\n\nDictionary:\n\nこっち -> kocchi\n\nText:\n\n" .. str, {temperature = 0})
    end,
    tilde_resolved = function(path)
      if stringy.startswith(path, "~") then
        return env.HOME .. eutf8.sub(path, 2)
      else
        return path
      end
    end,
    folded = function(str)
      return eutf8.gsub(str, "\n", " ")
    end,
    --- @param str string
    --- @return string[]
    bytechars = function(str)
      local t = {}
      for i = 1, #str do
        t[i] = str:sub(i, i)
      end
      return t
    end,


    --- @param str string
    --- @return string[]
    chars = function(str)
      local t = {}
      for i = 1, eutf8.len(str) do
        t[i] = eutf8.sub(str, i, i)
      end
      return t
    end,

    --- @param str string
    --- @return string[]
    lines = function(str)
      return stringy.split(
        stringy.strip(str),
        "\n"
      )
    end,
    content_lines = function(str)
      return memoize(filter)(transf.string.lines(str), true)
    end,

    first_line = function(str)
      return transf.string.lines(str)[1]
    end,
    first_content_line = function(str)
      return transf.string.content_lines(str)[1]
    end,
    last_line = function(str)
      local lines = transf.string.lines(str)
      return lines[#lines]
    end,
    last_content_line = function(str)
      local lines = transf.string.content_lines(str)
      return lines[#lines]
    end,
    first_char = function(str)
      return eutf8.sub(str, 1, 1)
    end,
    last_char = function(str)
      return eutf8.sub(str, -1)
    end,
    no_final_newlines = function(str)
      return eutf8.gsub(str, "\n+$", "")
    end,
    one_final_newline = function(str)
      return eutf8.gsub(str, "\n+$", "\n")
    end,
    
    path_resolved = function(path, resolve_tilde)
      if resolve_tilde then
        path = transf.string.tilde_resolved(path)
      end
      local components = pathSlice(path, ":")
      local reduced_components = {}
      local started_with_slash = stringy.startswith(path, "/")
      local components_are_all_dotdot = false
      for _, component in ipairs(components) do
        if component == ".." then
          if #reduced_components > 0 and not components_are_all_dotdot then
            table.remove(reduced_components)
          else -- we can't go higher up
            if started_with_slash then
              -- no-op: we're already at the root, so we treat this similarly to '.', which is a no-op. This is consistent with the behavior of cd/ls in bash
            else
              table.insert(reduced_components, "..") -- the path was a relative path, and we've arrived at the root of the relative path. We have no further information about what is above the root of the relative path, so we have no choice but to leave this component unresolved
              components_are_all_dotdot = true
            end
             
          end
        else
          components_are_all_dotdot = false
          if component ~= "." then
            table.insert(reduced_components, component)
          end
        end
      end
      local new_path = table.concat(reduced_components, "/")
      if started_with_slash then
        return "/" .. new_path
      else
        if #new_path == 0 then
          return "."
        else
          return new_path
        end
      end
    end,
    timestamp_or_nil = function(str)
      if eutf8.match(str, "^%d") then
        str = slice(str, {start = {_r = "%d"}})
      end
      -- date is already a timestamp
    
      if #str == 13 then
        return tonumber(eutf8.sub(str, 1, 10))
      elseif #str == 10 then
        return tonumber(str)
      end
    
      -- we have to parse the date
    
      for _, sep in ipairs(mt._list.date.long_dt_seps) do
        eutf8.gsub(str, _r_comp.lua.data.sep, " ")
      end
    
      local date_parts
    
      for _, date_regex in fastpairs(mt._r_lua.date) do
        date_parts = {eutf8.match(str, date_regex)}
        if #date_parts > 0 then
          break
        end
      end
    
      if #date_parts == 0 then
        return nil
      end
    
      local date_table = map(mt._list.date.dt_component_few_chars, function(k,v) return v, date_parts[k] end, "kv")
      local res, timestamp = pcall(os.time, date_table)
      if res then
        return timestamp
      else
        return nil
      end
    end,
    raw_contact = function(searchstr)
      return memoize(run)("khard show --format=yaml " .. searchstr, {catch = true} )
    end,
    contact_table = function(searchstr)
      local raw_contact = transf.string.raw_contact(searchstr)
      local contact = transf.yaml_string.table(raw_contact)
      return contact
    end,
    event_table = function(str)
      local components = stringx.split(str, mt._contains.unique_field_separator)
      local parsed = ovtable.new()
      for i, component in ipairs(components) do
        local key = mt._list.khal.parseable_format_components[i]
        if key == "alarms" then
          parsed[key] = stringy.split(component, ",")
        elseif key == "description" then
          parsed[key] = component
        else
          parsed[key] = stringx.replace(component, "\n", "")
        end
      end
      return parsed
    end,
    kana_inner = function(argstr)
      return run("kana --vowel-shortener x " .. argstr )
    end,
    kana_inner_nospaces = function(argstr)
      return run("kana --vowel-shortener x " .. argstr .. "| tr -d ' '")
    end,
    hiragana_only = function(str)
      return transf.string.kana_inner(transf.string.single_quoted_escaped(str))
    end,
    katakana_only = function(str)
      return transf.string.kana_inner("--katakana --extended" .. transf.string.single_quoted_escaped(str))
    end,
    hiragana_punct = function(str)
      return transf.string.kana_inner_nospaces("--punctuation" .. transf.string.single_quoted_escaped(str))
    end,
    katakana_punct = function(str)
      return transf.string.kana_inner_nospaces("--katakana --extended --punctuation" .. transf.string.single_quoted_escaped(str))
    end,
    kana_mixed = function(str)
      return transf.string.kana_inner("--extended --punctuation --kana-toggle 'Δ' --raw-toggle '†'" .. transf.string.single_quoted_escaped(str))
    end,
    japanese_writing = function(str)
      return gpt("You're a dropin IME for already written text. Please transform the following into its Japanese writing system equivalent:\n\n" .. str, {temperature = 0})
    end,
    kana_readings = function(str)
      return gpt("Provide kana readings for: " .. str, {temperature = 0})
    end,
    ruby_annotated_kana = function(str)
      return gpt("Add kana readings to this text as <ruby> annotations, including <rp> fallback: " .. str, {temperature = 0})
    end,
    --- @param str string
    --- @return hs.styledtext
    with_styled_start_end_markers = function(str)
      local res =  hs.styledtext.new("^" .. str .. "$")
      res = styleText(res, { style = "light", starts = 1, ends = 1 })
      res = styleText(res, { style = "light", starts = #res, ends = #res})
      return res
    end,
    email_quoted = function(str)
      return stringx.join(
        "\n",
        hs.fnutils.imap(
          stringx.splitlines(
            stringy.strip(str)
          ),
          function(v)
            if stringy.startswith(v, ">") then
              return ">" .. v
            else
              return ">" .. " " .. v
            end
          end
        )
      )
    end,
  },
  pass_name = {
    password = function(pass_name)
      return get.pass.value("passw", pass_name)
    end,
    username = function(pass_name)
      return transf.plaintext_file.no_final_newlines(st(env.MPASSUSERNAME .. "/" .. pass_name .. ".txt") or env.MAIN_EMAIL)
    end
  },
  yaml_string = {
    table = function(str)
      local res = yaml.load(str)
      null2nil(res)
      return res
    end
  },
  json_string = {
    table = json.decode
  },
  toml_string = {
    table = toml.decode
  },
  ini_string = {
    table = function(str)
      return runJSON(
        "jc --ini <<EOF " .. str .. "EOF"
      )
    end,
  },

  event_table = {
    calendar_template = function(event_table)
      local template = get.khal.calendar_template_empty()
      for key, value in fastpairs(event_table) do
        if template[key] then
          if key == "repeat" then
            for subkey, subvalue in fastpairs(value) do
              template[key][subkey].value = subvalue
            end
          else
            template[key].value = value
          end
        end
      end
      if template.alarms.value then 
        template.alarms.value = table.concat(template.alarms.value, ",")
      end
      return transf.table.yaml_aligned(template)

    end,
    event_tagline = function(event_table)
      local str = event_table.start
      if event_table["end"] then
        str = str .. " - " .. event_table["end"]
      end
      str = str .. " " .. event_table.calendar .. ":"
      if event_table.title then
        str = str .. " " .. event_table.title
      end
      if event_table.location then
        str = str .. " @ " .. event_table.location
      end
      if event_table.description then
        str = str .. " :: " .. event_table.description
      end
      if event_table.url then
        str = str .. " Link: " .. event_table.url
      end
      return str
    end
  },
  search_engine = {
    action_table_item = function(search_engine)
      return {
        text = string.format("%s🔎 s%s.", tblmap.search_engine.emoji_icon[search_engine], tblmap.search_engine.short[search_engine]),
        key = "search-with",
        args = search_engine
      }
    end,
  },
  multiline_string = {
    trimmed_lines = function(str)
      local lines = split(str, "\n")
      local trimmed_lines = map(lines, stringy.strip)
      return table.concat(trimmed_lines, "\n")
    end,
    relay_table = function(raw)
      local raw_countries = stringx.split(raw, "\n\n") -- stringy does not support splitting by multiple characters
      raw_countries = filter(raw_countries, true)
      local countries = {}
      for _, raw_country in ipairs(raw_countries) do
        local raw_country_lines = stringy.split(raw_country, "\n")
        raw_country_lines = filter(raw_country_lines, true)
        local country_header = raw_country_lines[1]
        local country_code = slice(country_header, "(", ")")
        if country_code == nil then error("could not find country code in header. header was " .. country_header) end
        local payload_lines = slice(raw_country_lines, 2, -1)
        countries[country_code] = {}
        local city_code
        for _, payload_line in ipairs(payload_lines) do
          if stringy.startswith(payload_line, "\t\t") then -- line specifying a single relay
            local relay_code = payload_line:match("^\t\t([%w%-]+) ") -- lines look like this: \t\tfi-hel-001 (185.204.1.171) - OpenVPN, hosted by Creanova (Mullvad-owned)
            push(countries[country_code][city_code], relay_code)
          elseif stringy.startswith(payload_line, "\t") then -- line specifying an entire city
            city_code = slice(payload_line, "(", ")") -- lines look like this: \tHelsinki (hel) @ 60.19206°N, 24.94583°W
            countries[country_code][city_code] = {}
          end
        end

      end
    
      return countries
    end,
    array_of_event_tables = function(str)
      local res = filter(stringx.split(str, mt._contains.unique_record_separator))
      return hs.fnutils.imap(
        res,
        transf.string.event_table
      )
    end,
  },
  word = {
    title_case_policy = function(word)
      if find(mt._contains.small_words, word) then
        return word
      elseif eutf8.find(word, "%u") then -- words with uppercase letters are presumed to already be correctly title cased (acronyms, brands, the like)
        return word
      else
        return replace(word, to.case.capitalized)
      end
    end,
    capitalized = function(word)
      return replace(word, to.case.capitalized)
    end,
    synonyms = {

      raw_syn = function(str)
        return memoize(run)( "syn -p" .. transf.string.single_quoted_escaped(str) )
      end,
      array_syn_tbls = function(str)
        local synonym_parts = stringx.split(transf.word.synonyms.raw_syn(str), "\n\n")
        local synonym_tables = map(
          synonym_parts,
          function (synonym_part)
            local synonym_part_lines = stringy.split(synonym_part, "\n")
            local synonym_term = eutf8.sub(synonym_part_lines[1], 2) -- syntax: ❯<term>
            local synonyms_raw = eutf8.sub(synonym_part_lines[2], 12) -- syntax:  ⬤synonyms: <term>{, <term>}
            local antonyms_raw = eutf8.sub(synonym_part_lines[3], 12) -- syntax:  ⬤antonyms: <term>{, <term>}
            local synonyms = map(stringy.split(synonyms_raw, ", "), stringy.strip)
            local antonyms = map(stringy.split(antonyms_raw, ", "), stringy.strip)
            return {
              term = synonym_term,
              synonyms = synonyms,
              antonyms = antonyms,
            }
          end
        )
        return synonym_tables
      end,
      raw_av = function (str)
        memoize(run)(
          "synonym" .. transf.string.single_quoted_escaped(str)
        )
      end,
      array_av = function(str)
        local items = stringy.split(transf.word.synonyms.raw_av(str), "\t")
        items = filter(items, function(itm)
          if itm == nil then
            return false
          end
          itm = stringy.strip(itm)
          return #itm > 0
        end)
        return items
      end,
    }
  },
  displayname_email = {
    email = function(str)
      return eutf8.match(str, " <(.*)> *$")
    end,
    displayname = function(str)
      return eutf8.match(str, "^(.*) <")
    end,
    displayname_email_dict = function(str)
      local displayname = transf.displayname_email.displayname(str)
      local email = transf.displayname_email.email(str)
      return {
        displayname = displayname,
        email = email,
      }
    end,
  },
  email_or_displayname_email = {
    email = function(str)
      return transf.displayname_email.email(str) or str
    end,
    displayname = function(str)
      return transf.displayname_email.displayname(str) or nil
    end,
    displayname_email_dict = function(str)
      local displayname = transf.email_or_displayname_email.displayname(str)
      local email = transf.email_or_displayname_email.email(str)
      return {
        displayname = displayname,
        email = email,
      }
    end,
  },
  array_of_tables = {
    item_array_of_item_tables = function(arr)
      return ar(map(
        arr,
        function (arr)
          return tb(arr)
        end
      ))
    end
  },
  array_of_strings = {
    item_array_of_string_items = function(arr)
      return ar(hs.fnutils.imap(
        arr,
        st
      ))
    end,
    repeated_option_string = function(arr, opt)
      return table.concat(
        hs.fnutils.imap(
          arr,
          function (itm)
            return " " .. opt .. " " .. itm
          end
        ),
        ""
      )
    end,

  },
  array_of_string_arrays = {

  },
  array_of_event_tables = {
    item_array_of_event_table_items = function(arr)
      return ar(hs.fnutils.imap(
        arr,
        CreateEventTableItem
      ))
    end,
  },
  table = {
    
    --- wraps yaml.dump into a more intuitive form which always encodes a single document
    --- @param tbl any
    --- @return string
    yaml_string = function(tbl)
      local raw_yaml = yaml.dump({tbl})
      local lines = stringy.split(raw_yaml, "\n")
      return table.concat(lines, "\n", 2, #lines - 2)
    end,
    json_string = json.encode,
    toml_string = toml.encode,
    --- allows for aligned values and comments, but may be less robust than transf.table.yaml_string, since I'm implementing it myself
    --- value and comment must be strings
    yaml_aligned = function(tbl)
      local value_table = map(
        tbl,
        {_k = "value", _ret = "orig" },
        { recurse = true, treat_as_leaf = "list" }
      )
      local stops = flatten(value_table, {
        treat_as_leaf = "list",
        mode = "assoc",
        val = {"valuestop", "keystop"},
      })
      local valuestop = reduce(map(stops, {_k = "valuestop"}, {tolist = true}))
      local keystop = reduce(map(stops, {_k = "keystop"}, {tolist = true}))
      return table.concat(get.table.yaml_lines_aligned_with_predetermined_stops(tbl, keystop, valuestop, 0), "\n")
    end,
    yaml_metadata = function(t)
      local string_contents = transf.table.yaml_string(t)
      return "---\n" .. string_contents .. "\n---\n"
    end,
    fs_tag_array = function(t)
       local arr = map(
        t,
        function(tag_key, tag_value)
          if type(tag_value) == "table" then tag_value = table.concat(tag_value, ",") end
          return string.format("%s-%s", tag_key, tag_value)
        end,
        {
          args = "kv",
          ret = "v",
          tolist = true,
        }
      )
      table.sort(arr)
      return arr
    end,
    fs_tag_string = function(t)
      return "%" .. table.concat(transf.table.fs_tag_array(t), "%")
    end,
    ics_string = function(t)
      local tmpdir_ics_path = transf.not_userdata_or_function.in_tmp_dir(t) .. ".ics"
      dothis.table.write_ics_file(t, tmpdir_ics_path)
      local contents = readFile(tmpdir_ics_path)
      delete(tmpdir_ics_path)
      return contents
    end,
    
  },
  assoc_arr = {

  },
  dict = {
    url_params = function(t)
      local params = {}
      for k, v in pairs(t) do
        local encoded_v = transf.string.urlencoded(tostring(v), true)
        table.insert(params, k .. "=" .. encoded_v)
      end
      return table.concat(params, "&")
    end,
    --- @param t { [string]: string }
    --- @return string
    email_header = function(t)
      local header_lines = {}
      local initial_headers = mt._list.initial_headers
      for _, header_name in ipairs(initial_headers) do
        local header_value = t[header_name]
        if header_value then
          table.insert(header_lines, join.string.string.email_header(header_name, header_value))
          t[header_name] = nil
        end
      end
      for key, value in prs(t) do
        table.insert(header_lines, join.string.string.email_header(key, value))
      end
      return table.concat(header_lines, "\n")
    end,
    curl_form_field_list = function(t)
      local fields = {}
      for k, v in pairs(t) do
        push(fields, "-F")
        local val = v
        if stringy.startswith(v, "@") then
          local valpath = eutf8.sub(v, 2)
          valpath = transf.string.path_resolved(valpath, true)
          val = "@" .. valpath
        end
        push(fields, {
          value = ("%s=%s"):format(k, val),
          type = "quoted",
        })
      end
      return fields
    end,
    ini_string = function(tbl)
      for k, v in fastpairs(tbl) do
        local out_lines = { "[" .. k .. "]" }
        for k, v in fastpairs(v) do
          local val
          if stringy.startswith(v, "noquote:") then
            val = v:match("noquote:(.+)")
          else
            val = "\"" .. v .. "\""
          end
          table.insert(out_lines, k .. " = " .. val)
        end
        return table.concat(out_lines, "\n")
      end
    end,
    labeled_dict_by_space = function(tbl)
      local res = {}
      for k, v in fastpairs(tbl) do
        local key_parts = stringy.split(k, " ")
        local label = key_parts[1]
        local key = key_parts[2]
        if not key then
          res[label] = v
        else
          res[label] = res[label] or {}
          res[label][key] = v
        end
      end
      return res
    end,
  },
  labeled_dict = {
    dict_by_space = function(labeled_dict)
      local res = {}
      for label, dict in fastpairs(labeled_dict) do
        for k, v in fastpairs(dict) do
          res[label .. " " .. k] = v
        end
      end
      return res
    end,
    ini_string = function (labeled_dict)
      return transf.dict.ini_string(transf.labeled_dict.dict_by_space(labeled_dict))
    end

  },
  timestamp_table = {
    --- transforms a timestamp-key orderedtable into a table of the structure [yyyy] = { [yyyy-mm] = { [yyyy-mm-dd] = { [hh:mm:ss, ...] } } }
    --- @param timestamp_key_table orderedtable
    --- @return { [string]: { [string]: { [string]: string[] } } }
    ymd_table = function(timestamp_key_table)
      local year_month_day_time_table = {}
      for timestamp_str, fields in prs(timestamp_key_table,-1,1,-1) do 
        local timestamp = tonumber(timestamp_str)
        local year = os.date("%Y", timestamp)
        local year_month = os.date("%Y-%m", timestamp)
        local year_month_day = os.date("%Y-%m-%d", timestamp)
        local time = os.date("%H:%M:%S", timestamp)
        if not year_month_day_time_table[year] then year_month_day_time_table[year] = {} end
        if not year_month_day_time_table[year][year_month] then year_month_day_time_table[year][year_month] = {} end
        if not year_month_day_time_table[year][year_month][year_month_day] then year_month_day_time_table[year][year_month][year_month_day] = {} end
        local contents = concat({time}, fields)
        table.insert(year_month_day_time_table[year][year_month][year_month_day], contents)
      end
      return year_month_day_time_table
    end
  },
  tachiyomi_json_table = {
    timestamp_table = function(raw_backup)
      -- data we care about is in the backupManga array in the json file
      -- each array element is a manga which has general metadata keys such as title, author, url, etc
      -- and a chapters array which has chapter metadata keys such as name, chapterNumber, url, etc
      -- and a history array which has the keys url and lastRead (unix timestamp in ms)
      -- we want to transform this into a table of our own design, where the key is a timestamp (but in seconds) and the value is an array consisting of some of the metadata of the manga and some of the metadata of the chapter
      -- specifically: url (of the manga), title, chapterNumber, name (of the chapter)
      -- for that, we need to match the key url in the history array with the key url in the chapters array, for which we will create a temporary table with the urls as keys and the chapter metadata we will use as values

      local manga = raw_backup.backupManga
      local manga_url, manga_title = manga.url, manga.title
      local chapter_map = {}
      for _, chapter in ipairs(manga.chapters) do
        chapter_map[chapter.url] = {
          chapterNumber = chapter.chapterNumber,
          name = chapter.name
        }
      end
      local history_list = {}
      for _, hist_item in ipairs(manga.history) do
        local chapter = chapter_map[hist_item.url]
        history_list[hist_item.lastRead / 1000] = {
          manga_url,
          manga_title,
          chapter.chapterNumber,
          chapter.name
        }
      end
      return history_list
    end,
  },
  vdirsyncer_pair_specifier = {
    labeled_dict = function(specifier)
      local local_name = specifier.name .. "_local"
      local remote_name = specifier.name .. "_remote"
      return {
        pair = {
          [specifier.name] = {
            a = local_name,
            b = remote_name,
            collections = specifier.collections,
            conflict_resolution = specifier.conflict_resolution,
          }
        },
        storage = {
          [local_name] = {
            type = specifier.local_storage_type,
            path = specifier.local_storage_path,
            fileext = specifier.local_storage_fileext,
          },
          [remote_name] = {
            type = specifier.remote_storage_type,
            url = specifier.remote_storage_url,
            username = specifier.remote_storage_username,
            password = specifier.remote_storage_password,
          }
        }
      }         
    end,
    ini_string = function(specifier)
      return transf.labeled_dict.ini_string(transf.vdirsyncer_pair_specifier.labeled_dict(specifier))
    end
  },
  url_components = {
    url = function(comps)
      local url
      if comps.url then
        url = comps.url
      elseif comps.host then
        if comps.scheme then
          url = comps.scheme
        else
          url = "https://"
        end
        url = url .. mustEnd(comps.host, "/")
        if comps.endpoint then
          url = url .. (mustNotStart(comps.endpoint, "/") or "/")
        end   
      end     
      if comps.params then
        if type(comps.params) == "table" then
          url = url .. "?" .. transf.dict.url_params(comps.params)
        else
          url = url .. mustStart(comps.params, "?")
        end
      end
      return url
    end,
  },
  doi = {
    doi_url = function(doi)
      return replace(doi, to.resolved.doi)
    end,
    bibtex = function(doi)
      return run(
        "curl -LH Accept: application/x-bibtex" .. transf.string.single_quoted_escaped(
          transf.doi.doi_url(doi)
        )
      )
    end,
  },
  isbn = {
    bibtex = function(isbn)
      return run(
        "isbn_meta" .. transf.string.single_quoted_escaped(isbn) .. " bibtex"
      )
    end,
  },
  isbn10 = {
    isbn13 = function(isbn10)
      return run(
        "to_isbn13" .. transf.string.single_quoted_escaped(isbn10)
      )
    end,
  },
  isbn13 = {
    isbn10 = function(isbn13)
      return run(
        "to_isbn10" .. transf.string.single_quoted_escaped(isbn13)
      )
    end,
  },
  bibtex_string = {
    csl_table = function(str)
      return runJSON(" pandoc -f bibtex -t csljson <<EOF " .. str .. "\nEOF")
    end,
  },
  url = {
    in_wayback_machine = function(url)
      return "https://web.archive.org/web/*/" .. url
    end,
    default_negotiation_url_contents = function(url)
      return memoize(run, refstore.params.memoize.opts.invalidate_1_day_fs, "run")
          "curl -L" .. transf.string.single_quoted_escaped(url)
    end,
    in_cache_dir = function(url)
      return transf.not_userdata_or_function.in_cache_dir(url, "url")
    end,
    url_table = function(url)
      return memoize(parseGuessScheme)(url)
    end,
    scheme = function(url)
      return transf.url.url_table(url).scheme
    end,
    host = function(url)
      return transf.url.url_table(url).host
    end,
    sld_and_tld = function(url)
      return eutf8.match(transf.url.host(url), "(%w+%.%w+)$")
    end,
    sld = function(url)
      return eutf8.match(transf.url.host(url), "(%w+)%.%w+$") 
    end,
    tld = function(url)
      return eutf8.match(transf.url.host(url), "%w+%.(%w+)$")
    end,
    path = function(url)
      return transf.url.url_table(url).path
    end,
    query = function(url)
      return transf.url.url_table(url).query
    end,
    fragment = function(url)
      return transf.url.url_table(url).fragment
    end,
    port = function(url)
      return transf.url.url_table(url).port
    end,
    user = function(url)
      return transf.url.url_table(url).user
    end,
    password = function(url)
      return transf.url.url_table(url).password
    end,
    param_table = function(url)
      local params = {}
      local url_parts = stringy.split(url, "?")
      if #url_parts > 1 then
        local param_parts = stringy.split(url_parts[2], "&")
        for _, param_part in ipairs(param_parts) do
          local param_parts = stringy.split(param_part, "=")
          local key = param_parts[1]
          local value = param_parts[2]
          params[key] = transf.string.urldecoded(value)
        end
      end
      return params
    end,
    no_scheme = function(url)
      local parts = stringy.split(url, ":")
      table.remove(parts, 1)
      local rejoined = table.concat(parts, ":")
      return mustNotStart(rejoined, "//")
    end,
    vdirsyncer_pair_specifier = function(url)
      local name = "webcal_readonly_" .. transf.not_userdata_or_function.md5(url)
      local local_storage_path =  env.XDG_STATE_HOME .. "/vdirsyncer/" .. name
      return  {
        name = name,
        collections = "noquote:null",
        conflict_resolution = "b wins",
        local_storage_type = "filesystem",
        local_storage_path = local_storage_path,
        local_storage_fileext = ".ics",
        remote_storage_type = "http",
        remote_storage_url = url,
      }
    end,

  },
  whisper_url = {
    transcribed = function(url)
      local path = transf.url.in_cache_dir(url)
      dothis.url.download(url, path)
      return transf.audio_file.transcribed(path)

    end
  },
  image_url = {
    booru_url = function(url)
      return run(
        "saucenao --url" ..
        transf.string.single_quoted_escaped(url)
        .. "--output-properties booru-url"
      )
    end,
    hs_image = function(url)
      return memoize(hs.image.imageFromURL, refstore.params.memoize.opts.invalidate_1_week_fs, "hs.image.imageFromURL")(url)
    end,
    qr_data = function(url)
      local path = transf.url.in_cache_dir(url)
      dothis.url.download(url, path)
      return transf.image_file.qr_data(path)
    end,
    data_url = function(url)
      local ext = transf.path.extension(url)
      return memoize(hs.image.encodeAsURLString)(transf.image_url.hs_image(url), ext)
    end,
  },
  gpt_response_table = {
    response_text = function(result)
      local first_choice = result.choices[1]
      local response = first_choice.text or first_choice.message.content
      return stringy.strip(response)
    end
  },
  not_userdata_or_function = {
    md5 = function(thing)
      if type(thing) ~= "string" then 
        thing = json.encode(thing) 
      end
      local md5 = hashings("md5")
      md5:update(thing)
      return md5:hexdigest()
    end,
    in_cache_dir = function(data, type)
      return transf.string.in_cache_dir(
        transf.not_userdata_or_function.md5(data),
        type
      )
    end,
    in_tmp_dir = function(data, type)
      return transf.string.in_tmp_dir(
        transf.not_userdata_or_function.md5(data),
        type
      )
    end,
    single_quoted_escaped_json = function(t)
      return transf.string.single_quoted_escaped(json.encode(t))
    end,
  },
  mailto_url = {
   
    emails = function(mailto_url)
      local no_scheme = transf.url.no_scheme(mailto_url)
      local emails_part = stringy.split(no_scheme, "?")[1]
      local emails = stringy.split(emails_part, ",")
      return hs.fnutils.imap(emails, stringy.strip)
    end,
    first_email = function(mailto_url)
      return transf.mailto_url.emails(mailto_url)[1]
    end,
    subject = function(tel_url)
      return transf.url.param_table(tel_url).subject 
    end,
    body = function(tel_url)
      return transf.url.param_table(tel_url).body 
    end,
    cc = function(tel_url)
      return transf.url.param_table(tel_url).cc 
    end,

  },
  tel_url = {
    phone_number = function(tel_url)
      return transf.url.no_scheme(tel_url)
    end,
    
  },
  otpauth_url = {
    type = function(otpauth_url)
      return stringy.split(transf.url.no_scheme(otpauth_url), "/")[1]
    end,
    label = function(otpauth_url)
      local part = stringy.split(transf.url.no_scheme(otpauth_url), "/")[2]
      return stringy.split(part, "?")[1]
    end,
    
  },
  data_url = {
    content_type = function(data_url)
      return stringy.split(transf.url.no_scheme(data_url), ";")[1]
    end,
    header_part = function(data_url) -- the non-data part will either be separated from the rest of the url by `;,` or `;base64,`, so we need to split on `,`, then find the first part that ends `;` or `base64;`, and then join and return all parts before that part
      local parts = stringy.split(transf.url.no_scheme(data_url), ",")
      local non_data_part = ""
      for _, part in ipairs(parts) do
        non_data_part = non_data_part .. part
        if stringy.endswith(part, ";") or stringy.endswith(part, "base64;") then
          break
        else
          non_data_part = non_data_part .. ","
        end
      end
      return non_data_part
    end,
    payload_part = function(data_url)
      return mustNotStart(transf.url.no_scheme(data_url), transf.data_url.header_part(data_url))
    end,
      
    content_type_param_table = function(data_url)
      local parts = stringy.split(transf.data_url.header_part(data_url), ";")
      table.remove(parts, 1) -- this is the content type
      table.remove(parts, #parts) -- this is the base64, or ""
      return memoize(map)(parts, function(part)
        local kv = stringy.split(part, "=")
        return kv[1], kv[2]
      end, {"v", "kv"})
    end
  },
  source_id = {
    language = function(source_id)
      return slice(stringy.split(source_id, "."), -1, -1)[1]
    end,
  },
}
