
SMODS.Challenge {
    key = "doom",
    loc_txt = {
        name = "Wheel of Doom",
        text = {
            'Applies the {C:EF_plant_spectral}Wheel of Doom{} effect'
        }
    },
    restrictions = {
        banned_other = {
            { id = 'bl_plant', type = 'blind' },
            { id = 'bl_pillar', type = 'blind' },
            { id = 'bl_goad', type = 'blind' },
        }
    },
    deck = {
        type = 'Challenge Deck',
        cards = {
            {s='S',r='J',e="m_steel",d="polychrome",g="Red"},
            {s='S',r='J',e="m_steel",d="polychrome",g="Red"},
            {s='S',r='J',e="m_steel",d="polychrome",g="Red"},
            {s='S',r='J',e="m_steel",d="polychrome",g="Red"},
        }
    }
}