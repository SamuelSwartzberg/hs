-- CHORD MANAGEMENT

--- @class GlobalChordManager
--- @field package chordManagers table<ChordManager>
--- @field public createChordManager fun(self: GlobalChordManager, modifiers: modifier[], key: string): ChordManager
--- @field public disable fun(self: GlobalChordManager): nil

--- @class ChordManager
--- @field package enabled boolean
--- @field package shortcuts table<hs.hotkey>
--- @field public enable fun(self: ChordManager): nil
--- @field public disable fun(self: ChordManager): nil
--- @field public addShortcut fun(self: ChordManager, modifiers: modifier[], key: string, callback: fun(): nil): nil

function createGlobalChordManager()
    --- @type GlobalChordManager
    local globalChordManager = {}
    globalChordManager.chordManagers = {}
    function globalChordManager:disable()
        for _, chordManager in ipairs(self.chordManagers) do chordManager:disable() end
    end

    function globalChordManager:createChordManager(modifiers, key)
        --- @type ChordManager
        local chordManager = {}
        chordManager.shortcuts = {}
        chordManager.enabled = false

        function chordManager:enable()
            if not self.enabled then
                self.enabled = true
                globalChordManager:disable()

                for _, shortcut in ipairs(self.shortcuts) do
                    shortcut:enable()
                end
            end
        end

        function chordManager:disable()
            self.enabled = false
            for _, shortcut in ipairs(self.shortcuts) do shortcut:disable() end
        end

        function chordManager:addShortcut(modifiers, key, callback)
            self.shortcuts[#self.shortcuts + 1] =
            hs.hotkey.new(modifiers, key, callback)
        end

        hs.hotkey.bind(modifiers, key, function() chordManager:enable() end)
        globalChordManager.chordManagers[#globalChordManager.chordManagers + 1] = chordManager

        chordManager:addShortcut({}, "escape", function() chordManager:disable() end)

        return chordManager
    end

    return globalChordManager
end

