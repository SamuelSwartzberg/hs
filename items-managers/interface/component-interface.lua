--- @alias recursiveDoFunction fun(self: ComponentInterface, action: "doThis", key: string, value: any, previous_lower_node_id: integer): true | nil
--- @alias recursiveGetFunction fun(self: ComponentInterface, action: "get", key: string, value: any, previous_lower_node_id: integer): any

--- @type recursiveGetFunction | recursiveDoFunction
local function actionInterfacesRecursive(self, action, key, value, previous_lower_node_id)
  for _, interface in self.interface:pairs() do
    if (not previous_lower_node_id) or (not (interface.id == previous_lower_node_id)) then -- prevent infinite loops by not going back down the tree where we've come from
      local interface_returned = interface[action](interface, key, value, false, true)
      if interface_returned ~= nil then
        return interface_returned
      end
    end
  end
end


local function getOrDoAll(self, action, key, value, not_recursive_children, not_recursive_super,  previous_lower_node_id)
  local output = list({})
  local result_for_self = self[action](self, key, value, true, true)
  output = concat(output, result_for_self)
  if self.interface and not not_recursive_children then
    for _, interface in self.interface:pairs() do
      print(interface)
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
  output = transf.hole_y_arraylike.array(output)
  return output
end

--- @alias nonstring function | number | boolean | table | any[]

--- @alias propfunc fun(self?: ComponentInterface, arg?: any)
--- @alias doThisables { [string]: propfunc }
--- @alias getfunc fun(self?: ComponentInterface, arg?: any): any
--- @alias getables table<string, getfunc>,
--- @alias interface_table { [string]: ComponentInterface }
--- @alias interface_properties {  doThisables: doThisables, getables: getables, [nonstring]: nil }
--- @alias action_table_item { text: string, key: string, args: any, e: string, d: string, getfn: function, dothis: function, filter: function, get: string, act: string }
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
  interface = ovtable.new(),
  type = "generic",
  properties = {
    getables = {
      contents = function(self)
        if self.super then return self.root_super:get("c") 
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
        return transf.string.with_styled_start_end_markers(self:get("to-string"))
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
        for action_index, action in ipairs(self:get("filtered-action-table")) do
          local n_action = copy(action)
          n_action.id = self:get("id")
          n_action.action_id = rand({len=10})
          n_action.text = n_action.text or ""
          local choose =  n_action.act and stringy.startswith(n_action.act, "c") 
          if choose == "ci" then
            n_action.text = mustStart(n_action.text, "👉")
          elseif choose == "cia" then
            n_action.text = mustStart(n_action.text, "👉👊")
          end
          if n_action.e then
            n_action.text = n_action.e .. " " .. n_action.text
          end
          if choose then
            n_action.text = choose .. n_action.text
          end 
          if n_action.d then
            n_action.text = n_action.text .. n_action.d
          end
          n_action.text = mustEnd(n_action.text, ".")

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
      ["timer-that-does"] = function(self, specifier)
        return {
          interval = specifier.interval,
          fn = function() self:doThis(specifier.key, specifier.args) end,
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
      ["use-action"] = function(self, action_item)
        local first_arg
        if action_item.getfn or action_item.dothis then
          action_item.get = action_item.get or "c"
          first_arg = self:get(action_item.get)
        else
          first_arg = self
        end
        local args = {}
        if not isListOrEmptyTable(action_item.args) then
          args = {action_item.args}
        end
        for k, v in pairs(action_item.args) do
          if args.isprompttbl then
            args[k] = map(v, {_pm = false}, {tolist = true})[1]
          else
            args[k] = v
          end
        end
        action_item.filter = action_item.filter or st
        if action_item.dothis then
          action_item.dothis(action_item.filter(first_arg), table.unpack(args))
        elseif action_item.key then
          self:doThis(action_item.key, table.unpack(args))
        else
          local res = action_item.getfn(first_arg, table.unpack(args))
          action_item.act = action_item.act or "ca"
          if action_item.act == "ca" then
            action_item.act = "choose-action"
          elseif action_item.act == "cia" then
            action_item.act = "choose-item-and-then-action"
          elseif action_item.act == "ciia" then
            action_item.act = "choose-item-item-and-then-action"
          end
          self:doThis(action_item.act, action_item.filter(res))
        end
      end,
      ["update"] = function() end,
      ["get-as-do"] = function(self, key)
        self:get(key)
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
  get_all = bind(getOrDoAll, {a_use, "get"}),
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
  doThis_all = bind(getOrDoAll, {a_use, "doThis"}),
  setContents = function(self, value)
    if not self.super then self.contents = value end
    if self.potential_interfaces then
      self.interface = ovtable.new()
      for potential_interface, potential_interface_constructor  in self.potential_interfaces:pairs() do
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

local identifier = 0


BasicInterfaceDefaultTemplate = concat(InterfaceDefaultTemplate, {properties = NonHeritableInterfacePropsTemplate})

--- @param interface_specifier ItemSpecifier
--- @param super ComponentInterface
--- @return NonRootComponentInterface
function NewDynamicContentsComponentInterface(interface_specifier, super)
  --- @type NonRootComponentInterface
  local interface = memoize(glue)(InterfaceDefaultTemplate, interface_specifier)
  interface.id = identifier
  identifier = identifier + 1
  if super then 
    interface.super = super
    interface.root_super = super.root_super
    interface:setContents(super.root_super:get("c"))
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
  if contents == nil then 
    error("Contents for a component interface may not be nil.", 0)
  end
  --- @type RootComponentInterface
  local interface =  memoize(glue)(InterfaceDefaultTemplate, interface_specifier)
  interface.id = identifier
  identifier = identifier + 1
  interface.properties.getables["is-" .. interface.type] = function() return true end -- in the root, we can be sure that the is-<type> is true
  interface.root_super = interface
  interface:setContents(contents)
  interface.action_table = memoize(concat)(InterfaceDefaultTemplate.action_table, interface_specifier.action_table, root_action_table)
  return interface
end

--- @alias BoundRootInitializeInterface fun(contents: any): RootComponentInterface