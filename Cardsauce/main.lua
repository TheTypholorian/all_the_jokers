-- Removed the deprecated header metadata in favor of the current json one
-- look in Cardsauce.json for that info! ~Winter

SMODS.current_mod.optional_features = {
	retrigger_joker = true,
	quantum_enhancements = true,
}

UsableModPath = SMODS.current_mod.path:match("Mods/[^/]+")
PathPatternReplace = UsableModPath:gsub("(%W)","%%%1")  -- shoot me in the foot, why doesn't lua just have a str.replace
csau_config = SMODS.current_mod.config
csau_enabled = copy_table(csau_config)

SMODS.current_mod.DT = {
	def_deckskin = 'joel', -- 'vinny' or nil for Vine Characters, 'joel' for Joel characters
	ortalab_dlc = false,
}

-- I put the colors here I guess
G.C.STAND = HEX('B85F8E')
G.C.VHS = HEX('a2615e')
G.C.MUG = HEX('db9a4d')

local includes = {
	-- includes utility functions required for following files
	'tables',
	'utility',
	'ui',
	'shaders',
	'compat',
	'music',

	-- object hooks
	'hooks/game',
	'hooks/button_callbacks',
	'hooks/card',
	'hooks/cardarea',
	'hooks/state_events',
	'hooks/common_events',
	'hooks/misc_functions',
	'hooks/UI_definitions',
	'hooks/overrides',
	'hooks/smods',

	-- option files
	--- jokers are required for some following files so include them first
	
	'skins',
	'colors',
	'items',
	'achievements',
}

-- blank function that is run on starting the main menu,
-- other parts of the mod can hook into this to run code
-- that needs to be run after the game has initialized
G.FUNCS.initPostSplash = function() end

for _, include in ipairs(includes) do
	local init, error = SMODS.load_file("includes/" .. include ..".lua")
	if error then sendErrorMessage("[Cardsauce] Failed to load "..include.." with error "..error) else
		local data = init()
		sendDebugMessage("[Cardsauce] Loaded hook: " .. include)
	end
end
