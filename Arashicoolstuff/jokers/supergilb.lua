SMODS.Joker{ --Super gilb(200k iq)
    key = "supergilb",
    config = {
        extra = {
        }
    },
    loc_txt = {
        ['name'] = 'Super gilb(200k iq)',
        ['text'] = {
            [1] = 'When a hand is played, create a negative {C:spectral}spectral{} card'
        },
        ['unlock'] = {
            [1] = ''
        }
    },
    pos = {
        x = 4,
        y = 2
    },
    display_size = {
        w = 71 * 1, 
        h = 95 * 1
    },
    cost = 20,
    rarity = 4,
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

    set_ability = function(self, card, initial)
        card:set_eternal(true)
    end,

    calculate = function(self, card, context)
        if context.cardarea == G.jokers and context.joker_main  then
                local created_consumable = true
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.add_card{set = 'Spectral', key = nil, edition = 'e_negative', key_append = 'joker_forge_spectral'}
                        return true
                    end
                }))
                return {
                    message = created_consumable and localize('k_plus_spectral') or nil
                }
        end
    end
}