local bundle = require("luvi").bundle
bundle.register("common", "./common.lua")
require("common")
local uv = require("uv")
local FS = require("modules.FS")
local JSON = require("modules.JSON")
--
-- ─────────────────────────────────────────────────────────────── APP CONFIG ─────
--
Application.NAME = "mLauncher"
Application.VERSION = "0.1a"
-- -------------------------------------------------------------------------- --

local programDir = uv.cwd()

--- load program config
local function loadConfig()
    local configFile = FS.joinPath(programDir,"settings.json")
    local readOk,data = FS.readFile(configFile)
    if readOk and data then
        Application.data = JSON.parse(data)
        return true
    end
    return false
end

local function getServers()
    local servers = {}
    for idx,v in ipairs(Application.data["servers"]) do
        servers[idx] = v
    end
    return servers
end

local function getModsPath(game)
    if game == "experimental" then
        return Application.data.settings["miscreatedexp_path"]
    elseif game == "normal" then
        return Application.data.settings["miscreated_path"]
    end
end

local function launchGame(server,purge_mods)
    local game = {
        experimental = "912290",
        normal = "299740"
    }

    print()
    print("","-- LAUNCHING --","\n")

    --- Handle Mod deletion
    local data = Application.data
    local mods_path
    if server.experimental then
        mods_path = FS.joinPath(getModsPath("experimental"),"Mods")
    else
        mods_path = FS.joinPath(getModsPath("normal"),"Mods")
    end
    if data.settings['purge_mods'] or purge_mods then
        local delete_path = FS.translate(mods_path)
        print(string.format("Purging mods in: %q",delete_path))
        local delete_cmd = string.format("rmdir /S /Q %q",delete_path)
        print(" > executing: ",delete_cmd)
        os.execute(delete_cmd)
    end

    --- setup launch command
    local cmd
    local launchCommand = string.expand("explorer steam://run/${game}/connect/+connect ${hostname} ${port}",server)
    if server.experimental then
        cmd =  string.expand(launchCommand,{game = game["experimental"]})
    else
        cmd = string.expand(launchCommand,{game = game["normal"]})
    end
    print("Starting Miscreated with Command:", cmd)
    os.execute(cmd)
    os.exit()
end

--- process menu options
local function processOption(line,purge)
    local servers = getServers()
    if servers[tonumber(line)] then
        launchGame(servers[tonumber(line)],purge)
    else
        print("   >> Invalid Option...! check serverlist")
        return
    end
end
--
-- ────────────────────────────────────────────────────────────────── CONSOLE ─────
--

local function showServers(servers)
    print("Server List >")
    for idx,server in ipairs(servers) do
        print("\n","Server: "..tostring(idx), server.name)
        local isExperimental = (server.experimental == true)
        print("","Hostname: "..server.hostname, "Port: "..server.port,"Experimental:"..tostring(isExperimental))
    end
end


print(Application.NAME,Application.VERSION)

if loadConfig() then
    print("Config Loaded")
    if args and (#args >= 1) then
        local opt = args[1]
        local purge = false
        if args[2] == "true" then purge = true end
        processOption(opt,purge)
    end
    showServers(getServers())
end

local function prompt()
    print("\nChoice: ",'',':: [s: show servers, q: quit]')
end


local do_exit = false
prompt()
while not do_exit do
    local line = io.read("*l")

    if (line) then
        if line == "q" then
            print("Qitting....")
            return
        elseif line == "s" then
            showServers(getServers())
        else
            processOption(line)
        end
    else
        return
    end
    prompt()
end