--- STEAMODDED HEADER
--- MOD_NAME: solar
--- MOD_ID: solar
--- PREFIX: solar
--- MOD_AUTHOR: [LazyTurtle33]
--- MOD_DESCRIPTION: Replaces Space Joker with Solar 
--- VERSION: 1.0.0
--- DEPENDENCIES: [malverk]

AltTexture{
    key = 'solar', -- alt_tex key
    set = 'Joker', -- set to act upon
    path = 'solar.png', -- path of sprites
    keys = { -- keys of objects to change
        'j_space'
    },
    localization = { -- keys of objects with new localizations
        j_space = {
            name = 'Solar'
         }
     }
}

TexturePack{ -- Aure
    key = 'solar', -- texpack key
    textures = { -- keys of AltTextures in this TexturePack
        'solar_solar'
    }
}
