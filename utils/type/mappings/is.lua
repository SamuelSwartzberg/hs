is = {
  string = {
    package_manager = function(str)
      return find(lines(
        memoize(run)("upkg list-package-managers")
      ), {_exactly = str})
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
    end
    
  },
  alphanum_minus_underscore = {
    word =  function(str) 
      return not string.find(str, "-")
    end,
    alphanum_minus = function(str)
      return not string.find(str, "_")
    end,
    youtube_id = function(str)
      return #str == 11 -- not officially specified, but b/c 64^11 > 2^64 > 64^10 and 64 chars in base64, allowing for billions of ids per living person, unlikely to change
    end,
    youtube_channel_id = function(str)
      return #str == 24 -- standartized length
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
  }
}