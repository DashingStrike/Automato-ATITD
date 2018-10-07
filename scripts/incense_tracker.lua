-- incense_assist.lua by Ashen
--
-- Assists in incense research by logging incense starts and logging stats
-- before/after each ingredient is added (along with the ingredient).
-- Log files are CSV format to allow import into excel or post-processing
-- (e.g. maybe digraph generation or mathematical analysis?)
--
-- Two files are generated:
--
--	incensestarts.txt logs only starts (when you start a new batch). 
--	Each line/entry has the following format:
--
--		quality,scent,feeling,pos/neg
--
--	incenseadds.txt logs changes with each addition of an ingredient.
--	Each line/entry has the following format:
--
--		quality,scent,feeling,pos/neg,ingredient,quality,scent,feeling,pos/neg
--
--	...where the values to the left of the ingredient are the stats before
--	and those to the right of the ingredient are the stats after the ingredient
--	is added.
--
--	Incense taken through the macro UI are automatically named as follows:
--
--		Scent Feeling +Stat -Stat
--
--	(The game itself adds the quality to the name.)
--
dofile("common.inc");

resins = {
	"Anaxi",
	"Arconis",
	"Ash Palm",
	"Beetlenut",
	"Bloodbark",
	"Bottle Tree",
	"Bramble Hedge",
	"Broadleaf Palm",
	"Butterleaf Tree",
	"Cerulean Blue",
	"Chakkanut Tree",
	"Chicory",
	"Cinnar",
	"Coconut Palm",
	"Cricklewood",
	"Deadwood Tree",
	"Delta Palm",
	"Elephantia",
	"Feather Tree",
	"Fern Palm",
	"Folded Birch",
	"Giant Cricklewood",
	"Hawthorn",
	"Hokkaido",
	"Kaeshra",
	"Locust Palm",
	"Mini Palmetto",
	"Miniature Fern Palm",
	"Monkey Palm",
	"Oil Palm",
	"Oleaceae",
	"Orrorin",
	"Passam",
	"Phoenix Palm",
	"Pratyeka Tree",
	"Ranyahn",
	"Razor Palm",
	"Red Maple",
	"Royal Palm",
	"Savaka",
	"Scaley Hardwood",
	"Spiked Fishtree",
	"Spindle Tree",
	"Stout Palm",
	"Tapacae Miralis",
	"Tiny Oil Palm",
	"Towering Palm",
	"Trilobellia",
	"Umbrella Palm",
	"Windriver Palm",
};

