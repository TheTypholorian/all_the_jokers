SMODS.Joker{ --Geeked in vs Locked in
    key = "geekedinvslockedin",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Geeked in vs Locked in',
        ['text'] = {
            [1] = '{C:attention}Disable{} Boss Blind',
            [2] = 'if the Boss Blind ability',
            [3] = 'is {C:attention}triggered{}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 0,
        y = 7
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 18,
    rarity = 4,
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if G.GAME.blind.triggered then
                if G.GAME.blind and G.GAME.blind.boss and not G.GAME.blind.disabled then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.GAME.blind:disable()
                        play_sound('timpani')
                        return true
                    end
                }))
                card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = localize('ph_boss_disabled'), colour = G.C.GREEN})
            end
            end
        end
    end
}