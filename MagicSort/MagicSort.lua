--- STEAMODDED HEADER
--- MOD_NAME: Magic Sort
--- MOD_ID: MagicSort
--- MOD_AUTHOR: [WUOTE]
--- MOD_DESCRIPTION: MagicSort intelligently organizes your hand, saving you countless clicks during mid- to lategame. The mod adds a new sorting button to the menu.
--- BADGE_COLOUR: 708b91
--- PREFIX: magic
--- VERSION: 0.6.9 NICE

-- Global flag to track if magic sort is enabled
_G.MAGIC_SORT_ENABLED = false

local SORT_PRIORITIES = {
    enhancement = {
        m_lucky = 1,
        m_mult = 2,
        m_bonus = 3,
        m_wild = 4,
        m_steel = 5,
        m_glass = 6,
        m_gold = 7,
        m_stone = 8
    },
    edition = {
        e_polychrome = 1,
        e_foil = 2,
        e_holo = 3,
        -- Alternative naming patterns for compatibility
        polychrome = 1,
        foil = 2,
        holo = 3,
        holographic = 3
    },
    seal = {
        Red = 1, Gold = 2, Purple = 3, Blue = 4
    },
    suit = {
        Spades = 1, Hearts = 2, Clubs = 3, Diamonds = 4
    },
    rank = {
        King = 1,
        Queen = 2,
        Jack = 3,
        Ace = 4,
        [10] = 5,
        [9] = 6,
        [8] = 7,
        [7] = 8,
        [6] = 9,
        [5] = 10,
        [4] = 11,
        [3] = 12,
        [2] = 13
    }
}

-- Generate composite sort key
local function get_sort_key(card)
    if not card then return "999999999999999" end

    local keys = { 999, 999, 999, 999, 999 }

    if card.config and card.config.center and card.config.center.key then
        keys[1] = SORT_PRIORITIES.enhancement[card.config.center.key] or 999
    end

    -- Edition priority calc
    if card.edition then
        local edition_priority = 999
        for edition, priority in pairs(SORT_PRIORITIES.edition) do
            if card.edition[edition] then
                edition_priority = math.min(edition_priority, priority)
            end
        end
        keys[2] = edition_priority
    end

    -- Seal priority mapping
    if card.seal then
        keys[3] = SORT_PRIORITIES.seal[card.seal] or 999
    end

    -- Suit hierarchy processing
    if card.base and card.base.suit then
        keys[4] = SORT_PRIORITIES.suit[card.base.suit] or 999
    end

    -- Rank detection and classification
    if card.base and card.base.id then
        local rank = card.base.id

        if type(rank) == "number" then
            if rank >= 2 and rank <= 10 then
                keys[5] = SORT_PRIORITIES.rank[rank] or 999
            elseif rank == 11 then
                keys[5] = SORT_PRIORITIES.rank.Jack or 999
            elseif rank == 12 then
                keys[5] = SORT_PRIORITIES.rank.Queen or 999
            elseif rank == 13 then
                keys[5] = SORT_PRIORITIES.rank.King or 999
            elseif rank == 14 then
                keys[5] = SORT_PRIORITIES.rank.Ace or 999
            end
        elseif type(rank) == "string" then
            keys[5] = SORT_PRIORITIES.rank[rank] or 999
        end
    end

    return string.format("%03d%03d%03d%03d%03d", keys[1], keys[2], keys[3], keys[4], keys[5])
end

-- The Algo
local function magic_sort()
    if not G then return end
    if not G.hand then return end
    if not G.hand.cards then return end
    if #G.hand.cards == 0 then return end

    -- Generate sortable dataset
    local sortable = {}
    for i, card in ipairs(G.hand.cards) do
        if card then
            local sort_key = get_sort_key(card)
            if sort_key then
                table.insert(sortable, {
                    card = card,
                    key = sort_key
                })
            end
        end
    end

    if #sortable == 0 then return end

    -- Execute hierarchical sort algorithm
    table.sort(sortable, function(a, b)
        return a.key < b.key
    end)

    -- Reconstruct optimized hand arrangement
    local new_cards = {}
    for i, item in ipairs(sortable) do
        if item and item.card then
            new_cards[i] = item.card
        end
    end

    -- Apply sorted configuration
    if #new_cards == #G.hand.cards then
        G.hand.cards = new_cards
        if G.hand.align_cards then
            G.hand:align_cards()
        end
    end
end

-- Initialize button functionality
G.FUNCS = G.FUNCS or {}
G.FUNCS.magic_sort_hand = function(e)
    -- Force enable magic sort (no toggle to prevent double-press issues)
    _G.MAGIC_SORT_ENABLED = true

    -- Apply magic sort configuration
    if G.hand and G.hand.config then
        G.hand.config.sort = 'magic'
        magic_sort()
    end

    -- Audio feedback
    if play_sound then
        play_sound('generic1', 0.9, 0.8)
        play_sound('card1', 1.2, 0.8)
    end
