local server = require("src.server.server")

local serving = server.new({
    port = '3000',
    host = 'localhost'
})

serving:start()
