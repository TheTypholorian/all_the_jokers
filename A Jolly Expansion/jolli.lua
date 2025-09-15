SMODS.Atlas {
    key = "JolliMod",
    path = "JolliMod.png",
    px = 71,
    py = 95,
}

SMODS.Atlas {
    key = "seal_atlas",
    path = "modded_seal.png",
    px = 71,
    py = 95
}

SMODS.Joker {
    key = 'trashquatch',
    loc_txt = {
        name = 'Trash-Quatch',
        text = {
            "This Joker gains {C:chips}+#1#{} Chips",
            "for each {C:attention}2{}, {C:attention}3{} and {C:attention}4{}",
            "in hand at end of round.",
            "{C:inactive}(Currently {C:chips}+#2#{C:inactive} Chips)"
        }
    },
    config = {
        extra = {
            chips = 0,
            chip_mod = 10
        }
    },
    loc_vars = function(self, infoqueue, card)
        return { vars = { card.ability.extra.chip_mod, card.ability.extra.chips } }
    end,
    rarity = 1,
    atlas = "JolliMod",
    pos = {
        x = 0,
        y = 0,
    },
    cost = 5,
    calculate = function(self, card, context)
        if
        context.end_of_round and
        context.individual and
        context.cardarea == G.hand and
        not context.other_card.debuff and
        not context.blueprint
        then
            if context.other_card:get_id() >= 2 and context.other_card:get_id() <= 4 then
                card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.chip_mod
                return {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.CHIPS,
                    card = card
                }
            end
        end
        if context.joker_main and card.ability.extra.chips > 0 then
            return {
                message = localize{type='variable',key='a_chips',vars={card.ability.extra.chips}},
                chip_mod = card.ability.extra.chips,
                colour = G.C.CHIPS
            }
        end
    end,
}

SMODS.Joker {
    key = "gangstapermit",
    loc_txt = {
        name = "Gangsta Permit",
        text = {
            "If all cards in played poker hand",
            "are {C:red}Debuffed{}, gain {C:mult}+#1#{} Mult",
            "and score played cards normally."
        }
    },
    config = { extra = { mult = 15 } },
    rarity = 2,
    cost = 6,
    atlas = "JolliMod",
    pos = {
        x = 3,
        y = 0,
    },
    loc_vars = function(self, infoqueue, card)
        return { vars = { card.ability.extra.mult, card.ability.extra.hand, card.ability.extra.all_debuffed,} }
    end,
    calculate = function(self, card, context)
        if context.before
        then
            card.ability.extra.hand = context.scoring_hand
            card.ability.extra.all_debuffed = true
            for _, v in ipairs(context.scoring_hand) do
                if not v.debuff then
                    card.ability.extra.all_debuffed = false
                end
            end
            if card.ability.extra.all_debuffed then
                for _, v in ipairs(context.scoring_hand) do
                    v.debuff = false
                end
                return{
                    mod_mult = card.ability.extra.mult,
                    message = localize { type = 'variable', key = 'a_mult', vars = {card.ability.extra.mult}}
                }
            end
        end
    end
}

SMODS.Joker {
    key = "fetchquester",
    loc_txt = {
        name = 'Fetch Quester',
        text = {
            "{C:red}+#1#{} hand size for",
            "each {C:attention}Ace{} discarded",
            "before a hand is played."
        }
    },
    config = { extra = { hand_size = 1, size_dif = 0 } },
    rarity = 1,
    cost = 4,
    atlas = "JolliMod",
    pos = {
        x = 1,
        y = 0,
    },
    loc_vars = function (self, infoqueue, card)
        return { vars = { card.ability.extra.hand_size, card.ability.extra.size_dif }}
    end,
    calculate = function (self, card, context)
        if
        context.discard and
        not context.other_card.debuff and
        context.other_card:get_id() == 14 and
        not context.blueprint
        then
            G.hand:change_size(card.ability.extra.hand_size)
            card.ability.extra.size_dif = card.ability.extra.size_dif - card.ability.extra.hand_size
            return {
                message = 'Ruff!',
                card = card
            }
        end
        if context.before and
        card.ability.extra.size_dif < 0 then
            G.hand:change_size(card.ability.extra.size_dif)
            card.ability.extra.size_dif = 0
            return {
                card = card
            }
        end
    end,
    remove_from_deck = function (self, card, from_debuff)
        if card.ability.extra.size_dif < 0 then
            G.hand:change_size(card.ability.extra.size_dif)
        end
    end
}

