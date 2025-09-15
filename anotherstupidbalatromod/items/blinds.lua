SMODS.Blind{
    key = 'the_shield',
    loc_txt = {
        name = 'The Shield',
        text = {
            "All Aces are debuffed"
        }
    },
    atlas = 'death',
    pos = { x = 0, y = 1 },
    dollars = 8,
    mult = 2,
    boss = { min = 3, max = 10 }, 
    boss_colour = HEX('8B4513'), 
    
    recalc_debuff = function(self, card, from_blind)
        local is_base_ace = card.base and card.base.value == 'Ace'
        
        local is_modified_ace = card:get_id() == 14
        
        return is_base_ace or is_modified_ace
    end,
    
    in_pool = function(self)
        return G.GAME.round_resets.ante >= 3
    end
}

SMODS.Blind{
    key = 'afforestation',
    loc_txt = {
        name = 'Afforestation',
        text = {
            "Face cards held in hand have",
            "a 1 in 3 chance to be destroyed",
            "when a hand is played"
        }
    },
    atlas = 'death',
    pos = { x = 0, y = 3 },
    dollars = 12,
    mult = 2.2,
    boss = { min = 5, max = 10 },
    boss_colour = HEX('8B0000'), 
    press_play = function(self)
        if G.hand and G.hand.cards then
            local cards_to_destroy = {}
            
            for i = 1, #G.hand.cards do
                local card = G.hand.cards[i]
                if card and card.base and card.base.value then
                    local rank = card.base.value
                    if rank == 'Jack' or rank == 'Queen' or rank == 'King' then
                        local destroy_chance = pseudorandom('afforestation', 1, 3)
                        if destroy_chance == 1 then
                            table.insert(cards_to_destroy, card)
                        end
                    end
                end
            end
            
            for _, card in ipairs(cards_to_destroy) do
                if card and not card.destroyed then
                    card.destroyed = true
                    G.hand:remove_card(card)
                    card:remove()
                    
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.1,
                        func = function()
                            return true
                        end
                    }))
                end
            end
            
            if #cards_to_destroy > 0 and G.hand.align_cards then
                G.hand:align_cards()
            end
        end
    end,
    
    in_pool = function(self)
        return G.GAME.round_resets.ante >= 5
    end
}

SMODS.Blind{
    key = 'the_perfectionist',
    loc_txt = {
        name = 'The Perfectionist',
        text = {
            "You can only play the exact",
            "number of cards required for the hand",
            "(e.g., 2 cards for a Pair)"
        }
    },
    atlas = 'death',
    pos = { x = 0, y = 0 },
    dollars = 12,
    mult = 2.8,
    boss = { min = 1, max = 10 },
    boss_colour = HEX('8A2BE2'),
    
    debuff_hand = function(self, cards, hand, handname, check)
        if not cards or not handname then return false end
        
        local required_cards = 5
        
        if handname == "High Card" then 
            required_cards = 1
        elseif handname == "Pair" then 
            required_cards = 2
        elseif handname == "Two Pair" then 
            required_cards = 4
        elseif handname == "Three of a Kind" then 
            required_cards = 3
        elseif handname == "Four of a Kind" then 
            required_cards = 4
        else
            required_cards = 5
        end
        
        return #cards ~= required_cards
    end,
    
    in_pool = function(self)
        return G.GAME.round_resets.ante >= 4
    end
}

SMODS.Blind{
    key = 'huevo_eterno',
    loc_txt = {
        name = 'HUEVITOS',
        text = {
            "Each hand played creates",
            "an eternal Egg joker"
        }
    },
    atlas = 'death',
    pos = { x = 0, y = 4 },
    dollars = 10,
    mult = 2.5,
    boss_colour = HEX('2A8B53'),
    boss = { min = 8, max = 10 },

    
    press_play = function(self)
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                local egg_joker = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_egg', nil)
                
                egg_joker.ability.eternal = true
                
                egg_joker:add_to_deck()
                G.jokers:emplace(egg_joker)
                egg_joker:start_materialize()
                
                return true
            end
        }))
    end,
    
    in_pool = function(self)
        return G.GAME.round_resets.ante >= 4
    end,
    
    collection_loc_vars = function(self)
        return {
            vars = {
                self.mult,
                self.dollars
            }
        }
    end
}

