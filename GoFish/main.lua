--- STEAMODDED HEADER
--- MOD_NAME: Go_Fish
--- MOD_ID: Go_Fish
--- MOD_AUTHOR: [Omnilax]
--- MOD_DESCRIPTION: Adds Go Fish booster packs with 80 optional Fish Jokers.
--- PREFIX: AC
----------------------------------------------
------------MOD CODE -------------------------





-- Config Stuff

local config = SMODS.current_mod.config

SMODS.current_mod.config_tab = function()
    return {
        n = G.UIT.ROOT,
        config = { align = "cm", padding = 0.1 },
        nodes = {
            {
                n = G.UIT.C,
                config = {},
                nodes = {
                    create_toggle({
                        label = "Modded Jokers",
                        ref_table = config,
                        ref_value = "moddedjokers",
                        callback = function(_set_toggle)
                            config.moddedjokers = _set_toggle
                            -- if _set_toggle then
                            --     update_modded_jokers() -- Initialize modded jokers
                            -- else
                            --     -- Remove all modded jokers from the pool
                            --     for key, joker in pairs(SMODS.Joker or {}) do
                            --         if joker["rarity"] == "AC_Fish" then
                            --             SMODS.Joker[key] = nil -- Remove the joker from the pool
                            --         end
                            --     end
                            -- end
                        end,
                    })
                }
            }
        }
    }
end

-- end

-- Load sprite atlas
SMODS.Atlas {
    key = 'Jokers',
    path = 'Jokers.png',
    px = 71,
    py = 95
}

SMODS.Atlas {
    key = 'Extra',
    path = 'Extra.png',
    px = 71,
    py = 95
}


-- Functions

function add_dollar()
    ease_dollars(1)                                        -- Animates the dollar gain
    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + 1 -- Ensures the money is actually added
end

-- Rarity

SMODS.Rarity {
    key = "AC_Fish", -- ✅ matches your Joker rarity field
    loc_txt = { name = "Fish" },

    badge_colour = SMODS.Gradient {
        key = "fish_gradient",
        colours = { HEX("2F5B25"), HEX("256EBC") },
        cycle = 12,
        interpolation = "trig"
    },

    default_weight = 0.00000001, -- ✅ required so it can be polled (but disabled by default via rarity_mods)

    pools = { ["Joker"] = true }
}


