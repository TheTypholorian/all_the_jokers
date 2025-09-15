SMODS.Joker{ --The envy
    key = "theenvy",
    config = {
        extra = {
            mostplayedhandlevel = 1,
            emult = 2,
            emult2 = 3,
            emult3 = 4,
            emult4 = 5,
            emult5 = 6,
            emult6 = 7,
            emult7 = 8,
            most = 0
        }
    },
    loc_txt = {
        ['name'] = 'The envy',
        ['text'] = {
            [1] = '{C:planet}Solar cards{} give {C:dark_edition}^1{} mult per',
            [2] = '{C:planet}solar card{} in {C:attention}played hand{}',
            [3] = 'levels {C:attention}most played{} hand by',
            [4] = 'it\'s {C:attention}current{} level when {C:clubs}hand{} is {C:attention}played{}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 4,
        y = 8
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 250,
    rarity = "cokelatr_transcendant",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    soul_pos = {
        x = 5,
        y = 8
    },

    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play  then
            if (function()
    local count = 0
    for _, playing_card in pairs(context.scoring_hand or {}) do
        if SMODS.get_enhancements(playing_card)["m_cokelatr_solar"] == true then
            count = count + 1
        end
    end
    return count == 1
end)() then
                return {
                    e_mult = card.ability.extra.emult
                }
            elseif (function()
    local count = 0
    for _, playing_card in pairs(context.scoring_hand or {}) do
        if SMODS.get_enhancements(playing_card)["m_cokelatr_solar"] == true then
            count = count + 1
        end
    end
    return count == 2
end)() then
                return {
                    e_mult = card.ability.extra.emult2
                }
            elseif (function()
    local count = 0
    for _, playing_card in pairs(context.scoring_hand or {}) do
        if SMODS.get_enhancements(playing_card)["m_cokelatr_solar"] == true then
            count = count + 1
        end
    end
    return count == 3
end)() then
                return {
                    e_mult = card.ability.extra.emult3
                }
            elseif (function()
    local count = 0
    for _, playing_card in pairs(context.scoring_hand or {}) do
        if SMODS.get_enhancements(playing_card)["m_cokelatr_solar"] == true then
            count = count + 1
        end
    end
    return count == 4
end)() then
                return {
                    e_mult = card.ability.extra.emult4
                }
            elseif (function()
    local count = 0
    for _, playing_card in pairs(context.scoring_hand or {}) do
        if SMODS.get_enhancements(playing_card)["m_cokelatr_solar"] == true then
            count = count + 1
        end
    end
    return count == 5
end)() then
                return {
                    e_mult = card.ability.extra.emult5
                }
            elseif (function()
    local count = 0
    for _, playing_card in pairs(context.scoring_hand or {}) do
        if SMODS.get_enhancements(playing_card)["m_cokelatr_solar"] == true then
            count = count + 1
        end
    end
    return count == 6
end)() then
                return {
                    e_mult = card.ability.extra.emult6
                }
            elseif (function()
    local count = 0
    for _, playing_card in pairs(context.scoring_hand or {}) do
        if SMODS.get_enhancements(playing_card)["m_cokelatr_solar"] == true then
            count = count + 1
        end
    end
    return count == 7
end)() then
                return {
                    e_mult = card.ability.extra.emult7
                }
            end
        end
        if context.cardarea == G.jokers and context.joker_main  then
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
                return {
                    level_up = card.ability.extra.mostplayedhandlevel + ((function() local most_played = 0; local most_played_hand = ''; for hand, data in pairs(G.GAME.hands) do if data.played > most_played then most_played = data.played; most_played_hand = hand end end; return most_played_hand ~= '' and G.GAME.hands[most_played_hand].level or 0 end)()) * 2,
      level_up_hand = target_hand,
                    message = localize('k_level_up_ex')
                }
        end
    end
}