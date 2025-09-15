--- We can't do this because synergies with some VHS tapes require that we be able to move Stands around -keku
--[[
local ref_align_cards = CardArea.align_cards
function CardArea:align_cards()
    local ret = ref_align_cards(self)
    -- hate doing this after it already sorted and ranked the cards but w/e
    if self.config.type == 'joker' then
        table.sort(self.cards, function (a, b)
            if a.ability.set == 'csau_Stand' and b.ability.set ~= 'csau_Stand' then
                return true
            elseif a.ability.set ~= 'csau_Stand' and b.ability.set == 'csau_Stand' then
                return false
            end

            return a.T.x + a.T.w/2 < b.T.x + b.T.w/2 
        end)
    end   
    for k, card in ipairs(self.cards) do
        card.rank = k
    end

    return ret
end
]]--
