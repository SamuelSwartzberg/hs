--- @alias relay_table { [string]: { [string]: string[] } }


transf = {
  hex = { -- a hex string
    char = function(hex)
      return string.char(tonumber(hex, 16))
    end,
    indicated_hex_string = function(hex)
      return "0x" .. hex
    end,
    utf8_unicode_prop_table = function(hex)
      return memoize(runJSON)("uni print -compact -format=all -as=json".. transf.string.single_quoted_escaped("utf8:" .. tostring(hex)))[1]
    end,
    unicode_codepoint = function(hex)
      return "U+" .. hex
    end,
  },
  percent = {
    char = function(percent)
      local num = percent:sub(2, 3)
      return string.char(tonumber(num, 16))
    end,
  },
  unicode_codepoint = { -- U+X...
    number = function(codepoint)
      return tonumber(codepoint:sub(3), 16)
    end,
    unicode_prop_table = function(codepoint)
      return memoize(runJSON)("uni print -compact -format=all -as=json".. transf.string.single_quoted_escaped(codepoint))[1]
    end
  },
  number = {
    decimal_string = function(num)
      return tostring(num)
    end,
    indicated_decimal_string = function(num)
      return "0d" .. transf.number.decimal_string(num)
    end,
    hex_string = function(num)
      return string.format("%X", num)
    end,
    indicated_hex_string = function(num)
      return "0x" .. transf.number.hex_string(num)
    end,
    unicode_codepoint = function(num)
      return "U+" .. transf.number.hex_string(num)
    end,
    octal_string = function(num)
      return string.format("%o", num)
    end,
    indicated_octal_string = function(num)
      return "0o" .. transf.number.octal_string(num)
    end,
    binary_string = function(num)
      return string.format("%b", num)
    end,
    indicated_binary_string = function(num)
      return "0b" .. transf.number.binary_string(num)
    end,
    unicode_prop_table = function(num)
      return transf.unicode_codepoint.unicode_prop_table(transf.number.unicode_codepoint(num))
    end,
    utf8_unicode_prop_table = function(num)
      return transf.hex.utf8_unicode_prop_table(transf.number.hex_string(num))
    end,
  },
  not_nil = {
    string = function(arg)
      if arg == nil then
        return nil
      else
        return tostring(arg)
      end
    end,
  },
  char = {
    hex = function(char)
      return string.format("%02X", string.byte(char))
    end,
    percent = function(char)
      return string.format("%%%02X", string.byte(char))
    end,
    unicode_prop_table = function(char)
      return memoize(runJSON)("uni identify -compact -format=all -as=json".. transf.string.single_quoted_escaped(char))[1]
    end
  },
  path = {
    attachment = function(path)
      local mimetype = mimetypes.guess(path) or "text/plain"
      return "#" .. mimetype .. " " .. path
    end,
    no_leading_following_slash_or_whitespace = function(item)
      item = stringy.strip(item)
      return item
    end
  },
  real_image_path = {
    qr_data = function(path)
      return run("zbarimg -q --raw " .. transf.string.single_quoted_escaped(path))
    end
  },
  semver = {
    components = function(str)
      local major, minor, patch, prerelease, build = onig.match(str, mt._r.version.semver)
      return {
        major = tonumber(major),
        minor = tonumber(minor),
        patch = tonumber(patch),
        prerelease = prerelease,
        build = build
      }
    end,
  },
  uuid = {
    raw_contact = function(uuid)
      return memoize(run)( "khard show --format=yaml uid:" .. uuid, {catch = true} )
    end,
    contact_table = function(uuid)
      local raw_contact = transf.uuid.raw_contact(uuid)
      local contact_table = yamlLoad(raw_contact)
      contact_table.uid = uuid
      return contact_table
    end,
  },
  string = {
    escaped_csv_field = function(field)
      error("current implementation will break on nonascii")
      return '"' .. replace(field, {{'"', "\n"}, {'""', '\\n'}})  .. '"'
    end,
    unicode_prop_table_array = function(str)
      return memoize(runJSON)("uni identify -compact -format=all -as=json".. transf.string.single_quoted_escaped(str))
    end,
    single_quoted_escaped = function(str)
      return " '" .. memoize(replace)(str, to.string.escaped_single_quote_safe) .. "'"
    end,
    double_quoted_escaped = function(str)
      return ' "' .. memoize(replace)(str, to.string.escaped_double_quote_safe) .. '"'
    end,
    bits = basexx.to_bit,
    hex = basexx.to_hex,
    base64_gen = basexx.to_base64,
    base64_url = basexx.to_url64,
    base32_gen = basexx.to_base32,
    base32_crock = basexx.to_crockford,
    title_case = function(str)
      local words, removed = split(str, {_r = "[ :–\\—\\-\\t\\n]", _regex_engine = "onig"})
      local title_cased_words = map(words, transf.word.title_case_policy)
      title_cased_words[1] = replace(title_cased_words[1], to.case.capitalized)
      title_cased_words[#title_cased_words] = replace(title_cased_words[#title_cased_words], to.case.capitalized)
      return concat({
        isopts = "isopts",
        sep = removed,
      }, title_cased_words)
    end,
    romanized = function(str)
      local raw_romanized = run(
        { "echo", "-n",  {value = str, type = "quoted"}, "|", "kakasi", "-iutf8", "-outf8", "-ka", "-Ea", "-Ka", "-Ha", "-Ja", "-s", "-ga" }
      )
      local is_ok, romanized = pcall(eutf8.gsub, raw_romanized, "(%w)%^", "%1%1")
      if not is_ok then
        return str -- if there's an error, just return the original string
      end
      replace(romanized, {{"(kigou)", "'"}, {}}, {
        mode = "remove",
      })
      return romanized
    end,
    romanized_snake = function(str)
      str = eutf8.gsub(str, "[%^']", "")
      str = transf.string.romanized(str)
      str = eutf8.lower(replace(str, to.case.snake))
      return str
    end,
    romanized_gpt = function(str)
      return gpt("Please romanize the following text with wapuro-like romanization, where:\n\nっ -> duplicated letter (e.g. っち -> cchi)\nlong vowel mark -> duplicated letter (e.g. ローマ -> roomaji)\nづ -> du\nんま -> nma\nじ -> ji\nを -> wo\nち -> chi\nparticles are separated by spaces (e.g. これに -> kore ni)\nbut morphemes aren't (真っ赤 -> makka)\n\nDictionary:\n\nこっち -> kocchi\n\nText:\n\n" .. str, {temperature = 0})
    end,
    tilde_resolved = function(path)
      if stringy.startswith(path, "~") then
        return env.HOME .. eutf8.sub(path, 2)
      else
        return path
      end
    end,
    path_resolved = function(path, resolve_tilde)
      if resolve_tilde then
        path = transf.string.tilde_resolved(path)
      end
      local components = pathSlice(path, ":")
      local reduced_components = {}
      local started_with_slash = stringy.startswith(path, "/")
      local components_are_all_dotdot = false
      for _, component in ipairs(components) do
        if component == ".." then
          if #reduced_components > 0 and not components_are_all_dotdot then
            table.remove(reduced_components)
          else -- we can't go higher up
            if started_with_slash then
              -- no-op: we're already at the root, so we treat this similarly to '.', which is a no-op. This is consistent with the behavior of cd/ls in bash
            else
              table.insert(reduced_components, "..") -- the path was a relative path, and we've arrived at the root of the relative path. We have no further information about what is above the root of the relative path, so we have no choice but to leave this component unresolved
              components_are_all_dotdot = true
            end
             
          end
        else
          components_are_all_dotdot = false
          if component ~= "." then
            table.insert(reduced_components, component)
          end
        end
      end
      local new_path = table.concat(reduced_components, "/")
      if started_with_slash then
        return "/" .. new_path
      else
        if #new_path == 0 then
          return "."
        else
          return new_path
        end
      end
    end,
    timestamp_or_nil = function(str)
      if eutf8.match(str, "^%d") then
        str = slice(str, {start = {_r = "%d"}})
      end
      -- date is already a timestamp
    
      if #str == 13 then
        return tonumber(eutf8.sub(str, 1, 10))
      elseif #str == 10 then
        return tonumber(str)
      end
    
      -- we have to parse the date
    
      for _, sep in ipairs(long_dt_seps) do
        eutf8.gsub(str, _r_comp.lua.data.sep, " ")
      end
    
      local date_parts
    
      for _, date_regex in fastpairs(date_regexes) do
        date_parts = {eutf8.match(str, date_regex)}
        if #date_parts > 0 then
          break
        end
      end
    
      if #date_parts == 0 then
        return nil
      end
    
      local date_table = map(mt._list.date.dt_component_few_chars, function(k,v) return v, date_parts[k] end, "kv")
      local res, timestamp = pcall(os.time, date_table)
      if res then
        return timestamp
      else
        return nil
      end
    end,
    raw_contact = function(searchstr)
      return memoize(run)("khard show --format=yaml " .. searchstr, {catch = true} )
    end,
    contact_table = function(searchstr)
      local raw_contact = transf.string.raw_contact(searchstr)
      local contact = yamlLoad(raw_contact)
      return contact
    end,
    event_table = function(str)
      local components = stringx.split(str, mt._contains.unique_field_separator)
      local parsed = ovtable.new()
      for i, component in ipairs(components) do
        local key = mt._list.khal.parseable_format_components[i]
        if key == "alarms" then
          parsed[key] = stringy.split(component, ",")
        elseif key == "description" then
          parsed[key] = component
        else
          parsed[key] = stringx.replace(component, "\n", "")
        end
      end
      return parsed
    end
  },
  event_table = {
    calendar_template = function(event_table)
      local template = get.khal.calendar_template_empty()
      for key, value in fastpairs(event_table) do
        if template[key] then
          if key == "repeat" then
            for subkey, subvalue in fastpairs(value) do
              template[key][subkey].value = subvalue
            end
          else
            template[key].value = value
          end
        end
      end
      if template.alarms.value then 
        template.alarms.value = table.concat(template.alarms.value, ",")
      end
      return yamlDumpAligned(template)

    end
  },
  multiline_string = {
    trimmed_lines = function(str)
      local lines = split(str, "\n")
      local trimmed_lines = map(lines, stringy.strip)
      return table.concat(trimmed_lines, "\n")
    end,
    relay_table = function(raw)
      local raw_countries = stringx.split(raw, "\n\n") -- stringy does not support splitting by multiple characters
      raw_countries = filter(raw_countries, true)
      local countries = {}
      for _, raw_country in ipairs(raw_countries) do
        local raw_country_lines = stringy.split(raw_country, "\n")
        raw_country_lines = filter(raw_country_lines, true)
        local country_header = raw_country_lines[1]
        local country_code = slice(country_header, "(", ")")
        if country_code == nil then error("could not find country code in header. header was " .. country_header) end
        local payload_lines = slice(raw_country_lines, 2, -1)
        countries[country_code] = {}
        local city_code
        for _, payload_line in ipairs(payload_lines) do
          if stringy.startswith(payload_line, "\t\t") then -- line specifying a single relay
            local relay_code = payload_line:match("^\t\t([%w%-]+) ") -- lines look like this: \t\tfi-hel-001 (185.204.1.171) - OpenVPN, hosted by Creanova (Mullvad-owned)
            push(countries[country_code][city_code], relay_code)
          elseif stringy.startswith(payload_line, "\t") then -- line specifying an entire city
            city_code = slice(payload_line, "(", ")") -- lines look like this: \tHelsinki (hel) @ 60.19206°N, 24.94583°W
            countries[country_code][city_code] = {}
          end
        end

      end
    
      return countries
    end,
    array_of_event_tables = function(str)
      local res = filter(stringx.split(str, mt._contains.unique_record_separator))
      return hs.fnutils.imap(
        res,
        transf.string.event_table
      )
    end,
  },
  word = {
    title_case_policy = function(word)
      if find(mt._contains.small_words, word) then
        return word
      elseif eutf8.find(word, "%u") then -- words with uppercase letters are presumed to already be correctly title cased (acronyms, brands, the like)
        return word
      else
        return replace(word, to.case.capitalized)
      end
    end,
    synonyms = {

      raw_syn = function(str)
        return memoize(run)(
          "syn -p" .. transf.string.single_quoted_escaped(str),
        )
      end,
      array_syn_tbls = function(str)
        local synonym_parts = stringx.split(transf.word.synonyms.raw_syn(str), "\n\n")
        local synonym_tables = map(
          synonym_parts,
          function (synonym_part)
            local synonym_part_lines = stringy.split(synonym_part, "\n")
            local synonym_term = eutf8.sub(synonym_part_lines[1], 2) -- syntax: ❯<term>
            local synonyms_raw = eutf8.sub(synonym_part_lines[2], 12) -- syntax:  ⬤synonyms: <term>{, <term>}
            local antonyms_raw = eutf8.sub(synonym_part_lines[3], 12) -- syntax:  ⬤antonyms: <term>{, <term>}
            local synonyms = map(stringy.split(synonyms_raw, ", "), stringy.strip)
            local antonyms = map(stringy.split(antonyms_raw, ", "), stringy.strip)
            return {
              term = synonym_term,
              synonyms = synonyms,
              antonyms = antonyms,
            }
          end
        )
        return synonym_tables
      end,
      raw_av = function (str)
        memoize(run)(
          "synonym" .. transf.string.single_quoted_escaped(str),
        )
      end,
      array_av = function(str)
        local items = stringy.split(transf.word.synonyms.raw_av(str), "\t")
        items = filter(items, function(itm)
          if itm == nil then
            return false
          end
          itm = stringy.strip(itm)
          return #itm > 0
        end)
        return items
      end,
    }
  },
  array_of_tables = {
    item_array_of_item_tables = function(arr)
      return CreateArray(map(
        arr,
        function (arr)
          return CreateTable(arr)
        end
      ))
    end
  },
  array_of_strings = {
    item_array_of_string_items = function(arr)
      return CreateArray(hs.fnutils.imap(
        arr,
        CreateStringItem
      ))
    end,
    repeated_option_string = function(arr, opt)
      return table.concat(
        hs.fnutils.imap(
          arr,
          function (itm)
            return " " .. opt .. " " .. itm
          end
        )
      )
    end,
  },
  array_of_event_tables = {
    item_array_of_event_table_items = function(arr)
      return CreateArray(hs.fnutils.imap(
        arr,
        CreateEventTableItem
      ))
    end,
  },
  package_manager = {
    array = {
      backed_up_packages = function(mgr)
        return lines(run("upkg " .. mgr .. " read-backup"))
      end,
      missing_packages = function(mgr)
        return lines(run("upkg " .. mgr .. " missing"))
      end,
      added_packages = function(mgr)
        return lines(run("upkg " .. mgr .. " added"))
      end,
      difference_packages = function(mgr)
        return lines(run("upkg " .. mgr .. " difference"))
      end,
      package_manager_version = function(mgr)
        return lines(run("upkg " .. mgr .. " package-manager-version"))
      end,
      which_package_manager = function(mgr)
        return lines(run("upkg " .. mgr .. " which-package-manager"))
      end,
      package_managers_with_missing_packages = function(mgr)
        return lines(run("upkg " .. mgr .. " missing-package-managers"))
      end,
      list = function(mgr) return lines(run("upkg" .. mgr .. "list")) end,
      count = function(mgr) return lines(run("upkg" .. mgr .. " count")) end,
      with_version = function(mgr, arg) return lines(run("upkg" .. mgr .. " with-version " .. (arg or ""))) end,
      version = function(mgr, arg) return lines(run("upkg" .. mgr .. " version " .. (arg or ""))) end,
      which = function(mgr, arg) return lines(run("upkg" .. mgr ..  " which" .. (arg or "")))
      end,
      is_installed = function(mgr, arg) return pcall(run, mgr .. "is-installed" .. (arg or "")) end,
    },

  },
  table = {
    url_params = function(t)
      local params = {}
      for k, v in pairs(t) do
        local encoded_v = urlencode(tostring(v), true)
        table.insert(params, k .. "=" .. encoded_v)
      end
      return table.concat(params, "&")
    end,
    curl_form_field_list = function(t)
      local fields = {}
      for k, v in pairs(t) do
        push(fields, "-F")
        local val = v
        if stringy.startswith(v, "@") then
          local valpath = eutf8.sub(v, 2)
          valpath = transf.string.path_resolved(valpath, true)
          val = "@" .. valpath
        end
        push(fields, {
          value = ("%s=%s"):format(k, val),
          type = "quoted",
        })
      end
      return fields
    end,
    single_quoted_escaped_json = function(t)
      return transf.string.single_quoted_escaped(json.encode(t))
    end,
    yaml_metadata = function(t)
      local string_contents = yamlDump(t)
      return "---\n" .. string_contents .. "\n---\n"
    end,
  },
  url_components = {
    url = function(comps)
      local url
      if comps.url then
        url = comps.url
      elseif comps.host then
        if comps.scheme then
          url = comps.scheme
        else
          url = "https://"
        end
        url = url .. mustEnd(comps.host, "/")
        if comps.endpoint then
          url = url .. (mustNotStart(comps.endpoint, "/") or "/")
        end   
      end     
      if comps.params then
        if type(comps.params) == "table" then
          url = url .. "?" .. transf.table.url_params(comps.params)
        else
          url = url .. mustStart(comps.params, "?")
        end
      end
      return url
    end,
  },
  gpt_response_table = {
    response_text = function(result)
      local first_choice = result.choices[1]
      local response = first_choice.text or first_choice.message.content
      return stringy.strip(response)
    end
  }
}
