local gauge = {}
gauge.__index = gauge

math.clamp = function(a, b, c)
    if a < b then
        return b
    elseif a > c then
        return c
    end
    return a
end

gauge.new = function(text)
    return setmetatable({
        last = "",
        lasti = 0,
        showing = false,
        progress = 0,
        text = text and (" - " .. text) or "",
        currentRotator = "-",
        ended = false
    }, gauge)
end

gauge.corout = function(this)
    this.showing = true
    local t = os.clock()
    repeat
    until os.clock() - t >= 0.05
    this.lasti = this.lasti + 1
    if this.lasti > 4 then
        this.lasti = 1
    end

    if this.ended then
        return
    end

    local possible = "-\\|/"
    this.currentRotator = possible:sub(this.lasti, this.lasti)
    this:setProgress(this.progress, true)
end

function gauge:_write(str)
    io.write(('\b \b'):rep(#self.last))
    io.write(str)
    io.flush()
    self.last = str
end

function gauge:show()
    if not self.showing then
        self.showing = true
        os.execute("chcp 65001 >NUL 2>NUL")

        local last = 0
        local possible = ""

        gauge.corout(self)
    end
end

local red = string.char(27) .. "[31m"
local green = string.char(27) .. "[32m"
local reset = string.char(27) .. "[0m"

function gauge:setProgress(percent, corout)
    local last = self.progress
    self.progress = percent or self.progress or 0
    percent = self.progress
    percent = math.clamp(math.floor(percent), 0, 100)
    if self.showing then
        local tags = math.floor(math.min(percent / 2 + 1, 50))
        local dashes = 50 - tags ~= 0 and ("▒"):rep(50 - tags) or ""
        self:_write(green .. "█" .. ("█"):rep(tags) .. red .. dashes ..
                        (50 - tags ~= 0 and red .. "█ " or green .. "█ ") ..
                        string.format("%0.2f", percent + (last ~= self.progress and math.random(1, 99) / 100 or 0)) ..
                        "% " .. reset .. self.currentRotator .. self.text .. reset)
        if not corout then
            gauge.corout(self)
        end
    end
end

function gauge:endGauge()
    local percent = self.progress
    local tags = math.floor(math.min(percent / 2 + 1, 50))
    local dashes = 50 - tags ~= 0 and ("▒"):rep(50 - tags) or ""
    self:_write(green .. "█" .. ("█"):rep(tags) .. red .. dashes ..
                    (50 - tags ~= 0 and red .. "█ " or green .. "█ ") .. string.format("%0.2f", percent) .. "%" ..
                    reset .. self.text .. reset)
    print(green .. " ✔" .. reset)
    self.ended = true
end

return gauge
