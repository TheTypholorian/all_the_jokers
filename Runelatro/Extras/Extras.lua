--- STEAMODDED HEADER
--- MOD_NAME: RunelatroUI
--- MOD_ID: RunelatroUI
--- MOD_AUTHOR: [Isotope]
--- MOD_DESCRIPTION: Runescapify your game.
--- VERSION: 1.0.0

----------------------------------------------
------------ MOD CODE -------------------------

function SMODS.INIT.Colors()

    G.C.SUITS = {
        Hearts = HEX('dc0000'),
        Diamonds = HEX('d40980'),
        Spades = HEX("6fec19"),
        Clubs = HEX("0552ec"),
    }

    G.C.SO_1 = {
        Hearts = HEX('dc0000'),
        Diamonds = HEX('d40980'),
        Spades = HEX("6fec19"),
        Clubs = HEX("0552ec"),
    }

    G.C.SO_2 = {
        Hearts = HEX('dc0000'),
        Diamonds = HEX('d40980'),
        Spades = HEX("6fec19"),
        Clubs = HEX("0552ec"),
    }

    G.C.BACKGROUND = {
        L = {1,1,0,0},
        D = HEX("494034"),
        C = HEX("494034"),
        contrast = 1
    }

    G.C.BLIND = {
        Small = HEX("ffdeaa"),
        Big = HEX("ffdeaa"),
        Boss = HEX("a13a28"),
        won = HEX("4f6367")
    }

    local osrsreskin_mod = SMODS.findModByID("RunelatroUI")
    local osrs_balatro = SMODS.Sprite:new("balatro", osrsreskin_mod.path, "osrsBalatro.png", 333, 216, "asset_atli")
    
    osrs_balatro:register()

end

----------------------------------------------
------------ END MOD CODE ----------------------