SMODS.Joker{ --Bestie Joker
    key = "rommiejoker2",
    config = {
        extra = {
            xmultvar = 1,
            chips = 10
        }
    },
    loc_txt = {
        ['name'] = 'Bestie Joker',
        ['text'] = {
            [1] = '{C:blue}+10{} Chips',
            [2] = 'for Joker is owned gains {X:red,C:white}X0.5{} Mult{}',
            [3] = '{C:inactive}(Currently {X:red,C:white}X#1#{} {C:inactive}Mult){}{}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 7,
        y = 1
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 6,
    rarity = 3,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.xmultvar}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
                return {
                    Xmult = card.ability.extra.xmultvar,
                    extra = {
                        chips = card.ability.extra.chips,
                        colour = G.C.CHIPS
                        }
                }
        end
        if context.setting_blind  then
            if (function()
      for i = 1, #G.jokers.cards do
          if G.jokers.cards[i].config.center.key == "j_joker" then
              return true
          end
      end
      return false
  end)() then
                return {
                    func = function()
                    card.ability.extra.xmultvar = (card.ability.extra.xmultvar) + 0.5
                    return true
                end
                }
            end
        end
    end
}