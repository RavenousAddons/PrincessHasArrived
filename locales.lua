local _, ns = ...
local L = {}
ns.L = L

setmetatable(L, { __index = function(t, k)
    local v = tostring(k)
    t[k] = v
    return v
end })

L.Received = "|cffffff00%s|r sent a |cffffff00%s%s|r." -- sender, soundType
L.SendWarning = "You must wait |cffffff00%s|r second%s before sending a sound again." -- number, string
L.SendFailed = "You need to be in a group or instance to send sounds!"
L.SoundsToggled = "Sounds have been |cffffff00%s|r."
L.Help = "Sounds you can send:"

L.Settings = {
    [1] = {
        title = "General Options",
        options = {
            [1] = {
                key = "sound",
                name = "Sounds",
                tooltip = "Allows sounds to play.",
            },
        },
    },
}