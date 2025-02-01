local ADDON_NAME, ns = ...
local L = ns.L

-- Load the Addon

function PrincessHasArrived_OnLoad(self)
    self:RegisterEvent("PLAYER_ENTERING_WORLD")
    self:RegisterEvent("CHAT_MSG_ADDON")
end

-- Event Triggers

function PrincessHasArrived_OnEvent(self, event, ...)
    if event == "PLAYER_ENTERING_WORLD" then
        local isInitialLogin, isReloadingUi = ...
        ns.registered = C_ChatInfo.RegisterAddonMessagePrefix(ns.name)
        ns.race = ns:GetRace()
        ns.gender = ns:GetGender()
        ns:SetOptionDefaults()
        ns:CreateSettingsPanel(PHA_options, ns.data.defaults, L.Settings, ns.title, ns.prefix, ns.version)
        self:UnregisterEvent("PLAYER_ENTERING_WORLD")
   elseif event == "CHAT_MSG_ADDON" then
        local addonName, soundType, channel, sender, _ = ...
        if addonName ~= ns.name then
            return
        end
        ns:ReceivedSound(soundType, sender, channel)
    end
end

-- Addon Compartment Handling

AddonCompartmentFrame:RegisterAddon({
    text = ns.title,
    icon = ns.icon,
    registerForAnyClick = true,
    notCheckable = true,
    func = function(button, menuInputData, menu)
        local mouseButton = menuInputData.buttonName
        if mouseButton == "RightButton" then
            ns:OpenSettings()
        else
            ns:ProcessSound()
        end
    end,
    funcOnEnter = function(menuItem)
        GameTooltip:SetOwner(menuItem)
        GameTooltip:SetText(ns.title .. "  v" .. ns.version)
        GameTooltip:AddLine(" ", 1, 1, 1, true)
        GameTooltip:AddLine(L.AddonCompartmentTooltip1, 1, 1, 1, true)
        GameTooltip:AddLine(L.AddonCompartmentTooltip2, 1, 1, 1, true)
        GameTooltip:Show()
    end,
    funcOnLeave = function()
        GameTooltip:Hide()
    end,
})

-- Slash Command Handling

local sounds = ns.data.sounds
local soundTypesList = {}
for index = 1, #sounds do
    local sound = sounds[index]
    soundTypesList[index] = ns:Capitalize(sound.type)
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
        -- Process the message for sound types
        ns:ProcessSound(message)
    end
end
SLASH_PRINCESSHASARRIVED1 = "/" .. ns.command