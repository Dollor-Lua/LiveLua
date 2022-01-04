local request = require("src.server.request")
local response = require("src.server.response")

local handler = {}
handler.__index = {}

handler.new = function(callback, location)
    local handlerMain = {
        callback = callback,
        location = location or ''
    }

    return setmetatable(handlerMain, handler)
end

function handler:processBodyData(data, stayOpen, response)
    return data
end

function handler:onRequest(port, client, server)
    local request = request.new(port, client, server)

    if not request:method() then
        client:close()
        return
    end

    local res = response.new(client, self)
    res.request = request

    if request:path() and self.location ~= '' then
        if self.callback then
            self.callback(request:method(), request:path(), request:parseHeaders())
        else
            local testData =
                [[<!DOCTYPE html><html lang="en"><head><meta charset="UTF-8"><meta http-equiv="X-UA-Compatible" content="IE=edge"><meta name="viewport" content="width=device-width, initial-scale=1.0"><title>Live Lua!</title><style>* {margin: 0;font-family: Arial, Helvetica, sans-serif;}</style></head><body><div style="width:100%;height:100%;background-color:#000;position:absolute;margin:0;"><h1 style="position:absolute;width:fit-content;left:50%;transform:translateX(-50%);color:#fff;top:7.5%;">Woo! You've got Live Lua up and running!</h1><img src="https://github.com/Dollor-Lua/LuaS/blob/main/LuaSLogo.png?raw=true" style="top:45%;height:50%;width:fit-content;position:absolute;left:50%;transform:translate(-50%, -50%);"><h1 style="color:#fff;top:85%;left:50%;transform:translate(-50%, -100%);position:absolute;">Get started by editting views/pages/home.el.html</h1></div></body></html>]]

            if request:path() == "/" then
                res:writeData(testData, 'text/html')
            else
                res:statusCode(404)
            end
        end
    end

    if res.status == 404 then
        res:writeDefaultErrorMessage(404)
    end
end

return handler
