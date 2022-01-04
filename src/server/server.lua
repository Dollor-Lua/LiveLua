local socket = require("socket")
local handler = require("src.server.serverHandler")

local server = {}
server.__index = server

server.new = function(options)
    options = options or {}
    local serve = {}

    serve.host = options.host or '127.0.0.1'
    serve.port = options.port or '8000'
    serve.timeout = options.timeout or 1
    serve.location = ''
    serve._running = false
    serve._closeCallback = nil

    return setmetatable(serve, server)
end

function server:start(callback)
    local serve = assert(socket.bind(self.host, self.port))
    print("Server started on " .. self.host .. ":" .. self.port .. "/")

    self._running = true

    while self._running do
        local client, errmsg = serve:accept()

        if client then
            client:settimeout(self.timeout, 'b')
            handler:onRequest(self.port, client, serve)
        else
            io.stderr("ERROR: Failed to accept a client: " .. errmsg .. '\n')
        end
    end

    if self._closeCallback then
        self._closeCallback()
    end
end

function server:close(callback)
    self._closeCallback = callback
    self._running = false
end

return server
