SMODS.ConsumableType({
    key = "index",
    primary_colour = HEX("FFFFFF"),
    secondary_colour = HEX("FF0000"),
    shop_rate = 4,
    loc_txt = {},
    default = "c_pencil_ono99",
})
SMODS.UndiscoveredSprite({
    key = "index",
    atlas = "indexes",
    pos = { x = 0, y = 0 },
})

StrangeLib.make_boosters("index",
    { { x = 0, y = 1 }, { x = 1, y = 1 } }, { { x = 2, y = 1 } }, { { x = 3, y = 1 } },
    {
        kind = "Index",
        atlas = "boosters",
        draw_hand = true,
        set_ability = function(self, card, initial, delay_sprites)
            card.ability.extra = card.ability.extra + (G.GAME.index_pack_bonus or 0)
        end,
        ease_background_colour = function(self)
            ease_background_colour({ new_colour = G.C.WHITE, special_colour = G.C.BLUE, contrast = 2 })
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
                colours = { G.C.RED, lighten(G.C.WHITE, 0.4), lighten(G.C.WHITE, 0.2), lighten(G.C.BLUE, 0.2) },
                fill = true
            })
            G.booster_pack_sparkles.fade_alpha = 1
            G.booster_pack_sparkles:fade(1, 0)
        end,
        create_card = function(self, card, i)
            return { set = "index", area = G.pack_cards, skip_materialize = true, soulable = true }
        end,
        group_key = "k_index_pack",
    },
    2)

local G_UIDEF_use_and_sell_buttons_ref = G.UIDEF.use_and_sell_buttons -- copied from Cryptid
function G.UIDEF.use_and_sell_buttons(card)
    if (card.area == G.pack_cards and G.pack_cards) and
        G.GAME.used_vouchers.v_pencil_pull and SMODS.OPENED_BOOSTER and SMODS.OPENED_BOOSTER.config.center.kind == "Index" then --Add a use button
        return {
            n = G.UIT.ROOT,
            config = { padding = -0.1, colour = G.C.CLEAR },
            nodes = {
                {
                    n = G.UIT.R,
                    config = {
                        ref_table = card,
                        r = 0.08,
                        padding = 0.1,
                        align = "bm",
                        minw = 0.5 * card.T.w - 0.15,
                        minh = 0.7 * card.T.h,
                        maxw = 0.7 * card.T.w - 0.15,
                        hover = true,
                        shadow = true,
                        colour = G.C.UI.BACKGROUND_INACTIVE,
                        one_press = true,
                        button = "use_card",
                        func = "can_reserve_card",
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = localize("b_pull"),
                                colour = G.C.UI.TEXT_LIGHT,
                                scale = 0.55,
                                shadow = true,
                            },
                        },
                    },
                },
                {
                    n = G.UIT.R,
                    config = {
                        ref_table = card,
                        r = 0.08,
                        padding = 0.1,
                        align = "bm",
                        minw = 0.5 * card.T.w - 0.15,
                        maxw = 0.9 * card.T.w - 0.15,
                        minh = 0.1 * card.T.h,
                        hover = true,
                        shadow = true,
                        colour = G.C.UI.BACKGROUND_INACTIVE,
                        one_press = true,
                        button = "Do you know that this parameter does nothing?",
                        func = "can_use_consumeable",
                    },
                    nodes = {
                        {
                            n = G.UIT.T,
                            config = {
                                text = localize("b_use"),
                                colour = G.C.UI.TEXT_LIGHT,
                                scale = 0.45,
                                shadow = true,
                            },
                        },
                    },
                },
                { n = G.UIT.R, config = { align = "bm", w = 7.7 * card.T.w } },
                { n = G.UIT.R, config = { align = "bm", w = 7.7 * card.T.w } },
                { n = G.UIT.R, config = { align = "bm", w = 7.7 * card.T.w } },
                { n = G.UIT.R, config = { align = "bm", w = 7.7 * card.T.w } },
                -- Betmma can't explain it, neither can I
            },
        }
    end
    return G_UIDEF_use_and_sell_buttons_ref(card)
end

