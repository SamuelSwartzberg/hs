

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
          local tme = os.time()
          dothis.khal.add_event_from_specifier({
            calendar = "testcalendar",
            location = "testlocation",
            url = "https://example.com/testcalendar/testevent",
            start = "2020-01-01T00:00:00",
            ["end"] = "2020-01-01T01:00:00",
            title = "testevent"  .. tme,
            description = "testdescription",
            do_after = function ()
              local event_table = get.khal.search_event_tables("testevent" .. tme)[1]
              assertMessage(event_table.title, "testevent" .. tme)
              assertMessage(event_table.description, "testdescription")
              assertMessage(event_table.location, "testlocation")
              assertMessage(event_table.url, "https://example.com/testcalendar/testevent")
              assertMessage(event_table.start, "2020-01-01T00:00:00")
              assertMessage(event_table["end"], "2020-01-01T01:00:00")
              dothis.khal.delete_event("testevent" .. tme)
              hs.timer.doAfter(1, function ()
                error("TODO add_event_interactive")
                alert("Just save the event and close the window")
                dothis.khal.add_event_interactive({
                  calendar = "testcalendar",
                  location = "testlocation",
                  url = "https://example.com/testcalendar/testevent",
                  start = "2021-01-01T00:00:00",
                  ["end"] = "2021-01-01T01:00:00",
                  title = "interactive "  .. tme,
                  description = "testdescription",
                  do_after = function()
                    local event_table = get.khal.search_event_tables("interactive " .. tme)[1]
                    assertMessage(event_table.title, "interactive " .. tme)
                    assertMessage(event_table.description, "testdescription")
                    assertMessage(event_table.location, "testlocation")
                    assertMessage(event_table.url, "https://example.com/testcalendar/testevent")
                    assertMessage(event_table.start, "2021-01-01T00:00:00")
                    assertMessage(event_table["end"], "2021-01-01T01:00:00")
                    dothis.khal.delete_event("interactive " .. tme)

                  end
                })
              end)
            end
          })
        end)
      end)
    end)
  end)

end)

local test_md_file = env.MMOCK .. "/files/plaintext/md/full_pandoc.md"

dothis.pandoc.markdown_to(test_md_file, "html", nil, function(res)
  -- Check if Heading 1 is correctly converted
  assert(stringy.find(res, '<h1 id="sec1" class="section">Heading 1</h1>'))

  -- Check if Heading 2 is correctly converted
  assert(stringy.find(res, '<h2 class="subsection">Heading 2</h2>'))

  -- Check if italic is correctly converted
  assert(stringy.find(res, '<em>markdown</em>'))

  -- Check if bold is correctly converted
  assert(stringy.find(res, '<strong>extensions</strong>'))

  -- Check if strikeout is correctly converted
  assert(stringy.find(res, '<s>text like this</s>'))

  -- Check if subscript is correctly converted
  assert(stringy.find(res, 'H<sub>2</sub>O'))

  -- Check if superscript is correctly converted
  assert(stringy.find(res, 'E=mc<sup>2</sup>'))

  -- Check if highlight is correctly converted
  assert(stringy.find(res, '<mark>important text</mark>'))

  -- Check if emoji is correctly converted
  assert(stringy.find(res, 'emojis &#x1F604;')) -- Unicode for :smile:

  -- Check if link is correctly converted
  assert(stringy.find(res, '<a href="https://google.com">Regular link</a>'))

  -- Check if autolink bare URIs is correctly converted
  assert(stringy.find(res, '<a href="https://google.com">https://google.com</a>'))

  -- Check if inline code is correctly converted
  assert(stringy.find(res, '<code>print("hello world")</code>'))

  -- Check if escaped characters are correctly converted
  assert(stringy.find(res, '&lt;literal spans&gt;'))
  assert(stringy.find(res, '*literal asterisks*'))

  -- Check if raw code block is correctly converted
  assert(stringy.find(res, '<pre><code>function hello(name)'))

  -- Check if highlighted code block is correctly converted
  assert(stringy.find(res, '<pre class="lua"><code>function hello(name)'))
  assert(stringy.find(res, '<pre><code>def hello(name)'))
  assert(stringy.find(res, '<pre class="python"><code>def hello(name)'))
  assert(stringy.find(res, '<pre class="python example"><code>def hello(name)'))
  assert(stringy.find(res, '<pre class="python"><code>def hello(name)'))

  -- Check if hard line breaks are correctly converted
  assert(stringy.find(res, 'Lorem ipsum dolor sit amet,<br/>'))

  -- Check if ordered list is correctly converted
  assert(stringy.find(res, '<ol><li>First item</li>'))

  -- Check if example list is correctly converted

  assert(stringy.find(res, '<p id="example-1">(1) Proposition: With example_lists we can do that.'))
  assert(stringy.find(res, '<p id="example-2">(2) Proof: By example.'))
  assert(stringy.find(res, '<p id="example-3">(3) Q.E.D.</p>'))
  assert(stringy.find(res, '<p id="example-4">(4) SO FUN!</p>'))
  assert(stringy.find(res, 'Via (1), (2) we have shown that example_lists are awesome.'))

  -- Check if task list is correctly converted
  assert(stringy.find(res, '<li><input disabled="" type="checkbox">Unchecked</li>'))
  assert(stringy.find(res, '<li><input checked="" disabled="" type="checkbox">Checked</li>'))
  assert(stringy.find(res, '<li><input checked="" disabled="" type="checkbox">yay!</li>'))

  -- Check if definition list is correctly converted
  assert(stringy.find(res, '<dl><dt>Term 1</dt><dd>Definition 1</dd>'))

  -- Check if line block is correctly converted
  assert(stringy.find(res, '<div class="line-block"><div class="line">This is a line block.'))

  -- Check if fenced division is correctly converted
  assert(stringy.find(res, '<div class="fenced div">This is a fenced division.</div>'))

  -- Check if table with caption above is correctly converted
  assert(stringy.find(res, '<table><caption>Sample Table Caption above</caption><thead><tr><th>Header 1</th><th>Header 2</th></tr></thead><tbody><tr><td>Cell 1</td><td>Cell 2</td></tr><tr><td>Cell 3</td><td>Cell 4</td></tr></tbody></table>'))

  -- Check if table with caption below is correctly converted
  assert(stringy.find(res, '<table><thead><tr><th>Header 1</th><th>Header 2</th></tr></thead><tbody><tr><td>Cell 1</td><td>Cell 2</td></tr><tr><td>Cell 3</td><td>Cell 4</td></tr></tbody><caption>Sample Table Caption below</caption></table>'))
  

  -- Check if implicit header references are correctly converted
  assert(stringy.find(res, '<a href="#line_blocks">line_blocks</a>'))

  -- Check if auto identifiers are correctly converted
  assert(stringy.find(res, '<a href="#sec1">Heading 1</a>'))

  assert(stringy.find(res, '<h3 id="fancy_lists">fancy_lists</h3>'))
  assert(stringy.find(res, '<h3 id="hard-line-breaks">Hard Line Breaks</h3>'))
  
  -- Check if footnotes are correctly converted
  assert(stringy.find(res, '<a href="#fn1" class="footnote-ref" id="fnref1">'))

  -- Check if citations are correctly converted
  assert(stringy.find(res, '<span class="citation" data-cites="example2021">'))

  -- Check if raw HTML is correctly converted
  assert(stringy.find(res, '<span style="color: red">Red text</span>'))

  -- Check if LaTeX Math is correctly converted
  assert(stringy.find(res, '<span class="math inline">E=mc<sup>2</sup></span>'))

  -- Check if inline notes are correctly converted
  assert(stringy.find(res, '<a href="#fn2" class="footnote-ref" id="fnref2">'))

  -- Check if implicit figures are correctly converted TODO this is not yet correct
  assert(stringy.find(res, '<img src="path/to/image.jpg" alt="A description of the image"/>'))

  -- Check if link attributes are correctly converted
  assert(stringy.find(res, '<a href="https://google.com/" title="Google" class="linkclass">Link with title attribute</a>'))

  delete(env.MMOCK .. "/files/plaintext/md/full_pandoc.html")
end)