herbs = {
	"Allbright",
	"Aloe",
	"Altar's Blessing",
	"Anansi",
	"Apiphenalm",
	"Apothecary's Scythe",
	"Artemesia",
	"Asafoetida",
	"Asane",
	"Ashoka",
	"Azure Tristeria",
	"Banto",
	"Bay Tree",
	"Bee Balm",
	"Beetle Leaf",
	"Beggar's Button",
	"Bhillawa",
	"Bilimbi",
	"Bitter Florian",
	"Black Pepper Plant",
	"Blessed Mariae",
	"Bleubaille",
	"Blood Balm",
	"Blood Blossom",
	"Blood Root",
	"Blooded Harebell",
	"Bloodwort",
	"Blue Damia",
	"Blue Tarafern",
	"Blueberry Tea Tree",
	"Bluebottle Clover",
	"Blushing Blossom",
	"Brassy Caltrops",
	"Brown Muskerro",
	"Buckler-leaf",
	"Bull's Blood",
	"Burnt Tarragon",
	"Butterfly Damia",
	"Butterroot",
	"Calabash",
	"Camelmint",
	"Caraway",
	"Cardamom",
	"Cassia",
	"Chaffa",
	"Chatinabrae",
	"Chives",
	"Chukkah",
	"Cicada Bean",
	"Cinnamon",
	"Cinquefoil",
	"Cirallis",
	"Clingroot",
	"Common Basil",
	"Common Rosemary",
	"Common Sage",
	"Corsacia",
	"Covage",
	"Crampbark",
	"Cranesbill",
	"Creeping Black Nightshade",
	"Creeping Thyme",
	"Crimson Clover",
	"Crimson Lettuce",
	"Crimson Nightshade",
	"Crimson Pipeweed",
	"Crimson Windleaf",
	"Crumpled Leaf Basil",
	"Curly Sage",
	"Cyan Cressidia",
	"Daggerleaf",
	"Dalchini",
	"Dameshood",
	"Dank Mullien",
	"Dark Ochoa",
	"Dark Radish",
	"Death's Piping",
	"Deadly Catsclaw",
	"Dewplant",
	"Digweed",
	"Discorea",
	"Drapeau D'or",
	"Dusty Blue Sage",
	"Dwarf Hogweed",
	"Dwarf Wild Lettuce",
	"Earth Apple",
	"Elegia",
	"Enchanter's Plant",
	"Finlow",
	"Fire Allspice",
	"Fire Lily",
	"Fivesleaf",
	"Flaming Skirret",
	"Flander's Blossom",
	"Fleabane",
	"Fool's Agar",
	"Fumitory",
	"Garcinia",
	"Garlic Chives",
	"Ginger Root",
	"Ginger Tarragon",
	"Ginseng Root",
	"Glechoma",
	"Gnemnon",
	"Gokhru",
	"Golden Doubloon",
	"Golden Gladalia",
	"Golden Sellia",
	"Golden Sweetgrass",
	"Golden Sun",
	"Golden Thyme",
	"Gynura",
	"Harebell",
	"Harrow",
	"Hazlewort",
	"Headache Tree",
	"Heartsease",
	"Hogweed",
	"Homesteader Palm",
	"Honey Mint",
	"Houseleek",
	"Hyssop",
	"Ice Blossom",
	"Ice Mint",
	"Ilex",
	"Indigo Damia",
	"Ipomoea",
	"Jagged Dewcup",
	"Jaivanti",
	"Jaiyanti",
	"Joy of the Mountain",
	"Jugwort",
	"Katako Root",
	"Khokali",
	"King's Coin",
	"Lamae",
	"Larkspur",
	"Lavender Navarre",
	"Lavender Scented Thyme",
	"Lemon Basil",
	"Lemon Grass",
	"Lemondrop",
	"Lilia",
	"Liquorice",
	"Lungclot",
	"Lythrum",
	"Mahonia",
	"Maliceweed",
	"Mandrake Root",
	"Maragosa",
	"Mariae",
	"Meadowsweet",
	"Medicago",
	"Mindanao",
	"Miniature Bamboo",
	"Miniature Lamae",
	"Mirabellis Fern",
	"Moon Aloe",
	"Morpha",
	"Motherwort",
	"Mountain Mint",
	"Myristica",
	"Myrrh",
	"Naranga",
	"Nubian Liquorice",
	"Octec's Grace",
	"Opal Harebell",
	"Orange Niali",
	"Orange Sweetgrass",
	"Orris",
	"Pale Dhamasa",
	"Pale Ochoa",
	"Pale Russet",
	"Pale Skirret",
	"Panoe",
	"Paradise Lily",
	"Patchouli",
	"Peppermint",
	"Pippali",
	"Pitcher Plant",
	"Primula",
	"Prisniparni",
	"Pulmonaria Opal",
	"Purple Tintiri",
	"Quamash",
	"Red Pepper Plant",
	"Revivia",
	"Rhubarb",
	"Royal Rosemary",
	"Rubia",
	"Rubydora",
	"Sacred Palm",
	"Sagar Ghota",
	"Sandalwood",
	"Sandy Dustweed",
	"Satsatchi",
	"Schisandra",
	"Shrub Sage",
	"Shrubby Basil",
	"Shyama",
	"Shyamalata",
	"Sickly Root",
	"Silvertongue Damia",
	"Skirret",
	"Sky Gladalia",
	"Soapwort",
	"Sorrel",
	"Spinach",
	"Spinnea",
	"Squill",
	"Steel Bladegrass",
	"Stickler Hedge",
	"Strawberry Tea",
	"Strychnos",
	"Sugar Cane",
	"Sweet Groundmaple",
	"Sweetflower",
	"Sweetgrass",
	"Sweetsop",
	"Tagetese",
	"Tamarask",
	"Tangerine Dream",
	"Thunder Plant",
	"Thyme",
	"Tiny Clover",
	"Trilobe",
	"Tristeria",
	"True Tarragon",
	"Tsangto",
	"Tsatso",
	"Turtle's Shell",
	"Umber Basil",
	"Upright Ochoa",
	"Vanilla Tea Tree",
	"Verdant Squill",
	"Verdant Two-Lobe",
	"Wasabi",
	"Weeping Patala",
	"White Pepper Plant",
	"Whitebelly",
	"Wild Garlic",
	"Wild Lettuce",
	"Wild Onion",
	"Wild Yam",
	"Wood Sage",
	"Xanat",
	"Xanosi",
	"Yava",
	"Yellow Gentian",
	"Yellow Tristeria",
	"Yigory",
	"Zanthoxylum",
};

