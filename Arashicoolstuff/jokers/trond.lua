SMODS.Joker{ --Trond
    key = "trond",
    config = {
        extra = {
            dollars = 5,
            emult = 1.3
        }
    },
    loc_txt = {
        ['name'] = 'Trond',
        ['text'] = {
            [1] = 'Gives {C:gold}$5{} if hand is a',
            [2] = '{C:attention}Three of a kind{},',
            [3] = 'and {X:legendary,C:white}^1.3{} Mult if {C:attention}Freddy fazbear{}',
            [4] = 'is also owned (they\'re a couple)'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 7,
        y = 2
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if context.scoring_name == "Three of a Kind" then
                return {
                    dollars = card.ability.extra.dollars
                }
            elseif (function()
      for i = 1, #G.jokers.cards do
          if G.jokers.cards[i].config.center.key == "j_arashi_freddy" then
              return true
          end
      end
      return false
  end)() then
                return {
                    e_mult = card.ability.extra.emult,
                    message = "Smooch!"
                }
            end
        end
    end
}