--Code from Betmma's Vouchers
G.FUNCS.can_reserve_card = function(e)
    if #G.consumeables.cards < G.consumeables.config.card_limit then
        e.config.colour = G.C.GREEN
        e.config.button = "reserve_card"
    else
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    end
end
G.FUNCS.reserve_card = function(e)
    local c1 = e.config.ref_table
    G.E_MANAGER:add_event(Event({
        trigger = "after",
        delay = 0.1,
        func = function()
            c1.area:remove_card(c1)
            c1:add_to_deck()
            if c1.children.price then
                c1.children.price:remove()
            end
            c1.children.price = nil
            if c1.children.buy_button then
                c1.children.buy_button:remove()
            end
            c1.children.buy_button = nil
            remove_nils(c1.children)
            G.consumeables:emplace(c1)
            G.GAME.pack_choices = G.GAME.pack_choices - 1
            if G.GAME.pack_choices <= 0 then
                G.FUNCS.end_consumeable(nil, delay_fac)
            end
            return true
        end,
    }))
end

SMODS.Tag({
    atlas = "tags",
    pos = { x = 1, y = 0 },
    config = { type = "new_blind_choice" },
    key = "index",
    min_ante = 2,
    loc_vars = function(self, info_queue)
        table.insert(info_queue, G.P_CENTERS.p_pencil_index_jumbo_1)
    end,
    apply = function(self, tag, context)
        if context.type == "new_blind_choice" then
            if G.STATE ~= G.STATES.TAROT_PACK then
                G.GAME.PACK_INTERRUPT = G.STATE
            end
            tag:yep("+", G.C.BLUE, function()
                local card = Card(
                    G.play.T.x + G.play.T.w / 2 - G.CARD_W * 1.27 / 2,
                    G.play.T.y + G.play.T.h / 2 - G.CARD_H * 1.27 / 2,
                    G.CARD_W * 1.27,
                    G.CARD_H * 1.27,
                    G.P_CARDS.empty,
                    G.P_CENTERS["p_pencil_index_jumbo_1"],
                    { bypass_discovery_center = true, bypass_discovery_ui = true }
                )
                card.cost = 0
                card.from_tag = true
                G.FUNCS.use_card({ config = { ref_table = card } })
                card:start_materialize()
                return true
            end)
            tag.triggered = true
            return true
        end
    end,
})

SMODS.Consumable({
    key = "replica",
    set = "index",
    atlas = "indexes",
    pos = { x = 1, y = 0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.selections } }
    end,
    cost = 5,
    config = { selections = 1 },
    can_use = function(self, card)
        local targets = {}
        for _, other_card in ipairs(G.consumeables.highlighted) do
            if other_card.ability.set ~= "Unique" and other_card.ability.consumeable and other_card ~= card then
                table.insert(targets, other_card)
            end
        end
        if G.shop_jokers ~= nil then
            for _, other_card in ipairs(G.shop_jokers.highlighted) do
                if other_card.ability.set ~= "Unique" and other_card.ability.consumeable and other_card ~= card then
                    table.insert(targets, other_card)
                end
            end
        end
        if G.shop_booster ~= nil then
            for _, other_card in ipairs(G.shop_booster.highlighted) do
                if other_card.ability.set ~= "Unique" and other_card.ability.consumeable and other_card ~= card then
                    table.insert(targets, other_card)
                end
            end
        end
        if G.shop_vouchers ~= nil then
            for _, other_card in ipairs(G.shop_vouchers.highlighted) do
                if other_card.ability.set ~= "Unique" and other_card.ability.consumeable and other_card ~= card then
                    table.insert(targets, other_card)
                end
            end
        end
        if G.pack_cards ~= nil then
            for _, other_card in ipairs(G.pack_cards.highlighted) do
                if other_card.ability.set ~= "Unique" and other_card.ability.consumeable and other_card ~= card then
                    table.insert(targets, other_card)
                end
            end
        end
        if G.hand ~= nil then
            for _, other_card in ipairs(G.hand.highlighted) do
                if other_card.ability.set ~= "Unique" and other_card.ability.consumeable and other_card ~= card then
                    table.insert(targets, other_card)
                end
            end
        end
        return #targets ~= 0 and #targets <= card.ability.selections and
            #G.consumeables.cards + #targets - (card.area == G.consumeables and 1 or 0) <=
            G.consumeables.config.card_limit
    end,
    use = function(self, card, area)
        G.GAME.consumeable_usage_total.pencil_index = (G.GAME.consumeable_usage_total.pencil_index or 0) + 1
        local targets = {}
        for _, other_card in ipairs(G.consumeables.highlighted) do
            if other_card.ability.set ~= "Unique" and other_card.ability.consumeable and other_card ~= card then
                table.insert(targets, other_card)
            end
        end
        if G.shop_jokers ~= nil then
            for _, other_card in ipairs(G.shop_jokers.highlighted) do
                if other_card.ability.set ~= "Unique" and other_card.ability.consumeable and other_card ~= card then
                    table.insert(targets, other_card)
                end
            end
        end
        if G.shop_booster ~= nil then
            for _, other_card in ipairs(G.shop_booster.highlighted) do
                if other_card.ability.set ~= "Unique" and other_card.ability.consumeable and other_card ~= card then
                    table.insert(targets, other_card)
                end
            end
        end
        if G.shop_vouchers ~= nil then
            for _, other_card in ipairs(G.shop_vouchers.highlighted) do
                if other_card.ability.set ~= "Unique" and other_card.ability.consumeable and other_card ~= card then
                    table.insert(targets, other_card)
                end
            end
        end
        if G.pack_cards ~= nil then
            for _, other_card in ipairs(G.pack_cards.highlighted) do
                if other_card.ability.set ~= "Unique" and other_card.ability.consumeable and other_card ~= card then
                    table.insert(targets, other_card)
                end
            end
        end
        if G.hand ~= nil then
            for _, other_card in ipairs(G.hand.highlighted) do
                if other_card.ability.set ~= "Unique" and other_card.ability.consumeable and other_card ~= card then
                    table.insert(targets, other_card)
                end
            end
        end
        for _, other_card in ipairs(targets) do
            local consume = copy_card(other_card)
            consume:add_to_deck()
            G.consumeables:emplace(consume)
        end
    end,
})

