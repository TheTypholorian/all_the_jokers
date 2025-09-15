SMODS.Booster {
    key = 'destructive_pack',
    loc_txt = {
        name = "Destructive Pack",
        text = {
            "Choose 1 of up to 3 Destructive Joker cards"
        },
        group_name = "Destructive Pack"
    },
    config = { extra = 3, choose = 1 },
    atlas = "CustomBoosters",
    pos = { x = 0, y = 0 },
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        return {
        set = "Joker",
        rarity = "shit_destructive",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "shit_destructive_pack"
        }
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, HEX("d766d4"))
        ease_background_colour({ new_colour = HEX('d766d4'), special_colour = HEX("c247b7"), contrast = 2 })
    end,
    particles = function(self)
        -- No particles for joker packs
    end,
}


SMODS.Booster {
    key = 'forged_pack',
    loc_txt = {
        name = "Forged Pack",
        text = {
            "Sybau..."
        },
        group_name = "Forged Pack"
    },
    config = { extra = 100, choose = 1 },
    atlas = "CustomBoosters",
    pos = { x = 1, y = 0 },
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        return {
        set = "Joker",
        rarity = "shit_forged",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "shit_forged_pack"
        }
    end,
    ease_background_colour = function(self)
    end,
    particles = function(self)
        -- No particles for joker packs
    end,
}


SMODS.Booster {
    key = 'generic_pack',
    loc_txt = {
        name = "Generic Pack",
        text = {
            "Choose 1 of up to 3 Generic cards to be added to consumables"
        },
        group_name = "Generic Pack"
    },
    config = { extra = 3, choose = 1 },
    atlas = "CustomBoosters",
    pos = { x = 2, y = 0 },
    draw_hand = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        return {
        set = "generic",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "shit_generic_pack"
        }
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, HEX("9733d5"))
        ease_background_colour({ new_colour = HEX('9733d5'), special_colour = HEX("451d59"), contrast = 2 })
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2), lighten(G.C.GOLD, 0.2) },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}


SMODS.Booster {
    key = 'jumbo_destructive_pack',
    loc_txt = {
        name = "Jumbo Destructive Pack",
        text = {
            "Choose 1 of up to 5 Destructive Joker cards"
        },
        group_name = "Jumbo Destructive Pack"
    },
    config = { extra = 5, choose = 1 },
    cost = 5,
    atlas = "CustomBoosters",
    pos = { x = 3, y = 0 },
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        return {
        set = "Joker",
        rarity = "shit_destructive",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "shit_jumbo_destructive_pack"
        }
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, HEX("ca4fb1"))
        ease_background_colour({ new_colour = HEX('ca4fb1'), special_colour = HEX("c150aa"), contrast = 2 })
    end,
    particles = function(self)
        -- No particles for joker packs
    end,
}


SMODS.Booster {
    key = 'jumbo_generic_pack',
    loc_txt = {
        name = "Jumbo Generic Pack",
        text = {
            "Choose 1 of up to 5 Generic cards to be added to consumables"
        },
        group_name = "Jumbo Generic Pack"
    },
    config = { extra = 5, choose = 1 },
    cost = 5,
    atlas = "CustomBoosters",
    pos = { x = 4, y = 0 },
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        return {
        set = "generic",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "shit_jumbo_generic_pack"
        }
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, HEX("bd10e0"))
        ease_background_colour({ new_colour = HEX('bd10e0'), special_colour = HEX("9013fe"), contrast = 2 })
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2), lighten(G.C.GOLD, 0.2) },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}


SMODS.Booster {
    key = 'jumbo_shitpost_pack',
    loc_txt = {
        name = "Jumbo Shitpost Pack",
        text = {
            "Choose 1 of up to 5 Shitpost Joker cards"
        },
        group_name = "Jumbo Shitpost Pack"
    },
    config = { extra = 5, choose = 1 },
    cost = 5,
    atlas = "CustomBoosters",
    pos = { x = 5, y = 0 },
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        return {
        set = "Joker",
        rarity = "shit_shitpost",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "shit_jumbo_shitpost_pack"
        }
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, HEX("10c21e"))
        ease_background_colour({ new_colour = HEX('10c21e'), special_colour = HEX("62d994"), contrast = 2 })
    end,
    particles = function(self)
        -- No particles for joker packs
    end,
}


