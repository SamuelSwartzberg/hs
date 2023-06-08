assert(
  findsingle(
    get.mullvad.status(),
    {
      _r = "[cC]onnected"
    }
  )
)

assert(
  type(get.mullvad.connected()) == "boolean"
)

assert(
  type(get.mullvad.relay_list_raw()) == "string"
)

assert(
  #get.mullvad.relay_list_raw() > 100
)

assert(
  type(get.mullvad.flat_relay_array()) == "table"
)

assert(
  not find(
    get.mullvad.flat_relay_array(),
    { _r = whole(mt._r.id.relay_identifier), _invert = true }
  )
)

assert(
  type(get.khard.list()) == "string"
)

assert(
  #lines(get.khard.list()) > 20 -- unlikely to be less than 20 contacts, since I'm just that popular
)

assert(
  not find(
    get.khard.all_contact_uids(),
    { _r = whole(mt._r.id.contact_uid), _invert = true }
  )
)

local all_contact_tables = get.khard.all_contact_tables()
local all_contact_uuids_remapped = map(
  all_contact_tables,
  { _k ="uid"}
)

assert(
  not find(
    all_contact_uuids_remapped,
    { _r = whole(mt._r.id.contact_uid), _invert = true }
  )
)

assertValuesContain(
  get.upkg.package_managers(),
  {"pip"}
)

assert(
  #get.upkg.package_managers() > 4 -- unlikely to be less than 4 package managers
)

assertValuesContain(
  get.upkg.array.backed_up_packages("os"),
  {"mpv"}
)

assert(
  type(get.upkg.array.missing_packages("os")) == "table"
)
assert(
  type(get.upkg.array.added_packages("os")) == "table"
)
assert(
  type(get.upkg.array.difference_packages("os")) == "table"
)

assertValuesContain(
  get.upkg.array.list("os"),
  {"mpv"}
)

assert(
  find(
    get.upkg.array.version("os"),
    { _start = "1." } -- there will always be some package with a version starting with 1., so this is a safe test
  )
)

assert(
  tonumber(get.upkg.array.count("os")) > 50  -- 50 is a safe number to assume there are more than (at time of writing, 388)
)

assert(
  find(
    get.upkg.array.with_version("os", "mpv"),
    { _start = "mpv@" }
  )
)

assertValuesContain(
  get.upkg.array.which("os", "mpv"),
  {"/opt/homebrew/opt/mpv"}
)

assert(
  get.upkg.array.is_installed("os", "mpv")
)

local khal_calendars = get.khal.all_calendars()

assert( isList(khal_calendars))

assert(
  not find(
    khal_calendars,
    {_type = "string", _invert = true}
  )
)

local writeable_calendars = get.khal.writeable_calendars()

assert( isList(writeable_calendars))

assert(
  not find(
    writeable_calendars,
    {_start = "r-:", _invert = true}
  )
)

assertMessage(
  get.khal.parseable_format_specifier(),
  "{uid}Y:z:Y{calendar}Y:z:Y{start}Y:z:Y{title}Y:z:Y{description}Y:z:Y{location}Y:z:Y{end}Y:z:Y{url}__ENDOFRECORD5579__"
)

assertMessage(
  get.khal.basic_command_parts({"foo"}),
  "--format={uid}Y:z:Y{calendar}Y:z:Y{start}Y:z:Y{title}Y:z:Y{description}Y:z:Y{location}Y:z:Y{end}Y:z:Y{url}__ENDOFRECORD5579__ --include-calendar foo"
)

assertMessage(
  get.khal.basic_command_parts({"foo", "bar"}),
  "--format={uid}Y:z:Y{calendar}Y:z:Y{start}Y:z:Y{title}Y:z:Y{description}Y:z:Y{location}Y:z:Y{end}Y:z:Y{url}__ENDOFRECORD5579__ --include-calendar foo --include-calendar bar"
)

assertMessage(
  get.khal.basic_command_parts(nil, {"baz", "moop"}),
  "--format={uid}Y:z:Y{calendar}Y:z:Y{start}Y:z:Y{title}Y:z:Y{description}Y:z:Y{location}Y:z:Y{end}Y:z:Y{url}__ENDOFRECORD5579__ --exclude-calendar baz --exclude-calendar moop"
)

assertMessage(
  get.khal.basic_command_parts({"foo", "yui"}, {"baz", "moop"}),
  "--format={uid}Y:z:Y{calendar}Y:z:Y{start}Y:z:Y{title}Y:z:Y{description}Y:z:Y{location}Y:z:Y{end}Y:z:Y{url}__ENDOFRECORD5579__ --include-calendar foo --include-calendar yui --exclude-calendar baz --exclude-calendar moop"
)

assertMessage(
  get.khal.search_event_tables("basic test event in past", {"testcalendar"})[1].title,
  "basic test event in past"
)

assertMessage(
  get.khal.search_event_tables("basic test event in past", nil, {"testcalendar"})[1],
  nil
)

assertMessage(
  get.khal.search_event_tables("nonextant test event may not exist", {"testcalendar"})[1],
  nil
)

assertMessage(
  get.khal.list_event_tables({
    start = "1960-01-01",
    ["end"] = "1980-01-01"
  }, {"testcalendar"})[1].title,
  "Testevent Unix Epoch 1 hour"
)

local templ = get.khal.calendar_template_empty()
local templ2 = get.khal.calendar_template_empty()

assert(
  templ ~= templ2
)

assertMessage(
  templ.alarms.comment,
  "array of alarms as deltas"
)

assertValuesContain(
  get.pandoc.full_md_extension_set(),
  {"citations", "definition_lists", "fenced_code_blocks", "footnotes"} -- sample of extensions that should be present
)