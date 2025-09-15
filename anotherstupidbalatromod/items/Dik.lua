SMODS.Back({
    key = "shitmod_deck",
    loc_txt = {
        name = "Shitmod",
        text = {
            "Empiezas con un",
            "{C:attention}Shicot{}"
        }
    },
    atlas = "CustomBacks",
    pos = { x = 0, y = 0 },
    config = {},
    unlocked = true,
    discovered = true,
    
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                local shicot = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_shit_zzz', 'shitmod')
                shicot:add_to_deck()
                G.jokers:emplace(shicot)
                return true
            end,
            delay = 1
        }))
    end
})

SMODS.Back({
    key = "im_hungry_deck",
    loc_txt = {
        name = "Im hungry",
        text = {
            "Start with an",
            "{C:dark_edition}Eternal{} {C:attention}Fatass Misprint{}"
        }
    },
    atlas = "CustomBacks",
    pos = { x = 1, y = 0 },
    config = {},
    unlocked = true,
    discovered = true,
    
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                local fatass_misprint = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_shit_fatassmisprint', 'hungry')
                fatass_misprint:set_eternal(true)
                fatass_misprint:add_to_deck()
                G.jokers:emplace(fatass_misprint)
                return true
            end,
            delay = 1
        }))
    end
})

SMODS.Back({
    key = "perkegod_deck",
    loc_txt = {
        name = "Pueden tus ideas cambiar el mundo?",
        text = {
            "{C:attention}6{} Joker Slots,",
            "1 {C:attention}Perkegod{} and",
            "{C:attention}4{} {C:dark_edition}Eternal Jokers{}"
        }
    },
    atlas = "CustomBacks",
    pos = { x = 2, y = 0 }, 
    config = {
        joker_slot = 6 
    },
    unlocked = true,
    discovered = true,
    
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                if G.jokers then
                    G.jokers.config.card_limit = 6
                end
                
                local perkegod = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_shit_perkegod', 'perkegod_deck')
                perkegod:add_to_deck()
                G.jokers:emplace(perkegod)
                
                for i = 1, 4 do
                    local eternal_joker = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_joker', 'perkegod_deck')
                    eternal_joker:set_eternal(true)
                    eternal_joker:add_to_deck()
                    G.jokers:emplace(eternal_joker)
                end
                
                return true
            end,
            delay = 1
        }))
    end
})

SMODS.Back({
    key = "minimalist_deck",
    loc_txt = {
        name = "Minimalist Deck",
        text = {
            "Only {C:attention}20 cards{} in your deck",
            "Every card give {C:mult}+2 Mult{} per base",
            "{C:money}+$15{} extra"
        }
    },
    atlas = "CustomBacks",
    pos = { x = 3, y = 0 },
    config = {
        dollars = 15
    },
    unlocked = true,
    discovered = true,
    
    apply = function(self, back)
        G.E_MANAGER:add_event(Event({
            func = function()
                ease_dollars(15)
                
                for i = #G.playing_cards, 1, -1 do
                    local card = G.playing_cards[i]
                    if card then
                        card:remove()
                        table.remove(G.playing_cards, i)
                    end
                end
                
                if G.deck and G.deck.cards then
                    for i = #G.deck.cards, 1, -1 do
                        G.deck.cards[i] = nil
                    end
                end
                
                local suits = {'H', 'D', 'C', 'S'}
                local high_ranks = {'T','J','Q','K','A'}
                
                for _, suit in pairs(suits) do
                    for _, rank in pairs(high_ranks) do
                        local card_key = suit..'_'..rank
                        local card = Card(G.deck.T.x, G.deck.T.y, G.CARD_W, G.CARD_H, 
                            G.P_CARDS[card_key], G.P_CENTERS.c_base)
                        card:add_to_deck()
                        table.insert(G.playing_cards, card)
                        G.deck:emplace(card)
                    end
                end
                
                G.GAME.minimalist_deck_active = true
                
                if G.deck and G.deck.cards then
                    G.deck:shuffle('minimalist_start')
                end
                
                return true
            end,
            delay = 1
        }))
    end
})

local original_get_chip_mult = Card.get_chip_mult
function Card:get_chip_mult()
    local mult, chips = original_get_chip_mult(self)
    
    if G.GAME and G.GAME.minimalist_deck_active and not self.debuff then
        mult = mult + 2
    end
    
    return mult, chips
end