-- JOKERS START HERE
-- if config.moddedjokers == true then
function setup_jokers()
    SMODS.Joker {
        key = 'Smelt',
        loc_txt = {
            name = 'Pond Smelt',
            text = {
                '{C:money}$2{} at the end of round'
            }
        },
        atlas = 'Jokers',
        rarity = 'AC_Fish',
        cost = 3,
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        pos = { x = 0, y = 0 },
        config = { extra = { dollar_bonus = 2 } },

        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.dollar_bonus } }
        end,

        -- Correct way to add money at the end of the round
        calc_dollar_bonus = function(self, card)
            return card.ability.extra.dollar_bonus -- Adds $1 per hand played at round end
        end,

        in_pool = function(self)
            return true
        end,


        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }

    -- Black Bass

    SMODS.Joker {
        key = "BlackBass",
        atlas = "Jokers",
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        rarity = "AC_Fish",
        cost = 7,
        pos = { x = 9, y = 0 },

        loc_txt = {
            name = "Black Bass",
            text = {
                'Gives {C:mult}+10{} Mult each hand',
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = { 10 }
            }
        end,

        calculate = function(self, card, context)
            if context.joker_main and not context.blueprint then
                return {
                    mult = 10
                }
            end
        end,

        in_pool = function(self)
            return true
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }





    -- Sea Bass

    SMODS.Joker {
        key = 'SeaBass',
        loc_txt = {
            name = 'Sea Bass',
            text = {
                '{C:mult}+3{} Mult per scored card'
            }
        },
        atlas = 'Jokers',
        rarity = 'AC_Fish',
        cost = 4,
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,
        pos = { x = 1, y = 0 },
        config = {
            extra = {
                mult_bonus = 4,
                is_fish = true
            }
        },
        loc_vars = function(self, info_queue, center)
            return { vars = { center.ability.extra.mult_bonus } }
        end,
        calculate = function(self, card, context)
            if context.repetition then return end -- Early exit during repetition checks
            if context.cardarea == G.play and context.other_card and context.other_card ~= card then
                return {
                    mult_mod = card.ability.extra.mult_bonus,
                    message = '+' .. card.ability.extra.mult_bonus .. ' Mult',
                    colour = G.C.MULT,
                    repetitions = 0
                }
            end
        end,
        in_pool = function(self)
            return true
        end,


        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }

    -- Horse Mackerel - Adds flat +30 chips when it triggers
    SMODS.Joker {
        key = 'HorseMackerel',
        loc_txt = {
            name = 'Horse Mackerel',
            text = {
                '{C:chips}+30{} Chips'
            }
        },
        atlas = 'Jokers',
        rarity = 'AC_Fish',
        cost = 3,
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        pos = { x = 2, y = 0 },
        config = {
            extra = {
                chip_bonus = 30,
                is_fish = true
            }
        },
        loc_vars = function(self, info_queue, center)
            return {
                vars = { center.ability.extra.chip_bonus }
            }
        end,
        calculate = function(self, card, context)
            if context.joker_main then
                return {
                    chip_mod = card.ability.extra.chip_bonus,
                    message = '+' .. card.ability.extra.chip_bonus .. ' Chips',
                    colour = G.C.CHIPS,
                    repetitions = 0
                }
            end
        end,
        in_pool = function(self)
            return true
        end,



        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }

    -- Pufferfish - Always gives +1 X Mult (testing)
    SMODS.Joker {
        key = 'Pufferfish',
        loc_txt = {
            name = 'Pufferfish',
            text = {
                '{X:mult,C:white}X1.2{} Mult for every {C:clubs}Fish{} Joker'
            }
        },
        atlas = 'Jokers',
        rarity = 'AC_Fish',
        cost = 4,
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        mod_id = 'Go_Fish',
        pos = { x = 3, y = 0 },
        config = { extra = { xmult = 1.2 } },

        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.xmult } }
        end,

        calculate = function(self, card, context)
            if context.other_joker and (context.other_joker.config.center.rarity == "AC_Fish") then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }

    -- Killi

    SMODS.Joker {
        key = 'Killi',
        loc_txt = {
            name = 'Killifish',
            text = {
                'Playing {C:attention}High Card{} earns {C:money}$2{}'
            }
        },
        atlas = 'Jokers',
        rarity = 'AC_Fish',
        cost = 5,
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,
        pos = { x = 2, y = 1 },
        config = { extra = { dollars = 2, poker_hand = 'High Card' } },

        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.dollars, localize(card.ability.extra.poker_hand, 'poker_hands') } }
        end,

        calculate = function(self, card, context)
            if context.before and context.main_eval and context.scoring_name == card.ability.extra.poker_hand then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                return {
                    dollars = card.ability.extra.dollars,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }
            end
        end,

        set_ability = function(self, card, initial, delay_sprites)
            -- Explicitly enforce that the hand is always 'High Card'
            card.ability.extra.poker_hand = 'High Card'
        end,


        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }

    -- Bitterling Joker
    SMODS.Joker {
        key = 'Bitterling',
        loc_txt = {
            name = 'Bitterling',
            text = {
                '{C:chips}+50{} Chips if playing a single card'
            }
        },
        atlas = 'Jokers',
        rarity = 'AC_Fish',
        cost = 3,
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        pos = { x = 3, y = 1 },
        config = { extra = { chip_bonus = 50, size = 1 } },

        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.chip_bonus, card.ability.extra.size } }
        end,

        calculate = function(self, card, context)
            -- Ensure the player played **only one card**
            if context.joker_main and #context.full_hand == card.ability.extra.size then
                return {
                    chip_mod = card.ability.extra.chip_bonus,
                    message = '+50',
                    colour = G.C.CHIPS
                }
            end
        end,

        in_pool = function(self)
            return true
        end,



        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }

    --Pale Chub

    SMODS.Joker {
        key = 'PaleChub',
        loc_txt = {
            name = 'Pale Chub',
            text = {
                '{C:chips}+80{} Chips when playing a Pair'
            }
        },
        atlas = 'Jokers',
        rarity = 'AC_Fish',
        cost = 3,
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        pos = { x = 4, y = 1 },
        config = { extra = { chip_bonus = 80 } },

        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.chip_bonus } }
        end,

        calculate = function(self, card, context)
            -- Ensure the effect applies **before scoring is finalized**
            if context.joker_main and context.scoring_name == "Pair" then
                return {
                    chip_mod = card.ability.extra.chip_bonus,
                    message = '+80',
                    colour = G.C.CHIPS
                }
            end
        end,

        in_pool = function(self)
            return true
        end
        ,


        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }



    -- Goldfish



    SMODS.Joker {
        key = 'Goldfish',
        atlas = 'Jokers',
        rarity = 'AC_Fish',
        cost = 3,
        pos = { x = 6, y = 0 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,

        config = { extra = { dollar_per_fish = 1 } },

        loc_txt = {
            name = 'Goldfish',
            text = {
                '{C:money}$1{} at the end of round',
                'for every {C:attention}Fish{} Joker'
            }
        },

        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.dollar_per_fish or 1 } }
        end,

        calc_dollar_bonus = function(self, card)
            local fish_count = 0
            for _, joker in ipairs(G.jokers.cards or {}) do
                local rarity = joker.config.center and joker.config.center.rarity
                if rarity == "AC_Fish" then
                    fish_count = fish_count + 1
                end
            end
            return (card.ability.extra.dollar_per_fish or 1) * fish_count
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self) return true end
    }





    -- Popeyed Goldfish


    SMODS.Joker {
        key = "PopEyedGoldfish",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 4,
        pos = { x = 0, y = 1 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { mult = 1, chips = 5, suit = "Spades" } },

        loc_txt = {
            name = "Pop-Eyed Goldfish",
            text = {
                "{C:attention}Spades{} score for {C:mult}+1{} Mult",
                "and {C:chips}+5{} Chips each"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.mult or 1,
                    card.ability.extra.chips or 5,
                    localize(card.ability.extra.suit or "Spades", "suits_plural"),
                    colours = { G.C.SUITS[card.ability.extra.suit or "Spades"] }
                }
            }
        end,

        calculate = function(self, card, context)
            if context.individual and context.cardarea == G.play and context.other_card:is_suit(card.ability.extra.suit or "Spades") then
                return {
                    mult = card.ability.extra.mult or 1,
                    chips = card.ability.extra.chips or 5
                }
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self)
            return true
        end
    }



    -- Ranchu Goldfish




    SMODS.Joker {
        key = "RanchuGoldfish",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 4,
        pos = { x = 1, y = 1 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { dollars = 1 } },

        loc_txt = {
            name = "Ranchu Goldfish",
            text = {
                "Gives {C:money}$1{} when {C:attention}Face{} cards",
                "are scored"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = { card.ability.extra.dollars or 1 }
            }
        end,

        calculate = function(self, card, context)
            if context.individual and context.cardarea == G.play and context.other_card:is_face() then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars

                return {
                    dollars = card.ability.extra.dollars,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self)
            return true
        end
    }





    -- Carp




    SMODS.Joker {
        key = "Carp",
        atlas = "Jokers",
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        rarity = 'AC_Fish',
        cost = 5,
        pos = { x = 8, y = 3 },

        loc_txt = {
            name = "Carp",
            text = {
                '{C:chips}+15{} Chips and {C:mult}+30{} Mult'
            }
        },

        calculate = function(self, card, context)
            if context.joker_main then
                return {
                    chips = 15,
                    mult = 30
                }
            end
        end,


        in_pool = function(self)
            return true
        end,


        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,
    }













    --Crucian Carp




    SMODS.Joker {
        key = "CrucianCarp",
        atlas = "Jokers",
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        rarity = 'AC_Fish',
        cost = 5,
        pos = { x = 9, y = 3 },

        loc_txt = {
            name = "Crucian Carp",
            text = {
                '{C:chips}+30{} Chips and {C:mult}+15{} Mult'
            }
        },

        calculate = function(self, card, context)
            if context.joker_main then
                return {
                    chips = 30,
                    mult = 15
                }
            end
        end,

        in_pool = function(self)
            return true
        end,


        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,
    }

    -- Dace








    SMODS.Joker {
        key = "Dace",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 0, y = 6 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,

        config = { extra = { xmult = 2 } },

        loc_txt = {
            name = "Dace",
            text = {
                "Grants {X:mult,C:white}X2{} mult",
                "only on the {C:attention}first{} hand played each round"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = { card.ability.extra.xmult or 2 }
            }
        end,

        calculate = function(self, card, context)
            -- Jiggle when first hand is drawn
            if context.first_hand_drawn and not context.blueprint then
                local eval = function()
                    return G.GAME.current_round.hands_played == 0 and not G.RESET_JIGGLES
                end
                juice_card_until(card, eval, true)
            end

            -- Apply scoring bonus after first hand is played
            if context.joker_main and G.GAME.current_round.hands_played == 0 then
                return {
                    xmult = card.ability.extra.xmult or 2,
                    colour = G.C.XMULT
                }
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self) return true end
    }










    -- Yellow Perch




    SMODS.Joker {
        key = "YellowPerch",
        atlas = "Jokers",
        unlocked = true,
        discovered = true,
        blueprint_compat = false,
        eternal_compat = false,
        perishable_compat = false,
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 5, y = 2 },

        config = {
            extra = {
                dollars = 1
            }
        },

        loc_txt = {
            name = "Yellow Perch",
            text = {
                '{C:money}$1{} back for every shop {C:attention}Reroll{}'
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability and card.ability.extra and card.ability.extra.dollars or 1
                }
            }
        end,

        calculate = function(self, card, context)
            if context.reroll_shop and not context.blueprint then
                local dollars = (card.ability and card.ability.extra and card.ability.extra.dollars) or 1
                add_dollar()
                return {
                    dollars = dollars
                }
            end
        end,



        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self)
            return true
        end
    }

    -- Loach

    SMODS.Joker {
        key = "Loach",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 5, y = 0 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { mult = 10 } },

        loc_txt = {
            name = "Loach",
            text = {
                "Gives {C:mult}+10{} Mult",
                "for each played card that wasn't scored"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = { card.ability.extra.mult or 10 }
            }
        end,

        calculate = function(self, card, context)
            if context.individual and context.cardarea == "unscored" then
                return {
                    mult = card.ability.extra.mult or 10
                }
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self) return true end
    }



    -- Freshwater Goby


    SMODS.Joker {
        key = "FreshwaterGoby",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 5, y = 1 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { chips = 25 } },

        loc_txt = {
            name = "Freshwater Goby",
            text = {
                "Gives {C:chips}+25{} Chips",
                "for each played card that wasn't scored"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = { card.ability.extra.chips or 25 }
            }
        end,

        calculate = function(self, card, context)
            if context.individual and context.cardarea == "unscored" then
                return {
                    chips = card.ability.extra.chips or 25
                }
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self)
            return true
        end
    }




    -- Nibblefish




    SMODS.Joker {
        key = "Nibblefish",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 8, y = 6 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { xmult = 1.5 } },

        loc_txt = {
            name = "Nibblefish",
            text = {
                "Cards played but not scored",
                "give {X:mult,C:white}X1.5{} Mult"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = { card.ability.extra.xmult or 1.5 }
            }
        end,

        calculate = function(self, card, context)
            if context.individual and context.cardarea == "unscored" then
                return {
                    xmult = card.ability.extra.xmult or 1.5
                }
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self)
            return true
        end
    }






    -- Tadpole



    SMODS.Joker {
        key = "tadpole",
        atlas = 'Jokers',
        rarity = 'AC_Fish',
        cost = 8,
        unlocked = true,
        blueprint_compat = true,
        eternal_compat = false,
        pos = { x = 3, y = 2 },

        config = {
            extra = {
                invis_rounds = 0,
                total_rounds = 2,
                mult_bonus = 1.5
            }
        },

        loc_txt = {
            name = 'Tadpole',
            text = {
                '{X:mult,C:white}X1.5{} Mult every round',
                'Sell after {C:attention}2{} rounds to become a {C:green}Frog{}'
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.mult_bonus,
                    card.ability.extra.total_rounds,
                    card.ability.extra.invis_rounds
                }
            }
        end,

        calculate = function(self, card, context)
            if context.joker_main then
                return {
                    mult = card.ability.extra.mult_bonus
                }
            end

            if context.selling_self and
                card.ability.extra.invis_rounds >= card.ability.extra.total_rounds and
                not context.blueprint then
                SMODS.add_card { key = "j_AC_Frog" }
            end

            if context.end_of_round and not context.game_over and context.main_eval and not context.blueprint then
                card.ability.extra.invis_rounds = card.ability.extra.invis_rounds + 1
                if card.ability.extra.invis_rounds == card.ability.extra.total_rounds then
                    -- Trigger animation / bobbing like Invisible Joker
                    local eval = function(card) return not card.REMOVED end
                    juice_card_until(card, eval, true)
                end

                return {
                    message = (card.ability.extra.invis_rounds < card.ability.extra.total_rounds)
                        and (card.ability.extra.invis_rounds .. '/' .. card.ability.extra.total_rounds)
                        or localize('k_active_ex'),
                    colour = G.C.FILTER
                }
            end
        end,

        check_for_unlock = function(self, args)
            return args.type == 'win_custom' and G.GAME.max_jokers <= 4
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end

    }



    -- Frog

    SMODS.Joker {
        key = "Frog",
        atlas = "Jokers",
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        rarity = 'AC_Fish',
        cost = 6,
        pos = { x = 4, y = 2 },

        config = {
            extra = {
                xmult = 1.5,
                xmult_gain = 0.2
            }
        },

        loc_txt = {
            name = "Frog",
            text = {
                "This Joker gains {X:mult,C:white} X#1# {} Mult",
                "when a {C:spades}Spade{} card",
                "is destroyed",
                "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)",
            }
        },

        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.xmult_gain, card.ability.extra.xmult } }
        end,

        calculate = function(self, card, context)
            if context.remove_playing_cards and not context.blueprint then
                local spades = 0
                for _, removed_card in ipairs(context.removed) do
                    if removed_card:is_suit("Spades") then
                        spades = spades + 1
                    end
                end
                if spades > 0 then
                    card.ability.extra.xmult = card.ability.extra.xmult + spades * card.ability.extra.xmult_gain
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.MULT,
                        message_card = card
                    }
                end
            end

            if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self)
            return true
        end
    }








    -- Butterfly Fish


    SMODS.Joker {
        key = "ButterflyFish",
        atlas = "Jokers",
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 0, y = 2 },

        config = {},

        loc_txt = {
            name = "Butterfly Fish",
            text = {
                "{C:money}$1{} per {C:attention}3{}{C:diamonds} Diamonds{} in full deck",
                "at the end of round",
                "{C:inactive}Currently {C:money}$#1#{}"
            }
        },

        loc_vars = function(self, info_queue, card)
            local diamonds = 0
            for _, v in ipairs(G.playing_cards or {}) do
                if v:is_suit("Diamonds") then
                    diamonds = diamonds + 1
                end
            end
            local payout = math.floor(diamonds / 3) -- ✅ accurate rounding
            return { vars = { tostring(payout) } }
        end,

        calc_dollar_bonus = function(self, card)
            local diamonds = 0
            for _, v in ipairs(G.playing_cards or {}) do
                if v:is_suit("Diamonds") then
                    diamonds = diamonds + 1
                end
            end
            return math.floor(diamonds / 3) -- ✅ only full sets yield dollars
        end,

        in_pool = function(self, args)
            -- ✅ Only allow in shop if Fish Only deck is active
            if args and args.source == "shop" then
                return G.GAME
                    and G.GAME.starting_params
                    and G.GAME.starting_params.back == "b_fish_only"
            end
            return true -- ✅ allow in other contexts like Blueprint, effects, rewards
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }

    -- Blue Gill


    SMODS.Joker {
        key = "BluegillFish",
        atlas = "Jokers",
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        rarity = "AC_Fish",
        cost = 6,
        pos = { x = 1, y = 2 },

        config = {
            extra = {
                chips = 0,
                chip_mod = 3
            }
        },

        loc_txt = {
            name = "Bluegill",
            text = {
                'This Joker gains {C:chips}+3{} Chips when {C:clubs}Club{} cards are scored',
                '{C:inactive}(Currently {C:chips}+#1#{} Chips)'
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    string.format("%d", card.ability and card.ability.extra and card.ability.extra.chips or 0)
                }
            }
        end,

        calculate = function(self, card, context)
            if context.individual and context.cardarea == G.play and context.other_card and not context.blueprint then
                if context.other_card:is_suit("Clubs") then
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                    return {
                        message = localize('k_upgrade_ex'),
                        colour = G.C.CHIPS,
                        message_card = card
                    }
                end
            end

            if context.joker_main then
                return {
                    chips = card.ability.extra.chips
                }
            end
        end,

        in_pool = function(self)
            return true
        end,


        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }


    -- Red Snapper


    SMODS.Joker {
        key = "RedSnapper",
        loc_txt = {
            name = 'Red Snapper',
            text = {
                '{C:mult}+6{} Mult for every {C:hearts}Heart{} card scored'
            }
        },
        atlas = 'Jokers',
        rarity = 'AC_Fish',
        cost = 4,
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,
        mod_id = 'Go_Fish',
        pos = { x = 4, y = 0 },
        config = { extra = { s_mult = 6, suit = 'Hearts' } },

        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.s_mult, localize(card.ability.extra.suit, 'suits_singular') } }
        end, -- **Missing comma fixed here**

        calculate = function(self, card, context)
            if context.individual and context.cardarea == G.play and
                context.other_card:is_suit(card.ability.extra.suit) then
                return {
                    mult = card.ability.extra.s_mult
                }
            end
        end,

        in_pool = function(self)
            return true
        end,


        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }




    -- Catfish

    SMODS.Joker {
        key = "Catfish",
        atlas = "Jokers",
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        rarity = "AC_Fish",
        cost = 8,
        pos = { x = 2, y = 2 },

        config = {
            extra = {
                xmult = 1.2
            }
        },

        loc_txt = {
            name = "Catfish",
            text = {
                'Each {C:spades}Spade{} held in hand gives {X:mult,C:white}X1.2{} Mult',
                '{C:inactive}Applies after playing a hand'
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.xmult
                }
            }
        end,

        calculate = function(self, card, context)
            if context.individual and context.cardarea == G.hand and not context.end_of_round and not context.blueprint then
                if context.other_card:is_suit("Spades") then
                    if context.other_card.debuff then
                        return {
                            message = localize('k_debuffed'),
                            colour = G.C.RED
                        }
                    else
                        return {
                            x_mult = card.ability.extra.xmult
                        }
                    end
                end
            end
        end,

        in_pool = function(self)
            return true
        end,


        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }

    -- Crawfish


    SMODS.Joker {
        key = "Crawfish",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 5, y = 3 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,

        config = { extra = { discard_gain = 1 } },

        loc_txt = {
            name = "Crawfish",
            text = {
                "{C:red}+1{} discard for every",
                "{C:attention}Pair{} you play this round"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra and card.ability.extra.discard_gain or 1
                }
            }
        end,

        calculate = function(self, card, context)
            -- Grant discard on exact Pair
            if context.joker_main
                and context.scoring_name == "Pair"
                and context.poker_hands and next(context.poker_hands["Pair"]) then
                local gain = card.ability.extra and card.ability.extra.discard_gain or 1

                G.GAME.round_resets.discards = G.GAME.round_resets.discards + gain
                ease_discard(gain)

                card.ability._discards_gained = (card.ability._discards_gained or 0) + gain

                return {
                    message = "Pinch!",
                    colour = G.C.RED
                }
            end

            -- Reset discard when entering shop (round ended)
            if context.starting_shop and context.cardarea == G.jokers then
                local revoke = card.ability._discards_gained or 0
                if revoke > 0 then
                    G.GAME.round_resets.discards = math.max(0, G.GAME.round_resets.discards - revoke)
                    ease_discard(-revoke)
                    card.ability._discards_gained = 0
                end
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end

            -- Cleanup discard gain if selling before shop
            local revoke = card.ability._discards_gained or 0
            if revoke > 0 then
                G.GAME.round_resets.discards = math.max(0, G.GAME.round_resets.discards - revoke)
                ease_discard(-revoke)
                card.ability._discards_gained = 0
            end
        end,

        in_pool = function(self)
            return true
        end
    }


    -- Mud Crab

    SMODS.Joker {
        key = "MudCrab",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 7, y = 3 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,

        config = { extra = { odds = 4 } },

        loc_txt = {
            name = "Mud Crab",
            text = {
                "{C:green}#1# in #2#{}, chance to create a random {C:attention}tag{}",
                "when you play a {C:attention}Two Pair{}"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    tostring(G.GAME and G.GAME.probabilities.normal or 1),
                    tostring(card.ability.extra.odds or 4)
                }
            }
        end,

        calculate = function(self, card, context)
            if context.joker_main
                and context.scoring_name == "Two Pair"
                and context.poker_hands and next(context.poker_hands["Two Pair"])
                and pseudorandom("mudcrab_trigger") < ((G.GAME.probabilities.normal or 1) / (card.ability.extra.odds or 4)) then
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.4,
                    func = function()
                        local tag_key = get_next_tag_key("MudCrab")
                        local i = 0
                        while tag_key == "tag_boss" and i < 6 do
                            tag_key = get_next_tag_key("MudCrab")
                            i = i + 1
                        end
                        tag_key = tag_key ~= "tag_boss" and tag_key or "tag_double"

                        local tag = Tag(tag_key)
                        if tag.name == "Orbital Tag" then
                            local _poker_hands = {}
                            for k, v in pairs(G.GAME.hands or {}) do
                                if v.visible then
                                    _poker_hands[#_poker_hands + 1] = k
                                end
                            end
                            tag.ability.orbital_hand = pseudorandom_element(_poker_hands, "mudcrab_orbital")
                        end

                        add_tag(tag)
                        return true
                    end
                }))

                return {
                    message = "Pinch!",
                    colour = G.C.RED
                }
            end
        end,
        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,
        in_pool = function(self)
            return true
        end
    }


    -- Betta

    SMODS.Joker {
        key = "Betta",
        atlas = "Jokers",
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        rarity = 'AC_Fish',
        cost = 6,
        pos = { x = 7, y = 0 },

        loc_txt = {
            name = "Betta",
            text = {
                'Creates a {C:spectral}Spectral{} card if you win with your last hand',
                '{C:inactive}Only triggers once per round'
            }
        },

        calculate = function(self, card, context)
            if context.joker_main and G.GAME.current_round.hands_left == 0 and not context.blueprint then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card {
                                set = 'Spectral',
                                key_append = 'vremade_betta'
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                    return {
                        message = localize('k_plus_spectral'),
                        colour = G.C.SECONDARY_SET.Spectral
                    }
                end
            end
        end,

        in_pool = function(self)
            return true
        end,


        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }




    -- Rainbowfish

    SMODS.Joker {
        key = "Rainbowfish",
        atlas = "Jokers",
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        rarity = 'AC_Fish',
        cost = 6,
        pos = { x = 7, y = 2 },

        loc_txt = {
            name = "Rainbowfish",
            text = {
                'Creates a {C:tarot}Tarot{} card if you win with your last hand',
                '{C:inactive}Only triggers once per round'
            }
        },

        calculate = function(self, card, context)
            if context.joker_main and G.GAME.current_round.hands_left == 0 and not context.blueprint then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card {
                                set = 'Tarot',
                                key_append = 'vremade_rainbowfish'
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                    return {
                        message = localize('k_plus_tarot'),
                        colour = G.C.SECONDARY_SET.Tarot
                    }
                end
            end
        end,

        in_pool = function(self)
            return true
        end,


        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }

    -- Neon Tetra

    SMODS.Joker {
        key = "NeonTetra",
        atlas = "Jokers",
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        rarity = "AC_Fish",
        cost = 6,
        pos = { x = 7, y = 1 },

        loc_txt = {
            name = "Neon Tetra",
            text = {
                'Creates a {C:planet}Planet{} card if you win with your last hand',
                '{C:inactive}Only triggers once per round'
            }
        },

        calculate = function(self, card, context)
            if context.joker_main and G.GAME.current_round.hands_left == 0 and not context.blueprint then
                if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card {
                                set = 'Planet',
                                key_append = 'vremade_neon_tetra'
                            }
                            G.GAME.consumeable_buffer = 0
                            return true
                        end
                    }))
                    return {
                        message = localize('k_plus_planet'),
                        colour = G.C.SECONDARY_SET.Planet
                    }
                end
            end
        end,

        in_pool = function(self)
            return true
        end,


        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }

    -- Guppy

    SMODS.Joker {
        key = "Guppy",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 5, y = 6 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = {
            extra = { dollars_per_glass = 1 }
        },

        loc_txt = {
            name = "Guppy",
            text = {
                "Gives {C:money}$#1#{} at the end of the round",
                "for each {C:attention}Glass{} card in your hand"
            }
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
            return {
                vars = { tostring(card.ability.extra.dollars_per_glass or 1) }
            }
        end,

        calculate = function(self, card, context)
            if context.end_of_round and not context.game_over and context.main_eval and not context.blueprint then
                local total = 0
                for _, held_card in ipairs(G.hand.cards or {}) do
                    if SMODS.has_enhancement(held_card, "m_glass") then
                        total = total + (card.ability.extra.dollars_per_glass or 1)
                    end
                end

                if total > 0 then
                    G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + total
                    return {
                        dollars = total,
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    G.GAME.dollar_buffer = 0
                                    return true
                                end
                            }))
                        end
                    }
                end
            end
        end,

        in_pool = function(self) return true end,

        add_to_deck = function(self, card)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }





    -- Salmon



    SMODS.Joker {
        key = "Salmon",
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,
        rarity = "AC_Fish",
        cost = 6,
        atlas = "Jokers",
        pos = { x = 4, y = 5 },

        loc_txt = {
            name = "Salmon",
            text = {
                "Creates a random card with the {C:mult}Mult{} enhancement",
                "at the start of every round"
            }
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
            return { vars = {} }
        end,

        calculate = function(self, card, context)
            if context.first_hand_drawn then
                local _card = SMODS.create_card { set = "Base", enhancement = "m_mult", area = G.discard }

                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand:emplace(_card)
                        _card:start_materialize()
                        G.GAME.blind:debuff_card(_card)
                        G.hand:sort()

                        if context.blueprint_card then
                            context.blueprint_card:juice_up()
                        else
                            card:juice_up()
                        end

                        return true
                    end
                }))

                SMODS.calculate_context({
                    playing_card_added = true,
                    cards = { _card }
                })

                return nil, true
            end
        end,

        check_for_unlock = function(self, args)
            return args.type == "double_gold"
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self)
            return true
        end
    }


    -- King Salmon



    SMODS.Joker {
        key = "KingSalmon",
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,
        rarity = "AC_Fish",
        cost = 6,
        atlas = "Jokers",
        pos = { x = 4, y = 3 },

        loc_txt = {
            name = "King Salmon",
            text = {
                "Creates a {C:dark_edition}Holographic{}, {C:attention}King{}",
                "with the {C:mult}Mult{} enhancement",
                "at the start of every round"
            }
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
            return { vars = {} }
        end,

        calculate = function(self, card, context)
            if context.first_hand_drawn then
                local _card = SMODS.create_card { set = "Base", enhancement = "m_mult", rank = "King", edition = "e_holo", area = G.discard }

                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.hand:emplace(_card)
                        _card:start_materialize()
                        G.GAME.blind:debuff_card(_card)
                        G.hand:sort()

                        if context.blueprint_card then
                            context.blueprint_card:juice_up()
                        else
                            card:juice_up()
                        end

                        return true
                    end
                }))

                SMODS.calculate_context({
                    playing_card_added = true,
                    cards = { _card }
                })

                return nil, true
            end
        end,

        check_for_unlock = function(self, args)
            return args.type == "double_gold"
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self)
            return true
        end
    }



    -- Sturgeon

    SMODS.Joker {
        key = "Sturgeon",
        atlas = "Jokers",
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        rarity = "AC_Fish",
        cost = 9,
        pos = { x = 4, y = 4 },

        loc_txt = {
            name = "Sturgeon",
            text = {
                'Creates a random {C:dark_edition}Negative{} {C:planet}Planet{} card when starting a new round'
            }
        },

        calculate = function(self, card, context)
            if context.setting_blind and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                return {
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                SMODS.add_card {
                                    set = 'Planet',
                                    edition = { negative = true },
                                    key_append = 'sturgeon'
                                }
                                G.GAME.consumeable_buffer = 0
                                return true
                            end
                        }))
                        SMODS.calculate_effect({
                            message = localize('k_plus_planet'),
                            colour = G.C.SECONDARY_SET.Planet
                        }, context.blueprint_card or card)
                        return true
                    end
                }
            end
        end,

        in_pool = function(self)
            return true
        end,


        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }














    -- Dorado

    SMODS.Joker {
        key = "Dorado",
        atlas = "Jokers",
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        rarity = "AC_Fish",
        cost = 7,
        pos = { x = 2, y = 4 },

        config = {
            extra = {
                dollars = 1,
                triggered = false
            }
        },

        loc_txt = {
            name = "Dorado",
            text = {
                'Retrigger all {C:attention}Gold{} cards scored',
                'Scoring {C:attention}Gold{} cards give {C:money}$1{}'
            }
        },

        calculate = function(self, card, context)
            if context.repetition and context.cardarea == G.play and context.other_card and
                SMODS.has_enhancement(context.other_card, 'm_gold') then
                return {
                    repetitions = 1
                }
            end

            if context.individual and context.cardarea == G.play and
                SMODS.has_enhancement(context.other_card, 'm_gold') then
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + card.ability.extra.dollars
                return {
                    dollars = card.ability.extra.dollars,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }
            end
        end,

        in_pool = function(self)
            for _, c in ipairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(c, 'm_gold') then
                    return true
                end
            end
            return false
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }












    -- Piranha

    SMODS.Joker {
        key = "Piranha",
        atlas = "Jokers",
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        rarity = "AC_Fish",
        cost = 6,
        pos = { x = 6, y = 2 },

        loc_txt = {
            name = "Piranha",
            text = {
                '{C:attention}Destroys{} a random card held in hand after each {C:blue}hand{} is played',
            }
        },

        calculate = function(self, card, context)
            if context.end_of_round or context.discard or context.blueprint then return end
            if context.after and G.hand and #G.hand.cards > 0 then
                local target = pseudorandom_element(G.hand.cards, pseudoseed('piranha_bite'))
                G.E_MANAGER:add_event(Event({
                    delay = 0.4,
                    func = function()
                        SMODS.destroy_cards(target)
                        return true
                    end
                }))
                return {
                    message = "Chomp!",
                    colour = G.C.RED
                }
            end
        end,

        in_pool = function(self)
            return true
        end,


        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }


    -- Great White Shark
    SMODS.Joker {
        key = "GreatWhiteShark",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 9,
        pos = { x = 3, y = 4 },

        loc_txt = {
            name = "Great White Shark",
            text = {
                'Destroys every card that was scored',
                '{C:inactive}Does not affect unscored cards'
            }
        },
        calculate = function(self, card, context)
            if context.destroy_card and context.cardarea == G.play and context.scoring_hand then
                for _, scored_card in ipairs(context.scoring_hand) do
                    if context.destroy_card == scored_card then
                        return {
                            remove = true,
                            message = "Chomp!",
                            colour = G.C.RED
                        }
                    end
                end
            end
        end,


        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }



    -- Whale Shark




    SMODS.Joker {
        key = "WhaleShark",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 9,
        pos = { x = 7, y = 4 },

        loc_txt = {
            name = "Whale Shark",
            text = {
                'Destroys every card that was scored',
                'Only if a {C:attention}Flush{} was played'
            }
        },

        calculate = function(self, card, context)
            if context.destroy_card and context.cardarea == G.play
                and context.scoring_hand and next(context.poker_hands['Flush']) then
                for _, scored_card in ipairs(context.scoring_hand) do
                    if context.destroy_card == scored_card then
                        return {
                            remove = true,
                            message = "Gulp!",
                            colour = G.C.BLUE
                        }
                    end
                end
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }








    -- Saw Shark




    SMODS.Joker {
        key = "SawShark",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 9,
        pos = { x = 8, y = 4 },

        loc_txt = {
            name = "Saw Shark",
            text = {
                'Destroys every card that was scored',
                'Only if a {C:attention}Straight{} was played'
            }
        },

        calculate = function(self, card, context)
            if context.destroy_card and context.cardarea == G.play
                and context.scoring_hand and next(context.poker_hands['Straight']) then
                for _, scored_card in ipairs(context.scoring_hand) do
                    if context.destroy_card == scored_card then
                        return {
                            remove = true,
                            message = "Slice!",
                            colour = G.C.ORANGE
                        }
                    end
                end
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }




    -- Hammer Head


    SMODS.Joker {
        key = "HammerheadShark",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 9,
        pos = { x = 9, y = 4 },

        loc_txt = {
            name = "Hammerhead Shark",
            text = {
                'Destroys every card that was scored',
                'Only if a {C:attention}Full House{} was played'
            }
        },

        calculate = function(self, card, context)
            if context.destroy_card and context.cardarea == G.play
                and context.scoring_hand and next(context.poker_hands['Full House']) then
                for _, scored_card in ipairs(context.scoring_hand) do
                    if context.destroy_card == scored_card then
                        return {
                            remove = true,
                            message = "Thwack!",
                            colour = G.C.PURPLE
                        }
                    end
                end
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }






    -- Suckerfish
    SMODS.Joker {
        key = "Suckerfish",
        atlas = "Jokers",
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        rarity = "AC_Fish",
        cost = 7,
        pos = { x = 0, y = 3 },

        loc_txt = {
            name = "Suckerfish",
            text = {
                "Copies the Joker to its {C:attention}left{}",
                "Only if it's a {C:blue}Fish Joker{}"
            }
        },

        loc_vars = function(self, info_queue, card)
            if card.area == G.jokers then
                local other_joker
                for i = 1, #G.jokers.cards do
                    if G.jokers.cards[i] == card then
                        other_joker = G.jokers.cards[i - 1]
                        break
                    end
                end

                local rarity = other_joker and other_joker.config
                    and other_joker.config.center
                    and other_joker.config.center.rarity

                local rarity_key = type(rarity) == "table" and rarity.key or rarity
                local compatible = rarity_key == "AC_Fish" and other_joker.config.center.blueprint_compat

                return {
                    main_end = {
                        {
                            n = G.UIT.C,
                            config = { align = "bm", minh = 0.4 },
                            nodes = {
                                {
                                    n = G.UIT.C,
                                    config = {
                                        ref_table = card,
                                        align = "m",
                                        colour = compatible and mix_colours(G.C.GREEN, G.C.JOKER_GREY, 0.8)
                                            or mix_colours(G.C.RED, G.C.JOKER_GREY, 0.8),
                                        r = 0.05,
                                        padding = 0.06
                                    },
                                    nodes = {
                                        {
                                            n = G.UIT.T,
                                            config = {
                                                text = ' ' ..
                                                    localize('k_' .. (compatible and 'compatible' or 'incompatible')) ..
                                                    ' ',
                                                colour = G.C.UI.TEXT_LIGHT,
                                                scale = 0.32 * 0.8
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            end
        end,

        calculate = function(self, card, context)
            local other_joker
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then
                    other_joker = G.jokers.cards[i - 1]
                    break
                end
            end

            local rarity = other_joker and other_joker.config
                and other_joker.config.center
                and other_joker.config.center.rarity

            local rarity_key = type(rarity) == "table" and rarity.key or rarity
            local compatible = rarity_key == "AC_Fish" and other_joker.config.center.blueprint_compat

            if compatible then
                return SMODS.blueprint_effect(card, other_joker, context)
            end
        end,

        check_for_unlock = function(self, args)
            return args.type == 'win_custom'
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self)
            return true
        end
    }




    -- Moray EEl

    SMODS.Joker {
        key = "MorayEel",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 6,
        pos = { x = 2, y = 3 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,

        config = {
            extra = { mult = 10 }
        },

        loc_txt = {
            name = "Moray Eel",
            text = {
                "When a {C:attention}Straight{} is played",
                "{C:mult}+10 Mult{} and",
                "retrigger the {C:attention}first{} card scored {C:attention}1{} time"
            }
        },

        loc_vars = function(self, info_queue, card)
            local m = card.ability and card.ability.extra and card.ability.extra.mult or 0
            return { vars = { m } }
        end,

        calculate = function(self, card, context)
            local mult = (card.ability and card.ability.extra and card.ability.extra.mult) or 3

            -- Bonus mult if hand is a Straight
            if context.joker_main and next(context.poker_hands["Straight"]) then
                return {
                    mult = mult * #context.poker_hands["Straight"],
                    colour = G.C.MULT
                }
            end

            -- Retrigger first card in scoring hand
            if context.repetition and context.cardarea == G.play
                and context.scoring_hand and context.other_card == context.scoring_hand[1]
                and next(context.poker_hands["Straight"]) then
                return {
                    repetitions = 1
                }
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,



        in_pool = function(self) return true end
    }




    -- Ribbon Eel



    SMODS.Joker {
        key = "RibbonEel",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 6,
        pos = { x = 1, y = 3 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,

        config = {
            extra = { chips = 50, reps = 2 }
        },

        loc_txt = {
            name = "Ribbon Eel",
            text = {
                "If a {C:attention}Straight{} is played:",
                "{C:chips}+50 Chips{} and",
                "Retrigger the {C:attention}last{} card scored {C:attention}2{} times"
            }
        },

        loc_vars = function(self, info_queue, card)
            local x = card.ability and card.ability.extra and card.ability.extra.chips or 0
            local r = card.ability and card.ability.extra and card.ability.extra.reps or 0
            return { vars = { x, r } }
        end,

        calculate = function(self, card, context)
            local chips = (card.ability and card.ability.extra and card.ability.extra.chips) or 15
            local reps = (card.ability and card.ability.extra and card.ability.extra.reps) or 2

            -- Bonus chips if hand is a Straight
            if context.joker_main and next(context.poker_hands["Straight"]) then
                return {
                    chips = chips * #context.poker_hands["Straight"],
                    colour = G.C.CHIPS
                }
            end

            -- Retrigger last card in scoring hand
            if context.repetition and context.cardarea == G.play
                and context.scoring_hand and context.other_card == context.scoring_hand[#context.scoring_hand]
                and next(context.poker_hands["Straight"]) then
                return {
                    repetitions = reps
                }
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,



        in_pool = function(self) return true end
    }



    -- Dab


    SMODS.Joker {
        key = "Dab",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 8, y = 2 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,

        loc_txt = {
            name = "Dab",
            text = {
                "Gives {C:mult}+2 Mult{}",
                "to each card held in {C:attention}hand{}"
            }
        },

        calculate = function(self, card, context)
            if context.individual and context.cardarea == G.hand and not context.end_of_round then
                if not context.other_card.debuff then
                    return {
                        mult = 2,
                        colour = G.C.MULT
                    }
                end
            end
        end,


        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,



        in_pool = function(self)
            return true
        end
    }



    -- Olive Flounder




    SMODS.Joker {
        key = "OliveFlounder",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 9, y = 2 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,

        loc_txt = {
            name = "Olive Flounder",
            text = {
                "Gives {C:chips}+10 Chips{}",
                "to each card held in {C:attention}hand{}"
            }
        },

        calculate = function(self, card, context)
            if context.individual and context.cardarea == G.hand and not context.end_of_round then
                if not context.other_card.debuff then
                    return {
                        chips = 10,
                        colour = G.C.CHIPS
                    }
                end
            end
        end,


        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,



        in_pool = function(self)
            return true
        end
    }






    -- Anchovy

    SMODS.Joker {
        key = "Anchovy",
        atlas = "Jokers",
        blueprint_compat = true,
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 8, y = 0 },
        config = { extra = { chip = 10 } },

        loc_txt = {
            name = "Anchovy",
            text = {
                '{C:chips}+10{} Chips for each Joker you have',
                '{C:inactive}(Currently {C:chips}+#1#{} Chips)'
            }
        },

        loc_vars = function(self, info_queue, card)
            local count = G.jokers and #G.jokers.cards or 0
            return {
                vars = {
                    string.format("%d", (card.ability and card.ability.extra and card.ability.extra.chip or 10) * count)
                }
            }
        end,

        calculate = function(self, card, context)
            if context.joker_main then
                return {
                    chips = card.ability.extra.chip * #G.jokers.cards
                }
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self)
            return true
        end
    }



    -- Zebra Turkeyfish





    SMODS.Joker {
        key = "ZebraTurkeyfish",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 9, y = 7 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { xmult = 2 } },

        loc_txt = {
            name = "Zebra Turkeyfish",
            text = {
                "{C:attention}Wild{} cards",
                "score for {X:mult,C:white}X2{} when played"
            }
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_wild
            return {
                vars = {
                    card.ability.extra.xmult or 2
                }
            }
        end,

        calculate = function(self, card, context)
            if context.individual
                and context.cardarea == G.play
                and SMODS.has_enhancement(context.other_card, 'm_wild') then
                return {
                    xmult = card.ability.extra.xmult or 2
                }
            end
        end,

        in_pool = function(self)
            for _, playing_card in ipairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(playing_card, 'm_wild') then
                    return true
                end
            end
            return false
        end,

        check_for_unlock = function(self, args)
            if args.type == 'hand_contents' then
                local tally = 0
                for _, c in ipairs(args.cards) do
                    if SMODS.has_enhancement(c, 'm_wild') then
                        tally = tally + 1
                        if tally >= 5 then return true end
                    end
                end
            end
            return false
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }


    -- Barred Knifejaw


    SMODS.Joker {
        key = "BarredKnifejaw",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 5, y = 5 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { xmult = 2 } },

        loc_txt = {
            name = "Barred Knifejaw",
            text = {
                "{C:attention}Steel{} cards",
                "score for {X:mult,C:white}X2{} when played"
            }
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
            return {
                vars = {
                    card.ability.extra.xmult or 2
                }
            }
        end,

        calculate = function(self, card, context)
            if context.individual
                and context.cardarea == G.play
                and SMODS.has_enhancement(context.other_card, 'm_steel') then
                return {
                    xmult = card.ability.extra.xmult or 2
                }
            end
        end,

        in_pool = function(self)
            for _, playing_card in ipairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(playing_card, 'm_steel') then
                    return true
                end
            end
            return false
        end,

        check_for_unlock = function(self, args)
            if args.type == 'hand_contents' then
                local tally = 0
                for _, c in ipairs(args.cards) do
                    if SMODS.has_enhancement(c, 'm_steel') then
                        tally = tally + 1
                        if tally >= 5 then return true end
                    end
                end
            end
            return false
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }


    -- Koi

    SMODS.Joker {
        key = "Koi",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 6,
        pos = { x = 6, y = 6 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        loc_txt = {
            name = "Koi",
            text = {
                "If your scoring hand includes a {C:hearts}Heart{},",
                "balance {C:chips}Chips{} and {C:mult}Mult{}"
            }
        },

        calculate = function(self, card, context)
            if context.final_scoring_step and context.scoring_hand then
                for _, scoring_card in ipairs(context.scoring_hand) do
                    if scoring_card.base and scoring_card.base.suit == "Hearts" then
                        return { balance = true }
                    end
                end
            end
        end,

        in_pool = function(self) return true end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }

    -- Mahi Mahi

    SMODS.Joker {
        key = "MahiMahi",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 7, y = 6 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = {
            extra = { chips = 20, dollars = 2 }
        },

        loc_txt = {
            name = "Mahi-Mahi",
            text = {
                "Gives {C:chips}+#1#{} chips and {C:money}$#2#{}",
                "when playing a {C:attention}Two Pair"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    tostring(card.ability.extra.chips or 20),
                    tostring(card.ability.extra.dollars or 2)
                }
            }
        end,

        calculate = function(self, card, context)
            if context.joker_main and context.scoring_name == "Two Pair" then
                return {
                    chips = card.ability.extra.chips or 20,
                    dollars = card.ability.extra.dollars or 2,
                }
            end
        end,

        in_pool = function(self) return true end,

        add_to_deck = function(self, card)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }

    -- Sweetfish


    SMODS.Joker {
        key = "Sweetfish",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 7, y = 7 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { value_boost = 1 } },

        loc_txt = {
            name = "Sweetfish",
            text = {
                "Each shop reroll increases the sell value of all",
                "{C:attention}Consumables{} by {C:money}$#1#{}"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = { tostring(card.ability.extra.value_boost or 1) }
            }
        end,

        calculate = function(self, card, context)
            if context.reroll_shop and not context.blueprint then
                for _, other_card in ipairs(G.consumeables.cards or {}) do
                    if other_card.set_cost then
                        other_card.ability.extra_value = (other_card.ability.extra_value or 0) +
                            (card.ability.extra.value_boost or 1)
                        other_card:set_cost()
                    end
                end
                return {
                    message = "Sweet!",
                    colour = G.C.MONEY
                }
            end
        end,

        in_pool = function(self) return true end,

        add_to_deck = function(self, card)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }


    -- Tuna


    SMODS.Joker {
        key = "Tuna",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 5, y = 4 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,

        config = { extra = { payout = 10 } },

        loc_txt = {
            name = "Tuna",
            text = {
                "{C:money}$10{} when you play",
                "a {C:attention}Flush{}"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.payout or 10,
                    localize("Flush", "poker_hands")
                }
            }
        end,

        calculate = function(self, card, context)
            if context.joker_main and context.scoring_name == "Flush" then
                local payout = card.ability.extra.payout or 10
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + payout
                return {
                    dollars = payout,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self) return true end
    }



    -- Blue Marlin

    SMODS.Joker {
        key = "BlueMarlin",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 6, y = 4 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,

        config = { extra = { payout = 10 } },

        loc_txt = {
            name = "Blue Marlin",
            text = {
                "{C:money}$10{} when you play",
                "a {C:attention}Straight{}"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.payout or 10,
                    localize("Straight", "poker_hands")
                }
            }
        end,

        calculate = function(self, card, context)
            if context.joker_main and context.scoring_name == "Straight" then
                local payout = card.ability.extra.payout or 10
                G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + payout
                return {
                    dollars = payout,
                    func = function()
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                G.GAME.dollar_buffer = 0
                                return true
                            end
                        }))
                    end
                }
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self) return true end
    }





    -- Charr

    SMODS.Joker {
        key = "Char",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 7, y = 5 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { mult = 0, mult_gain = 2 } },

        loc_txt = {
            name = "Char",
            text = {
                "Gains {C:mult}+2{} mult when discarding a",
                "{C:attention}single{} card",
                "{C:inactive}Currently {C:mult}+#1#{}"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    string.format("%d", card.ability and card.ability.extra and card.ability.extra.mult or 0)
                }
            }
        end,

        calculate = function(self, card, context)
            if context.discard and not context.blueprint and #context.full_hand == 1 then
                card.ability.extra.mult = card.ability.extra.mult + (card.ability.extra.mult_gain or 2)
                return {
                    message = localize("k_upgrade_ex"),
                    colour = G.C.MULT
                }
            end

            if context.joker_main then
                return { mult = card.ability.extra.mult }
            end
        end,

        in_pool = function(self) return true end,

        add_to_deck = function(self, card)
            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        end,

        remove_from_deck = function(self, card)
            G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
        end
    }
    --Cherry Salmon


    SMODS.Joker {
        key = "CherrySalmon",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 8, y = 5 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { chips = 0, chip_gain = 5 } },

        loc_txt = {
            name = "Cherry Salmon",
            text = {
                "Gain {C:chips}+5{} chips when playing a",
                "{C:attention}single{} card",
                "{C:inactive}Currently {C:chips}+#1#{}"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    string.format("%d", card.ability and card.ability.extra and card.ability.extra.chips or 0)
                }
            }
        end,

        calculate = function(self, card, context)
            if context.before and context.main_eval and not context.blueprint and #context.full_hand == 1 then
                card.ability.extra.chips = card.ability.extra.chips + (card.ability.extra.chip_gain or 5)
                return {
                    message = localize("k_upgrade_ex"),
                    colour = G.C.CHIPS
                }
            end

            if context.joker_main then
                return { chips = card.ability.extra.chips }
            end
        end,

        in_pool = function(self) return true end,

        add_to_deck = function(self, card)
            G.jokers.config.card_limit = G.jokers.config.card_limit + 1
        end,

        remove_from_deck = function(self, card)
            G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
        end
    }

    -- Golden Trout

    SMODS.Joker {
        key = "GoldenTrout",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 4, y = 6 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = {},

        loc_txt = {
            name = "Golden Trout",
            text = {
                "{C:money}$1{} at the end of the round",
                "for each {C:attention}Gold{} card in full deck",
                "{C:inactive}Currently{} {C:money}$#1#{}"
            }
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
            local golds = 0
            for _, v in ipairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(v, "m_gold") then
                    golds = golds + 1
                end
            end
            return { vars = { tostring(golds) } }
        end,

        calc_dollar_bonus = function(self, card)
            local golds = 0
            for _, v in ipairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(v, "m_gold") then
                    golds = golds + 1
                end
            end
            return golds
        end,

        in_pool = function(self)
            return true
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }




    -- Angelfish


    SMODS.Joker {
        key = "Angelfish",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 6,
        pos = { x = 0, y = 5 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { mult = 5, odds = 2 } },

        loc_txt = {
            name = "Angelfish",
            text = {
                "Played {C:attention}Diamond{} cards have a {C:green}#1# in #2#{} chance",
                "to give {C:mult}+#3#{} mult"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    tostring(G.GAME.probabilities.normal or 1),
                    tostring(card.ability.extra.odds or 2),
                    tostring(card.ability.extra.mult or 5)
                }
            }
        end,

        calculate = function(self, card, context)
            if context.individual
                and context.cardarea == G.play
                and context.other_card:is_suit("Diamonds")
                and pseudorandom("angelfish") < ((G.GAME.probabilities.normal or 1) / (card.ability.extra.odds or 2)) then
                return {
                    mult = card.ability.extra.mult or 5
                }
            end
        end,

        in_pool = function(self)
            return true
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }



    -- Seahorse


    SMODS.Joker {
        key = "Seahorse",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 8,
        pos = { x = 6, y = 3 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { mult = 0, mult_gain = 3 } },

        loc_txt = {
            name = "Seahorse",
            text = {
                "Gains {C:mult}+3 mult{} whenever a {C:attention}3{} is scored",
                "{C:inactive}Currently {C:mult}+#1#{}"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    string.format("%d", card.ability and card.ability.extra and card.ability.extra.mult or 0)
                }
            }
        end,

        calculate = function(self, card, context)
            if context.individual and context.cardarea == G.play
                and context.other_card:get_id() == 3 and not context.blueprint then
                card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.mult_gain

                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MULT,
                    message_card = card
                }
            end

            if context.joker_main then
                return {
                    mult = card.ability.extra.mult
                }
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self)
            return true
        end
    }

    -- Squid

    SMODS.Joker {
        key = "Squid",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 4, y = 7 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { h_size = 2 } },

        loc_txt = {
            name = "Squid",
            text = {
                "{C:attention}+2{} hand size"
            }
        },

        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.h_size or 2 } }
        end,

        add_to_deck = function(self, card, from_debuff)
            G.hand:change_size(card.ability.extra.h_size or 2)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            G.hand:change_size(-(card.ability.extra.h_size or 2))
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self)
            return true
        end
    }

    --Snapping Turtle

    SMODS.Joker {
        key = "SnappingTurtle",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 6,
        pos = { x = 2, y = 7 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { xmult = 1.0, gain = 0.1 } },

        loc_txt = {
            name = "Snapping Turtle",
            text = {
                "Gains {X:mult,C:white}X0.1{} mult for every reroll in the shop",
                "{C:inactive}Currently {X:mult,C:white}X#1#{}"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    string.format("%.1f", card.ability.extra.xmult or 1.0)
                }
            }
        end,

        calculate = function(self, card, context)
            if context.reroll_shop and not context.blueprint then
                card.ability.extra.xmult = card.ability.extra.xmult + (card.ability.extra.gain or 0.1)
                return {
                    message = "Snap!",
                    colour = G.C.XMULT
                }
            end

            if context.joker_main then
                return { xmult = card.ability.extra.xmult }
            end
        end,

        in_pool = function(self) return true end,

        add_to_deck = function(self, card)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }



    -- Soft-Shelled Turtle


    SMODS.Joker {
        key = "SoftShelledTurtle",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 6,
        pos = { x = 3, y = 7 },
        unlocked = true,
        discovered = true,
        blueprint_compat = false,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { dollar_gain = 1 } },

        loc_txt = {
            name = "Soft-Shelled Turtle",
            text = {
                "Gains {C:money}$1{} of sell value every time you reroll the shop",
                "{C:inactive}Currently {C:money}$#1#{}"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    tostring(card.ability.extra_value or 0)
                }
            }
        end,

        calculate = function(self, card, context)
            if context.reroll_shop and not context.blueprint then
                card.ability.extra_value = (card.ability.extra_value or 0) + (card.ability.extra.dollar_gain or 1)
                card:set_cost()
                return {
                    message = "Squish!",
                    colour = G.C.MONEY
                }
            end
        end,

        in_pool = function(self) return true end,

        add_to_deck = function(self, card)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }


    -- Tilapia

    SMODS.Joker {
        key = "Tilapia",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 6,
        pos = { x = 8, y = 7 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { steel_required = 2 } },

        loc_txt = {
            name = "Tilapia",
            text = {
                "Create 2 {C:tarot}Tarot{} cards when you {C:red}Discard{}",
                "{C:attention}#1#{} or more {C:attention}Steel{} cards at once",
                "{C:inactive}(Must have room){}"
            }
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_steel
            return { vars = { card.ability.extra.steel_required or 2 } }
        end,

        calculate = function(self, card, context)
            if context.discard and context.full_hand then
                local steel_count = 0
                for _, discarded_card in ipairs(context.full_hand) do
                    if SMODS.has_enhancement(discarded_card, "m_steel") then
                        steel_count = steel_count + 1
                    end
                end

                if steel_count >= (card.ability.extra.steel_required or 2)
                    and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                    G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

                    return {
                        func = function()
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    SMODS.add_card {
                                        set = "Tarot",
                                        key_append = "vremade_tilapia"
                                    }
                                    G.GAME.consumeable_buffer = 0
                                    return true
                                end
                            }))
                        end,
                        message = localize("k_plus_tarot"),
                        colour = G.C.TAROT
                    }
                end
            end
        end,

        in_pool = function(self) return true end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }

    -- Clownfish

    SMODS.Joker {
        key = "Clownfish",
        atlas = "Jokers",
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        rarity = "AC_Fish",
        cost = 6,
        pos = { x = 8, y = 1 },

        config = {
            extra = {
                creates = 1
            }
        },

        loc_txt = {
            name = "Clownfish",
            text = {
                'Creates {C:attention}1{} random {C:green}Uncommon{} Joker',
                'when a {C:attention}Blind{} is selected',
                '{C:inactive}(Must have room)'
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability and card.ability.extra and card.ability.extra.creates or 1
                }
            }
        end,

        calculate = function(self, card, context)
            if context.setting_blind and #G.jokers.cards + G.GAME.joker_buffer < G.jokers.config.card_limit then
                if G.GAME.joker_buffer == 0 then
                    G.GAME.joker_buffer = 1
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            SMODS.add_card {
                                set = 'Joker',
                                rarity = 'Uncommon',
                                key_append = 'fish_clownfish'
                            }
                            G.GAME.joker_buffer = 0
                            return true
                        end
                    }))
                    return {
                        message = localize('k_plus_joker'),
                        colour = G.C.RARITY_UNCOMMON
                    }
                end
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self)
            return true
        end
    }
    -- Surgeonfish



    SMODS.Joker {
        key = "Surgeonfish",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 6,
        pos = { x = 6, y = 7 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = {
            extra = {}
        },

        loc_txt = {
            name = "Surgeonfish",
            text = {
                "Retrigger all {C:attention}Bonus{} cards scored"
            }
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_bonus
            return { vars = {} }
        end,

        calculate = function(self, card, context)
            -- Repetition phase: add one extra trigger for every scored Bonus card
            if context.repetition and context.cardarea == G.play
                and context.other_card
                and SMODS.has_enhancement(context.other_card, "m_bonus") then
                return { repetitions = 1 }
            end
        end,

        in_pool = function(self)
            for _, c in ipairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(c, "m_bonus") then
                    return true
                end
            end
            return false
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }

    --Blowfish

    SMODS.Joker {
        key = "Blowfish",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 9, y = 1 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = {
            extra = { chips = 100 }
        },

        loc_txt = {
            name = "Blowfish",
            text = {
                "Gives {C:chips}+#1#{} chips",
                "on the final hand of the round"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    tostring(card.ability.extra.chips or 100)
                }
            }
        end,

        calculate = function(self, card, context)
            if context.joker_main
                and G.GAME.current_round
                and G.GAME.current_round.hands_left == 0 then
                return {
                    chips = card.ability.extra.chips or 100
                }
            end
        end,

        in_pool = function(self) return true end,

        add_to_deck = function(self, card)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }

    -- Sting Ray

    SMODS.Joker {
        key = "StingRay",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 0, y = 7 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { xmult = 2, threshold = 5 } },

        loc_txt = {
            name = "Sting Ray",
            text = {
                "{X:mult,C:white}X#1#{} when holding",
                "{C:attention}#2#{} or more cards"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    tostring(card.ability.extra.xmult or 2),
                    tostring(card.ability.extra.threshold or 5)
                }
            }
        end,

        calculate = function(self, card, context)
            if context.joker_main
                and G.hand
                and #G.hand.cards >= (card.ability.extra.threshold or 5) then
                return {
                    xmult = card.ability.extra.xmult or 2
                }
            end
        end,

        in_pool = function(self) return true end,

        add_to_deck = function(self, card)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }



    -- Napoleon Fish
    SMODS.Joker {
        key = "Napoleonfish",
        atlas = "Jokers",
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 3, y = 3 },

        config = {
            extra = { xmult_per_club = 0.1 }
        },

        loc_txt = {
            name = "Napoleonfish",
            text = {
                "{X:mult,C:white} X0.1{} for every{C:clubs} Club{} in full deck",
                '{C:inactive}Currently {X:mult,C:white}+#1#{}'
            }
        },

        loc_vars = function(self, info_queue, card)
            local clubs = 0
            for _, v in ipairs(G.playing_cards or {}) do
                if v:is_suit("Clubs") then
                    clubs = clubs + 1
                end
            end
            local bonus = clubs * ((card.ability and card.ability.extra and card.ability.extra.xmult_per_club) or 0.1)
            return {
                vars = {
                    string.format("%.1f", bonus)
                }
            }
        end,

        calculate = function(self, card, context)
            if context.joker_main then
                local clubs = 0
                for _, v in ipairs(G.playing_cards or {}) do
                    if v:is_suit("Clubs") then
                        clubs = clubs + 1
                    end
                end
                local xmult = clubs *
                    ((card.ability and card.ability.extra and card.ability.extra.xmult_per_club) or 0.1)
                if xmult > 0 then
                    return {
                        xmult = xmult,
                        colour = G.C.XMULT
                    }
                end
            end
        end,

        in_pool = function(self)
            return true
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }



    -- Saddled Bichir


    SMODS.Joker {
        key = "SaddledBichir",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 3, y = 5 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { repetitions = 2, target_hand = "Three of a Kind" } },

        loc_txt = {
            name = "Saddled Bichir",
            text = {
                "Retriggers the {C:attention}second card{} scored {C:attention}2{} times",
                "if hand contains {C:attention}Three of a Kind{}"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    localize(card.ability.extra.target_hand, "poker_hands")
                }
            }
        end,

        calculate = function(self, card, context)
            if context.repetition
                and context.cardarea == G.play
                and context.scoring_hand
                and next(context.poker_hands[card.ability.extra.target_hand])
                and context.other_card == context.scoring_hand[2] then
                return {
                    repetitions = card.ability.extra.repetitions
                }
            end
        end,

        in_pool = function(self)
            return true
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }
    -- Ocean Sunfish
    SMODS.Joker {
        key = "OceanSunfish",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 4,
        pos = { x = 0, y = 4 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = {
            extra = {
                xmult = 3,
                poker_hand = "Flush Five"
            }
        },

        loc_txt = {
            name = "Ocean Sunfish",
            text = {
                "{X:mult,C:white}X#1#{} mult when",
                "playing a {C:attention}#2#{}"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.xmult,
                    localize(card.ability.extra.poker_hand, "poker_hands")
                }
            }
        end,

        calculate = function(self, card, context)
            if context.joker_main
                and context.poker_hands
                and next(context.poker_hands[card.ability.extra.poker_hand]) then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self)
            return true
        end
    }


    -- Oarfish

    SMODS.Joker {
        key = "OarFish",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 4,
        pos = { x = 1, y = 4 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = {
            extra = {
                xmult = 3,
                poker_hand = "Straight Flush"
            }
        },

        loc_txt = {
            name = "Oar Fish",
            text = {
                "{X:mult,C:white}X#1#{} mult when",
                "playing a {C:attention}#2#{}"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.xmult,
                    localize(card.ability.extra.poker_hand, "poker_hands")
                }
            }
        end,

        calculate = function(self, card, context)
            if context.joker_main
                and context.poker_hands
                and next(context.poker_hands[card.ability.extra.poker_hand]) then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end,


        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self)
            return true
        end
    }

    -- Pike


    SMODS.Joker {
        key = "Pike",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 4,
        pos = { x = 9, y = 6 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = {
            extra = {
                xmult = 3,
                poker_hand = "Flush House"
            }
        },

        loc_txt = {
            name = "Pike",
            text = {
                "{X:mult,C:white}X#1#{} mult when",
                "playing a {C:attention}#2#{}"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    card.ability.extra.xmult,
                    localize(card.ability.extra.poker_hand, "poker_hands")
                }
            }
        end,

        calculate = function(self, card, context)
            if context.joker_main
                and context.poker_hands
                and next(context.poker_hands[card.ability.extra.poker_hand]) then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self)
            return true
        end
    }




    -- Gar
    SMODS.Joker {
        key = "Gar",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 6,
        pos = { x = 1, y = 6 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { xmult = 2 } },

        loc_txt = {
            name = "Gar",
            text = {
                "Playing a {C:attention}Full House{} with the {C:attention}smaller cards at the front{},",
                "the {C:attention}first 2{} cards give {X:mult,C:white}X#1#{} mult"
            }
        },

        loc_vars = function(self, info_queue, card)
            return { vars = { card.ability.extra.xmult } }
        end,

        calculate = function(self, card, context)
            if context.individual
                and context.cardarea == G.play
                and context.poker_hands
                and next(context.poker_hands["Full House"])
                and context.scoring_hand
                and #context.scoring_hand == 5 then
                local c = context.scoring_hand

                -- Extract IDs safely
                local r1 = c[1] and c[1]:get_id()
                local r2 = c[2] and c[2]:get_id()
                local r3 = c[3] and c[3]:get_id()
                local r4 = c[4] and c[4]:get_id()
                local r5 = c[5] and c[5]:get_id()

                -- Check for proper Full House structure and ranking
                local valid_order =
                    r1 == r2 and              -- First two are a pair
                    r3 == r4 and r4 == r5 and -- Last three are a triple
                    r1 < r3                   -- Pair rank < triple rank

                if valid_order and (context.other_card == c[1] or context.other_card == c[2]) then
                    return { xmult = card.ability.extra.xmult }
                end
            end
        end,

        in_pool = function(self)
            return true
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }


    -- Sea Butterfly

    SMODS.Joker {
        key = "SeaButterfly",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 1, y = 7 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { size = 1, odds = 2 } },

        loc_txt = {
            name = "Sea Butterfly",
            text = {
                "{C:green}#1# in #2#{} chance to grant a random {C:spectral}edition{}",
                "when playing a single card",
                "{C:inactive}Excluding{} {C:dark_edition}negative{}"
            }
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.e_foil
            info_queue[#info_queue + 1] = G.P_CENTERS.e_holo
            info_queue[#info_queue + 1] = G.P_CENTERS.e_polychrome
            return {
                vars = {
                    tostring(G.GAME and G.GAME.probabilities.normal or 1),
                    tostring(card.ability.extra.odds or 2)
                }
            }
        end,

        calculate = function(self, card, context)
            if context.joker_main and #context.full_hand == card.ability.extra.size then
                local single_card = context.full_hand[1]

                -- Disable if the card already has an edition
                if single_card.edition then return end

                if pseudorandom("seabutterfly_edition") < ((G.GAME.probabilities.normal or 1) / (card.ability.extra.odds or 2)) then
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        delay = 0.3,
                        func = function()
                            -- Extra edition guard just in case
                            if single_card.edition then return true end

                            local edition = poll_edition("seabutterfly_aura", nil, true, true, {
                                "e_polychrome", "e_holo", "e_foil"
                            })
                            single_card:set_edition(edition, true)
                            card:juice_up(0.3, 0.5)
                            return true
                        end
                    }))
                end
            end
        end,

        in_pool = function(self)
            return true
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }



    -- Football Fish



    SMODS.Joker {
        key = "FootballFish",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 6, y = 1 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { chips = 2 } },

        loc_txt = {
            name = "Football Fish",
            text = {
                "{C:chips}+2{} Chips",
                "for each card not in your current {C:attention}deck{}",
                "{C:inactive}(Currently {C:chips}+#1#{} Chips)"
            }
        },

        loc_vars = function(self, info_queue, card)
            local missing = 52 - ((G.deck and G.deck.cards) and #G.deck.cards or 0)
            local current = missing * (card.ability.extra.chips or 2)
            return {
                vars = { tostring(current) }
            }
        end,

        calculate = function(self, card, context)
            if context.joker_main then
                local missing = 52 - ((G.deck and G.deck.cards) and #G.deck.cards or 0)
                local bonus = missing * (card.ability.extra.chips or 2)
                if bonus > 0 then
                    return { chips = bonus }
                end
            end
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end,

        in_pool = function(self) return true end
    }





    -- Barreleye





    SMODS.Joker {
        key = "Barreleye",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 6,
        pos = { x = 6, y = 5 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        loc_txt = {
            name = "Barreleye",
            text = {
                "Gain either a {C:dark_edition}negative{} tag or {C:spectral}orbital{} tag",
                "whenever a {C:attention}Glass{} card is destroyed"
            }
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_glass
            return {
                vars = {}
            }
        end,

        calculate = function(self, card, context)
            if context.remove_playing_cards and not context.blueprint then
                local glass_count = 0
                for _, removed_card in ipairs(context.removed or {}) do
                    if removed_card.shattered or SMODS.has_enhancement(removed_card, "m_glass") then
                        glass_count = glass_count + 1
                    end
                end

                if glass_count > 0 then
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            for i = 1, glass_count do
                                local tag_key = pseudorandom("barreleye") < 0.5 and "tag_orbital" or "tag_negative"
                                local tag = Tag(tag_key)
                                tag:set_ability()

                                if tag_key == "tag_orbital" then
                                    local options = {}
                                    for k, v in pairs(G.GAME.hands or {}) do
                                        if v.visible then
                                            options[#options + 1] = k
                                        end
                                    end
                                    tag.ability.orbital_hand = pseudorandom_element(options, "barreleye_orbital")
                                end

                                add_tag(tag)
                            end
                            play_sound("glass1", 0.9 + math.random() * 0.1, 0.5)
                            return true
                        end
                    }))
                    return nil, true
                end
            end
        end,

        in_pool = function(self)
            for _, playing_card in ipairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(playing_card, "m_glass") then
                    return true
                end
            end
            return false
        end,

        locked_loc_vars = function(self, info_queue, card)
            return { vars = { 1, localize { type = "name_text", key = "m_glass", set = "Enhanced" } } }
        end,

        check_for_unlock = function(self, args)
            if args.type == "modify_deck" then
                local count = 0
                for _, playing_card in ipairs(G.playing_cards or {}) do
                    if SMODS.has_enhancement(playing_card, "m_glass") then
                        count = count + 1
                        if count >= 1 then
                            return true
                        end
                    end
                end
            end
            return false
        end
    }



    SMODS.Joker {
        key = "GiantTrevally",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 7,
        pos = { x = 3, y = 6 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = false,
        perishable_compat = false,

        loc_txt = {
            name = "Giant Trevally",
            text = {
                "Retrigger all {C:attention}Stone{} cards"
            }
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
            return { vars = {} }
        end,

        calculate = function(self, card, context)
            if context.repetition and context.cardarea == G.play and context.other_card and
                SMODS.has_enhancement(context.other_card, "m_stone") then
                return {
                    repetitions = 1
                }
            end
        end,

        in_pool = function(self)
            for _, c in ipairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(c, "m_stone") then
                    return true
                end
            end
            return false
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }


    --Giant Snakehead

    SMODS.Joker {
        key = "GiantSnakehead",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 6,
        pos = { x = 2, y = 6 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = {
            extra = { xmult = 1.0, xmult_gain = 0.1 }
        },

        loc_txt = {
            name = "Giant Snakehead",
            text = {
                "Gain {X:mult,C:white}X0.1{} when scoring",
                "a {C:attention}Face{} card",
                "{C:inactive}(Currently {X:mult,C:white}X#1#{})"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    string.format("%.1f", card.ability.extra.xmult or 1.0)
                }
            }
        end,

        calculate = function(self, card, context)
            -- If a face card is scored, increase Xmult
            if context.individual
                and context.cardarea == G.play
                and context.other_card
                and context.other_card:is_face()
                and not context.blueprint then
                card.ability.extra.xmult = (card.ability.extra.xmult or 1.0) + (card.ability.extra.xmult_gain or 0.1)

                return {
                }
            end

            -- Apply its current Xmult when used
            if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end,

        in_pool = function(self) return true end,

        add_to_deck = function(self, card)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }
    -- Arapaima

    SMODS.Joker {
        key = "Arapaima",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 1, y = 5 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { xmult = 1.5 } },

        loc_txt = {
            name = "Arapaima",
            text = {
                "{C:attention}Mult{} cards",
                "score for {X:mult,C:white}X#1#{} when played"
            }
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_mult
            return {
                vars = { card.ability.extra.xmult or 1.5 }
            }
        end,

        calculate = function(self, card, context)
            if context.individual
                and context.cardarea == G.play
                and SMODS.has_enhancement(context.other_card, "m_mult") then
                return {
                    xmult = card.ability.extra.xmult or 1.5
                }
            end
        end,

        in_pool = function(self)
            for _, c in ipairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(c, "m_mult") then
                    return true
                end
            end
            return false
        end,

        check_for_unlock = function(self, args)
            if args.type == "hand_contents" then
                local count = 0
                for _, c in ipairs(args.cards) do
                    if SMODS.has_enhancement(c, "m_mult") then
                        count = count + 1
                        if count >= 5 then return true end
                    end
                end
            end
            return false
        end,

        add_to_deck = function(self, card)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }
    -- Arowana

    SMODS.Joker {
        key = "Arowana",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 2, y = 5 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { xmult = 1.5 } },

        loc_txt = {
            name = "Arowana",
            text = {
                "{C:attention}Gold{} cards",
                "score for {X:mult,C:white}X#1#{} when played"
            }
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_gold
            return {
                vars = { card.ability.extra.xmult or 1.5 }
            }
        end,

        calculate = function(self, card, context)
            if context.individual
                and context.cardarea == G.play
                and SMODS.has_enhancement(context.other_card, "m_gold") then
                return {
                    xmult = card.ability.extra.xmult or 1.5
                }
            end
        end,

        in_pool = function(self)
            for _, playing_card in ipairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(playing_card, "m_gold") then
                    return true
                end
            end
            return false
        end,

        check_for_unlock = function(self, args)
            if args.type == "hand_contents" then
                local tally = 0
                for _, c in ipairs(args.cards) do
                    if SMODS.has_enhancement(c, "m_gold") then
                        tally = tally + 1
                        if tally >= 5 then return true end
                    end
                end
            end
            return false
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }

    -- Stringfish

    SMODS.Joker {
        key = "Stringfish",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 6,
        pos = { x = 5, y = 7 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = {
            extra = { xmult = 2.0, gain = 0.5 }
        },

        loc_txt = {
            name = "Stringfish",
            text = {
                "Gain {X:mult,C:white}X#1#{} mult every time",
                "a {C:attention}Four of a Kind{} with all {C:attention}suits{} is scored",
                "{C:inactive}(Currently {X:mult,C:white}X#2#{})"
            }
        },

        loc_vars = function(self, info_queue, card)
            return {
                vars = {
                    tostring(card.ability.extra.gain or 0.5),
                    string.format("%.1f", card.ability.extra.xmult or 2.0)
                }
            }
        end,

        calculate = function(self, card, context)
            if context.before and context.main_eval
                and context.scoring_name == "Four of a Kind"
                and context.scoring_hand
                and not context.blueprint then
                -- Check for all 4 suits
                local suit_found = {
                    Hearts = false,
                    Diamonds = false,
                    Spades = false,
                    Clubs = false
                }

                for _, c in ipairs(context.scoring_hand) do
                    for suit, _ in pairs(suit_found) do
                        if c:is_suit(suit, true) then
                            suit_found[suit] = true
                            break
                        end
                    end
                end

                local unique_suits = 0
                for _, v in pairs(suit_found) do
                    if v then unique_suits = unique_suits + 1 end
                end

                if unique_suits >= 4 then
                    card.ability.extra.xmult = (card.ability.extra.xmult or 2.0) + (card.ability.extra.gain or 0.5)
                    return {
                        message = "Scale!",
                        colour = G.C.XMULT
                    }
                end
            end

            if context.joker_main then
                return {
                    xmult = card.ability.extra.xmult
                }
            end
        end,

        in_pool = function(self)
            return true
        end,

        add_to_deck = function(self, card)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }

    -- Coelacanth

    SMODS.Joker {
        key = "Coelacanth",
        atlas = "Jokers",
        rarity = "AC_Fish",
        cost = 5,
        pos = { x = 9, y = 5 },
        unlocked = true,
        discovered = true,
        blueprint_compat = true,
        eternal_compat = true,
        perishable_compat = true,

        config = { extra = { xmult = 3 } },

        loc_txt = {
            name = "Coelacanth",
            text = {
                "{C:attention}Stone{} cards",
                "score for {X:mult,C:white}X3{} mult"
            }
        },

        loc_vars = function(self, info_queue, card)
            info_queue[#info_queue + 1] = G.P_CENTERS.m_stone
            return {
                vars = {
                    card.ability.extra.xmult or 3
                }
            }
        end,

        calculate = function(self, card, context)
            if context.individual
                and context.cardarea == G.play
                and SMODS.has_enhancement(context.other_card, "m_stone") then
                return {
                    xmult = card.ability.extra.xmult or 3
                }
            end
        end,

        in_pool = function(self)
            for _, playing_card in ipairs(G.playing_cards or {}) do
                if SMODS.has_enhancement(playing_card, "m_stone") then
                    return true
                end
            end
            return false
        end,

        check_for_unlock = function(self, args)
            if args.type == "hand_contents" then
                local tally = 0
                for _, c in ipairs(args.cards) do
                    if SMODS.has_enhancement(c, "m_stone") then
                        tally = tally + 1
                        if tally >= 5 then return true end
                    end
                end
            end
            return false
        end,

        add_to_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = G.jokers.config.card_limit + 1
            end
        end,

        remove_from_deck = function(self, card, from_debuff)
            if G.jokers and G.jokers.config then
                G.jokers.config.card_limit = math.max(1, G.jokers.config.card_limit - 1)
            end
        end
    }



    -- JOKERS END HERE
end

-- if config.moddedjokers == true then
setup_jokers()
-- end

-- Consumable type for Fishing Rod
SMODS.ConsumableType {
    key = 'FishingRodConsumableType',
    collection_rows = { 4, 5 },
    primary_colour = G.C.PURPLE,
    secondary_colour = G.C.DARK_EDITION,
    loc_txt = {
        collection = 'Fishing Rod Cards',
        name = 'Fishing Rod',
        undiscovered = {
            name = 'Unknown Fishing Rod',
            text = { 'A mysterious fishing rod' }
        }
    },
    shop_rate = 0,
}




-- Undiscovered sprite for the Fishing Rod Consumable
SMODS.UndiscoveredSprite {
    key = 'FishingRodConsumableType',
    atlas = 'Jokers',
    pos = { x = 0, y = 1 }
}

-- Fishing Rod consumables for every card rank (2 to Ace)
local card_names = {
    [2] = '2',
    [3] = '3',
    [4] = '4',
    [5] = '5',
    [6] = '6',
    [7] = '7',
    [8] = '8',
    [9] = '9',
    [10] = '10',
    [11] = 'Jack',
    [12] = 'Queen',
    [13] = 'King',
    [14] = 'Ace'
}

-- Fishing Rod for 2
SMODS.Consumable {
    key = 'FishingRod2',
    set = 'FishingRodConsumableType',
    atlas = 'Extra',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Fishing Rod',
        text = { 'Do you have any {C:attention}2{}\'s?' }
    },
    use = function(self, card, area, copier)
        if not G.hand or not G.hand.highlighted then return true end
        if #G.hand.highlighted ~= 1 then return true end
        local target_card = G.hand.highlighted[1]
        if not target_card or target_card:get_id() ~= 2 or not target_card.start_dissolve then return true end
        target_card:start_dissolve()
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                SMODS.add_card({ set = 'Joker', rarity = 'AC_Fish' })
                card:juice_up(0.3, 0.5)
                attention_text({
                    text = "GO FISH",
                    scale = 1.3,
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.WHITE,
                    align = 'cm',
                    offset = { x = 0, y = -2 },
                    silent = true
                })
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.06 * G.SETTINGS.GAMESPEED,
                    blockable = false,
                    blocking = false,
                    func = function()
                        play_sound('tarot2', 0.76, 0.4)
                        return true
                    end
                }))
                play_sound('tarot2', 1, 0.4)
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        if not G.hand or not G.hand.highlighted then return false end
        if #G.hand.highlighted ~= 1 then return false end
        local target_card = G.hand.highlighted[1]
        return target_card and target_card:get_id() == 2
    end
}


-- Fishing Rod for 3
SMODS.Consumable {
    key = 'FishingRod3',
    set = 'FishingRodConsumableType',
    atlas = 'Extra',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Fishing Rod',
        text = { 'Do you have any {C:attention}3{}\'s?' }
    },
    use = function(self, card, area, copier)
        if not G.hand or not G.hand.highlighted then return true end
        if #G.hand.highlighted ~= 1 then return true end
        local target_card = G.hand.highlighted[1]
        if not target_card or target_card:get_id() ~= 3 or not target_card.start_dissolve then return true end
        target_card:start_dissolve()
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                if config.moddedjokers == true then
                    SMODS.add_card({ set = 'Joker', rarity = 'AC_Fish' })
                else
                    SMODS.add_card({ set = 'Joker' })
                end
                card:juice_up(0.3, 0.5)
                attention_text({
                    text = "GO FISH",
                    scale = 1.3,
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.WHITE,
                    align = 'cm',
                    offset = { x = 0, y = -2 },
                    silent = true
                })
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.06 * G.SETTINGS.GAMESPEED,
                    blockable = false,
                    blocking = false,
                    func = function()
                        play_sound('tarot2', 0.76, 0.4)
                        return true
                    end
                }))
                play_sound('tarot2', 1, 0.4)
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        if not G.hand or not G.hand.highlighted then return false end
        if #G.hand.highlighted ~= 1 then return false end
        local target_card = G.hand.highlighted[1]
        return target_card and target_card:get_id() == 3
    end
}


