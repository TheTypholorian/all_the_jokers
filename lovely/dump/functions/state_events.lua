LOVELY_INTEGRITY = '246ddf7d66c24d90fc101ddcd89c7a0104c6ac1e9f3152b4be692690c96e6ff9'

function win_game()
    if (not G.GAME.seeded and not G.GAME.challenge) or SMODS.config.seeded_unlocks then
        set_joker_win()
        set_stand_win()
        set_voucher_win()
        set_deck_rounds()
        set_deck_win()
        set_skill_win()
        
        check_and_set_high_score('win_streak', G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt+1)
        check_and_set_high_score('current_streak', G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt+1)
        check_for_unlock({type = 'win_no_hand'})
        check_for_unlock({type = 'win_no'})
        check_for_unlock({type = 'win_custom'})
        check_for_unlock({type = 'win_deck'})
        check_for_unlock({type = 'win_stake'})
        check_for_unlock({type = 'win'})
        inc_career_stat('c_wins', 1)
    end

    set_profile_progress()

    if G.GAME.challenge then
        G.PROFILES[G.SETTINGS.profile].challenge_progress.completed[G.GAME.challenge] = true
        set_challenge_unlock()
        check_for_unlock({type = 'win_challenge'})
        G:save_settings()
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()
            for k, v in pairs(G.I.CARD) do
                v.sticker_run = nil
            end
            
            play_sound('win')
            G.SETTINGS.paused = true

            G.FUNCS.overlay_menu{
                definition = create_UIBox_win(),
                config = {no_esc = true}
            }
            local Jimbo = nil

            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 2.5,
                blocking = false,
                func = (function()
                    if G.OVERLAY_MENU and G.OVERLAY_MENU:get_UIE_by_ID('jimbo_spot') then 
                        local quip, extra = SMODS.quip("win")
                        extra.x = 0
                        extra.y = 5
                        Jimbo = Card_Character(extra)
                        local spot = G.OVERLAY_MENU:get_UIE_by_ID('jimbo_spot')
                        spot.config.object:remove()
                        spot.config.object = Jimbo
                        Jimbo.ui_object_updated = true
                        Jimbo:add_speech_bubble(quip, nil, {quip = true}, extra)
                        Jimbo:say_stuff((extra and extra.times) or 5, false, quip)
                        if G.F_JAN_CTA then 
                            G.E_MANAGER:add_event(Event({
                                func = function()
                                    Jimbo:add_button(localize('b_wishlist'), 'wishlist_steam', G.C.DARK_EDITION, nil, true, 1.6)
                                    return true
                                end}))
                        end
                        end
                    return true
                end)
            }))
            
            return true
        end)
    }))

    if (not G.GAME.seeded and not G.GAME.challenge) or SMODS.config.seeded_unlocks then
        G.PROFILES[G.SETTINGS.profile].stake = math.max(G.PROFILES[G.SETTINGS.profile].stake or 1, (G.GAME.stake or 1)+1)
    end
    G:save_progress()
    G.FILE_HANDLER.force = true
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()
            if not G.SETTINGS.paused then
                G.GAME.current_round.round_text = 'Endless Round '
                return true
            end
        end)
    }))
end

function end_round()
if G.GAME.blind:get_type() == 'Boss' then
    G.GAME.overscore = 0
else
    if type(G.GAME.chips) ~= 'table' then
        if G.GAME.chips - G.GAME.blind.chips >= 0 then
            G.GAME.overscore = (G.GAME.overscore or 0) + G.GAME.chips - G.GAME.blind.chips
        end
    else
        if G.GAME.chips - G.GAME.blind.chips >= to_big(0) then
            G.GAME.overscore = (G.GAME.overscore or 0) + G.GAME.chips - G.GAME.blind.chips
        end
    end
