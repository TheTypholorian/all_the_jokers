LOVELY_INTEGRITY = 'e6c7a4c4ce98bcc7a1c3909abe67ae3f95a4a716c2e0a437ea50cdcb61002a78'

SMODS.Joker {
    key = 'perspective',
    atlas = 'Jokers',
    pos = {
        x = 8,
        y = 0
    },
    rarity = 1,
    mxms_credits = {
        art = { "Maxiss02" },
        code = { "theAstra" },
        idea = { "Maxiss02" }
    },
    blueprint_compat = false,
    cost = 3
}

-- Change Full House to not interfere with Perspective
SMODS.PokerHand:take_ownership('Full House', {
        evaluate = function(parts, hand)
            local val = {}
            if #parts._3 < 1 or #parts._2 < 2 or #hand < 5 then
              val = {}
            else
              val = parts._all_pairs
            end
            if true then return Bakery_API.maximus_full_house_compat(parts, val) end
            return parts._all_pairs
        end
    },
    true)
