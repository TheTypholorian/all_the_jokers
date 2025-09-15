G.C.EF = {
    PLANT = HEX("199e19"),
    IDEA_CREDIT = HEX("2be3a0"),
    ART_CREDIT = HEX("2b4ae3"),
    IDEA_ART_CREDIT = HEX("2b97c2"),
}

-- https://github.com/nh6574/JoyousSpring/blob/main/src/globals.lua#L71
local loc_colour_ref = loc_colour 
---@diagnostic disable-next-line: lowercase-global
function loc_colour(_c, _default)
    if not G.ARGS.LOC_COLOURS then
        loc_colour_ref()
    end
    G.ARGS.LOC_COLOURS.ef_plant = G.C.EF.PLANT

    return loc_colour_ref(_c, _default)
end
