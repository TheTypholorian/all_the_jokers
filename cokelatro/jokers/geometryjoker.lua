SMODS.Joker{ --Geometry joker
    key = "geometryjoker",
    config = {
        extra = {
            ohgod = 1,
            hypermult_arrows = 2,
            start_dissolve = 0,
            n = 0
        }
    },
    loc_txt = {
        ['name'] = 'Geometry joker',
        ['text'] = {
            [1] = 'Gains{X:edition,C:dark_edition,E:1,s:1.2}^^0.04{}Mult if',
            [2] = 'played hand is {C:attention}exactly{} four cards',
            [3] = 'if played hand is {C:attention}not{}, {C:red,E:1}destroy self{}',
            [4] = '{C:hearts,e:1,s:0.8}GEOMETRY DASH{} {C:inactive,s:0.7}- MDK{}',
            [5] = '{C:inactive}(currently{} {X:edition,C:dark_edition,E:1,s:1.2}^^#1#{} {C:inactive}Mult){}'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 7,
        y = 3
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 500,
    rarity = "cokelatr_almanetic",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = false,
    atlas = 'CustomJokers',
    in_pool = function(self, args)
          return (
          not args 
          or args.source ~= 'sho' 
          or args.source == 'buf' or args.source == 'jud' or args.source == 'rif' or args.source == 'rta' or args.source == 'sou' or args.source == 'uta' or args.source == 'wra'
          )
          and true
      end,

    loc_vars = function(self, info_queue, card)
        return {vars = {card.ability.extra.ohgod}}
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
            if #context.full_hand == 4 then
                card.ability.extra.ohgod = (card.ability.extra.ohgod) + 0.4
                return {
                    hypermult = {
    card.ability.extra.hypermult_arrows,
    card.ability.extra.ohgod
}
                }
            elseif not (#context.full_hand == 4) then
                return {
                    func = function()
                card:start_dissolve()
                return true
            end
                }
            end
        end
    end
}