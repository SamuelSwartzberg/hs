--- @type ItemSpecifier
ContactTableSpecifier = {
  type = "contact-table",
  action_table = {
      { i = "⏪🙋🏻‍♀️", d = "nmpr", key = "name-pre", check = true },
      { i = "◀️🙋🏻‍♀️", d = "fnm", key = "first-name", check = true },
      { i = "⏺🙋🏻‍♀️", d = "mnm", key = "first-name", check = true },
      { i = "▶️🙋🏻‍♀️", d = "lnm", key = "last-name", check = true },
      { i = "⏩🙋🏻‍♀️", d = "nmsf", key = "name-suf", check = true },
      { i = "👩🏻‍🎤🙋🏻‍♀️", d = "nnm", key = "nickname", check = true },
      { i = "全🙋🏻‍♀️🇺🇸", d = "flnmw", key = "full-name-western" },
      { i = "全🙋🏻‍♀️🇯🇵", d = "flnme", key = "full-name-eastern" },
      { i = "⭐️🙋🏻‍♀️", d = "pnm", key = "pref-name" },
      { i = "🎂", d = "bday", key = "birthday", check = true },
      { i = "🎉", d = "ann", key = "anniversary", check = true },
      { i = "🏢", d = "org", key = "organization", check = true },
      { i = "🎓", d = "ttl", key = "title", check = true },
      { i = "👩🏻‍🏫", d = "rol", key = "role", check = true },
      { i = "🌐", d = "hp", key = "homepage", check = true },
      { i = "🆔", d = "uid", key = "uid", },
      { i = "🏦🔢", d = "iban", key = "iban", },
      { i = "✉♥️", d = "pmail", key = "contact-addr", args = { type = "email", addr_type = "pref" }, check = true },
      { i = "📞♥️", d = "pphone", key = "contact-addr", args = { type = "phone", addr_type = "pref" }, check = true },
      {
        text = "👉✉ cmail.",
        key = "choose-item-and-then-action-on-result-of-get",
        args = { key = "contact-addr-table-item", args = "email" },
      },
      {
        text = "👉📞 cphone.",
        key = "choose-item-and-then-action-on-result-of-get",
        args = { key = "contact-addr-table-item", args = "phone" },
      },
      {
        text = "👉🏡 caddr.",
        key = "choose-item-and-then-action-on-result-of-get",
        args = { key = "addresses-table" }
      },
      {
        text = "👉🏦 cbnkdt.",
        key = "choose-action-bank-deets-array"
      },
      {
        text = "✏️ ed.",
        key = "edit",
      }
  }
  

}

--- @type BoundRootInitializeInterface
function CreateContactTableItem(contents)
  return RootInitializeInterface(ContactTableSpecifier, contents)
end