SMODS.Blind{
    key = 'death',
    loc_txt = {
        name = 'Death',
        text = {
            "All cards are flipped face down",
            "Only 1 hand and 2 discards",
            "lol"
        }
    },
    atlas = 'death',
    pos = { x = 0, y = 2 },
    dollars = 15,
    mult = 3,
    boss = { 
        min = 1, 
        max = 10,
        showdown = true 
    },
    boss_colour = HEX('2C1810'), 
    
    set_blind = function(self, blind, reset, silent)
        self.death_original_hands = G.GAME.current_round.hands_left
        self.death_original_discards = G.GAME.current_round.discards_left
        self.death_flipped_jokers = {}
        self.death_flipped_hand_cards = {}
        self.death_flipped_deck_cards = {}
        
        G.GAME.current_round.hands_left = 1
        G.GAME.current_round.discards_left = 2
        
        if G.jokers and G.jokers.cards then
            for i = 1, #G.jokers.cards do
                local joker = G.jokers.cards[i]
                if joker and joker.facing == 'front' then
                    self.death_flipped_jokers[joker] = true
                    joker.facing = 'back'
                    if joker.children and joker.children.center then
                        joker.children.center.facing = 'back'
                    end
                    if joker.flip then
                        joker:flip()
                    end
                end
            end
        end
        
        if G.hand and G.hand.cards then
            for i = 1, #G.hand.cards do
                local card = G.hand.cards[i]
                if card and card.facing == 'front' then
                    self.death_flipped_hand_cards[card] = true
                    card.facing = 'back'
                    if card.children and card.children.center then
                        card.children.center.facing = 'back'
                    end
                    if card.flip then
                        card:flip()
                    end
                end
            end
        end
        
        if G.deck and G.deck.cards then
            for i = 1, #G.deck.cards do
                local card = G.deck.cards[i]
                if card and card.facing == 'front' then
                    self.death_flipped_deck_cards[card] = true
                    card.facing = 'back'
                    if card.children and card.children.center then
                        card.children.center.facing = 'back'
                    end
                    if card.flip then
                        card:flip()
                    end
                end
            end
        end
        
        if G.discard and G.discard.cards then
            for i = 1, #G.discard.cards do
                local card = G.discard.cards[i]
                if card and card.facing == 'front' then
                    self.death_flipped_deck_cards[card] = true
                    card.facing = 'back'
                    if card.children and card.children.center then
                        card.children.center.facing = 'back'
                    end
                    if card.flip then
                        card:flip()
                    end
                end
            end
        end
        
        if G.jokers and G.jokers.cards and #G.jokers.cards > 1 then
            local joker_refs = {}
            for i = 1, #G.jokers.cards do
                table.insert(joker_refs, G.jokers.cards[i])
            end
            
            for i = #joker_refs, 2, -1 do
                local j = pseudorandom('death_shuffle', 1, i)
                if j and j >= 1 and j <= #joker_refs then
                    joker_refs[i], joker_refs[j] = joker_refs[j], joker_refs[i]
                end
            end
            
            for i = 1, #joker_refs do
                G.jokers.cards[i] = joker_refs[i]
            end
            
            if G.jokers.align_cards then
                G.jokers:align_cards()
            end
        end
        
    end,
    
    disable = function(self)
        if self.death_flipped_jokers then
            for joker, _ in pairs(self.death_flipped_jokers) do
                if joker and joker.facing == 'back' then
                    joker.facing = 'front'
                    if joker.children and joker.children.center then
                        joker.children.center.facing = 'front'
                    end
                    if joker.flip then
                        joker:flip()
                    end
                end
            end
        end
        
        if self.death_flipped_hand_cards then
            for card, _ in pairs(self.death_flipped_hand_cards) do
                if card and card.facing == 'back' then
                    card.facing = 'front'
                    if card.children and card.children.center then
                        card.children.center.facing = 'front'
                    end
                    if card.flip then
                        card:flip()
                    end
                end
            end
        end
        
        if self.death_flipped_deck_cards then
            for card, _ in pairs(self.death_flipped_deck_cards) do
                if card and card.facing == 'back' then
                    card.facing = 'front'
                    if card.children and card.children.center then
                        card.children.center.facing = 'front'
                    end
                    if card.flip then
                        card:flip()
                    end
                end
            end
        end
        
        if self.death_original_hands then
            G.GAME.current_round.hands_left = self.death_original_hands
        end
        if self.death_original_discards then
            G.GAME.current_round.discards_left = self.death_original_discards
        end
        
        self.death_flipped_jokers = nil
        self.death_flipped_hand_cards = nil
        self.death_flipped_deck_cards = nil
        self.death_original_hands = nil
        self.death_original_discards = nil
    end,
    
    defeat = function(self)
        self:disable()
    end,
    
    stay_flipped = function(self, area, card)
        return true
    end,
    
    drawn_to_hand = function(self)
        if G.hand and G.hand.cards then
            for i = 1, #G.hand.cards do
                local card = G.hand.cards[i]
                if card and card.facing == 'front' and not self.death_flipped_hand_cards[card] then
                    self.death_flipped_hand_cards[card] = true
                    card.facing = 'back'
                    if card.children and card.children.center then
                        card.children.center.facing = 'back'
                    end
                    if card.flip then
                        card:flip()
                    end
                end
            end
        end
    end,
    
    in_pool = function(self)
        return G.GAME.round_resets.ante >= 8
    end,
    
    collection_loc_vars = function(self)
        return {
            vars = {
                self.mult,
                self.dollars
            }
        }
    end
}
