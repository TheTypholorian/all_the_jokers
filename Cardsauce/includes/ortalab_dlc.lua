local itemsToLoad = {
    Joker = {
        'piss',
        'expiredmeds',
        'puyo'
    },
}

for k, v in pairs(itemsToLoad) do
    if next(itemsToLoad[k]) then
        if csau_filter_loading('set', {key = k}) then
            for i = 1, #v do
                load_cardsauce_item(v[i], k, nil, {ortalab = true})
            end
        end
    end
end