SMODS.Joker {
    key = "spaceshaft",
    loc_txt = {
        name = 'Funny Penis Ship',
        text = {
            "After defeating the {C:attention}Boss Blind{},",
            "receive a {C:attention}Wheel of Fortune{}."
        }
    },
    rarity = 1,
    cost = 4,
    atlas = "JolliMod",
    pos = {
        x = 2,
        y = 0,
    },
    config = { extra = 0 },
    calculate = function (self, card, context)
        if
        context.end_of_round and
        not context.repetition and
        not context.individual and
        G.GAME.blind.boss
        then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        local card = create_card('Tarot', G.consumeables, nil, nil, nil, nil, 'c_wheel_of_fortune', 'spaceshaft')
                        card:add_to_deck()
                        G.consumeables:emplace(card)
                        return true
                    end)}))
                -- card_eval_status_text(context.blueprint_card or card, 'extra', nil, nil, nil)
                return {
                    message = "NEW GAMBA!!!",
                    card = card
                }
            end
        end
    end
}

SMODS.Joker {
    key = "vandalisedposter",
    loc_txt = {
        name = "Vandalised Joker",
        text = {
            "{C:mult}+4{} Mult. Sneak 2 random",
            "playing cards into your opening",
            "hand at the beginning of {C:attention}Small{}",
            "and {C:attention}Big Blinds{} to keep."
        }
    },
    rarity = 2,
    cost = 5,
    atlas = "JolliMod",
    pos = {
        x = 5,
        y = 0,
    },
    config = { extra = { mult = 4 } },
    loc_vars = function (self, infoqueue, card)
        return { vars = { card.ability.extra.mult }}
    end,
    calculate = function (self, card, context)
        if
        context.first_hand_drawn and
        not G.GAME.blind.boss
        then
            G.E_MANAGER:add_event(Event({
                func = function() 
                    local _card1 = create_playing_card({
                        front = pseudorandom_element(G.P_CARDS, pseudoseed('vandal1')),
                        center = G.P_CENTERS.c_base}, G.hand, nil, nil, nil)
                    local _card2 = create_playing_card({
                        front = pseudorandom_element(G.P_CARDS, pseudoseed('vandal2')),
                        center = G.P_CENTERS.c_base}, G.hand, nil, nil, nil)
                    G.GAME.blind:debuff_card(_card1)
                    G.GAME.blind:debuff_card(_card2)
                    G.hand:sort()
                    return true
                end}))
            playing_card_joker_effects({true})
        end
        if
        context.joker_main
        then
            return {
                message = localize{type='variable',key='a_mult',vars={card.ability.extra.mult}},
                mult_mod = card.ability.extra.mult,
            }
        end
    end
}

SMODS.Joker {
    key = "badbambino",
    loc_txt = {
        name = "Bad Bambino",
        text = {
            "Skips to payout if sold during",
            "a {C:attention}Small Blind{}.",
        }
    },
    rarity = 2,
    cost = 3,
    atlas = "JolliMod",
    pos = {
        x = 4,
        y = 0,
    },
    eternal_compat = false,
    remove_from_deck = function (self, card, from_debuff)
        if
        G.GAME.blind.name == "Small Blind"
        then
            if G.STATE ~= G.STATES.SELECTING_HAND then
                return
            end
            G.GAME.chips = G.GAME.blind.chips
            G.STATE = G.STATES.HAND_PLAYED
            G.STATE_COMPLETE = true
            end_round()
        end
    end
}

