local clubs_pack_inject_hook = SMODS.ObjectTypes.clubs_pack.inject
function SMODS.ObjectTypes.clubs_pack.inject(self)
    clubs_pack_inject_hook(self)
    self:inject_card(SMODS.Centers.j_bunc_crop_circles)
end

table.insert(SMODS.Challenges.c_pencil_permamouth.restrictions.banned_cards, { id = "j_bunc_ghost_print" })
StrangeLib.bulk_add(SMODS.Challenges.c_pencil_permamouth.restrictions.banned_other, {
    { id = "bl_bunc_mask",    type = "blind" },
    { id = "bl_bunc_bulwark", type = "blind" },
})
StrangeLib.bulk_add(SMODS.Challenges.c_pencil_immutable.restrictions.banned_cards, {
    { id = "j_bunc_linocut" },
    { id = "j_bunc_juggalo" },
    { id = "j_bunc_puzzle_board" },
    { id = "j_bunc_glue_gun" },
    { id = "j_bunc_taped" },
    { id = "j_bunc_rubber_band_ball" },
    { id = "j_bunc_headache" },
    { id = "j_bunc_games_collector" },
    { id = "j_bunc_fondue" },
    { id = "j_bunc_ROYGBIV" },
    { id = "c_bunc_adjustment" },
    { id = "c_bunc_art" },
    { id = "c_bunc_universe" },
    { id = "c_bunc_sky" },
    { id = "c_bunc_abyss" },
    { id = "c_bunc_cleanse" },
    { id = "c_bunc_the_8" },
    { id = "p_bunc_virtual_1",       ids = { "p_bunc_virtual_1", "p_bunc_virtual_2", "p_bunc_virtual_jumbo", "p_bunc_virtual_mega" } },
    { id = "v_bunc_arcade_machine" },
})
table.insert(SMODS.Challenges.c_pencil_immutable.restrictions.banned_tags, { id = "tag_bunc_arcade" })
