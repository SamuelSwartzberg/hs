local function getThenUse(self, do_specifier, use_callback)
  if not (type(do_specifier) == "table") or not do_specifier.key then
    do_specifier = { key = do_specifier }
  end
  local thing_to_use = self:get(do_specifier.key, do_specifier.args)
  if not thing_to_use then
    print("WARN: getThenUse couldn't get thing to use for key " .. (do_specifier.key or "no key"))
  end
  return use_callback(self, thing_to_use)
end

--- @alias recursiveDoFunction fun(self: ComponentInterface, action: "doThis", key: string, value: any, previous_lower_node_id: integer): true | nil
--- @alias recursiveGetFunction fun(self: ComponentInterface, action: "get", key: string, value: any, previous_lower_node_id: integer): any

--- @type recursiveGetFunction | recursiveDoFunction
local function actionInterfacesRecursive(self, action, key, value, previous_lower_node_id)
  for _, interface in prs(self.interface) do
    if (not previous_lower_node_id) or (not (interface.id == previous_lower_node_id)) then -- prevent infinite loops by not going back down the tree where we've come from
      local interface_returned = interface[action](interface, key, value, false, true)
      if interface_returned ~= nil then
        return interface_returned
      end
    end
  end
end


local function getOrDoAll(self, action, key, value, not_recursive_children, not_recursive_super,  previous_lower_node_id)
  local output = {}
  local result_for_self = self[action](self, key, value, true, true)
  output = concat(output, result_for_self)
  if self.interface and not not_recursive_children then
    for _, interface in prs(self.interface) do
      if (not previous_lower_node_id) or (not (interface.id == previous_lower_node_id)) then 
        local result_for_descendants = getOrDoAll(interface, action, key, value, false, true)
        output = concat(output, result_for_descendants)
      end
    end
  end
  if self.super and not not_recursive_super then
    local result_for_super = getOrDoAll(self.super, action, key, value, false, false, self.id)
    output = concat(output, result_for_super)
  end
  output = fixListWithNil(output)
  return output
end

--- @param self ComponentInterface
--- @param thing string | functable
local function singleInteractiveFunc(self, thing)
  if type(thing) == "string" then
    if stringy.startswith(thing, "path_from:") then
      local start = eutf8.sub(thing, 11)
      return prompt("path", start)
    else 
      return prompt("string", "Enter value for " .. thing)
    end
  elseif type(thing) == "table" and thing.func then -- we can't use functions directly since hs.chooser can't serialize them and doesn't like unserializable things
    return _G[thing.func](thing.args)
  else
    error("Unknown specifier thing type for do-interactive: " .. type(thing))
  end
end

--- @alias functable { func: string, args: string}

--- allow for some sort of dynamic getting of args to pass to methods of the interface without having to write wrappers
--- the passed specifier contains the key action (e.g. "doThis") and the key key identifying the method of that action
--- most importantly, it contains the key thing, which does the work of specifying how to get the args to pass to the method
--- thing can be a string, in which case it will be used as a prompt for the user to enter a string
--- thing can also be a functable
--- or it can be an assoc arr or array of strings or functables, which will be handled the same as the above, but will be passed as an assoc arr or array to the method
--- @param self ComponentInterface
--- @param specifier { action: string, key: string, thing: string | functable | { [string]: string | function } | (string | functable)[]}
local function interactiveFunc(self, specifier)
  local args_to_pass
  local thing = specifier.thing
  if isListOrEmptyTable(specifier.thing) then
    --- @cast thing (string | function)[]
    args_to_pass = {}
    for _, thing in iprs(thing) do
      push(args_to_pass, singleInteractiveFunc(self, thing))
    end
  elseif type(thing) == "table" and not thing.func then
    args_to_pass = {}
    --- @cast thing { [string]: string | function }
    for key, val in prs(thing) do
      args_to_pass[key] = singleInteractiveFunc(self, val)
    end
  else
    --- @cast thing string | functable
    args_to_pass= singleInteractiveFunc(self, thing)
  end
  return self[specifier.action](self, specifier.key, args_to_pass)
end

--- @alias nonstring function | number | boolean | table | any[]

