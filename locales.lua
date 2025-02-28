local _, ns = ...
local L = {}
ns.L = L

setmetatable(L, { __index = function(t, k)
    local v = tostring(k)
    t[k] = v
    return v
end })

local sounds = ns.data.sounds

L.Received = "|cffffff00%s|r sent a |cffffff00%s%s|r to %s." -- sender, soundType, muted, channel
L.SendWarning = "You must wait |cffffff00%s|r second%s before sending a sound again." -- number, string
L.SendFailed = "You need to be in a group or instance to send sounds!"
L.SoundsToggled = "Sounds have been |cffffff00%s|r."
L.Help = "Sounds you can send:"
L.AddonCompartmentTooltip1 = "|cff" .. ns.color .. "Left-Click:|r Share Sound"
L.AddonCompartmentTooltip2 = "|cff" .. ns.color .. "Right-Click:|r Open Settings"

L.Settings = {
    [1] = {
        title = "Sounds",
        options = {
            [1] = {
                key = "sound",
                name = "Sounds",
                tooltip = "Allows sounds to play.",
            },
            [2] = {
                key = "soundChannel",
                name = "Sound Channel",
                tooltip = "Which channel should sounds play from?",
                choices = function(container)
                    for index = 1, #ns.data.soundChannels do
                        container:Add(ns.data.soundChannels[index], ns.data.soundChannels[index])
                    end
                end,
            },
            [3] = {
                key = "defaultSound",
                name = "Your Default Sound",
                tooltip = "What sound to play when calling the slash command without any parameters.",
                choices = function(container)
                    for index = 1, #sounds do
                        local sound = sounds[index]
                        local emoteString = (sound.action or sound.reaction) and " (" .. (sound.action and "A" or "") .. ((sound.action and sound.reaction) and "/" or "") .. (sound.reaction and "R" or "") .. ")" or ""
                        container:Add(sound.type, ns:Capitalize(sound.type) .. emoteString)
                    end
                end,
            },
        },
    },
    [2] = {
        title = "Emotes",
        options = {
            [1] = {
                key = "allowActions",
                name = "Actions",
                tooltip = "Allows your character to perform certain emotes as actions alongside some sounds that you send.",
            },
            [2] = {
                key = "allowReactions",
                name = "Reactions",
                tooltip = "Allows your character to perform certain emotes as actions alongside some sounds that you receive.",
            },
        },
    },
}