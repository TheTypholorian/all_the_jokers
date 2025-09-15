SMODS.Atlas {
  key = "modicon",
  path = "mod_icon.png",
  px = 34,
  py = 34,
}

SMODS.Atlas {
  key = "KHJokers",
  path = "KHJokers.png",
  px = 71,
  py = 95,
}

SMODS.Atlas({
  key = 'consumabels',
  px = 71,
  py = 95,
  path = 'consumabels.png'
})


SMODS.Atlas({
  key = 'decks',
  px = 71,
  py = 95,
  path = 'decks.png'
})

SMODS.Atlas {
  key = "KHSleeves",
  path = "cardsleeves.png",
  px = 71,
  py = 95,
}

SMODS.Atlas({
  key = 'khblind',
  path = 'blinds.png',
  px = 34,
  py = 34,
  frames = 21,
  atlas_table = 'ANIMATION_ATLAS'
})

KH = SMODS.current_mod

KH.save_config = function(self)
  SMODS.save_mod_config(self)
end

-- config
KH.config_tab = function()
  return {
    n = G.UIT.ROOT,
    config = {
      r = 0.1, minw = 5, align = "cm", padding = 0.2, colour = G.C.BLACK
    },
    nodes = {

      create_toggle({
        id = "enable_jokers",
        label = localize("k_khjokers_config_jokers"),
        info = { localize('k_khjokers_config_restart') },
        ref_table = KH.config,
        ref_value = "enable_jokers",
        callback = function()
          KH:save_config()
        end,
      }),

      create_toggle({
        id = "enable_tarots",
        label = localize("k_khjokers_config_tarots"),
        info = { localize('k_khjokers_config_restart') },
        ref_table = KH.config,
        ref_value = "enable_tarots",
        callback = function()
          KH:save_config()
        end
      }),

      create_toggle({
        id = "enable_spectrals",
        label = localize("k_khjokers_config_spectrals"),
        info = { localize('k_khjokers_config_restart') },
        ref_table = KH.config,
        ref_value = "enable_spectrals",
        callback = function()
          KH:save_config()
        end
      }),


      create_toggle({
        id = "enable_seal",
        label = localize("k_khjokers_config_seal"),
        info = { localize('k_khjokers_config_restart') },
        ref_table = KH.config,
        ref_value = "enable_seal",
        callback = function()
          KH:save_config()
        end
      }),

      create_toggle({
        id = "enable_blind",
        label = localize("k_khjokers_config_blind"),
        info = { localize('k_khjokers_config_restart') },
        ref_table = KH.config,
        ref_value = "enable_blind",
        callback = function()
          KH:save_config()
        end
      }),

    }
  }
end

if KH.config.enable_jokers then
  local subdir = "content/cards"
  local cards = NFS.getDirectoryItems(SMODS.current_mod.path .. subdir)
  for _, filename in pairs(cards) do
    assert(SMODS.load_file(subdir .. "/" .. filename))()
  end
  SMODS.load_file("content/challenges/challenges.lua")() -- Loads Challenges if Jokers are enabled
end

if KH.config.enable_tarots then
  SMODS.load_file("content/consumables/tarots.lua")()
end

if KH.config.enable_spectrals then
  SMODS.load_file("content/consumables/spectrals.lua")()
end

if KH.config.enable_seal then
  SMODS.load_file("content/consumables/seal.lua")()
end

if KH.config.enable_blind then
  SMODS.load_file("content/blinds/blinds.lua")()
end

-- load Friends of Jimbo
SMODS.load_file("content/collabs/kingdomheartsxbalatro.lua")()

-- Joker Display Compat
if JokerDisplay then
  SMODS.load_file("content/JokerDisplay/joker_display_definitions.lua")()
end

-- Decks
SMODS.Back {
  key = 'kingdom',
  atlas = 'decks',
  pos = { x = 0, y = 0 },
  config = { vouchers = { "v_overstock_norm" }, },
  loc_vars = function(self, info_queue, center)
  end,
  calculate = function(self, back, context)
  end
}

-- CardSleeves Support!
if CardSleeves then
  CardSleeves.Sleeve {
    key       = 'kingdom',
    deck_buff = 'b_kh_kingdom',
    atlas     = 'KHSleeves',
    pos       = { x = 0, y = 0 },

    loc_vars  = function(self)
      local key, vars
      if self.get_current_deck_key() == "b_kh_kingdom" then
        key = self.key .. "_alt"
        self.config = { vouchers = { "v_overstock_plus" } }
        vars = { self.config.vouchers }
      else
        key = self.key
        self.config = { vouchers = { "v_overstock_norm" } }
        vars = { self.config.vouchers }
      end
      return { key = key, vars = vars }
    end,

    calculate = function(self, sleeve, context)
    end
  }
end
