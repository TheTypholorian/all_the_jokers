SMODS.Consumable {
    key = "sorcerer",
    set = "Spectral",
    discovered = true,
    config = {
        max_highlighted = 1,
        extra = 'kh_luckyemblem',
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_SEALS[(card.ability or self.config).extra]
        return { vars = { (card.ability or self.config).max_highlighted } }
    end,

    atlas = "consumabels",
    pos = { x = 1, y = 0 },
    cost = 4,

    use = function(self, card, area, copier)
        for i = 1, math.min(#G.hand.highlighted, card.ability.max_highlighted) do
            G.E_MANAGER:add_event(Event({
                func = function()
                    play_sound('tarot1')
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    G.hand.highlighted[i]:set_seal(card.ability.extra, nil, true)
                    return true
                end
            }))

            delay(0.5)
        end
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all(); return true
            end
        }))
    end
}


SMODS.Consumable {
    key = 'gummiship',
    discovered = true,
    set = 'Spectral',
    atlas = "consumabels",
    pos = { x = 2, y = 0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { 1 } }
    end,

    use = function(self, card, area, copier)
        local destructable_jokers = {}
        for i = 1, #G.jokers.cards do
            if not G.jokers.cards[i].ability.eternal and not G.jokers.cards[i].getting_sliced then
                table.insert(destructable_jokers, G.jokers.cards[i])
            end
        end

        local joker_to_destroy = pseudorandom_element(destructable_jokers, pseudoseed('gummiship'))

        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                card:juice_up(0.3, 0.5)
                return true
            end
        }))

        if joker_to_destroy then
            joker_to_destroy.getting_sliced = true
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    joker_to_destroy:start_dissolve({ G.C.RED }, nil, 1.6)
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 1.0,
                func = function()
                    G.hand:change_size(1)
                    return true
                end
            }))
        end

        delay(0.5)
    end,
    can_use = function(self, card)
        for _, joker in ipairs(G.jokers.cards) do
            if not joker.ability.eternal and not joker.getting_sliced then return true end
        end
        return false
    end
}
--[[
function Card:set_rank(new_rank)
    local suit_prefix = string.sub(self.base.suit, 1, 1)..'_'

    -- Convert rank to number if it's a valid number string
    local rank_suffix = tonumber(new_rank) or new_rank

    -- Handle rank conversion manually for valid numbers (only if it's a number)
    if type(rank_suffix) == "number" then
        if rank_suffix == 10 then
            rank_suffix = 'T'
        elseif rank_suffix == 11 then
            rank_suffix = 'J'
        elseif rank_suffix == 12 then
            rank_suffix = 'Q'
        elseif rank_suffix == 13 then
            rank_suffix = 'K'
        elseif rank_suffix == 14 then
            rank_suffix = 'A'
        elseif rank_suffix < 10 then
            rank_suffix = tostring(rank_suffix)
        end
    end

    -- Set the base with the correct rank
    self:set_base(G.P_CARDS[suit_prefix..rank_suffix])
end

SMODS.Consumable {
    key = 'gummi',
    set = 'Spectral',
    pos = { x = 2, y = 0 },
    cost = 4,
    discovered = true,
    atlas = "consumabels",
    config = { extra = { dollars = 10 } },

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.dollars}}
    end,

    use = function(self, card, area, copier)
        local used_tarot = copier or card

        -- Juice the consumable card
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.4,
            func = function()
                play_sound('tarot1')
                used_tarot:juice_up(0.3, 0.5)
                return true
            end
        }))

        -- Flip + juice all cards in hand (forward animation)
        for i = 1, #G.hand.cards do
            local percent = 1.15 - (i - 0.999) / (#G.hand.cards - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    local _card = G.hand.cards[i]
                    _card:flip()
                    play_sound('card1', percent)
                    _card:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end

        -- Apply random ranks to each card
        local ranks = {"2", "3", "4", "5", "6", "7", "8", "9", "10", "J", "Q", "K", "A"}
        for i = 1, #G.hand.cards do
            G.E_MANAGER:add_event(Event({
                func = function()
                    local _card = G.hand.cards[i]
                    local random_rank = pseudorandom_element(ranks, pseudoseed("rando"))
                    _card:set_rank(random_rank)
                    return true
                end
            }))
        end

        -- Flip + juice again (back animation)
        G.hand:change_size(-1)
        for i = 1, #G.hand.cards do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    local _card = G.hand.cards[i]
                    _card:flip()
                    play_sound('tarot2', 1, 0.6)
                    _card:juice_up(0.3, 0.3)
                    return true
                end
            }))
        end
        delay(0.5)

        -- money gain
        ease_dollars(card.ability.extra.dollars)
        delay(0.3)
    end,

    can_use = function(self, card)
        return G.hand and #G.hand.cards > 0
    end,
}
--]]
