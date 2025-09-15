local blindInfo = {
    name = "The Finger",
    color = HEX('a88850'),
    pos = {x = 0, y = 0},
    dollars = 5,
    mult = 2,
    vars = {},
    debuff = { },
    boss = {min = 1, max = 10},
}

function blindInfo.defeat(self)
    check_for_unlock({ type = "defeat_finger" })
end

function blindInfo.debuff_hand(self, cards, hand, handname, check)
    return (not G.GAME.blind.disabled and handname == "High Card")
end

return blindInfo