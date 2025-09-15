local curr_dir = "src/mod_compat/"

---@diagnostic disable-next-line: undefined-global
if not Talisman then
    assert(SMODS.load_file(curr_dir.."no_talisman.lua"))()
end