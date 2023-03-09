--- @type ItemSpecifier
WindowItemSpecifier = {
  type = "window-item",
  properties = {
    getables = {
      ["is-implementation"] = returnTrue,
      ["is-interface"] = returnTrue,
      ["raw-title"] = function(self)
        return self:get("contents"):title()
      end,
      ["running-application"] = function(self)
        return self:get("contents"):application()
      end,
      ["running-application-item"] = function(self)
        return CreateRunningApplicationItem(self:get("running-application"))
      end,
      ["application-item"] = function(self)
        return CreateApplicationItem(self:get("application-name"))
      end,
      ["application-name"] = function(self)
        return self:get("running-application"):name()
      end,
      ["snapshot"] = function(self)
        return self:get("contents"):snapshot()
      end,
      ["accessibility-interface"] = function(self)
        hs.axuielement.windowElement(self:get("contents"))
      end,
      ["rect"] = function(self)
        return self:get("contents"):frame()
      end,
      ["point-tl"] = function (self)
        return self:get("contents"):topLeft()
      end,
      ["point-tr"] = function(self)
        local rect = self:get("rect")
        rect.x = rect.x + rect.w
        return rect
      end,
      ["point-bl"] = function(self)
        local rect = self:get("rect")
        rect.y = rect.y + rect.h
        return rect
      end,
      ["point-br"] = function(self)
        return self:get("contents"):bottomRight()
      end,
      ["size"] = function(self)
        return self:get("contents"):size()
      end,
      ["relative-center"] = function(self)
        return self:get("size").center
      end,
      ["point-c"] = function(self)
        return self:get("rect").center
      end,
      ["point-with-offset-from"] = function(self, specifier)
        return self:get("point-" .. specifier.from):move(specifier.delta)
      end,
      ["point-offset-tl"] = function (self, delta)
        return self:get("point-with-offset-from", { from = "tr", delta = delta })
      end,
      ["point-offset-tr"] = function(self, delta)
        return self:get("point-with-offset-from", { from = "tr", delta = delta })
      end,
      ["point-offset-bl"] = function(self, delta)
        return self:get("point-with-offset-from", { from = "bl", delta = delta })
      end,
      ["point-offset-br"] = function(self, delta)
        return self:get("point-with-offset-from", { from = "br", delta = delta })
      end,
      ["point-offset-c"] = function(self,delta)
        return self:get("point-with-offset-from", { from = "c", delta = delta })
      end,
      ["corresponding-tabs-or-self"] = function(self)
        local tabs = self:get("list-of-tabs")
        if tabs and #tabs > 0 then
          return tabs
        else
          return self.root_super
        end
      end,
      ["to-string"] = function(self)
        return ("%s (%s)"):format(self:get("title"), self:get("application-name"))
      end,
      ["screen"] = function(self)
        return self:get("contents"):screen()
      end,
    },
    doThisables = {
      ["do-accessibility-element"] = function(self, specifier)
        self:get("accessibility-interface"):elementSearch(specifier.callback, specifier.criteria)
      end,
      ["focus"] = function(self)
        self:get("contents"):focus()
      end,
      ["close"] = function(self)
        self:get("contents"):close()
      end,
      ["make-main"] = function(self)
        self:get("contents"):becomeMain()
      end,
      ["do-on-application-w-window-as-main"] = function(self, callback)
        local application = self:get("running-application-item")
        local prev_main = application:get("main-window-item")
        self:doThis("make-main")
        callback(application)
        if prev_main then
          prev_main:doThis("make-main")
        end
      end,
      ["set-size"] = function(self, size)
        self:get("contents"):setSize(size)
      end,
      ["set-rect"] = function (self, specifier)
        self:get("contents"):move(specifier)
      end,
      ["set-position"] = function(self, position)
        self:get("contents"):setTopLeft(position)
      end,
      ["set-grid"] = function(self, grid)
        hs.grid.set(grid, self:get("screen"))
      end,
      ["set-cell"] = function (self, cell)
        hs.grid.set(self:get("contents"), cell, self:get("screen"))
      end,
      ["click-relative-to"] = function(self, specifier)
        local click_point = self:get("point-with-offset-from", specifier)
        hs.eventtap.leftClick(click_point)
      end,
      ["click-series"] = function (self, specifier_list)
        doSeries(specifier_list)
      end,
      ["scroll-relative-to"] = function (self, specifier)
        local scroll_point = self:get("point-with-offset-from", specifier)
        hs.mouse.absolutePosition(scroll_point)
        hs.eventtap.scrollWheel(specifier.scroll_delta, {}, "pixel")
      end,


    }
  },
  potential_interfaces = ovtable.init({
    { key = "implementation", value = CreateWindowImplementationItem },
    { key = "interface", value = CreateWindowInterfaceItem },
  })
}

--- @type BoundNewDynamicContentsComponentInterface
CreateWindowItem = bindArg(NewDynamicContentsComponentInterface, WindowItemSpecifier)

