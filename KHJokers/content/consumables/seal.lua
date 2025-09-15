SMODS.Atlas {
    key = "KHSeals",
    path = "modded_seal.png",
    px = 71,
    py = 95
}

SMODS.Seal {
    name = "luckyemblem",
    key = "luckyemblem",
    discovered = true,
    badge_colour = HEX("fab950"),
    atlas = "KHSeals",
    pos = { x = 0, y = 0 },

    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                self.config.extra.most_common_suit,
                localize(self.config.extra.most_common_suit, 'suits_singular'),
                colours = { G.C.SUITS[self.config.extra.most_common_suit], }
            }
        }
    end,

    config = {
        extra = {
            most_common_suit = 'Hearts'
        }
    },

    loc_txt = {
        label = 'Lucky Emblem',
        name = 'Lucky Emblem',
        text = {
            "Increases rank of card by 1",
            "when {C:attention}discarded{} and converts",
            "it to your {C:attention}most common{}",
            "suit in your {C:attention}full deck{}",
            "{C:inactive}(Currently {V:1}#1#{}{C:inactive}){}"
        }
    },
    update = function(self, card, dt)
        if not G.GAME or not G.playing_cards or #G.playing_cards == 0 then
            return
        end
        local counts = {}
        for suit in pairs(SMODS.Suits) do
            counts[suit] = 0
            for _, card in pairs(G.playing_cards) do
                if card:is_suit(suit) then
                    counts[suit] = counts[suit] + 1
                end
            end
        end

        local max_count = -1
        for suit, count in pairs(counts) do
            if count > max_count then
                max_count = count
                self.config.extra.most_common_suit = suit
            end
        end
    end,
    calculate = function(self, card, context)
        if context.discard and context.other_card == card then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    play_sound('tarot1')
                    card:juice_up(0.3, 0.5)
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    card:flip()
                    play_sound('card1', 1)
                    card:juice_up(0.3, 0.3)
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    assert(SMODS.modify_rank(card, 1))
                    assert(SMODS.change_base(card, self.config.extra.most_common_suit))
                    return true
                end
            }))

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    card:flip()
                    play_sound('tarot2', 1, 0.6)
                    card:juice_up(0.3, 0.3)
                    return true
                end
            }))
            delay(0.5)
        end
    end
}
