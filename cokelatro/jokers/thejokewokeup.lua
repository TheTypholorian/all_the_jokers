SMODS.Joker{ --The Joke Woke Up
    key = "thejokewokeup",
    config = {
        extra = {
            RNG = 1,
            levels = 1,
            levels2 = -1,
            most = 0
        }
    },
    loc_txt = {
        ['name'] = 'The Joke Woke Up',
        ['text'] = {
            [1] = '{C:attention}Scored{} {C:planet}solar{} cards either{C:planet} level up{}',
            [2] = 'or {C:planet}level down{} your {C:attention}most played{} hand'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 0,
        y = 9
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 8,
    rarity = 2,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if ((card.ability.extra.RNG or 0) <= 6 and SMODS.get_enhancements(context.other_card)["m_cokelatr_solar"] == true) then
                temp_played = 0
        temp_order = math.huge
        for hand, value in pairs(G.GAME.hands) do 
          if value.played > temp_played and value.visible then
            temp_played = value.played
            temp_order = value.order
            target_hand = hand
          else if value.played == temp_played and value.visible then
            if value.order < temp_order then
              temp_order = value.order
              target_hand = hand
            end
          end
          end
        end
                card.ability.extra.RNG = pseudorandom('RNG_ce17f7b7', 1, 10)
                return {
                    level_up = card.ability.extra.levels,
      level_up_hand = target_hand,
                    message = localize('k_level_up_ex')
                }
            elseif ((card.ability.extra.RNG or 0) > 6 and SMODS.get_enhancements(context.other_card)["m_cokelatr_solar"] == true) then
                temp_played = 0
        temp_order = math.huge
        for hand, value in pairs(G.GAME.hands) do 
          if value.played > temp_played and value.visible then
            temp_played = value.played
            temp_order = value.order
            target_hand2 = hand
          else if value.played == temp_played and value.visible then
            if value.order < temp_order then
              temp_order = value.order
              target_hand2 = hand
            end
          end
          end
        end
                card.ability.extra.RNG = pseudorandom('RNG_14fe54dd', 1, 10)
                return {
                    level_up = card.ability.extra.levels2,
      level_up_hand = target_hand2,
                    message = localize('k_level_up_ex')
                }
            end
        end
    end
}