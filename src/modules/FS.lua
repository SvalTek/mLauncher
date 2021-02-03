FS = {}

DIR_SEPERATOR = _G['package'].config:sub(1, 1)

---* Check if a file or directory exists in path ,
---| Path is Relative to Server Root.
---@param path string path - the path to a file or directory to test
function FS.Exists(path)
    local ok, err, code = os.rename(path, path)
    if not ok then
        if code == 13 then
            -- Permission denied, but it exists
            return true
        end
    end
    return ok, err
end

function FS.isFile(path)
    local f = io.open(path, 'r')
    if f then
        f:close()
        return true
    end
    return false
end
-- Check if a directory exists path
function FS.isDir(path)
    path = string.gsub(path .. '/', '//', '/')
    local ok, err, code = os.rename(path, path)
    if ok or code == 13 then return true end
    return false
end

function FS.mkDir(path)
    local ok, Result = os.execute('mkdir ' .. path:gsub('/', '\\'))
    if not ok then
        return nil, 'Failed to Create ' .. path .. ' Directory! - ' .. Result
    else
        return true, 'Successfully Created ' .. path .. ' Directory!'
    end
end

---* Write file to Disk
---@param path string       path of file to Write, starts in Server root
---@param data any          File Contents to Write
---@return boolean,string   true,nil and a message
function FS.writeFile(path, data)
    local thisFile = assert(io.open(path, 'w'))
    if thisFile ~= nil then
        local fWritten = thisFile:write(data)
        thisFile:close()
        if fWritten ~= nil then
            return true, 'Success Writing File: <ServerRoot>/' .. path
        else
            return nil, 'Failed to Write Data to File: <ServerRoot>/' .. path
        end
    else
        return nil, 'Failed to Open file for Writing: <ServerRoot>/' .. path
    end
end

---* Read File from Disk
---@param path string      path of file to Write, starts in Server root
---@return boolean,any     true,nil and file content or message
function FS.readFile(path)
    local thisFile, errMsg = io.open(path, 'r')
    if thisFile ~= nil then
        local fContent = thisFile:read('*all')
        thisFile:close()
        if fContent ~= '' or nil then
            return true, fContent
        else
            return nil, 'Failed to Read from File: ' .. path
        end
    else
        return nil, 'Error Opening file: ' .. path .. ' io.open returned:' .. errMsg
    end
end

function FS.joinPath(...)
    local parts = {...}
    -- TODO: might be more useful to handle empty/missing parts
    if #parts < 2 then error('joinpath requires at least 2 parts', 2) end
    local r = parts[1]
    for i = 2, #parts do
        local v = string.gsub(parts[i], '^[' .. DIR_SEPERATOR .. ']', '')
        if not string.match(r, '[' .. DIR_SEPERATOR .. ']$') then r = r .. '/' end
        r = r .. v
    end
    return r
end

--- normalises a path based on provided seperator when not specified uses platform defined, `_G['package'].config:sub(1, 1)`
function FS.translate(p, sep)
    if (type(p) == "table") then
        local result = { }
        for _, value in ipairs(p) do
            table.insert(result, FS.translate(value))
        end
        return result
    else
        if (not sep) then
            if (DIR_SEPERATOR == "\\") then
                sep = "\\"
            else
                sep = "/"
            end
        end
        local result = p:gsub("[/\\]", sep)
        return result
    end
end

return FS