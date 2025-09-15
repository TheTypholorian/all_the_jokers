SMODS.Challenge {
    key = 'printing_press',
    rules = {
        custom = {
            { id = 'no_shop_jokers' },
        },
    },
    jokers = {
        { id = 'j_riff_raff', eternal = true, edition = 'negative', pinned = false },
        { id = 'j_bccp_fax_machine', eternal = true, edition = 'negative', pinned = false },
    },
    restrictions = {
        banned_cards = {
            { id = 'p_buffoon_normal_1', ids = {
                'p_buffoon_normal_1', 'p_buffoon_normal_2', 'p_buffoon_jumbo_1', 'p_buffoon_mega_1',
            }
            },
        },
        banned_tags = {
            { id = 'tag_uncommon' },
            { id = 'tag_rare' },
            { id = 'tag_negative' },
            { id = 'tag_foil' },
            { id = 'tag_holographic' },
            { id = 'tag_polychrome' },
            { id = 'tag_buffoon' },
            { id = 'tag_top_up' },
        }
    }
}