BossJokers = SMODS.current_mod
BossJokers.BossJokerList = {
	"j_mpbj_the_arm",
	"j_mpbj_the_club",
	"j_mpbj_the_eye",
	"j_mpbj_the_fish",
	"j_mpbj_the_flint",
	"j_mpbj_the_goad",
	"j_mpbj_the_head",
	"j_mpbj_the_hook",
	"j_mpbj_the_house",
	"j_mpbj_the_manacle",
	"j_mpbj_the_mark",
	"j_mpbj_the_mouth",
	"j_mpbj_the_ox",
	"j_mpbj_the_pillar",
	"j_mpbj_the_plant",
	"j_mpbj_the_psychic",
	"j_mpbj_the_tooth",
	"j_mpbj_the_water",
	"j_mpbj_the_wheel",
	"j_mpbj_the_window"
}

function BossJokers.load_file(file)
	local chunk, err = SMODS.load_file(file, "BossJokers")
	if chunk then
		local ok, func = pcall(chunk)
		if ok then
			return func
		else
			sendWarnMessage("Failed to process file: " .. func, "BossJokers")
		end
	else
		sendWarnMessage("Failed to find or compile file: " .. tostring(err), "BossJokers")
	end
	return nil
end

function BossJokers.load_dir(directory)
	local files = NFS.getDirectoryItems(BossJokers.path .. "/" .. directory)
	local regular_files = {}

	for _, filename in ipairs(files) do
		local file_path = directory .. "/" .. filename
		if file_path:match(".lua$") then
			if filename:match("^_") then
				BossJokers.load_file(file_path)
			else
				table.insert(regular_files, file_path)
			end
		end
	end

	for _, file_path in ipairs(regular_files) do
		BossJokers.load_file(file_path)
	end
end

SMODS.Atlas({
	key = "modicon",
	path = "modicon.png",
	px = 34,
	py = 34,
})

BossJokers.load_dir("localization")
BossJokers.load_dir("misc")
BossJokers.load_dir("objects/Editions")
BossJokers.load_dir("objects/Jokers")
BossJokers.load_dir("objects/Tags")
BossJokers.load_dir("rulesets")
