--- STEAMODDED HEADER
--- MOD_NAME: LushUtil
--- MOD_ID: LushUtil
--- MOD_AUTHOR: [lusciousdev]
--- MOD_DESCRIPTION: Utility mod to facilitate adding Jokers.
----------------------------------------------
------------MOD CODE -------------------------

function sortByOrder(t, arg1, arg2)
  if t[arg2].order == nil then return true
  elseif t[arg1].order == nil then return false
  else
    if t[arg1].order < t[arg2].order then return true
    elseif t[arg1].order == t[arg2].order then return true
    elseif t[arg1].order > t[arg2].order then return false
    end
  end
end

function pairsByOrder(t, f)
  local a = {}
  for n in pairs(t) do table.insert(a, n) end
  table.sort(a, function(a, b) return sortByOrder(t, a, b) end)
  local i = 0      -- iterator variable
  local iter = function ()   -- iterator function
    i = i + 1
    if a[i] == nil then return nil
    else return a[i], t[a[i]]
    end
  end
  return iter
end

function addJokersToPools(jokerTable)
  -- Add Jokers to center
  for k, v in pairsByOrder(jokerTable) do
      v.key = k
      v.order = table_length(G.P_CENTER_POOLS['Joker']) + v.order
      G.P_CENTERS[k] = v
      table.insert(G.P_CENTER_POOLS['Joker'], v)
      if v.rarity and v.set == 'Joker' and not v.demo then
          table.insert(G.P_JOKER_RARITY_POOLS[v.rarity], v)
      end
  end

  table.sort(G.P_CENTER_POOLS["Joker"], function(a, b)
      return a.order < b.order
  end)
end

function updateLocalization(localizationTable)
  for k, v in pairs(localizationTable) do
      G.localization.descriptions.Joker[k] = v
  end
  
  -- Update localization
  for g_k, group in pairs(G.localization) do
      if g_k == 'descriptions' then
          for _, set in pairs(group) do
              for _, center in pairs(set) do
                  center.text_parsed = {}
                  for _, line in ipairs(center.text) do
                      center.text_parsed[#center.text_parsed + 1] = loc_parse_string(line)
                  end
                  center.name_parsed = {}
                  for _, line in ipairs(type(center.name) == 'table' and center.name or {center.name}) do
                      center.name_parsed[#center.name_parsed + 1] = loc_parse_string(line)
                  end
                  if center.unlock then
                      center.unlock_parsed = {}
                      for _, line in ipairs(center.unlock) do
                          center.unlock_parsed[#center.unlock_parsed + 1] = loc_parse_string(line)
                      end
                  end
              end
          end
      end
  end
end

----------------------------------------------
------------MOD CODE END----------------------