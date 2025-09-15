SMODS.Voucher({
	key = "rigged",
	atlas = "Vouchers",
	config = { extra = {} },
	pos = { x = 1, y = 1 },
	cost = 10,
	unlocked = true,
	discovered = true,
	requires = { "v_beginners_luck" },
	available = true,
	calculate = function (self, card, context)
		if context.mod_probability then
			return {
				numerator = context.numerator * 2
			}
		end
	end
})
