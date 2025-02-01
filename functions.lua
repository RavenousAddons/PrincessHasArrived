local ADDON_NAME, ns = ...
local L = ns.L

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
    -- return nil
    return "GUILD"
end

function ns:Trim(value)
   local a = value:match("^%s*()")
   local b = value:match("()%s*$", a)
   return value:sub(a, b - 1)
end

function ns:SendSound(soundType, channel)
    if not ns.data.toggles.sentSound then
        ns:Toggle("sentSound", ns.data.timeout)
        C_ChatInfo.SendAddonMessage(ns.name, soundType, channel)
        return
    end
    ns:PrettyPrint(L.SendWarning:format(math.max(ns.data.toggles.sentSound - GetServerTime(), 1)))
end

function ns:ReceivedSound(soundType, sender)
    ns:PlaySound(PHA_options, ns.data.soundTypes[soundType])
    C_GamePad.SetVibration("Low", 0.2)
    ns:PrettyPrint(L.Received:format(sender, soundType, ns:OptionValue(PHA_options, "sound") and "" or " (" .. _G.MUTED:lower() .. ")"))
end