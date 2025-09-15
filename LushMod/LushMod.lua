--- STEAMODDED HEADER
--- MOD_NAME: LushMod
--- MOD_ID: LushMod
--- MOD_AUTHOR: [lusciousdev]
--- MOD_DESCRIPTION: Various new Jokers
----------------------------------------------
------------MOD CODE -------------------------
function table_length(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

function SMODS.INIT.LushMod()
    local lushJokers = {
        j_jokester  = { order = 1,  unlocked = true, discovered = true, blueprint_compat = true,  eternal_compat = true, rarity = 3, cost = 8, name = "The Jokester",      set = "Joker", config = { extra = 0.2, Xmult = 1 },              pos = { x = 0, y = 16 } },
        j_brethren  = { order = 2,  unlocked = true, discovered = true, blueprint_compat = true,  eternal_compat = true, rarity = 3, cost = 8, name = "The Brethren",      set = "Joker", config = { extra = 2 },                           pos = { x = 1, y = 16, } },
        j_trickster = { order = 3,  unlocked = true, discovered = true, blueprint_compat = false, eternal_compat = true, rarity = 3, cost = 8, name = "The Trickster",     set = "Joker", config = { extra = {}, },                         pos = { x = 2, y = 16, }, },
        j_top5      = { order = 4,  unlocked = true, discovered = true, blueprint_compat = true,  eternal_compat = true, rarity = 2, cost = 6, name = "Top 5",             set = "Joker", config = { extra = { chips = 4, chip_mod = 2 } }, pos = { x = 3, y = 16 } },
        j_buffer    = { order = 5,  unlocked = true, discovered = true, blueprint_compat = true,  eternal_compat = true, rarity = 1, cost = 4, name = "The Buffer",        set = "Joker", config = { extra = { mult = 15 } },               pos = { x = 4, y = 16 } },
        j_amazin    = { order = 6,  unlocked = true, discovered = true, blueprint_compat = true,  eternal_compat = true, rarity = 1, cost = 4, name = "Amazin' Joker",     set = "Joker", config = { extra = { chips = 25 } },              pos = { x = 5, y = 16 } },
        j_hue       = { order = 7,  unlocked = true, discovered = true, blueprint_compat = true,  eternal_compat = true, rarity = 2, cost = 6, name = "Hue Graph",         set = "Joker", config = { extra = 3 },                           pos = { x = 6, y = 16 } },
        j_wizard    = { order = 8,  unlocked = true, discovered = true, blueprint_compat = true,  eternal_compat = true, rarity = 1, cost = 5, name = "Cloud Wizard",      set = "Joker", config = { extra = 1 },                           pos = { x = 7, y = 16 } },
        j_timely    = { order = 9,  unlocked = true, discovered = true, blueprint_compat = true,  eternal_compat = true, rarity = 2, cost = 6, name = "Timely Lion",       set = "Joker", config = { extra = { mult = 12 } },               pos = { x = 8, y = 16 } },
        j_seven     = { order = 10, unlocked = true, discovered = true, blueprint_compat = true,  eternal_compat = true, rarity = 1, cost = 4, name = "Seven Seven Seven", set = "Joker", config = { extra = 3 },                           pos = { x = 9, y = 16 } },
    }

    -- Localization
    local jokerLocalization = {
        j_jokester = {
            name = "The Jokester",
            text = {"{X:mult,C:white} X#1# {} Mult per", "Joker added.",
                    "{C:inactive}(Currently {X:mult,C:white} X#2# {C:inactive} Mult)"}
        },
        j_brethren = {
          name = "The Brethren",
          text = { "{C:green}#1# in #2#{} chance to", "convert the pair in a", "{C:attention}Full House{} to the rank", "of the other 3 cards" }
        },
        j_trickster = {
          name = "The Trickster",
          text = { "When {C:attention}Blind{} is selected,", "reroll the Joker to the", "right into a new Joker", "of the same rarity" }
        },
        j_top5 = {
            name = "Top 5",
            text = {"Doubles Chips if first", "played hand is a {C:attention}Straight{}",
                    "containing an {C:attention}Ace{} and a {C:attention}5{} ",
                    "{C:inactive}(Currently {C:chips}#1#{C:inactive} Chips)"}
        },
        j_buffer = {
            name = "The Buffer",
            text = {"{C:mult}+#1#{} Mult if", "played hand", "contains a {C:attention}5{}"}
        },
        j_amazin = {
          name = "Amazin' Joker",
          text = { "Each {C:attention}Ace{}", "held in hand", "gives {C:chips}+#1#{} Chips" }
        },
        j_hue = {
          name = "Hue Graph",
          text = { "If {C:attention}first discard{} of round is", "a flush, {C:green}#1# in #2#{} chance", " to destroy each discarded card."}
        },
        j_wizard = {
          name = "Cloud Wizard",
          text = { "Earn {C:money}$1{} for each", "{C:purple}Tarot{} card used." }
        },
        j_timely = {
          name = "Timely Lion",
          text = { "{C:mult}+#1#{} Mult on {C:attention}first{}", "and {C:attention}final{} hand", "of round." }
        },
        j_seven = {
          name = "Seven Seven Seven",
          text = {
            "Create a {C:attention}random 7{}",
            "if played hand contains",
            "{C:attention}#1#{} or more {C:attention}7s{}",
          }
        },
    }

    addJokersToPools(lushJokers)
    updateLocalization(jokerLocalization)

    -- Add sprites
    local lushmod = SMODS.findModByID("LushMod")
    local sprite_lushmod = SMODS.Sprite:new("Joker", lushmod.path, "Jokers_LushMod.png", 71, 95, "asset_atli")

    sprite_lushmod:register()
end

-- Joker abilities
local set_abilityref = Card.set_ability
function Card.set_ability(self, center, initial, delay_sprites)
    return set_abilityref(self, center, initial, delay_sprites)
end

local calculate_jokerref = Card.calculate_joker
function Card.calculate_joker(self, context)
    local calc_ref = calculate_jokerref(self, context)

    if self.ability.set == "Joker" and not self.debuff then
        if self.ability.name == "Blueprint" then
            local other_joker = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == self then
                    other_joker = G.jokers.cards[i + 1]
                end
            end
            if other_joker and other_joker ~= self then
                context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
                context.blueprint_card = context.blueprint_card or self
                if context.blueprint > #G.jokers.cards + 1 then
                    return
                end
                local other_joker_ret = other_joker:calculate_joker(context)
                if other_joker_ret then
                    other_joker_ret.card = context.blueprint_card or self
                    other_joker_ret.colour = G.C.BLUE
                    return other_joker_ret
                end
            end
        end
        if self.ability.name == "Brainstorm" then
            local other_joker = G.jokers.cards[1]
            if other_joker and other_joker ~= self then
                context.blueprint = (context.blueprint and (context.blueprint + 1)) or 1
                context.blueprint_card = context.blueprint_card or self
                if context.blueprint > #G.jokers.cards + 1 then
                    return
                end
                local other_joker_ret = other_joker:calculate_joker(context)
                if other_joker_ret then
                    other_joker_ret.card = context.blueprint_card or self
                    other_joker_ret.colour = G.C.RED
                    return other_joker_ret
                end
            end
        end
        
        if context.open_booster then
        elseif context.buying_card then
        elseif context.selling_self then
        elseif context.selling_card then
        elseif context.reroll_shop then
        elseif context.ending_shop then
        elseif context.skip_blind then
        elseif context.skipping_booster then
        elseif context.playing_card_added and not self.getting_sliced then
        elseif context.first_hand_drawn then
          if self.ability.name == 'Hue Graph' and not context.blueprint then
              local eval = function() return G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES end
              juice_card_until(self, eval, true)
          end
        elseif context.setting_blind and not self.getting_sliced and not self.gettin_rerolled then
          if self.ability.name == "The Trickster" and not context.blueprint then
            local my_pos = nil
            for i = 1, #G.jokers.cards do
              if G.jokers.cards[i] == self then my_pos = i; break end
            end

            if my_pos and G.jokers.cards[my_pos + 1] and not self.getting_sliced and not G.jokers.cards[my_pos + 1].ability.eternal and not G.jokers.cards[my_pos + 1].getting_rerolled then
              local rerolled_card = G.jokers.cards[my_pos + 1]
              rerolled_card.getting_rerolled = true

              local rerolled_card_rarity = 0
              if rerolled_card.config.center.rarity == 2 then
                rerolled_card_rarity = 0.9
              elseif rerolled_card.config.center.rarity == 3 then
                rerolled_card_rarity = 1
              end

              G.GAME.joker_buffer = G.GAME.joker_buffer - 1

              G.E_MANAGER:add_event(Event({func = function()
                G.GAME.joker_buffer = 0
                self:juice_up(0.8, 0.8)
                rerolled_card:start_dissolve({HEX("57ecab")}, nil, 1.6)
                local card = create_card('Joker', G.jokers, nil, rerolled_card_rarity, nil, nil, nil, 'trc')
                card:add_to_deck()
                G.jokers:emplace(card)
                card:start_materialize()
                G.GAME.joker_buffer = 0
                return true
              end}))
              card_eval_status_text(context.blueprint_card or self, 'extra', nil, nil, nil, {message = "Rerolled!", colour = G.C.PURPLE})    
            end
          end
        elseif context.destroying_card then
        elseif context.cards_destroyed then
        elseif context.remove_playing_cards then
        elseif context.using_consumeable then
          if self.ability.name == 'Cloud Wizard' and (context.consumeable.ability.set == "Tarot") then
              ease_dollars(self.ability.extra)
              G.GAME.dollar_buffer = (G.GAME.dollar_buffer or 0) + self.ability.extra
              G.E_MANAGER:add_event(Event({func = (function() G.GAME.dollar_buffer = 0; return true end)}))
              return {
                  message = localize('$')..self.ability.extra,
                  dollars = self.ability.extra,
                  colour = G.C.MONEY
              }
          end
        elseif context.debuffed_hand then 
        elseif context.pre_discard then
        elseif context.discard then
          if self.ability.name == 'Hue Graph' and not context.blueprint and not context.hook and 
          G.GAME.current_round.discards_used <= 0 then
              local text,disp_text = G.FUNCS.get_poker_hand_info(G.hand.highlighted)

              if text == "Flush" then
                if pseudorandom('hue'..G.GAME.round_resets.ante) < G.GAME.probabilities.normal/self.ability.extra then
                  return {
                      message = "Hewn!",
                      colour = G.C.RED,
                      delay = 0.45, 
                      remove = true,
                      card = self
                  }
                end
              end
          end
        elseif context.end_of_round then
        elseif context.repetition then
        elseif context.other_joker then
        elseif context.adding_to_deck then
            if self.ability.name == "The Jokester" and not context.blueprint then
                if context.adding_to_deck_set == "Joker" then
                    self.ability.x_mult = self.ability.x_mult + self.ability.extra
                end
            end
        elseif context.individual then
          if context.cardarea == G.play then
          end
          if context.cardarea == G.hand then
            if self.ability.name == "Amazin' Joker" and context.other_card:get_id() == 14 then
              if context.other_card.debuff then
                  return {
                      message = localize('k_debuffed'),
                      colour = G.C.RED,
                      card = self,
                  }
              else
                  return {
                      chips = self.ability.extra.chips,
                      card = self
                  }
              end
            end
          end
        else
            if context.cardarea == G.jokers then
                if context.before then
                    if self.ability.name == "Top 5" and G.GAME.current_round.hands_played == 0 and not context.blueprint then
                        local aces = 0
                        local fives = 0
                        for i = 1, #context.scoring_hand do
                            if context.scoring_hand[i]:get_id() == 14 then
                                aces = aces + 1
                            end
                            if context.scoring_hand[i]:get_id() == 5 then
                                fives = fives + 1
                            end
                        end
                        if aces >= 1 and fives >= 1 and next(context.poker_hands["Straight"]) then
                            self.ability.extra.chips = self.ability.extra.chip_mod * self.ability.extra.chips

                            return {
                                message = localize('k_upgrade_ex'),
                                colour = G.C.CHIPS,
                                card = self
                            }
                        end
                    end
                    if self.ability.name == "Seven Seven Seven" then
                      local sevens = 0
                      for i = 1, #context.scoring_hand do
                        if context.scoring_hand[i]:get_id() == 7 then
                          sevens = sevens + 1
                        end
                      end
                      if sevens >= 3 then
                        G.E_MANAGER:add_event(Event({
                          trigger = "after",
                          delay = 0.7,
                          func = function()
                            local card = nil
                            local newcards = {}
                            local _rank = '7'
                            local _suit = pseudorandom_element({'S','H','D','C'}, pseudoseed('777_create'))
                            local cen_pool = {}
                            local enhanced_poll = pseudorandom(pseudoseed('777enh'..G.GAME.round_resets.ante))
                            if enhanced_poll > 0.7 then
                              for k, v in pairs(G.P_CENTER_POOLS["Enhanced"]) do
                                  if v.key ~= 'm_stone' then 
                                      cen_pool[#cen_pool+1] = v
                                  end
                              end
                              card = create_playing_card({front = G.P_CARDS[_suit..'_'.._rank], center = pseudorandom_element(cen_pool, pseudoseed('777_card'))}, G.hand, nil, false, {G.C.SECONDARY_SET.Spectral})
                            else
                              card = create_playing_card({front = G.P_CARDS[_suit..'_'.._rank], center = G.P_CENTERS.c_base}, G.hand, nil, false, {G.C.SECONDARY_SET.Spectral})
                            end
                            local edition_rate = 2
                            local edition = poll_edition('777_edition'..G.GAME.round_resets.ante, edition_rate, true)
                            card:set_edition(edition)
                            local seal_rate = 10
                            local seal_poll = pseudorandom(pseudoseed('777seal'..G.GAME.round_resets.ante))
                            if seal_poll > 1 - 0.02*seal_rate then
                                local seal_type = pseudorandom(pseudoseed('777sealtype'..G.GAME.round_resets.ante))
                                if seal_type > 0.75 then card:set_seal('Red')
                                elseif seal_type > 0.5 then card:set_seal('Blue')
                                elseif seal_type > 0.25 then card:set_seal('Gold')
                                else card:set_seal('Purple')
                                end
                            end
                            newcards[1] = card
                            playing_card_joker_effects(newcards)
                            return true
                          end}))
                      end
                    end
                elseif context.after then
                  if context.cardarea == G.jokers then
                    if self.ability.name == "The Brethren" then
                      if next(context.poker_hands["Full House"]) then
                        if pseudorandom('breth'..G.GAME.round_resets.ante) < G.GAME.probabilities.normal/self.ability.extra then
                          local rank1 = nil
                          local rank1_count = nil
                          local rank2 = nil
                          local rank2_count = nil
  
                          for i = 1, #context.scoring_hand do
                            if rank1 == context.scoring_hand[i]:get_id() then
                              rank1_count = rank1_count + 1
                            elseif rank2 == context.scoring_hand[i]:get_id() then
                              rank2_count = rank2_count + 1
                            elseif rank1 == nil then
                              rank1 = context.scoring_hand[i]:get_id()
                              rank1_count = 1
                            elseif rank2 == nil then
                              rank2 = context.scoring_hand[i]:get_id()
                              rank2_count = 1
                            end
                          end
                          
                          local pair_rank = nil
                          local three_rank = nil
                          if rank1_count == 2 then
                            pair_rank = rank1
                            three_rank = rank2
                          elseif rank2_count == 2 then
                            pair_rank = rank2
                            three_rank = rank1
                          end

                          local cdelay = 0.5
                          for i = 1, #context.scoring_hand do
                            if context.scoring_hand[i]:get_id() == pair_rank then
                              G.E_MANAGER:add_event(Event({trigger = 'after', delay = cdelay, func = function()
                                local card = context.scoring_hand[i]
                                local suit_prefix = string.sub(card.base.suit, 1, 1)..'_'
                                local rank_suffix = three_rank
                                if rank_suffix < 10 then rank_suffix = tostring(rank_suffix)
                                elseif rank_suffix == 10 then rank_suffix = 'T'
                                elseif rank_suffix == 11 then rank_suffix = 'J'
                                elseif rank_suffix == 12 then rank_suffix = 'Q'
                                elseif rank_suffix == 13 then rank_suffix = 'K'
                                elseif rank_suffix == 14 then rank_suffix = 'A'
                                end
                                card:set_base(G.P_CARDS[suit_prefix..rank_suffix])
                              return true end}))
                              cdelay = 0.1
                            end
                          end

                          return {
                              message = "Converted!",
                              colour = G.C.RED,
                              card = self
                          }
                        end
                      end
                    end
                  end
                else
                    if context.cardarea == G.jokers then
                        if self.ability.name == 'Top 5' then
                            return {
                                message = localize {
                                    type = 'variable',
                                    key = 'a_chips',
                                    vars = {self.ability.extra.chips}
                                },
                                chip_mod = self.ability.extra.chips,
                                colour = G.C.CHIPS
                            }
                        end
                        if self.ability.name == 'The Buffer' then
                            local fives = 0
                            for i = 1, #context.full_hand do
                                if context.full_hand[i]:get_id() == 5 then
                                    fives = fives + 1
                                end
                            end
                            if fives >= 1 then
                                return {
                                    message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult}},
                                    mult_mod = self.ability.extra.mult
                                }
                            end
                        end
                        if self.ability.name == "Timely Lion" then
                          if G.GAME.current_round.hands_left == 0 and G.GAME.current_round.hands_played == 0 then
                            local temp_mult = 2 * self.ability.extra.mult
                            return {
                              message = localize{type='variable',key='a_mult',vars={temp_mult}},
                              mult_mod = temp_mult,
                            }
                          elseif G.GAME.current_round.hands_left == 0 or G.GAME.current_round.hands_played == 0 then
                            return {
                              message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult}},
                              mult_mod = self.ability.extra.mult,
                            }
                          end
                        end
                    end
                end
            end
        end
    end

    return calc_ref
