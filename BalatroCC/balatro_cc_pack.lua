
--Creates an atlas for cards to use
SMODS.Atlas {
	-- Key for code to find it with
	key = "ModdedVanilla",
	-- The name of the file, for the code to pull the atlas from
	path = "ModdedVanilla.png",
	-- Width of each sprite in 1x size
	px = 71,
	-- Height of each sprite in 1x size
	py = 95
}

-- load all jokers
local subdir = "jokers"
local cards = NFS.getDirectoryItems(SMODS.current_mod.path .. subdir)
for _, filename in pairs(cards) do
    if string.sub(filename, string.len(filename) - 3) == '.lua' then
        assert(SMODS.load_file(subdir .. "/" .. filename))()
    end
end

-- load all challenges
local subdir = "challenges"
local cards = NFS.getDirectoryItems(SMODS.current_mod.path .. subdir)
for _, filename in pairs(cards) do
    if string.sub(filename, string.len(filename) - 3) == '.lua' then
        assert(SMODS.load_file(subdir .. "/" .. filename))()
    end
end