end
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.2,
      func = function()
        G.GAME.blind.in_blind = false
        local game_over = true
        local game_won = false
        G.RESET_BLIND_STATES = true
        local delete_these = {}
        for i = 1, #G.playing_cards do
            if G.playing_cards[i].ability.fleeting then
                table.insert(delete_these, G.playing_cards[i])
            end
        end
        for i = 1, #delete_these do
            delete_these[i]:remove()
        end
        local pool = {}
        for i = 1, #G.consumeables.cards do
            table.insert(pool, G.consumeables.cards[i])
        end
        for i = 1, #pool do
            if pool[i].config.card and hit_minor_arcana_suits[pool[i].config.card.suit] then
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    draw_card(G.consumeables,G.deck, 90,'down', nil, pool[i])
                    return true
                end
            }))
            end
        end        
        if G.hand.crackers_highlighted and #G.hand.crackers_highlighted >= 1 then
        
            ease_discard(-1)
        
            for i = 1, #G.hand.crackers_highlighted do
                if not G.hand.crackers_highlighted[i].highlighted then
                    G.hand:add_to_highlighted(G.hand.crackers_highlighted[i], true)
                end
                G.hand.crackers_highlighted[i].marked_cracker = true
            end
        
            if #G.play.cards ~= 0 then
                for i=1, #G.hand.highlighted do
                    if G.hand.highlighted[i] and G.hand.highlighted[i].config.center == G.P_CENTERS.m_bunc_cracker then
                        if G.hand.highlighted[i]:is_face() then inc_career_stat('c_face_cards_played', 1) end
                        G.hand.highlighted[i].base.times_played = G.hand.highlighted[i].base.times_played + 1
                        G.hand.highlighted[i].ability.played_this_ante = true
                        G.GAME.round_scores.cards_played.amt = G.GAME.round_scores.cards_played.amt + 1
                        draw_card(G.hand, G.play, i*100/#G.hand.highlighted, 'up', nil, G.hand.highlighted[i])
                    end
                end
            end
        
            G.E_MANAGER:add_event(Event({func = function()
                if #G.play.cards == 0 then
                    G.GAME.ignore_hand_played = true
                    G.FUNCS.play_cards_from_highlighted()
                end
            return true end}))
        
            return
        end
        

        G.RESET_JIGGLES = true
        G.GAME.blind_attack = nil
        local skill_saved = false
        for i, j in pairs(G.GAME.skills) do
            local saved = calculate_skill(i, {end_of_round = true, game_over = game_over})
            if saved then
                skill_saved = true
            end
        end
        if game_over and skill_saved then
            game_over = false
        end
        if (G.GAME.special_levels) and (G.GAME.special_levels["money"] > 0) and (to_big and to_big(G.GAME.dollars) or (G.GAME.dollars)) < (to_big and to_big(G.GAME.grim_boss_dollars) or (G.GAME.grim_boss_dollars)) then
            ease_dollars(math.ceil(0.1 * G.GAME.special_levels["money"] * (G.GAME.grim_boss_dollars - G.GAME.dollars)))
        end
        if (G.GAME.blind_on_deck == "Boss") and G.GAME.special_levels and (G.GAME.special_levels["overshoot"] > 0) then
            local big_func = to_big or (function(x) return x end)
            if big_func(math.abs((G.GAME.blind.chips - G.GAME.chips) / G.GAME.blind.chips)) <= big_func(.015 * G.GAME.special_levels["overshoot"]) then
                add_tag(Tag("tag_negative"))
            end
        end
        if (G.GAME.special_levels) and (G.GAME.special_levels["boss"] > 0) and (G.GAME.blind_on_deck == "Boss") and G.GAME.blind and G.GAME.blind.config.blind.boss.showdown then
            local glass = {}
            local pool = {}
            for i = 1, #G.playing_cards do
                if not G.playing_cards[i].ability.name ~= 'Glass Card' then
                    table.insert(pool, G.playing_cards[i])
                end
            end
            if #pool > G.GAME.special_levels["boss"] then
                for i = 1, G.GAME.special_levels["boss"] do
                    local card, index = pseudorandom_element(pool, pseudoseed('deimos'))
                    table.insert(glass, card)
                    table.remove(pool, index)
                end
            else
                glass = pool
            end
            for i, j in ipairs(glass) do
                j:set_ability(G.P_CENTERS["m_glass"])
            end
        end
        if skill_active("sk_grm_cl_explorer") and (G.GAME.blind_on_deck == "Boss") then
            add_tag(Tag("tag_grm_grid"))
        end
        if (G.GAME.blind_on_deck == "Boss") and (G.GAME.special_levels) and (G.GAME.special_levels["grind"] > 0) then
            for i = 1, G.GAME.special_levels["grind"] do
                local rng = pseudorandom('grind')
                local reward = ""
                if rng > 0.66 then
                    reward = SMODS.create_card {set = "Lunar", no_edition = true}
                elseif rng > 0.33 then
                    reward = SMODS.create_card {set = "Stellar", no_edition = true}
                else
                    reward = SMODS.create_card {set = "Planet", no_edition = true}
                end
                reward:set_edition('e_negative')
                reward:add_to_deck()
                reward.ability.no_sell_value = true
                reward:set_cost()
                G.consumeables:emplace(reward)
            end
        end
        if skill_active("sk_cry_sticky_4") then
            for j, k in ipairs({G.jokers, G.consumeables, G.hand, G.deck, G.discard}) do
                local dupe_these = {}
                for i = 1, #k.cards do
                    if k.cards[i].ability.banana and (pseudorandom('sticky') < G.GAME.probabilities.normal/8) then
                        table.insert(dupe_these, k.cards[i])
                    end
                end
                for i = 1, math.min(((((k == G.jokers) or (k == G.consumeables)) and k.config.card_limit) or 1e15) - #k.cards, #dupe_these) do
                    card_eval_status_text(dupe_these[i], 'extra', nil, nil, nil, {message = localize('k_duplicated_ex')})
                    local card = copy_card(dupe_these[i], nil, nil, nil, dupe_these[i].edition and dupe_these[i].edition.negative)
                    card:add_to_deck()
                    if k.cards[i].playing_card then
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        table.insert(G.playing_cards, card)
                    end
                    k:emplace(card)
                end
            end
        end
        if (G.GAME.blind_on_deck == "Boss") and skill_active("sk_mf_painted_2") then
            local pool = {}
            for i = 1, #G.consumeables.cards do
                if G.consumeables.cards[i].ability and (G.consumeables.cards[i].ability.set == "Colour") then
                    table.insert(pool, G.consumeables.cards[i])
                end
            end
            if #pool > 0 then
                local card = pseudorandom_element(pool, pseudoseed('painted'))
                card.ability.val = card.ability.val + 1
                G.E_MANAGER:add_event(Event({
                func = function() 
                    card_eval_status_text(card, 'extra', nil, nil, nil, {
                    message = localize('k_upgrade_ex'),
                    colour = G.C.SECONDARY_SET.ColourCard,
                    card = card
                    }) 
                    return true
                end}))
            end
        end
        if skill_active("sk_ortalab_starry_1") then
            if G.zodiacs then
                for i, j in pairs(G.zodiacs) do
                    if j.ability.grm_unactivated then
                        j.config.extra.temp_level = j.config.extra.temp_level + 1
                        G.E_MANAGER:add_event(Event({
                            delay = 0.4,
                            trigger = 'after',
                            func = (function()
                                attention_text({
                                    text = '+1',
                                    colour = G.C.WHITE,
                                    scale = 1, 
                                    hold = 1/G.SETTINGS.GAMESPEED,
                                    cover = j.HUD_zodiac,
                                    cover_colour = G.ARGS.LOC_COLOURS.Zodiac,
                                    align = 'cm',
                                    })
                                play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                                play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                                return true
                            end)
                        }))
                    end
                end
            end
        end
         
        local infectable_cards = {}
        local can_infect = nil
        for i = 1, #G.jokers.cards do
            for k, v in ipairs(G.jokers.cards) do
                if not v.ability.dsix_infected and not (v.config.center.impure or v.config.center.pure) then infectable_cards[#infectable_cards+1] = v 
                elseif v.ability.dsix_infected then can_infect = true end
            end
            if #infectable_cards > 0 and can_infect and pseudorandom('dsix_infected_joker') > G.GAME.probabilities.normal/2 then 
                local infected_card = pseudorandom_element(infectable_cards, pseudoseed("dsix_infect_a_card"))
                infected_card.ability.dsix_infected = true
            end
            break
        end
        local infectable_cards = {}
        local can_infect = nil
        for i = 1, #G.consumeables.cards do
            if G.consumeables.cards[i].ability.dsix_infected then 
                for k, v in ipairs(G.consumeables.cards) do
                    if not v.ability.dsix_infected then infectable_cards[#infectable_cards+1] = v 
                    elseif v.ability.dsix_infected then can_infect = true end
                end
                if #infectable_cards > 0 and can_infect and pseudorandom('dsix_infected_joker') > G.GAME.probabilities.normal/2 then 
                    local infected_card = pseudorandom_element(infectable_cards, pseudoseed("dsix_infect_a_card"))
                    infected_card.ability.dsix_infected = true
                end
                break
            end
        end
        if G.GAME.current_round.semicolon then
            game_over = false
        end
            if G.GAME.current_round.advanced_blind then
                if G.GAME.aiko_puzzle_win then
                    game_over = false
                else
                    game_over = true
                end
            elseif G.GAME.akyrs_mathematics_enabled and G.GAME.akyrs_character_stickers_enabled then
                if G.GAME.blind and AKYRS.is_value_within_threshold(G.GAME.blind.chips,G.GAME.chips,G.GAME.akyrs_math_threshold) then
                    game_over = false
                else
                    game_over = true
                end
            end
            if to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips) then
                game_over = false
            end
                if G.GAME.current_round.advanced_blind then
                    if G.GAME.aiko_puzzle_win then
                        game_over = false
                    else
                        game_over = true
                    end
                elseif G.GAME.akyrs_mathematics_enabled and G.GAME.akyrs_character_stickers_enabled then
                    if G.GAME.blind and AKYRS.is_value_within_threshold(G.GAME.blind.chips,G.GAME.chips,G.GAME.akyrs_math_threshold) then
                        game_over = false
                    else
                        game_over = true
                    end
                end
            -- context.end_of_round calculations
            SMODS.saved = false
            G.GAME.saved_text = nil
            SMODS.calculate_context({end_of_round = true, game_over = game_over, beat_boss = G.GAME.blind.boss })
            AKYRS.copper_eval_calculation = true
            SMODS.calculate_context({akyrs_copper_end_of_round = true, game_over = game_over, beat_boss = G.GAME.blind.boss })
            AKYRS.simple_event_add(function() AKYRS.copper_eval_calculation = nil return true end, 0)
            for i = 1, #G.GAME.tags do
                G.GAME.tags[i]:apply_to_run({type = 'ad_end_of_round', game_over = game_over})
            end
            if SMODS.saved then game_over = false end
            -- TARGET: main end_of_round evaluation
            G.GAME.green_seal_draws = 0
            local i = 1
            while i <= #G.jokers.cards do
                local gone = G.jokers.cards[i]:calculate_banana()
                if not gone then i = i + 1 end
            end
            if G.GAME.round_resets.ante >= G.GAME.win_ante and G.GAME.blind_on_deck == 'Boss' then
                game_won = true
                G.GAME.won = true
            end
            if game_over then
                G.STATE = G.STATES.GAME_OVER
                if not G.GAME.won and not G.GAME.seeded and not G.GAME.challenge then 
                    G.PROFILES[G.SETTINGS.profile].high_scores.current_streak.amt = 0
                end
                G:save_settings()
                G.FILE_HANDLER.force = true
                G.STATE_COMPLETE = false
            else
                if G.GAME.modifiers.mts_scaling ~= 0 then
                    if G.GAME.blind:get_type() == 'Boss' and G.GAME.round_resets.blind ~= G.P_BLINDS[G.GAME.last_chdp_blind] then
                        G.GAME.modifiers.money_total_scaling = G.GAME.modifiers.money_total_scaling + G.GAME.modifiers.mts_scaling
                    end
                end
                if G.GAME.blind:get_type() == 'Boss' and G.GAME.round_resets.blind ~= G.P_BLINDS[G.GAME.last_chdp_blind] then
                    G.GAME.from_boss_blind = true
                else
                    G.GAME.from_boss_blind = false
                end
                if G.GAME.modifiers.rental_rate_increase_all ~= 0 then
                    if not G.GAME.real_rental_rate then 
                        G.GAME.real_rental_rate = G.GAME.rental_rate
                    end
                    G.GAME.real_rental_rate = G.GAME.real_rental_rate + G.GAME.modifiers.rental_rate_increase_all
                    if G.GAME.real_rental_rate % 1 < 0.5 then
                        G.GAME.rental_rate = math.floor(G.GAME.real_rental_rate)
                    else
                        G.GAME.rental_rate = math.ceil(G.GAME.real_rental_rate)
                    end
                end
                if G.GAME.modifiers.rental_rate_increase ~= 0 then
                    if not G.GAME.real_rental_rate then G.GAME.real_rental_rate = G.GAME.rental_rate end
                    G.GAME.real_rental_rate = G.GAME.real_rental_rate + G.GAME.modifiers.rental_rate_increase
                    if G.GAME.real_rental_rate % 1 < 0.5 then
                        G.GAME.rental_rate = math.floor(G.GAME.real_rental_rate)
                    else
                        G.GAME.rental_rate = math.ceil(G.GAME.real_rental_rate)
                    end
                end
                if G.GAME.modifiers.shop_scaling_ante_increase ~= 0 and G.GAME.blind:get_type() == 'Boss' and G.GAME.round_resets.blind ~= G.P_BLINDS[G.GAME.last_chdp_blind] then
                    G.GAME.modifiers.all_shop_scaling = G.GAME.modifiers.all_shop_scaling + G.GAME.modifiers.shop_scaling_ante_increase
                end
                if G.GAME.modifiers.shop_scaling_round_increase ~= 0 then
                    G.GAME.modifiers.all_shop_scaling = G.GAME.modifiers.all_shop_scaling + G.GAME.modifiers.shop_scaling_round_increase
                end
                if (G.GAME.modifiers.chaos_engine and G.GAME.from_boss_blind == true) or G.GAME.modifiers.chaos_engine_all then --i can do anything!
                    local challenge = G.GAME.challenge_index
                    local chaos_number = pseudorandom('chaos_engine')
                    disabledContaining = G.GAME.modifiers.disable_hand_containing
                    disabledHands = G.GAME.modifiers.disable_hand
                                        for k, v in ipairs(G.GAME.chaos_engine_rules) do
                                            if chaos_number < k/#G.GAME.chaos_engine_rules then
                                                print("ADDING "..v.id)
                                                if v.value then
                                                    print("VALUE: "..v.value)
                                                end
                                                if v.tag then
                                                    print("TAG: "..v.tag)
                                                end
                                                if v.hand then
                                                    print("HAND: "..v.hand)
                                                end
                                                if v.id == 'enable_eternal_jokers' then
                                                    G.GAME.modifiers.enable_eternals_in_shop = true
                                                    G.GAME.chaos_engine_rules[#G.GAME.chaos_engine_rules+1] = {id = 'all_eternal'}
                                                elseif v.id == 'all_eternal' then
                                                    G.GAME.modifiers.all_eternal = true
                                                    for kk, vv in ipairs(G.jokers.cards) do
                                                        vv:set_eternal(true)
                                                    end
                                                elseif v.id == 'enable_rental_jokers' then
                                                    G.GAME.modifiers.enable_rentals_in_shop = true
                                                    G.GAME.chaos_engine_rules[#G.GAME.chaos_engine_rules+1] = {id = 'all_rental_jokers'}
                                                    local rnd_num = pseudorandom('rule')
                                                    G.GAME.chaos_engine_rules[#G.GAME.chaos_engine_rules+1] = {id = 'rental_rate', value = math.ceil(2 + rnd_num*4)}
                                                elseif v.id == 'all_rental_jokers' then    
                                                    G.GAME.modifiers.all_rental_jokers = true
                                                    for kk, vv in ipairs(G.jokers.cards) do
                                                        vv:set_rental(true)
                                                    end
                                                elseif v.id == 'enable_perishable_jokers' then
                                                    G.GAME.modifiers.enable_perishables_in_shop = true
                                                    G.GAME.chaos_engine_rules[#G.GAME.chaos_engine_rules+1] = {id = 'all_perishable_jokers'}
                                                elseif v.id == 'all_perishable_jokers' then
                                                    G.GAME.modifiers.all_perishable_jokers = true
                                                    for kk, vv in ipairs(G.jokers.cards) do
                                                        vv:set_perishable(true)
                                                    end
                                                elseif v.id == 'enable_scattering_jokers' then
                                                    G.GAME.modifiers.enable_scattering_in_shop = true
                                                elseif v.id == 'enable_reactive_jokers' then
                                                    G.GAME.modifiers.enable_reactive_in_shop = true
                                                elseif v.id == 'enable_hindered_jokers' then
                                                    G.GAME.modifiers.enable_hindered_in_shop = true
                                                elseif v.id == 'enable_shrouded_jokers' then
                                                    G.GAME.modifiers.enable_shroudeds_in_shop = true
                                                elseif v.id == 'anaglyph' then
                                                    G.GAME.modifiers.anaglyph[#G.GAME.modifiers.anaglyph+1] = v.tag
                                                    local chaos_number = pseudorandom('chaos_engine')
                                                    for k, v in ipairs(G.GAME.chaos_tags) do --choose a random tag to add as anaglyph rule to the chaos engine
                                                        if chaos_number < k/#G.GAME.chaos_tags then
                                                            G.GAME.chaos_engine_rules[#G.GAME.chaos_engine_rules+1] = {id = 'anaglyph', value = localize{type = 'name_text', set = 'Tag', key = 'tag_'..v, nodes = {}}, tag = v}
                                                            break
                                                        end
                                                    end
                                                elseif v.id == 'no_shop_jokers' then
                                                    G.GAME.joker_rate = 0
                                                elseif v.id == 'win_ante' then
                                                    G.GAME.win_ante = v.value
                                                elseif v.id == 'no_vouchers' then
                                                    G.GAME.modifiers.no_vouchers = true
                                                    G.GAME.current_round.voucher = nil
                                                    G.GAME.banned_keys['tag_voucher'] = true
                                                    for kk, vv in ipairs(G.GAME.chaos_tags) do
                                                        if vv == 'voucher' or vv == 'cry_better_voucher' then
                                                            table.remove(G.GAME.chaos_tags, kk)
                                                        end
                                                    end
                                                elseif v.id == 'blind_scaling' then
                                                    G.GAME.starting_params.ante_scaling = G.GAME.starting_params.ante_scaling * v.value
                                                elseif v.id == 'disable_hand' then --hand is not allowed
                                                    disabledHands[#disabledHands+1] = v.hand
                                                    local chaos_number = pseudorandom('chaos_engine')
                                                    for k, v in ipairs(G.GAME.chaos_hands) do --choose a random hand to ban
                                                        if chaos_number < k/#G.GAME.chaos_hands then
                                                            G.GAME.chaos_engine_rules[#G.GAME.chaos_engine_rules+1] = {id = 'disable_hand', value = v, hand = v}
                                                            break
                                                        end
                                                    end
                                                elseif v.id == 'disable_hand_containing' then --hands with this in them are not allowed
                                                    disabledContaining[#disabledContaining+1] = v.hand
                                                elseif v.value then
                                                    G.GAME.modifiers[v.id] = v.value
                                                else
                                                    G.GAME.modifiers[v.id] = true
                                                end
                                                G.GAME.chaos_rules[#G.GAME.chaos_rules+1] = v
                                                if v.edition_type == 'cards' and #G.GAME.chaos_editions_cards > 0 then
                                                    local chaos_number = pseudorandom('chaos_engine')
                                                    for kk, vv in ipairs(G.GAME.chaos_editions_cards) do --choose a random playing card edition to add as a ban
                                                        if chaos_number < kk/#G.GAME.chaos_editions_cards then
                                                            G.GAME.chaos_engine_rules[k] = {id = 'no_'..vv..'_cards', edition_type = 'cards'}
                                                            table.remove(G.GAME.chaos_editions_cards, kk)
                                                            break
                                                        end
                                                    end
                                                elseif v.edition_type == 'jokers' and #G.GAME.chaos_editions_jokers > 0 then
                                                    local chaos_number = pseudorandom('chaos_engine')
                                                    for kk, vv in ipairs(G.GAME.chaos_editions_jokers) do --choose a random joker edition to add as a ban
                                                        if chaos_number < kk/#G.GAME.chaos_editions_jokers then
                                                            G.GAME.chaos_engine_rules[k] = {id = 'no_'..vv..'_jokers', edition_type = 'jokers'}
                                                            table.remove(G.GAME.chaos_editions_jokers, kk)
                                                            break
                                                        end
                                                    end
                                                elseif v.edition_type == 'all' and #G.GAME.chaos_editions > 0  then
                                                    local chaos_number = pseudorandom('chaos_engine')
                                                    for kk, vv in ipairs(G.GAME.chaos_editions) do --choose a random edition to add as a ban for every card
                                                        if chaos_number < kk/#G.GAME.chaos_editions then
                                                            G.GAME.chaos_engine_rules[k] = {id = 'no_'..vv..'s', edition_type = 'all'}
                                                            table.remove(G.GAME.chaos_editions, kk)
                                                            break
                                                        end
                                                    end
                                                elseif v.id ~= 'anaglyph' then
                                                    table.remove(G.GAME.chaos_engine_rules, k)
                                                end
                                                break
                                            end
                                        end
                                    G.GAME.modifiers.disable_hand_containing = disabledContaining
                                    G.GAME.modifiers.disable_hand = disabledHands
                end
                if #G.GAME.modifiers.anaglyph > 0 and G.GAME.from_boss_blind == true then
                    for k, v in ipairs(G.GAME.modifiers.anaglyph) do
                        add_tag(Tag('tag_'..(v)))
                    end
                end
                if G.GAME.modifiers.no_vouchers then
                    G.GAME.current_round.voucher = nil
                end
                if G.GAME.from_boss_blind and (G.GAME.round_resets.ante + 1) == G.GAME.modifiers.disable_skipping_ante then
                    G.GAME.modifiers.disable_skipping = true
                end
                G.GAME.unused_discards = (G.GAME.unused_discards or 0) + G.GAME.current_round.discards_left
                        G.GAME.word_todo = nil
                if G.GAME.blind and G.GAME.blind.config.blind then 
                    discover_card(G.GAME.blind.config.blind)
                end

                if G.GAME.blind_on_deck == 'Boss' then
                    local _handname, _played, _order = 'High Card', -1, 100
                    for k, v in pairs(G.GAME.hands) do
                        if v.played > _played or (v.played == _played and _order > v.order) then 
                            _played = v.played
                            _handname = k
                        end
                    end
                    
                    if G.GAME.played_ranks ~= nil then
                        local max_rank = nil
                        local max_count = -1
                    
                        for _, rank in ipairs(SMODS.Rank.obj_buffer) do
                            count = G.GAME.played_ranks[rank] or 0
                            -- tiebreak with highest rank
                            if count >= max_count then
                                max_count = count
                                max_rank = rank
                            end
                        end
                    
                        G.GAME.current_round.most_played_rank = max_rank
                    end
                    
                    
                    
                    local lowestValue = math.huge
                    local leastPlayedHand = ''
                    
                    for i = #G.handlist, 1, -1 do
                        local v = G.handlist[i]
                        local playedCount = G.GAME.hands and G.GAME.hands[v] and G.GAME.hands[v].played or 0
                        if (playedCount < lowestValue) and G.GAME.hands[v].visible then
                            lowestValue = G.GAME.hands[v].visible and playedCount or lowestValue
                            leastPlayedHand = G.GAME.hands[v].visible and v or leastPlayedHand
                        end
                    end
                    
                    G.GAME.current_round.least_played_poker_hand = leastPlayedHand
                    
                    G.GAME.current_round.most_played_poker_hand = _handname
                end

                if G.GAME.blind:get_type() == 'Boss' and not G.GAME.seeded and not G.GAME.challenge  then
                    G.GAME.current_boss_streak = G.GAME.current_boss_streak + 1
                    check_and_set_high_score('boss_streak', G.GAME.current_boss_streak)
                end
                
                if G.GAME.current_round.hands_played == 1 then 
                    inc_career_stat('c_single_hand_round_streak', 1)
                else
                    if not G.GAME.seeded and not G.GAME.challenge  then
                        G.PROFILES[G.SETTINGS.profile].career_stats.c_single_hand_round_streak = 0
                        G:save_settings()
                    end
                end

                check_for_unlock({type = 'round_win'})
                
                if not G.GAME.blind.disabled then
                    check_for_unlock({type = 'defeat_blind', blind = G.GAME.blind})
                end
                
                set_joker_usage()
                if game_won and not G.GAME.win_notified then
                    G.GAME.win_notified = true
                    G.E_MANAGER:add_event(Event({
                        trigger = 'immediate',
                        blocking = false,
                        blockable = false,
                        func = (function()
                            if G.STATE == G.STATES.ROUND_EVAL then 
                                win_game()
                                G.GAME.won = true
                                return true
                            end
                        end)
                    }))
                end
                for _,v in ipairs(SMODS.get_card_areas('playing_cards', 'end_of_round')) do
                    SMODS.calculate_end_of_round_effects({ cardarea = v, end_of_round = true, beat_boss = G.GAME.blind.boss })
                end



                local i = 1
                while i <= #G.hand.cards do
                    local gone = G.hand.cards[i]:calculate_banana()
                    if not gone then i = i + 1 end
                end
                for i = 1, #G.discard.cards do
                    G.discard.cards[i]:calculate_perishable()
                end
                i = 1
                while i <= #G.deck.cards do
                    G.deck.cards[i]:calculate_perishable()
                    local gone = G.deck.cards[i]:calculate_banana()
                    if not gone then i = i + 1 end
                end
                if G.GAME.used_vouchers.v_cry_double_down then
                    local function update_dbl(area)
                        local area = G.jokers
                        for i = 1, #area.cards do
                            if area.cards[i].ability.immutable and type(area.cards[i].ability.immutable.other_side) == "table" then
                                --tweak to do deck effects with on the flip side
                                if not G.P_CENTERS[area.cards[i].ability.immutable.other_side.key].immutable then
                                    if area.cards[i].ability.immutable.other_side and area.cards[i].edition.cry_double_sided then
                                        Cryptid.manipulate_table(
                                        area.cards[i],
                                        area.cards[i].ability.immutable,
                                        "other_side", 
                                        {
                                            value = 1.5, 
                                            type = "X",
                                            big = Cryptid.is_card_big({config = {center = G.P_CENTERS[area.cards[i].ability.immutable.other_side.key]}})
                                        }
                                        )
                                        card_eval_status_text(area.cards[i], "extra", nil, nil, nil, { message = localize("k_upgrade_ex") })
                                    end
                                end
                            end
                        end
                    end
                    update_dbl(G.jokers)
                    update_dbl(G.consumeables)
                    update_dbl(G.hand)
                    update_dbl(G.discard)
                    update_dbl(G.deck)
                end
                if G.GAME.modifiers.joker_tax then
                    local tax = 0
                    for i = 1, #G.jokers.cards do
                        tax = tax + (G.jokers.cards[i].sell_cost * 0.2)
                    end
                    if tax > 0 then
                        tax = math.ceil(tax)
                        ease_dollars(-tax)
                        for i = 1, #G.jokers.cards do
                            G.jokers.cards[i]:juice_up()
                        end
                    end
                end
                for i = #G.hand.cards,1,-1 do
                    if G.hand.cards[i].ability and G.hand.cards[i].ability.decayed then
                        G.hand.cards[i]:start_dissolve()
                    end
                end
                i = 1
                while i <= #G.hand.cards do
                    local gone = G.hand.cards[i]:calculate_abstract_break()
                    if not gone then i = i + 1 end
                end 
                -- i = 1
                -- while i <= #G.deck.cards do
                --     local gone = G.deck.cards[i]:calculate_abstract_break()
                --     if not gone then i = i + 1 end
                -- end
                -- i = 1
                -- while i <= #G.discard.cards do
                --     local gone = G.discard.cards[i]:calculate_abstract_break()
                --     if not gone then i = i + 1 end
                -- end
                G.FUNCS.draw_from_hand_to_discard()
                if G.GAME.blind_on_deck == 'Boss' then
                    G.GAME.voucher_restock = nil
                    if G.GAME.modifiers.set_eternal_ante and (G.GAME.round_resets.ante == G.GAME.modifiers.set_eternal_ante) then 
                        for k, v in ipairs(G.jokers.cards) do
                            v:set_eternal(true)
                        end
                    end
                    if G.GAME.modifiers.set_joker_slots_ante and (G.GAME.round_resets.ante == G.GAME.modifiers.set_joker_slots_ante) then 
                        G.jokers.config.card_limit = 0
                    end
                    delay(0.4); ease_ante(1, true); delay(0.4); check_for_unlock({type = 'ante_up', ante = G.GAME.round_resets.ante + 1})
                end
                G.FUNCS.draw_from_discard_to_deck()
                if G.GAME.blind:get_type() == 'Boss' then
                	G.FUNCS.draw_from_area_to_abduction()  
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                		delay = 0.3,
                        func = (function()  
                			Kino.abduction_end()
                	        return true end)
                	}))
                end
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    func = function()
                        if G.GAME.blind.config.blind.cry_before_cash and not G.GAME.blind.disabled then
                        	G.GAME.blind:cry_before_cash()
                        else
                        G.GAME.cry_make_a_decision = nil
                        
                        G.STATE = G.STATES.ROUND_EVAL
                        G.STATE_COMPLETE = false
                        end

                        if G.GAME.akyrs_default_blind_handler then
                        if G.GAME.blind_on_deck == 'Small' then
                            G.GAME.round_resets.blind_states.Small = 'Defeated'
                        elseif G.GAME.blind_on_deck == 'Dungeon' then
                            
                        elseif G.GAME.round_resets.blind == G.P_BLINDS[G.GAME.last_chdp2_blind] then
                        G.GAME.round_resets.blind_states.ChDp_Boss2 = "Defeated"
                        elseif G.GAME.round_resets.blind == G.P_BLINDS[G.GAME.last_chdp_blind] then
                        G.GAME.round_resets.blind_states.ChDp_Boss = "Defeated"
                        elseif G.GAME.blind_on_deck == 'Big' then
                            G.GAME.round_resets.blind_states.Big = 'Defeated'
                            elseif G.GAME.round_resets.blind.small then
                                G.GAME.round_resets.blind_states.Small = 'Defeated'
                            elseif G.GAME.round_resets.blind.big then
                                G.GAME.round_resets.blind_states.Big = 'Defeated' --Redundant if Ortalab is also present, but shouldn't do anything bad PROBABLY
                        else
                            if G.GAME.current_round.cry_voucher_stickers.pinned == false then
                            	G.GAME.current_round.Bakery_charm = Bakery_API.get_next_charms()
                            	G.GAME.current_round.voucher = SMODS.get_next_vouchers()
                            	G.GAME.current_round.cry_voucher_stickers = Cryptid.next_voucher_stickers()
                            	G.GAME.current_round.cry_voucher_edition = cry_get_next_voucher_edition() or {}
                            	G.GAME.current_round.cry_bonusvouchers = {}
                            	G.GAME.cry_bonusvouchersused = {}	-- i'm not sure why i'm putting these in two separate tables but it doesn't matter much
                            	for i = 1, G.GAME.cry_bonusvouchercount do
                            		G.GAME.current_round.cry_bonusvouchers[i] = SMODS.get_next_vouchers()
                            	end
                            	if G.GAME.modifiers.cry_no_vouchers then
                            	    very_fair_quip = pseudorandom_element(G.localization.misc.very_fair_quips, pseudoseed("cry_very_fair"))
                            	end
                            end
                            G.GAME.round_resets.blind_states.Boss = 'Defeated'
                            for k, v in ipairs(G.playing_cards) do
                                if (v.ability.played_this_ante ~= nil) then
                                    v.ability.played_this_ante = nil
                                    v.ability.played_last_ante = true
                                else
                                    v.ability.played_last_ante = nil
                                end
                            end
                        end

                        else
                            AKYRS.blind_handler()
                        end
                        if G.GAME.round_resets.temp_handsize then G.hand:change_size(-G.GAME.round_resets.temp_handsize); G.GAME.round_resets.temp_handsize = nil end
                        if G.GAME.round_resets.temp_reroll_cost then G.GAME.round_resets.temp_reroll_cost = nil; calculate_reroll_cost(true) end
                        if G.GAME.mxms_sagittarius_bonus then G.GAME.round_resets.temp_reroll_cost = 0; calculate_reroll_cost(true); G.GAME.mxms_sagittarius_bonus = false end
                        for _, v in pairs(find_joker("cry-loopy")) do
                        	if v.ability.extra.retrigger ~= 0 then
                        		v.ability.extra.retrigger = 0
                        		card_eval_status_text(v, 'extra', nil, nil, nil, {message = localize("k_reset"), colour = G.C.GREEN})
                        	end
                        end
                        for _, v in pairs(G.deck.cards) do
                        	v.sus = nil
                        end
                        if G.GAME.sus_cards then
                        	SMODS.calculate_context({ remove_playing_cards = true, removed = G.GAME.sus_cards })
                        	G.GAME.sus_cards = nil
                        end

                        if not next(SMODS.find_card('j_mxms_stop_sign')) then
                            reset_idol_card()
                            reset_mail_rank()
                            reset_ancient_card()
                            reset_castle_card()                 
                            for _, mod in ipairs(SMODS.mod_list) do
                                if mod.reset_game_globals and type(mod.reset_game_globals) == 'function' then
                                    mod.reset_game_globals(false)
                                end
                            end
                        end
                        for k, v in ipairs(G.playing_cards) do
                            v.ability.discarded = nil
                            if v.ability.revert_base then
                                if v.ability.revert_base[2] > 1 then
                                    v.ability.revert_base[2] = v.ability.revert_base[2] - 1
                                else
                                    v:set_base(v.ability.revert_base[1])
                                    G.GAME.blind:debuff_card(v)
                                    v.ability.revert_base = nil
                                end
                            end
                            v.ability.hit_hermit_indicator = nil
                            v.ability.hit_moon_indicator = nil
                            v.ability['4_W_uses'] = nil
                            G.GAME.suits_drawn = nil
                            v.ability.hit_has_original_suit = nil
                            if v.debuff then
                                v.ability.temp_debuff = nil
                                v:set_debuff()
                            end
                            if v.debuff then
                                v.ability.temp_debuff = nil
                                v:set_debuff()
                            end
                            v.ability.forced_selection = nil
                        end
                    return true
                    end
                }))
            end
        return true
      end
    }))
  end
  
function new_round()
    G.RESET_JIGGLES = nil
    delay(0.4)
    G.E_MANAGER:add_event(Event({
      trigger = 'immediate',
      func = function()
            if G.GAME.modifiers["blind_attack"] then
                G.GAME.blind_attack = random_attack()
            end
            if G.zodiacs then
                for _, zodiac in pairs(G.zodiacs) do
                    zodiac.ability.grm_unactivated = true
                end
            end
            if not G.GAME.modifiers["no_hand_discard_reset"] then
            if not G.GAME.modifiers["ante_hand_discard_reset"] then
            if not G.GAME.modifiers.carryover_discards then
                
                local deck_size = 0
                
                G.GAME.last_deck_size = G.GAME.last_deck_size
                
                for k, v in pairs(G.playing_cards) do
                    deck_size = deck_size + 1
                end
                
                if G.GAME.last_deck_size ~= deck_size then
                    local difference = deck_size - G.GAME.last_deck_size
                
                    check_for_unlock({type = 'round_deck_size', round_deck_size_diff = difference})
                end
                
                G.GAME.last_deck_size = deck_size
                
                G.GAME.bunc_money_spend_this_round = 0
                G.GAME.current_round.discards_left = math.max(0, G.GAME.round_resets.discards + G.GAME.round_bonus.discards)
                G.GAME.current_round.bunc_actual_discards_left = G.GAME.current_round.discards_left
            end
            if not G.GAME.modifiers.carryover_hands then
                G.GAME.current_round.hands_left = (math.max(1, G.GAME.round_resets.hands + G.GAME.round_bonus.next_hands))
            end
            end
            end
            if used_voucher and used_voucher('garbage_bag') then
                G.GAME.current_round.discards_left = G.GAME.current_round.discards_left + (G.GAME.betmma_discards_left_ref or 0)
            end
            if used_voucher and used_voucher('handbag') then
                G.GAME.current_round.hands_left = G.GAME.current_round.hands_left + (G.GAME.betmma_hands_left_ref or 0)
            end
            G.GAME.current_round.hands_played = 0
            G.GAME.current_round.discards_used = 0
            G.GAME.current_round.any_hand_drawn = nil
            G.GAME.current_round.reroll_cost_increase = 0
            G.GAME.current_round.used_packs = {}

            for k, v in pairs(G.GAME.hands) do 
                v.played_this_round = 0
            end

            for k, v in pairs(G.playing_cards) do
                v.ability.wheel_flipped = nil
            end

            G.GAME.current_round.free_rerolls = G.GAME.round_resets.free_rerolls
            calculate_reroll_cost(true)

            
            local blair = find_joker('j_kino_blair_witch')
            G.GAME.current_round.free_rerolls = G.GAME.current_round.free_rerolls + #blair
            calculate_reroll_cost(true)
            G.GAME.round_bonus.next_hands = 0
            G.GAME.round_bonus.discards = 0
            G.GAME.grim_boss_dollars = G.GAME.dollars

            local blhash = ''
            if G.GAME.blind_on_deck == 'Small' then
                G.GAME.round_resets.blind_states.Small = 'Current'
                G.GAME.current_boss_streak = 0
                blhash = 'S'
            elseif G.GAME.round_resets.blind == G.P_BLINDS[G.GAME.last_chdp2_blind] then
            G.GAME.round_resets.blind_states.ChDp_Boss2 = "Defeated"
            elseif G.GAME.round_resets.blind == G.P_BLINDS[G.GAME.last_chdp_blind] then
            G.GAME.round_resets.blind_states.ChDp_Boss = "Defeated"
            elseif G.GAME.blind_on_deck == 'Big' then
                G.GAME.round_resets.blind_states.Big = 'Current'
                G.GAME.current_boss_streak = 0
                blhash = 'B'
            else
                G.GAME.round_resets.blind_states.Boss = 'Current'
                blhash = 'L'
            end
            G.GAME.subhash = (G.GAME.round_resets.ante)..(blhash)

            G.GAME.blind:set_blind(G.GAME.round_resets.blind)
            G.E_MANAGER:add_event(Event({trigger = 'immediate',func = function()
                if G.GAME.nullified_blinds[G.GAME.blind.config.blind.key] then G.GAME.blind:disable() end
                return true
            end}))
            for i2, j2 in pairs(G.GAME.skills) do
                calculate_skill(i2, {selecting_blind = true})
            end
            if G.GAME.modifiers.cry_card_each_round then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        local front = pseudorandom_element(G.P_CARDS, pseudoseed('cry_horizon'))
                        G.playing_card = (G.playing_card and G.playing_card + 1) or 1
                        local edition = G.P_CENTERS.c_base
                        local card = Card(G.play.T.x + G.play.T.w/2, G.play.T.y, G.CARD_W, G.CARD_H, front, G.P_CENTERS.c_base, {playing_card = G.playing_card})
                        card:start_materialize()
                        if G.GAME.selected_back.effect.config.cry_force_edition and G.GAME.selected_back.effect.config.cry_force_edition ~= "random" then
                            local edition = {}
                            edition[G.GAME.selected_back.effect.config.cry_force_edition] = true
                            card:set_edition(edition, true, true);
                        end
                        G.play:emplace(card)
                        table.insert(G.playing_cards, card)
                        playing_card_joker_effects({true})
                        return true
                    end}))
                G.E_MANAGER:add_event(Event({
                    func = function()
                        G.deck.config.card_limit = G.deck.config.card_limit + 1
                        return true
                    end}))
                draw_card(G.play,G.deck, 90,'up', nil)
            end
            if G.GAME.modifiers.cry_conveyor and #G.jokers.cards>0 then
                local duplicated_joker = copy_card(G.jokers.cards[#G.jokers.cards])
                duplicated_joker:add_to_deck()
                G.jokers:emplace(duplicated_joker)
                G.jokers.cards[1]:start_dissolve()
            end
            
            SMODS.calculate_context({setting_blind = true, blind = G.GAME.round_resets.blind})
            
            -- TARGET: setting_blind effects
            Bakery_API.on_set_blind(G.GAME.blind)
 
            for i = 1, #G.consumeables.cards do
                G.consumeables.cards[i]:calculate_joker({dsix_setting_blind = true, blind = G.GAME.round_resets.blind})
            end            delay(0.4)

            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
                    G.STATE = G.STATES.DRAW_TO_HAND
                    G.deck:shuffle('nr'..G.GAME.round_resets.ante)
                    for i = 1, #G.deck.cards do
                        if G.deck.cards[i].ability and G.deck.cards[i].ability.shuffle_bottom then
                            G.deck.cards[i].ability.hit_hermit_indicator = G.deck.cards[i].ability.shuffle_bottom
                            G.deck.cards[i].ability.shuffle_bottom = G.deck.cards[i].ability.shuffle_bottom - 1
                            if G.deck.cards[i].ability.shuffle_bottom == 0 then
                                G.deck.cards[i].ability.shuffle_bottom = nil
                            end
                            local card = G.deck.cards[i]
                            table.remove(G.deck.cards, i)
                            table.insert(G.deck.cards, 1, card)
                        end
                        G.deck:set_ranks()
                    end
                    for i = #G.deck.cards, 1, -1 do
                        if G.deck.cards[i].ability and G.deck.cards[i].ability.shuffle_top then
                            G.deck.cards[i].ability.hit_moon_indicator = G.deck.cards[i].ability.shuffle_top
                            G.deck.cards[i].ability.shuffle_top = G.deck.cards[i].ability.shuffle_top - 1
                            if G.deck.cards[i].ability.shuffle_top == 0 then
                                G.deck.cards[i].ability.shuffle_top = nil
                            end
                            local card = G.deck.cards[i]
                            table.remove(G.deck.cards, i)
                            table.insert(G.deck.cards, card)
                        end
                        G.deck:set_ranks()
                    end
                    G.deck:hard_set_T()
if G.SCORING_COROUTINE then return false end 
                    G.STATE_COMPLETE = false
                    return true
                end
            }))
            return true
            end
        }))
