EF = EF or {}

function EF.destroy_random_joker(seed)
    if not seed then
        seed = 'Destroy_joker'
    end

    local deletable_jokers = {}
    for _, joker in pairs(G.jokers.cards) do
        if not joker.ability.eternal then deletable_jokers[#deletable_jokers + 1] = joker end
    end

    local chosen_joker = pseudorandom_element(deletable_jokers, seed)
    if chosen_joker then
        chosen_joker:start_dissolve()
    end
end

function EF.get_most_played_hands()
  local hands = {}

  for _, v in ipairs(G.P_CENTER_POOLS.Planet) do
    if v.config and v.config.hand_type then
      local hand = G.GAME.hands[v.config.hand_type]

      if hand and hand.visible then
        hands[#hands + 1] = {
          key = v.config.hand_type,
          hand = hand,
          planet_key = v.key
        }
      end
    end
  end

  table.sort(hands, function(a, b)
    if a.hand.played ~= b.hand.played then
      return a.hand.played > b.hand.played
    end

    -- Sort by base values if the played amount is equal
    return (a.hand.s_mult * a.hand.s_chips) > (b.hand.s_mult * b.hand.s_chips)
  end)

  return hands
end

---@param x number
---@return string
function EF.normal_hour_to_am_pm(x) -- maybe add a config option to toggle between 12h and 24h
  if x < 0 or x > 24 then
    return "ERR at EF.normal_hour_to_am_pm"
  elseif x == 0 or x == 24 then
    return "12 AM"
  elseif 1 <= x and x <= 11 then
    return x.." AM"
  elseif 12 <= x and x <= 23 then
    return (x-12).." PM"
  end
  return "wtf at EF.normal_hour_to_am_pm"
end

---@return osdate
function EF.get_time_table()
  ---@diagnostic disable-next-line: return-type-mismatch
  return os.date("*t", os.time())
end

---performs a time check using `immutable.min_hour` and `immutable.max_hour` from card's config
---@param card Card
---@return boolean
function EF.hour_check(card)
  G.GAME.EF_stopwatch_voucher = G.GAME.EF_stopwatch_voucher or false
  local time = EF.get_time_table()
  local hour = time.hour + time.min/60
  if (card.ability.immutable.min_hour <= hour and hour <= card.ability.immutable.max_hour) -- normal check
      or G.GAME.EF_stopwatch_voucher -- voucher
      then
    return true
  end
  return false
end