--- @alias propfunc fun(self?: ComponentInterface, arg?: any)
--- @alias doThisables { [string]: propfunc }
--- @alias getfunc fun(self?: ComponentInterface, arg?: any): any
--- @alias getables table<string, getfunc>,
--- @alias interface_table { [string]: ComponentInterface }
--- @alias interface_properties {  doThisables: doThisables, getables: getables, [nonstring]: nil }
--- @alias action_table_item { text: string, key: string, args: any }
--- @alias action_table action_table_item[]
--- @alias get_func fun(self: ComponentInterface, key: string, value?: `T`, not_recursive_children?: boolean, not_recursive_super?: boolean,  previous_lower_node_id?: integer): any
--- @alias non_get_func fun(self: ComponentInterface, key: string, value?: `T`, not_recursive_children?: boolean, not_recursive_super?: boolean, previous_lower_node_id?: integer): true | nil


--- @class ComponentInterfaceTemplate
--- @field type string
--- @field is_interface boolean
--- @field interface interface_table
--- @field properties interface_properties
--- @field get get_func
--- @field get_all function
--- @field doThis non_get_func
--- @field doThis_all function
--- @field setContents fun(self: ComponentInterface, contents: any): nil


--- @class ItemSpecifier
--- @field type string
--- @field properties interface_properties
--- @field potential_interfaces orderedtable
--- @field action_table action_table

--- @class SpecifiedComponentInterface : ComponentInterfaceTemplate
--- @field potential_interfaces orderedtable
--- @field action_table action_table
--- @field id integer

-- note to self: generics are also currently broken in lua type annotations: https://github.com/sumneko/lua-language-server/labels/generic

--- @class GenericComponentInterface : SpecifiedComponentInterface
--- @field super ComponentInterface
--- @field root_super ComponentInterface


--- @class RootComponentInterface : SpecifiedComponentInterface
--- @field contents any

--- @alias NonRootComponentInterface GenericComponentInterface

--- @alias ComponentInterface RootComponentInterface | NonRootComponentInterface

--- @class ContentsInterface


