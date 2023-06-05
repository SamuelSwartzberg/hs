

-- start out disconnected

local was_originally_connected = get.mullvad.connected()

if was_originally_connected then
  dothis.mullvad.disconnect()
end

assert(not get.mullvad.connected())

-- connect

dothis.mullvad.connect()

assert(get.mullvad.connected())

-- disconnect

dothis.mullvad.disconnect()

assert(not get.mullvad.connected())

-- toggle

dothis.mullvad.toggle()

assert(get.mullvad.connected())

dothis.mullvad.toggle()

assert(not get.mullvad.connected())

-- set relay

local original_relay = get.mullvad.relay()

assert(type(original_relay) == "string")

dothis.mullvad.relay_set("de-fra-wg-005")

assert(get.mullvad.relay() == "de-fra-wg-005")

-- return to original state

dothis.mullvad.relay_set(original_relay)
if was_originally_connected then
  dothis.mullvad.connect()
end

-- test upkg
-- upkg is async. however, the `mgr` `test` only does simple fileops (being the mock manager), so we can assume it's gonna be fairly fast. So we're gonna do batches of our mutations at once, then wait a second, and then check if they were successful.

dothis.upkg.remove("test", "test-pkg-001")
dothis.upkg.remove("test", "test-pkg-002")
dothis.upkg.remove("test", "test-pkg-003")
delete(env.MDEPENDENCIES .. "/test")

dothis.upkg.install("test", "test-pkg-001")
dothis.upkg.install("test", "test-pkg-002")
dothis.upkg.upgrade("test", "test-pkg-002")
dothis.upkg.upgrade_all("test")

dothis.upkg.backup("test")

-- wait a second

hs.timer.doAfter(1, function()
  assert(get.upkg.installed("test", "test-pkg-001"))
  assertMessage(get.upkg.version("test", "test-pkg-001"), "0.0.2")
  assertMessage(get.upkg.version("test", "test-pkg-002"), "0.0.3")
  assertMessage(
    get.upkg.backed_up_packages("test"),
    { "test-pkg-001", "test-pkg-002"}
  )
  dothis.upkg.install("test", "test-pkg-003")
  dothis.upkg.replace_backup("test")
  dothis.upkg.remove("test", "test-pkg-001")
  hs.timer.doAfter(1, function()
    assert(not get.upkg.installed("test", "test-pkg-001"))
    assert(get.upkg.installed("test", "test-pkg-003"))
    assertMessage(
      get.upkg.backed_up_packages("test"),
      { "test-pkg-001", "test-pkg-002", "test-pkg-003"}
    )
    dothis.upkg.install_missing("test")
    hs.timer.doAfter(1, function()
      assert(get.upkg.installed("test", "test-pkg-001"))
    end)

  end)
end)

-- test khal

-- make sure event doesn't exist yet

local baking_class_event = get.khal.search_event_tables("Baking class test event")

assert(#baking_class_event == 0)

-- create event

dothis.khal.add_event_from_file(env.MMOCK .. "/files/plaintext/ics/single_event.ics")

hs.timer.doAfter(1, function ()
  local baking_class_event = get.khal.search_event_tables("Baking class test event")
  assert(#baking_class_event == 1)
  assertMessage(baking_class_event[1].title, "Baking class test event")
  dothis.khal.delete_event("Baking class test event")
  hs.timer.doAfter(1, function ()
    local baking_class_event = get.khal.search_event_tables("Baking class test event")
    assert(#baking_class_event == 0)
    dothis.khal.add_event_from_url("file://" .. env.MMOCK .. "/files/plaintext/ics/single_event.ics")
    hs.timer.doAfter(1, function()
      local baking_class_event = get.khal.search_event_tables("Baking class test event")
      assert(#baking_class_event == 1)
      assertMessage(baking_class_event[1].title, "Baking class test event")
      dothis.khal.edit_event("Baking class test event") -- user will be prompted to edit the event
      alert("Edit the title of the event to 'Baking class test event edited'")
      hs.timer.doAfter(60, function()
        local baking_class_event = get.khal.search_event_tables("Baking class test event edited")
        assert(#baking_class_event == 1)
        assertMessage(baking_class_event[1].title, "Baking class test event edited")
        dothis.khal.delete_event("Baking class test event edited")
        hs.timer.doAfter(1, function ()
          local baking_class_event = get.khal.search_event_tables("Baking class test event edited")
          assert(#baking_class_event == 0)
          error("TODO add_event_from_specifier, add_event_interactive")
        end)
      end)
    end)
  end)

end)

error("TODO pandoc.markdown_to")

