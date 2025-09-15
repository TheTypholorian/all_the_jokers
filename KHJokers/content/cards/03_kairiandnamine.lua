SMODS.Joker {
    name = 'Kairi',
    key = 'kairi',

    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = "kh_lightsuit", set = "Other" }
        info_queue[#info_queue + 1] = { key = "kh_darksuit", set = "Other" }

        local vars = {
            card.ability.extra.chips, --1
            card.ability.extra.mult,  --2
            card.ability.extra.dark,  --3
            card.ability.extra.light  --4
        }
        local flip_nodes = {}
        localize { type = 'descriptions', set = 'Joker', key = 'j_kh_kairi_extra', nodes = flip_nodes, vars = vars, scale = 0.8 }

        local side_nodes = {}
        localize { type = 'descriptions', set = 'Joker', key = 'j_kh_kairi_' .. (card.ability.extra.side == 'A' and 'b' or 'a'), nodes = side_nodes, vars = vars, scale = 0.75 }

        local main_end = {
            {
                n = G.UIT.R,
                config = { align = "cm", padding = 0.08 },
                nodes = {
                    {
                        n = G.UIT.R,
                        config = { align = "cm" },
                        nodes = flip_nodes[1]
                    },


                    {
                        n = G.UIT.R,
                        config = { align = "cm" },
                        nodes = flip_nodes[2]
                    },


                    {
                        n = G.UIT.R,
                        config = { align = "cm", padding = 0.08, colour = G.C.UI.BACKGROUND_INACTIVE, r = 0.1 },
                        nodes = {
                            {
                                n = G.UIT.R,
                                config = { align = "cm" },
                                nodes = {
                                    {
                                        n = G.UIT.O,
                                        config = {
                                            object = DynaText({
                                                string = { G.localization.misc.dictionary['kh_' .. (card.ability.extra.side == 'A' and 'b' or 'a') .. '_side'] },
                                                colours = { G.C.WHITE },
                                                scale = 0.32
                                            })
                                        }
                                    },
                                }
                            },


                            {
                                n = G.UIT.R,
                                config = {
                                    align = "cm",
                                    outline_colour = G.C.UI.BACKGROUND_WHITE,
                                    colour = G.C.UI.BACKGROUND_WHITE,
                                    outline = 0.5,
                                    r = 0.1,
                                    padding = 0.1
                                },
                                nodes = {
                                    {
                                        n = G.UIT.R,
                                        config = { align = "cm" },
                                        nodes = side_nodes[1]
                                    },
                                    {
                                        n = G.UIT.R,
                                        config = { align = "cm" },
                                        nodes = side_nodes[2]
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        if card.ability.extra.side == 'A' then
            return {
                key = self.key .. '_a',
                main_end = main_end,
                vars = vars
            }
        else
            return {
                key = self.key .. '_b',
                main_end = main_end,
                vars = vars
            }
        end
    end,

    rarity = 2,
    atlas = 'KHJokers',
    pos = { x = 2, y = 0 },
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            side = 'A',
            repetitions = 1,
            chips = 0,
            mult = 0,
            dark = 1,
            light = 1
        }
    },

    update = function(self, card)
        if card.VT.w <= 0 then
            if card.ability.extra.side == 'A' then
                card.children.center:set_sprite_pos({ x = 2, y = 0 })
            else
                card.children.center:set_sprite_pos({ x = 3, y = 2 })
            end
        end
    end,

    set_sprites = function(self, card, front)
        if self.discovered or card.bypass_discovery_center then
            if card.ability and card.ability.extra and card.ability.extra.side then
                if card.ability.extra.side == 'A' then
                    card.children.center:set_sprite_pos({ x = 2, y = 0 })
                else
                    card.children.center:set_sprite_pos({ x = 3, y = 2 })
                end
            end
        end
    end,

    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition and not context.blueprint then
            card:flip()
        end

        if context.flip and not context.blueprint then
            card_eval_status_text(card, 'extra', nil, nil, nil, {
                message = G.localization.misc.dictionary
                    ['kh_' .. (card.ability.extra.side == 'A' and 'b' or 'a') .. '_side'],
                colour = G.C.RED,
                instant = true
            })

            if card.ability.extra.side == 'A' then
                card.ability.extra.side = 'B'
            else
                card.ability.extra.side = 'A'
            end
        end

        if context.individual and context.cardarea == G.play and not context.blueprint then
            local side = card.ability.extra.side

            if context.other_card:is_suit('Hearts') or context.other_card:is_suit('Diamonds') then
                if side == 'A' then -- KAIRI
                    -- Gain Chips
                    card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.dark
                    return {
                        message = 'Upgraded!',
                        colour = G.C.CHIPS,
                        card = card
                    }
                end

                if side == 'B' and card.ability.extra.mult > 0 then -- NAMINE
                    -- Lose Mult
                    card.ability.extra.mult = card.ability.extra.mult - card.ability.extra.light

                    return {
                        message = 'Nope!',
                        colour = G.C.MONEY,
                        card = card,
                    }
                end
            end

            if context.other_card:is_suit('Spades') or context.other_card:is_suit('Clubs') then
                if side == 'A' and card.ability.extra.chips > 0 then -- KAIRI
                    --Lose Chips
                    card.ability.extra.chips = card.ability.extra.chips - card.ability.extra.light

                    return {
                        message = 'Nope!',
                        colour = G.C.MONEY,
                        card = card,
                    }
                end

                if side == 'B' then -- NAMINE
                    -- Gain Mult
                    card.ability.extra.mult = card.ability.extra.mult + card.ability.extra.dark
                    return {
                        message = 'Upgraded!',
                        colour = G.C.MULT,
                        card = card
                    }
                end
            end
        end
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                mult = card.ability.extra.mult,
                card = card
            }
        end
    end,
}
