--Mod icon
SMODS.Atlas({
    key = "modicon",
    path = "icon.png",
    px = 32,
    py = 32
})

local create_UIBox_main_menu_buttonsRef = create_UIBox_main_menu_buttons
function create_UIBox_main_menu_buttons()
    local t = create_UIBox_main_menu_buttonsRef()
    
    table.insert(t.nodes, 2, {n=G.UIT.C, config={align="cm", minw=0.75}, nodes={}})

    local main_bar = t.nodes[1].nodes[1]
   
    main_bar.nodes[2].config.align = "tm"
    
    -- swap quit and mods buttons
    local mods_button = main_bar.nodes[4]
    main_bar.nodes[4] = main_bar.nodes[2].nodes[3]
    main_bar.nodes[2].nodes[3] = mods_button
    
    -- options button
    main_bar.nodes[2].nodes[1].nodes[1].config.minh = 0.7
    main_bar.nodes[2].nodes[1].nodes[1].nodes[1].config.minw = 2.25
    main_bar.nodes[2].nodes[1].n = G.UIT.R
    
    -- separator
    main_bar.nodes[2].nodes[2].config = {align = "cm", minh = 0.15}
    main_bar.nodes[2].nodes[2].n = G.UIT.R
    
    -- mods button
    main_bar.nodes[2].nodes[3].nodes[1].config.minh = 0.7
    main_bar.nodes[2].nodes[3].nodes[1].nodes[1].config.minw = 2.25
    main_bar.nodes[2].nodes[3].n = G.UIT.R

    -- quit button
    main_bar.nodes[4].nodes[1].nodes[1].config.minh = 1.55
    main_bar.nodes[4].nodes[1].nodes[1].config.minw = 2.25

    -- swap collection and options|mods buttons
    local collection_button = main_bar.nodes[3]
    main_bar.nodes[3] = main_bar.nodes[2]
    main_bar.nodes[2] = collection_button


    return(t)
end