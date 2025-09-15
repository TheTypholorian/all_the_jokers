--- STEAMODDED HEADER
--- MOD_NAME: GlowyPumpkin
--- MOD_ID: glowypumpkin
--- MOD_AUTHOR: [ButterSpaceship, Orangesuit1]
--- MOD_DESCRIPTION: Custom GlowyPumpkin Deck by ButterSpaceship as Modmaker, Orangesuit1 as Main Artist and AngyPeachy as miscellaneous Helper (and THE Mr. John SMODS for their unending patience in helping port this to be modloader compatible)

----------------------------------------------
------------MOD CODE -------------------------
---

SMODS.Atlas {
    key = 'cards_1',
    path = '8BitDeck.png',
    prefix_config = false,
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'cards_2',
    path = '8BitDeck.png',
    prefix_config = false,
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'Planet',
    path = 'Tarots.png',
    prefix_config = false,
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'Spectral',
    path = 'Tarots.png',
    prefix_config = false,
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'Tarot',
    path = 'Tarots.png',
    prefix_config = false,
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'centers',
    path = 'Enhancers.png',
    prefix_config = false,
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'Joker',
    path = 'Jokers.png',
    prefix_config = false,
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'ui_1',
    path = 'ui_assets.png',
    prefix_config = false,
    px = 18,
    py = 18
}
 
G.C.SUITS = {
    Hearts = HEX("ffdc2e"),
    Diamonds = HEX('FE5F55'),
    Spades = HEX("ff8095"),
    Clubs = HEX("31663e"),
}

G.C.SO_1, G.C.SO_2 = G.C.SUITS, G.C.SUITS

----------------------------------------------
------------MOD CODE END----------------------