petals = {
	"Bloodheart",
	"Dawn's Blush",
	"Goldenleaves",
	"Hatch's Bud",
	"Heart of Darkness",
	"Night Bloom",
	"Onion Skin",
	"Pantomime",
	"Pink Giant",
	"Red Dwarf",
	"White Giant",
};

posstats = {
	["dexterity"] = "+Dex",
	["perception"] = "+Per",
	["focus"] = "+Foc",
	["constitution"] = "+Con",
	["endurance"] = "+End",
	["speed"] = "+Spd",
	["strength"] = "+Str",
}

negstats = {
	["clumsyness"] = "-Dex",
	["confusion"] = "-Per",
	["forgetfulness"] = "-Foc",
	["fragility"] = "-Con",
	["lethargy"] = "-End",
	["sluggishness"] = "-Spd",
	["weakness"] = "-Str",
};

per_click_delay = 150;
per_read_delay = 300;
batchInProgress = false;
toAddIngredient = "";
toAddQuantity = 0;
incQuality = 0;
incScent = "";
incFeeling = "";
incPositive = "";
incNegative = "";
newQuality = 0;
newScent = "";
newFeeling = "";
newPositive = "";
newNegative = "";
incChanged = false;
totalAdds = 0;
errmsg = "";

function resetStats()
	incQuality = 0;
	incScent = "";
	incFeeling = "";
	incPositive = "";
	incNegative = "";
	totalAdds = 0;
	errmsg = "";
	incChanged = false;
	batchInProgress = false;
end

function checkIfMain(chatText)
	for j = 1, #chatText do
		if string.find(chatText[j][2], "^%*%*", 0) then
			return true;
		end
	end
	return false;
end

function updateStats()
	incQuality = newQuality;
	incScent = newScent;
	incFeeling = newFeeling;
	incPositive = newPositive;
	incNegative = newNegative;
end

function formatCSV(quality, scent, feeling, positive, negative)
	csv = "" .. quality .. "," .. scent .. "," .. feeling .. "," .. positive .. "/" .. negative .. "";
	return csv;
end

function saveIncenseStart()
	entry = formatCSV(incQuality, incScent, incFeeling, incPositive, incNegative);

	fh = io.open("incensestarts.txt", "a+");
	fh:write(entry .. "\n");
	fh:close();
end

function saveIncenseChange(ingred)
	old = formatCSV(incQuality, incScent, incFeeling, incPositive, incNegative);
	new = formatCSV(newQuality, incScent, newFeeling, newPositive, newNegative);
	entry = old .. "," .. ingred .. "," .. new;

	fh = io.open("incenseadds.txt", "a+");
	fh:write(entry .. "\n");
	fh:close();
end

