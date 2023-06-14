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
  #transf.string.lines(get.khard.list()) > 20 -- unlikely to be less than 20 contacts, since I'm just that popular
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
  {"test"}
)

assert(
  #get.upkg.package_managers() > 4 -- unlikely to be less than 4 package managers
)


dothis.upkg.install("test", "basic_pkg@1.2.3")
dothis.upkg.install("test", "missing_pkg")
dothis.upkg.backup("test")
dothis.upkg.install("test", "added_pkg")
dothis.upkg.remove("test", "missing_pkg")


assertMessage(
  get.upkg.backed_up_packages("test"),
  {"basic_pkg@1.2.3", "missing_pkg"}
)

assertMessage(
  get.upkg.missing_packages("test"),
  {"missing_pkg"}
)

assertMessage(
  get.upkg.added_packages("test"),
  {"added_pkg"}
)

assertMessage(
  get.upkg.difference_packages("test"),
  {"added_pkg", "missing_pkg"}
)

assertMessage(
  get.upkg.package_manager_version("test"),
  "1.0.0"
)

assertMessage(
  get.upkg.which_package_manager("test"),
  env.XDG_DATA_HOME .. "/upkg/test/packages"
)

assertValuesContain(
  get.upkg.package_managers_with_missing_packages(),
  {"test"}
)

assertMessage(
  get.upkg.list("test"),
  {"added_pkg", "basic_pkg@1.2.3"}
)

assertMessage(
  get.upkg.count("test"),
  2
)

assertMessage(
  get.upkg.list_version("test"),
  {"added_pkg@0.0.1", "basic_pkg@1.2.3"}
)

assertMessage(
  get.upkg.list_no_version("test"),
  {"added_pkg", "basic_pkg"}
)

assertMessage(
  get.upkg.list_version_package_manager("test"),
  {"test:added_pkg@0.0.1", "test:basic_pkg@1.2.3"}
)

assertMessage(
  get.upkg.list_with_package_manager("test"),
  {"test:added_pkg", "test:basic_pkg@1.2.3"}
)

assertMessage(
  get.upkg.with_version("test", "added_pkg"),
  {"added_pkg@0.0.1"}
)

assertMessage(
  get.upkg.with_version_package_manager("test", "added_pkg"),
  {"test:added_pkg@0.0.1"}
)

assertMessage(
  get.upkg.with_package_manager("test", "added_pkg"),
  {"test:added_pkg"}
)

assertMessage(
  get.upkg.which("test", "added_pkg"),
  {env.XDG_DATA_HOME .. "/upkg/test/packages/added_pkg@0.0.1"}
)
assertMessage(
  get.upkg.which("test", "basic_pkg"),
  {env.XDG_DATA_HOME .. "/upkg/test/packages/added_pkg@0.0.1@default"}
)

assertMessage(
  get.upkg.version("test", "added_pkg"),
  "0.0.1"
)

assertMessage(
  get.upkg.installed_package_manager("added_pkg"),
  {"test"}
)

assert(
  get.string_or_number.number(get.upkg.count("os")) > 50  -- 50 is a safe number to assume there are more than (at time of writing, 388)
)

assert(
  find(
    get.upkg.with_version("os", "mpv"),
    { _start = "mpv@" }
  )
)

assertValuesContain(
  get.upkg.which("os", "mpv"),
  {"/opt/homebrew/opt/mpv"}
)

assert(
  get.upkg.is_installed("os", "mpv")
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

dothis.pass.add_item("basic_test_data", "test", "basic_test")
dothis.pass.add_json({foo = "bar"}, "test", "json_test")
dothis.pass.add_password("password", "test_password_name")
dothis.pass.add_contact_data(1, "contact_test_type", "contact_test")

assertMessage(
  get.pass.value("test", "basic_test"),
  "basic_test_data"
)

assertMessage(
  get.pass.json("test", "json_test"),
  {foo = "bar"}
)

assertMessage(
  get.pass.contact_json("contact_test_type", "contact_test"),
  1
)

dothis.pass.edit("basic_test_data_edited", "test", "basic_test")

assertMessage(
  get.pass.value("test", "basic_test"),
  "basic_test_data_edited"
)

dothis.pass.rename("passw", "test_password_name", "test_password_name2")

assertMessage(
  get.pass.password("test_password_name"),
  nil
)

assertMessage(
  get.pass.password("test_password_name2"),
  "password"
)

dothis.pass.delete("test_password_name2")
dothis.pass.delete("test", "basic_test")
dothis.pass.delete("test", "json_test")
dothis.pass.delete("contacts/contact_test_type", "contact_test")

local current_default_audio_output = get.audiodevice_system.default("output")
local built_in_output = hs.audiodevice.findDeviceByName("Built-in Output")

dothis.audiodevice.set_default("Built-in Output", "output")

local now_default_audio_output = get.audiodevice_system.default("output")

assertMessage(
  get.audiodevice.name(now_default_audio_output),
  "Built-in Output"
)

assert(get.audiodevice.is_default(built_in_output, "output"))