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
    looks_like_path = function(str)
      return 
        str:find("/") ~= nil
        and str:find("[\n\t\r\f]") == nil
        and str:find("^%s") == nil
        and str:find("%s$") == nil
      end
  },
  uuid = {
    contact = function(uuid)
      local succ, res = pcall(transf.uuid.raw_contact, uuid)
      return succ 
    end,
  },
  youtube_video_id = {
    extant = function(id)
      return listContains(mt._list.youtube.extant_upload_status, transf.youtube_video_id.upload_status(id))
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
    
    playable_file = function (path)
      return get.path.usable_as_filetype(path, "audio") or get.path.usable_as_filetype(path, "video")
    end,
    shellscript_file = function(path)
      return testPath(path, {
        contents = { _r = "^#!.*?(?:ba|z|fi|da|k|t?c)sh\\s+" }
      }) or get.path.usable_as_filetype(path, "shell-script")
    end,
    has_extension = function(path)
      return transf.path.extension(path) ~= ""
    end,
    remote = function(path)
      return not not path:find("^[^/:]-:") 
    end,
    dir = bind(testPath, {a_use, "dir"}),
    file = bind(testPath, {a_use, "not-dir"}),
    exists = bind(testPath, {a_use, true}),
    empty_dir = function(path)
      return testPath(path, {
        dirness = "dir",
        contents = false
      })
    end,
    parent_dir = function (path)
      return testPath(path, {
        dirness = "dir",
        contents = true
      })
    end,
    tilde_absolute_path = function(path)
      return stringy.startswith(path, "~/")
    end,
    true_absolute_path = function(path)
      return stringy.startswith(path, "/")
    end,
    absolute_path = function(path)
      return is.path.tilde_absolute_path(path) or is.path.true_absolute_path(path)
    end,
    email_file = function(path)
     return 
      get.path.is_extension(path, "eml") or 
      transf.path.parent_leaf(path) == "new" or
      transf.path.parent_leaf(path == "cur")
    end
  },
  extant_path = {
    
  },
  dir = {
    git_root_dir = function(path)
      return get.array.some_pass(
        transf.dir.children_filenames_array(path),
        {_exactly = ".git"}
      )
    end,
    
    grandparent_dir = function (path)
      return get.array.some_pass(
        transf.dir.children_array(path),
        is.path.dir
      )
    end
  },
  in_git_dir = {
    has_changes = function(path)
      return transf.in_git_dir.status(path) ~= ""
    end,
    has_unpushed_commits = function(path)
      return #transf.in_git_dir.unpushed_commit_hash_list(path) > 0
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
  },
  url = {
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
  data_url = {
    base64 = function(url)
      return stringy.endswith(transf.data_url.header_part(url), ";base64")
    end,
  },
  media_type = {
    image = function(media_type)
      return stringy.startswith(media_type, "image/")
    end,
  },
  source_id = {
    active = function(source_id)
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
  },
  int = {
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
  },

}