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
        showing = false,
        progress = 0,
        text = text and (" - " .. text) or ""
    }, gauge)
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
        -- print("[" .. ("-"):rep(20) .. "] 0%" .. self.text)
        gauge:setProgress()
    end
end

function gauge:setProgress(percent)
    percent = percent or self.progress or 0
    percent = math.clamp(math.floor(percent), 0, 100)
    self.progress = percent
    if self.showing then
        local tags = math.floor(math.min(percent / 5 + 1, 20))
        local dashes = 20 - tags ~= 0 and ("-"):rep(20 - tags) or ""
        self:_write("[" .. ("#"):rep(tags) .. dashes .. "] " .. percent .. "%" .. self.text)
    end
end

function gauge:endGauge()
    print(" ✔")
end

return gauge
