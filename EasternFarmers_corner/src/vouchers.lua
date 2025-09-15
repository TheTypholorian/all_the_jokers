SMODS.Voucher {
    key = 'stopwatch',
    atlas = "Vouchers",
    pos = {x = 0, y = 0},
    config = { extra = {} },
    discovered = true,
    loc_txt = {
        name = "Stopwatch",
        text = {
            "Makes {C:gold}All{} {C:blue}time{} based jokers",
            "ignore the current {C:blue}time{}"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {} }
    end,
    redeem = function(self, card)
        G.E_MANAGER:add_event(Event({
            func = function()
                G.GAME.EF_stopwatch_voucher = true
                return true
            end
        }))
    end
}
