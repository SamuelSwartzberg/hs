is = {
  string = {
    package_manager = function(str)
      return find(lines(
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
    usable_as_filetype = function(path, filetype)
      path = transf.string.path_resolved(path)
      local extension = pathSlice(path, "-1:-1", { ext_sep = true, standartize_ext = true })[1]
      if find(mt._list.filetype[filetype], extension) then
        return true
      else
        return false
      end
    end,
    playable_file = function (path)
      return is.path.usable_as_filetype(path, "audio") or is.path.usable_as_filetype(path, "video")
    end,
    has_extension = function(path)
      return transf.path.extension(path) ~= ""
    end,
    remote = function(path)
      return not not path:find("^[^/:]-:") 
    end,
    git_root_dir = function(path)
      return find(itemsInPath({
        path = path,
        recursion = false,
        validator = returnTrue
      }), {_stop = ".git"})
    end,
    
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
  any = {
    component_interface = function(val)
      return type(val) == "table" and val.is_interface == true
    end,
  }
}