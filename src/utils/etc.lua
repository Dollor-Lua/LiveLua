local cwd_A = io.popen("cd", "r")
local cwd = cwd_A:read()
cwd_A:close()

local etc = {}

etc.getCwd = function()
    local cwd_A = io.popen("cd", "r")
    local cwd = cwd_A:read()
    cwd_A:close()

    return cwd
end

etc.cacheCwd = cwd

return etc
