SMODS.Joker{
    --[[
    seed
    1 in 6 chance of getting destroyed at the end of the round
    when destroyed, the shop will guarrantee a plant booster pack
    ]]
    key = "seed", -- Idea Credit: plantform @ discord
    loc_txt = {
        name = 'Seed',
        text = {
            '{C:green}#1# in #2#{} chance of getting',
            'destroyed at the end of the round',
            'when destroyed, creates a {C:spectral,T:t_EF_small_plant_pack_tag}Garden tag{}'
        }
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = { key = 'tag_EF_small_plant_pack_tag', set = 'Tag' }
        local nominator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "EF_seed")
        return {vars = {nominator, denominator}}
    end,
    joker_display_def = function (JokerDisplay)
        return {
            text = {
                { text = "(" },
                { ref_table = "card.joker_display_values", ref_value = "nominator" },
                { text = " in " },
                { ref_table = "card.joker_display_values", ref_value = "denominator" },
                { text = ")" },
            },
            text_config = { colour = G.C.GREEN, scale = 0.3 },
            calc_function = function(card)
                local nominator, denominator = SMODS.get_probability_vars(card, 1, card.ability.extra.odds, "EF_seed")
                card.joker_display_values.nominator = nominator
                card.joker_display_values.denominator = denominator
            end
        }
    end,
    config = { extra = {odds = 6} },
    atlas = "Jokers",
    pos = {x=5,y=0},
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = false,
    demicoloncompat = true,
    rarity = 1,
    cost = 4,

    set_badges = function(self, card, badges)
 		badges[#badges+1] = create_badge('Idea Credit: plantform', G.C.EF.IDEA_CREDIT, G.C.BLACK, 0.8 )
 	end,

    calculate = function(self, card, context)
        if context.forcetrigger or (context.end_of_round and context.game_over == false and context.main_eval and not context.blueprint) then
            if SMODS.pseudorandom_probability(card, "EF_seed", 1, card.ability.extra.odds, "EF_seed") or
                context.forcetrigger or card.ability.cry_rigged -- cryptid compat
            then
                card:start_dissolve()
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        add_tag(Tag('tag_EF_small_plant_pack_tag'))
                        return true
                    end)
                }))
                return {
                    message = localize('k_extinct_ex')
                }
            else
                return {
                    message = localize('k_safe_ex')
                }
            end
        end
    end
}