SMODS.Booster {
    key = 'jumbo_tylers_mind_pack',
    loc_txt = {
        name = "Jumbo Tyler's Mind Pack",
        text = {
            "Choose 1 of up to 4  Tyler's-Mind  Joker cards"
        },
        group_name = "Jumbo Tyler's Mind Pack"
    },
    config = { extra = 4, choose = 1 },
    cost = 5,
    atlas = "CustomBoosters",
    pos = { x = 6, y = 0 },
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        return {
        set = "shit_tyler",
        rarity = "shit_tylers_mind",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "shit_jumbo_tylers_mind_pack"
        }
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, HEX("a1f178"))
        ease_background_colour({ new_colour = HEX('a1f178'), special_colour = HEX("a0c871"), contrast = 2 })
    end,
    particles = function(self)
        -- No particles for joker packs
    end,
}


SMODS.Booster {
    key = 'jumbo_ultrarot_pack',
    loc_txt = {
        name = "Jumbo Ultrarot Pack",
        text = {
            "Choose 1 of up to 3 Ultrarot cards to be added to consumables"
        },
        group_name = "Jumbo Ultrarot Pack"
    },
    config = { extra = 3, choose = 1 },
    cost = 5,
    atlas = "CustomBoosters",
    pos = { x = 7, y = 0 },
    draw_hand = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        return {
        set = "ultrarot",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "shit_jumbo_ultrarot_pack"
        }
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, HEX("222554"))
        ease_background_colour({ new_colour = HEX('222554'), special_colour = HEX("4a90e2"), contrast = 2 })
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2), lighten(G.C.GOLD, 0.2) },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}


SMODS.Booster {
    key = 'mega_generic_pack',
    loc_txt = {
        name = "Mega Generic Pack",
        text = {
            "Choose 2 of up to 7 Generic cards to be added to consumables"
        },
        group_name = "Mega Generic Pack"
    },
    config = { extra = 7, choose = 2 },
    cost = 6,
    atlas = "CustomBoosters",
    pos = { x = 8, y = 0 },
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        return {
        set = "generic",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "shit_mega_generic_pack"
        }
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, HEX("9733d5"))
        ease_background_colour({ new_colour = HEX('9733d5'), special_colour = HEX("451d59"), contrast = 2 })
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2), lighten(G.C.GOLD, 0.2) },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}


SMODS.Booster {
    key = 'mega_shitpost_pack',
    loc_txt = {
        name = "Mega Shitpost Pack",
        text = {
            "Choose 2 of up to 7 Shitpost Joker cards"
        },
        group_name = "Mega Shitpost Pack"
    },
    config = { extra = 7, choose = 2 },
    cost = 6,
    atlas = "CustomBoosters",
    pos = { x = 9, y = 0 },
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        return {
        set = "Joker",
        rarity = "shit_shitpost",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "shit_mega_shitpost_pack"
        }
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, HEX("10c21e"))
        ease_background_colour({ new_colour = HEX('10c21e'), special_colour = HEX("62d994"), contrast = 2 })
    end,
    particles = function(self)
        -- No particles for joker packs
    end,
}


SMODS.Booster {
    key = 'mega_ultrarot_pack',
    loc_txt = {
        name = "Mega Ultrarot Pack",
        text = {
            "Choose 2 of up to 7 Ultrarot cards to be added to consumables"
        },
        group_name = "Mega Ultrarot Pack"
    },
    config = { extra = 7, choose = 2 },
    cost = 6,
    atlas = "CustomBoosters",
    pos = { x = 0, y = 1 },
    draw_hand = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        return {
        set = "ultrarot",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "shit_mega_ultrarot_pack"
        }
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, HEX("222554"))
        ease_background_colour({ new_colour = HEX('222554'), special_colour = HEX("4a90e2"), contrast = 2 })
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2), lighten(G.C.GOLD, 0.2) },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}


