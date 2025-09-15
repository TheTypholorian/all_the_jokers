local https_lib = assert(SMODS.load_file("lib/https.lua"))()
anotherstupidbalatromod_config = { HTTPS = true }

local config = SMODS.current_mod.config

SMODS.Atlas({
    key = "CustomJokers", 
    path = "CustomJokers.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
}):register()

SMODS.Atlas{
    key = "death", 
    path = "CustomBlind.png", 
	frames = 21,
    px = 34,
    py = 34, 
    atlas_table = "ANIMATION_ATLAS"
}

SMODS.Atlas({
    key = "CustomConsumables", 
    path = "CustomConsumables.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
}):register()

SMODS.Atlas({
	key = "modicon",
	path = "ModIcon.png",
	px = 32,
	py = 32,
})

SMODS.Atlas({
    key = "CustomEnhancements", 
    path = "CustomEnhancements.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
}):register()

SMODS.Atlas({
    key = "CustomSeals", 
    path = "CustomSeals.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
}):register()

SMODS.Atlas({
    key = "CustomBacks", 
    path = "CustomBacks.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
}):register()

SMODS.Atlas({
    key = "CustomBoosters", 
    path = "CustomBoosters.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
}):register()

SMODS.Atlas({
    key = "CustomVouchers", 
    path = "CustomVouchers.png", 
    px = 71,
    py = 95, 
    atlas_table = "ASSET_ATLAS"
}):register()

SMODS.Atlas({
    key = "CustomStake", 
    path = "CustomStake.png", 
    px = 29,
    py = 29, 
    atlas_table = "ASSET_ATLAS"
}):register()

SMODS.Atlas({
    key = "CustomTag", 
    path = "CustomTag.png", 
    px = 34,
    py = 34, 
    atlas_table = "ASSET_ATLAS"
}):register()

SMODS.Atlas({
    key = "CustomSticker", 
    path = "CustomSticker.png", 
    px = 71,
    py = 71, 
    atlas_table = "ASSET_ATLAS"
}):register()

SMODS.Sound({
    key = "shitpost_music", 
    path = "shitpost_music.ogg",
    pitch = 0.7,
    sync = true,
    select_music_track = function()
        return (G.pack_cards and G.pack_cards.cards and G.pack_cards.cards[1] and 
                G.pack_cards.cards[1].ability.set == "Joker" and
                G.pack_cards.cards[1].config and G.pack_cards.cards[1].config.center and
                G.pack_cards.cards[1].config.center.rarity == "shit_shitpost") and 10 or false
    end
})

SMODS.Sound({
    key = "generic_music", 
    path = "generic_music.ogg",
    pitch = 0.7,
    sync = true,
    select_music_track = function()
        return (G.pack_cards and G.pack_cards.cards and G.pack_cards.cards[1] and 
                G.pack_cards.cards[1].ability.set == "generic") and 10 or false
    end
})

SMODS.Sound({
    key = "ultrarot_music", 
    path = "ultrarot_music.ogg",
    pitch = 0.7,
    sync = true,
    select_music_track = function()
        return (G.pack_cards and G.pack_cards.cards and G.pack_cards.cards[1] and 
                G.pack_cards.cards[1].ability.set == "ultrarot") and 10 or false
    end
})

SMODS.Sound {
    key = 'music_menutest',
    path = 'menutest.ogg', 
    volume = 0.6,
    pitch = 1.0,
    
    select_music_track = function(self)
        if config.enable_menu_music and (G.STATE == G.STATES.MENU or G.STATE == 11) then
            return 100  
        end
        return nil  
    end
}

