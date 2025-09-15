local jd_def = JokerDisplay.Definitions

-- Sora
jd_def["j_kh_sora"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "x_mult" }
            }
        }
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = lighten(G.C.SUITS["Hearts"], 0.35) },
        { text = ")" }
    },
    calc_function = function(card)
        card.joker_display_values.localized_text = localize("Hearts", 'suits_plural')
    end
}

-- Riku
jd_def["j_kh_riku"] = {
    text = {
        { ref_table = "card.joker_display_values", ref_value = "most_played", colour = G.C.CHIPS }
    },

    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "counter" },
        { text = "/" },
        { ref_table = "card.ability.extra", ref_value = "total" },
        { text = ")" },
    },
    calc_function = function(card)
        local _handname, _played, _order = 'High Card', -1, 100
        for k, v in pairs(G.GAME.hands) do
            if v.played > _played or (v.played == _played and _order > v.order) then
                _played = v.played
                _handname = k
            end
        end
        card.ability.extra.most_played = _handname
        card.ability.extra.old_most_played = card.ability.extra.most_played
        card.joker_display_values.most_played = card.ability.extra.most_played
    end
}

-- Kairi/Namine
jd_def["j_kh_kairi"] = {

    text = {
        { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
        { text = ", " },
        { ref_table = "card.joker_display_values", ref_value = "mult",  colour = G.C.MULT },

    },
    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "localized_text", },
        { text = "," },
        { ref_table = "card.joker_display_values", ref_value = "localised_text", },
    },
    calc_function = function(card)
        local chips = card.ability.extra.chips or 0
        local mult = card.ability.extra.mult or 0

        card.joker_display_values.chips = (chips >= 0 and "+" or "") .. tostring(chips)
        card.joker_display_values.mult = (mult >= 0 and "+" or "") .. tostring(mult)

        local side = card.ability.extra.side
        card.joker_display_values.localized_text = side == "B" and "Dark Suits" or "Light Suits"
        card.joker_display_values.localised_text = side == "B" and "Mult" or "Chips"
    end,
    style_function = function(card, text, reminder_text, extra)
        local side = card.ability.extra.side

        if reminder_text and reminder_text.children then
            for _, child in ipairs(reminder_text.children) do
                if child.config and child.config.ref_value then
                    if child.config.ref_value == "localized_text" then
                        -- "Dark Suit" or "Light Suit" color
                        child.config.colour = (side == "B") and G.C.BLUE or G.C.SUITS.Diamonds
                    elseif child.config.ref_value == "localised_text" then
                        -- "Mult" or "Chips" color
                        child.config.colour = (side == "B") and G.C.MULT or G.C.CHIPS
                    end
                end
            end
        end

        return false
    end
}

-- Roxas
jd_def["j_kh_roxas"] = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
    },
    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "discards_remaining" },
        { text = "/" },
        { ref_table = "card.ability.extra", ref_value = "discards" },
        { text = ")" },
    },

}

-- Bryce the Nobody
jd_def["j_kh_brycethenobody"] = {

    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = lighten(G.C.SUITS["Hearts"], 0.35) },
        { text = ")" }
    },
    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },
    extra_config = { colour = G.C.GREEN, scale = 0.3 },
    calc_function = function(card)
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { card.ability.extra.base, card.ability.extra.odds } }
        card.joker_display_values.localized_text = localize("Hearts", "suits_plural")
    end
}

--Axel
jd_def["j_kh_axel"] = {
    text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "compatibility", colour = G.C.RED },
        { text = ")" },
    },

    reminder_text = {
        { text = "(boss blind)" }
    },

    calc_function = function(card)
        card.joker_display_values = card.joker_display_values or {}
        local target = G.jokers.cards[1]
        local is_excluded = Exclude_list[target.ability.name]

        if target and target ~= card then
            if is_excluded or target.ability.perishable then
                card.joker_display_values.compatibility = localize('k_incompatible')
            else
                card.joker_display_values.compatibility = localize('k_compatible')
            end
        else
            card.joker_display_values.compatibility = localize('k_incompatible')
        end
    end,

    style_function = function(card, text, reminder_text, extra)
        if text and text.children then
            for _, child in ipairs(text.children) do
                if child.config and child.config.ref_value == "compatibility" then
                    local val = card.joker_display_values.compatibility
                    if val == localize("k_compatible") then
                        child.config.colour = G.C.GREEN
                    else
                        child.config.colour = G.C.RED
                    end
                end
            end
        end
        return false
    end,
}

-- Xigbar
jd_def["j_kh_xigbar"] = {

    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips", retrigger_type = "chips", colour = G.C.CHIPS }
    },

    calc_function = function(card)
        card.joker_display_values = card.joker_display_values or {}

        local _, _, scoring_hand = JokerDisplay.evaluate_hand(JokerDisplay.current_hand)
        local scoring = {}
        for _, c in ipairs(scoring_hand) do
            scoring[c] = true
        end

        local count = 0
        for _, c in ipairs(JokerDisplay.current_hand or {}) do
            if not scoring[c] and c:is_face() then
                count = count + 1
            end
        end

        card.joker_display_values.chips = count * (card.ability.extra.chips_gain or 0)
        card.ability.force_joker_display_update = true
    end

}