SMODS.Seal {
    name = "Squirrel",
    key = "squirrel",
    badge_colour = HEX("CF5D00"),
	config = { odds = 7 },
    loc_txt = {
        label = 'Squirrel',
        name = 'Squirrel',
        text = {
            "{C:green}#1# in #2#{} chance of",
            "adding a permanant copy (without squirrel)",
            "to deck and drawing it to hand."
        }
    },
    loc_vars = function(self, info_queue)
        return { vars = {(G.GAME.probabilities.normal or 1), self.config.odds} }
    end,
    calculate = function(self, card, context)
        if context.main_scoring and
        context.cardarea == G.play and
        not self.debuff and
        pseudorandom('sqeak') < G.GAME.probabilities.normal / self.config.odds then
            local _card = copy_card(card, nil, nil, G.playing_card)
            _card:set_seal(nil, nil, nil)
            _card:add_to_deck()
            G.deck.config.card_limit = G.deck.config.card_limit + 1
            table.insert(G.playing_cards, _card)
            G.hand:emplace(_card)
            _card.states.visible = nil

            G.E_MANAGER:add_event(Event({
                func = function()
                    _card:start_materialize()
                    return true
                end
            })) 
                return {
                        message = "...",
                        colour = G.C.MULT
                    }
        end
    end,
    atlas = "seal_atlas",
    pos = {x=0, y=0},
}

SMODS.Joker {
    key = "nuts4u",
    loc_txt = {
        name = "Nuts 4 U",
        text = {
            "Whenever you play a {C:attention}Queen{},",
            "give it a squirrel stamp. This",
            "Joker gains {X:mult,C:white} X#1# {} Mult for each",
            "squirrel stamp applied this run.",
            "{C:inactive}[Currently {X:mult,C:white} X#2# {C:inactive} Mult]{}",
            "{s:0.5,C:inactive}(may summon god){}",
        }
    },
    config = { extra = { mod = 0.25, mult_mod = 1} },
    rarity = 3,
    cost = 8,
    atlas = "JolliMod",
    pos = {
        x = 0,
        y = 1,
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mod, card.ability.extra.mult_mod} }
    end,
    calculate = function (self, card, context)
        if context.cardarea == G.play and
        context.individual then
            if context.other_card:get_id() == 12 and
            context.other_card:get_seal() ~= "jolli_squirrel"
            then
                local queen = context.other_card
                G.E_MANAGER:add_event(Event({func = function()
                    play_sound('tarot1')
                    queen:juice_up(0.3, 0.5)
                    return true end }))
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.1, func = function()
                    queen:set_seal('jolli_squirrel', nil, true)
                    return true end }))

                card.ability.extra.mult_mod = card.ability.extra.mult_mod + card.ability.extra.mod
                return{
                    message = localize('k_upgrade_ex'),
                    colour = G.C.MULT,
                    card = card
                }
            end
        end
        if context.joker_main and card.ability.extra.mult_mod > 1 then
            return
            {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.mult_mod }},
                Xmult_mod = card.ability.extra.mult_mod,
                colour = G.C.MULT
            }

        end
    end

}

