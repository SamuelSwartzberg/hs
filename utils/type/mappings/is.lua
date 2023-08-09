is = {
  string = {
    potentially_phone_number = function(str)
      if #str > 16 then return false end
      local _, amount_of_digits = eutf8.gsub(str, "%d", "")
      local _, amount_of_non_digits = eutf8.gsub(str, "%D", "")
      local digit_non_digit_ratio = amount_of_digits / amount_of_non_digits
      return digit_non_digit_ratio > 0.5
    end,
    path = function(str)
      return 
        str:find("/") ~= nil
        and str:find("[\n\t\r\f]") == nil
        and str:find("^%s") == nil
        and str:find("%s$") == nil
    end,
    number_string = function(str)
      return get.string_or_number.number_or_nil(str) ~= nil
    end,
    int_string = function(str)
      return is.string.number_string(str) and is.number.int(get.string_or_number.number_or_nil(str))
    end,
   
    ascii_string = function(str)
      return onig.find(str, transf.string.whole_regex(mt._r.charset.ascii))
    end,
    alphanum_minus_underscore = function(str)
      return is.string.ascii_string(str) and is.ascii_string.alphanum_minus_underscore(str)
    end,
    url = function(str)
      return is.string.ascii_string(str) and is.printable_ascii_string.url(str)
    end,
    empty_string = function(str)
      return str == ""
    end,
    noempty_string = function(str)
      return not is.string.empty_string(str)
    end,
    line = function(str)
      return eutf8.find(str, "[\n\r]") == nil
    end,
    noncomment_line = function(str)
      return is.string.line(str) and is.line.noncomment_line(str)
    end,
  },
  line = {
    comment_line = function(str)
      return eutf8.find(str, "^%s*#") ~= nil
    end,
    noncomment_line = function(str)
      return not is.line.comment_line(str)
    end,
  },
  ascii_string = {
    printable_ascii_string = function(str)
      return onig.find(str, transf.string.whole_regex(mt._r.charset.printable_ascii))
    end,
    alphanum_minus_underscore = function(str)
      return is.ascii_string.printable_ascii_string(str) and is.printable_ascii_string.alphanum_minus_underscore(str)
    end,
  },
  printable_ascii_string = {
    base32_gen_string = function(str)
      return onig.find(str, transf.string.whole_regex(mt._r.id.b32.gen))
    end,
    base32_crock_string = function(str)
      return onig.find(str, transf.string.whole_regex(mt._r.id.b32.crockford))
    end,
    base64_gen_string = function(str)
      return onig.find(str, transf.string.whole_regex(mt._r.id.b64.gen))
    end,
    base64_url_string = function(str)
      return onig.find(str, transf.string.whole_regex(mt._r.id.b64.url))
    end,
    base32_string = function(str)
      return is.printable_ascii_string.base32_gen_string(str) or is.printable_ascii_string.base32_crock_string(str)
    end,
    base64_string = function(str)
      return is.printable_ascii_string.base64_gen_string(str) or is.printable_ascii_string.base64_url_string(str)
    end,
    number_string = function(str)
      return get.string_or_number.number_or_nil(str, 16) ~= nil -- this may not return the correct value for non-hex strings, but that doesn't matter, we're only checking if it is a digit string of whatever kind, so what value exactly it returns doesn't matter
    end,
    indicated_number_string = function(str)
      return 
        stringy.startswith(str, "0") and
        get.array.bool_by_contains(transf.table_or_nil.kt_array(tblmap.base_letter.base), str:sub(2, 2)) and
        is.printable_ascii_string.number_string(str:sub(3))
    end,
    potentially_indicated_number_string = function(str)
      return is.printable_ascii_string.indicated_number_string(str) or is.printable_ascii_string.number_string(str)
    end,
    binary_string = function(str)
      return get.string_or_number.number_or_nil(str, 2) ~= nil
    end,
    hex_string = function(str)
      return get.string_or_number.number_or_nil(str, 16) ~= nil
    end,
    octal_string = function(str)
      return get.string_or_number.number_or_nil(str, 8) ~= nil
    end,
    decimal_string = function(str)
      return get.string_or_number.number_or_nil(str, 10) ~= nil
    end,

    indicated_binary_string = function(str)
      return stringy.startswith(str, "0b") and is.printable_ascii_string.binary_string(str:sub(3))
    end,
    indicated_hex_string = function(str)
      return stringy.startswith(str, "0x") and is.printable_ascii_string.hex_string(str:sub(3))
    end,
    indicated_octal_string = function(str)
      return stringy.startswith(str, "0o") and is.printable_ascii_string.octal_string(str:sub(3))
    end,
    indicated_decimal_string = function(str)
      return stringy.startswith(str, "0d") and is.printable_ascii_string.decimal_string(str:sub(3))
    end,
    potentially_indicated_binary_string = function(str)
      return is.printable_ascii_string.indicated_binary_string(str) or is.printable_ascii_string.binary_string(str)
    end,
    potentially_indicated_hex_string = function(str)
      return is.printable_ascii_string.indicated_hex_string(str) or is.printable_ascii_string.hex_string(str)
    end,
    potentially_indicated_octal_string = function(str)
      return is.printable_ascii_string.indicated_octal_string(str) or is.printable_ascii_string.octal_string(str)
    end,
    potentially_indicated_decimal_string = function(str)
      return is.printable_ascii_string.indicated_decimal_string(str) or is.printable_ascii_string.decimal_string(str)
    end,
    url = isUrl,
    handle = function(str)
      return stringy.startswith(str, "@")
    end,
  },
  calendar_name = {
    writeable_calendar_name = function(name)
      return get.string.bool_not_startswith(name, "r-:")
    end,
  },
  alphanum_minus = {
    isbn = function(str)
      return onig.find(transf.alphanum_minus.alphanum(str), transf.string.whole_regex(mt._r.id.isbn))
    end,
    issn = function(str) 
      return onig.find(str, transf.string.whole_regex(mt._r.id.issn))
    end,
    uuid = function(str)
      return onig.find(str, transf.string.whole_regex(mt._r.id.uuid), 1, "i")
    end,
    relay_identifier = function(str)
      return onig.find(str, transf.string.whole_regex(mt._r.id.relay_identifier))
    end,
    
  },
  uuid = {
    contact = function(uuid)
      local succ, res = pcall(transf.uuid.raw_contact, uuid)
      return succ 
    end,
  },
  youtube_video_id = {
    extant = function(id)
      return get.array.bool_by_contains(mt._list.youtube.extant_upload_status, transf.youtube_video_id.upload_status(id))
    end,
    private = function(id)
      return transf.youtube_video_id.privacy_status(id) == "private"
    end,
    unavailable = function(id)
      return 
        not transf.youtube_video_id.extant(id) or
        transf.youtube_video_id.private(id)
    end,
  },
  path = {
    extension_path = function(path)
      return transf.path.extension(path) ~= ""
    end,
    remote_path = function(path)
      return is.remote_path.labelled_remote_path(path) -- future: or is.remote_path.url_remote_path(path)
    end,
    local_path = function(path)
      return not is.path.remote_path(path)
    end,
    absolute_path = function(path)
      return (
        is.path.remote_path(path) and is.remote_path.remote_absolute_path()
      ) or (
        is.path.local_path(path) and is.local_path.local_absolute_path()
      )
    end,
    extant_path = function(path)
      return is.path.absolute_path(path) and is.absolute_path.extant_path(path)
    end,
    path_with_intra_file_locator = function(path)
      return eutf8.find(transf.path.leaf(path), ":%d+$") ~= nil
    end,
    useless_file_leaf = function(path)
      return get.array.bool_by_contains(mt._list.useless_files, transf.path.leaf(path))
    end,
    not_useless_file_leaf = function(path)
      return not is.path.useless_file_leaf(path)
    end,
  },
  remote_path = {
    labelled_remote_path = function(path)
      return not not path:find("^[^/:]-:/") 
    end,
    -- url_remote_path = is.string.url,
    remote_absolute_path = transf["nil"]["true"] -- remote paths are always absolute
  },
  remote_absolute_path = {
    remote_extant_path = function(path)
      return is.labelled_remote_absolute_path.labelled_remote_extant_path(path)
    end,
  },
  labelled_remote_absolute_path = {
    labelled_remote_extant_path = function(path)
      return transf.string.bool_by_evaled_env_bash_success("rclone ls " .. transf.string.single_quoted_escaped(path))
    end,
  },
  remote_extant_path = {
    remote_dir = function(path)
      return is.labelled_remote_extant_path.labelled_remote_dir(path)
    end,
    remote_file = function(path)
      return not is.remote_extant_path.remote_dir(path)
    end,
  },
  labelled_remote_extant_path = {
    labelled_remote_dir = function(path)
      return get.string.not_userdata_or_function_or_nil_by_evaled_env_bash_parsed_json_in_key("rclone lsjson --stat" .. transf.string.single_quoted_escaped(path))
    end,
    labelled_remote_file = function(path)
      return not is.labelled_remote_extant_path.labelled_remote_dir(path)
    end,
  },
  labelled_remote_file = {
    empty_labelled_remote_file = function(path)
      local contents = transf.labelled_remote_file.contents(path)
      return contents == nil or contents == ""
    end,
    nonempty_labelled_remote_file = function(path)
      return not is.labelled_remote_file.empty_labelled_remote_file(path)
    end,
  },
  remote_file = {
    empty_remote_file = function(path)
      return is.labelled_remote_file.empty_labelled_remote_file(path)
    end,
    nonempty_remote_file = function(path)
      return is.labelled_remote_file.empty_labelled_remote_file(path)
    end,
  },
  labelled_remote_dir = {
    empty_labelled_remote_dir = function(path)
      return transf.labelled_remote_dir.children_absolute_path_value_stateful_iter(path)() == nil
    end,
    nonempty_labelled_remote_dir = function(path)
      return not is.labelled_remote_dir.empty_labelled_remote_dir(path)
    end,
  },
  remote_dir = {
    empty_remote_dir = function(path)
      return is.labelled_remote_dir.empty_labelled_remote_dir(path)
    end,
    nonempty_remote_dir = function(path)
      return not is.labelled_remote_dir.empty_labelled_remote_dir(path)
    end,
  },
  local_path = {
    local_absolute_path = function(path)
      return stringy.startswith(path, "/")
    end,
    local_nonabsolute_path = function(path)
      return not is.path.local_absolute_path(path)
    end,
  },

  local_absolute_path = {
    local_extant_path = function(path)
      local file = io.open(path, "r")
      pcall(io.close, file)
      return file ~= nil
    end,
    local_nonextant_path = function(path)
      return not is.path.local_extant_path(path)
    end,
    root_local_absolute_path = function(path)
      return path == "/"
    end,
    in_volume_local_absolute_path = function(path)
      return stringy.startswith(path, "/Volumes/")
    end,
    extant_volume_local_extant_path = function(path)
      return get.array.bool_by_contains(
        transf["nil"].non_root_volume_absolute_path_array(),
        path
      )
    end,
  },
  in_volume_local_absolute_path = {
    
  },
  extant_volume_local_extant_path = {
    
    dynamic_time_machine_extant_volume_local_extant_path = function(path)
      return stringy.startswith(
        path,
        "/Volumes/com.apple.TimeMachine.localsnapshots/Backups.backupdb/" .. get.fn.rt_or_nil_by_memoized(hs.host.localizedName)() .. "/" .. os.date("%Y-%m-%d-%H")
      )
    end,
    static_time_machine_extant_volume_local_extant_path = function(path)
      return path == env.TMBACKUPVOL .. "/"
    end
      
  },
  local_extant_path = {
    local_dir = function(path)
      return not not hs.fs.chdir(path)
    end,
    local_file = function(path)
      return not is.path.local_dir(path)
    end,
  },
  local_file = {
    empty_local_file = function(path)
      local contents =  transf.local_file.contents(path)
      return contents == nil or contents == ""
    end,
    nonempty_local_file = function(path)
      return not is.path.empty_local_file(path)
    end,
  },
  local_dir = {
    empty_local_dir = function(path)
      return transf.local_dir.children_absolute_path_value_stateful_iter(path)() == nil
    end,
    nonempty_local_dir = function(path)
      return not is.path.empty_local_dir(path)
    end,
  },
  absolute_path = {
    extant_path = function(path)
      return (
        is.path.remote_path(path) and is.remote_absolute_path.remote_extant_path(path)
      ) or (
        is.path.local_path(path) and is.local_absolute_path.local_extant_path(path)
      )
    end,
    nonextant_path = function(path)
      return not is.path.extant_path(path)
    end,
    dir = function(path)
      return is.absolute_path.file(path) and is.extant_path.dir(path)
    end,
    file = function(path)
      return is.absolute_path.file(path) and is.extant_path.file(path)
    end,
    nonempty_dir = function(path)
      return is.absolute_path.dir(path) and is.dir.nonempty_dir(path)
    end,
  
  },
  extant_path = {
    dir = function(path)
      return (
        is.path.remote_path(path) and is.remote_extant_path.remote_dir(path)
      ) or (
        is.path.local_path(path) and is.local_extant_path.local_dir(path)
      )
    end,
    file = function(path)
      return not is.extant_path.dir(path)
    end,
    in_git_dir = function(path)
      return get.extant_path.extant_path_by_self_or_ancestor_sibling_w_leaf(path, ".git")
    end,
  },
  dir = {
    git_root_dir = function(path)
      return get.array.bool_by_some_pass_w_t(
        transf.dir.children_filename_array(path),
        ".git"
      )
    end,
    empty_dir = function(path)
      return (
        is.path.remote_path(path) and is.remote_dir.empty_remote_dir(path)
      ) or (
        is.path.local_path(path) and is.local_dir.empty_local_dir(path)
      )
    end,
    nonempty_dir = function(path)
      return not is.dir.empty_dir(path)
    end,
    logging_dir = function(path)
      return stringy.endswith(transf.path.leaf(path), "_logs")
    end,
  },
  nonempty_dir = {
    grandparent_dir = function (path)
      return get.array.bool_by_some_pass_w_fn(
        transf.dir.absolute_path_array_by_children(path),
        is.absolute_path.dir
      )
    end,
  },
  in_git_dir = {
    has_changes = function(path)
      return transf.in_git_dir.status(path) ~= ""
    end,
    has_unpushed_commits = function(path)
      return #transf.in_git_dir.unpushed_commit_hash_list(path) > 0
    end,
  },
  file = {
    plaintext_file = function(path)
      error("TODO")
    end,
    image_file = function(path)
      return get.path.usable_as_filetype(path, "image")
    end,
    binary_file = function(path)
      return not is.file.plaintext_file(path)
    end,
    plaintext_dictionary_file = function(path)
      return is.file.plaintext_file(path) and is.plaintext_file.plaintext_dictionary_file(path)
    end,
    shellscript_file = function(path)
      return get.path.usable_as_filetype(path, "shell-script") 
      or onig.find(
        transf.file.contents(path),
        "^#!.*?(?:ba|z|fi|da|k|t?c)sh\\s+"
      )
    end,
    email_file = function(path)
      return 
       get.path.is_extension(path, "eml") or 
       transf.path.parent_leaf(path) == "new" or
       transf.path.parent_leaf(path == "cur")
     end,
  },
  binary_file = {
    db_file = function(path)
      return get.path.is_standartized_extension_in(
        path,
        mt._list.filetype["db"]
      )
    end,
    playable_file = function (path)
      return get.path.usable_as_filetype(path, "audio") or get.path.usable_as_filetype(path, "video")
    end,
  },
  playable_file = {
    whisper_file = function(path)
      return get.path.usable_as_filetype(path, "whisper-audio")
    end,
  },
  shellscript_file = {
    errors = function(path)
      return transf.shellscript_file.gcc_string_errors(path) ~= ""
    end,
    warnings = function(path)
      return transf.shellscript_file.gcc_string_warnings(path) ~= ""
    end,
  },
  plaintext_file = {
    plaintext_dictionary_file = function(path)
      get.path.is_standartized_extension_in(
        path,
        mt._list.filetype["plaintext-dictionary"]
      )
    end,
    plaintext_table_file = function(path)
      get.path.is_standartized_extension_in(
        path,
        mt._list.filetype["plaintext-table"]
      )
    end,
    m3u_file = function(path)
      return get.path.is_extension(path, "m3u")
    end,
    gitignore_file = function(path)
      return get.path.is_filename(path, ".gitignore")
    end,
    log_file = function(path)
      return get.path.is_extension(path, "log")
    end,
    newsboat_urls_file = function(path)
      return get.path.is_leaf(path, "urls")
    end,
    md_file = function(path)
      return get.path.is_standartized_extension(path, "md")
    end,
  },
  plaintext_dictionary_file = {
    yaml_file = get.fn.arbitrary_args_bound_or_ignored_fn(get.path.is_standartized_extension, {a_use, "yaml"}),
    json_file = get.fn.arbitrary_args_bound_or_ignored_fn(get.path.is_standartized_extension, {a_use, "json"}),
    toml_file = get.fn.arbitrary_args_bound_or_ignored_fn(get.path.is_standartized_extension, {a_use, "toml"}),
    ini_file = get.fn.arbitrary_args_bound_or_ignored_fn(get.path.is_standartized_extension, {a_use, "ini"}),
    ics_file = get.fn.arbitrary_args_bound_or_ignored_fn(get.path.is_standartized_extension, {a_use, "ics"}),
  },
  plaintext_table_file = {
    timestamp_first_column_plaintext_table_file = function(path)
      local line = get.plaintext_file.nth_line(path, 1)
      if not line then return false end
      local leading_number = eutf8.match(line, "^(%d+)%D")
      if leading_number and #leading_number < 11 then -- a unix timestamp will only be larger than 10 digits starting at 2286-11-20, at which point this code will need to be updated
        return true
      else
        return false
      end
    end
  },
  alphanum_minus_underscore = {
    package_manager_name = function(str)
      return get.array.bool_by_contains(transf["nil"].package_manager_name_array(), str)
    end,
    alphanum_underscore =  function(str) 
      return not string.find(str, "-")
    end,
    alphanum_minus = function(str)
      return not string.find(str, "_")
    end,
    youtube_video_id = function(str)
      return #str == 11 -- not officially specified, but b/c 64^11 > 2^64 > 64^10 and 64 chars in base64, allowing for billions of ids per living person, unlikely to change
    end,
    youtube_playlist_id = function(str)
      return stringy.startswith(str, "PL") and #str == 34
    end,
    youtube_channel_id = function(str)
      return stringy.startswith(str, "UC") and #str == 24
    end,
    pass_item_name = function(str)
      return get.extant_path.absolute_path_by_descendant_with_filename(env.MPASS, str)
    end,
  },
  url = {
    scheme_url = function(url)
      return onig.match(url, mt._r.url.scheme) ~= nil
    end,
    path_url = function(url)
      return transf.url.path(url) ~= nil
    end,
    authority_url = function(url)
      return transf.url.authority(url) ~= nil
    end,
    query_url = function(url)
      return transf.url.query(url) ~= nil
    end,

  },
  scheme_url = {
    mailto_url = function(url)
      return stringy.startswith(url, "mailto:")
    end,
    tel_url = function(url)
      return stringy.startswith(url, "tel:")
    end,
    otpauth_url = function(url)
      return stringy.startswith(url, "otpauth:")
    end,
    data_url = function(url)
      return stringy.startswith(url, "data:")
    end,
  },
  path_url = {
    owner_item_url = function(url)
      return #transf.owner_item_url.owner_item(url) == 2
    end,
    extension_url = function(url)
      return is.path.extension_path(transf.path_url.path(url))
    end,
    danbooru_style_post_url = function(url)
      return eutf8.find(transf.path_url.path(url), "^/posts/%d+/?$") ~= nil
    end,
    yandere_style_post_url = function(url)
      return eutf8.find(transf.path_url.path(url), "^/post/show/%d+/?$") ~= nil
    end,
  },
  query_url = {
    gelbooru_style_post_url = function(url)
      local paramtbl = transf.url.param_table(url)
      return is.any.int_string(paramtbl["id"]) and paramtbl["page"] == "post"
    end
  },
  extension_url = {

  },
  authority_url = {
    host_url = function(url)
      return transf.url.host(url) ~= nil
    end,
  },
  host_url = {
    booru_url = function(url)
      return get.array.bool_by_contains(mt._list.url.booru, transf.host_url.host(url))
    end,
    youtube_url = function(url)
      return transf.host_url.host(url) == "youtube.com"
    end,
  },
  booru_url = {
    danbooru_url = function(url)
      return transf.url.host(url) == "danbooru.donmai.us"
    end,
    gelbooru_url = function(url)
      return transf.url.host(url) == "gelbooru.com"
    end,
    safebooru_url = function(url)
      return transf.url.host(url) == "safebooru.org"
    end,
  },
  youtube_url = {
    youtube_video_url = function(url)
      return transf.path_url.initial_path_component(url) == "watch"
    end,
    youtube_playlist_url = function(url)
      return transf.path_url.initial_path_component(url) == "playlist"
    end,
    youtube_playable_url = function(url)
      return is.youtube_url.youtube_video_url(url) or is.youtube_url.youtube_playlist_url(url)
    end,
  },
  data_url = {
    base64_data_url = function(url)
      return stringy.endswith(transf.data_url.header_part(url), ";base64")
    end,
    image_data_url = function(url)
      return  s.media_type.image_media_type(transf.data_url.content_type(url))
    end,
  },
  media_type = {
    image_media_type = function(media_type)
      return stringy.startswith(media_type, "image/")
    end,
  },
  source_id = {
    active_source_id = function(source_id)
      return hs.keycodes.currentSourceID() == source_id
    end,
  },
  number = {
    pos_number = function(num)
      return num > 0
    end,
    neg_number = function(num)
      return num < 0
    end,
    zero = function(num)
      return num == 0
    end,
    int = function(num)
      return math.floor(num) == num 
    end,
    float = function(num)
      return not is.number.int(num)
    end,
    even_number = function(num)
      return num % 2 == 0
    end,
  },
  int = {
    even_int = function(num)
      return num % 2 == 0
    end,
    pos_int = function(num)
      return num > 0
    end,
    timestamp_s = transf["nil"]["true"](), -- all integers are valid timestamps (s)
    timestamp_ms = transf["nil"]["true"](), -- all integers are valid timestamps (ms)
  },
  timestamp_s = {
    reasonable_timestamp_s = function(num)
      return num > 1e7 and num < 1e10
    end,
  },
  timestamp_ms = {
    reasonable_timestamp_ms = function(num)
      return num > 1e10 and num < 1e13
    end,
  },
  pos_int = {
    
  },
  any = {
    fn = function(val)
      return type(val) == "function"
    end,
    number = function(val)
      return type(val) == "number"
    end,
    int = function(val)
      return is.any.number(val) and is.number.int(val)
    end,
    pos_int = function(val)
      return is.any.int(val) and is.number.pos_number(val)
    end,
    neg_int = function(val)
      return is.any.int(val) and is.number.neg_number(val)
    end,
    float = function(val)
      return is.any.number(val) and is.number.float(val)
    end,
    string = function(val)
      return type(val) == "string"
    end,
    table = function(val)
      return type(val) == "table"
    end,
    primitive = function(val)
      return not is.any.table(val)
    end,
    arraylike = function(val)
      return is.any.table(val) and is.table.arraylike(val)
    end,
    array = function(val)
      return is.any.table(val) and is.table.arraylike(val) and is.arraylike.array(val)
    end,
    pair = function(val)
      return is.any.array(val) and is.array.pair(val)
    end,
    non_empty_table_array = function(val)
      return is.any.table(val) and is.table.non_empty_table(val) and is.table.arraylike(val) and is.arraylike.array(val)
    end,
    is_interface = function(val)
      return 
        is.any.table(val) and
        is.table.interface(val)
    end,
    is_not_interface = function(val)
      return not is.any.is_interface(val)
    end,
    stream_created_item_specifier = function(val)
      return is.any.table(val) and is.table.stream_created_item_specifier(val)
    end,
    empty_table = function(val)
      return is.any.table(val) and is.table.empty_Table(val)
    end,
  },
  pass_item_name = {
    passw_pass_item_name = function(name)
      return get.pass_item_name.exists_as(name, "passw")
    end,
    username_pass_item_name = function(name)
      return get.pass_item_name.exists_as(name, "username", "txt")
    end,
    recovery_pass_item_name = function(name)
      return get.pass_item_name.exists_as(name, "recovery")
    end,
    otp_pass_item_name = function(name)
      return get.pass_item_name.exists_as(name, "otp")
    end,
    secq_pass_item_name = function(name)
      return get.pass_item_name.exists_as(name, "secq")
    end,
    login_pass_item_name = function(name)
      return 
        is.pass_item_name.passw_pass_item_name(name) or
        is.pass_item_name.username_pass_item_name(name) or
        is.pass_item_name.recovery_pass_item_name(name) or
        is.pass_item_name.otp_pass_item_name(name) or
        is.pass_item_name.secq_pass_item_name(name)
    end,


  },
  mac_application_name = {
    running = function(name)
      return get.mac_application_name.running_application(name) ~= nil
    end,
  },
  audiodevice_specifier = {
    active_audiodevice_specifier = function(audiodevice_specifier)
      return get.audiodevice.is_active_audiodevice_specifier(audiodevice_specifier.device, audiodevice_specifier.subtype)
    end,
  },
  csl_table = {
    type_whole_book = function(csl_table)
      return csl_table.type == "book" or csl_table.type == "monograph"
    end,
    type_book_chapter = function(csl_table)
      return csl_table.type == "chapter"
    end,
    whole_book = function(csl_table)
      return is.csl_table.type_whole_book(csl_table) and not csl_table.chapter and not csl_table.pages
    end
  },
  two_anys = {
    a_larger = function(a, b)
      return a > b
    end,
    b_larger = function(a, b)
      return a < b
    end,
    a_larger_as_string = function(a, b)
      return tostring(a) > tostring(b)
    end,
    b_larger_as_string = function(a, b)
      return tostring(a) < tostring(b)
    end,
    equal = function(a, b)
      return a == b
    end,
  },
  table = {
    created_item_specifier = function(t)
      return
        t.created_item and t.creation_specifier
    end,
    date = function(t)
      return type(t.addyears) == "function" -- arbitrary prop of date object
    end,
    native_table = function(t)
      return not t.isovtable
    end,
    empty_table = function(t)
      for k, v in transf.table.key_value_stateless_iter(t) do
        return false
      end
      return true
    end,
    non_empty_table = function(t)
      return not is.table.empty_table(t)
    end,
    arraylike_by_keys = function(t)
      for k, v in transf.table.key_value_stateless_iter(t) do
        if type(k) ~= "number" then return false end
      end
      return true
    end,
    non_empty_table_arraylike_by_keys = function(t)
      return is.table.non_empty_table(t) and is.table.arraylike_by_keys(t)
    end,
    arraylike = function(t)
      if t.isarr then return true end -- signal value to indicate that this is a list
      if t.isassoc then return false end -- signal value to indicate that this is an assoc table
      return is.table.arraylike_by_keys(t)
    end,
    non_arraylike = function(t)
      return not is.table.arraylike(t)
    end,
    array = function (t)
      return is.table.arraylike(t) and is.arraylike.array(t)
    end,
    hole_y_arraylike = function (t)
      return is.table.arraylike(t) and is.arraylike.hole_y_arraylike(t)
    end,
    empty_unspecified_table = function(t)
      if t.isovtable then return false end
      if t.isarr then return false end
      if t.isassoc then return false end
      return is.any.empty_table(t)
    end
  },
  arraylike = {
    --- an empty arraylike is never a hole_y_arraylike and always an array
    hole_y_arraylike = function(arraylike)
      if #arraylike == 0 then return false end
      for i = 1, #arraylike do
        if arraylike[i] == nil then return true end
      end
      return false
    end,
    array = function(arraylike)
      return not is.arraylike.hole_y_arraylike(arraylike)
    end,
  },
  assoclike = {

  },
  hole_y_arraylike = {

  },
  array = {
    empty_table_array = function(array)
      return #array == 0
    end,
    non_empty_table_array = function(array)
      return #array > 0
    end,
    string_array = function(array)
      return get.array.bool_by_all_pass_w_fn(
        array,
        is.any.string
      )
    end,
    array_of_arrays = function(array)
      return get.array.bool_by_all_pass_w_fn(
        array,
        is.any.array
      )
    end,
    pair = function(array)
      return #array == 2
    end,
  },
  string_array = {
    path_array = function(array)
      return get.array.bool_by_all_pass_w_fn(
        array,
        is.string.path
      )
    end,
  },
  path_array = {
    absolute_path_array = function(array)
      return get.array.bool_by_all_pass_w_fn(
        array,
        is.path.absolute_path
      )
    end,
    remote_path_array = function(array)
      return get.array.bool_by_all_pass_w_fn(
        array,
        is.path.remote_path
      )
    end,
    local_path_array = function(array)
      return get.array.bool_by_all_pass_w_fn(
        array,
        is.path.local_path
      )
    end,
  },
  absolute_path_array = {
    extant_path_array = function(array)
      return get.array.bool_by_all_pass_w_fn(
        array,
        is.absolute_path.file
      )
    end,
  },
  extant_path_array = {
    dir_array = function(array)
      return get.array.bool_by_all_pass_w_fn(
        array,
        is.extant_path.dir
      )
    end,
    file_array = function(array)
      return get.array.bool_by_all_pass_w_fn(
        array,
        is.extant_path.file
      )
    end,
  },
  dir_array = {
    git_root_dir_array = function(array)
      return get.array.bool_by_all_pass_w_fn(
        array,
        is.dir.git_root_dir
      )
    end,
  },
  git_root_dir_array = {

  },
  file_array = {
    plaintext_file_array = function(array)
      return get.array.bool_by_all_pass_w_fn(
        array,
        is.file.plaintext_file
      )
    end,
  },
  mpv_ipc_socket_id = {
    alive = function(mpv_ipc_socket_id)
      return get.ipc_socket_id.response_table_or_nil(mpv_ipc_socket_id, {
        command = {"get_property", "pid"}
      }) ~= nil
    end,
  },
  created_item_specifier = {
    stream_created_item_specifier = function(t)
      return
        t.inner_item.ipc_socket_id ~= nil
    end,
    fireable_created_item_specifier = function(t)
      return t.creation_specifier.fn ~= nil
    end,
  },
  stream_created_item_specifier = {
    alive = function(stream_created_item_specifier)
      return is.mpv_ipc_socket_id.alive(stream_created_item_specifier.inner_item.ipc_socket_id)
    end,
  },
  input_spec = {
    declared_click_input_spec = function(input_spec)
      return input_spec.mode == "click"
    end,
    declared_key_input_spec = function(input_spec)
      return input_spec.mode == "key"
    end,
    declared_move_input_spec = function(input_spec)
      return input_spec.mode == "move"
    end,
    declared_scroll_input_spec = function(input_spec)
      return input_spec.mode == "scroll"
    end,
    declared_position_change_input_spec = function(input_spec)
      return is.input_spec.declared_move_input_spec(input_spec) or is.input_spec.declared_scroll_input_spec(input_spec)
    end,
  }
}