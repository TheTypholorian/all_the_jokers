--- STEAMODDED HEADER
--- MOD_NAME: LGBT Mult Cards
--- MOD_ID: lgbt_mult_cards
--- PREFIX: lgbt
--- MOD_AUTHOR: [Chicken]
--- MOD_DESCRIPTION: LGBT Mult Cards
--- VERSION: 1.0.0
--- DEPENDENCIES: [malverk]

SMODS.Atlas({
    key = "modicon",
    path = "icon.png",
    px = 34,
    py = 34
})

AltTexture({
    key = 'lgbt_enhancers',
    set = 'Enhanced',
    path = 'lgbt_enhancers.png',
    keys = {'m_mult'},
    original_sheet = 'true',
    loc_txt = {
      name = 'lgbt_enhancers'
    }
})


TexturePack({
    key = 'lgbt_skin',
    textures = {
      'lgbt_enhancers'
    },
    loc_txt = {
      name = 'LGBT_tex',
      text = {'LGBT Mult cards'}
    }
})
----------------------------------------------
------------MOD CODE END----------------------