-- Fishing Rod for 4
SMODS.Consumable {
    key = 'FishingRod4',
    set = 'FishingRodConsumableType',
    atlas = 'Extra',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Fishing Rod',
        text = { 'Do you have any {C:attention}4{}\'s?' }
    },
    use = function(self, card, area, copier)
        if not G.hand or not G.hand.highlighted then return true end
        if #G.hand.highlighted ~= 1 then return true end
        local target_card = G.hand.highlighted[1]
        if not target_card or target_card:get_id() ~= 4 or not target_card.start_dissolve then return true end
        target_card:start_dissolve()
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                if config.moddedjokers == true then
                    SMODS.add_card({ set = 'Joker', rarity = 'AC_Fish' })
                else
                    SMODS.add_card({ set = 'Joker' })
                end
                card:juice_up(0.3, 0.5)
                attention_text({
                    text = "GO FISH",
                    scale = 1.3,
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.WHITE,
                    align = 'cm',
                    offset = { x = 0, y = -2 },
                    silent = true
                })
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.06 * G.SETTINGS.GAMESPEED,
                    blockable = false,
                    blocking = false,
                    func = function()
                        play_sound('tarot2', 0.76, 0.4)
                        return true
                    end
                }))
                play_sound('tarot2', 1, 0.4)
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        if not G.hand or not G.hand.highlighted then return false end
        if #G.hand.highlighted ~= 1 then return false end
        local target_card = G.hand.highlighted[1]
        return target_card and target_card:get_id() == 4
    end
}

