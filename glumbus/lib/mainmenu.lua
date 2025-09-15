-- add glumbus card to main menu
-- i wrote this with no copy paste or code lsp
-- but it was based on the work in the balatro multiplayer mod
-- which is itself based on cryptid's implementation
if SMODS.current_mod.config.enable_main_menu_glumbus then
    local game_main_menu_ref = Game.main_menu
    ---@diagnostic disable-next-line: duplicate-set-field
    function Game:main_menu(change_context)
        local ret = game_main_menu_ref(self, change_context)

        local title_card = Card(
            G.title_top.T.x,
            G.title_top.T.y,
            G.CARD_W,
            G.CARD_H,
            G.P_CARDS.empty,
            G.P_CENTERS.j_lucky_cat,
            { bypass_discovery_center = true }
        )

        G.title_top.T.w = G.title_top.T.w * 1.7675
        G.title_top.T.x = G.title_top.T.x - 0.8

        G.title_top:emplace(title_card)

        title_card.T.w = title_card.T.w * 1.1 * 1.2
        title_card.T.h = title_card.T.h * 1.1 * 1.2
        title_card.no_ui = true
        title_card.states.visible = false

        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = change_context == "game" and 1.5 or 0,
            blockable = false,
            blocking = false,
            func = function()
                if change_context == "splash" then
                    title_card.states.visible = true
                    title_card:start_materialize({ G.C.WHITE, G.C.WHITE }, true, 2.5)
                    play_sound("whoosh1", math.random() * 0.1 + 0.3, 0.3)
                    play_sound("crumple" .. math.random(1, 5), math.random() * 0.2 + 0.6, 0.65)
                else
                    title_card.states.visible = true
                    title_card:start_materialize({ G.C.WHITE, G.C.WHITE }, nil, 1.2)
                end

                G.VIBRATION = G.VIBRATION + 1
                return true
            end
        }))

        return ret
    end
end
