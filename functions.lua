local ADDON_NAME, ns = ...
local L = ns.L

local soundTypes = ns.data.soundTypes
local soundTypeAliases = ns.data.soundTypeAliases

function ns:SetOptionDefaults()
    PHA_options = PHA_options or {}
    for option, default in pairs(ns.data.defaults) do
        ns:SetOptionDefault(PHA_options, option, default)
    end
end

function ns:GetChannel()
    local partyMembers = GetNumSubgroupMembers()
    local raidMembers = IsInRaid() and GetNumGroupMembers() or 0
    if IsInInstance() then
        return "INSTANCE"
    elseif raidMembers > 1 then
        return "RAID"
    elseif partyMembers > 0 then
        return "PARTY"
    end
    return nil
end

function ns:Trim(value)
   local a = value:match("^%s*()")
   local b = value:match("()%s*$", a)
   return value:sub(a, b - 1)
end

function ns:Capitalize(value)
    return value:gsub("(%l)(%w*)", function(first, rest)
        return first:upper() .. rest:lower()
    end)
end

function ns:ProcessSound(soundType)
    local soundType = (soundType ~= nil and soundType ~= "") and soundType:lower() or nil
    local channel = ns:GetChannel()
    local target
    if not channel and PHA_options.PHA_debug then
        channel = "WHISPER"
        target = UnitName("player") .. "-" .. GetNormalizedRealmName("player")
    end
    if channel then
        if soundType then
            -- Exact match
            for index = 1, #soundTypes do
                local lookup = soundTypes[index]
                if lookup.type == soundType then
                    ns:SendSound(lookup.type, channel, target)
                    return
                end
            end
            -- Alias exact match
            if soundTypeAliases[soundType] then
                ns:SendSound(soundTypeAliases[soundType], channel, target)
                return
            end
            -- Fuzzy match
            for index = 1, #soundTypes do
                local lookup = soundTypes[index]
                if lookup.type:match(soundType) or soundType:match(lookup.type) then
                    ns:SendSound(lookup.type, channel, target)
                    return
                end
            end
            -- Alias fuzzy match
            for alias, lookup in pairs(soundTypeAliases) do
                if alias:match(soundType) or soundType:match(alias) then
                    ns:SendSound(lookup, channel, target)
                    return
                end
            end
        end
        -- Default/Fallback
        ns:SendSound(ns:OptionValue(PHA_options, "defaultSound"), channel, target)
    else
        ns:PrettyPrint(L.SendFailed)
    end
end

function ns:SendSound(soundType, channel, target)
    if not ns.data.toggles.sentSound then
        ns:Toggle("sentSound", ns.data.timeout)
        local response = C_ChatInfo.SendAddonMessage(ns.name, soundType, channel, target)
        return
    end
    local timeRemaining = math.max(ns.data.toggles.sentSound - GetServerTime(), 1)
    ns:PrettyPrint(L.SendWarning:format(timeRemaining, timeRemaining ~= 1 and "s" or ""))
end

function ns:ReceivedSound(soundType, sender)
    for index = 1, #soundTypes do
        local lookup = soundTypes[index]
        if lookup.type == soundType then
            ns:PlaySound(PHA_options, lookup.id)
        end
    end
    C_GamePad.SetVibration("Low", 0.2)
    ns:PrettyPrint(L.Received:format(sender, soundType, ns:OptionValue(PHA_options, "sound") and "" or " (" .. _G.MUTED:lower() .. ")"))
end
