is = {
  string = {
    package_manager = function(str)
      return find(transf.string.lines(
        memoize(run)("upkg list-package-managers")
      ), {_exactly = str})
    end,
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
      return get.string_or_number.number(str) ~= nil
    end,
    int_string = function(str)
      return is.string.number_string(str) and is.number.int(get.string_or_number.number(str))
    end,
    printable_ascii = function(str)
      return onig.find(str, transf.string.whole_regex(mt._r.charset.printable_ascii))
    end,
    ascii = function(str)
      return onig.find(str, transf.string.whole_regex(mt._r.charset.ascii))
    end,
    url = function(str)
      return is.string.ascii(str) and is.ascii.url(str)
    end,
  },
  ascii = {
    issn = function(str)
      return onig.find(str, transf.string.whole_regex(mt._r.id.issn))
    end,
    uuid = function(str)
      return onig.find(str, transf.string.whole_regex(mt._r.id.uuid), 1, "i")
    end,
    relay_identifier = function(str)
      return onig.find(str, transf.string.whole_regex(mt._r.id.relay_identifier))
    end,
    base32_gen = function(str)
      return onig.find(str, transf.string.whole_regex(mt._r.id.b32.gen))
    end,
    base32_crockford = function(str)
      return onig.find(str, transf.string.whole_regex(mt._r.id.b32.crockford))
    end,
    base64_gen = function(str)
      return onig.find(str, transf.string.whole_regex(mt._r.id.b64.gen))
    end,
    base64_url = function(str)
      return onig.find(str, transf.string.whole_regex(mt._r.id.b64.url))
    end,
    base32 = function(str)
      return is.ascii.base32_gen(str) or is.ascii.base32_crockford(str)
    end,
    base64 = function(str)
      return is.ascii.base64_gen(str) or is.ascii.base64_url(str)
    end,
    digit_string = function(str)
      return get.string_or_number.number(str, 16) ~= nil -- this may not return the correct value for non-hex strings, but that doesn't matter, we're only checking if it is a digit string of whatever kind, so what value exactly it returns doesn't matter
    end,
    indicated_digit_string = function(str)
      return 
        stringy.startswith(str, "0") and
        get.array.contains(transf.native_table_or_nil.key_array(tblmap.base_letter.base), str:sub(2, 2)) and
        is.ascii.digit_string(str:sub(3))
    end,
    potentially_indicated_digit_string = function(str)
      return is.ascii.indicated_digit_string(str) or is.ascii.digit_string(str)
    end,
    binary_string = function(str)
      return get.string_or_number.number(str, 2) ~= nil
    end,
    hex_string = function(str)
      return get.string_or_number.number(str, 16) ~= nil
    end,
    octal_string = function(str)
      return get.string_or_number.number(str, 8) ~= nil
    end,
    decimal_string = function(str)
      return get.string_or_number.number(str, 10) ~= nil
    end,

    indicated_binary_string = function(str)
      return stringy.startswith(str, "0b") and is.ascii.binary_string(str:sub(3))
    end,
    indicated_hex_string = function(str)
      return stringy.startswith(str, "0x") and is.ascii.hex_string(str:sub(3))
    end,
    indicated_octal_string = function(str)
      return stringy.startswith(str, "0o") and is.ascii.octal_string(str:sub(3))
    end,
    indicated_decimal_string = function(str)
      return stringy.startswith(str, "0d") and is.ascii.decimal_string(str:sub(3))
    end,
    potentially_indicated_binary_string = function(str)
      return is.ascii.indicated_binary_string(str) or is.ascii.binary_string(str)
    end,
    potentially_indicated_hex_string = function(str)
      return is.ascii.indicated_hex_string(str) or is.ascii.hex_string(str)
    end,
    potentially_indicated_octal_string = function(str)
      return is.ascii.indicated_octal_string(str) or is.ascii.octal_string(str)
    end,
    potentially_indicated_decimal_string = function(str)
      return is.ascii.indicated_decimal_string(str) or is.ascii.decimal_string(str)
    end,
    url = isUrl,

  },
  alphanum_minus = {
    isbn = function(str)
      return onig.find(transf.alphanum_minus.alphanum(str), transf.string.whole_regex(mt._r.id.isbn))
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
      return get.array.contains(mt._list.youtube.extant_upload_status, transf.youtube_video_id.upload_status(id))
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
    has_extension = function(path)
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
    volume = function(path)
      return stringy.startswith(path, "/Volumes/")
    end,
    path_with_intra_file_locator = function(path)
      return eutf8.find(transf.path.leaf(path), ":%d+$") ~= nil
    end,
    useless_file_leaf = function(path)
      return get.array.contains(mt._list.useless_files, transf.path.leaf(path))
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
      return pcall(run, "rclone ls " .. transf.string.single_quoted_escaped(path))
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
      return pcall(runJSON,{
        args = {"rclone", "lsjson", "--stat", {value = path, type = "quoted"}},
        key_that_contains_payload = "IsDir"
      })
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
      return get.extant_path.find_self_or_ancestor_sibling_with_leaf(path, ".git")
    end,
  },
  dir = {
    git_root_dir = function(path)
      return get.array.some_pass(
        transf.dir.children_filename_array(path),
        {_exactly = ".git"}
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
  },
  nonempty_dir = {
    grandparent_dir = function (path)
      return get.array.some_pass(
        transf.dir.children_absolute_path_array(path),
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
    plaintext_dictionary_file = function(path)
      return is.file.plaintext_file(path) and is.plaintext_file.plaintext_dictionary_file(path)
    end,
    playable_file = function (path)
      return get.path.usable_as_filetype(path, "audio") or get.path.usable_as_filetype(path, "video")
    end,
    shellscript_file = function(path)
      return get.path.usable_as_filetype(path, "shell-script") or get.file.find_contents(path, { _r = "^#!.*?(?:ba|z|fi|da|k|t?c)sh\\s+" })
    end,
    email_file = function(path)
      return 
       get.path.is_extension(path, "eml") or 
       transf.path.parent_leaf(path) == "new" or
       transf.path.parent_leaf(path == "cur")
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
    word =  function(str) 
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
      return get.extant_path.find_descendant_with_filename(env.MPASS, str)
    end,
  },
  url = {
    has_scheme = function(url)
      return onig.match(url, mt._r.url.scheme) ~= nil
    end,
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
    url_with_path = function(url)
      return transf.url.path(url) ~= nil
    end,

  },
  url_with_path = {
    owner_item_url = function(url)
      return #transf.owner_item_url.owner_item == 2
    end,
  },
  data_url = {
    base64_data_url = function(url)
      return stringy.endswith(transf.data_url.header_part(url), ";base64")
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
    pos = function(num)
      return num > 0
    end,
    neg = function(num)
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
    even = function(num)
      return num % 2 == 0
    end,
  },
  int = {
    even = function(num)
      return num % 2 == 0
    end,
  },
  any = {
    component_interface = function(val)
      return type(val) == "table" and val.is_interface == true
    end,
    number = function(val)
      return type(val) == "number"
    end,
    int = function(val)
      return is.any.number(val) and is.number.int(val)
    end,
    pos_int = function(val)
      return is.any.int(val) and is.number.pos(val)
    end,
    neg_int = function(val)
      return is.any.int(val) and is.number.neg(val)
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
    default = function(audiodevice_specifier)
      return get.audiodevice.is_default(audiodevice_specifier.device, audiodevice_specifier.subtype)
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
      for k, v in transf.native_table.key_value_stateless_iter(t) do
        return false
      end
      return true
    end,
    non_empty_table = function(t)
      return not is.table.empty_table(t)
    end,
    arraylike_by_keys = function(t)
      for k, v in transf.native_table.key_value_stateless_iter(t) do
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
      if t.isovtable then return false end
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
      return get.array.all_pass(
        array,
        is.any.string
      )
    end,
    array_of_arrays = function(array)
      return get.array.all_pass(
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
      return get.array.all_pass(
        array,
        is.string.path
      )
    end,
  },
  path_array = {
    absolute_path_array = function(array)
      return get.array.all_pass(
        array,
        is.path.absolute_path
      )
    end,
  },
  absolute_path_array = {
    extant_path_array = function(array)
      return get.array.all_pass(
        array,
        is.absolute_path.file
      )
    end,
  },
  extant_path_array = {
    dir_array = function(array)
      return get.array.all_pass(
        array,
        is.extant_path.dir
      )
    end,
    file_array = function(array)
      return get.array.all_pass(
        array,
        is.extant_path.file
      )
    end,
  },
  dir_array = {
    git_root_dir_array = function(array)
      return get.array.all_pass(
        array,
        is.dir.git_root_dir
      )
    end,
  },
  git_root_dir_array = {

  },
  file_array = {
    plaintext_file_array = function(array)
      return get.array.all_pass(
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
  }
}