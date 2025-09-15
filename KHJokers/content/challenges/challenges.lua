SMODS.Challenge {
  key = 'seasaltmadness',
  loc_txt = {
    name = "Sea Salt Madness"
  },
  jokers = {
    { id = "j_kh_sealsalt", eternal = true },
    { id = "j_kh_roxas",    eternal = true },

  },
  rules = {
    custom = {
      { id = 'debuff_played_cards' },
    },
  },
  deck = {
    type = "Challenge Deck",
    cards = {
      { s = 'C', r = 'A', g = 'Blue' },
      { s = 'D', r = 'A', g = 'Blue' },
      { s = 'H', r = 'A', g = 'Blue' },
      { s = 'S', r = 'A', g = 'Blue' },
      { s = 'C', r = 'K', g = 'Blue' },
      { s = 'D', r = 'K', g = 'Blue' },
      { s = 'H', r = 'K', g = 'Blue' },
      { s = 'S', r = 'K', g = 'Blue' },
      { s = 'C', r = 'Q', g = 'Blue' },
      { s = 'D', r = 'Q', g = 'Blue' },
      { s = 'H', r = 'Q', g = 'Blue' },
      { s = 'S', r = 'Q', g = 'Blue' },
      { s = 'C', r = 'J', g = 'Blue' },
      { s = 'D', r = 'J', g = 'Blue' },
      { s = 'H', r = 'J', g = 'Blue' },
      { s = 'S', r = 'J', g = 'Blue' },
      { s = 'C', r = 'T', g = 'Blue' },
      { s = 'D', r = 'T', g = 'Blue' },
      { s = 'H', r = 'T', g = 'Blue' },
      { s = 'S', r = 'T', g = 'Blue' },
      { s = 'C', r = '9', g = 'Blue' },
      { s = 'D', r = '9', g = 'Blue' },
      { s = 'H', r = '9', g = 'Blue' },
      { s = 'S', r = '9', g = 'Blue' },
      { s = 'C', r = '8', g = 'Blue' },
      { s = 'D', r = '8', g = 'Blue' },
      { s = 'H', r = '8', g = 'Blue' },
      { s = 'S', r = '8', g = 'Blue' },
      { s = 'C', r = '7', g = 'Blue' },
      { s = 'D', r = '7', g = 'Blue' },
      { s = 'H', r = '7', g = 'Blue' },
      { s = 'S', r = '7', g = 'Blue' },
      { s = 'C', r = '6', g = 'Blue' },
      { s = 'D', r = '6', g = 'Blue' },
      { s = 'H', r = '6', g = 'Blue' },
      { s = 'S', r = '6', g = 'Blue' },
      { s = 'C', r = '5', g = 'Blue' },
      { s = 'D', r = '5', g = 'Blue' },
      { s = 'H', r = '5', g = 'Blue' },
      { s = 'S', r = '5', g = 'Blue' },
      { s = 'C', r = '4', g = 'Blue' },
      { s = 'D', r = '4', g = 'Blue' },
      { s = 'H', r = '4', g = 'Blue' },
      { s = 'S', r = '4', g = 'Blue' },
      { s = 'C', r = '3', g = 'Blue' },
      { s = 'D', r = '3', g = 'Blue' },
      { s = 'H', r = '3', g = 'Blue' },
      { s = 'S', r = '3', g = 'Blue' },
      { s = 'C', r = '2', g = 'Blue' },
      { s = 'D', r = '2', g = 'Blue' },
      { s = 'H', r = '2', g = 'Blue' },
      { s = 'S', r = '2', g = 'Blue' },
    }
  }
}

SMODS.Challenge {
  key = 'got_it_memorized',
  loc_txt = {
    name = "Got it Memorized?"
  },
  jokers = {
    { id = "j_kh_axel", eternal = true },
  },
  rules = {
    custom = {
      { id = "kh_got_it_memorized" },
      { id = "no_skipping" },
    },
  },
  deck = {
    type = "Challenge Deck",
  },
  restrictions = {
    banned_cards = {
      { id = "j_luchador" },
      { id = "j_chicot" },
      { id = "j_throwback" },
      { id = "j_diet_cola" },
      { id = "v_directors_cut" },
      { id = "v_retcon" },
    },
    banned_other = {},
  },
}

SMODS.Challenge {
  key = 'tick_tock',
  loc_txt = {
    name = "Tick Tock"
  },
  jokers = {
    { id = "j_kh_luxord" },
  },
  rules = {
    custom = {
      { id = "no_skipping" },
    },
  },
  deck = {
    type = "Challenge Deck",
  },
  restrictions = {
    banned_cards = {
      { id = "j_throwback" },
      { id = "j_diet_cola" },
    },
    banned_other = {},
  },
}
