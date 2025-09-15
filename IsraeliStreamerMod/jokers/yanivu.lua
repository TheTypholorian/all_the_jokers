SMODS.Joker {
    key = "yanivu",
    rarity = 2,
    cost = 6,
	unlocked = true,
    discovered = true,
    blueprint_compat = false,
    eternal_compat = true,
    perishable_compat = true,
    atlas = 'yanivu',
    pos = { x = 0, y = 0 },
    loc_txt = {
        name = "Yanivu",
        text = {
            "If a {C:attention}Woman{} is in the played hand,",
            "gain {X:mult,C:white} 5x {} Mult BUT",
            "She will run away with fear"
        }
    },
	
    calculate = function(self, card, context)
        if not context or not context.joker_main then return end
        if not G.play or not G.play.cards or #G.play.cards == 0 then return end

        for i, played_card in ipairs(G.play.cards) do
            local rank = played_card.base and played_card.base.value
            if rank == 'Queen' then

                played_card:start_dissolve()
				played_card:remove_from_deck()
				G.play:remove_card(played_card)
				--played_card:remove()
                return {
                    x_mult = 5,
                    card = card,
					message = "Why did she run away?",
					colour = G.C.ATTENTION,
                    message_time = 4.0

                }
            end
        end
    end,



    in_pool = function(self)
        return true
    end



}
