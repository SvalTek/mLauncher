--
-- ──────────────────────────────────────────────────── I ──────────
--   :::::: C L A S S Y : :  :   :    :     :        :          :
-- -------------------------------------------------------------------------- --
--- | V0.1 - Simple Class Builder --{Theros@MisModding}
---@class Classy
--- Simple Class Object
---@field Extend fun():Classy Extend a Classy Object
local Classy = {}
Classy.KnownClasses = {}

function Classy:Create(name, base)
    -- empty class Object
    local Object
    Object = {
        __index = {
            Extend = function(self)
                local obj = {
                    --- this Objects superclass
                    super = self ---@type Classy
                }
                return setmetatable(obj, Object)
            end
        },
        __type = "Object",
        __tostring = function(self) return getmetatable(self).__type end,
        __call = function(self, ...)
            if self['super'] and self.super['new'] then
                self.super.new(self, ...)
            end
            if self['new'] then self:new(...) end
            return self
        end
    }
    -- handle named classes
    if name then
        -- if the class exists, return it.
        if self.KnownClasses[name] then
            return self.KnownClasses[name]
        else
            -- set the Object type
            Object.__type = name

            local obj = {}
            -- populate class definition
            if (type(base) == "table") then
                for k, v in pairs(base) do obj[k] = v end
            end
            setmetatable(obj, Object)
            self.KnownClasses[name] = obj
            return obj
        end
    else
        -- just return a new object
        return setmetatable({}, Object)
    end
end

local meta = {__call = function(self, ...) return self:Create(...) end}

local exports = setmetatable(Classy, meta)
---//RegisterModule("Classy",exports)
return exports