end

G.FUNCS.draw_from_hand_to_run = function(e)
	local hand_count = #G.hand.cards
	for i=1, hand_count do --draw cards from deck
		draw_card(G.hand, G.cry_runarea, i*100/hand_count,'down', nil, nil,  0.08)
	end
end
G.FUNCS.draw_from_deck_to_hand = function(e)
    if not (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.SMODS_BOOSTER_OPENED) and
        G.hand.config.card_limit <= 0 and #G.hand.cards == 0 and not G.PROFILES[G.SETTINGS.profile].cry_none then
        if next(find_joker('2 Kings 2:23-24')) then
            check_for_unlock({ type = "shebear_mauling" })
        end
        G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false 
        return true
    end

    local hand_space = e
    local cards_to_draw = {}
    if not hand_space then
        local limit = G.hand.config.card_limit - #G.hand.cards
        local unfixed = not G.hand.config.fixed_limit
        local n = 0
        while n < #G.deck.cards do
            local card = G.deck.cards[#G.deck.cards-n]
            local mod = unfixed and (card.ability.card_limit - card.ability.extra_slots_used) or 0
            if limit - 1 + mod < 0 then
            else    
                limit = limit - 1 + mod
                table.insert(cards_to_draw, card)
                if limit <= 0 then break end
            end
            n = n + 1
        end
        hand_space = #cards_to_draw
    end
    if G.GAME.modifiers.cry_forced_draw_amount and (G.GAME.current_round.hands_played > 0 or G.GAME.current_round.discards_used > 0) then
    	hand_space = math.min(#G.deck.cards, G.GAME.modifiers.cry_forced_draw_amount)
    end
    if G.GAME.vhp_draw_extra then
        hand_space = math.min(#G.deck.cards, hand_space + G.GAME.vhp_draw_extra)
        G.GAME.vhp_draw_extra = nil
    end
    if G.GAME.blind and (G.GAME.blind.name == "The Jaw") and not G.GAME.blind.disabled then
            if ((to_big and to_big(G.GAME.dollars - G.GAME.bankrupt_at) or (G.GAME.dollars - G.GAME.bankrupt_at)) < (to_big and to_big(hand_space) or hand_space)) then
                hand_space = (G.GAME.dollars - G.GAME.bankrupt_at)
                if to_big and to_number then
                    hand_space = to_number(hand_space)
                end
                if ((to_big and to_big(G.GAME.dollars - G.GAME.bankrupt_at) or (G.GAME.dollars - G.GAME.bankrupt_at)) ~= (to_big and to_big(0) or 0)) then
                    ease_dollars(G.GAME.bankrupt_at-G.GAME.dollars)
                    delay(0.1)
                end
            else
                if (hand_space ~= 0) then
                    ease_dollars(-hand_space)
                    delay(0.1)
                end
            end
            if not (G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK) and
                (hand_space <= 0) and (#G.hand.cards == 0) then 
                if next(find_joker('2 Kings 2:23-24')) then
                    check_for_unlock({ type = "shebear_mauling" })
                end
                G.STATE = G.STATES.GAME_OVER; G.STATE_COMPLETE = false 
                return true
            end
        end
    if G.GAME.grim_hand_size_bonus then
        hand_space = hand_space + G.GAME.grim_hand_size_bonus
        G.GAME.grim_hand_size_bonus = 0
    end
    if G.GAME.blind.in_blind and 
    next(find_joker('j_kino_insomnia')) and
    (G.GAME.current_round.hands_played > 0 or
    G.GAME.current_round.discards_used > 0) then 
    	SMODS.calculate_context({insomnia_awake = true})
    	return
    end
    if G.GAME.blind.name ~= 'The Serpent' then
        local miami = G.FUNCS.find_activated_tape('c_csau_miami')
        if miami then
            miami:juice_up()
            hand_space = hand_space + miami.ability.extra.draw_mod
            miami.ability.extra.uses = miami.ability.extra.uses+1
            if to_big(miami.ability.extra.uses) >= to_big(miami.ability.extra.runtime) then
                G.FUNCS.destroy_tape(miami)
                miami.ability.destroyed = true
            end
        end
    end
    if G.GAME.blind.name == 'The Serpent' and
        not G.GAME.blind.disabled and
        (G.GAME.current_round.hands_played > 0 or
        G.GAME.current_round.discards_used > 0) then
            hand_space = math.min(#G.deck.cards, 3)
    end
    local flags = SMODS.calculate_context({drawing_cards = true, amount = hand_space})
    hand_space = math.min(#G.deck.cards, flags.cards_to_draw or hand_space)
    delay(0.3)
    SMODS.drawn_cards = {}
    if not G.GAME.USING_RUN then
    hand_space = hand_space + G.GAME.green_seal_draws
    G.GAME.green_seal_draws = 0
    for i=1, hand_space do --draw cards from deckL
        if G.STATE == G.STATES.TAROT_PACK or G.STATE == G.STATES.SPECTRAL_PACK then 
            draw_card(G.deck,G.hand, i*100/hand_space,'up', true, cards_to_draw[i])
        elseif next(SMODS.find_card('j_mxms_detective')) and G.STATE ~= G.STATES.SMODS_BOOSTER_OPENED then
            local biggest_size = 0
            for k, v in pairs(SMODS.find_card('j_mxms_detective')) do
                if v.ability.extra.size > biggest_size then
                    biggest_size = v.ability.extra.size
                end
            end
            if i <= biggest_size then
                draw_card(G.deck,G.hand, i*100/hand_space,'up', true, cards_to_draw[i], nil, nil, true)
            else
                draw_card(G.deck,G.hand, i*100/hand_space,'up', true, cards_to_draw[i])
            end
        else
            draw_card(G.deck,G.hand, i*100/hand_space,'up', true, cards_to_draw[i])
        end
    end
    G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = 0.4,
        func = function()
            if #SMODS.drawn_cards > 0 then
                SMODS.calculate_context({first_hand_drawn = not G.GAME.current_round.any_hand_drawn and G.GAME.facing_blind,
                                        hand_drawn = G.GAME.facing_blind and SMODS.drawn_cards,
                                        other_drawn = not G.GAME.facing_blind and SMODS.drawn_cards})
                SMODS.drawn_cards = {}
                if G.GAME.facing_blind then G.GAME.current_round.any_hand_drawn = true end
            end
            return true
        end
    }))
else
	for i = 1, #G.cry_runarea.cards do
		draw_card(G.cry_runarea,G.hand, i*100/#G.cry_runarea.cards,'up', true)
	end
end
end

G.FUNCS.discard_cards_from_highlighted = function(e, hook)

G.hand.crackers_highlighted = {}
local crackers_in_hand = false

for i = 1, #G.hand.cards do
    if G.hand.cards[i] and G.hand.cards[i].highlighted
    and G.hand.cards[i].config.center == G.P_CENTERS.m_bunc_cracker
    and not G.hand.cards[i].debuff then
        crackers_in_hand = true
        break
    end
end

for i = 1, #G.hand.cards do
    if G.hand.cards[i] and G.hand.cards[i].highlighted
    and (((G.hand.cards[i].config.center == G.P_CENTERS.m_bunc_cracker) and not G.hand.cards[i].debuff) or (crackers_in_hand and #SMODS.find_card('j_bunc_pica', false) > 0)) then
        table.insert(G.hand.crackers_highlighted, G.hand.cards[i])
        G.hand:remove_from_highlighted(G.hand.cards[i], true)
    end
end


if G.GAME.blind and G.GAME.blind.name == 'bl_bunc_final_dagger' and not G.GAME.blind.disabled then
    G.GAME.blind:wiggle()
    G.GAME.blind.antiscore = true
    G.FUNCS.play_cards_from_highlighted()
    return
end


if G.GAME.blind and G.GAME.blind.name == 'bl_bunc_paling' and not G.GAME.blind.disabled then
    G.GAME.blind:wiggle()
    delay(0.7)
end

   if G.GAME.modifiers.dungeon then
    G.GAME.hit_limit = #G.hand.cards - 1
    if G.GAME.hit_limit < 1 then
        G.GAME.hit_limit = 1
    end
end
   if G.GAME.blind and (G.GAME.blind.name == "The Triton") and not G.GAME.blind.disabled then
        ease_dollars(-G.GAME.dollars-100, true)
    end
if G.GAME.blind and (G.GAME.blind.name == "The Sink") and not G.GAME.blind.disabled then
        local hands = evaluate_poker_hand(G.hand.highlighted)
         if next(hands["Flush"]) then
             G.E_MANAGER:add_event(Event({trigger = 'immediate',func = function()
                 G.GAME.blind:disable()
                 return true
            end}))
         end
    end
    stop_use()
    G.CONTROLLER.interrupt.focus = true
    G.CONTROLLER:save_cardarea_focus('hand')

    for k, v in ipairs(G.playing_cards) do
        v.ability.forced_selection = nil
    end
    for _index, _pcard in ipairs(G.hand.highlighted) do
        if _pcard.ability.cannot_be_discarded then
            table.remove(G.hand.highlighted, _index)
        end
    end

    if G.CONTROLLER.focused.target and G.CONTROLLER.focused.target.area == G.hand then G.card_area_focus_reset = {area = G.hand, rank = G.CONTROLLER.focused.target.rank} end
    local highlighted_count = math.min(#G.hand.highlighted, G.discard.config.card_limit - #G.play.cards)
    if highlighted_count > 0 then 
        update_hand_text({immediate = true, nopulse = true, delay = 0}, {mult = 0, chips = 0, level = '', handname = ''})
        table.sort(G.hand.highlighted, function(a,b) return a.T.x < b.T.x end)
        inc_career_stat('c_cards_discarded', highlighted_count)
        for i, j in pairs(G.GAME.skills) do
            calculate_skill(i, {pre_discard = true})
        end
        SMODS.calculate_context({pre_discard = true, full_hand = G.hand.highlighted, hook = hook})
        
        -- TARGET: pre_discard
        if highlighted_count > 5 then
             inc_career_stat('minty_large_discards', 1)
             check_for_unlock({type = "career_stat", statname = "minty_large_discards"})
        end
        local cards = {}
        local destroyed_cards = {}
        
        if G.GAME.blind and G.GAME.blind.name == 'bl_bunc_paling' and not G.GAME.blind.disabled then
            for i=1, highlighted_count do
                G.E_MANAGER:add_event(Event({func = function()
                    if G.hand.highlighted[i] and not G.hand.highlighted[i].removed then
                        G.hand.highlighted[i]:juice_up()
                    end
                return true end }))
                ease_dollars(-1)
                delay(0.23)
            end
        end
        
        for i=1, highlighted_count do
            G.hand.highlighted[i]:calculate_seal({discard = true})
            local removed = false
            local effects = {}
            SMODS.calculate_context({discard = true, other_card =  G.hand.highlighted[i], full_hand = G.hand.highlighted, ignore_other_debuff = true}, effects)
            SMODS.trigger_effects(effects)
            for _, eval in pairs(effects) do
                if type(eval) == 'table' then
                    for key, eval2 in pairs(eval) do
                        if key == 'remove' or (type(eval2) == 'table' and eval2.remove) then removed = true end
                    end
                end
            end
            table.insert(cards, G.hand.highlighted[i])
            if removed then
                destroyed_cards[#destroyed_cards + 1] = G.hand.highlighted[i]
                if SMODS.shatters(G.hand.highlighted[i]) then
                    G.hand.highlighted[i]:shatter()
                else
                    G.hand.highlighted[i]:start_dissolve()
                end
            else 
                G.hand.highlighted[i].ability.discarded = true
                
                if G.GAME.blind and G.GAME.blind.name == 'bl_bunc_claw' and not G.GAME.blind.disabled then
                    draw_card(G.hand, G.deck, i*100/highlighted_count, 'down', false, G.hand.highlighted[i])
                    G.deck:shuffle('claw'..G.GAME.round_resets.ante)
                else
                    local has_line_in_the_sand = false
                    if G.jokers ~= nil and G.jokers.cards then
                        for _, j in ipairs(G.jokers.cards) do
                            if j.config and j.config.center_key == "j_aij_line_in_the_sand" then
                                has_line_in_the_sand = true
                            end
                        end
                    end
                    if has_line_in_the_sand then
                        draw_card(G.hand, G.jest_super_discard, i*100/highlighted_count, 'down', false, G.hand.highlighted[i])
                    else
                    draw_card(G.hand, G.discard, i*100/highlighted_count, 'down', false, G.hand.highlighted[i])
                    end
                end
                
            end
        end

        -- context.remove_playing_cards from discard
        for i = 1, #G.hand.highlighted do
            if G.hand.highlighted[i].ability and G.hand.highlighted[i].ability.grm_status and G.hand.highlighted[i].ability.grm_status.flint and not G.hand.highlighted[i].debuff and not G.hand.highlighted[i].ability.grm_status.aether then
                G.hand.highlighted[i].ability.grm_status.flint = nil
                card_eval_status_text(G.hand.highlighted[i], 'jokers', nil, nil, nil, {colour = G.C.FILTER, message = localize('k_ex_expired')})
            end
        end
        if destroyed_cards[1] then
            SMODS.calculate_context({remove_playing_cards = true, removed = destroyed_cards})
        end
        
        -- TARGET: effects after cards destroyed in discard
        
        G.GAME.cards_destroyed = G.GAME.cards_destroyed + (#destroyed_cards or 0)
        

        G.GAME.round_scores.cards_discarded.amt = G.GAME.round_scores.cards_discarded.amt + #cards
        check_for_unlock({type = 'discard_custom', cards = cards})
        if not hook then
            if G.GAME.modifiers.discard_cost then
                ease_dollars(-G.GAME.modifiers.discard_cost)
            end
            G.E_MANAGER:add_event(Event({ func = function()
                do_attack("pre_draw_discard")
                do_attack("pre_draw")
            return true end }))
            ease_discard(-1)
            G.GAME.current_round.discards_used = G.GAME.current_round.discards_used + 1
            
            if G.hand.crackers_highlighted and #G.hand.crackers_highlighted >= 1 then
                for i = 1, #G.hand.crackers_highlighted do
                    if not G.hand.crackers_highlighted[i].highlighted then
                        G.hand:add_to_highlighted(G.hand.crackers_highlighted[i], true)
                    end
                    G.hand.crackers_highlighted[i].marked_cracker = true
                end
            
                G.E_MANAGER:add_event(Event({func = function()
                    G.GAME.ignore_hand_played = true
                    G.FUNCS.play_cards_from_highlighted()
                return true end}))
            
                return
            end
            
            
            if G.GAME.blind and G.GAME.blind.name == 'bl_bunc_swing' and not G.GAME.blind.disabled then
                G.E_MANAGER:add_event(Event({ func = function()
                    for k, v in ipairs(G.hand.cards) do
                        v:flip()
                    end
            
                    G.GAME.blind:wiggle()
                    G.GAME.blind.triggered = true
            
                    if G.GAME.Swing == true then
                        G.GAME.Swing = false
                    else
                        G.GAME.Swing = true
                    end
                return true end }))
            end
            
            G.STATE = G.STATES.DRAW_TO_HAND
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = function()
if G.SCORING_COROUTINE then return false end 
                    G.STATE_COMPLETE = false
                    return true
                end
            }))
        end
    end    
    if G.hand.crackers_highlighted and #G.hand.crackers_highlighted >= 1 then
    
        ease_discard(-1)
    
        for i = 1, #G.hand.crackers_highlighted do
            if not G.hand.crackers_highlighted[i].highlighted then
                G.hand:add_to_highlighted(G.hand.crackers_highlighted[i], true)
            end
            G.hand.crackers_highlighted[i].marked_cracker = true
        end
    
        if #G.play.cards ~= 0 then
            for i=1, #G.hand.highlighted do
                if G.hand.highlighted[i] and G.hand.highlighted[i].config.center == G.P_CENTERS.m_bunc_cracker then
                    if G.hand.highlighted[i]:is_face() then inc_career_stat('c_face_cards_played', 1) end
                    G.hand.highlighted[i].base.times_played = G.hand.highlighted[i].base.times_played + 1
                    G.hand.highlighted[i].ability.played_this_ante = true
                    G.GAME.round_scores.cards_played.amt = G.GAME.round_scores.cards_played.amt + 1
                    draw_card(G.hand, G.play, i*100/#G.hand.highlighted, 'up', nil, G.hand.highlighted[i])
                end
            end
        end
    
        G.E_MANAGER:add_event(Event({func = function()
            if #G.play.cards == 0 then
                G.GAME.ignore_hand_played = true
                G.FUNCS.play_cards_from_highlighted()
            end
        return true end}))
    
        return
    end
    

end
  
G.FUNCS.play_cards_from_highlighted = function(e)
   played_hand = true
    if G.play and G.play.cards[1] then return end
    for i = 1, #G.hand.highlighted do
        local _card = G.hand.highlighted[i]
    
        if _card.ability.gemslot_jade then
            G.E_MANAGER:add_event(Event({
                trigger = 'after',
                delay = 0.1,
                func = function()
                    local rank_data = SMODS.Ranks[_card.base.value]
                    local behavior = rank_data.strength_effect or { fixed = 1, ignore = false, random = false }
                    local new_rank
    
                    if behavior.ignore or not next(rank_data.next) then
                        return true
                    elseif behavior.random then
                        -- TODO doesn't respect in_pool
                        new_rank = pseudorandom_element(rank_data.next, pseudoseed('strength'))
                    else
                        local ii = (behavior.fixed and rank_data.next[behavior.fixed]) and behavior.fixed or 1
                        new_rank = rank_data.next[ii]
                    end
                    assert(SMODS.change_base(_card, nil, new_rank))
                    return true
                end
            }))
        end
    end    
    if G.hand.crackers_highlighted and #G.hand.crackers_highlighted >= 1 then
    
        ease_discard(-1)
    
        for i = 1, #G.hand.crackers_highlighted do
            if not G.hand.crackers_highlighted[i].highlighted then
                G.hand:add_to_highlighted(G.hand.crackers_highlighted[i], true)
            end
            G.hand.crackers_highlighted[i].marked_cracker = true
        end
    
        if #G.play.cards ~= 0 then
            for i=1, #G.hand.highlighted do
                if G.hand.highlighted[i] and G.hand.highlighted[i].config.center == G.P_CENTERS.m_bunc_cracker then
                    if G.hand.highlighted[i]:is_face() then inc_career_stat('c_face_cards_played', 1) end
                    G.hand.highlighted[i].base.times_played = G.hand.highlighted[i].base.times_played + 1
                    G.hand.highlighted[i].ability.played_this_ante = true
                    G.GAME.round_scores.cards_played.amt = G.GAME.round_scores.cards_played.amt + 1
                    draw_card(G.hand, G.play, i*100/#G.hand.highlighted, 'up', nil, G.hand.highlighted[i])
                end
            end
        end
    
        G.E_MANAGER:add_event(Event({func = function()
            if #G.play.cards == 0 then
                G.GAME.ignore_hand_played = true
                G.FUNCS.play_cards_from_highlighted()
            end
        return true end}))
    
        return
    end
    

    --check the hand first
    
    local unlock_all_flipped = true
    
    for i = 1, #G.hand.highlighted do
        if G.hand.highlighted[i].facing ~= 'back' then
            unlock_all_flipped = false
        end
    end
    
    if (not G.hand.highlighted) or (#G.hand.highlighted == 0) then unlock_all_flipped = false end
    
    if unlock_all_flipped and #G.hand.highlighted >= 5 then
        check_for_unlock({type = 'play_all_flipped'})
    end
    
    
    if G.jokers ~= nil then
        SMODS.calculate_context({bunc_play_cards = true})
    end
    

    stop_use()
    G.GAME.blind.triggered = false
    G.CONTROLLER.interrupt.focus = true
    G.CONTROLLER:save_cardarea_focus('hand')

    for k, v in ipairs(G.playing_cards) do
        v.ability.forced_selection = nil
    end
    for _index, _pcard in ipairs(G.hand.highlighted) do
        if _pcard.ability.cannot_be_discarded then
            table.remove(G.hand.highlighted, _index)
        end
    end
    
    table.sort(G.hand.highlighted, function(a,b) return a.T.x < b.T.x end)

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            SMODS.calculate_context({akyrs_pre_play = true, akyrs_pre_play_cards = G.hand.highlighted})
            G.STATE = G.STATES.HAND_PLAYED
            G.STATE_COMPLETE = true
            return true
        end
    }))
    inc_career_stat('c_cards_played', #G.hand.highlighted)
    inc_career_stat('c_hands_played', 1)
    
    if G.GAME.blind and G.GAME.blind.name == 'bl_bunc_swing' and not G.GAME.blind.disabled then
        G.E_MANAGER:add_event(Event({ func = function()
            for k, v in ipairs(G.hand.cards) do
                if not (v.area == G.hand and v.highlighted and v.facing == 'front') then
                    v:flip()
                end
            end
    
            G.GAME.blind:wiggle()
            G.GAME.blind.triggered = true
    
            if G.GAME.Swing == true then
                G.GAME.Swing = false
            else
                G.GAME.Swing = true
            end
        return true end }))
    end
    
    
    if G.GAME.blind and G.GAME.blind.name == 'bl_bunc_umbrella' and not G.GAME.blind.disabled then
        G.E_MANAGER:add_event(Event({func = function()
    
            for k, v in ipairs(G.hand.cards) do
                if v.facing == 'front' and not v.highlighted then
                    v:flip()
                end
            end
    
            G.GAME.blind:wiggle()
            G.GAME.blind.triggered = true
    
        return true end }))
    end
    
    
    SMODS.calculate_context({ bunc_press_play = true })
    
    if not G.GAME.modifiers.dungeon then
        
        local function calculate_discard()
            for i = 1, #G.hand.cards do
                eval_card(G.hand.cards[i], {pre_discard = true, full_hand = G.hand.highlighted, hook = hook})
            end
            for j = 1, #G.jokers.cards do
                G.jokers.cards[j]:calculate_joker({pre_discard = true, full_hand = G.hand.highlighted, hook = hook})
            end
        end
        
        if not G.GAME.ignore_hand_played then
            if G.GAME.blind.antiscore then
                ease_discard(-1)
                calculate_discard()
            else
                ease_hands_played(-1)
            end
        else
            G.GAME.ignore_hand_played = nil
        end
        
    end
    delay(0.4)

        for i=1, #G.hand.highlighted do
            if G.hand.highlighted[i]:is_face() then inc_career_stat('c_face_cards_played', 1) end
            G.hand.highlighted[i].base.times_played = G.hand.highlighted[i].base.times_played + 1
            G.hand.highlighted[i].ability.played_this_ante = true
            G.GAME.round_scores.cards_played.amt = G.GAME.round_scores.cards_played.amt + 1
            if G.hand.highlighted[i].facing == 'back' then G.hand.highlighted[i].grim_facing_down = true end
            draw_card(G.hand, G.play, i*100/#G.hand.highlighted, 'up', nil, G.hand.highlighted[i])
        end

        check_for_unlock({type = 'run_card_replays'})

        G.E_MANAGER:add_event(Event({ func = function()
            do_attack("press_play")
        return true end }))
        if G.GAME.blind:press_play() then
            G.E_MANAGER:add_event(Event({
                trigger = 'immediate',
                func = (function()
                    SMODS.juice_up_blind()
                    G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                        play_sound('tarot2', 0.76, 0.4);return true end}))
                    play_sound('tarot2', 1, 0.4)
                    return true
                end)
            }))
            delay(0.4)
        end

        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = (function()
                check_for_unlock({type = 'hand_contents', cards = G.play.cards})

                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
                        G.FUNCS.evaluate_play(e)
                        
                        if G.GAME.blind.antiscore then
                            G.GAME.blind.antiscore = false
                        end
                        
                        return true
                    end
                }))

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.1,
                    func = function()
                        if G.SCORING_COROUTINE then return false end 
                        check_for_unlock({type = 'play_all_hearts'})
                        G.FUNCS.draw_from_area_to_abduction()
                        for i = 1, #G.play.cards do
                            G.play.cards[i].grim_facing_down = nil
                        end
                        if G.GAME.blind and G.GAME.blind.refunded then
                            refund_played()
                        else
                            if G.GAME.blind and skill_active("sk_grm_dash_1") then
                                refund_played_grim()
                            else
                                G.FUNCS.draw_from_play_to_discard()
                            end
                        end
                        G.GAME.hands_played = G.GAME.hands_played + 1
                        G.GAME.current_round.hands_played = G.GAME.current_round.hands_played + 1
                        return true
                            end
                        }))
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            func = function()
                                G.E_MANAGER:add_event(Event({
                                func = function()
                                    if to_big then
                                        if (to_big(G.GAME.chips) < to_big(G.GAME.blind.chips)) and G.GAME.modifiers["blind_attack"] then
                                            do_attack("pre_draw_hand")
                                            do_attack("pre_draw")
                                        end
                                    else
                                        if (G.GAME.chips < G.GAME.blind.chips) and G.GAME.modifiers["blind_attack"] then
                                            do_attack("pre_draw_hand")
                                            do_attack("pre_draw")
                                        end
                                    end
                                    G.GAME.blind_attack = random_attack()
                                    return true
                                end
                                }))
                                
                        return true
                    end
                }))
                G.E_MANAGER:add_event(Event({
                    trigger = 'immediate',
                    func = function()
if G.SCORING_COROUTINE then return false end 
                        G.STATE_COMPLETE = false
                        return true
                    end
                }))
                return true
            end)
        }))
