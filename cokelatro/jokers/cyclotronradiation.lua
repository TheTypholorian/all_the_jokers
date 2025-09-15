SMODS.Joker{ --Cyclotron Radiation
    key = "cyclotronradiation",
    config = {
        extra = {
            levels = 1,
            levels2 = 2,
            levels3 = 3,
            levels4 = 4,
            levels5 = 5
        }
    },
    loc_txt = {
        ['name'] = 'Cyclotron Radiation',
        ['text'] = {
            [1] = '{C:attention}Scored{} {C:planet}solar{} cards {C:planet}level up{} a {C:attention}random{} hand',
            [2] = '{C:attention}1{} time {C:attention}per scored{} {C:planet}solar{} card',
            [3] = '{C:inactive,s:0.8}(ex: 1 card, 1 level per card, 2 cards, 2 per card){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 1,
        y = 2
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = "cokelatr_incredulous",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if (SMODS.get_enhancements(context.other_card)["m_cokelatr_solar"] == true and (function()
    local count = 0
    for _, playing_card in pairs(context.scoring_hand or {}) do
        if SMODS.get_enhancements(playing_card)["m_cokelatr_solar"] == true then
            count = count + 1
        end
    end
    return count == 1
end)()) then
                available_hands = {}
        for hand, value in pairs(G.GAME.hands) do
          if value.visible and value.level >= to_big(1) then
            table.insert(available_hands, hand)
          end
        end
        target_hand = #available_hands > 0 and pseudorandom_element(available_hands, pseudoseed('level_up_hand')) or "High Card"
                return {
                    level_up = card.ability.extra.levels,
      level_up_hand = target_hand,
                    message = localize('k_level_up_ex')
                }
            elseif (SMODS.get_enhancements(context.other_card)["m_cokelatr_solar"] == true and (function()
    local count = 0
    for _, playing_card in pairs(context.scoring_hand or {}) do
        if SMODS.get_enhancements(playing_card)["m_cokelatr_solar"] == true then
            count = count + 1
        end
    end
    return count == 2
end)()) then
                available_hands = {}
        for hand, value in pairs(G.GAME.hands) do
          if value.visible and value.level >= to_big(1) then
            table.insert(available_hands, hand)
          end
        end
        target_hand2 = #available_hands > 0 and pseudorandom_element(available_hands, pseudoseed('level_up_hand')) or "High Card"
                return {
                    level_up = card.ability.extra.levels2,
      level_up_hand = target_hand2,
                    message = localize('k_level_up_ex')
                }
            elseif (SMODS.get_enhancements(context.other_card)["m_cokelatr_solar"] == true and (function()
    local count = 0
    for _, playing_card in pairs(context.scoring_hand or {}) do
        if SMODS.get_enhancements(playing_card)["m_cokelatr_solar"] == true then
            count = count + 1
        end
    end
    return count == 3
end)()) then
                available_hands = {}
        for hand, value in pairs(G.GAME.hands) do
          if value.visible and value.level >= to_big(1) then
            table.insert(available_hands, hand)
          end
        end
        target_hand3 = #available_hands > 0 and pseudorandom_element(available_hands, pseudoseed('level_up_hand')) or "High Card"
                return {
                    level_up = card.ability.extra.levels3,
      level_up_hand = target_hand3,
                    message = localize('k_level_up_ex')
                }
            elseif (SMODS.get_enhancements(context.other_card)["m_cokelatr_solar"] == true and (function()
    local count = 0
    for _, playing_card in pairs(context.scoring_hand or {}) do
        if SMODS.get_enhancements(playing_card)["m_cokelatr_solar"] == true then
            count = count + 1
        end
    end
    return count == 4
end)()) then
                available_hands = {}
        for hand, value in pairs(G.GAME.hands) do
          if value.visible and value.level >= to_big(1) then
            table.insert(available_hands, hand)
          end
        end
        target_hand4 = #available_hands > 0 and pseudorandom_element(available_hands, pseudoseed('level_up_hand')) or "High Card"
                return {
                    level_up = card.ability.extra.levels4,
      level_up_hand = target_hand4,
                    message = localize('k_level_up_ex')
                }
            elseif (SMODS.get_enhancements(context.other_card)["m_cokelatr_solar"] == true and (function()
    local count = 0
    for _, playing_card in pairs(context.scoring_hand or {}) do
        if SMODS.get_enhancements(playing_card)["m_cokelatr_solar"] == true then
            count = count + 1
        end
    end
    return count == 5
end)()) then
                available_hands = {}
        for hand, value in pairs(G.GAME.hands) do
          if value.visible and value.level >= to_big(1) then
            table.insert(available_hands, hand)
          end
        end
        target_hand5 = #available_hands > 0 and pseudorandom_element(available_hands, pseudoseed('level_up_hand')) or "High Card"
                return {
                    level_up = card.ability.extra.levels5,
      level_up_hand = target_hand5,
                    message = localize('k_level_up_ex')
                }
            end
        end
    end
}