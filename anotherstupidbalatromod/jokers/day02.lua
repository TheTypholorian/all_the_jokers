SMODS.Joker{ --Day 0
    key = "day02",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Day 0',
        ['text'] = {
            [1] = 'Minecraft hardcore buy i have carbon monoxide poisoning'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 6,
        y = 4
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 5,
    rarity = "shit_shitpost",
    blueprint_compat = true,
    eternal_compat = true,
    perishable_compat = true,
    unlocked = true,
    discovered = true,
    atlas = 'CustomJokers',
    in_pool = function(self, args)
          return (
          not args 
          or args.source ~= 'sho' 
          or args.source == 'buf' or args.source == 'jud' or args.source == 'rif' or args.source == 'rta' or args.source == 'sou' or args.source == 'uta' or args.source == 'wra'
          )
          and true
      end,

    calculate = function(self, card, context)
        if context.after and context.cardarea == G.jokers  then
                return {
                    func = function()
                card:undefined()
                return true
            end
                }
        end
    end
}