-- Fishing Rod for 5
SMODS.Consumable {
    key = 'FishingRod5',
    set = 'FishingRodConsumableType',
    atlas = 'Extra',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Fishing Rod',
        text = { 'Do you have any {C:attention}5{}\'s?' }
    },
    use = function(self, card, area, copier)
        if not G.hand or not G.hand.highlighted then return true end
        if #G.hand.highlighted ~= 1 then return true end
        local target_card = G.hand.highlighted[1]
        if not target_card or target_card:get_id() ~= 5 or not target_card.start_dissolve then return true end
        target_card:start_dissolve()
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                if config.moddedjokers == true then
                    SMODS.add_card({ set = 'Joker', rarity = 'AC_Fish' })
                else
                    SMODS.add_card({ set = 'Joker' })
                end
                card:juice_up(0.3, 0.5)
                attention_text({
                    text = "GO FISH",
                    scale = 1.3,
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.WHITE,
                    align = 'cm',
                    offset = { x = 0, y = -2 },
                    silent = true
                })
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.06 * G.SETTINGS.GAMESPEED,
                    blockable = false,
                    blocking = false,
                    func = function()
                        play_sound('tarot2', 0.76, 0.4)
                        return true
                    end
                }))
                play_sound('tarot2', 1, 0.4)
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        if not G.hand or not G.hand.highlighted then return false end
        if #G.hand.highlighted ~= 1 then return false end
        local target_card = G.hand.highlighted[1]
        return target_card and target_card:get_id() == 5
    end
}


