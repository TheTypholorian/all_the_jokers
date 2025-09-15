-- I replaced a lovely patch with this, since hooking is generally more stable
-- Since it's a vanilla function, you're less likely to run into an issue when SMODS updates ~Winter
local ref_loc_colour = loc_colour
function loc_colour(_c, _default)
	ref_loc_colour(_c, _default)
	G.ARGS.LOC_COLOURS.mug = G.C.MUG
    G.ARGS.LOC_COLOURS.vhs = G.C.VHS
    G.ARGS.LOC_COLOURS.stand = G.C.STAND
    return G.ARGS.LOC_COLOURS[_c] or _default or G.C.UI.TEXT_DARK
end

-- I put this in misc_functions because this is where similar functions are in Vanilla ~Winter

--- Resets the rank used by the Paper Moon King stand card
function csau_reset_paper_rank()
    G.GAME.current_round.paper_rank = 'Jack'
	local valid_ranks = {}
    for _, rank in pairs(SMODS.Ranks) do
        if rank.face then valid_ranks[#valid_ranks+1] = rank.key end
    end
	G.GAME.current_round.paper_rank = pseudorandom_element(valid_ranks, pseudoseed('papermoon'..G.GAME.round_resets.ante))
end

function is_perfect_square(x)
	local sqrt = math.sqrt(x)
	return sqrt^2 == x
end

--- Calculation for Fibonacci Scoring
function csau_get_fibonacci(hand)
	local ret = {}
	if #hand < 5 then return ret end
	local vals = {}
	for i = 1, #hand do
		local value = hand[i].base.nominal
		if hand[i].base.value == 'Ace' then
			value = 1
		elseif SMODS.has_no_rank(hand[i]) then
			value = 0
		end
		
		vals[#vals+1] = value
	end
	table.sort(vals, function(a, b) return a < b end)

	if not vals[1] == 0 and not (is_perfect_square(5 * vals[1]^2 + 4) or is_perfect_square(5 * vals[1]^2 - 4)) then
		return ret
	end

	local sum = 0
	local prev_1 = vals[1]
	local prev_2 = 0
	for i=1, #vals do
		sum = prev_1 + prev_2
		
		if vals[i] ~= sum then
			return ret
		end

		prev_2 = prev_1
		prev_1 = vals[i] == 0 and 1 or vals[i]
	end

	local t = {}
	for i=1, #hand do
		t[#t+1] = hand[i]
	end

	table.insert(ret, t)
	return ret
end

function set_stand_win()
	G.PROFILES[G.SETTINGS.profile].stand_usage = G.PROFILES[G.SETTINGS.profile].stand_usage or {}
	for k, v in pairs(G.consumeables.cards) do
		if v.config.center_key and v.ability.set == 'csau_Stand' then
			G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key] = G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key] or {count = 1, order = v.config.center.order, wins = {}, losses = {}, wins_by_key = {}, losses_by_key = {}}
			if G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key] then
				G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key].wins = G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key].wins or {}
				G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key].wins[G.GAME.stake] = (G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key].wins[G.GAME.stake] or 0) + 1
				G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key].wins_by_key[SMODS.stake_from_index(G.GAME.stake)] = (G.PROFILES[G.SETTINGS.profile].stand_usage[v.config.center_key].wins_by_key[SMODS.stake_from_index(G.GAME.stake)] or 0) + 1
			end
		end
	end
	G:save_settings()
end

function get_stand_win_sticker(_center, index)
	if not G.PROFILES[G.SETTINGS.profile].stand_usage then return 0 end
	local stand_usage = G.PROFILES[G.SETTINGS.profile].stand_usage[_center.key] or {}
	if stand_usage.wins then
		if SMODS and SMODS.can_load then
			local applied = {}
			local _count = 0
			local _stake = nil
			for k, v in pairs(stand_usage.wins_by_key or {}) do
				SMODS.build_stake_chain(G.P_STAKES[k], applied)
			end
			for i, v in ipairs(G.P_CENTER_POOLS.Stake) do
				if applied[v.order] then
					_count = _count+1
					if (v.stake_level or 0) > (_stake and G.P_STAKES[_stake].stake_level or 0) then
						_stake = v.key
					end
				end
			end
			if index then return _count end
			if _count > 0 then return G.sticker_map[_stake] end
		else
			local _stake = 0
			for k, v in pairs(G.PROFILES[G.SETTINGS.profile].stand_usage[_center.key].wins or {}) do
				_stake = math.max(k, _stake)
			end
			if index then return _stake end
			if _stake > 0 then return G.sticker_map[_stake] end
		end
	end
	if index then return 0 end
end

local ref_spp = set_profile_progress
function set_profile_progress()
	ref_spp()
	G.PROGRESS.stand_stickers = {tally = 0, of = 0}
	for _, v in pairs(G.P_CENTERS) do
		if v.set == 'csau_Stand' then
			G.PROGRESS.stand_stickers.of = G.PROGRESS.stand_stickers.of + #G.P_CENTER_POOLS.Stake
			G.PROGRESS.stand_stickers.tally = G.PROGRESS.stand_stickers.tally + get_stand_win_sticker(v, true)
		end
	end
	G.PROFILES[G.SETTINGS.profile].progress.stand_stickers = copy_table(G.PROGRESS.stand_stickers)
end


function get_flush(hand, sub_count)
  local ret = {}
  local suits = SMODS.Suit.obj_buffer
  if #hand < (5 - (math.min(sub_count, 4) or 0)) then return ret else
    for j = 1, #suits do
      local t = {}
      local suit = suits[j]
      local flush_count = 0
      for i=1, #hand do
        if hand[i]:is_suit(suit, nil, true) then flush_count = flush_count + 1;  t[#t+1] = hand[i] end 
      end
      if flush_count >= (5 - (math.min(sub_count, 4) or 0)) then
        table.insert(ret, t)
        return ret
      end
    end
    return {}
  end
end

local ref_alert_space = alert_no_space
alert_no_space = function(card, area)
	if card.config.center.key == 'j_csau_ufo' then
		G.CONTROLLER.locks.no_space = true
		attention_text({
			scale = 0.9, text = localize('k_ufo_alert'), hold = 0.9, align = 'cm',
			cover = area, cover_padding = 0.1, cover_colour = adjust_alpha(G.C.BLACK, 0.7)
		})
		card:juice_up(0.3, 0.2)
		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.06*G.SETTINGS.GAMESPEED,
			blockable = false,
			blocking = false,
			func = function()
				play_sound('tarot2', 0.76, 0.4);
				return true
			end
		}))
		play_sound('tarot2', 1, 0.4)

		G.E_MANAGER:add_event(Event({
			trigger = 'after',
			delay = 0.5*G.SETTINGS.GAMESPEED,
			blockable = false,
			blocking = false,
			func = function()
				G.CONTROLLER.locks.no_space = nil
				return true 
			end
		}))
		return
	end
	
	return ref_alert_space(card, area)
end