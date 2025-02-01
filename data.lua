local _, ns = ...

ns.data = {
    defaults = {
        sound = true,
        defaultSound = "chime",
    },
    soundTypes = {
        [1] = {
            type = "bell",
            id = 566564,
        },
        [2] = {
            type = "bell toll",
            id = 566254,
        },
        [3] = {
            type = "chime",
            id = 1129273,
        },
        [4] = {
            type = "fail",
            id = 903974,
        },
        [5] = {
            type = "horn",
            id = 4202812,
        },
        [6] = {
            type = "laugh",
            id = 551682,
        },
        [7] = {
            type = "owl hoot",
            id = 4518673,
        },
        [8] = {
            type = "sleigh bells",
            id = 3076692,
        },
        [9] = {
            type = "shays bell",
            id = 568154,
        },
    },
    soundTypeAliases = {
        ["ha"] = "laugh",
    },
    toggles = {
        sentSound = false,
    },
    timeout = 5,
}