local function reset_keyblade_rank()
    G.GAME.current_round.keyblade_rank = { rank = 'Seven', }
    local valid_keyblade_cards = {}
    for _, playing_card in ipairs(G.playing_cards) do
        if not SMODS.has_no_rank(playing_card) then
            valid_keyblade_cards[#valid_keyblade_cards + 1] = playing_card
        end
    end
    local keyblade_card = pseudorandom_element(valid_keyblade_cards, 'cloudzXIII' .. G.GAME.round_resets.ante)
    if keyblade_card then
        G.GAME.current_round.keyblade_rank.rank = keyblade_card.base.value
        G.GAME.current_round.keyblade_rank.id = keyblade_card.base.id
    end
end

-- Hook into the global reset so Keyblade changes each round
function SMODS.current_mod.reset_game_globals(run_start)
    reset_keyblade_rank()
end

SMODS.Joker {
    name = 'Keyblade',
    key = 'keyblade',

    loc_vars = function(self, info_queue, card)
        local keyblade_card = G.GAME.current_round.keyblade_rank or { rank = 'Seven' }
        return {
            vars = {
                localize(keyblade_card.rank, 'ranks'),
            }
        }
    end,

    rarity = 1,
    atlas = 'KHJokers',
    pos = { x = 1, y = 1 },
    cost = 3,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,

    config = {
        extra = {
            options = {
                [1]  = 'tag_uncommon',
                [2]  = 'tag_rare',
                [3]  = 'tag_negative',
                [4]  = 'tag_foil',
                [5]  = 'tag_holo',
                [6]  = 'tag_polychrome',
                [7]  = 'tag_investment',
                [8]  = 'tag_voucher',
                [9]  = 'tag_boss',
                [10] = 'tag_standard',
                [11] = 'tag_charm',
                [12] = 'tag_meteor',
                [13] = 'tag_buffoon',
                [14] = 'tag_handy',
                [15] = 'tag_garbage',
                [16] = 'tag_ethereal',
                [17] = 'tag_coupon',
                [18] = 'tag_double',
                [19] = 'tag_juggle',
                [20] = 'tag_d_six',
                [21] = 'tag_top_up',
                [22] = 'tag_skip',
                [23] = 'tag_economy',
            }
        }
    },

    calculate = function(self, card, context)
        if context.destroy_card and not context.blueprint then
            local keyblade_card = G.GAME.current_round.keyblade_rank.rank or { rank = 'Seven' }
            if #context.full_hand == 1
                and context.destroy_card == context.full_hand[1]
                and context.full_hand[1].base.value == keyblade_card
                and G.GAME.current_round.hands_played == 0 then
                local tag_choice = pseudorandom_element(card.ability.extra.options, pseudoseed('keyblade'))
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        add_tag(Tag(tag_choice))
                        play_sound('generic1', 0.9 + math.random() * 0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random() * 0.1, 0.4)
                        return true
                    end)
                }))
                return { remove = true }
            end
        end
    end
}