function startBatch()
	for try=1,30 do
		refreshLab();

		srReadScreen();
		local p = findText("Start a batch of incense", nil);

		if p then
			clickText(p);
			lsSleep(per_click_delay);

			-- TODO: check for and handle error window? (if sap/cc aren't in inventory, an OK
			-- window with "To start a batch of incense requires" pops up.)

			if burnPinch() then
				updateStats();
				saveIncenseStart();
				batchInProgress = true;
			end

			return;
		end
	end

	errmsg = "Start Batch button not found";
end

function takeBatch()
	srReadScreen();
	local p = findText("Take the Incense", nil);

	if p then
		clickText(p);
		lsSleep(per_click_delay);

		-- Name the incense
		incName = incScent .. " " .. incFeeling .. " " .. incPositive .. " " .. incNegative;

		-- Send incense name

		for i=1,string.len(incName) do
			srCharEvent(string.sub(incName,i,i));
			lsSleep(10);
		end

		srKeyDown(13);
		lsSleep(25);
		srKeyUp(13);

		refreshLab();
		resetStats();

		return;
	end

	errmsg = "Take Incense button not found";
end

function addIngredient(group, ingred)
	srReadScreen();
	local menu = "Add " .. group;
	local p = findText(menu .. "...", nil);

	if p then
		clickText(p);
		lsSleep(per_click_delay);

		srReadScreen();
		p = findText(ingred, nil);

		if p then
			clickText(p);
			lsSleep(per_click_delay);

			if burnPinch() then
				saveIncenseChange(ingred);
				updateStats();
				totalAdds = totalAdds + 1;
				errmsg = "";
			end
		else
			errmsg = ingred .. " button not found";
			srKeyDown(27);
			lsSleep(25);
			srKeyUp(27);
		end
	else
		errmsg = menu .. " menu button not found";
	end
end

function parseChat()
	for try=1,10 do
		srReadScreen();
		local chatText = getChatText();
		local onMain = checkIfMain(chatText);

		-- Wait for Main chat screen and alert user if its not showing
		while not onMain do
			checkBreak();
			srReadScreen();
			chatText = getChatText();
			onMain = checkIfMain(chatText);
			sleepWithStatus(500, "Looking for Main chat screen...\n\nMake sure main chat tab is showing and that the window is sized, wide enough, so that no lines wrap to next line.\n\nAlso if you main chat tab is minimized, you need to check Options, Interface Option, Minimized chat-channels are still visible.", nil, 0.7, 0.7);
		end

		lastLine = chatText[#chatText][2];
		lastLineParse = string.sub(lastLine,string.find(lastLine,"m]")+3,string.len(lastLine));

		quality, scent, feeling, pos, neg = string.match(lastLineParse, "You catch a whiff of quality (%d+) (%D+) scented incense. You are filled with a (%D+) (%D+), yet a bit of (%D+).");

		if ((quality ~= nil) and (scent ~= nil) and (feeling ~= nil) and (pos ~= nil) and (neg ~= nil)) then
			newQuality = tonumber(quality);
			newScent = scent;
			newFeeling = feeling;
			newPositive = posstats[pos];
			newNegative = negstats[neg];

			if ((newQuality ~= incQuality) or (newScent ~= incScent) or (newFeeling ~= incFeeling) or (newPositive ~= incPostive) or (newNegative ~= incNegative)) then
				return true;
			end
		end

		lsSleep(100);
	end

	errmsg = "Failed to read stats chat msg";
	return false;
end

function burnPinch()
	for try=1,30 do
		refreshLab();

		srReadScreen();
		local p = findText("Burn a little pinch of the mixture", nil);

		if p then
			clickText(p);
			lsSleep(per_click_delay);
			lsSleep(per_read_delay);
			return parseChat();
		end
	end

	errmsg = "Burn Pinch button not found";
end

function displayStatus()
	y = 6;

	lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
	y = y + 12;

	lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Alt+Shift to pause this script.");
	y = y + 24;

	lsPrint(10, y, 0, 0.7, 0.7, 0xFF0000ff, errmsg);
	y = y + 24;

	if (incQuality > 0) then
		lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Quality: ");
		lsPrint(100, y, 0, 0.7, 0.7, 0xB0B0B0ff, incQuality);
		y = y + 12;
		lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Scent: ");
		lsPrint(100, y, 0, 0.7, 0.7, 0xB0B0B0ff, incScent);
		y = y + 12;
		lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Feeling: ");
		lsPrint(100, y, 0, 0.7, 0.7, 0xB0B0B0ff, incFeeling);
		y = y + 12;
		lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Stats: ");
		lsPrint(100, y, 0, 0.7, 0.7, 0xB0B0B0ff, incPositive .. "/" .. incNegative);
		y = y + 12;
		lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Total Adds: ");
		lsPrint(100, y, 0, 0.7, 0.7, 0xB0B0B0ff, totalAdds);
		y = y + 24;
	end
	
	if (batchInProgress) then
		lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Add Herb: ");
		y = y + 16;
		dd_herb_value = lsDropdown("thisHerb", 10, y, 0, 200, dd_herb_value, herbs);
		add_herb = lsButtonText(220, y, 0, 35, 0x00FF00ff, "+");
		y = y + 35;

		lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Add Resin: ");
		y = y + 16;
		dd_resin_value = lsDropdown("thisResin", 10, y, 0, 200, dd_resin_value, resins);
		add_resin = lsButtonText(220, y, 0, 35, 0x00FF00ff, "+");
		y = y + 35;

		lsPrint(10, y, 0, 0.7, 0.7, 0xB0B0B0ff, "Add Petals: ");
		y = y + 16;
		dd_petal_value = lsDropdown("thisPetal", 10, y, 0, 200, dd_petal_value, petals);
		add_petal = lsButtonText(220, y, 0, 35, 0x00FF00ff, "+");
		y = y + 35;

		if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0xFFFFFFff, "Take Batch") then
			takeBatch();
		end
	else
		if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0xFFFFFFff, "Start Batch") then
			startBatch();
		end
	end

	if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
		error "Clicked End Script button";
	end

	if (add_herb) then
		addIngredient("Herb", herbs[dd_herb_value]);
	end
	
	if (add_resin) then
		addIngredient("Resin", resins[dd_resin_value]);
	end

	if (add_petal) then
		addIngredient("Petals", petals[dd_petal_value]);
	end

	checkBreak();
	lsDoFrame();
