return {
    descriptions={
        Back={
            b_checkered={
                name="Checkered Deck",
                text={
                    "Start run with",
                    "{C:attention}26{C:spades} Peaches{} and",
                    "{C:attention}26{C:hearts} Duckies{} in deck",
                },
            },
        },
        Blind={
            bl_club={
                name="The Piplow",
                text={
                    "All Piplow cards",
                    "are debuffed",
                },
            },
            bl_goad={
                name="The Goad",
                text={
                    "All Peach cards",
                    "are debuffed",
                },
            },
            bl_head={
                name="The Head",
                text={
                    "All Ducky cards",
                    "are debuffed",
                },
            },
            bl_window={
                name="The Window",
                text={
                    "All Pumpkin cards",
                    "are debuffed",
                },
            },
        },

        Joker={
            j_arrowhead={
                name="Arrowhead",
                text={
                    "Played cards with",
                    "{C:spades}Peach{} suit give",
                    "{C:chips}+#1#{} Chips when scored",
                },
                unlock={
                    "Have at least {E:1,C:attention}#1#",
                    "cards with {E:1,C:attention}#2#",
                    "suit in your deck",
                },
            },

            j_blackboard={
                name="Blackboard",
                text={
                    "{X:red,C:white} X#1# {} Mult if all",
                    "cards held in hand",
                    "are {C:spades}#2#{} or {C:clubs}#3#{}",
                },
            },
            j_bloodstone={
                name="Bloodstone",
                text={
                    "{C:green}#1# in #2#{} chance for",
                    "played cards with",
                    "{C:hearts}Ducky{} suit to give",
                    "{X:mult,C:white} X#3# {} Mult when scored",
                },
                unlock={
                    "Have at least {E:1,C:attention}#1#",
                    "cards with {E:1,C:attention}#2#",
                    "suit in your deck",
                },
            },
            j_flower_pot={
                name="Flower Pot",
                text={
                    "{X:mult,C:white} X#1# {} Mult if poker",
                    "hand contains a",
                    "{C:diamonds}Pumpkin{} card, {C:clubs}Piplow{} card,",
                    "{C:hearts}Ducky{} card, and {C:spades}Peach{} card",
                },
                unlock={
                    "Reach Ante",
                    "level {E:1,C:attention}#1#",
                },
            },
            j_gluttenous_joker={
                name="Gluttonous Joker",
                text={
                    "Played cards with",
                    "{C:clubs}#2#{} suit give",
                    "{C:mult}+#1#{} Mult when scored",
                },
            },
            j_greedy_joker={
                name="Greedy Joker",
                text={
                    "Played cards with",
                    "{C:diamonds}#2#{} suit give",
                    "{C:mult}+#1#{} Mult when scored",
                },
            },
            j_lusty_joker={
                name="Lusty Joker",
                text={
                    "Played cards with",
                    "{C:hearts}#2#{} suit give",
                    "{C:mult}+#1#{} Mult when scored",
                },
            },
            j_onyx_agate={
                name="Onyx Agate",
                text={
                    "Played cards with",
                    "{C:clubs}Piplow{} suit give",
                    "{C:mult}+#1#{} Mult when scored",
                },
                unlock={
                    "Have at least {E:1,C:attention}#1#",
                    "cards with {E:1,C:attention}#2#",
                    "suit in your deck",
                },
            },
            j_rough_gem={
                name="Rough Gem",
                text={
                    "Played cards with",
                    "{C:diamonds}Pumpkin{} suit earn",
                    "{C:money}$#1#{} when scored",
                },
                unlock={
                    "Have at least {E:1,C:attention}#1#",
                    "cards with {E:1,C:attention}#2#",
                    "suit in your deck",
                },
            },
            j_seeing_double={
                name="Seeing Double",
                text={
                    "{X:mult,C:white} X#1# {} Mult if played",
                    "hand has a scoring",
                    "{C:clubs}Piplow{} card and a scoring",
                    "card of any other {C:attention}suit",
                },
                unlock={
                    "Play a hand",
                    "that contains",
                    "{E:1,C:attention}#1#",
                },
            },
            j_shoot_the_moon={
                name="Shoot the Moon",
                text={
                    "Each {C:attention}Queen{}",
                    "held in hand",
                    "gives {C:mult}+#1#{} Mult",
                },
                unlock={
                    "Play every {E:1,C:attention}Ducky",
                    "in your deck in",
                    "a single round",
                },
            },
            j_smeared={
                name="Smeared Joker",
                text={
                    "{C:hearts}Duckies{} and {C:diamonds}Pumpkins",
                    "count as the same suit,",
                    "{C:spades}Peaches{} and {C:clubs}Piplows",
                    "count as the same suit",
                },
                unlock={
                    "Have at least {C:attention}#1#",
                    "{E:1,C:attention}#2#{} in",
                    "your deck",
                },
            },
            j_wrathful_joker={
                name="Wrathful Joker",
                text={
                    "Played cards with",
                    "{C:spades}#2#{} suit give",
                    "{C:mult}+#1#{} Mult when scored",
                },
            },
        },
    },

    misc={
        suits_plural={
            Clubs="Piplows",
            Diamonds="Pumpkins",
            Hearts="Duckies",
            Spades="Peaches",
        },
        suits_singular={
            Clubs="Piplow",
            Diamonds="Pumpkin",
            Hearts="Ducky",
            Spades="Peach",
        },
    },
}
