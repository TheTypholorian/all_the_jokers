--- STEAMODDED HEADER
--- MOD_NAME: Casey
--- MOD_ID: casey_cat
--- PREFIX: casey_cat
--- MOD_AUTHOR: [cat.bread]
--- MOD_DESCRIPTION: Replaces Lucky Cat with my cat, Casey. 
--- VERSION: 1.0.0
--- DEPENDENCIES: [malverk]

AltTexture{ -- Lucky Cat 
    key = 'casey', -- alt_tex key
    set = 'Joker', -- set to act upon
    path = 'casey.png', -- path of sprites
    keys = { -- keys of objects to change
        'j_lucky_cat'
    },
    localization = { -- keys of objects with new localizations
        j_lucky_cat = {
            name = 'Casey'
         }
     }
}

TexturePack{ -- Aure
    key = 'casey', -- texpack key
    textures = { -- keys of AltTextures in this TexturePack
        'casey_cat_casey'
    }
}