local start_run_hook = Game.start_run
function Game:start_run(args)
    start_run_hook(self, args)
    self.consumeables.config.highlighted_limit = math.huge
end

local shop_ui_hook = G.UIDEF.shop
function G.UIDEF.shop()
    local ret = shop_ui_hook()
    G.shop_jokers.config.highlighted_limit = math.huge
    G.shop_booster.config.highlighted_limit = math.huge
    G.shop_vouchers.config.highlighted_limit = math.huge
    return ret
end

local open_hook = Card.open
function Card:open()
    open_hook(self)
    G.E_MANAGER:add_event(Event({
        func = (function()
            G.E_MANAGER:add_event(Event({
                func = (function()
                    G.pack_cards.config.highlighted_limit = math.huge
                    return true
                end)
            }))
            return true
        end)
    }))
end

SMODS.Consumable({
    key = "counterfeit",
    set = "index",
    atlas = "indexes",
    pos = { x = 2, y = 0 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.dollars } }
    end,
    cost = 5,
    config = { dollars = 15 },
    can_use = function(self, card)
        return true
    end,
    use = function(self, card, area)
        G.GAME.consumeable_usage_total.pencil_index = (G.GAME.consumeable_usage_total.pencil_index or 0) + 1
        ease_dollars(card.ability.dollars)
    end,
})

SMODS.Consumable({
    key = "chisel",
    set = "index",
    atlas = "indexes",
    pos = { x = 3, y = 0 },
    cost = 5,
    can_use = function(self, card)
        if #G.jokers.highlighted ~= 1 then
            return false
        end
        for _, sticker in pairs(SMODS.Stickers) do
            if G.jokers.highlighted[1].ability[sticker.key] then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area)
        G.GAME.consumeable_usage_total.pencil_index = (G.GAME.consumeable_usage_total.pencil_index or 0) + 1
        local target = G.jokers.highlighted[1]
        target:flip()
        play_sound("card1", 0.9)
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.3,
            func = function()
                play_sound("gold_seal", 1.2, 0.4)
                target:juice_up(0.3, 0.3)
                card:juice_up(0.3, 0.3)
                return true
            end,
        }))
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.1,
            func = function()
                for k, v in pairs(SMODS.Stickers) do
                    v:apply(target, nil)
                end
                return true
            end,
        }))
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.85,
            func = function()
                target:flip()
                play_sound("card1", 1.1)
                return true
            end,
        }))
    end,
})

