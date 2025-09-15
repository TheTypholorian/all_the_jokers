SMODS.ConsumableType {
    key = 'plant_spectral',
    loc_txt = {
        name = 'Root Spectral',
        collection = "Root Spectrals"
    },
    shop_rate = 0.1,
    collection_rows = { 4, 5 },
    primary_colour = HEX('8C6631'),
    secondary_colour = HEX("735121"),
}

SMODS.Consumable {
    key = 'jalapeno',
    set = 'plant_spectral',
    config = { extra = {} },
    loc_txt = {
        name = 'Jalapeno',
        text = {
            'Destroy {C:gold}your entire{} hand'
        }
    },
    atlas = "Spectrals",
    pos = { x = 0, y = 0 },
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge('Idea Credit: thenumberpie', G.C.EF.IDEA_CREDIT, G.C.BLACK, 0.8 )
 	end,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    use = function(self, card, area, copier)
        for i, v in ipairs(G.hand.cards) do
            G.E_MANAGER:add_event(Event({
            trigger = "after", 
            delay = 0.2, 
            func = function() 
                v:start_dissolve()
                return true 
            end
            }))
        end
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.cards > 0
    end
}

SMODS.Consumable {
    key = 'wheel_of_doom',
    set = 'plant_spectral',
    config = { extra = {created = 4} },
    loc_txt = {
        name = 'Wheel of Doom',
        text = {
            'Destroys all cards in',
            'deck, adds {C:gold}#1#{} {C:edition}polychrome{}',
            '{C:enhanced}steel{} red seal jacks'
        }
    },
    atlas = "Spectrals",
    pos = {x = 1, y = 0},
    discovered = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.e_polychrome
        info_queue[#info_queue+1] = G.P_CENTERS.m_steel
        info_queue[#info_queue+1] = G.P_SEALS["Red"]
        return { vars = {card.ability.extra.created} }
    end,
    use = function(self, card, area, copier)
        for i, v in ipairs(G.deck.cards) do
            v:start_dissolve()
        end
        for i, v in ipairs(G.hand.cards) do
            v:start_dissolve()
        end
        local cards = {}
        for i = 1, card.ability.extra.created do
            local card_1 = SMODS.add_card  { set = "Base", edition="e_polychrome", enhancement = "m_steel", seal = "Red", front = "S_J", area = G.deck }
            cards[#cards+1] = card_1
        end
        G.E_MANAGER:add_event(Event({
            func = function()
                for _, v in ipairs(cards) do
                    v:start_materialize()
                    G.GAME.blind:debuff_card(v)
                end
                G.hand:sort()
                return true
            end
        }))
    end,
    can_use = function(self, card)
        return true
    end
}

SMODS.Consumable {
    key = 'slime_mold',
    set = 'plant_spectral',
    config = { extra = { destroy = 2} },
    loc_txt = {
        name = 'Slime Mold',
        text = {
            'Destroy {C:gold}#1#{} random jokers',
            'and create a blueprint'
        }
    },
    atlas = "Spectrals",
    pos = {x=3, y=0},
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge('Idea Credit: plantform', G.C.EF.IDEA_CREDIT, G.C.BLACK, 0.8 )
 	end,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue+1] = G.P_CENTERS.j_blueprint
        return { vars = {card.ability.extra.destroy} }
    end,
    use = function(self, card, area, copier)

        EF.destroy_random_joker() -- src/helper_functions.lua
        EF.destroy_random_joker()
        --create blueprint
        local card_ = SMODS.create_card{ set = "Joker", area = G.jokers, key = "j_blueprint"}
        card_:add_to_deck()
        G.jokers:emplace(card_)
    end,
    can_use = function(self, card)
        return ((G.jokers and #G.jokers.cards) or 0) <= G.jokers.config.card_limit
    end
}

SMODS.Consumable {
    key = 'starfruit',
    set = 'plant_spectral',
    config = { extra = {editions_added = 3} },
    loc_txt = {
        name = 'Starfruit',
        text = {
            'Sets {C:edition}Polychrome{} to {C:gold}#1#{} random',
            'cards in hand, {C:gold}destroy{} all',
            'other cards in hand',
            --'{C:inactive,s:0.7}(Must have at least {C:gold,s:0.7}#2#{C:inactive,s:0.7} cards in hand){}'
        }
    },
    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge('Idea Credit: plantform', G.C.EF.IDEA_CREDIT, G.C.BLACK, 0.8 )
 	end,
    atlas = "Spectrals",
    pos = {x = 2, y = 0},
    discovered = true,
    loc_vars = function(self, info_queue, card)
        return { vars = {card.ability.extra.editions_added, } }
    end,
    use = function(self, card, area, copier)
        local destroyed_cards = {}
        local temp_hand = {}

        for _, playing_card in ipairs(G.hand.cards) do temp_hand[#temp_hand + 1] = playing_card end
        table.sort(temp_hand,
            function(a, b)
                return not a.playing_card or not b.playing_card or a.playing_card < b.playing_card
            end
        )

        pseudoshuffle(temp_hand, pseudoseed("starfruit"))
        
        if G.hand and #G.hand.cards - card.ability.extra.editions_added > 0 then
            for i = 1, (#G.hand.cards - card.ability.extra.editions_added) do destroyed_cards[#destroyed_cards + 1] = temp_hand[i] end
            SMODS.destroy_cards(destroyed_cards)
            
        end
        G.E_MANAGER:add_event(Event({ -- added for timing. without this all cards 
            trigger = "after", 
            delay = 1, 
            func = function() 
                for i, v in ipairs(G.hand.cards) do
                    v:set_edition('e_polychrome', true)
                end
                return true 
            end
            }))
        
    end,
    can_use = function(self, card)
        return G.hand and #G.hand.cards > 0
    end
}

-- SMODS.Consumable {
--     key = '???',
--     set = 'plant_spectral',
--     config = { extra = {} },
--     loc_txt = {
--         name = '???',
--         text = {
--             "adds negative to a random joker, destroys entire hand"
--         }
--     },
--     atlas = "Spectrals",
--     pos = {x = 2, y = 0},
--     discovered = true,
--     loc_vars = function(self, info_queue, card)
--         return { vars = {card.ability.extra.editions_added, } }
--     end,
--     use = function(self, card, area, copier)
        
--     end,
--     can_use = function(self, card)
--         return G.hand and #G.hand.cards > 0
--     end
-- }