SMODS.Booster {
    key = 'mini_destructive_pack',
    loc_txt = {
        name = "Mini Destructive Pack",
        text = {
            "Choose 1 of up to 1 Destructive Joker cards"
        },
        group_name = "Mini Destructive Pack"
    },
    config = { extra = 1, choose = 1 },
    cost = 2,
    atlas = "CustomBoosters",
    pos = { x = 1, y = 1 },
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        return {
        set = "Joker",
        rarity = "shit_destructive",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "shit_mini_destructive_pack"
        }
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, HEX("c855bb"))
        ease_background_colour({ new_colour = HEX('c855bb'), special_colour = HEX("e289d9"), contrast = 2 })
    end,
    particles = function(self)
        -- No particles for joker packs
    end,
}


SMODS.Booster {
    key = 'mini_generic_pack',
    loc_txt = {
        name = "Mini Generic Pack",
        text = {
            "Choose 1 of up to 1 Generic cards to be added to consumables"
        },
        group_name = "Mini Generic Pack"
    },
    config = { extra = 1, choose = 1 },
    cost = 2,
    atlas = "CustomBoosters",
    pos = { x = 2, y = 1 },
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        return {
        set = "generic",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "shit_mini_generic_pack"
        }
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, HEX("9733d5"))
        ease_background_colour({ new_colour = HEX('9733d5'), special_colour = HEX("451d59"), contrast = 2 })
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2), lighten(G.C.GOLD, 0.2) },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}


SMODS.Booster {
    key = 'mini_shitpost_pack',
    loc_txt = {
        name = "Mini Shitpost Pack",
        text = {
            "Choose 1 of up to 1 Shitpost Joker cards"
        },
        group_name = "Mini Shitpost Pack"
    },
    config = { extra = 1, choose = 1 },
    cost = 2,
    atlas = "CustomBoosters",
    pos = { x = 3, y = 1 },
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        return {
        set = "Joker",
        rarity = "shit_shitpost",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "shit_mini_shitpost_pack"
        }
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, HEX("10c21e"))
        ease_background_colour({ new_colour = HEX('10c21e'), special_colour = HEX("62d994"), contrast = 2 })
    end,
    particles = function(self)
        -- No particles for joker packs
    end,
}


SMODS.Booster {
    key = 'mini_ultrarot_pack',
    loc_txt = {
        name = "Mini Ultrarot Pack",
        text = {
            "Choose 1 of up to 1 Ultrarot cards to be added to consumables"
        },
        group_name = "Mini Ultrarot Pack"
    },
    config = { extra = 1, choose = 1 },
    cost = 2,
    atlas = "CustomBoosters",
    pos = { x = 4, y = 1 },
    draw_hand = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        return {
        set = "ultrarot",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "shit_mini_ultrarot_pack"
        }
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, HEX("222554"))
        ease_background_colour({ new_colour = HEX('222554'), special_colour = HEX("4a90e2"), contrast = 2 })
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2), lighten(G.C.GOLD, 0.2) },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}


SMODS.Booster {
    key = 'polychrome_pack',
    loc_txt = {
        name = "Polychrome Pack",
        text = {
            "Polychrome cards"
        },
        group_name = "Polychrome Pack"
    },
    config = { extra = 3, choose = 1 },
    atlas = "CustomBoosters",
    pos = { x = 5, y = 1 },
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        return {
        set = "Playing Card",
        edition = "e_polychrome",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "shit_polychrome_pack"
        }
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.3,
            initialize = true,
            lifespan = 3,
            speed = 0.2,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.BLACK, G.C.RED },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}


SMODS.Booster {
    key = 'shit',
    loc_txt = {
        name = "shit",
        text = {
            "Choose 1 of up to 5 Playing cards with editions custom from my mod to add to your deck"
        },
        group_name = "shit"
    },
    config = { extra = 5, choose = 1 },
    atlas = "CustomBoosters",
    pos = { x = 6, y = 1 },
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        local selected_index = pseudorandom('shit_shit_card', 1, 3)
        if selected_index == 1 then
            return {
            set = "Playing Card",
            edition = "e_shit_loops",
                area = G.pack_cards,
                skip_materialize = true,
                soulable = true,
                key_append = "shit_shit"
            }
        elseif selected_index == 2 then
            return {
            set = "Playing Card",
            edition = "e_shit_interference",
                area = G.pack_cards,
                skip_materialize = true,
                soulable = true,
                key_append = "shit_shit"
            }
        elseif selected_index == 3 then
            return {
            set = "Playing Card",
            edition = "e_shit_error",
                area = G.pack_cards,
                skip_materialize = true,
                soulable = true,
                key_append = "shit_shit"
            }
        end
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, HEX("50e3c2"))
        ease_background_colour({ new_colour = HEX('50e3c2'), special_colour = HEX("4a90e2"), contrast = 2 })
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.3,
            initialize = true,
            lifespan = 3,
            speed = 0.2,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.BLACK, G.C.RED },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}


