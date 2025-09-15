SMODS.Shader({ key = 'ionized', path = 'ionized.fs' })

SMODS.Edition {
    key = 'random',
    shader = 'ionized',
    in_shop = true,
    weight = 0.01,
    extra_cost = 5,
    apply_to_float = false,
    badge_colour = HEX('0011ff'),
    sound = { sound = "generic1", per = 1.2, vol = 0.4 },
    disable_shadow = false,
    disable_base_shader = true,
    loc_txt = {
        name = 'Random',
        label = 'Random',
        text = {
        [1] = 'Randomizes {C:attention,s:1.2}everything{} about',
        [2] = 'this card when {C:attention}scored{}'
    }
    },
    unlocked = true,
    discovered = true,
    no_collection = false,
    get_weight = function(self)
        return G.GAME.edition_rate * self.weight
    end,
  
    calculate = function(self, card, context)
        if context.pre_joker or (context.main_scoring and context.cardarea == G.play) then
            assert(SMODS.change_base(card, pseudorandom_element(SMODS.Suits, 'edit_card_suit').key, pseudorandom_element(SMODS.Ranks, 'edit_card_rank').key))
                local enhancement_pool = {}
                for _, enhancement in pairs(G.P_CENTER_POOLS.Enhanced) do
                    if enhancement.key ~= 'm_stone' then
                        enhancement_pool[#enhancement_pool + 1] = enhancement
                    end
                end
                local random_enhancement = pseudorandom_element(enhancement_pool, 'edit_card_enhancement')
                card:set_ability(random_enhancement)
                local random_seal = SMODS.poll_seal({mod = 10})
                if random_seal then
                    card:set_seal(random_seal, true)
                end
                local random_edition = poll_edition('edit_card_edition', nil, true, true)
                if random_edition then
                    card:set_edition(random_edition, true)
                end
            card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil, {message = "Card Modified!", colour = G.C.BLUE})
        end
    end
}