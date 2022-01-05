package.path = package.path .. ";./?.lua"
local fs = require("fs")

local webpacker = {}

webpacker.read = function(el)
    local file = io.open(el, "r")
    local contents = file:read()
    file:close()

    return contents;
end

webpacker.compile = function(folder)

end

return webpacker
