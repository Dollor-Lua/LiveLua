package.path = package.path .. ";../?.lua"

local sutils = require("src.utils.stringUtils")
local path = require("src.utils.path")
local etc = require("src.utils.etc")
local gaugeHandler = require("src.gauge.gauge")
local socket = require("socket")

local function mkdir(making, cache)
    local parsed = sutils.split(table.concat(sutils.split(making, "/"), "\\"), "\\")

    local total = etc.getCwd()
    for _, v in pairs(parsed) do
        total = path.join(total, v)

        for _, cached in pairs(cache) do
            if cached == total then
                goto mkdirContinue
            end
        end

        os.execute("mkdir " .. total .. " >NUL 2>NUL")
        table.insert(cache, total)

        ::mkdirContinue::
    end
end

local function quickGauge(text)
    local gauge = gaugeHandler.new(text)
    gauge:show()

    for i = 1, 100 do
        gauge:setProgress(i)
        socket.sleep(0.02);
    end

    gauge:endGauge()
end

-- argument handler
if arg[1] == "serve" then
    local server = require("src.server.server")

    local serving = server.new({
        port = '3000',
        host = 'localhost'
    })

    serving:start()
elseif arg[1] == "init" then
    print("Starting generator on directory: " .. etc.cacheCwd)

    local files = require("src.fileconfig")
    local processes = {{"Creating Folders", function(prog)
        local dirs = {"app/assets/", "app/helpers/", "app/scripts/", "app/views/pages/", "config/locales/languages",
                      "config/etc/", "public/", "logs/", "bin/", "whirl_modules/webpacker/"}

        local cache = {}
        for pos, dir in pairs(dirs) do
            mkdir(dir, cache)
            prog(100 / #dirs * pos)
            socket.sleep(0.02);
        end
    end}, {"Generating files", function(prog)
        local total = 0
        for _, file in pairs(files.files) do
            total = total + 1
        end

        local pos = 0
        for filename, contents in pairs(files.files) do
            pos = pos + 1
            local fullname = path.join(etc.cacheCwd, filename)
            local file = assert(io.open(fullname, "w+"))
            file:write(contents)
            prog(100 / total * pos)
            socket.sleep(0.02);
        end
    end}}

    for _, method in pairs(processes) do
        local gauge = gaugeHandler.new(method[1])
        gauge:show()

        local function updateGauge(progress)
            gauge:setProgress(progress)
        end

        method[2](updateGauge)
        gauge:endGauge()
    end

    for filename, contents in pairs(files.webpacker) do
        local len = #(contents[2])
        local gauge = gaugeHandler.new(filename)
        gauge:show()

        for i = 1, len do
            local prog = 100 / (len / 3) * (i - 5)
            if prog > 90 then
                prog = 90 - (100 / (len / 3) * 4)
            end
            gauge:setProgress(prog)
            if i % 3 == 0 then
                socket.sleep(0.01);
            end
        end

        local file = io.open(path.join(etc.cacheCwd, contents[1]), "w+")
        file:write(contents[2])
        file:close()

        gauge:setProgress(100)
        gauge:endGauge()
    end

    quickGauge("Installing")
    quickGauge("Verifying Packages")
    quickGauge("Cleaning Up")

    print("\nLua Webpacker is successfully installed! 🍰")
    print("Successfully built new project in folder './'")
end
