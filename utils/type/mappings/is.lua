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
    end
    
  }
}