SMODS.current_mod.extra_tabs = function()
    return {
        {
            label = 'Credits',
            tab_definition_function = function()
                return {
                    n = G.UIT.ROOT, 
                    config = {
                        align = "cm", 
                        padding = 0.2, 
                        colour = G.C.BLACK, 
                        r = 0.1, 
                        minw = 10, 
                        minh = 8
                    }, 
                    nodes = {
                        {
                            n = G.UIT.C, 
                            config = {align = "cm", padding = 0.1}, 
                            nodes = {
                                {
                                    n = G.UIT.R, 
                                    config = {align = "cm", padding = 0.15}, 
                                    nodes = {
                                        {
                                            n = G.UIT.T, 
                                            config = {
                                                text = "CREDITS", 
                                                colour = G.C.UI.TEXT_LIGHT, 
                                                scale = 0.7
                                            }
                                        }
                                    }
                                },
                                {
                                    n = G.UIT.R, 
                                    config = {align = "cm", padding = 0.1}, 
                                    nodes = {}
                                },
                                -- Doggfly
                                {
                                    n = G.UIT.R, 
                                    config = {align = "cm", padding = 0.05}, 
                                    nodes = {
                                        {
                                            n = G.UIT.T, 
                                            config = {
                                                text = "Doggfly", 
                                                colour = G.C.YELLOW, 
                                                scale = 0.55
                                            }
                                        }
                                    }
                                },
                                {
                                    n = G.UIT.R, 
                                    config = {align = "cm", padding = 0.02}, 
                                    nodes = {
                                        {
                                            n = G.UIT.T, 
                                            config = {
                                                text = "(Creator of this crap)", 
                                                colour = G.C.UI.TEXT_LIGHT, 
                                                scale = 0.4
                                            }
                                        }
                                    }
                                },
                                {
                                    n = G.UIT.R, 
                                    config = {align = "cm", padding = 0.02}, 
                                    nodes = {
                                        {
                                            n = G.UIT.T, 
                                            config = {
                                                text = "(I wrote some code to do this)", 
                                                colour = G.C.UI.TEXT_INACTIVE, 
                                                scale = 0.35
                                            }
                                        }
                                    }
                                },
                                {
                                    n = G.UIT.R, 
                                    config = {align = "cm", padding = 0.1}, 
                                    nodes = {}
                                },
                                -- Mateoe
                                {
                                    n = G.UIT.R, 
                                    config = {align = "cm", padding = 0.05}, 
                                    nodes = {
                                        {
                                            n = G.UIT.T, 
                                            config = {
                                                text = "Mateoe", 
                                                colour = G.C.BLUE, 
                                                scale = 0.55
                                            }
                                        }
                                    }
                                },
                                {
                                    n = G.UIT.R, 
                                    config = {align = "cm", padding = 0.02}, 
                                    nodes = {
                                        {
                                            n = G.UIT.T, 
                                            config = {
                                                text = "(Music from the Booster Packs and Main Menu)", 
                                                colour = G.C.UI.TEXT_LIGHT, 
                                                scale = 0.4
                                            }
                                        }
                                    }
                                },
                                {
                                    n = G.UIT.R, 
                                    config = {align = "cm", padding = 0.15}, 
                                    nodes = {}
                                },
                                {
                                    n = G.UIT.R, 
                                    config = {align = "cm", padding = 0.05}, 
                                    nodes = {
                                        {
                                            n = G.UIT.T, 
                                            config = {
                                                text = "And a huge thank you to", 
                                                colour = G.C.UI.TEXT_LIGHT, 
                                                scale = 0.45
                                            }
                                        }
                                    }
                                },
                                {
                                    n = G.UIT.R, 
                                    config = {align = "cm", padding = 0.05}, 
                                    nodes = {
                                        {
                                            n = G.UIT.T, 
                                            config = {
                                                text = "Joker Forge", 
                                                colour = G.C.GREEN, 
                                                scale = 0.5
                                            }
                                        }
                                    }
                                },
                                {
                                    n = G.UIT.R, 
                                    config = {align = "cm", padding = 0.02}, 
                                    nodes = {
                                        {
                                            n = G.UIT.T, 
                                            config = {
                                                text = "jokers, consumables, seals and enchantment made in joker forge", 
                                                colour = G.C.UI.TEXT_LIGHT, 
                                                scale = 0.4
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            end,
        }
    }
end

SMODS.current_mod.config_tab = function()
    return {
        n = G.UIT.ROOT, 
        config = {
            align = "cm", 
            padding = 0.1, 
            colour = G.C.BLACK, 
            r = 0.1, 
            minw = 8, 
            minh = 6
        }, 
        nodes = {
            {
                n = G.UIT.C, 
                config = {align = "cm", padding = 0.1}, 
                nodes = {
                    {
                        n = G.UIT.R, 
                        config = {align = "cm", padding = 0.1}, 
                        nodes = {
                            {
                                n = G.UIT.T, 
                                config = {
                                    text = "Shit", 
                                    colour = G.C.UI.TEXT_LIGHT, 
                                    scale = 0.6
                                }
                            }
                        }
                    },
                    {
                        n = G.UIT.R, 
                        config = {align = "cm", padding = 0.05}, 
                        nodes = {}
                    },
                    {
                        n = G.UIT.R, 
                        config = {align = "cm", padding = 0.1}, 
                        nodes = {
                            {
                                n = G.UIT.C, 
                                config = {align = "cm", minw = 3}, 
                                nodes = {
                                    {
                                        n = G.UIT.T, 
                                        config = {
                                            text = "Toggle menu music:", 
                                            colour = G.C.UI.TEXT_LIGHT, 
                                            scale = 0.45
                                        }
                                    }
                                }
                            },
                            {
                                n = G.UIT.C, 
                                config = {
                                    align = "cm", 
                                    minw = 2,
                                    button = "toggle_menu_music",
                                    colour = config.enable_menu_music and G.C.GREEN or G.C.RED,
                                    r = 0.1,
                                    padding = 0.1,
                                    hover = true,
                                    shadow = true
                                }, 
                                nodes = {
                                    {
                                        n = G.UIT.T, 
                                        config = {
                                            text = config.enable_menu_music and "ENABLE" or "DISABLE", 
                                            colour = G.C.UI.TEXT_LIGHT, 
                                            scale = 0.4
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
end

local game_main_menu_ref = Game.main_menu
function Game:main_menu(change_context)
        game_main_menu_ref(self, change_context)
        G.C.colorname = HEX("8A2BE2") 
        G.C.color2 = HEX("000080")     
        G.SPLASH_BACK:define_draw_steps({
            {
                shader = "splash",
                send = {
                    { name = "time",       ref_table = G.TIMERS, ref_value = "REAL_SHADER" },
                    { name = "vort_speed", val = 1 },
                    { name = "colour_1",   ref_table = G.C,  ref_value = 'colorname' }, 
                    { name = "colour_2",   ref_table = G.C,  ref_value = 'color2' },  
                },
            },
        })
end
G.FUNCS.toggle_menu_music = function(e)
    config.enable_menu_music = not config.enable_menu_music
    
    SMODS.save_mod_config(SMODS.current_mod)
    
    local config_tab = G.OVERLAY_MENU:get_UIE_by_ID("mod_config")
    if config_tab and config_tab.config.object then
        config_tab.config.object:remove()
        config_tab.config.object = UIBox({
            definition = SMODS.current_mod.config_tab(),
            config = {parent = config_tab, type = "cm"}
        })
        config_tab.UIBox:recalculate()
    end
    
    play_sound('button')
end



function Card:resize(mod, force_save)
    self:hard_set_T(self.T.x, self.T.y, self.T.w * mod, self.T.h * mod)
    remove_all(self.children)
    self.children = {}
    self.children.shadow = Moveable(0, 0, 0, 0)
    self:set_sprites(self.config.center, self.base.id and self.config.card)
end

local mainmenuref2 = Game.main_menu
Game.main_menu = function(change_context)

    local ret = mainmenuref2(change_context)

    local newcard = SMODS.create_card({key='j_shit_zzz',area = G.title_top})
    G.title_top.T.w = G.title_top.T.w * 1.7675
    G.title_top.T.x = G.title_top.T.x - 0.8
    G.title_top:emplace(newcard)
    newcard:start_materialize()
    newcard:resize(1.1 * 1.2)
    newcard.no_ui = true
    return ret
end

function Card:resize(mod, force_save)
    self:hard_set_T(self.T.x, self.T.y, self.T.w * mod, self.T.h * mod)
    remove_all(self.children)
    self.children = {}
    self.children.shadow = Moveable(0, 0, 0, 0)
    self:set_sprites(self.config.center, self.base.id and self.config.card)
end

local mainmenuref2 = Game.main_menu
Game.main_menu = function(change_context)

    local ret = mainmenuref2(change_context)

    local newcard = SMODS.create_card({key='j_shit_dontforgetj',area = G.title_top})
    G.title_top.T.w = G.title_top.T.w * 1.7675
    G.title_top.T.x = G.title_top.T.x - 0.8
    G.title_top:emplace(newcard)
    newcard:start_materialize()
    newcard:resize(1.1 * 1.2)
    newcard.no_ui = true
    return ret
end

local NFS = require("nativefs")
to_big = to_big or function(a) return a end
lenient_bignum = lenient_bignum or function(a) return a end

local function load_jokers_folder()
    local mod_path = SMODS.current_mod.path
    local jokers_path = mod_path .. "/jokers"
    local files = NFS.getDirectoryItemsInfo(jokers_path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("jokers/" .. file_name))()
        end
    end
end

local function load_editions_folder()
    local mod_path = SMODS.current_mod.path
    local editions_path = mod_path .. "/editions"
    local files = NFS.getDirectoryItemsInfo(editions_path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("editions/" .. file_name))()
        end
    end
end

local function load_boosters_file()
    local mod_path = SMODS.current_mod.path
    assert(SMODS.load_file("items/boosters.lua"))()
end

local function load_all_in_file()
    local mod_path = SMODS.current_mod.path
    assert(SMODS.load_file("items/all_in.lua"))()
end

local function load_blind_file()
    local mod_path = SMODS.current_mod.path
    assert(SMODS.load_file("items/blinds.lua"))()
end

local function load_dik_file()
    local mod_path = SMODS.current_mod.path
    assert(SMODS.load_file("items/Dik.lua"))()
end

local function load_stake_file()
    local mod_path = SMODS.current_mod.path
    assert(SMODS.load_file("items/stake.lua"))()
end

local function load_challenge_file()
    local mod_path = SMODS.current_mod.path
    assert(SMODS.load_file("items/challenge.lua"))()
end

local function load_tag_file()
    local mod_path = SMODS.current_mod.path
    assert(SMODS.load_file("items/tag.lua"))()
end

local function load_consumables_folder()
    local mod_path = SMODS.current_mod.path
    local consumables_path = mod_path .. "/consumables"
    local files = NFS.getDirectoryItemsInfo(consumables_path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("consumables/" .. file_name))()
        end
    end
end

local function load_rarities_file()
    local mod_path = SMODS.current_mod.path
    assert(SMODS.load_file("rarities.lua"))()
end

local function load_enhancements_folder()
    local mod_path = SMODS.current_mod.path
    local enhancements_path = mod_path .. "/enhancements"
    local files = NFS.getDirectoryItemsInfo(enhancements_path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("enhancements/" .. file_name))()
        end
    end
end

local function load_seals_folder()
    local mod_path = SMODS.current_mod.path
    local seals_path = mod_path .. "/seals"
    local files = NFS.getDirectoryItemsInfo(seals_path)
    for i = 1, #files do
        local file_name = files[i].name
        if file_name:sub(-4) == ".lua" then
            assert(SMODS.load_file("seals/" .. file_name))()
        end
    end
end

load_rarities_file()
load_boosters_file()
load_all_in_file()
assert(SMODS.load_file("sounds.lua"))()
load_stake_file()
load_challenge_file()
load_tag_file()
load_jokers_folder()
load_consumables_folder()
load_dik_file() 
load_enhancements_folder()
load_seals_folder()
load_blind_file()
load_editions_folder()
SMODS.ObjectType({
    key = "shit_food",
    cards = {
        ["j_gros_michel"] = true,
        ["j_egg"] = true,
        ["j_ice_cream"] = true,
        ["j_cavendish"] = true,
        ["j_turtle_bean"] = true,
        ["j_diet_cola"] = true,
        ["j_popcorn"] = true,
        ["j_ramen"] = true,
        ["j_selzer"] = true,
        ["j_shit_chocolate"] = true,
        ["j_shit_fideoscontuco"] = true
    },
})

SMODS.ObjectType({
    key = "shit_tyler",
    cards = {
        ["j_shit_acethejoker"] = true,
        ["j_shit_bigpoe"] = true,
        ["j_shit_churbum"] = true,
        ["j_shit_dctc"] = true,
        ["j_shit_flowerboy"] = true,
        ["j_shit_igor"] = true,
        ["j_shit_samisdead"] = true,
        ["j_shit_sirtylerbaudelaire"] = true,
        ["j_shit_stchroma"] = true,
        ["j_shit_troncat"] = true,
        ["j_shit_tylerthejoker"] = true,
        ["j_shit_wolfhaley"] = true
    },
})

SMODS.ObjectType({
    key = "shit_shit_jokers",
    cards = {
        ["j_shit_hyperjimbo"] = true
    },
})
if G and G.GAME then
    G.E_MANAGER:add_event(Event({
        func = function()
            anotherstupidbalatromod.update_member_count()
            return true
        end,
        delay = 5 
    }))
end

anotherstupidbalatromod.update_member_count()