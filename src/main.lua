if arg[1] == "serve" then
    local server = require("src.server.server")

    local serving = server.new({
        port = '3000',
        host = 'localhost'
    })

    serving:start()
elseif arg[1] == "init" then
    -- generate folders in the current working directory
end
