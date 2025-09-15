AltTexture({
    key = 'normal',
    set = 'Joker',
    path = 'glumbus.png',
    loc_txt = {
        name = 'glumbus'
    },
    keys = { 'j_lucky_cat' }
})

AltTexture({
    key = "plus",
    set = "Joker",
    path = "glumbus_plus.png",
    loc_txt = {
        name = "friends of glumbus"
    },
    keys = {
        'j_hologram',
        'j_stencil',
        'j_idol',
        'j_space',
        'j_drivers_license',
        'j_blackboard',
        'j_mime',
        'j_flower_pot',
        'j_smiley',
        'j_scholar',
        'j_burglar',
        'j_egg',
        'j_photograph',
        'j_gros_michel',
        'j_stuntman',
        'j_misprint',
        'j_oops',
        'j_even_steven',
        'j_odd_todd',
        'j_raised_fist',
        'j_8_ball'
    },
    soul_keys = {
        'j_hologram'
    }
})

TexturePack({
  key = 'glumbus', -- the key of the texture
  textures = {'glumbus_normal', 'glumbus_plus'}, -- a table of keys of your AltTexture objects
  loc_txt = {
    name = 'Glumbus',
    text = {'glumbus'}
  }
})

SMODS.Language({
    key = 'en-glumbus',
    label = 'English (mrow)',
})