SMODS.Consumable({
    key = "peek",
    set = "index",
    atlas = "indexes",
    pos = { x = 4, y = 0 },
    cost = 5,
    can_use = function(self, card)
        for _, other_card in ipairs(G.hand.cards or {}) do
            if other_card.facing == "back" then
                return true
            end
        end
        return false
    end,
    use = function(self, card, area)
        G.GAME.consumeable_usage_total.pencil_index = (G.GAME.consumeable_usage_total.pencil_index or 0) + 1
        for _, other_card in ipairs(G.hand.cards) do
            if other_card.facing == "back" then
                other_card:flip()
            end
        end
    end,
})

SMODS.Consumable({
    key = "mixnmatch",
    set = "index",
    atlas = "indexes",
    pos = { x = 5, y = 0 },
    cost = 5,
    can_use = function(self, card)
        return #G.hand.highlighted - (card.area == G.hand and 1 or 0) == 2
    end,
    use = function(self, card, area)
        G.GAME.consumeable_usage_total.pencil_index = (G.GAME.consumeable_usage_total.pencil_index or 0) + 1
        local left = false
        local right = false
        for _, other_card in ipairs(G.hand.highlighted) do
            if other_card == card then
            elseif left then
                right = other_card
            else
                left = other_card
            end
        end
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.15,
            func = function()
                left:flip()
                play_sound("card1", 1.15 - (1 - 0.999) / (2 - 0.998) * 0.3)
                return true
            end,
        }))
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.15,
            func = function()
                right:flip()
                play_sound("card1", 1.15 - (2 - 0.999) / (2 - 0.998) * 0.3)
                return true
            end,
        }))
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.1,
            func = function()
                local temp = { suit = left.base.suit, rank = left.base.value }
                SMODS.change_base(left, right.base.suit, right.base.value)
                SMODS.change_base(right, temp.suit, temp.rank)
                card:juice_up(0.3, 0.3)
                return true
            end,
        }))
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.85,
            func = function()
                left:flip()
                play_sound("card1", 1.15 - (1 - 0.999) / (2 - 0.998) * 0.3)
                return true
            end,
        }))
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.15,
            func = function()
                right:flip()
                play_sound("card1", 1.15 - (2 - 0.999) / (2 - 0.998) * 0.3)
                return true
            end,
        }))
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.2,
            func = function()
                G.hand:unhighlight_all()
                return true
            end
        }))
    end,
})

SMODS.Consumable({
    key = "fractal",
    set = "index",
    atlas = "indexes",
    pos = { x = 0, y = 1 },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.cards } }
    end,
    cost = 5,
    config = { cards = 2 },
    can_use = function(self, card)
        return #G.consumeables.cards < G.consumeables.config.card_limit or card.area == G.consumeables
    end,
    use = function(self, card, area)
        G.GAME.consumeable_usage_total.pencil_index = (G.GAME.consumeable_usage_total.pencil_index or 0) + 1
        for _ = 1, math.min(card.ability.cards, G.consumeables.config.card_limit - #G.consumeables.cards) do
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.4,
                func = function()
                    if G.consumeables.config.card_limit > #G.consumeables.cards then
                        play_sound('timpani')
                        local new = SMODS.create_card({ set = "index" })
                        new:add_to_deck()
                        G.consumeables:emplace(new)
                        card:juice_up(0.3, 0.5)
                    end
                    return true
                end
            }))
        end
        delay(0.6)
    end,
})

SMODS.Consumable({
    key = "ono99",
    set = "index",
    atlas = "indexes",
    pos = { x = 1, y = 1 },
    cost = 5,
    can_use = function(self, card)
        return #SMODS.find_card("c_pencil_ono99", true) >= G.consumeables.config.card_limit
    end,
    use = function(self, card, area)
        G.GAME.consumeable_usage_total.pencil_index = (G.GAME.consumeable_usage_total.pencil_index or 0) + 1
        G.GAME.banned_keys.c_pencil_ono99 = true
        play_sound('timpani')
        for _, other_card in ipairs(SMODS.find_card("c_pencil_ono99")) do
            if not other_card.ability.eternal then
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        SMODS.add_card({ set = "index", no_edition = true, edition = other_card.edition })
                        other_card:start_dissolve()
                        return true
                    end
                }))
            end
        end
    end,
})

local can_sell_hook = Card.can_sell_card
function Card:can_sell_card(context)
    return self.config.center.key ~= "c_pencil_ono99" and can_sell_hook(self, context)
end
