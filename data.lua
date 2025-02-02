local _, ns = ...

local specialSoundTypes = {
    greeting = {
        bloodelf = {
            female = 556870,
            male = 556894,
        },
        darkirondwarf = {
            female = 547820,
            male = 547895,
        },
        draenei = {
            female = 557249,
            male = 557329,
        },
        dwarf = {
            female = 547820,
            male = 547895,
        },
        earthen = {
            female = 547820,
            male = 547895,
        },
        gnome = {
            female = 550419,
            male = 550449,
        },
        goblin = {
            female = 550661,
            male = 550809,
        },
        highelf = {
            female = 556549,
            male = 556573,
        },
        highmountaintauren = {
            female = 561526,
            male = 561539,
        },
        lightforgeddraenei = {
            female = 557249,
            male = 557329,
        },
        mechagnome = {
            female = 550419,
            male = 550449,
        },
        nightborne = {
            female = 556549,
            male = 556573,
        },
        nightelf = {
            female = 556537,
            male = 556556,
        },
        orc = {
            female = 557764,
            male = 557847,
        },
        tauren = {
            female = 561526,
            male = 561539,
        },
        troll = {
            female = 562849,
            male = 562914,
        },
        undead = {
            female = 563111,
            male = 563183,
        },
        nightelf = {
            female = 556537,
            male = 556556,
        },
        pandaren = {
            female = 632510,
            male = 641990,
        },
        voidelf = {
            female = 3085742,
            male = 3085521,
        },
        vulpera = {
            female = 3085742,
            male = 3085521,
        },
        zandalaritroll = {
            female = 562849,
            male = 562914,
        },
        female = 552115,
        male = 552190,
    },
}

ns.data = {
    defaults = {
        sound = true,
        soundChannel = "Master",
        allowActions = false,
        allowReactions = false,
        defaultSound = "greeting",
    },
    sounds = {
        [1] = {
            type = "alarm",
            id = 2066498,
        },
        [2] = {
            type = "bell",
            id = 566564,
        },
        [3] = {
            type = "chime",
            id = 1129273,
        },
        [4] = {
            type = "clock",
            id = 567458,
        },
        [5] = {
            type = "fail",
            id = 903974,
        },
        [6] = {
            type = "felreaver",
            id = 548880,
        },
        [7] = {
            type = "greeting",
            id = function()
                local specialSoundType = specialSoundTypes.greeting
                return specialSoundType[ns.race] and specialSoundType[ns.race][ns.gender] or specialSoundType[ns.gender]
            end,
            action = function() DoEmote("WAVE") end,
            reaction = function() DoEmote("WAVE") end,
        },
        [8] = {
            type = "hazard",
            id = 2924414,
        },
        [9] = {
            type = "horn",
            id = 4202812,
        },
        [10] = {
            type = "laugh",
            id = 551682,
        },
        [11] = {
            type = "hoot",
            id = 4518673,
        },
        [12] = {
            type = "sleigh",
            id = 3076692,
        },
        [13] = {
            type = "shays",
            id = 568154,
        },
        [14] = {
            type = "toll",
            id = 566254,
        },
        [15] = {
            type = "triangle",
            id = 2066499,
        },
    },
    soundTypeAliases = {
        ha = "laugh",
        hi = "greeting",
        hello = "greeting",
    },
    specialSoundTypes = specialSoundTypes,
    soundChannels = {
        [1] = "Master",
        [2] = "Music",
        [3] = "Effects",
        [4] = "Ambience",
        [5] = "Dialog",
    },
    toggles = {
        sentSound = false,
    },
    timeout = 5,
}