if get.pass.value("passw", "testotp") then
  dothis.pass.delete_otp("testotp")
end
dothis.pass.add_otp_url(readFile(env.MMOCK .. "/strings/urls/otpauth/basic"), "testotp")
hs.timer.doAfter(1, function()
  assert(
    toNumber(get.pass.otp("testotp"), "int") > 0
  )
  dothis.pass.delete_otp("testotp")
end)

dothis.youtube.do_extracted_attrs_via_ai("EBNl8bwdVcA", function(res_tbl)
  assertMessage(
    res_tbl.tcrea,
    "nobodyknows+"
  )
  assert(
    onig.match(res_tbl.titl, "Hero's Come Back!?") -- both with and without the question mark is correct
  )
  assertMessage(
    res_tbl.srs,
    "Naruto Shippuden"
  )
  assertMessage(
    res_tbl.srsrel,
    "op"
  )
  assertMessage(
    res_tbl.srsrelindex,
    "1"
  )
end)

local tgt = env.TMPDIR .. "/helloworld-" .. os.time() .. ".txt"
dothis.url.download(transf.path.file_url(env.MMOCK .. "/files/plaintext/txt/helloworld.txt"), tgt)

assert(
  readFile(tgt) == "Hello World!"
)

local yaml_contact_by_uuid = transf.uuid.contact_table("a615b162-a203-4a24-a392-87ba3a7ca80c")

assertMessage(
  yaml_contact_by_uuid.name,
  "Test Contact Germany English 001"
)

dothis.khard.edit("a615b162-a203-4a24-a392-87ba3a7ca80c", function()
  assertMessage(
    transf.uuid.contact_table("a615b162-a203-4a24-a392-87ba3a7ca80c").name,
    "Test Contact Germany English 001"
  )
end)

dothis.sox.rec_start_cache(function(path)
  dothis.audiodevice_system.ensure_sound_played_on_speakers()
  dothis.real_audio_path.play(env.MMOCK .. "/files/binary/audio/mp3/myvoice.mp3", function()
    dothis.sox.rec_stop(function()
      assertMessage(
        transf.real_audio_path.transcribed(path),
        "This is a testfile containing my voice."
      )
      dothis.sox.rec_toggle_cache()
      dothis.real_audio_path.play(env.MMOCK .. "/files/binary/audio/mp3/myvoice.mp3", function()
        dothis.sox.rec_toggle_cache(function(recpath)
          assertMessage(
            transf.real_audio_path.transcribed(recpath),
            "This is a testfile containing my voice."
          )
        end)
      end)
    end)
  end)
end)