end

function refreshLab()
	srReadScreen();
	labWindow = findText("This is [a-z]+ Scent Lab", nil, REGEX);

	if labWindow == nil then
		errmsg = "Lab window not found";
		return;
	end

	clickText(labWindow);
	lsSleep(per_click_delay);
end

function initWindow()
	for try=1,30 do
		refreshLab();
		srReadScreen();

		local p = findText("Start a batch of incense", nil);

		if p then
			return;
		end

		p = findText("Burn a little pinch of the mixture", nil);

		if p then
			if burnPinch() then
				batchInProgress = true;
				updateStats();
			end
			return;
		end
	end

	error "Start Batch/Burn Pinch text not found";
end
	
function doit()
	last_time = lsGetTimer() + 5000;
	
	askForWindow("Pin Scent Lab and Add Resin/Herb/Petals menus and press SHIFT over the ATITD window.");
	
	srReadScreen();
	labWindow = findText("This is [a-z]+ Scent Lab", nil, REGEX);
	
	if labWindow == nil then
		error "Did not find any Scent Lab window";
	end

	initWindow();

	while 1 do
		srReadScreen();
		local chatText = getChatText();
		local onMain = checkIfMain(chatText);

		-- Wait for Main chat screen and alert user if its not showing
		while not onMain do
			checkBreak();
			srReadScreen();
			chatText = getChatText();
			onMain = checkIfMain(chatText);
			sleepWithStatus(500, "Looking for Main chat screen...\n\nMake sure main chat tab is showing and that the window is sized, wide enough, so that no lines wrap to next line.\n\nAlso if you main chat tab is minimized, you need to check Options, Interface Option, Minimized chat-channels are still visible.", nil, 0.7, 0.7);
		end

		displayStatus();
		lsSleep(25);
		
		checkBreak();
	end
end
