SMODS.current_mod.config_tab = function()
    return {
        n = G.UIT.ROOT,
        config = {
            r = 0.1,
            minw = 5,
            align = "cm",
            padding = 0.2,
            colour = G.C.BLACK,
        },
        nodes = {
            create_toggle({
                id = "enable_main_menu_glumbus",
                label = localize("k_glumbus_enable_mm"),
                ref_table = SMODS.Mods["glumbus"].config,
                ref_value = "enable_main_menu_glumbus"
            }),
        }
    }
end
