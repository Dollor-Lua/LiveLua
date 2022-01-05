local sutils = require("src.utils.stringUtils")

local path = {}

local joiner = package.config:sub(1, 1)

path.normalize = function(path)
    local basic = table.concat(sutils.split(table.concat(sutils.split(path, "/"), "\\"), "\\"), joiner)
    local trueNorm = {}
    for _, v in pairs(sutils.split(basic, joiner)) do
        if v ~= "" then
            table.insert(trueNorm, v)
        end
    end

    return table.concat(trueNorm, joiner)
end

path.delimeter = joiner == "/" and ":" or ";"
path.separator = joiner

path.join = function(...)
    local s1 = {}
    for _, mpath in pairs({...}) do
        for _, subpath in pairs(sutils.split(path.normalize(mpath), joiner)) do
            if subpath ~= "" and subpath ~= " " then
                table.insert(s1, subpath)
            end
        end
    end

    return table.concat(s1, joiner)
end

return path