-- Fishing Rod for 6
SMODS.Consumable {
    key = 'FishingRod6',
    set = 'FishingRodConsumableType',
    atlas = 'Extra',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Fishing Rod',
        text = { 'Do you have any {C:attention}6{}\'s?' }
    },
    use = function(self, card, area, copier)
        if not G.hand or not G.hand.highlighted then return true end
        if #G.hand.highlighted ~= 1 then return true end
        local target_card = G.hand.highlighted[1]
        if not target_card or target_card:get_id() ~= 6 or not target_card.start_dissolve then return true end
        target_card:start_dissolve()
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                if config.moddedjokers == true then
                    SMODS.add_card({ set = 'Joker', rarity = 'AC_Fish' })
                else
                    SMODS.add_card({ set = 'Joker' })
                end
                card:juice_up(0.3, 0.5)
                attention_text({
                    text = "GO FISH",
                    scale = 1.3,
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.WHITE,
                    align = 'cm',
                    offset = { x = 0, y = -2 },
                    silent = true
                })
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.06 * G.SETTINGS.GAMESPEED,
                    blockable = false,
                    blocking = false,
                    func = function()
                        play_sound('tarot2', 0.76, 0.4)
                        return true
                    end
                }))
                play_sound('tarot2', 1, 0.4)
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        if not G.hand or not G.hand.highlighted then return false end
        if #G.hand.highlighted ~= 1 then return false end
        local target_card = G.hand.highlighted[1]
        return target_card and target_card:get_id() == 6
    end
}

