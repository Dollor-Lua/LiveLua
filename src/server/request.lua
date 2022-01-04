-- based off of request.lua from pegasus.lua
local sutils = require("src.utils.stringUtils")

local request = {}
request.__index = request

request.firstLineProtocol = "^(.-)%s(%S+)%s*(HTTP%/%d%.%d)"
request.headerProtocol = '([%w-]+): ([%w %p]+=?)'

request.new = function(port, client, server)
    local req = {
        client = client,
        server = server,
        port = port,
        ip = client:getpeername(),
        querystring = {},
        _path = nil,
        _first_line = nil,
        _method = nil,
        _headersParsed = false,
        _headers = {},
        _contentDone = 0,
        _contentLength = nil
    }

    return setmetatable(req, request)
end

function request:parse()
    if self._first_line ~= nil then
        return
    end

    local status, partial
    self._first_line, status, partial = self.client:receive()
    if self._first_line == nil or status == 'timeout' or status == 'closed' or partial == '' then
        return
    end

    local path
    self._method, path = string.match(self._first_line, request.firstLineProtocol)

    if not self._method then
        self.client:close()
        self.server:close()
        return
    end

    local file = ""
    if #path then
        file, self.querystring = string.match(path, "^([^#?]+)[#|?]?(.*)")
        file = table.concat(sutils.split(file, "\\"), '/')
    end

    self._path = file
end

function request:post()
    if self:method() ~= 'POST' then
        return nil
    end

    return self:getBody()
end

function request:parseHeaders()
    if self._headerParsed then
        return self._headers
    end

    self:parse()

    local data = self.client:receive()

    while data ~= nil and #data > 0 do
        local key, value = string.match(data, request.headerProtocol)

        if key and value then
            self._headers[key] = value
        end

        data = self.client:receive()
    end

    self._headerParsed = true
    self._contentLength = tonumber(self._headers["Content-Length"] or 0)
    return self._headers
end

function request:method()
    self:parse()
    return self._method
end

function request:path()
    self:parse()
    return self._path
end

function request:getBody(size)
    size = size or self._contentLength

    if self._contentLength == nil or self._contentDone >= self._contentLength then
        return false
    end

    local amount = math.min(self._contentLength - self._contentDone, size)
    local data, err, partial = self.client:receive(amount)

    if err == 'timeout' then
        data = partial
    end

    self._contentDone = self._contentDone + #data
    return data
end

return request
