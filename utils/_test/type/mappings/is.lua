assert(
  is.string.package_manager("os")
)

assert(
  not is.string.package_manager("not a package manager")
)

assert(
  is.uuid.contact("a615b162-a203-4a24-a392-87ba3a7ca80c")
)

assert(
  not is.uuid.contact(mt._exactly.null_uuid)
)

-- Test 1: Positive test for plaintext-table
local test1 = is.path.usable_as_filetype("example.csv", "plaintext-table")
assertMessage(test1, true)

-- Test 2: Negative test for plaintext-table
local test2 = is.path.usable_as_filetype("example.txt", "plaintext-table")
assertMessage(test2, false)

-- Test 3: Positive test for plaintext-dictionary
local test3 = is.path.usable_as_filetype("example.json", "plaintext-dictionary")
assertMessage(test3, true)

-- Test 4: Negative test for plaintext-dictionary
local test4 = is.path.usable_as_filetype("example.md", "plaintext-dictionary")
assertMessage(test4, false)

local probably_extant_public_video_id = "Y7dpJ0oseIA"
local probably_extant_unlisted_video_id = "Yw5VKpuv5JE"
local probably_extant_private_video_id = "b9vIpu0kAbE"
local deleted_video_id = "JaxUqFJ3JT4"

assert(
  is.youtube_video_id.extant(probably_extant_public_video_id)
)

assert(
  is.youtube_video_id.extant(probably_extant_unlisted_video_id)
)

assert(
  is.youtube_video_id.extant(probably_extant_private_video_id)
)

assert(
  not is.youtube_video_id.extant(deleted_video_id)
)

assert(
  not is.youtube_video_id.private(probably_extant_public_video_id)
)

assert(
  not is.youtube_video_id.private(probably_extant_unlisted_video_id)
)

assert(
  is.youtube_video_id.private(probably_extant_private_video_id)
)

assert(
  not is.youtube_video_id.private(deleted_video_id)
)

assert(
  not is.youtube_video_id.unavailable(probably_extant_public_video_id)
)

assert(
  not is.youtube_video_id.unavailable(probably_extant_unlisted_video_id)
)

assert(
  is.youtube_video_id.unavailable(probably_extant_private_video_id)
)

assert(
  is.youtube_video_id.unavailable(deleted_video_id)
)

assert(
  is.path.playable_file("/foo/example.mp3")
)

assert(
  is.path.playable_file("/foo/example.wav")
)

assert(
  is.path.playable_file("example.mov")
)

assert(
  not is.path.playable_file("example")
)

assert(
  is.alphanum_minus_underscore.word("foo_bar")
)

assert(
  not is.alphanum_minus_underscore.word("foo-bar")
)

assert(
  is.alphanum_minus_underscore.alphanum_minus("foo-bar")
)

assert(
  not is.alphanum_minus_underscore.alphanum_minus("foo_bar")
)

assert(
  is.alphanum_minus_underscore.youtube_video_id("Y7dpJ0oseIA")
)

assert(
  not is.alphanum_minus_underscore.youtube_video_id("PLJicmE8fK0EgWJTaILL9k6D9B9FEo5EiP")
)

assert(
  is.alphanum_minus_underscore.youtube_playlist_id("PLJicmE8fK0EgWJTaILL9k6D9B9FEo5EiP")
)

assert(
  not is.alphanum_minus_underscore.youtube_playlist_id("Y7dpJ0oseIA")
)

assert(
  is.alphanum_minus_underscore.youtube_channel_id("UCJicmE8fK0EgWJTaILL9k6D9B9FEo5EiP")
)

assert(
  not is.alphanum_minus_underscore.youtube_channel_id("Y7dpJ0oseIA")
)

assert(
  is.url.mailto_url("mailto:someone@example.com?subject=This%20is%20the%20subject&cc=someone_else@example.com&body=This%20is%20the%20body")
)

assert(
  not is.url.mailto_url("https://example.com")
)

assert(
  is.url.tel_url("tel:+1-555-555-5555")
)

assert(
  not is.url.tel_url("https://example.com")
)

assert(
  is.url.otpauth_url("otpauth://totp/Test%20Issuer%3ATest%20Account?secret=12345678901234567890&issuer=Test%20Issuer")
)

assert(
  not is.url.otpauth_url("https://example.com")
)