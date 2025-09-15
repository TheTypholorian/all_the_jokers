return{
    descriptions = {
        --Back={},
        --Blind={},
        --Edition={},
        --Enhanced={},
        Joker = {
            j_hrzi_supreme_justice = {
                name = 'Supreme Justice',
                text = {
                    'If {C:attention}consumeable slots{} are empty at the start of round',
                    'create a {C:tarot}Justice{} and {C:spectral}Deja Vu{}'
                    }
            },

            j_hrzi_skygazer = {
                name = 'Skygazer',
                text = {
                    'When blind is selected',
                    '{C:green}#1# in #2#{} chance to create a {C:dark_edition}Negative{}',
                    '{C:tarot} Moon, Sun, World {}and {C:tarot}Star{}',
                    '{C:inactive}(One of each){}',
                }
            },

            j_hrzi_gacha = {
                name = 'Gacha',
                text = {
                    'Whenever any {C:attention}Booster Pack{} is opened',
                    'gain a {C:attention}random{} amount of {C:money}money{}'
                }
            },

            j_hrzi_end_credits = {
                name = 'End Credits',
                text = {'Gain {X:mult,C:white}X#1#{} when final hand is played',
                        '{X:mult,C:white}X#2#{} Mult on final hand',
                        
                }
            },

            j_hrzi_quarry = {
                name = 'Quarry',
                text = {
                    '{C:attention}Stone Cards{} give {C:money}$#1#{} when scored'
                }
            },

            j_hrzi_event_horizon = {
                name = 'Event Horizon',
                text = {
                    'Destroy {C:planet}Planet{} Cards at end of shop',
                    'For every 2 {C:planet}Planet{} Cards destroyed',
                    'Create 1 {C:spectral}Black Hole'
                }
            },

            j_hrzi_to_apotheosis = {
                name = 'Apotheosis',
                text = {
                    'When a {C:attention}Secret Hand{} is played',
                    'gain {X:mult,C:white}X#1#{}',
                    '{C:inactive}Currently {X:mult,C:white}X#2#{}',
                }
            },

            j_hrzi_geologist = {
                name = 'Geologist',
                text = {
                    'This gains {C:mult}+3{} Mult',
                    'for each {C:attention}Stone Card{} in your deck',
                    '{C:inactive}Currently{} {C:mult}+#1#{} {C:inactive}Mult{}',
                }
            },

            j_hrzi_stonehenge = {
                name = 'Stonehenge',
                text = {
                    'When a {C:attention}Stone Card{} is scored, {X:chips,C:white}X#1#{} chips',
                    'Gains {X:chips,C:white}X0.5{} for each {C:attention}Stone Card{} scored',
                    '{C:inactive}Resets after every hand{}',
                }
            },

            j_hrzi_brainwashing = {
                name = 'Brainwashing',
                text = {
                    '{X:dark_edition,C:white}^#1#{}',
                    '{C:red,E:1}Destroys itself{} if {C:attention}3{} hands are played',
                    'without a {C:attention}Wild Card{}',
                    '{C:inactive}Self destruction in #2#',
                }
            },

            j_hrzi_monopoly_man = {
                name = 'Monopoly Man',
                text = {
                    'When a {C:attention}Gold Card{} is discarded,',
                    'lower the current blind requirement by {C:attention}15%{}'
                }
            },

            j_hrzi_sinful_deal = {
                name = 'Sinful Deal',
                text = {
                    'When a {C:attention}Booster Pack{} is skipped',
                    'Gain a {C:tarot}Devil{}'
                }
            },
            
            j_hrzi_cremedlc = {
                name = 'Creme de la Crop',
                text = {
                    'When blind is selected, lose {C:money}$#1#{}',
                    'create 1 {C:dark_edition}Negative{} {C:blue}Common{} Joker',
                }
            },

            j_hrzi_headshot = {
                name = 'Headshot',
                text = {
                    'When a Joker is sold',
                    'lower current blind requirement by {C:attention}%35{}'
                }
            },

            j_hrzi_thechosen = {
                name = 'The Chosen',
                text = {
                    '{X:mult,C:white}X#1#{} Mult',
                    'if played hand is only {C:attention}1{} card and',
                    'is an {C:attention}Ace{} of {V:1}#2#{}',
                    '{C:inactive}(Suit changes every round){}'
                }
            }
        },
               --[[]
        Other={},
        ]]
        Planet={
            c_hrzi_asteroid = {
                name = 'Asteroid',
                text = {
                    "(lvl #1#) Level up",
                    "{C:attention}Rampart{}",
                    "{C:red}+#2#{} Mult and",
                    "{C:blue}+#3#{} chips",
                },

            }
        },
        --[[]
        Spectral={},
        Stake={},
        Tag={},
        Tarot={},
        Voucher={},
        ]]
    },

    misc = {
        --achievement_descriptions={},
        --achievement_names={},
        --blind_states={},
        --challenge_names={},
        --collabs={},
        --dictionary={},
        --high_scores={},
        --labels={},

        poker_hand_descriptions={
            ['hrzi_Rampart'] = {
                '5 Stone Cards'
            }
        },

        poker_hands={
            ['hrzi_Rampart'] = "Rampart"
        },

        --quips={},
        --ranks={},
        --suits_plural={},
        --suits_singular={},
        --tutorial={},
        --v_dictionary={},
        --v_text={},
    }
}
