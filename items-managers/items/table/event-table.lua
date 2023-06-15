--- @type ItemSpecifier
EventTableSpecifier = {
  type = "event-table",
  action_table = {
    { i = "📇", d = "cl", getfn = transf.event_table.calendar},
    { i = "🏧", d = "ttl", getfn = transf.event_table.title },
    { i = "💬", d = "dsc", getfn = transf.event_table.description },
    { i = "🔗", d = "url", getfn = transf.event_table.url },
    { i = "📍", d = "lc", getfn = transf.event_table.location },
    { 
      text = "👉🎬📅 cst.",
      getfn = transf.event_table.start_date,
      filter = dat
    },{
      text = "👉🏁📅 ced.",
      getfn = transf.event_table.end_date,
      filter = dat
    },{
      text = "🗑 rmev.",
      dothis = dothis.event_table.delete
    },{
      text = "✏️ edev.",
      dothis = dothis.event_table.edit
    },{
      text = "🌄 crsev.",
      dothis = dothis.event_table.create_similar
    }
  
  }
}




--- @type BoundRootInitializeInterface
function CreateEventTableItem(contents)
  return RootInitializeInterface(EventTableSpecifier, contents)
end