SMODS.Booster {
    key = 'shitpost_pack',
    loc_txt = {
        name = "Shitpost Pack",
        text = {
            "Choose 1 of up to 3 Shitpost Joker cards"
        },
        group_name = "Shitpost Pack"
    },
    config = { extra = 3, choose = 1 },
    atlas = "CustomBoosters",
    pos = { x = 7, y = 1 },
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        return {
        set = "Joker",
        rarity = "shit_shitpost",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "shit_shitpost_pack"
        }
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, HEX("10c21e"))
        ease_background_colour({ new_colour = HEX('10c21e'), special_colour = HEX("62d994"), contrast = 2 })
    end,
    particles = function(self)
        -- No particles for joker packs
    end,
}


SMODS.Booster {
    key = 'spot_pack',
    loc_txt = {
        name = "Spot Pack",
        text = {
            "Choose 1 of up to 3 Spot cards to be added to consumables"
        },
        group_name = "Spot Pack"
    },
    config = { extra = 3, choose = 1 },
    weight = 0.15,
    atlas = "CustomBoosters",
    pos = { x = 8, y = 1 },
    draw_hand = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        return {
        set = "spot",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "shit_spot_pack"
        }
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, HEX("bf32a8"))
        ease_background_colour({ new_colour = HEX('bf32a8'), special_colour = HEX("b34b36"), contrast = 2 })
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2), lighten(G.C.GOLD, 0.2) },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}


SMODS.Booster {
    key = 'tylers_mind_pack',
    loc_txt = {
        name = "Tyler's Mind Pack",
        text = {
            "Choose 1 of up to 3  Tyler's-Mind  Joker cards"
        },
        group_name = "Tyler's Mind Pack"
    },
    config = { extra = 3, choose = 1 },
    atlas = "CustomBoosters",
    pos = { x = 9, y = 1 },
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        return {
        set = "shit_tyler",
        rarity = "shit_tylers_mind",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "shit_tylers_mind_pack"
        }
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, HEX("a1f178"))
        ease_background_colour({ new_colour = HEX('a1f178'), special_colour = HEX("a0c871"), contrast = 2 })
    end,
    particles = function(self)
        -- No particles for joker packs
    end,
}


SMODS.Booster {
    key = 'ultrarot_pack',
    loc_txt = {
        name = "Ultrarot Pack",
        text = {
            "Choose 2 of up to 5 Ultrarot cards to be added to consumables"
        },
        group_name = "Ultrarot Pack"
    },
    config = { extra = 5, choose = 2 },
    atlas = "CustomBoosters",
    pos = { x = 0, y = 2 },
    draw_hand = true,
    discovered = true,
    loc_vars = function(self, info_queue, card)
        local cfg = (card and card.ability) or self.config
        return {
            vars = { cfg.choose, cfg.extra }
        }
    end,
    create_card = function(self, card, i)
        return {
        set = "ultrarot",
            area = G.pack_cards,
            skip_materialize = true,
            soulable = true,
            key_append = "shit_ultrarot_pack"
        }
    end,
    ease_background_colour = function(self)
        ease_colour(G.C.DYN_UI.MAIN, HEX("222554"))
        ease_background_colour({ new_colour = HEX('222554'), special_colour = HEX("4a90e2"), contrast = 2 })
    end,
    particles = function(self)
        G.booster_pack_sparkles = Particles(1, 1, 0, 0, {
            timer = 0.015,
            scale = 0.2,
            initialize = true,
            lifespan = 1,
            speed = 1.1,
            padding = -1,
            attach = G.ROOM_ATTACH,
            colours = { G.C.WHITE, lighten(G.C.PURPLE, 0.4), lighten(G.C.PURPLE, 0.2), lighten(G.C.GOLD, 0.2) },
            fill = true
        })
        G.booster_pack_sparkles.fade_alpha = 1
        G.booster_pack_sparkles:fade(1, 0)
    end,
}