end

G.FUNCS.get_poker_hand_info = function(_cards)
    local poker_hands = evaluate_poker_hand(_cards)
    local scoring_hand = {}
    local text,disp_text,loc_disp_text = 'NULL','NULL', 'NULL'
    if next(poker_hands["Flush Five"]) then text = "Flush Five"; scoring_hand = poker_hands["Flush Five"][1]
    elseif next(poker_hands["Flush House"]) then text = "Flush House"; scoring_hand = poker_hands["Flush House"][1]
    elseif next(poker_hands["Five of a Kind"]) then text = "Five of a Kind"; scoring_hand = poker_hands["Five of a Kind"][1]
    elseif next(poker_hands["Straight Flush"]) then text = "Straight Flush"; scoring_hand = poker_hands["Straight Flush"][1]
    elseif next(poker_hands["Four of a Kind"]) then text = "Four of a Kind"; scoring_hand = poker_hands["Four of a Kind"][1]
    elseif next(poker_hands["Full House"]) then text = "Full House"; scoring_hand = poker_hands["Full House"][1]
    elseif next(poker_hands["Flush"]) then text = "Flush"; scoring_hand = poker_hands["Flush"][1]
    elseif next(poker_hands["Straight"]) then text = "Straight"; scoring_hand = poker_hands["Straight"][1]
    elseif next(poker_hands["Three of a Kind"]) then text = "Three of a Kind"; scoring_hand = poker_hands["Three of a Kind"][1]
    elseif next(poker_hands["Two Pair"]) then text = "Two Pair"; scoring_hand = poker_hands["Two Pair"][1]
    elseif next(poker_hands["Pair"]) then text = "Pair"; scoring_hand = poker_hands["Pair"][1]
    elseif next(poker_hands["High Card"]) then text = "High Card"; scoring_hand = poker_hands["High Card"][1] end

    disp_text = text
    if text =='Straight Flush' then
        local min = 10
        for j = 1, #scoring_hand do
            if scoring_hand[j]:get_id() < min then min =scoring_hand[j]:get_id() end
        end
        if min >= 10 then 
            disp_text = 'Royal Flush'
        end
    end
    loc_disp_text = localize(disp_text, 'poker_hands')
    return text, loc_disp_text, poker_hands, scoring_hand, disp_text
