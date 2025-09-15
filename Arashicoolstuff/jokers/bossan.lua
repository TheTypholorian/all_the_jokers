SMODS.Joker{ --Bossan
    key = "bossan",
    config = {
        extra = {
            currenthandsize = 0
        }
    },
    loc_txt = {
        ['name'] = 'Bossan',
        ['text'] = {
            [1] = 'Changes your {C:attention}Joker{} slots',
            [2] = 'to your {C:attention}hand size{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 2,
        y = 0
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
    pools = { ["arashi_pet"] = true },
    soul_pos = {
        x = 3,
        y = 0
    },
    in_pool = function(self, args)
          return (
          not args 
          or args.source ~= 'sho' 
          or args.source == 'buf' or args.source == 'jud' or args.source == 'rif' or args.source == 'rta' or args.source == 'sou' or args.source == 'uta' or args.source == 'wra'
          )
          and true
      end,

    calculate = function(self, card, context)
    end,

    add_to_deck = function(self, card, from_debuff)
        card.ability.extra.original_joker_slots = G.jokers.config.card_limit
        G.jokers.config.card_limit = (G.hand and G.hand.config.card_limit or 0)
    end,

    remove_from_deck = function(self, card, from_debuff)
        if card.ability.extra.original_joker_slots then
            G.jokers.config.card_limit = card.ability.extra.original_joker_slots
        end
    end
}