-- glumbus

assert(SMODS.load_file("lib/pack.lua"))()
assert(SMODS.load_file("lib/mainmenu.lua"))()
assert(SMODS.load_file("lib/config.lua"))()

SMODS.Atlas({
    key = 'modicon',
    px = 32,
    py = 32,
    path = "icon.png"
})
