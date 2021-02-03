local bundle = require("luvi").bundle
bundle.register("utils", "./common/utils.lua")
bundle.register("Classy", "./common/Classy.lua")
local utils = require("utils")
bundle.register("common_methods", "./common/methods.lua")
require("common_methods")

local function LoadBundledScripts(dir, ns)
    local bundles = bundle.readdir(dir)
    for index, filename in ipairs(bundles) do
        local scriptName = string.gsub(filename, ".lua$", "")
        local scriptFile = string.format("%s/%s", dir, scriptName .. ".lua")
        local NameSpace = (ns or "Application") .. "." .. scriptName
        print(string.format("Loading Bundled Script: %s", scriptFile), NameSpace)
        bundle.register(NameSpace, scriptFile)
    end
end

--- The Main Application
local App = {
    NAME = "Unset",
    VERSION = "Unset"
}
local App_Meta = {__index = App, LoadBundledScripts = LoadBundledScripts}

Application = setmetatable({}, App_Meta)
LoadBundledScripts("./modules", "modules")
_G['inspect'] = require("modules.inspect")
LoadBundledScripts("./classes", "classes")

local KVstore = require("classes.KVstore")
Application['CONFIG'] = KVstore {DEBUG = false, LOGFILE = "./app.log"}