-- Mickey
jd_def["j_kh_mickey"] = {
    text = {
        { text = "+" },
        { ref_table = "card.ability.extra", ref_value = "chips", colour = G.C.CHIPS },
        { text = ", " },
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "x_mult" }
            },
        },

    },

    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },

    extra_config = { colour = G.C.GREEN, scale = 0.3 },

    calc_function = function(card)
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { card.ability.extra.base, card.ability.extra.odds } }
    end,
}

-- Donald
jd_def["j_kh_donald"] = {

    text = {
        {
            ref_table = "card.joker_display_values",
            ref_value = "copied_name",
            colour = G.C.ATTENTION,
            newline = true,
        }
    },

    calc_function = function(card)
        local copied_joker_key = card.ability.extra.copied_joker_key
        local copied_name = "[None]"
        local blueprint_status = ""

        if G.jokers then
            local function getJokerByKey(jokers, key)
                for _, joker in ipairs(jokers) do
                    if joker.config.center.key == key then
                        return joker
                    end
                end
                return nil
            end

            local copied_joker = getJokerByKey(G.jokers.cards, copied_joker_key)
            if copied_joker then
                copied_name = copied_joker.config.center.name or "Unknown"
                blueprint_status = copied_joker.config.center.blueprint_compat and "[compatible]" or "[incompatible]"
            else
                blueprint_status = ""
            end
        end

        card.joker_display_values.copied_name = copied_name
        card.joker_display_values.blueprint_status = blueprint_status
    end
}

-- Goofy
jd_def["j_kh_goofy"] = {
    text = {
        {
            border_nodes = {
                { text = "X" },
                { ref_table = "card.ability.extra", ref_value = "Xmult" }
            },
            colour = G.C.MULT
        },
        { text = ", " },
        { ref_table = "card.joker_display_values", ref_value = "dollars", colour = G.C.MONEY, },
    },

    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "mult",  colour = G.C.MULT, },
        { text = ", " },
        { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
    },

    calc_function = function(card)
        local extra = card.ability.extra or {}
        card.joker_display_values.mult = string.format("+%d", extra.mult)
        card.joker_display_values.chips = string.format("+%d", extra.chips)
        card.joker_display_values.dollars = string.format("+$%d", extra.dollars)
    end,
}

-- Master Yen Sid
jd_def["j_kh_disney"] = {

    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },

    extra_config = { colour = G.C.GREEN, scale = 0.3 },

    calc_function = function(card)
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { card.ability.extra.base, card.ability.extra.odds } }
    end,
}

-- Keyblade
jd_def["j_kh_keyblade"] = {

    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "count", retrigger_type = "mult" }
    },

    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "keyblade_card", scale = 0.35 },
        { text = ")" },
    },

    calc_function = function(card)
        local _, _, scoring_hand = JokerDisplay.evaluate_hand()
        local keyblade_eval = #scoring_hand == 1 and scoring_hand[1]:get_id() == G.GAME.current_round.keyblade_rank.id
        card.joker_display_values.active = G.GAME and G.GAME.current_round.hands_played == 0
        card.joker_display_values.count = keyblade_eval and 1 or 0

        card.joker_display_values.keyblade_card = localize(G.GAME.current_round.keyblade_rank.rank, 'ranks')
    end,
    style_function = function(card, text, reminder_text, extra)
        if text and text.children[1] and text.children[2] then
            text.children[1].config.colour = card.joker_display_values.active and G.C.SECONDARY_SET.Spectral or
                G.C.UI.TEXT_INACTIVE
            text.children[2].config.colour = card.joker_display_values.active and G.C.SECONDARY_SET.Spectral or
                G.C.UI.TEXT_INACTIVE
        end
        return false
    end
}


-- Paopu Fruit
jd_def["j_kh_paopufruit"] = {

    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "localized_text", colour = lighten(G.C.SUITS["Diamonds"], 0.35) },
        { text = ")" }
    },

    extra = {
        {
            { text = "(" },
            { ref_table = "card.joker_display_values", ref_value = "odds" },
            { text = ")" },
        }
    },

    extra_config = { colour = G.C.GREEN, scale = 0.3 },

    calc_function = function(card)
        card.joker_display_values.odds = localize { type = 'variable', key = "jdis_odds", vars = { card.ability.extra.base, card.ability.extra.odds } }
        card.joker_display_values.localized_text = localize("Diamonds", "suits_plural")
    end
}


-- Seal Salt Ice Cream
jd_def["j_kh_sealsalt"] = {

    text = {
        { text = "(Blue Seal)", scale = 0.35, colour = G.C.SECONDARY_SET.Planet },
    },
}