--- @type GenericComponentInterface
InterfaceDefaultTemplate = {
  is_interface = true,
  interface = {},
  type = "generic",
  properties = {
    getables = {
      contents = function(self)
        if self.super then return self.root_super:get("contents") 
        else return self.contents end
      end,
      ["chooser-list-entry"] = function(self) 
        return {
          text = self:get("chooser-text"),
          ["subText"] = self:get("chooser-subtext"),
          ["initial-selected"] = self:get("chooser-initial-selected"),
          ["image"] = self:get("chooser-image"), -- may be nil
          ["id"] = self:get("id")
        }
      end,
      ["chooser-text"] = function(self)
        return surroundByStartEndMarkers(self:get("to-string"))
      end,
      ["chooser-subtext"] = function(self)
        local chooser_subtext_parts = self:get_all("chooser-subtext-part")
        if #chooser_subtext_parts > 0 then
          return table.concat(chooser_subtext_parts, " | ")
        else
          return nil
        end
      end,
      ["raw-action-table"] = function(self) return self.action_table end,
      ["filtered-action-table"] = function(self)
        local filtered_action_table = filter(
          self:get("raw-action-table") or {}, 
          function(action_table_entry)
            if action_table_entry.condition then
              return action_table_entry.condition(self)
            else
              return true
            end
          end)
        return filtered_action_table
      end,
      ["action-table"] = function(self)
        local chooser_table = {}
        for action_index, action in iprs(self:get("filtered-action-table")) do
          local chooser_string = ""
          if type(action.text) == "string" then
            chooser_string = action.text
          elseif type(action.text) == "function" then
            chooser_string = action.text(self)
          else
            error("String key of action table entry is not a string or a function.")
          end
          chooser_table[#chooser_table + 1] = {
            text = chooser_string,
            key = action.key,
            args = action.args,
            id = self:get("id"),
            action_id = rand({len=10})
          }
        end
        return chooser_table
      end,
      ["self"] = function(self) return self end,
      ["types-of-all-valid-interfaces"] = function(self)
        local types = self:get_all("type")
        return table.concat(types, "\n")
      end,
      ["is-a"] = function(self, interface_type)
        return find(self:get_all("type"), interface_type)
      end,
      ["interface-by-type"] = function(self, interface_type)
        local all_interfaces = self:get_all("self")
        return find(all_interfaces, function(interface)
          return interface:get("type") == interface_type
        end)
      end,
      ["str-item"] = bind(
        getThenUse, {["3"] = function (_, contents)
          return CreateStringItem(contents)
        end}
      ),
      ["array"] = bind(
        getThenUse, {["3"] = function (_, contents)
          return CreateArray(contents)
        end}
      ),
      ["new-array-from-result-of-get"] = bind(
        getThenUse, {["3"] = function (_, contents)
          return CreateArray(contents)
        end}
      ),
      ["get-interactive"] = function(self, specifier)
        specifier.action = "get"
        return interactiveFunc(self, specifier)
      end,
      ["timer-that-does"] = function(self, specifier)
        return {
          interval = specifier.interval,
          fn = function() self:doThis(specifier.key, specifier.args) end
        }
      end,
      id = function(self) return self.id end,
      type = function(self) return self.type end,
    },
    doThisables = {
      ["choose-action-callback"] = function(self, callback)
        local action_table = self:get_all("action-table")
        buildChooser(
          action_table,
          callback,
          nil, 
          { whole_chooser = { placeholderText = self:get("to-string") } }
        )
      end,
      ["choose-action"] = function(self)
        self:doThis("choose-action-callback", function(chosen_item)
          self:doThis("use-action", chosen_item)
        end)
      end,
      ["choose-item-or-action"] = function(self)
        local chose_item = self:doThis("choose-item", function (chosen_item)
          chosen_item:doThis("choose-item-or-action")
        end)
        if not chose_item then
          self:doThis("choose-action")
        end
      end,
      ["do-interactive"] = function(self, specifier)
        specifier.action = "doThis"
        interactiveFunc(self, specifier)
      end,
      ["use-action"] = function(self, action_item)
        self:doThis(action_item["key"], action_item["args"])
      end,
      ["update"] = function() end,
      ["get-as-do"] = function(self, key)
        self:get(key)
      end,
      ["copy-result-of-get"] = bind(getThenUse, { ["3"] = bind(hs.pasteboard.setContents, {["1"] = arg_ignore})}),
      ["paste-result-of-get"] = bind(getThenUse, { ["3"] = bind(pasteMultilineString, {["1"] = arg_ignore})}),
      ["open-result-of-get-in-browser"] = bind(getThenUse, { ["3"] = function(_, thing) open({url=thing}) end}),
      ["view-result-of-get"] = bind(getThenUse, { ["3"] = bind(hs.alert.show, {["1"] = arg_ignore})}),
      ["open-result-of-get"] = bind(getThenUse, { ["3"] = bind(open, {["1"] = arg_ignore})}),
      ["quick-look-result-of-get"] = bind(getThenUse, { ["3"] = bind(hs.alert.show, {["1"] = arg_ignore})}),
      ["code-quick-look-result-of-get"] = bind(getThenUse, { ["3"] = bind(alert, {["1"] = arg_ignore})}),
      ["choose-action-on-result-of-get"] = bind(getThenUse, { ["3"] = function(_, item)
        item:doThis("choose-action")
      end}),
      ["choose-action-on-str-item-result-of-get"] = bind(getThenUse, { ["3"] = function(_, item)
        CreateStringItem(item):doThis("choose-action")
      end}),
      ["choose-item-and-then-action-on-result-of-get"] = bind(getThenUse, { ["3"] = function(_, item)
        item:doThis("choose-item-and-then-action")
      end}),
      ["choose-item-or-action-on-result-of-get"] = bind(getThenUse, { ["3"] = function(_, item)
        item:doThis("choose-item-or-action")
      end}),
      ["repeat-action"] = function(self, specifier)
        for i = 1, specifier.limit + 1 do
          self:doThis(specifier.key, specifier.args)
        end
      end,
      ["do-staggered-action"] = function(self, specifier)
        local counter = 1
        System:get("contents")["global-timer-manager"]:doThis("create", { 
          interval = specifier.interval,
          fn = function()
            self:doThis(specifier.key, specifier.args)
            counter = counter + 1
            if counter > specifier.limit then
              error("staggered action limit reached, stop timer.", 0)
            end
          end
        })
      end,
      ["do-multiple"] = function(self, actions)
        for _, action in iprs(actions) do
          self:doThis(action.key, action.args)
        end
      end,
    },
  },

  get = function(self, key, value, not_recursive_children, not_recursive_super, previous_lower_node_id)
    if self.properties.getables[key] then
      return self.properties.getables[key](self, value)
    else
      if (not not_recursive_children) then
        local res = actionInterfacesRecursive(self, "get", key, value, previous_lower_node_id)
        if res ~= nil then return res end -- this pattern is necessary so we check parents if we don't find anything in children
      end
      if not not_recursive_super and self.super then
        -- print("checking super")
        local res = self.super:get(key, value, not_recursive_children, false, self.id)
        if res ~= nil  then return res end 
      end
    end
    return nil
  end,
  get_all = bind(getOrDoAll, {["2"] = "get"}),
  doThis = function(self, key, value, not_recursive_children, not_recursive_super, previous_lower_node_id)
    if self.properties.doThisables[key] then
      self.properties.doThisables[key](self, value)
      return true
    else
      if (not not_recursive_children) then
        local res = actionInterfacesRecursive(self, "doThis", key, value, previous_lower_node_id)
        if res ~= nil then return res end 
      end
      if not not_recursive_super and self.super then
        local res = self.super:doThis(key, value, not_recursive_children, false, self.id)
        if res ~= nil then return res end 
      end
    end
    return nil
  end,
  doThis_all = bind(getOrDoAll, {["2"] = "doThis"}),
  setContents = function(self, value)
    if not self.super then self.contents = value end
    if self.potential_interfaces then
      self.interface = {}
      for potential_interface, potential_interface_constructor  in prs(self.potential_interfaces) do
        if self:get("is-" .. potential_interface) then
          self.interface[potential_interface] = potential_interface_constructor(self)
        end
      end
    end
  end
}

