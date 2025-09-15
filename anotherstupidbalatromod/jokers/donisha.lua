SMODS.Joker{ --Donisha
    key = "donisha",
    config = {
        extra = {
            dollars = 10,
            levels = 1
        }
    },
    loc_txt = {
        ['name'] = 'Donisha',
        ['text'] = {
            [1] = 'If you {C:red}discard{} a card containing #1#, add {C:money}+$10{} and level up to any poker hand',
            [2] = '{C:inactive}(the suit changes every round){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 4,
        y = 5
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 20,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    soul_pos = {
        x = 5,
        y = 5
    },
    in_pool = function(self, args)
          return (
          not args 
          or args.source ~= 'sho' and args.source ~= 'buf' and args.source ~= 'jud' 
          or args.source == 'rif' or args.source == 'rta' or args.source == 'sou' or args.source == 'uta' or args.source == 'wra'
          )
          and true
      end,

    loc_vars = function(self, info_queue, card)
        return {vars = {localize((G.GAME.current_round.ffd_card or {}).suit or 'Spades', 'suits_singular')}, colours = {G.C.SUITS[(G.GAME.current_round.ffd_card or {}).suit or 'Spades']}}
    end,

    set_ability = function(self, card, initial)
        G.GAME.current_round.ffd_card = { suit = 'Spades' }
    end,

    calculate = function(self, card, context)
        if context.end_of_round and context.game_over == false and context.main_eval  then
                if G.playing_cards then
                    local valid_ffd_cards = {}
                    for _, v in ipairs(G.playing_cards) do
                        if not SMODS.has_no_suit(v) then
                            valid_ffd_cards[#valid_ffd_cards + 1] = v
                        end
                    end
                    if valid_ffd_cards[1] then
                        local ffd_card = pseudorandom_element(valid_ffd_cards, pseudoseed('ffd' .. G.GAME.round_resets.ante))
                        G.GAME.current_round.ffd_card.suit = ffd_card.base.suit
                    end
                end
        end
        if context.discard  then
            if context.other_card:is_suit(G.GAME.current_round.ffd_card.suit) then
                available_hands = {}
        for hand, value in pairs(G.GAME.hands) do
          if value.visible and value.level >= to_big(1) then
            table.insert(available_hands, hand)
          end
        end
        target_hand = #available_hands > 0 and pseudorandom_element(available_hands, pseudoseed('level_up_hand')) or "High Card"
                return {
                    dollars = card.ability.extra.dollars,
                    extra = {
                        level_up = card.ability.extra.levels,
      level_up_hand = target_hand,
                            message = localize('k_level_up_ex'),
                        colour = G.C.RED
                        }
                }
            end
        end
    end
}