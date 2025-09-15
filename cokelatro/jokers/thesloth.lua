SMODS.Joker{ --The Sloth
    key = "thesloth",
    config = {
        extra = {
            Retrigger = 1,
            one = 1,
            repetitions = 1
        }
    },
    loc_txt = {
        ['name'] = 'The Sloth',
        ['text'] = {
            [1] = 'Retrigger {C:green}lucky cards{} when they {C:red}fail{}',
            [2] = '{C:inactive}(temp art){}'
        },
        ['unlock'] = {
            [1] = 'Unlocked by default.'
        }
    },
    pos = {
        x = 0,
        y = 10
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 50,
    rarity = "cokelatr_mythical",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.repetition and context.cardarea == G.play  then
            if (not (context.other_card.lucky_trigger) and SMODS.get_enhancements(context.other_card)["m_lucky"] == true) then
                for i = 1, card.ability.extra.Retrigger do
              return {repetitions = card.ability.extra.repetitions}
                        
          end
            end
        end
        if context.individual and context.cardarea == G.play  then
            if (not (context.other_card.lucky_trigger) and SMODS.get_enhancements(context.other_card)["m_lucky"] == true) then
                card.ability.extra.Retrigger = (card.ability.extra.Retrigger) + 1
            end
        end
        if context.after and context.cardarea == G.jokers  then
                return {
                    func = function()
                    card.ability.extra.Retrigger = 0
                    return true
                end
                }
        end
    end
}