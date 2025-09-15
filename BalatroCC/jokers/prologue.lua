
-- -- Prologue
-- attempt here ends up triggering nothing, if we just set to context.before check then everything still gets triggered not just the rightmost joker
-- SMODS.Joker {
--     key = "prologue",
--     blueprint_compat = true,
--     eternal_compat = true,
--     unlocked = true,
--     discovered = true,
--     atlas = 'ModdedVanilla',
--     pos = { x = 0, y = 0 },
--     rarity = 3,
--     cost = 10,

--     loc_txt = {
--         name = "Prologue",
--         text = {
--             "Triggers the rightmost joker once",
--             "{C:attention}before{} cards are scored",        
--         }
--     },

--     calculate = function(self, card, context)
--         -- Only act when the scoring system is evaluating this joker itself
--         local rightmost_joker = G.jokers.cards[#G.jokers.cards]
--         if context.before and card == rightmost_joker then
--             -- Temporarily modify context for this call
--             context.before = false
--             context.joker_main = true
--             card:juice_up(0.5, 0.5)
--             SMODS.blueprint_effect(card, card, context) -- Apply the effect to the rightmost joker itself
--         end
--     end
-- }



-- Prologue
-- Attempt at allowing joker to the right to be triggered instead of rightmost, 
-- sadly cant restore context in time so everything to the right gets triggered
-- tried also passing a modified temporary context but that didn't work when scoring
-- SMODS.Joker {
--     key = "prologue",
--     blueprint_compat = true,
--     eternal_compat = true,
--     unlocked = true,
--     discovered = true,
--     atlas = 'ModdedVanilla',
--     pos = { x = 0, y = 0 },
--     rarity = 3,
--     cost = 10,

--     loc_txt = {
--         name = "Prologue",
--         text = {
--             "Triggers joker to the left once",
--             "{C:attention}before{} cards are scored",        
--         }
--     },
--     calculate = function(self, card, context)
--         local next_joker
--         for i = 1, #G.jokers.cards do
--             if G.jokers.cards[i] == card then next_joker = G.jokers.cards[i + 1] end
--         end
--         if context.before and next_joker then
--             -- Save original calculate
--             local original_calc = next_joker.calculate
        
--             -- Override calculate temporarily
--             next_joker.calculate = function(self, ctx)
--                 local result = nil
--                 if original_calc then
--                     result = original_calc(self, ctx)
--                 end
--                 -- Revert the context immediately after
--                 ctx.before = true
--                 ctx.joker_main = false
--                 -- Restore original calculate
--                 next_joker.calculate = original_calc
--                 return result
--             end
        
--             -- Modify context for this call
--             context.before = false
--             context.joker_main = true
--             card:juice_up(0.5, 0.5)
--             SMODS.blueprint_effect(card, next_joker, context)
--         end
        
--     end
-- }


-- also tried deepcopying the context and modifying it then calling next:calculate but that aint did shit