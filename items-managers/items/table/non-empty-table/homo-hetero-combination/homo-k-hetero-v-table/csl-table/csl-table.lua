CslTableSpecifier = {
  type = "csl-table",
  properties = {
    getables = {
      ["is-csl-book"] = function(self)
        return self:get("type", "book")
      end,
      ["is-csl-article-journal"] = function(self)
        return self:get("type", "article-journal")
      end,
      ["is-csl-webpage"] = function (self)
        return self:get("type", "webpage")
      end,
      ["is-csl-motion-picture"] = function (self)
        return self:get("type", "motion_picture")
      end,
      ["csl-date-to-rfc3339"] = function(self, key)
        local value = self:get("value", key)
        if value then
          return os.date(
            tblmap.dt_component.rfc3339[#value], 
            os.time(
              map(
                value, 
                function(k) return mt.int.date_component[k] end, 
                "k"
              )
            )
          )
        end
      end,
      ["issued"] = function(self)
        return self:get("csl-date-to-rfc3339", "issued")
      end,
      ["people-to-string"] = function(self, key)
        local people = self:get("value", key)
        if people then 
          local names = map(people, function(person)
            return person["given"] .. " " .. person["family"]
          end)
          return table.concat(names, ", ")
        end
      end,
      ["author"] = function(self)
        return self:get("people-to-string", "author")
      end,
      ["title"] = function(self)
        return self:get("first-match-in-list-of-keys", {"title", "title-short"})
      end,
      ["to-string"] = function(self)
        return 
          (self:get("issued") or "No date") .. ", " ..
          (self:get("author") or "No author") .. ": " ..
          (self:get("title") or "No title") .. ". " ..
          self:get("to-string-unique")
      end,
      ["to-citation"] = function(self, format)
        return run({
          "echo",
          {
            value = self:get("to-json-string"),
            type = "quoted"
          },
          "|",
          "pandoc",
          "--citeproc",
          "-f", "csljson",
          "-t", "plain",
          "--csl",
          { value = "styles/" .. format , type = "quoted" },
        })
      end,
      ["to-url-item"] = function(self)
        return st(self:get("value", "url"))
      end,
        
    },
    doThisables = {

    },
  },
  potential_interfaces = ovtable.init({
    { key = "csl-book", value = CreateCslBook },
    { key = "csl-article-journal", value = CreateCslArticleJournal },
    { key = "csl-webpage", value = CreateCslWebpage },
    { key = "csl-motion-picture", value = CreateCslMotionPicture },
    
  }),
  action_table = concat(
    getChooseItemTable({
      {
        i = "📖",
        d = "cttn",
        key = "get-interactive",
        args = { key = "to-citation", thing = "citation style (e.g.apa or apa-6th-edition)" }
      }
    }),{
      {
        text = "👉🔬 ccitid.",
        key ="choose-action-on-result-of-get",
        args = { key = "to-citable-object-id" }
      },{
        text = "👉🔗 ccururl.",
        key = "choose-action-on-result-of-get",
        args = { key = "to-url-item"}
      },
    }
  )
  
}
--- @type BoundNewDynamicContentsComponentInterface
CreateCslTable = bindArg(NewDynamicContentsComponentInterface, CslTableSpecifier)