-- There is no point in making default implementations of some methods heritable, since they will be reached via the super chain anyway.

--- @enum NonHeritableInterfacePropsTemplate
NonHeritableInterfacePropsTemplate = {
  getables = {
    ["is-valid"] = function() return true end,
    ["to-string"] = function() return "not implemented" end,
    ["chooser-initial-selected"] = function() return false end,
  }
}

BasicInterfaceDefaultTemplate = concat(InterfaceDefaultTemplate, {properties = NonHeritableInterfacePropsTemplate})

--- @param interface_specifier ItemSpecifier
--- @param super ComponentInterface
--- @return NonRootComponentInterface
function NewDynamicContentsComponentInterface(interface_specifier, super)
  -- print("creating a " .. interface_specifier.type .. " interface")
  --- @type NonRootComponentInterface
  local interface = concat(InterfaceDefaultTemplate, interface_specifier)
  interface.id = rand({len=10})
  if super then 
    interface.super = super
    interface.root_super = super.root_super
    interface:setContents(super.root_super:get("contents"))
  end
  return interface
end

--- @type action_table
local root_action_table = {
  {
    text = "👉🎛️ cinf.",
    key = "choose-action-on-str-item-result-of-get",
    args = { key = "types-of-all-valid-interfaces"}

  }
}

--- @alias BoundNewDynamicContentsComponentInterface fun(super: ComponentInterface): NonRootComponentInterface

--- @param interface_specifier ItemSpecifier
--- @param contents any
--- @return RootComponentInterface
function RootInitializeInterface(interface_specifier, contents)
  -- print("creating a " .. interface_specifier.type .. " interface")
  if contents == nil then 
    error("Contents for a component interface may not be nil.", 0)
  end
  --- @type RootComponentInterface
  local interface =  concat(InterfaceDefaultTemplate, interface_specifier)
  interface.id = rand({len=10})
  interface.properties.getables["is-" .. interface.type] = function() return true end -- in the root, we can be sure that the is-<type> is true
  interface.root_super = interface
  interface:setContents(contents)
  interface.action_table = concat(interface.action_table, root_action_table)
  return interface
end

--- @alias BoundRootInitializeInterface fun(contents: any): RootComponentInterface