-- Fishing Rod for 7
SMODS.Consumable {
    key = 'FishingRod7',
    set = 'FishingRodConsumableType',
    atlas = 'Extra',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Fishing Rod',
        text = { 'Do you have any {C:attention}7{}\'s?' }
    },
    use = function(self, card, area, copier)
        if not G.hand or not G.hand.highlighted then return true end
        if #G.hand.highlighted ~= 1 then return true end
        local target_card = G.hand.highlighted[1]
        if not target_card or target_card:get_id() ~= 7 or not target_card.start_dissolve then return true end
        target_card:start_dissolve()
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                if config.moddedjokers == true then
                    SMODS.add_card({ set = 'Joker', rarity = 'AC_Fish' })
                else
                    SMODS.add_card({ set = 'Joker' })
                end
                card:juice_up(0.3, 0.5)
                attention_text({
                    text = "GO FISH",
                    scale = 1.3,
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.WHITE,
                    align = 'cm',
                    offset = { x = 0, y = -2 },
                    silent = true
                })
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.06 * G.SETTINGS.GAMESPEED,
                    blockable = false,
                    blocking = false,
                    func = function()
                        play_sound('tarot2', 0.76, 0.4)
                        return true
                    end
                }))
                play_sound('tarot2', 1, 0.4)
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        if not G.hand or not G.hand.highlighted then return false end
        if #G.hand.highlighted ~= 1 then return false end
        local target_card = G.hand.highlighted[1]
        return target_card and target_card:get_id() == 7
    end
}


