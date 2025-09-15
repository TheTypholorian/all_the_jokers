SMODS.optional_features.retrigger_joker = true

-- assert(SMODS.load_file("src/mod_config.lua"))()
assert(SMODS.load_file("src/colors.lua"))() -- one override here
assert(SMODS.load_file("src/helper_functions.lua"))()
assert(SMODS.load_file("src/sounds.lua"))()
assert(SMODS.load_file("src/atlas.lua"))()
assert(SMODS.load_file("src/rarities.lua"))()
assert(SMODS.load_file("src/jokers/load.lua"))()
assert(SMODS.load_file("src/enhancements.lua"))()
assert(SMODS.load_file("src/vouchers.lua"))()
assert(SMODS.load_file("src/boosters.lua"))()
assert(SMODS.load_file("src/tags.lua"))()
assert(SMODS.load_file("src/spectrals.lua"))()
assert(SMODS.load_file("src/challenges.lua"))()
assert(SMODS.load_file("src/mod_compat/load.lua"))() -- more loading there