end

local add_to_deckref = Card.add_to_deck
function Card.add_to_deck(self, from_debuff)
    local calc_ref = add_to_deckref(self, from_debuff)

    for i = 1, #G.jokers.cards do
        G.jokers.cards[i]:calculate_joker({
            adding_to_deck = true,
            adding_to_deck_set = self.ability.set
        })
    end

    return calc_ref
end

local generate_UIBox_ability_tableref = Card.generate_UIBox_ability_table
function Card.generate_UIBox_ability_table(self)
    local card_type, hide_desc = self.ability.set or "None", nil
    local loc_vars = nil
    local main_start, main_end = nil, nil
    local no_badge = nil

    if self.config.center.unlocked == false and not self.bypass_lock then -- For everyting that is locked
    elseif card_type == 'Undiscovered' and not self.bypass_discovery_ui then -- Any Joker or tarot/planet/voucher that is not yet discovered
    elseif self.debuff then
    elseif card_type == 'Default' or card_type == 'Enhanced' then
    elseif self.ability.set == 'Joker' then
        local customJoker = true

        if self.ability.name == 'The Jokester' then
            loc_vars = {self.ability.extra, self.ability.x_mult}
        elseif self.ability.name == 'The Brethren' then
            loc_vars = {G.GAME.probabilities.normal, self.ability.extra}
        elseif self.ability.name == 'The Trickster' then
            loc_vars = {}
        elseif self.ability.name == 'Top 5' then
            loc_vars = {self.ability.extra.chips}
        elseif self.ability.name == 'The Buffer' then
            loc_vars = {self.ability.extra.mult}
        elseif self.ability.name == "Amazin' Joker" then
            loc_vars = {self.ability.extra.chips}
        elseif self.ability.name == 'Hue Graph' then
            loc_vars = {G.GAME.probabilities.normal, self.ability.extra}
        elseif self.ability.name == 'Cloud Wizard' then
            loc_vars = {self.ability.extra}
        elseif self.ability.name == 'Timely Lion' then
            loc_vars = {self.ability.extra.mult}
        elseif self.ability.name == 'Seven Seven Seven' then
            loc_vars = {self.ability.extra}
        else
            customJoker = false
        end

        if customJoker then
            local badges = {}
            if (card_type ~= 'Locked' and card_type ~= 'Undiscovered' and card_type ~= 'Default') or self.debuff then
                badges.card_type = card_type
            end
            if self.ability.set == 'Joker' and self.bypass_discovery_ui and (not no_badge) then
                badges.force_rarity = true
            end
            if self.edition then
                if self.edition.type == 'negative' and self.ability.consumeable then
                    badges[#badges + 1] = 'negative_consumable'
                else
                    badges[#badges + 1] = (self.edition.type == 'holo' and 'holographic' or self.edition.type)
                end
            end
            if self.seal then
                badges[#badges + 1] = string.lower(self.seal) .. '_seal'
            end
            if self.ability.eternal then
                badges[#badges + 1] = 'eternal'
            end
            if self.pinned then
                badges[#badges + 1] = 'pinned_left'
            end

            if self.sticker then
                loc_vars = loc_vars or {};
                loc_vars.sticker = self.sticker
            end

            return generate_card_ui(self.config.center, nil, loc_vars, card_type, badges, hide_desc, main_start,
                main_end)
        end
    end

    return generate_UIBox_ability_tableref(self)
end
----------------------------------------------
------------MOD CODE END----------------------