-- Fishing Rod for 8
SMODS.Consumable {
    key = 'FishingRod8',
    set = 'FishingRodConsumableType',
    atlas = 'Extra',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Fishing Rod',
        text = { 'Do you have any {C:attention}8{}\'s?' }
    },
    use = function(self, card, area, copier)
        if not G.hand or not G.hand.highlighted then return true end
        if #G.hand.highlighted ~= 1 then return true end
        local target_card = G.hand.highlighted[1]
        if not target_card or target_card:get_id() ~= 8 or not target_card.start_dissolve then return true end
        target_card:start_dissolve()
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                if config.moddedjokers == true then
                    SMODS.add_card({ set = 'Joker', rarity = 'AC_Fish' })
                else
                    SMODS.add_card({ set = 'Joker' })
                end
                card:juice_up(0.3, 0.5)
                attention_text({
                    text = "GO FISH",
                    scale = 1.3,
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.WHITE,
                    align = 'cm',
                    offset = { x = 0, y = -2 },
                    silent = true
                })
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.06 * G.SETTINGS.GAMESPEED,
                    blockable = false,
                    blocking = false,
                    func = function()
                        play_sound('tarot2', 0.76, 0.4)
                        return true
                    end
                }))
                play_sound('tarot2', 1, 0.4)
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        if not G.hand or not G.hand.highlighted then return false end
        if #G.hand.highlighted ~= 1 then return false end
        local target_card = G.hand.highlighted[1]
        return target_card and target_card:get_id() == 8
    end
}


-- Fishing Rod for 9
SMODS.Consumable {
    key = 'FishingRod9',
    set = 'FishingRodConsumableType',
    atlas = 'Extra',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Fishing Rod',
        text = { 'Do you have any {C:attention}9{}\'s?' }
    },
    use = function(self, card, area, copier)
        if not G.hand or not G.hand.highlighted then return true end
        if #G.hand.highlighted ~= 1 then return true end
        local target_card = G.hand.highlighted[1]
        if not target_card or target_card:get_id() ~= 9 or not target_card.start_dissolve then return true end
        target_card:start_dissolve()
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                if config.moddedjokers == true then
                    SMODS.add_card({ set = 'Joker', rarity = 'AC_Fish' })
                else
                    SMODS.add_card({ set = 'Joker' })
                end
                card:juice_up(0.3, 0.5)
                attention_text({
                    text = "GO FISH",
                    scale = 1.3,
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.WHITE,
                    align = 'cm',
                    offset = { x = 0, y = -2 },
                    silent = true
                })
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.06 * G.SETTINGS.GAMESPEED,
                    blockable = false,
                    blocking = false,
                    func = function()
                        play_sound('tarot2', 0.76, 0.4)
                        return true
                    end
                }))
                play_sound('tarot2', 1, 0.4)
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        if not G.hand or not G.hand.highlighted then return false end
        if #G.hand.highlighted ~= 1 then return false end
        local target_card = G.hand.highlighted[1]
        return target_card and target_card:get_id() == 9
    end
}

-- Fishing Rod for 10
SMODS.Consumable {
    key = 'FishingRod10',
    set = 'FishingRodConsumableType',
    atlas = 'Extra',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Fishing Rod',
        text = { 'Do you have any {C:attention}10{}\'s?' }
    },
    use = function(self, card, area, copier)
        if not G.hand or not G.hand.highlighted then return true end
        if #G.hand.highlighted ~= 1 then return true end
        local target_card = G.hand.highlighted[1]
        if not target_card or target_card:get_id() ~= 10 or not target_card.start_dissolve then return true end
        target_card:start_dissolve()
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                if config.moddedjokers == true then
                    SMODS.add_card({ set = 'Joker', rarity = 'AC_Fish' })
                else
                    SMODS.add_card({ set = 'Joker' })
                end
                card:juice_up(0.3, 0.5)
                attention_text({
                    text = "GO FISH",
                    scale = 1.3,
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.WHITE,
                    align = 'cm',
                    offset = { x = 0, y = -2 },
                    silent = true
                })
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.06 * G.SETTINGS.GAMESPEED,
                    blockable = false,
                    blocking = false,
                    func = function()
                        play_sound('tarot2', 0.76, 0.4)
                        return true
                    end
                }))
                play_sound('tarot2', 1, 0.4)
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        if not G.hand or not G.hand.highlighted then return false end
        if #G.hand.highlighted ~= 1 then return false end
        local target_card = G.hand.highlighted[1]
        return target_card and target_card:get_id() == 10
    end
}


-- Fishing Rod for Jack
SMODS.Consumable {
    key = 'FishingRod11',
    set = 'FishingRodConsumableType',
    atlas = 'Extra',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Fishing Rod',
        text = { 'Do you have any {C:attention}Jack{}\'s?' }
    },
    use = function(self, card, area, copier)
        if not G.hand or not G.hand.highlighted then return true end
        if #G.hand.highlighted ~= 1 then return true end
        local target_card = G.hand.highlighted[1]
        if not target_card or target_card:get_id() ~= 11 or not target_card.start_dissolve then return true end
        target_card:start_dissolve()
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                if config.moddedjokers == true then
                    SMODS.add_card({ set = 'Joker', rarity = 'AC_Fish' })
                else
                    SMODS.add_card({ set = 'Joker' })
                end
                card:juice_up(0.3, 0.5)
                attention_text({
                    text = "GO FISH",
                    scale = 1.3,
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.WHITE,
                    align = 'cm',
                    offset = { x = 0, y = -2 },
                    silent = true
                })
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.06 * G.SETTINGS.GAMESPEED,
                    blockable = false,
                    blocking = false,
                    func = function()
                        play_sound('tarot2', 0.76, 0.4)
                        return true
                    end
                }))
                play_sound('tarot2', 1, 0.4)
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        if not G.hand or not G.hand.highlighted then return false end
        if #G.hand.highlighted ~= 1 then return false end
        local target_card = G.hand.highlighted[1]
        return target_card and target_card:get_id() == 11
    end
}


-- Fishing Rod for Queen
SMODS.Consumable {
    key = 'FishingRod12',
    set = 'FishingRodConsumableType',
    atlas = 'Extra',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Fishing Rod',
        text = { 'Do you have any {C:attention}Queen{}\'s?' }
    },
    use = function(self, card, area, copier)
        if not G.hand or not G.hand.highlighted then return true end
        if #G.hand.highlighted ~= 1 then return true end
        local target_card = G.hand.highlighted[1]
        if not target_card or target_card:get_id() ~= 12 or not target_card.start_dissolve then return true end
        target_card:start_dissolve()
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                if config.moddedjokers == true then
                    SMODS.add_card({ set = 'Joker', rarity = 'AC_Fish' })
                else
                    SMODS.add_card({ set = 'Joker' })
                end
                card:juice_up(0.3, 0.5)
                attention_text({
                    text = "GO FISH",
                    scale = 1.3,
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.WHITE,
                    align = 'cm',
                    offset = { x = 0, y = -2 },
                    silent = true
                })
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.06 * G.SETTINGS.GAMESPEED,
                    blockable = false,
                    blocking = false,
                    func = function()
                        play_sound('tarot2', 0.76, 0.4)
                        return true
                    end
                }))
                play_sound('tarot2', 1, 0.4)
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        if not G.hand or not G.hand.highlighted then return false end
        if #G.hand.highlighted ~= 1 then return false end
        local target_card = G.hand.highlighted[1]
        return target_card and target_card:get_id() == 12
    end
}

