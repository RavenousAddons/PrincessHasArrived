local ADDON_NAME, ns = ...
local L = ns.L

local soundTypesList = {}
for soundTypes in pairs(ns.data.soundTypes) do
    table.insert(soundTypesList, soundTypes)
end

function PrincessHasArrived_OnLoad(self)
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("CHAT_MSG_ADDON")
end

function PrincessHasArrived_OnEvent(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        local isInitialLogin, isReloadingUi = ...
        C_ChatInfo.RegisterAddonMessagePrefix(ns.name)
        ns:SetOptionDefaults()
        ns:CreateSettingsPanel(PHA_options, ns.data.defaults, L.Settings, ns.title, ns.prefix, ns.version)
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
   elseif event == "CHAT_MSG_ADDON" then
        local addonName, soundType, channel, sender, _ = ...
        if addonName ~= ns.name then
            return
        end
        ns:ReceivedSound(soundType, sender)
    end
end

SlashCmdList["PRINCESSHASARRIVED"] = function(message)
    message = message and ns:Trim(message) or nil
    if message == "c" or message:match("con") or message == "o" or message:match("opt") or message:match("sett") or message:match("togg") then
        -- Open settings window
        ns:OpenSettings()
    elseif message == "h" or message:match("help") then
        -- Print ways to interact with addon
        ns:PrettyPrint(L.Help .. "|n" .. table.concat(soundTypesList, ", "))
    elseif message == "m" or message:match("mute") or message == "s" or message:match("sound") then
        PHA_options.PHA_sound = PHA_options.PHA_sound ~= true and true or false
        ns:PrettyPrint(L.SoundsToggled:format((PHA_options.PHA_sound and _G.VIDEO_OPTIONS_ENABLED or _G.MUTED):lower()))
    else
        -- Process the message for soundTypes
        local soundType = (message ~= nil and message ~= "") and message:lower() or nil
        local channel = ns:GetChannel()
        if channel then
            if soundType then
                -- Exact match
                if ns.data.soundTypes[soundType] then
                    ns:SendSound(soundType, channel)
                    return
                end
                -- Alias exact match
                if ns.data.soundTypeAliases[soundType] then
                    ns:SendSound(ns.data.soundTypeAliases[soundType], channel)
                    return
                end
                -- Fuzzy match
                for soundTypeLookup, _ in pairs(ns.data.soundTypes) do
                    if soundTypeLookup:match(soundType) or soundType:match(soundTypeLookup) then
                        ns:SendSound(soundTypeLookup, channel)
                        return
                    end
                end
                -- Alias fuzzy match
                for soundTypeAlias, soundTypeLookup in pairs(ns.data.soundTypeAliases) do
                    if soundTypeAlias:match(soundType) or soundType:match(soundTypeAlias) then
                        ns:SendSound(soundTypeLookup, channel)
                        return
                    end
                end
            end
            -- Default/Fallback
            ns:SendSound("chime", channel)
        else
            ns:PrettyPrint(L.SendFailed)
        end
    end
end
SLASH_PRINCESSHASARRIVED1 = "/" .. ns.command