local ADDON_NAME, ns = ...

local GetAddOnMetadata = C_AddOns.GetAddOnMetadata

ns.name = "PHA"
ns.title = GetAddOnMetadata(ADDON_NAME, "Title")
ns.notes = GetAddOnMetadata(ADDON_NAME, "Notes")
ns.version = GetAddOnMetadata(ADDON_NAME, "Version")
ns.icon = GetAddOnMetadata(ADDON_NAME, "IconAtlas")
ns.color = "f2c8ea"
ns.command = "pha"
ns.prefix = "PHA_"