SMODS.Joker {
    key = "tinyglade",
    loc_txt = {
        name = "TINY GLADE!",
        text = {
            "When a single {C:attention}#1# of #2#{} is played,",
            "apply {C:chips}+#3#{} Chips and {C:mult}+#4#{} Mult before",
            "scoring and destroy this. At the end",
            "of round, this card {C:attention}doubles its values{}",
            "and swaps the rank and suit."
        }
    },
    rarity = 3,
    cost = 8,
    atlas = "JolliMod",
    pos = {
        x = 1,
        y = 1,
    },
    config = { extra = { chips = 60, mult = 8}},
    loc_vars = function(self, info_queue, card)
        return { vars = {
            G.GAME.current_round.tiny_card.rank,
            G.GAME.current_round.tiny_card.suit,
            card.ability.extra.chips,
            card.ability.extra.mult } }
    end,
    eternal_compat = false,
    perishable_compat = false,
    calculate = function (self, card, context)
        if
        context.individual and
        context.cardarea == G.play then
            if #context.full_hand == 1 and
            context.full_hand[1]:get_id() == G.GAME.current_round.tiny_card.id and
            context.full_hand[1]:is_suit(G.GAME.current_round.tiny_card.suit) and
            not context.blueprint then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound('tarot1')
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        -- This part destroys the card.
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil
                                return true;
                            end
                        }))
                        return true
                    end
                }))
                return {
                    message = "FINALLY!!",
                    colour = G.C.CHIPS,
                    chip_mod = card.ability.extra.chips,
                    mult_mod = card.ability.extra.mult
                }
            end
        end
        if context.end_of_round and
        context.cardarea == G.jokers and
        not context.game_over and
        not context.blueprint then
            card.ability.extra.chips = card.ability.extra.chips * 2
            card.ability.extra.mult = card.ability.extra.mult * 2
            return {
                message = localize('k_upgrade_ex'),
                colour = G.C.CHIPS,
                card = card
            }
        end
    end
}

SMODS.Joker {
    key = "lifetime",
    loc_txt = {
        name = "Same as it Ever Was...",
        text = {
            "If your deck contains the same number",
            "as it always has ({C:attention}#1#{} cards), gain",
            "{X:mult,C:white}#2#x{} Mult. {C:attention}Doubles{} effect if all are base.",
            "{C:inactive}(cards: {C:attention}#4#{C:inactive} | base: {C:attention}#5#{C:inactive})"
        }
    },
    rarity = 3,
    cost = 8,
    atlas = "JolliMod",
    pos = {
        x = 2,
        y = 1,
    },
    config = { extra = { mult_mod = 2 }},
    loc_vars = function (self, info_queue, card)
        card.ability.lifetime_tally = 0
        if G.playing_cards ~= nil then
            card_count = #G.playing_cards
            for k, v in pairs(G.playing_cards) do
                if v.config.center == G.P_CENTERS.c_base then
                    card.ability.lifetime_tally = card.ability.lifetime_tally + 1
                end
            end
        else
            card_count = 0
        end
        return { vars = {G.GAME.starting_deck_size, card.ability.extra.mult_mod, card.ability.extra.mult_mod*2, card_count, card.ability.lifetime_tally}}
    end,
    calculate = function(self,card,context)
        if context.joker_main and
        G.GAME.starting_deck_size == #G.playing_cards then
            if card.ability.lifetime_tally == #G.playing_cards then
                return {
                    message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.mult_mod*2 }},
                    Xmult_mod = card.ability.extra.mult_mod *2,
                    colour = G.C.MULT
                }
            end
            return {
                message = localize { type = 'variable', key = 'a_xmult', vars = { card.ability.extra.mult_mod }},
                Xmult_mod = card.ability.extra.mult_mod,
                colour = G.C.MULT
            }
        end
    end
}

local igo = Game.init_game_object
function Game:init_game_object()
    local ret = igo(self)
    ret.current_round.tiny_card = {id = 14, rank = "Ace", suit = "Spades"}
    return ret
end

function SMODS.current_mod.reset_game_globals(run_start)
    G.GAME.current_round.tiny_card = {id = 14, rank = "Ace", suit = "Spades"}
    local valid_tiny_cards = {}
    for _, v in ipairs(G.playing_cards) do
        if not SMODS.has_no_suit(v) then
            valid_tiny_cards[#valid_tiny_cards+1] = v
        end
    end
    if valid_tiny_cards[1] then
        local new_tiny = pseudorandom_element(valid_tiny_cards, pseudoseed("tiny"..G.GAME.round_resets.ante))
        G.GAME.current_round.tiny_card.rank = new_tiny.base.value
        G.GAME.current_round.tiny_card.id = new_tiny.base.id
        G.GAME.current_round.tiny_card.suit = new_tiny.base.suit
    end
end