end

-- UI integration system
local original_create_UIBox_buttons = create_UIBox_buttons

function create_UIBox_buttons()
    local ret = original_create_UIBox_buttons and original_create_UIBox_buttons()

    if not ret then
        return ret
    end

    -- Inject Magic Sort button during hand selection phase
    if G.STATE == G.STATES.SELECTING_HAND and G.hand and #G.hand.cards > 0 then
        local function find_sort_container(node)
            if node.nodes then
                for i, child in ipairs(node.nodes) do
                    if child.nodes then
                        for j, grandchild in ipairs(child.nodes) do
                            if grandchild.config and grandchild.config.button and
                                (grandchild.config.button == "sort_hand_suit" or grandchild.config.button == "sort_hand_value") then
                                return child
                            end
                        end
                    end
                    local found = find_sort_container(child)
                    if found then return found end
                end
            end
            return nil
        end

        local sort_container = find_sort_container(ret)

        if sort_container and sort_container.nodes then
            -- Create Magic Sort button with consistent styling
            local magic_button = {
                n = G.UIT.C,
                config = {
                    align = "cm",
                    padding = 0.1,
                    r = 0.08,
                    minw = 0.9,
                    minh = 0.4,
                    hover = true,
                    colour = G.C.ORANGE, -- Force orange color always
                    button = "magic_sort_hand",
                    shadow = true
                },
                nodes = {
                    {
                        n = G.UIT.T,
                        config = {
                            text = "Magic",
                            colour = G.C.UI.TEXT_LIGHT,
                            scale = 0.35,
                            shadow = true
                        }
                    }
                }
            }

            table.insert(sort_container.nodes, magic_button)
        else
            -- Fallback Magic Sort interface
            if ret.nodes then
                local magic_row = {
                    n = G.UIT.R,
                    config = { align = "cm", padding = 0.1 },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = {
                                align = "cm",
                                padding = 0.1,
                                r = 0.08,
                                minw = 2.0,
                                minh = 0.6,
                                hover = true,
                                colour = G.C.ORANGE,
                                button = "magic_sort_hand",
                                shadow = true
                            },
                            nodes = {
                                {
                                    n = G.UIT.T,
                                    config = {
                                        text = "MAGIC SORT",
                                        colour = G.C.UI.TEXT_LIGHT,
                                        scale = 0.4,
                                        shadow = true
                                    }
                                }
                            }
                        }
                    }
                }

                table.insert(ret.nodes, magic_row)
            end
        end
    end

    return ret
end

-- Automatic sorting integration hooks
local original_Card_add_to_deck = Card.add_to_deck
Card.add_to_deck = function(self, from_debuff)
    local result = original_Card_add_to_deck(self, from_debuff)

    if _G.MAGIC_SORT_ENABLED and G.hand and self.area == G.hand then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                if _G.MAGIC_SORT_ENABLED then
                    magic_sort()
                end
                return true
            end
        }))
    end

    return result
end

local original_Card_remove_from_deck = Card.remove_from_deck
Card.remove_from_deck = function(self, from_debuff)
    local was_in_hand = (self.area == G.hand)
    local result = original_Card_remove_from_deck(self, from_debuff)

    if _G.MAGIC_SORT_ENABLED and was_in_hand and G.hand then
        G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.1,
            func = function()
                if _G.MAGIC_SORT_ENABLED then
                    magic_sort()
                end
                return true
            end
        }))
    end

    return result
end

-- Enhanced draw integration
if G.FUNCS and G.FUNCS.draw_from_deck_to_hand then
    local original_draw = G.FUNCS.draw_from_deck_to_hand
    G.FUNCS.draw_from_deck_to_hand = function(e)
        local result = original_draw(e)

        if _G.MAGIC_SORT_ENABLED then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.15,
                func = function()
                    if _G.MAGIC_SORT_ENABLED then
                        magic_sort()
                    end
                    return true
                end
            }))
        end

        return result
    end
end

-- Steamodded configuration interface
if SMODS then
    SMODS.current_mod.config_tab = function()
        return {
            n = G.UIT.ROOT,
            config = {
                align = "cm",
                padding = 0.05,
                colour = G.C.CLEAR,
            },
            nodes = {
                {
                    n = G.UIT.T,
                    config = {
                        text = "Magic Sort: Revolutionary hierarchical card organization system.",
                        scale = 0.5,
                        colour = G.C.UI.TEXT_LIGHT
                    }
                },
                {
                    n = G.UIT.T,
                    config = {
                        text = "Automatically sorts by: Enhancement → Edition → Seal → Suit → Rank",
                        scale = 0.4,
                        colour = G.C.UI.TEXT_LIGHT
                    }
                },
                {
                    n = G.UIT.T,
                    config = {
                        text = "Click Magic button once to activate intelligent sorting system.",
                        scale = 0.4,
                        colour = G.C.UI.TEXT_LIGHT
                    }
                }
            }
        }
    end
end
