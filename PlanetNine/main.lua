-- Planet Nine - Retexture
AltTexture({
    key = "tx_planetnine_retexture",   -- the key of the texture
    set = "Planet",                    -- define the object type that you are retexturing, see wiki for full list of types
    path = "planetnine_retexture.png", -- the filename of your spritesheet, saved in assets/1x AND assets/2x
    keys = {                           -- keys of objects to change
        "c_planet_x",
    },
    localization = { -- keys of objects with new localizations
        "c_planet_x",
    },
})

-- Planet Nine - Name Only
AltTexture({
    key = "tx_planetnine_nameonly",   -- the key of the texture
    set = "Planet",                   -- define the object type that you are retexturing, see wiki for full list of types
    path = "planetnine_nameonly.png", -- the filename of your spritesheet, saved in assets/1x AND assets/2x
    keys = {                          -- keys of objects to change
        "c_planet_x",
    },
    localization = { -- keys of objects with new localizations
        "c_planet_x",
    },
})

-- Pluto & Charon - Left Variant
AltTexture({
    key = "tx_pluto_charon_l",   -- the key of the texture
    set = "Planet",            -- define the object type that you are retexturing, see wiki for full list of types
    path = "pluto_charon_l.png", -- the filename of your spritesheet, saved in assets/1x AND assets/2x
    keys = {                   -- keys of objects to change
        "c_pluto",
    },
})

-- Pluto & Charon - Right Variant
AltTexture({
    key = "tx_pluto_charon_r",   -- the key of the texture
    set = "Planet",            -- define the object type that you are retexturing, see wiki for full list of types
    path = "pluto_charon_r.png", -- the filename of your spritesheet, saved in assets/1x AND assets/2x
    keys = {                   -- keys of objects to change
        "c_pluto",
    },
})

-- Texture Pack
TexturePack({
    key = "tp_planetnine", -- the key of the texture pack
    textures = {           -- a table of keys of your AltTexture objects
        "planetnine_tx_planetnine_retexture",
        "planetnine_tx_planetnine_nameonly",
        "planetnine_tx_pluto_charon_l",
        "planetnine_tx_pluto_charon_r",
    },
    toggle_textures = {    -- a table of keys of AltTexture objects that start disabled
        "planetnine_tx_planetnine_nameonly",
        "planetnine_tx_pluto_charon_r",
    },
})
