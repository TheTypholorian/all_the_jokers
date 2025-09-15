--- STEAMODDED HEADER
--- MOD_NAME: Marco
--- MOD_ID: marco_cat
--- PREFIX: marco_cat
--- MOD_AUTHOR: [Cozmo496]
--- MOD_DESCRIPTION: replaces the lucky cat with my cat, marco.
--- VERSION: 1.0.0
--- DEPENDENCIES: [malverk]

AltTexture{ -- Lucky Cat 
    key = 'marco', -- alt_tex key
    set = 'Joker', -- set to act upon
    path = 'marco.png', -- path of sprites
    keys = { -- keys of objects to change
        'j_lucky_cat'
    },
    localization = { -- keys of objects with new localizations
        j_lucky_cat = {
            name = 'Marco'
         }
     }
}

TexturePack{ -- Aure
    key = 'marco', -- texpack key
    textures = { -- keys of AltTextures in this TexturePack
        'marco_cat_marco'
    }
}
