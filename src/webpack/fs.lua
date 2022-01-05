local path = require('path')

local fs = {}

fs.cwd = io.popen("cd", "r"):read("l")

fs.isDir = function(path)
    local f = io.open(path, "r")
    local ok, err, code = f:read(1)
    f:close()
    return code == 21
end

fs.getAllFilesInDir = function(dir)
    local command = 'dir "' .. dir .. '" /b /ad && dir "' .. dir .. '" /b'

    if package.config:sub(1, 1) == "/" then
        command = 'ls -A "' .. dir .. '"'
    end

    local files = {}
    for dir in io.popen(command):lines() do
        table.insert(files, dir)
    end

    local selected = {}
    for file in files do
        if fs.isDir(path.join(fs.cwd, file)) then
            local s = fs.getAllFilesInDir(path.join(fs.cwd, file))
            for f in s do
                table.insert(selected, f)
            end
        else
            table.insert(selected, path.join(fs.cwd, file))
        end
    end

    return selected
end

return fs