-- Fishing Rod for King
SMODS.Consumable {
    key = 'FishingRod13',
    set = 'FishingRodConsumableType',
    atlas = 'Extra',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Fishing Rod',
        text = { 'Do you have any {C:attention}King{}\'s?' }
    },
    use = function(self, card, area, copier)
        if not G.hand or not G.hand.highlighted then return true end
        if #G.hand.highlighted ~= 1 then return true end
        local target_card = G.hand.highlighted[1]
        if not target_card or target_card:get_id() ~= 13 or not target_card.start_dissolve then return true end
        target_card:start_dissolve()
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                if config.moddedjokers == true then
                    SMODS.add_card({ set = 'Joker', rarity = 'AC_Fish' })
                else
                    SMODS.add_card({ set = 'Joker' })
                end
                card:juice_up(0.3, 0.5)
                attention_text({
                    text = "GO FISH",
                    scale = 1.3,
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.WHITE,
                    align = 'cm',
                    offset = { x = 0, y = -2 },
                    silent = true
                })
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.06 * G.SETTINGS.GAMESPEED,
                    blockable = false,
                    blocking = false,
                    func = function()
                        play_sound('tarot2', 0.76, 0.4)
                        return true
                    end
                }))
                play_sound('tarot2', 1, 0.4)
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        if not G.hand or not G.hand.highlighted then return false end
        if #G.hand.highlighted ~= 1 then return false end
        local target_card = G.hand.highlighted[1]
        return target_card and target_card:get_id() == 13
    end
}

-- Fishing Rod for Ace
SMODS.Consumable {
    key = 'FishingRod14',
    set = 'FishingRodConsumableType',
    atlas = 'Extra',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = 'Fishing Rod',
        text = { 'Do you have any {C:attention}Ace{}\'s?' }
    },
    use = function(self, card, area, copier)
        if not G.hand or not G.hand.highlighted then return true end
        if #G.hand.highlighted ~= 1 then return true end
        local target_card = G.hand.highlighted[1]
        if not target_card or target_card:get_id() ~= 14 or not target_card.start_dissolve then return true end
        target_card:start_dissolve()
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                if config.moddedjokers == true then
                    SMODS.add_card({ set = 'Joker', rarity = 'AC_Fish' })
                else
                    SMODS.add_card({ set = 'Joker' })
                end
                card:juice_up(0.3, 0.5)
                attention_text({
                    text = "GO FISH",
                    scale = 1.3,
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.WHITE,
                    align = 'cm',
                    offset = { x = 0, y = -2 },
                    silent = true
                })
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.06 * G.SETTINGS.GAMESPEED,
                    blockable = false,
                    blocking = false,
                    func = function()
                        play_sound('tarot2', 0.76, 0.4)
                        return true
                    end
                }))
                play_sound('tarot2', 1, 0.4)
                return true
            end
        }))
        delay(0.6)
    end,
    can_use = function(self, card)
        if not G.hand or not G.hand.highlighted then return false end
        if #G.hand.highlighted ~= 1 then return false end
        local target_card = G.hand.highlighted[1]
        return target_card and target_card:get_id() == 14
    end
}

-- Golden Fishing Rod


SMODS.Consumable {
    key = 'GoldenRod',
    set = 'FishingRodConsumableType',
    atlas = 'Extra',
    pos = { x = 1, y = 0 },
    weight = 0,
    loc_txt = {
        name = 'Golden Rod',
        text = { 'Do you have any {C:attention}Card{}?' }
    },
    use = function(self, card, area, copier)
        if not G.hand or not G.hand.highlighted then return true end
        if #G.hand.highlighted ~= 1 then return true end
        local target_card = G.hand.highlighted[1]
        if not target_card or not target_card.start_dissolve then return true end

        target_card:start_dissolve()

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('timpani')
                if config.moddedjokers == true then
                    SMODS.add_card({ set = 'Joker', rarity = 'AC_Fish' })
                else
                    SMODS.add_card({ set = 'Joker' })
                end
                card:juice_up(0.3, 0.5)
                attention_text({
                    text = "GO FISH",
                    scale = 1.3,
                    hold = 1.4,
                    major = card,
                    backdrop_colour = G.C.WHITE,
                    align = 'cm',
                    offset = { x = 0, y = -2 },
                    silent = true
                })
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.06 * G.SETTINGS.GAMESPEED,
                    blockable = false,
                    blocking = false,
                    func = function()
                        play_sound('tarot2', 0.76, 0.4)
                        return true
                    end
                }))
                play_sound('tarot2', 1, 0.4)
                return true
            end
        }))

        delay(0.6)
    end,

    can_use = function(self, card)
        if not G.hand or not G.hand.highlighted then return false end
        return #G.hand.highlighted == 1
    end
}
-- BoosterPack

-- 🪱 Bait Consumable
local bait_card = SMODS.Consumable {
    key = 'bait',
    set = 'FishingRodConsumableType',
    atlas = 'Extra',
    pos = { x = 0, y = 1 },
    weight = 2, -- hidden from packs until unlocked
    config = { max_highlighted = 1 },

    loc_txt = {
        name = 'Bait',
        text = { 'Decreases the {C:attention}rank{} of a selected card' }
    },

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability and card.ability.max_highlighted or 1 } }
    end,

    use = function(self, card, area, copier)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1', 0.8)
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        for i = 1, #G.hand.highlighted do
            local c = G.hand.highlighted[i]
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    c:flip()
                    c:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end

        delay(0.2)

        for i = 1, #G.hand.highlighted do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    assert(SMODS.modify_rank(G.hand.highlighted[i], -1))
                    return true
                end
            }))
        end

        for i = 1, #G.hand.highlighted do
            local c = G.hand.highlighted[i]
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    c:flip()
                    play_sound('tarot2', 0.85 + i * 0.05, 0.6)
                    c:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))

        delay(0.5)
    end
}


-- Define the ObjectType
local go_fish_rods_obj_type = SMODS.ObjectType {
    object_type = "FishingRodConsumableType", -- must match category
    key = "GO_FISH_RODS",
    default = "FishingRod8",
    cards = {
        ["c_AC_FishingRod2"] = true,
        ["c_AC_FishingRod3"] = true,
        ["c_AC_FishingRod4"] = true,
        ["c_AC_FishingRod5"] = true,
        ["c_AC_FishingRod6"] = true,
        ["c_AC_FishingRod7"] = true,
        ["c_AC_FishingRod8"] = true,
        ["c_AC_FishingRod9"] = true,
        ["c_AC_FishingRod10"] = true,
        ["c_AC_FishingRod11"] = true,
        ["c_AC_FishingRod12"] = true,
        ["c_AC_FishingRod13"] = true,
        ["c_AC_FishingRod14"] = true,
    }
}


local go_bait_obj_type = SMODS.ObjectType {
    object_type = "FishingRodConsumableType", -- must match category
    key = "Bait_Type",
    default = "FishingRod8",
    cards = {
        ["c_AC_Bait"] = true,
    }
}



-- Booster


SMODS.Booster {
    key = "go_fish_pack_1",
    name = "Go Fish Pack",
    group_name = "Go Fish",
    kind = "Go Fish",
    cost = 1,
    atlas = 'Extra',
    config = { extra = 1, choose = 1 },
    weight = 2,
    pos = { x = 3, y = 0 },
    draw_hand = true,
    discovered = true,

    loc_txt = {
        group_name = "Go Fish",
        name = "Go Fish Pack",
        text = {
            "Choose {C:attention}1{} of {C:attention}1{}",
            "{C:attention}Fishing Rods{} to go fishing for a random",
            "{C:blue}Fish Joker{} to add to your deck."
        }
    },

    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.SPECTRAL_PACK)
    end,

    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 1, 1, {
            timer = 0.2,
            scale = 0.7,
            initialize = true,
            lifespan = 2,
            speed = 0.07,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = {
                G.C.BLUE,
                lighten(G.C.WHITE, 0.6),
                lighten(G.C.WHITE, 0.6),
                lighten(G.C.BLUE, 0.6)
            },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,

    create_card = function(self, card, i)
        return {
            set = "GO_FISH_RODS",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = false,
            key_append = "go_fish"
        }
    end
}


SMODS.Booster {
    key = "go_fish_pack_2",
    name = "Go Fish Pack",
    group_name = "Go Fish",
    kind = "Go Fish",
    cost = 3,
    atlas = 'Extra',
    config = { extra = 2, choose = 1 },
    weight = 2,
    pos = { x = 5, y = 0 },
    draw_hand = true,
    discovered = true,

    loc_txt = {
        group_name = "Go Fish",
        name = "Medium Go Fish Pack",
        text = {
            "Choose {C:attention}1{} of {C:attention}2{}",
            "{C:attention}Fishing Rods{} to go fishing for a random",
            "{C:blue}Fish Joker{} to add to your deck."
        }
    },

    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.SPECTRAL_PACK)
    end,

    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 1, 1, {
            timer = 0.2,
            scale = 0.7,
            initialize = true,
            lifespan = 2,
            speed = 0.07,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = {
                G.C.BLUE,
                lighten(G.C.WHITE, 0.6),
                lighten(G.C.WHITE, 0.6),
                lighten(G.C.BLUE, 0.6)
            },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,

    create_card = function(self, card, i)
        return {
            set = "GO_FISH_RODS",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = false,
            key_append = "go_fish"
        }
    end
}




SMODS.Booster {
    key = "go_fish_pack_3",
    name = "Go Fish Pack",
    group_name = "Go Fish",
    kind = "Go Fish",
    cost = 5,
    atlas = 'Extra',
    config = { extra = 3, choose = 1 },
    weight = 2,
    pos = { x = 2, y = 0 },
    draw_hand = true,
    discovered = true,

    loc_txt = {
        group_name = "Go Fish",
        name = "Big Go Fish Pack",
        text = {
            "Choose {C:attention}1{} of {C:attention}3{}",
            "{C:attention}Fishing Rods{} to go fishing for a random",
            "{C:blue}Fish Joker{} to add to your deck."
        }
    },

    ease_background_colour = function(self)
        ease_background_colour_blind(G.STATES.SPECTRAL_PACK)
    end,

    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 1, 1, {
            timer = 0.2,
            scale = 0.7,
            initialize = true,
            lifespan = 2,
            speed = 0.07,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = {
                G.C.BLUE,
                lighten(G.C.WHITE, 0.6),
                lighten(G.C.WHITE, 0.6),
                lighten(G.C.BLUE, 0.6)
            },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,

    create_card = function(self, card, i)
        return {
            set = "GO_FISH_RODS",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = false,
            key_append = "go_fish"
        }
    end
}






--Vouchers



-- Chum
SMODS.Voucher {
    key = "Chum",
    atlas = "Extra",
    pos = { x = 2, y = 1 },

    loc_txt = {
        name = "Chum",
        text = {
            "Opening a {C:attention}Go Fish{} pack",
            "adds a {C:attention}Bait{} consumable"
        }
    },

    calculate = function(self, card, context)
        if context.open_booster
            and context.card
            and context.card.config
            and context.card.config.center
            and context.card.config.center.kind == "Go Fish"
            and #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0,
                func = function()
                    SMODS.add_card({
                        key = "c_AC_bait", -- 🔑 exact key of your bait card
                        area = G.consumeables,
                        key_append = "chum"
                    })
                    G.GAME.consumeable_buffer = 0
                    return true
                end
            }))

            return {
                message = "Bait!",
                colour = G.C.BLUE
            }
        end
    end
}


-- Tackle
SMODS.Voucher {
    key = "Tackle",
    atlas = "Extra",
    pos = { x = 3, y = 1 },

    requires = { "v_Chum" },
    unlocked = false,

    loc_txt = {
        name = "Tackle",
        text = {
            "{C:attention}Go Fish{} booster packs",
            "provides you with a {C:attention}Golden Rod{}"
        }
    },

    locked_loc_vars = function(self, info_queue, card)
        return { vars = { 1, (G.GAME.used_vouchers.v_Chum and 1 or 0) } }
    end,

    check_for_unlock = function(self, args)
        return args.type == "v_used" and args.voucher == "v_Chum"
    end,

    calculate = function(self, card, context)
        if context.open_booster
            and context.card
            and context.card.config
            and context.card.config.center
            and context.card.config.center.kind == "Go Fish" then
            G.E_MANAGER:add_event(Event({
                trigger = "before",
                delay = 0,
                func = function()
                    SMODS.add_card({
                        set = "GO_FISH_RODS",
                        key = "c_AC_GoldenRod",
                        area = G.pack_cards, -- ✅ now it shows up in the booster pack
                        key_append = "tackle"
                    })
                    return true
                end
            }))

            return {
            }
        end
    end
}



SMODS.Back {
    key = "fish_only",
    atlas = "Extra",
    pos = { x = 4, y = 1 },
    unlocked = true,

    loc_txt = {
        name = "Fish Only",
        text = {
            "Only {C:attention}Fish Jokers{} appear",
            "in the {C:attention}shop{}."
        }
    },

    apply = function(self, back)
        -- ❌ Disable base rarities
        G.GAME.common_mod = 0
        G.GAME.uncommon_mod = 0
        G.GAME.rare_mod = 0
        G.GAME.legendary_mod = 0

        -- ✅ Enable AC_Fish rarity (key lowercased becomes `ac_fish`)
        G.GAME.ac_fish_mod = 1
    end
}
