local _, ns = ...

ns.data = {
    defaults = {
        sound = true,
    },
    soundTypes = {
        ["chime"] = 1129273,
        ["horn"] = 4202812,
        ["bell"] = 566564,
        ["bell toll"] = 566254,
        ["sleigh bells"] = 3076692,
        ["shays bell"] = 568154,
        ["owl hoot"] = 4518673,
        ["fail"] = 903974,
        ["laugh"] = 551682,
    },
    soundTypeAliases = {
        ["ha"] = "laugh",
    },
    toggles = {
        sentSound = false,
    },
    timeout = 5,
}