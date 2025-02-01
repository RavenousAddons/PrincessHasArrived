local ADDON_NAME, ns = ...
local L = ns.L

local sounds = ns.data.sounds
local soundTypeAliases = ns.data.soundTypeAliases

function ns:SetOptionDefaults()
    PHA_options = PHA_options or {}
    for option, default in pairs(ns.data.defaults) do
        ns:SetOptionDefault(PHA_options, option, default)
    end
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

function ns:GetRace()
    local _, raceName, _ = UnitRace("player")
    return raceName:lower():gsub("%s+", "")
end

function ns:GetGender()
    local gender = UnitSex("player")
    -- because this is for getting voice files, we assume female if not male
    return gender == 2 and "male" or "female"
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

function ns:GetSoundMatch(soundType)
    -- Exact match
    for index = 1, #sounds do
        local sound = sounds[index]
        if sound.type == soundType then
            return sound.type
        end
    end
    -- Alias exact match
    if soundTypeAliases[soundType] then
        return soundTypeAliases[soundType]
    end
    -- Fuzzy match
    for index = 1, #sounds do
        local sound = sounds[index]
        if sound.type:match(soundType) or soundType:match(sound.type) then
            return sound.type
        end
    end
    -- Alias fuzzy match
    for alias, sound in pairs(soundTypeAliases) do
        if alias:match(soundType) or soundType:match(alias) then
            return sound
        end
    end
    return nil
end

function ns:GetSoundTypeIndex(soundType)
    for index = 1, #sounds do
        local sound = sounds[index]
        if sound.type == soundType then
            return index
        end
    end
end

function ns:SendSound(soundType, channel, target)
    if not ns.data.toggles.sentSound then
        ns:Toggle("sentSound", ns.data.timeout)
        local soundsIndex = ns:GetSoundTypeIndex(soundType)
        local sound = sounds[soundsIndex]
        local response = C_ChatInfo.SendAddonMessage(ns.name, sound.type, channel, target)
        if ns:OptionValue(PHA_options, "allowActions") and sound.action ~= nil then
            sound.action()
        end
        return
    end
    local timeRemaining = math.max(ns.data.toggles.sentSound - GetServerTime(), 1)
    ns:PrettyPrint(L.SendWarning:format(timeRemaining, timeRemaining ~= 1 and "s" or ""))
end

function ns:ReceivedSound(soundType, sender)
    local soundsIndex = ns:GetSoundTypeIndex(soundType)
    local sound = sounds[soundsIndex]
    ns:PlaySound(PHA_options, type(sound.id) == "function" and sound.id() or sound.id)
    if ns:OptionValue(PHA_options, "allowReactions") and sound.reaction ~= nil then
        sound.reaction()
    end
    C_GamePad.SetVibration("Low", 0.2)
    ns:PrettyPrint(L.Received:format(sender, sound.type, ns:OptionValue(PHA_options, "sound") and "" or " (" .. _G.MUTED:lower() .. ")"))
end

function ns:ProcessSound(message)
    local message = (message ~= nil and message ~= "") and message:lower() or nil
    local channel = ns:GetChannel()
    local target
    if not channel and PHA_options.PHA_debug then
        channel = "WHISPER"
        target = UnitName("player") .. "-" .. GetNormalizedRealmName("player")
    end
    if channel then
        local soundType
        if message then
            soundType = ns:GetSoundMatch(message)
        else
            soundType = ns:OptionValue(PHA_options, "defaultSound")
        end
        ns:SendSound(soundType, channel, target)
    else
        ns:PrettyPrint(L.SendFailed)
    end
end
