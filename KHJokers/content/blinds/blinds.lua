SMODS.Blind {
  key = 'khblind',
  loc_txt = {
    name = 'Shuffled',
    text = {
      'Shuffles Jokers',
      'When hand is played',
    }
  },
  vars = {},
  dollars = 5,
  mult = 2,
  debuff = {},
  boss = { min = 2, max = 10 },
  boss_colour = HEX('c88465'),
  pos = { x = 0, y = 0 },
  atlas = 'khblind',
  press_play = function(self)
    G.E_MANAGER:add_event(Event({
      trigger = 'after',
      delay = 0.2,
      func = function()
        for i = 1, 3 do
          G.E_MANAGER:add_event(Event({
            trigger = 'after',
            delay = 0.15 * (i - 1),
            func = function()
              G.jokers:shuffle('aajk')
              play_sound('cardSlide1', 0.85 + 0.15 * i)
              return true
            end
          }))
        end
        return true
      end
    }))
  end
}