end
  
function evaluate_play_intro()
    local destroyed_cards = {}
    for i = 1, #G.play.cards do
        local card = G.play.cards[i]
        if card.ability and card.ability.grm_status and card.ability.grm_status.flint and card.ability.grm_status.gust and card.ability.grm_status.rocky and card.ability.grm_status.subzero and not card.debuff then
            card:juice_up()
            card.ability.grm_status.aether = true
        end
        if card.ability and card.ability.grm_status and card.ability.grm_status.flint and not card.debuff then
            card.ability.perma_mult = card.ability.perma_mult or 0
            card.ability.perma_mult = card.ability.perma_mult + 1
            card_eval_status_text(card, 'jokers', nil, nil, nil, {colour = G.C.FILTER, message = localize{type='variable',key='a_mult',vars={1}}})
        end
        if card.ability and card.ability.grm_status and card.ability.grm_status.subzero and not card.debuff then
            for j = 1, #G.jokers.cards do
                if not G.jokers.cards[j].debuff and (G.jokers.cards[j].ability.name == "Absolute Zero") then
                    G.GAME.grim_hand_size_bonus = (G.GAME.grim_hand_size_bonus or 0) + 1
                end
            end
            G.GAME.grim_hand_size_bonus = (G.GAME.grim_hand_size_bonus or 0) + 1
        end
    end
    for i, j in ipairs(destroyed_cards) do
        j[2]:juice_up(0.8, 0.8)
        j[2]:start_dissolve({G.C.RED}, nil, 1.6)
        if j[2].area then j[2].area:remove_card(j[2]) end
    end
    for i = 1, #G.hand.cards do
        local card = G.hand.cards[i]
        if card.ability and card.ability.grm_status and card.ability.grm_status.rocky and not card.debuff and not card.ability.grm_status.aether then
            card.ability.grm_status.rocky = nil
            card_eval_status_text(card, 'jokers', nil, nil, nil, {colour = G.C.FILTER, message = localize('k_ex_expired')})
        end
    end
    local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(G.play.cards)
    G.FUNCS.ach_pepsecretunlock(text)
    local tbl = {}
    for i, v in pairs(G.jokers.cards) do
    	if v.base.nominal and v.base.suit then
    		tbl[#tbl+1] = v
    	end
    end
    local text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = G.FUNCS.get_poker_hand_info(Cryptid.table_merge(G.play.cards, tbl))
    
    local hand = (G.GAME.hands[text])
    if not hand then text = "cry_None"; disp_text = localize("cry_None", "poker_hands") end
    hand = G.GAME.hands[text]
    if text == "cry_None" then G.GAME.hands["cry_None"].visible = true end
    hand.played = hand.played + 1
    if G.GAME.current_round.current_hand.cry_asc_num and (((type(G.GAME.current_round.current_hand.cry_asc_num) == "table" and G.GAME.current_round.current_hand.cry_asc_num:gt(to_big(G.GAME.cry_exploit_override and 1 or 0)) or G.GAME.current_round.current_hand.cry_asc_num > (G.GAME.cry_exploit_override and 1 or 0)))) then
    	G.GAME.cry_asc_played = G.GAME.cry_asc_played and G.GAME.cry_asc_played+1 or 1
    end
    G.GAME.hands[text].played_this_round = G.GAME.hands[text].played_this_round + 1
    G.GAME.last_hand_played = text
    G.GAME.last_hand_played_cards = {}
    for i = 1, #G.play.cards do
    	G.GAME.last_hand_played_cards[i] = G.play.cards[i].sort_id
    end
    set_hand_usage(text)
    G.GAME.hands[text].visible = true

    local final_scoring_hand = {}
    for i=1, #G.play.cards do
        local splashed = SMODS.always_scores(G.play.cards[i]) or next(find_joker('Splash'))
        --Check for an Amamiya with The Psychic's Heart
        local amamiyas = SMODS.find_card("j_jokerhub_amamiya")
        if not splashed and #amamiyas > 0 then
        	for i = 1, #amamiyas do
        		if amamiyas[i].ability.extra.boss_abilities.bl_psychic then
        			splashed = true
        			break
        		end
        	end
        end
        local unsplashed = SMODS.never_scores(G.play.cards[i])
        local vhp_multiscoring_times = 0
        if not splashed then
            for _, card in pairs(scoring_hand) do
                if card == G.play.cards[i] then splashed = true end
                if card == G.play.cards[i] then
                    vhp_multiscoring_times = vhp_multiscoring_times + 1
                end
            end
        end
        local effects = {}
        SMODS.calculate_context({modify_scoring_hand = true, other_card =  G.play.cards[i], full_hand = G.play.cards, scoring_hand = scoring_hand, in_scoring = true}, effects)
        local flags = SMODS.trigger_effects(effects, G.play.cards[i])
        if flags.add_to_hand then splashed = true end
    	if flags.remove_from_hand then unsplashed = true end
        if splashed and not unsplashed then table.insert(final_scoring_hand, G.play.cards[i]) end
        if splashed and not unsplashed then
            for _ = 1, vhp_multiscoring_times - 1, 1 do
                table.insert(final_scoring_hand, G.play.cards[i])
            end
        end
    end
    -- TARGET: adding to hand effects
    -- WAUGH
    MINTY.omegasplashing = false
        for i=1, #G.hand.cards do
            local splashed = false
            local unsplashed = SMODS.never_scores(G.hand.cards[i])
            local effects = {}
            SMODS.calculate_context({minty_omegasplash = true, other_card =  G.hand.cards[i], full_hand = G.play.cards, scoring_hand = scoring_hand, in_scoring = true}, effects)
            local flags = SMODS.trigger_effects(effects, G.hand.cards[i])
            if flags.add_to_hand then splashed = true end
        	if flags.remove_from_hand then unsplashed = true end
            if splashed and not unsplashed then
                MINTY.omegasplashing = true
                table.insert(final_scoring_hand, G.hand.cards[i])
            end
        end
    -- Not yet
    for _, vhp_card in pairs(scoring_hand) do
        if vhp_card.area == G.hand then
            table.insert(final_scoring_hand, vhp_card)
        end
    end
    scoring_hand = final_scoring_hand
    
    G.GAME.last_played_hand = Kino.get_dummy_codex()
    
    for _, _pcard in ipairs(scoring_hand) do
        G.GAME.last_played_hand[_] = _pcard
    end
    
    
    delay(0.2)
    for i=1, #scoring_hand do
        --Highlight all the cards used in scoring and play a sound indicating highlight
        highlight_card(scoring_hand[i],(i-0.999)/5,'up')
        
        local played_rank = scoring_hand[i].base.value
        
        if G.GAME.played_ranks == nil then G.GAME.played_ranks = {} end
        
        if G.GAME.played_ranks[played_rank] then
            G.GAME.played_ranks[played_rank] = G.GAME.played_ranks[played_rank] + 1
        else
            G.GAME.played_ranks[played_rank] = 1
        end
        
    end

    percent = 0.3
    percent_delta = 0.08

    if next(find_joker("Lucky 7")) then
        local thunk = false
        for i=1, #scoring_hand do
            if scoring_hand[i]:get_id() == 7 and not SMODS.has_no_rank(scoring_hand[i]) then
                thunk = true break
            end
        end
        if thunk then
            for i=1, #scoring_hand do
                SMODS.enh_cache:write(scoring_hand[i], nil)
                scoring_hand[i].gambling = true
            end
        end
    end
    if G.GAME.current_round.current_hand.handname ~= disp_text then delay(0.3) end
    update_hand_text({sound = G.GAME.current_round.current_hand.handname ~= disp_text and 'button' or nil, volume = 0.4, immediate = true, nopulse = nil,
                                delay = G.GAME.current_round.current_hand.handname ~= disp_text and 0.4 or 0}, {handname=disp_text, level=G.GAME.hands[text].level, mult = Cryptid.ascend(G.GAME.hands[text].mult), chips = Cryptid.ascend(G.GAME.hands[text].chips)})
    SMODS.displayed_hand = text; SMODS.displaying_scoring = true

    return text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta
    end
    function evaluate_play_main(text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta)
                mult = mod_mult(Cryptid.ascend(G.GAME.hands[text].mult))
                hand_chips = mod_chips(Cryptid.ascend(G.GAME.hands[text].chips))
        AKYRS.base_cm_mod(G.play.cards, {text,disp_text,poker_hands,scoring_hand,non_loc_disp_text}, hand_chips, mult, already_ran)

        check_for_unlock({type = 'hand', handname = text, disp_text = non_loc_disp_text, scoring_hand = scoring_hand, full_hand = G.play.cards})
        local already_ran = true

        delay(0.4)

        if G.GAME.first_used_hand_level and G.GAME.first_used_hand_level > 0 then
            level_up_hand(G.deck.cards[1], text, nil, G.GAME.first_used_hand_level)
            G.GAME.first_used_hand_level = nil
        end

        for i = 1, #scoring_hand do
            if scoring_hand[i].ability and scoring_hand[i].ability.grm_status and scoring_hand[i].ability.grm_status.subzero and not scoring_hand[i].debuff and not scoring_hand[i].ability.grm_status.aether then
                scoring_hand[i].ability.grm_status.subzero = nil
                card_eval_status_text(scoring_hand[i], 'jokers', nil, nil, nil, {colour = G.C.FILTER, message = localize('k_ex_expired')})
            end
        end
        for i, j in pairs(G.GAME.skills) do
            calculate_skill(i, {before = true, scoring_name = text})
        end
        if next(SMODS.find_card("j_grm_showdown")) then
            local card = SMODS.find_card("j_grm_showdown")[1]
            text,disp_text,poker_hands,scoring_hand,non_loc_disp_text = upgrade_poker_hand_showdown(text, scoring_hand, card)
            mult = mod_mult(G.GAME.hands[text].mult)
            hand_chips = mod_chips(G.GAME.hands[text].chips)
        end
        if (G.GAME.area == "Tunnel") and (G.GAME.current_round.hands_played == 0) then
            local active = true
            local play_more_than = (G.GAME.hands[text].played or 0)
            for k, v in pairs(G.GAME.hands) do
                if k ~= text and v.played > play_more_than and v.visible then
                    active = false
                    break
                end
            end
            if active then
                level_up_hand(nil, text)
            else
                local _handname, _played, _order = 'High Card', -1, 100
                for k, v in pairs(G.GAME.hands) do
                    if v.played > _played or (v.played == _played and _order > v.order) then 
                        _played = v.played
                        _handname = k
                    end
                end
                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(_handname, 'poker_hands'),chips = G.GAME.hands[_handname].chips, mult = G.GAME.hands[_handname].mult, level=G.GAME.hands[_handname].level})
                delay(0.35)
                level_up_hand(nil, _handname, nil, -math.min(G.GAME.hands[_handname].level - 1, math.floor(G.GAME.hands[_handname].level / 2)))
                update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {handname=localize(text, 'poker_hands'),chips = hand_chips, mult = mult, level=G.GAME.hands[text].level})
            end
        end
        if (G.GAME.area == "Toxic Waste") and (G.GAME.current_round.discards_left > 0) then
            ease_discard(-G.GAME.area_data.discard_decay)
        end
        local hand_text_set = false
        SMODS.calculate_context({full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, kcv_forecast_event = true})
        -- context.before calculations
        SMODS.calculate_context({full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, hnds_pre_before = true})
        SMODS.calculate_context({full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, before = true})
        
        for i = 1, #G.GAME.tags do
            G.GAME.tags[i]:apply_to_run({type = 'hand_played', before = true, scoring_name = text})
        end
        
        -- TARGET: effects before scoring starts
        
        SMODS.displayed_hand = nil

                mult = mod_mult(Cryptid.ascend(G.GAME.hands[text].mult))
                hand_chips = mod_chips(Cryptid.ascend(G.GAME.hands[text].chips))
        AKYRS.base_cm_mod(G.play.cards, {text,disp_text,poker_hands,scoring_hand,non_loc_disp_text}, hand_chips, mult, already_ran)

        
        for i = 1, #G.GAME.tags do
            G.GAME.tags[i]:apply_to_run({type = 'hand_played', before = true})
        end
        
        local modded = false

        SMODS.calculate_context { after_before = true }
        mult, hand_chips, modded = G.GAME.blind:modify_hand(G.play.cards, poker_hands, text, mult, hand_chips, scoring_hand)
        if old_zodiac_effect then
            G.GAME.Ortalab_Zodiac_Reduction = old_zodiac_effect
            old_zodiac_effect = nil
        end
        mult, hand_chips = mod_mult(mult), mod_chips(hand_chips)
        for j, i in ipairs({'sk_grm_strike_1', 'sk_grm_strike_2', 'sk_cry_m_1', 'sk_grm_gravity_2', 'sk_grm_strike_3'}) do
            if skill_active(i) then
                hand_chips, mult, modded = calculate_skill(i, {modify_base = true, chips = hand_chips, mult = mult, scoring_name = text})
                if modded then
                    mult, hand_chips = mod_mult(mult), mod_chips(hand_chips)
                    update_hand_text({sound = 'chips2'}, {chips = hand_chips, mult = mult})
                end
            end
        end
        if G.zodiacs then
            if skill_active("sk_ortalab_starry_1") then
                for k1, i in pairs(G.zodiacs) do
                    if i.config.extra.hand_type == text then
                        i.ability.grm_unactivated = nil
                    end
                end
            end
        end
        mult, hand_chips = mod_mult(mult), mod_chips(hand_chips)
        if modded then update_hand_text({sound = 'chips2', modded = modded}, {chips = hand_chips, mult = mult}) end
        for i=1, #G.jokers.cards do
            eval_card(G.jokers.cards[i], {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, before_but_not_as_much = true})
        end
        delay(0.3)
        SMODS.calculate_context({initial_scoring_step = true, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands})
        SMODS.calculate_context({full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, jh_scoring_before = true})
        for _, v in ipairs(SMODS.get_card_areas('playing_cards')) do
            SMODS.calculate_main_scoring({cardarea = v, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands}, v == G.play and scoring_hand or nil)
            if v==G.play then
                local index=1
                while index<=#G.play.cards do
                    local card=G.play.cards[index]
                    if (card.ability.set == 'Default' or card.ability.set == 'Enhanced') and used_voucher('double_flipped_card') and card.facing_ref=='back' then
                        if (not card.shattered) and (not card.destroyed) then 
                            draw_card_immediately(G.play,G.hand, 0.1,'down', false, card)
                            card.facing_ref=card.facing
                            index=index-1
                        end
                    end
                    index=index+1
                end
            end
            delay(0.3)
        end
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
        for i=1, #G.consumeables.cards do
            local _card = G.consumeables.cards[i]
            local effects = eval_card(_card, {cardarea = G.consumeables, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, main_scoring = true}).playing_card
            if effects and _card.playing_card then
                local ii = 'talisman_check_key'
                effects[ii] = {}
                local reps = {1}
                local j = 1
                while j <= #reps do
                    if reps[j] ~= 1 then 
                        local _, eff = next(reps[j])
                        card_eval_status_text(eff.card, 'jokers', nil, nil, nil, eff)
                        percent = percent + 0.08
                    end
        
                    if reps[j] == 1 then 
                        --Check for hand doubling
                        --From Red seal
                        local eval = eval_card(_card, {end_of_round = true,cardarea = G.consumeables, repetition = true, repetition_only = true})
                        if next(eval) and eval.seals then 
                            for h = 1, eval.seals.repetitions do
                                if G.GAME.blind.name == "bl_mathbl_infinite" and not G.GAME.blind.disabled then
                                    G.GAME.blind:wiggle()
                                    G.GAME.blind.triggered = true
                                else
                                    reps[#reps+1] = eval
                                end
                            end
                        end
                    end
                    if effects.chips then 
                        juice_card(_card)
                        hand_chips = mod_chips(hand_chips + effects.chips)
                        update_hand_text({delay = 0}, {chips = hand_chips})
                        card_eval_status_text(_card, 'chips', effects.chips, percent)
                    end
        
                    if effects.xp then
                        juice_card(_card)
                        add_skill_xp(effects.xp, _card)
                    end
        
                    if effects.mult then 
                        juice_card(_card)
                        mult = mod_mult(mult + effects.mult)
                        update_hand_text({delay = 0}, {mult = mult})
                        card_eval_status_text(_card, 'mult', effects.mult, percent)
                    end
        
                    if effects.p_dollars then 
                        juice_card(_card)
                        ease_dollars(effects.p_dollars)
                        card_eval_status_text(_card, 'dollars', effects.p_dollars, percent)
                    end
        
                    if effects.dollars then 
                        juice_card(_card)
                        ease_dollars(effects.dollars)
                        card_eval_status_text(_card, 'dollars', effects.dollars, percent)
                    end
        
                    if effects.extra then
                        juice_card(_card)
                        local extras = {mult = false, hand_chips = false}
                        if effects.extra.mult_mod then mult =mod_mult( mult + effects.extra.mult_mod);extras.mult = true end
                        if effects.extra.chip_mod then hand_chips = mod_chips(hand_chips + effects.extra.chip_mod);extras.hand_chips = true end
                        if effects.extra.swap then 
                            local old_mult = mult
                            mult = mod_mult(hand_chips)
                            hand_chips = mod_chips(old_mult)
                            extras.hand_chips = true; extras.mult = true
                        end
                        if effects.extra.func then effects.extra.func() end
                        update_hand_text({delay = 0}, {chips = extras.hand_chips and hand_chips, mult = extras.mult and mult})
                        card_eval_status_text(_card, 'extra', nil, percent, nil, effects.extra)
                    end
        
                    --If x_mult added, do mult add event and mult the mult to the total
                    if effects.x_mult then
                        juice_card(_card)
                        mult = mod_mult(mult*effects.x_mult)
                        update_hand_text({delay = 0}, {mult = mult})
                        card_eval_status_text(_card, 'x_mult', effects.x_mult, percent)
                    end
        
                    if effects[ii].x_chips then
                    	mod_percent = true
                    	if effects[ii].card then juice_card(effects[ii].card) end
                    	hand_chips = mod_chips(hand_chips*effects[ii].x_chips)
                    	update_hand_text({delay = 0}, {chips = hand_chips})
                    	card_eval_status_text(scoring_hand[i], 'x_chips', effects[ii].x_chips, percent)
                    end
                    if effects[ii].e_chips then
                    	mod_percent = true
                    	if effects[ii].card then juice_card(effects[ii].card) end
                    	hand_chips = mod_chips(hand_chips^effects[ii].e_chips)
                    	update_hand_text({delay = 0}, {chips = hand_chips})
                    	card_eval_status_text(scoring_hand[i], 'e_chips', effects[ii].e_chips, percent)
                    end
                    if effects[ii].ee_chips then
                    	mod_percent = true
                    	if effects[ii].card then juice_card(effects[ii].card) end
                    	hand_chips = mod_chips(hand_chips:arrow(2, effects[ii].ee_chips))
                    	update_hand_text({delay = 0}, {chips = hand_chips})
                    	card_eval_status_text(scoring_hand[i], 'ee_chips', effects[ii].ee_chips, percent)
                    end
                    if effects[ii].eee_chips then
                    	mod_percent = true
                    	if effects[ii].card then juice_card(effects[ii].card) end
                    	hand_chips = mod_chips(hand_chips:arrow(3, effects[ii].eee_chips))
                    	update_hand_text({delay = 0}, {chips = hand_chips})
                    	card_eval_status_text(scoring_hand[i], 'eee_chips', effects[ii].eee_chips, percent)
                    end
                    if effects[ii].hyper_chips and type(effects[ii].hyper_chips) == 'table' then
                    	mod_percent = true
                    	if effects[ii].card then juice_card(effects[ii].card) end
                    	hand_chips = mod_chips(hand_chips:arrow(effects[ii].hyper_chips[1], effects[ii].hyper_chips[2]))
                    	update_hand_text({delay = 0}, {chips = hand_chips})
                    	card_eval_status_text(scoring_hand[i], 'hyper_chips', effects[ii].hyper_chips, percent)
                    end
                    if effects[ii].e_mult then
                    	mod_percent = true
                    	if effects[ii].card then juice_card(effects[ii].card) end
                    	mult = mod_mult(mult^effects[ii].e_mult)
                    	update_hand_text({delay = 0}, {mult = mult})
                    	card_eval_status_text(scoring_hand[i], 'e_mult', effects[ii].e_mult, percent)
                    end
                    if effects[ii].ee_mult then
                    	mod_percent = true
                    	if effects[ii].card then juice_card(effects[ii].card) end
                    	mult = mod_mult(mult:arrow(2, effects[ii].ee_mult))
                    	update_hand_text({delay = 0}, {mult = mult})
                    	card_eval_status_text(scoring_hand[i], 'ee_mult', effects[ii].ee_mult, percent)
                    end
                    if effects[ii].eee_mult then
                    	mod_percent = true
                    	if effects[ii].card then juice_card(effects[ii].card) end
                    	mult = mod_mult(mult:arrow(3, effects[ii].eee_mult))
                    	update_hand_text({delay = 0}, {mult = mult})
                    	card_eval_status_text(scoring_hand[i], 'eee_mult', effects[ii].eee_mult, percent)
                    end
                    if effects[ii].hyper_mult and type(effects[ii].hyper_mult) == 'table' then
                    	mod_percent = true
                    	if effects[ii].card then juice_card(effects[ii].card) end
                    	mult = mod_mult(mult:arrow(effects[ii].hyper_mult[1], effects[ii].hyper_mult[2]))
                    	update_hand_text({delay = 0}, {mult = mult})
                    	card_eval_status_text(scoring_hand[i], 'hyper_mult', effects[ii].hyper_mult, percent)
                    end
                    
                    --calculate the card edition effects
                    if effects.edition then
                        juice_card(_card)
                        hand_chips = mod_chips(hand_chips + (effects.edition.chip_mod or 0))
                        mult = mult + (effects.edition.mult_mod or 0)
                        mult = mod_mult(mult*(effects.edition.x_mult_mod or 1))
                        update_hand_text({delay = 0}, {
                            chips = effects.edition.chip_mod and hand_chips or nil,
                            mult = (effects.edition.mult_mod or effects.edition.x_mult_mod) and mult or nil,
                        })
                        card_eval_status_text(_card, 'extra', nil, percent, nil, {
                            message = (effects.edition.chip_mod and localize{type='variable',key='a_chips',vars={effects.edition.chip_mod}}) or
                                    (effects.edition.mult_mod and localize{type='variable',key='a_mult',vars={effects.edition.mult_mod}}) or
                                    (effects.edition.x_mult_mod and localize{type='variable',key='a_xmult',vars={effects.edition.x_mult_mod}}),
                            chip_mod =  effects.edition.chip_mod,
                            mult_mod =  effects.edition.mult_mod,
                            x_mult_mod =  effects.edition.x_mult_mod,
                            colour = G.C.DARK_EDITION,
                            edition = true})
                    end
                    j = j + 1
                end
            end
        end
        --Joker Effects
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
        percent = percent + percent_delta
        for _, area in ipairs(SMODS.get_card_areas('jokers')) do for _, _card in ipairs(area.cards) do
            local effects = {}
            -- remove base game joker edition calc
            local eval = eval_card(_card, {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, edition = true, pre_joker = true})
            if eval.edition then effects[#effects+1] = eval end
            

            -- Calculate context.joker_main
            local joker_eval, post = eval_card(_card, {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, joker_main = true})
            if next(joker_eval) then
                if joker_eval.edition then joker_eval.edition = {} end
                table.insert(effects, joker_eval)
                for _, v in ipairs(post) do effects[#effects+1] = v end
                if joker_eval.retriggers then
                    for rt = 1, #joker_eval.retriggers do
                        local rt_eval, rt_post = eval_card(_card, {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, joker_main = true, retrigger_joker = true})
                        if next(rt_eval) then
                            table.insert(effects, {retriggers = joker_eval.retriggers[rt]})
                            table.insert(effects, rt_eval)
                            for _, v in ipairs(rt_post) do effects[#effects+1] = v end
                        end
                    end
                end
            end

            -- Calculate context.other_joker effects
            for _, _area in ipairs(SMODS.get_card_areas('jokers')) do
                for _, _joker in ipairs(_area.cards) do
                    local other_key = 'other_unknown'
                    if _card.ability.set == 'Joker' then other_key = 'other_joker' end
                    if _card.ability.consumeable then other_key = 'other_consumeable' end
                    if _card.ability.set == 'Voucher' then other_key = 'other_voucher' end
                    -- TARGET: add context.other_something identifier to your cards
                    local joker_eval,post = eval_card(_joker, {full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, [other_key] = _card, other_main = _card })
                    if next(joker_eval) then
                        if joker_eval.edition then joker_eval.edition = {} end
                        joker_eval.jokers.juice_card = _joker
                        table.insert(effects, joker_eval)
                        for _, v in ipairs(post) do effects[#effects+1] = v end
                        if joker_eval.retriggers then
                            for rt = 1, #joker_eval.retriggers do
                                local rt_eval, rt_post = eval_card(_joker, {full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, [other_key] = _card, retrigger_joker = true})
                                if next(rt_eval) then
                                    table.insert(effects, {retriggers = joker_eval.retriggers[rt]})
                                    table.insert(effects, rt_eval)
                                    for _, v in ipairs(rt_post) do effects[#effects+1] = v end
                                end
                            end
                        end
                    end
                end
            end
            for _, _area in ipairs(SMODS.get_card_areas('individual')) do
                local other_key = 'other_unknown'
                if _card.ability.set == 'Joker' then other_key = 'other_joker' end
                if _card.ability.consumeable then other_key = 'other_consumeable' end
                if _card.ability.set == 'Voucher' then other_key = 'other_voucher' end
                -- TARGET: add context.other_something identifier to your cards
                local _eval,post = SMODS.eval_individual(_area, {full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, [other_key] = _card, other_main = _card })
                if next(_eval) then
                    _eval.individual.juice_card = _area.scored_card
                    table.insert(effects, _eval)
                    for _, v in ipairs(post) do effects[#effects+1] = v end
                    if _eval.retriggers then
                        for rt = 1, #_eval.retriggers do
                            local rt_eval, rt_post = SMODS.eval_individual(_area, {full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, [other_key] = _card, retrigger_joker = true})
                            if next(rt_eval) then
                                table.insert(effects, {_eval.retriggers[rt]})
                                table.insert(effects, rt_eval)
                                for _, v in ipairs(rt_post) do effects[#effects+1] = v end
                            end
                        end
                    end
                end
            end

            -- calculate edition multipliers
            local eval = eval_card(_card, {cardarea = G.jokers, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, edition = true, post_joker = true})
            if eval.edition then effects[#effects+1] = eval end

            SMODS.trigger_effects(effects, _card)
        end end

        if next(SMODS.find_card('j_mxms_whos_on_first')) then
        
            if not G.GAME.modifiers.mxms_nuclear_size and to_big(hand_chips)*mult >= to_big(G.GAME.blind.chips) and G.GAME.current_round.hands_played == 0 then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        check_for_unlock({type = 'beat_before_playing_cards'})
                        return true;
                    end
                }))
            end
        
            for _, v in ipairs(SMODS.get_card_areas('playing_cards')) do
                SMODS.calculate_main_scoring({cardarea = v, full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands}, v == G.play and scoring_hand or nil)
                delay(0.3)
            end
        end
        
        -- context.final_scoring_step calculations
        SMODS.calculate_context({full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, final_scoring_step = true})
        for i = 1, #G.GAME.tags do
            G.GAME.tags[i]:apply_to_run({type = 'ad_final_scoring_step'})
        end
        
        -- TARGET: effects before deck final_scoring_step
        if skill_active("sk_grm_blind_breaker") then
            mult = mod_mult(mult*(1 + G.GAME.current_round.hands_played * 0.2))
            update_hand_text({delay = 0}, {mult = mult})
        end
        
        for i = 1, #G.GAME.tags do
            G.GAME.tags[i]:apply_to_run({type = 'hand_played', after = true})
        end
        
        local nu_chip, nu_mult = G.GAME.selected_back:trigger_effect{context = 'final_scoring_step', chips = hand_chips, mult = mult}
        if G.GAME.ad_halve_scoring then
            local x_mult = 0.5 ^ G.GAME.ad_halve_scoring
            nu_mult = (nu_mult or mult) * x_mult
            update_hand_text({delay = 0}, { mult = nu_mult })
            
            G.E_MANAGER:add_event(Event {
                func = function()
                    local text = localize({ type = "variable", key = "ad_cracked", vars = { x_mult } })
                    play_sound('glass'..math.random(1, 6), math.random()*0.2 + 0.9,0.5)
                    play_sound('tarot1', 1.5)
                    attention_text({
                        scale = 1.4, text = text, hold = 2, align = 'cm', offset = {x = 0, y = -2.7}, major = G.play
                    })
                    return true
                end
            })
            delay(0.6)
        end
        mult = mod_mult(nu_mult or mult)
        hand_chips = mod_chips(nu_chip or hand_chips)

        local cards_destroyed = {}
        for _,v in ipairs(SMODS.get_card_areas('playing_cards', 'destroying_cards')) do
            SMODS.calculate_destroying_cards({ full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, cardarea = v }, cards_destroyed, v == G.play and scoring_hand or nil)
        end
        
        -- context.remove_playing_cards calculations
        if cards_destroyed[1] then
            SMODS.calculate_context({scoring_hand = scoring_hand, remove_playing_cards = true, removed = cards_destroyed})
        end
        
        -- TARGET: effects when cards are removed
        
        G.GAME.cards_destroyed = G.GAME.cards_destroyed + (#cards_destroyed or 0)
        
        


        local glass_shattered = {}
        for i=1, #G.consumeables.cards do
            local destroyed = nil
            local card = G.consumeables.cards[i]
            if card.playing_card and (card.ability.name == 'Glass Card') and not card.debuff and pseudorandom('glass') < G.GAME.probabilities.normal/card.ability.extra then 
                card.shattered = true
                cards_destroyed[#cards_destroyed+1] = card
            end
        end
        for k, v in ipairs(cards_destroyed) do
            if v.shattered then glass_shattered[#glass_shattered+1] = v end
        end

        check_for_unlock{type = 'shatter', shattered = glass_shattered}
        
        if G.GAME.negate_hand then
            mult = G.GAME.negate_hand * mult
            G.GAME.negate_hand = nil
            if (mult * hand_chips) < (-0.5 * G.GAME.blind.chips) then
                mult = math.ceil(-0.5 * G.GAME.blind.chips / hand_chips)
            end
            G.GAME.current_round.current_hand.mult = tostring(mult)
            SMODS.Scoring_Parameters['mult'].current = mult
            G.E_MANAGER:add_event(Event({
                trigger = 'before',
                delay = 0.8,
                func = function()
                    G.GAME.current_round.current_hand.mult = tostring(mult)
                    G.hand_text_area.mult:update(0)
                    return true
                end
            }))
        end
        for i=1, #cards_destroyed do
            G.E_MANAGER:add_event(Event({
                func = function()
                    if cards_destroyed[i].shattered then
                        cards_destroyed[i]:shatter()
                    else
                        cards_destroyed[i]:start_dissolve()
                    end
                  return true
                end
              }))
            SMODS.calculate_context({csau_card_destroyed = true, removed = cards_destroyed[i] })
        end
    return text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta
    end
    function evaluate_play_debuff(text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta)
    	mult = mod_mult(0)
        hand_chips = mod_chips(0)
        SMODS.displayed_hand = nil
        G.E_MANAGER:add_event(Event({
            trigger = 'immediate',
            func = (function()
                if SMODS.hand_debuff_source then SMODS.hand_debuff_source:juice_up(0.3,0) else SMODS.juice_up_blind() end
                G.E_MANAGER:add_event(Event({trigger = 'after', delay = 0.06*G.SETTINGS.GAMESPEED, blockable = false, blocking = false, func = function()
                    play_sound('tarot2', 0.76, 0.4);return true end}))
                play_sound('tarot2', 1, 0.4)
                return true
            end)
        }))

        play_area_status_text(localize('k_not_allowed_ex'))
        if G.GAME.special_levels and (G.GAME.special_levels["not_allowed"] > 0) then
            if pseudorandom('rhea') < G.GAME.probabilities.normal * ((G.GAME.special_levels["not_allowed"]) % 2) / 2 then
                level_up_hand(used_tarot, text, nil, math.ceil((G.GAME.special_levels["not_allowed"]) / 2))
            elseif G.GAME.special_levels["not_allowed"] >= 2 then
                level_up_hand(used_tarot, text, nil, math.floor((G.GAME.special_levels["not_allowed"]) / 2))
            end
        end
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
        --Joker Debuff Effects
        --+++++++++++++++++++++++++++++++++++++++++++++++++++++++++--
        -- context.debuffed_hand calculations
        SMODS.calculate_context({full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, debuffed_hand = true})
        
        -- TARGET: effects after hand debuffed by blind
    return text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta
    end
    function evaluate_play_final_scoring(text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta)
    G.E_MANAGER:add_event(Event({
    	trigger = 'after',delay = 0.4,
        func = (function()  update_hand_text({delay = 0, immediate = true}, {mult = 0, chips = 0, chip_total = math.floor( SMODS.calculate_round_score() ), level = '', handname = ''});play_sound('button', 0.9, 0.6);return true end)
      }))
      for name, parameter in pairs(SMODS.Scoring_Parameters) do
          update_hand_text({delay = 0}, {[name] = parameter.default_value})
      end
      check_and_set_high_score('hand',  SMODS.calculate_round_score() )
      
      if G.GAME.blind and G.GAME.blind.name == 'bl_bunc_blade' and not G.GAME.blind.disabled then
      
          local overscore = G.GAME.blind.chips * 1.5
      
          if type(hand_chips) == 'table' then overscore = to_big(overscore) end
      
          if (overscore < math.floor(hand_chips*mult) + G.GAME.chips) then
      
              mult = mod_mult(0)
              hand_chips = mod_chips(0)
      
              G.E_MANAGER:add_event(Event({
                  trigger = 'after',
                  func = (function()
                      G.GAME.blind:disable()
                      return true
                  end)
              }))
      
              local blade_message = G.localization.misc.dictionary.bunc_exceeded_score
              play_area_status_text(blade_message)
      
          end
      end
      

      check_for_unlock({type = 'chip_score', chips = math.floor( SMODS.calculate_round_score() )})
   
    if  to_big(SMODS.calculate_round_score())  > to_big(0) then
        delay(0.8)
        G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function() play_sound('chips2');return true end)
        }))
    end
    G.E_MANAGER:add_event(Event({
      trigger = 'ease',
      blocking = false,
      ref_table = G.GAME,
      ref_value = 'chips',
      ease_to = G.GAME.chips + math.floor( SMODS.calculate_round_score() ) * (G.GAME.blind.antiscore and -1 or 1),
      delay =  0.5,
      func = (function(t) return math.floor(t) end)
    }))
    G.E_MANAGER:add_event(Event({
      trigger = 'ease',
      blocking = true,
      ref_table = G.GAME.current_round.current_hand,
      ref_value = 'chip_total',
      ease_to = 0,
      delay =  0.5,
      func = (function(t) return math.floor(t) end)
    }))
        G.E_MANAGER:add_event(Event({
          trigger = 'immediate',
          	func = (function()
                if text ~= "cry_None" or not G.GAME.hands["cry_None"].visible then
                    G.GAME.current_round.current_hand.handname = ''
                end
                return true end)
          }))
          delay(0.3)
    delay(0.3)
    if not (SMODS.Mods["Talisman"] or {}).can_load then
        evaluate_play_after(text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta)
    end
    return text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta
    end
    function evaluate_play_after(text, disp_text, poker_hands, scoring_hand, non_loc_disp_text, percent, percent_delta)
    SMODS.last_hand_oneshot = to_big(SMODS.calculate_round_score()) > to_big(G.GAME.blind.chips)
    G.E_MANAGER:add_event(Event({
      trigger = 'immediate',
      func = (function() 
        for name, parameter in pairs(SMODS.Scoring_Parameters) do
            parameter.current = parameter.default_value
        end
        return true 
      end)
    }))
    
    SMODS.displaying_scoring = nil

    if G.GAME.temporary_bust_limit then
        G.GAME.hit_bust_limit = ( G.GAME.hit_bust_limit or 21) - G.GAME.temporary_bust_limit
        G.GAME.temporary_bust_limit = nil
        G.GAME.blind:set_text()
    end
    -- context.after calculations
    SMODS.calculate_context({full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, after = true})
    
    calculate_cracker_cards({full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, after = true})
    
    
    SMODS.calculate_context({full_hand = G.play.cards, scoring_hand = scoring_hand, scoring_name = text, poker_hands = poker_hands, after_debuff = true, ignore_debuff = true})
    G.E_MANAGER:add_event(Event({
    	func = function()
    		G.GAME.cry_exploit_override = nil
    		return true
    	end
    }))

    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()     
            if G.GAME.modifiers.debuff_played_cards then 
                for k, v in ipairs(scoring_hand) do v.ability.perma_debuff = true end
            end
        return true end)
      }))
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = (function()
            if G.GAME.modifiers.kino_alien then  
                for i = 1, G.GAME.modifiers.kino_alien do
                    local _card = nil
                    local _found_target = false
                    while not _found_target do
                        _card = pseudorandom_element(G.deck.cards)
                        if not _card.debuff then
                            _found_target = true
                        end
                    end
                        
                    SMODS.debuff_card(_card, true, "challenge_alien")
                end
            end
        return true end)
        }))

  end
  
  G.FUNCS.draw_from_play_to_discard = function(e)
    local play_count = #G.play.cards
    local it = 1
    for k, v in ipairs(G.play.cards) do
        if (not v.shattered) and (not v.destroyed) and (not v.abducted) then 
                if v.ability.gemslot_timecrystal then
                    draw_card(G.play,G.deck, it*100/play_count,'down', false, v)
                else
                    if next(SMODS.find_card('j_mxms_maurice')) and SMODS.has_enhancement(v, 'm_wild') then
                        draw_card(G.play,G.deck, it*100/play_count,'down', false, v)
                        SMODS.calculate_effect({message = localize('k_saved_ex'), sound = 'mxms_joker'}, SMODS.find_card('j_mxms_maurice')[1])
                    else
                        
                        local cards_to_hand = {}
                        
                        if G.jokers ~= nil then
                            for _, joker in ipairs(G.jokers.cards) do
                                if joker.config.center.key == 'j_bunc_cellphone' and joker.ability.extra.active and not joker.debuff then
                                    for __, card in ipairs(joker.ability.extra.cards_to_hand) do
                                        table.insert(cards_to_hand, card)
                                    end
                                    break
                                end
                            end
                        end
                        
                        if cards_to_hand ~= {} then
                            local condition = false
                            for _, card_to_hand in ipairs(cards_to_hand) do
                                if v == card_to_hand then
                                    condition = true
                                end
                            end
                            if condition then
                                draw_card(G.play,G.hand, it*100/play_count,'up', true, v)
                            else
                                draw_card(G.play,G.discard, it*100/play_count,'down', false, v)
                            end
                        else
                            draw_card(G.play,G.discard, it*100/play_count,'down', false, v)
                        end
                        
                    end
                end
            it = it + 1
        end
    end
  end

  G.FUNCS.draw_from_play_to_hand = function(cards)
    local gold_count = #cards
    for i=1, gold_count do --draw cards from play
        if not cards[i].shattered and not cards[i].destroyed then
            draw_card(G.play,G.hand, i*100/gold_count,'up', true, cards[i])
        end
    end
  end
  
  G.FUNCS.draw_from_discard_to_deck = function(e)
    G.E_MANAGER:add_event(Event({
        trigger = 'immediate',
        func = function()
            local has_line_in_the_sand = next(SMODS.find_card("j_aij_line_in_the_sand"))
            if has_line_in_the_sand and G.GAME.blind.boss then
                local discard_count = #G.jest_super_discard.cards
                for i=1, discard_count do --draw cards from deck
                    draw_card(G.jest_super_discard, G.deck, i*100/discard_count,'up', nil ,nil, 0.005, i%2==0, nil, math.max((21-i)/20,0.7))
                end
            end
            local discard_count = #G.discard.cards
            for i=1, discard_count do --draw cards from deck
                draw_card(G.discard, G.deck, i*100/discard_count,'up', nil ,nil, 0.005, i%2==0, nil, math.max((21-i)/20,0.7))
            end
            return true
        end
      }))
  end

  G.FUNCS.draw_from_hand_to_deck = function(e)
    local hand_count = #G.hand.cards
    for i=1, hand_count do --draw cards from deck
        draw_card(G.hand, G.deck, i*100/hand_count,'down', nil, nil,  0.08)
    end
  end
  
  G.FUNCS.draw_from_hand_to_discard = function(e)
    local hand_count = #G.hand.cards
    for i=1, hand_count do
        draw_card(G.hand,G.discard, i*100/hand_count,'down', nil, nil, 0.07)
    end
