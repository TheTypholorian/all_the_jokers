SMODS.Joker{ --Big Poe
    key = "bigpoe",
    config = {
        extra = {
            Xmult = 2,
            mult = 21
        }
    },
    loc_txt = {
        ['name'] = 'Big Poe',
        ['text'] = {
            [1] = '{C:red}+21{} Mult',
            [2] = '{X:red,C:white}X2{} Mult if you have any Tyler, The Joker'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 8,
        y = 1
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
    pools = { ["shit_tyler"] = true },

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if ((function()
      for i = 1, #G.jokers.cards do
          if G.jokers.cards[i].config.center.key == "j_shit_tylerthejoker" then
              return true
          end
      end
      return false
  end)() or (function()
      for i = 1, #G.jokers.cards do
          if G.jokers.cards[i].config.center.key == "j_shit_churbum" then
              return true
          end
      end
      return false
  end)() or (function()
      for i = 1, #G.jokers.cards do
          if G.jokers.cards[i].config.center.key == "j_shit_igor" then
              return true
          end
      end
      return false
  end)() or (function()
      for i = 1, #G.jokers.cards do
          if G.jokers.cards[i].config.center.key == "j_shit_flowerboy" then
              return true
          end
      end
      return false
  end)() or (function()
      for i = 1, #G.jokers.cards do
          if G.jokers.cards[i].config.center.key == "j_shit_wolfhaley" then
              return true
          end
      end
      return false
  end)() or (function()
      for i = 1, #G.jokers.cards do
          if G.jokers.cards[i].config.center.key == "j_shit_sirtylerbaudelaire" then
              return true
          end
      end
      return false
  end)() or (function()
      for i = 1, #G.jokers.cards do
          if G.jokers.cards[i].config.center.key == "j_shit_acetyler" then
              return true
          end
      end
      return false
  end)() or (function()
      for i = 1, #G.jokers.cards do
          if G.jokers.cards[i].config.center.key == "j_shit_stchroma" then
              return true
          end
      end
      return false
  end)() or (function()
      for i = 1, #G.jokers.cards do
          if G.jokers.cards[i].config.center.key == "j_shit_doctortc" then
              return true
          end
      end
      return false
  end)() or (function()
      for i = 1, #G.jokers.cards do
          if G.jokers.cards[i].config.center.key == "j_shit_troncat" then
              return true
          end
      end
      return false
  end)() or (function()
      for i = 1, #G.jokers.cards do
          if G.jokers.cards[i].config.center.key == "j_shit_samisdead" then
              return true
          end
      end
      return false
  end)()) then
                return {
                    Xmult = card.ability.extra.Xmult,
                    message = "DONT TAP THE GLASS"
                }
            else
                return {
                    mult = card.ability.extra.mult
                }
            end
        end
    end
}