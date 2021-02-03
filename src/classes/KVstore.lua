local Class = require("Classy")

---@class KVstore
--- Simple KeyStore
---@field data table all currently held key=value pairs
local KVstore = Class("KVstore", {data = {}})
function KVstore:new(data)
    if data then for k, v in pairs(data) do self.data[k] = v end end
end
function KVstore:setValue(key, value) self.data[key] = value end
function KVstore:getValue(key) return self.data[key] end
function KVstore:purge() self.data = {} end

return KVstore