end

G.FUNCS.evaluate_round = function()
    total_cashout_rows = 0
    local pitch = 0.95
    local dollars = 0

    if to_big(G.GAME.chips) >= to_big(G.GAME.blind.chips) then
        add_round_eval_row({dollars = G.GAME.blind.dollars, name='blind1', pitch = pitch})
        pitch = pitch + 0.06
        dollars = dollars + G.GAME.blind.dollars
    else
        local should_win = false
        if G.GAME.blind.debuff.special_blind and G.GAME.aiko_puzzle_win then
            if G.GAME.aiko_puzzle_win then
                --print("win")
                should_win = true
            end
        elseif G.GAME.akyrs_mathematics_enabled and G.GAME.akyrs_character_stickers_enabled then
            if (G.GAME.blind and AKYRS.is_value_within_threshold(G.GAME.blind.chips, G.GAME.chips, G.GAME.akyrs_math_threshold)) or AKYRS.compare(G.GAME.current_round.hands_left,"<",1) or AKYRS.does_hand_only_contain_symbols(G.hand) then
                should_win = true
            end
        end
        if should_win then 
            add_round_eval_row({dollars = G.GAME.blind.dollars, name='blind1', pitch = pitch})
            dollars = dollars + G.GAME.blind.dollars
        else
        add_round_eval_row({dollars = 0, name='blind1', pitch = pitch, saved = true})
        end
        pitch = pitch + 0.06
    end

    G.E_MANAGER:add_event(Event({
        trigger = 'before',
        delay = 1.3*math.min(G.GAME.blind.dollars+2, 7)/2*0.15 + 0.5,
        func = function()
          G.GAME.blind:defeat()
          return true
        end
      }))
    delay(0.2)
    G.E_MANAGER:add_event(Event({
        func = function()
            ease_background_colour_blind(G.STATES.ROUND_EVAL, '')
            return true
        end
    }))
    SMODS.calculate_context{round_eval = true}
    G.GAME.selected_back:trigger_effect({context = 'eval'})

    if G.GAME.current_round.hands_left > 0 and not G.GAME.modifiers.no_extra_hand_money then
        add_round_eval_row({dollars = G.GAME.current_round.hands_left*(G.GAME.modifiers.money_per_hand or 1), disp = G.GAME.current_round.hands_left, bonus = true, name='hands', pitch = pitch})
        pitch = pitch + 0.06
        dollars = math.floor(dollars + G.GAME.current_round.hands_left*(G.GAME.modifiers.money_per_hand or 1))
    end
    if G.GAME.modifiers.kino_yeag and G.GAME.current_round.sci_fi_upgrades_last_round > 0 then
        add_round_eval_row({dollars = G.GAME.current_round.sci_fi_upgrades_last_round*(G.GAME.modifiers.kino_yeag), disp = G.GAME.current_round.sci_fi_upgrades_last_round, bonus = true, name='kino_sci_fi_payout', pitch = pitch})
        pitch = pitch + 0.06
        dollars = dollars +  G.GAME.current_round.sci_fi_upgrades_last_round*(G.GAME.modifiers.kino_yeag)
    end
    if G.GAME.current_round.discards_left > 0 and G.GAME.modifiers.money_per_discard then
        add_round_eval_row({dollars = G.GAME.current_round.discards_left*(G.GAME.modifiers.money_per_discard), disp = G.GAME.current_round.discards_left, bonus = true, name='discards', pitch = pitch})
        pitch = pitch + 0.06
        dollars = dollars +  G.GAME.current_round.discards_left*(G.GAME.modifiers.money_per_discard)
    end
    local i = 0
    for _, area in ipairs(SMODS.get_card_areas('jokers')) do
            for _, _card in ipairs(area.cards) do
            local ret = _card:calculate_dollar_bonus()
    
            -- TARGET: calc_dollar_bonus per card
            if ret then
                i = i+1
                add_round_eval_row({dollars = ret, bonus = true, name='joker'..i, pitch = pitch, card = _card})
                pitch = pitch + 0.06
                dollars = dollars + ret
            end
        end
    end
    for i = 1, #G.GAME.tags do
        local ret = G.GAME.tags[i]:apply_to_run({type = 'eval'})
        local revenue = G.GAME.tags[i]:apply_to_run({type = 'eval_interest'})
        if ret then
            add_round_eval_row({dollars = ret.dollars, bonus = true, name='tag'..i, pitch = pitch, condition = ret.condition, pos = ret.pos, tag = ret.tag})
            pitch = pitch + 0.06
            dollars = dollars + ret.dollars
        end
    end
    if to_big(G.GAME.dollars) >= Bakery_API.interest_scale() and not G.GAME.modifiers.no_interest and G.GAME.cry_payload then
        add_round_eval_row({bonus = true, payload = G.GAME.cry_payload, name='interest_payload', pitch = pitch, dollars = G.GAME.interest_amount*G.GAME.cry_payload*math.min(math.floor(G.GAME.dollars/Bakery_API.interest_scale()), G.GAME.interest_cap/5)})
        pitch = pitch + 0.06
        if not G.GAME.seeded and not G.GAME.challenge then
            if G.GAME.interest_amount*math.min(math.floor(G.GAME.dollars/Bakery_API.interest_scale()), G.GAME.interest_cap/5) == G.GAME.interest_amount*G.GAME.interest_cap/5 then
                G.PROFILES[G.SETTINGS.profile].career_stats.c_round_interest_cap_streak = G.PROFILES[G.SETTINGS.profile].career_stats.c_round_interest_cap_streak + 1
            else
                G.PROFILES[G.SETTINGS.profile].career_stats.c_round_interest_cap_streak = 0
            end
        end
        check_for_unlock({type = 'interest_streak'})
        local skyrocket_mult2 = #SMODS.D6_Side.get_die_info("count", "pure_skyrocket_side") > 0 and 3 or 1
        dollars = dollars + G.GAME.interest_amount*math.min(math.floor(G.GAME.dollars/Bakery_API.interest_scale()), G.GAME.interest_cap/5)*skyrocket_mult2
        G.GAME.cry_payload = nil
    elseif to_big(G.GAME.dollars) >= to_big(5) and not G.GAME.modifiers.no_interest then
    if not next(SMODS.find_card("j_jokerhub_broker")) then
        local skyrocket_mult = SMODS.D6_Side and (#SMODS.D6_Side.get_die_info("count", "pure_skyrocket_side") > 0 and 3) or 1
        add_round_eval_row({bonus = true, name='interest', pitch = pitch, dollars = G.GAME.interest_amount*math.min(math.floor(G.GAME.dollars/Bakery_API.interest_scale()), G.GAME.interest_cap/5)*skyrocket_mult})
        pitch = pitch + 0.06
        if (not G.GAME.seeded and not G.GAME.challenge) or SMODS.config.seeded_unlocks then
            if G.GAME.interest_amount*math.min(math.floor(G.GAME.dollars/Bakery_API.interest_scale()), G.GAME.interest_cap/5) == G.GAME.interest_amount*G.GAME.interest_cap/5 then 
                G.PROFILES[G.SETTINGS.profile].career_stats.c_round_interest_cap_streak = G.PROFILES[G.SETTINGS.profile].career_stats.c_round_interest_cap_streak + 1
            else
                G.PROFILES[G.SETTINGS.profile].career_stats.c_round_interest_cap_streak = 0
            end
        end
        check_for_unlock({type = 'interest_streak'})
        local skyrocket_mult2 = #SMODS.D6_Side.get_die_info("count", "pure_skyrocket_side") > 0 and 3 or 1
        dollars = dollars + G.GAME.interest_amount*math.min(math.floor(G.GAME.dollars/Bakery_API.interest_scale()), G.GAME.interest_cap/5)*skyrocket_mult2
        else
        local brokers = SMODS.find_card("j_jokerhub_broker")
        for i = 1, #brokers do
        	local chips_to_add = G.GAME.interest_amount*math.min(math.floor(G.GAME.dollars/Bakery_API.interest_scale()), G.GAME.interest_cap/5)*brokers[i].ability.extra.scaling
        	brokers[i].ability.extra.chips = brokers[i].ability.extra.chips + chips_to_add
        	if next(SMODS.find_mod("Maximus")) then SMODS.calculate_context({scaling_card = true}) end
        	SMODS.calculate_effect({
        		message = localize('k_upgrade_ex'),
        		colour = G.C.CHIPS,
        		card = brokers[i]
        	}, brokers[i])
        end
        end
    end

    pitch = pitch + 0.06

    if total_cashout_rows > 7 then
        local total_hidden = total_cashout_rows - 7
    
        G.E_MANAGER:add_event(Event({
            trigger = 'before',delay = 0.38,
            func = function()
                local hidden = {n=G.UIT.R, config={align = "cm"}, nodes={
                    {n=G.UIT.O, config={object = DynaText({
                        string = {localize{type = 'variable', key = 'cashout_hidden', vars = {total_hidden}}}, 
                        colours = {G.C.WHITE}, shadow = true, float = false, 
                        scale = 0.45,
                        font = G.LANGUAGES['en-us'].font, pop_in = 0
                    })}}
                }}
    
                G.round_eval:add_child(hidden, G.round_eval:get_UIE_by_ID('bonus_round_eval'))
                return true
            end
        }))
    end
    G.GAME.chdp_spacer_loaded = false
    if G.GAME.modifiers.money_total_scaling ~= 1 then
        if (SMODS.Mods["Talisman"] or {}).can_load then
            add_round_eval_row({dollars = to_number(to_big(dollars)), name = 'subtotal', bonus = true, pitch = pitch})
            delay(0.2)
            if (to_number(to_big(dollars)) * (G.GAME.modifiers.money_total_scaling)) % 1 < 0.5 then
                dollars = math.floor(to_number(to_big(dollars)) * (G.GAME.modifiers.money_total_scaling))
            else
                dollars = math.ceil(to_number(to_big(dollars)) * (G.GAME.modifiers.money_total_scaling))
            end
        else
            add_round_eval_row({dollars = dollars, name = 'subtotal', bonus = true, pitch = pitch})
            delay(0.2)
            if (dollars * (G.GAME.modifiers.money_total_scaling)) % 1 < 0.5 then
                dollars = math.floor(dollars * (G.GAME.modifiers.money_total_scaling))
            else
                dollars = math.ceil(dollars * (G.GAME.modifiers.money_total_scaling))
            end
        end
        add_round_eval_row({dollars = 0, name = 'scaling', bonus = true, pitch = pitch})
    end
    
    if G.GAME.modifiers.rental_rate_increase_all ~= 0 and not G.GAME.from_boss_blind then
        add_round_eval_row({dollars = 0, name = 'rent_increase_all', bonus = true, pitch = pitch})
    elseif G.GAME.modifiers.rental_rate_increase ~= 0 then
        if G.GAME.from_boss_blind == true then
            add_round_eval_row({dollars = 0, name = 'rent_increase', bonus = true, pitch = pitch})
        end
    end
    if G.GAME.modifiers.shop_scaling_round_increase ~= 0 and not G.GAME.from_boss_blind then
        add_round_eval_row({dollars = 0, name = 'shop_scaling_round_increase', bonus = true, pitch = pitch})
    elseif G.GAME.modifiers.shop_scaling_ante_increase ~= 0 then
        if G.GAME.from_boss_blind == true then
            add_round_eval_row({dollars = 0, name = 'shop_scaling_ante_increase', bonus = true, pitch = pitch})
        end
    end
    if G.GAME.modifiers.mts_scaling ~= 0 and G.GAME.from_boss_blind then
        add_round_eval_row({dollars = 0, name = 'mts_scaling', bonus = true, pitch = pitch})
    end
    if (G.GAME.modifiers.chaos_engine and G.GAME.from_boss_blind) then
        add_round_eval_row({dollars = 0, name = 'chaos_engine', bonus = true, pitch = pitch})
    end
    if G.GAME.modifiers.chaos_engine_all then
        add_round_eval_row({dollars = 0, name = 'chaos_engine', bonus = true, pitch = pitch})
    end
    for i = 1, #G.jokers.cards do
        if G.jokers.cards[i].ability.name == "j_fam_debit_card" then
            dollars = dollars/2
            G.jokers.cards[i].ability.extra.last_cash = G.jokers.cards[i].ability.extra.cash
            G.jokers.cards[i].ability.extra.cash = G.jokers.cards[i].ability.extra.cash + math.ceil(dollars)
            add_round_eval_row({bonus = true, name='debit', pitch = pitch, dollars = -math.ceil(dollars)})
            dollars = math.floor(dollars)
        end
    end
    cash_out_xp = 0
    if (G.GAME.area == "Ghost Town") and G.GAME.area_data and (pseudorandom('ghost') < G.GAME.probabilities.normal/(G.GAME.area_data.ghost_odds or 3)) then
        add_custom_round_eval_row("Ghost Town" , "$".. G.GAME.area_data.ghost_dollars, nil, G.C.MONEY)
        pitch = pitch + 0.06
        dollars = dollars + G.GAME.area_data.ghost_dollars
    end
    if (G.GAME.blind_on_deck == "Boss") then
        local stake_key = G.P_CENTER_POOLS.Stake[G.GAME.stake].key
        local plus_xp = 100
        local name = localize('boss_blind')
        if G.GAME.modifiers and G.GAME.modifiers.force_stake_xp then
            plus_xp = G.GAME.modifiers.force_stake_xp
        end
        if G.GAME.blind and G.GAME.blind.config.blind.boss.showdown then
            plus_xp = math.floor(plus_xp * 2)
            name = localize('showdown_blind')
        end
        if plus_xp and (plus_xp > 0) then
            add_custom_round_eval_row(name , tostring(get_modded_xp(plus_xp)) .. " XP")
            cash_out_xp = cash_out_xp + get_modded_xp(plus_xp)
        end
    end
    if skill_active("sk_grm_skillful_1") then
        add_custom_round_eval_row("Skillful I" , tostring(get_modded_xp(30)) .. " XP")
        cash_out_xp = cash_out_xp + get_modded_xp(30)
    end
    for i0 = 1, #G.jokers.cards do
        local ret0 = G.jokers.cards[i0]:calculate_xp_bonus()
        if ret0 then
            local joker_name = localize {type = 'name_text', key = G.jokers.cards[i0].config.center.key, set = 'Joker'}
            G.jokers.cards[i0]:juice_up(0.7, 0.46)
            add_custom_round_eval_row(joker_name , tostring(get_modded_xp(ret0)) .. " XP")
            cash_out_xp = cash_out_xp + get_modded_xp(ret0)
        end
    end
    if G.GAME.used_vouchers['v_grm_progress'] or G.GAME.used_vouchers['v_grm_complete'] then
        local intrest = math.min(G.GAME.xp_interest_max, math.floor(G.GAME.skill_xp / G.GAME.xp_interest_rate) * G.GAME.xp_interest)
        if intrest < 0 then
            intrest = 0
        end
        local intrest_text = " "..localize{type = 'variable', key = 'xp_interest', vars = {G.GAME.xp_interest, G.GAME.xp_interest_rate, G.GAME.xp_interest_max}}
        intrest = get_modded_xp(intrest)
        if intrest ~= 0 then
            add_custom_round_eval_row(intrest_text , tostring(intrest) .. " XP", intrest)
            cash_out_xp = cash_out_xp + intrest
        end
    end
    add_round_eval_row({name = 'bottom', dollars = dollars})
    Talisman.dollars = dollars
    
    for i = 1, #G.jokers.cards do
    	SMODS.debuff_card(G.jokers.cards[i], false, "jh_syphon")
    end
end

G.FUNCS.tutorial_controller = function()
    if G.F_SKIP_TUTORIAL then
        G.SETTINGS.tutorial_complete = true
        G.SETTINGS.tutorial_progress = nil
        return
    end
    G.SETTINGS.tutorial_progress = G.SETTINGS.tutorial_progress or 
    {
        forced_shop = {'j_joker', 'c_empress'},
        forced_voucher = 'v_grabber',
        forced_tags = {'tag_handy', 'tag_garbage'},
        hold_parts = {},
        completed_parts = {},
    }
    if not G.SETTINGS.paused and (not G.SETTINGS.tutorial_complete) then
        if G.STATE == G.STATES.BLIND_SELECT and G.blind_select and not G.SETTINGS.tutorial_progress.completed_parts['small_blind'] then
            G.SETTINGS.tutorial_progress.section = 'small_blind'
            G.FUNCS.tutorial_part('small_blind')
            G.SETTINGS.tutorial_progress.completed_parts['small_blind']  = true
            G:save_progress()
        end
        if G.STATE == G.STATES.BLIND_SELECT and G.blind_select and not G.SETTINGS.tutorial_progress.completed_parts['big_blind'] and G.GAME.round > 0 then
            G.SETTINGS.tutorial_progress.section = 'big_blind'
            G.FUNCS.tutorial_part('big_blind')
            G.SETTINGS.tutorial_progress.completed_parts['big_blind']  = true
            G.SETTINGS.tutorial_progress.forced_tags = nil
            G:save_progress()
        end
        if G.STATE == G.STATES.SELECTING_HAND and not G.SETTINGS.tutorial_progress.completed_parts['second_hand'] and G.SETTINGS.tutorial_progress.hold_parts['big_blind'] then
            G.SETTINGS.tutorial_progress.section = 'second_hand'
            G.FUNCS.tutorial_part('second_hand')
            G.SETTINGS.tutorial_progress.completed_parts['second_hand']  = true
            G:save_progress()
        end
        if G.SETTINGS.tutorial_progress.hold_parts['second_hand'] then
            G.SETTINGS.tutorial_complete = true
        end
        if not G.SETTINGS.tutorial_progress.completed_parts['first_hand_section'] then 
            if G.STATE == G.STATES.SELECTING_HAND and not G.SETTINGS.tutorial_progress.completed_parts['first_hand'] then
                G.SETTINGS.tutorial_progress.section = 'first_hand'
                G.FUNCS.tutorial_part('first_hand')
                G.SETTINGS.tutorial_progress.completed_parts['first_hand']  = true
                G:save_progress()
            end
            if G.STATE == G.STATES.SELECTING_HAND and not G.SETTINGS.tutorial_progress.completed_parts['first_hand_2'] and G.SETTINGS.tutorial_progress.hold_parts['first_hand']  then
                G.FUNCS.tutorial_part('first_hand_2')
                G.SETTINGS.tutorial_progress.completed_parts['first_hand_2']  = true
                G:save_progress()
            end
            if G.STATE == G.STATES.SELECTING_HAND and not G.SETTINGS.tutorial_progress.completed_parts['first_hand_3'] and G.SETTINGS.tutorial_progress.hold_parts['first_hand_2']  then
                G.FUNCS.tutorial_part('first_hand_3')
                G.SETTINGS.tutorial_progress.completed_parts['first_hand_3']  = true
                G:save_progress()
            end
            if G.STATE == G.STATES.SELECTING_HAND and not G.SETTINGS.tutorial_progress.completed_parts['first_hand_4'] and G.SETTINGS.tutorial_progress.hold_parts['first_hand_3']  then
                G.FUNCS.tutorial_part('first_hand_4')
                G.SETTINGS.tutorial_progress.completed_parts['first_hand_4']  = true
                G.SETTINGS.tutorial_progress.completed_parts['first_hand_section']  = true
                G:save_progress()
            end
        end
         if G.STATE == G.STATES.SHOP and G.shop and G.shop.VT.y < 5 and not G.SETTINGS.tutorial_progress.completed_parts['shop_1'] then
            G.SETTINGS.tutorial_progress.section = 'shop'
            G.FUNCS.tutorial_part('shop_1')
            G.SETTINGS.tutorial_progress.completed_parts['shop_1']  = true
            G.SETTINGS.tutorial_progress.forced_voucher = nil
            G:save_progress()
        end
    end
end

G.FUNCS.tutorial_part = function(_part)
    local step = 1
    G.SETTINGS.paused = true
    if _part == 'small_blind' then 
        step = tutorial_info({
            text_key = 'sb_1',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'sb_2',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'sb_3',
            highlight = {
                G.blind_select.UIRoot.children[1].children[1].config.object:get_UIE_by_ID('blind_name'),
                G.blind_select.UIRoot.children[1].children[1].config.object:get_UIE_by_ID('blind_desc'),
            },
            attach = {major =  G.blind_select.UIRoot.children[1].children[1], type = 'tr', offset = {x = 2, y = 4}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'sb_4',
            highlight = {
                G.blind_select.UIRoot.children[1].children[1]
            },
            snap_to = function() 
                if G.blind_select and G.blind_select.UIRoot and G.blind_select.UIRoot.children[1] and G.blind_select.UIRoot.children[1].children[1] and G.blind_select.UIRoot.children[1].children[1].config.object then 
                    return G.blind_select.UIRoot.children[1].children[1].config.object:get_UIE_by_ID('select_blind_button') end
                end,
            attach = {major =  G.blind_select.UIRoot.children[1].children[1], type = 'tr', offset = {x = 2, y = 4}},
            step = step,
            no_button = true,
            button_listen = 'select_blind'
        })
    elseif _part == 'big_blind' then 
        step = tutorial_info({
            text_key = 'bb_1',
            highlight = {
                G.blind_select.UIRoot.children[1].children[2].config.object:get_UIE_by_ID('blind_name'),
                G.blind_select.UIRoot.children[1].children[2].config.object:get_UIE_by_ID('blind_desc'),
            },
            hard_set = true,
            attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'bb_2',
            highlight = {
                G.blind_select.UIRoot.children[1].children[2].config.object:get_UIE_by_ID('blind_name'),
                G.blind_select.UIRoot.children[1].children[2].config.object:get_UIE_by_ID('tag_desc'),
            },
            attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'bb_3',
            highlight = {
                G.blind_select.UIRoot.children[1].children[3].config.object:get_UIE_by_ID('blind_name'),
                G.blind_select.UIRoot.children[1].children[3].config.object:get_UIE_by_ID('blind_desc'),
            },
            attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'bb_4',
            highlight = {
                G.blind_select.UIRoot.children[1].children[3].config.object:get_UIE_by_ID('blind_name'),
                G.blind_select.UIRoot.children[1].children[3].config.object:get_UIE_by_ID('blind_desc'),
                G.blind_select.UIRoot.children[1].children[3].config.object:get_UIE_by_ID('blind_extras'),
                G.HUD:get_UIE_by_ID('hud_ante')
            },
            attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'bb_5',
            loc_vars = {G.GAME.win_ante},
            highlight = {
                G.blind_select,
                G.HUD:get_UIE_by_ID('hud_ante')
            },
            attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
            step = step,
            no_button = true,
            snap_to = function() 
                if G.blind_select and G.blind_select.UIRoot and G.blind_select.UIRoot.children[1] and G.blind_select.UIRoot.children[1].children[2] and
                G.blind_select.UIRoot.children[1].children[2].config.object then 
                    return G.blind_select.UIRoot.children[1].children[2].config.object:get_UIE_by_ID('select_blind_button') end
                end,
            button_listen = 'select_blind'
        })
    elseif _part == 'first_hand' then
        step = tutorial_info({
            text_key = 'fh_1',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'fh_2',
            highlight = {
                G.HUD:get_UIE_by_ID('hand_text_area')
            },
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'fh_3',
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            highlight = {
                G.HUD:get_UIE_by_ID('run_info_button')
            },
            no_button = true,
            button_listen = 'run_info',
            snap_to = function() return G.HUD:get_UIE_by_ID('run_info_button') end,
            step = step,
        })
    elseif _part == 'first_hand_2' then
        step = tutorial_info({
            hard_set = true,
            text_key = 'fh_4',
            highlight = {
                G.hand,
                G.HUD:get_UIE_by_ID('run_info_button')
            },
            attach = {major = G.hand, type = 'cl', offset = {x = -1.5, y = 0}},
            snap_to = function() return G.hand.cards[1] end,
            step = step,
        })
        step = tutorial_info({
            text_key = 'fh_5',
            highlight = {
                G.hand,
                G.buttons:get_UIE_by_ID('play_button'),
                G.HUD:get_UIE_by_ID('run_info_button')
            },
            attach = {major = G.hand, type = 'cl', offset = {x = -1.5, y = 0}},
            no_button = true,
            button_listen = 'play_cards_from_highlighted',
            step = step,
        })
    elseif _part == 'first_hand_3' then
        step = tutorial_info({
            hard_set = true,
            text_key = 'fh_6',
            highlight = {
                G.hand,
                G.buttons:get_UIE_by_ID('discard_button'),
                G.HUD:get_UIE_by_ID('run_info_button')
            },
            attach = {major = G.hand, type = 'cl', offset = {x = -1.5, y = 0}},
            no_button = true,
            button_listen = 'discard_cards_from_highlighted',
            step = step,
        })
    elseif _part == 'first_hand_4' then
        step = tutorial_info({
            hard_set = true,
            text_key = 'fh_7',
            highlight = {
                G.HUD:get_UIE_by_ID('hud_hands').parent,
            },
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
        step = tutorial_info({
            text_key = 'fh_8',
            highlight = {
                G.HUD:get_UIE_by_ID('hud_hands').parent,
                G.HUD:get_UIE_by_ID('row_dollars_chips'),
                G.HUD_blind
            },
            attach = {major = G.ROOM_ATTACH, type = 'cm', offset = {x = 0, y = 0}},
            step = step,
        })
    elseif _part == 'second_hand' then
        step = tutorial_info({
            text_key = 'sh_1',
            hard_set = true,
            highlight = {
                G.jokers
            },
            attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
            step = step,
        })
        local empress = find_joker('The Empress')[1]
        if empress then 
            step = tutorial_info({
                text_key = 'sh_2',
                highlight = {
                    empress
                },
                attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
                step = step,
            })
            step = tutorial_info({
                text_key = 'sh_3',
                attach = {major =  G.HUD, type = 'cm', offset = {x = 0, y = -2}},
                highlight = {
                    empress,
                    G.hand
                },
                no_button = true,
                button_listen = 'use_card',
                snap_to = function() return G.hand.cards[1] end,
                step = step,
            })
        end
    elseif _part == 'shop_1' then
        step = tutorial_info({
            hard_set = true,
            text_key = 's_1',
            highlight = {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent
            },
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 4}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_2',
            highlight = {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.shop_jokers.cards[2],
            },
            snap_to = function() return G.shop_jokers.cards[2] end,
            attach = {major = G.shop, type = 'tr', offset = {x = -0.5, y = 6}},
            no_button = true,
            button_listen = 'buy_from_shop',
            step = step,
        })
        step = tutorial_info({
            text_key = 's_3',
            loc_vars = {#G.P_CENTER_POOLS.Joker},
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.jokers.cards[1],
            } end,
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_4',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.jokers.cards[1],
            } end,
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_5',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.jokers,
            } end,
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_6',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.shop_jokers.cards[1],
            } end,
            snap_to = function() return G.shop_jokers.cards[1] end,
            no_button = true,
            button_listen = 'buy_from_shop',
            attach = {major = G.shop, type = 'tr', offset = {x = -0.5, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_7',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.consumeables.cards[#G.consumeables.cards],
            } end,
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_8',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.consumeables
            } end,
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_9',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.shop_vouchers,
            } end,
            snap_to = function() return G.shop_vouchers.cards[1] end,
            attach = {major = G.shop, type = 'tr', offset = {x = -4, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_10',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.shop_vouchers,
            } end,
            attach = {major = G.shop, type = 'tr', offset = {x = -4, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_11',
            highlight = function() return {
                G.SHOP_SIGN,
                G.HUD:get_UIE_by_ID('dollar_text_UI').parent.parent.parent,
                G.shop_booster,
            } end,
            snap_to = function() return G.shop_booster.cards[1] end,
            attach = {major = G.shop, type = 'tl', offset = {x = 3, y = 6}},
            step = step,
        })
        step = tutorial_info({
            text_key = 's_12',
            highlight = function() return {
                G.shop:get_UIE_by_ID('next_round_button'),
            } end,
            snap_to = function() if G.shop then return G.shop:get_UIE_by_ID('next_round_button') end end,
            no_button = true,
            button_listen = 'toggle_shop',
            attach = {major = G.shop, type = 'tm', offset = {x = 0, y = 6}},
            step = step,
        })
    end

    
    G.E_MANAGER:add_event(Event({
        blockable = false,
        timer = 'REAL',
        func = function()
            if (G.OVERLAY_TUTORIAL.step == step and
            not G.OVERLAY_TUTORIAL.step_complete) or G.OVERLAY_TUTORIAL.skip_steps then
                if G.OVERLAY_TUTORIAL.Jimbo then G.OVERLAY_TUTORIAL.Jimbo:remove() end
                if G.OVERLAY_TUTORIAL.content then G.OVERLAY_TUTORIAL.content:remove() end
                G.OVERLAY_TUTORIAL:remove()
                G.OVERLAY_TUTORIAL = nil
                G.SETTINGS.tutorial_progress.hold_parts[_part]=true
                return true
            end
            return G.OVERLAY_TUTORIAL.step > step or G.OVERLAY_TUTORIAL.skip_steps
        end
    }), 'tutorial') 
    G.SETTINGS.paused = false
end
