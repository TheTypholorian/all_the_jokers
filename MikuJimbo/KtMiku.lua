--- STEAMODDED HEADER
--- MOD_NAME: Kaatokun Miku Jimbo
--- MOD_ID: KtMiku
--- PREFIX: miku
--- MOD_AUTHOR: [WitchofV, AgentWill]
--- MOD_DESCRIPTION: Turns Jimbo into Kaatokun's Joker Miku @Kaatokunart.bsky.social, modified by AgentWill to work with Malverk
--- DEPENDENCIES: [malverk]

AltTexture{
	key = 'jimbo',
	set = 'Joker',
	path = 'mikujimbo.png',
	keys = {
		'j_joker'
	}
}

TexturePack{
	key = 'mikujimbo',
	textures = {
		'miku_jimbo'
	},
	loc_txt = {
		name = 'Kaatokun Miku Jimbo',
		text = {
			'Retextures Jimbo',
			'to be {C:legendary}Joker Miku!{}',
			'Art by {E:1,C:dark_edition,S:1.1}Kaatokun',
			'{C:inactive,s:0.8}Code by AgentWill.{}',
			'Heavily inspired by the',
			'code of {E:1,C:dark_edition,s:1.1}Victin{}'
		}
	}
}