-- Nobody
jd_def["j_kh_nobody"] = {

    text = {
        { text = "+" },
        { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
    },

    reminder_text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "suit_count" },
        { text = " suits",                         scale = 0.35,            colour = G.C.PURPLE },
        { text = ")" },
    },

    calc_function = function(card)
        local d = card.joker_display_values
        local extra = card.ability.extra or {}

        -- Default values
        d.chips = extra.chips or 0
        d.suit_count = 0

        -- Try to evaluate upcoming or last scoring hand
        local _, _, scoring_hand = JokerDisplay.evaluate_hand()
        if scoring_hand then
            local suits = {}
            for _, v in ipairs(scoring_hand) do
                if v.base and v.base.suit then
                    suits[v.base.suit] = true
                end
            end

            local unique_suits = 0
            for _ in pairs(suits) do
                unique_suits = unique_suits + 1
            end

            d.suit_count = unique_suits
        end
    end
}

-- Moogle
jd_def["j_kh_moogle"] = {

    text = {
        {
            ref_table = "card.joker_display_values",
            ref_value = "joker_count",
            scale = 0.40,
            colour = G.C.MONEY,
            newline = true
        }
    },

    reminder_text = {
        { text = "(Round)" }
    },

    calc_function = function(card)
        local joker_count = 0
        if G.jokers and G.jokers.cards then
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i].ability.set == 'Joker' then
                    joker_count = joker_count + 1
                end
            end
        end
        card.joker_display_values.joker_count = string.format("+$%d", card.ability.extra.dollars * joker_count)
    end
}

-- Gummi Phone
jd_def["j_kh_chipanddale"] = {

    text = {
        { text = "Creates " },
        { ref_table = "card.ability.extra", ref_value = "creates" },
    },

    reminder_text = {
        { text = "(" },
        { ref_table = "card.ability.extra", ref_value = "mini_rounds" },
        { text = "/" },
        { ref_table = "card.ability.extra", ref_value = "total_rounds" },
        { text = ")" },
    },

}

-- Luxord
jd_def["j_kh_luxord"] = {

    text = {
        { text = "(" },
        { ref_table = "card.joker_display_values", ref_value = "chips", colour = G.C.CHIPS },
        { text = "/" },
        { ref_table = "card.joker_display_values", ref_value = "cap",   colour = G.C.UI.ATTENTION },
        { text = ")" },
    },

    calc_function = function(card)
        card.joker_display_values = card.joker_display_values or {}
        card.joker_display_values.chips = string.format("+%d", card.ability.chips)
        card.joker_display_values.cap = tostring(card.ability.cap)
    end,
}

-- Kingdom Hearts Trilogy
jd_def["j_kh_khtrilogy"] = {

    text = {
        { ref_table = "card.joker_display_values", ref_value = "value", colour = G.C.CHIPS }
    },

    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "open" },
        { ref_table = "card.joker_display_values", ref_value = "counter" },
        { ref_table = "card.joker_display_values", ref_value = "slash" },
        { ref_table = "card.joker_display_values", ref_value = "total" },
        { ref_table = "card.joker_display_values", ref_value = "close" },
    },

    calc_function = function(card)
        local d = card.joker_display_values
        local extra = card.ability.extra or {}
        d.value = ""

        if extra.level == 1 then
            d.value = string.format("+%d", extra.chips)
        elseif extra.level == 2 then
            d.value = string.format("+%d", extra.mult)
        elseif extra.level == 3 then
            d.prefix = ""
            d.value = "X" .. tostring(extra.xmult or 0)
        end

        if extra.level < 3 then
            d.counter = tostring(extra.counter or 0)
            d.total = tostring(extra.total or 0)
            d.open = "("
            d.close = ")"
            d.slash = "/"
        else
            d.counter = ""
            d.total = ""
            d.slash = "Max"
        end
    end,
    style_function = function(card, text, reminder_text, extra)
        -- Adjust value color depending on level
        local level = card.ability.extra.level or 1
        if text and text.children and #text.children >= 1 then
            local colour = (level == 1 and G.C.CHIPS) or
                (level == 2 and G.C.RED) or
                (level == 3 and G.C.XMULT)
            text.children[1].config.colour = colour
        end
        return false
    end
}

-- Help Wanted!
jd_def["j_kh_helpwanted"] = {

    text = {
        { ref_table = "card.joker_display_values", ref_value = "task_desc", colour = G.C.BLUE },
    },

    reminder_text = {
        { ref_table = "card.joker_display_values", ref_value = "progress", colour = G.C.UI.TEXT_INACTIVE },
    },

    calc_function = function(card)
        card.joker_display_values = card.joker_display_values or {}

        local task = card.ability.current_task
        local prog = card.ability.progress or 0
        local task_desc = "loading..."
        local progress = "loading..."

        if task == "play_face" then
            task_desc = "Grand Stander"
            progress = "(" .. prog .. "/15)"
        elseif task == "destroy_cards" then
            task_desc = "Cargo Climb"
            progress = "(" .. prog .. "/7)"
        elseif task == "selling" then
            task_desc = "Mail Delivery"
            progress = "(" .. prog .. "/13)"
        elseif task == "skipping" then
            task_desc = "Junk Sweep"
            progress = "(" .. prog .. "/4)"
        elseif card.ability.current_task == "shopping" then
            local spent = card.ability.money_spent or 0
            task_desc = "Poster Duty"
            progress = "($" .. spent .. "/30)"
        end

        card.joker_display_values.task_desc = task_desc
        card.joker_display_values.progress = progress
    end,
}
