local curr_dir = "src/jokers/"

assert(SMODS.load_file(curr_dir.."plant.lua"))()
assert(SMODS.load_file(curr_dir.."common.lua"))()
assert(SMODS.load_file(curr_dir.."uncommon.lua"))()
assert(SMODS.load_file(curr_dir.."rare.lua"))()