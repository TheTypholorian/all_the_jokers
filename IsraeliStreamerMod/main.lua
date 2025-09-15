--- STEAMODDED HEADER
--- MOD_NAME: Israeli Streamer Mod
--- MOD_ID: ILSTREAMERMOD
--- MOD_AUTHOR: [SimplyRan , SimplyRan , SimplyRan , Autist & Shotist]
--- MOD_DESCRIPTION: Bituah Leumi Ha Bitahon Sheli
--- PREFIX: xmpl
----------------------------------------------
------------MOD CODE -------------------------




SMODS.Atlas{
    key = 'tree_force', --atlas key
    path = 'forceee.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Atlas{
    key = 'blackbeard', --atlas key
    path = 'blackbeard.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Atlas{
    key = 'sho', --atlas key
    path = 'sho.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}


SMODS.Atlas{
    key = 'amit_shiber', --atlas key
    path = 'amitshiber.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Atlas{
    key = 'ronengg', --atlas key
    path = 'ronengg.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Atlas{
    key = 'odedsvr', --atlas key
    path = 'odedsvr.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Atlas{
    key = 'snacksss', --atlas key
    path = 'snacksss.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}
SMODS.Atlas{
    key = 'kingsnacksss', --atlas key
    path = 'kingsnacksss.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Atlas{
    key = 'zagron', --atlas key
    path = 'zagron.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Atlas{
    key = 'smammit', --atlas key
    path = 'smammit.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Atlas{
    key = 'bigi', --atlas key
    path = 'bigi.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Atlas{
    key = 'yanivu', --atlas key
    path = 'yanivu.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Atlas{
    key = 'maorbalatro', --atlas key
    path = 'maorbalatro.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Atlas{
    key = 'forceee_femboy', --atlas key
    path = 'forceee_femboy.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}

SMODS.Atlas{
    key = 'oded_odelyn', --atlas key
    path = 'oded_odelyn.png', --atlas' path in (yourMod)/assets/1x or (yourMod)/assets/2x
    px = 71, --width of one card
    py = 95 -- height of one card
}


local subdir = "jokers"
local jokers = NFS.getDirectoryItems(SMODS.current_mod.path .. subdir)
for _, filename in pairs(jokers) do
    if string.sub(filename, string.len(filename) - 3) == '.lua' then
        assert(SMODS.load_file(subdir .. "/" .. filename))()
    end
end


  
----------------------------------------------
------------MOD CODE END----------------------
    
