local sutils = {}

sutils.split = function(string, delim)
    delim = delim or "%s"

    if delim == "" then
        delim = "%s"
    end

    local t = {}
    for str in string.gmatch(string .. delim, "(.-)" .. delim) do
        table.insert(t, str)
    end

    return t
end

return sutils
