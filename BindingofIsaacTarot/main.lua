--- STEAMODDED HEADER
--- MOD_NAME: Binding of Isaac Tarot
--- MOD_ID: isaac_tarot
--- PREFIX: isaac
--- MOD_AUTHOR: [Zamos]
--- MOD_DESCRIPTION: Tarot cards from The Binding of Isaac
--- VERSION: 1.0.0
--- DEPENDENCIES: [malverk]


AltTexture({
    key = 'tarot',
    set = 'Tarot',
    path = 'isaac_tarots.png',
    loc_txt = {
        name = 'Isaac Tarot'
    }
})
TexturePack{
    key = 'isaac',
    textures = {
        'isaac_tarot'
    },
    loc_txt = {
        name = 'Binding of Isaac Tarot',
        text = {
            'Binding of Isaac themed',
            '{C:tarot}Tarot{} cards'
        }
    }
}
