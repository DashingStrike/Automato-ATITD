dofile("common.inc");

essences = {
	{"ResinAnaxi",14},
	{"ResinArconis",82},
	{"ResinAshPalm",80},
	{"ResinBeetlenut",75},
	{"ResinBloodbark",40},
	{"ResinBottleTree",1},
	{"ResinBrambleHedge",22},
	{"ResinBroadleafPalm",16},
	{"ResinButterleafTree",11},
	{"ResinCeruleanBlue",10},
	{"ResinChakkanutTree",61},
	{"ResinChicory",58},
	{"ResinCinnar",30},
	{"ResinCoconutPalm",78},
	{"ResinCricklewood",40},
	{"ResinDeadwoodTree",},
	{"ResinDeltaPalm",41},
	{"ResinElephantia",88},
	{"ResinFeatherTree",24},
	{"ResinFernPalm",49},
	{"ResinFoldedBirch",79},
	{"ResinGiantCricklewood",29},
	{"ResinHawthorn",30},
	{"ResinHokkaido",48},
	{"ResinKaeshra",43},
	{"ResinLocustPalm",53},
	{"ResinMiniPalmetto",1},
	{"ResinMiniatureFernPalm",70},
	{"ResinMonkeyPalm",47},
	{"ResinOilPalm",77},
	{"ResinOleaceae",14},
	{"ResinOrrorin",52},
	{"ResinPassam",48},
	{"ResinPhoenixPalm",5},
	{"ResinPratyekaTree",20},
	{"ResinRanyahn",68},
	{"ResinRazorPalm",34},
	{"ResinRedMaple",74},
	{"ResinRoyalPalm",41},
	{"ResinSavaka",0},
	{"ResinScaleyHardwood",44},
	{"ResinSpikedFishtree",46},
	{"ResinSpindleTree",80},
	{"ResinStoutPalm",76},
	{"ResinTapacaeMiralis",24},
	{"ResinTinyOilPalm",13},
	{"ResinToweringPalm",90},
	{"ResinTrilobellia",57},
	{"ResinUmbrellaPalm",45},
	{"ResinWindriverPalm",65},
	{"PowderedDiamond",63},
	{"PowderedEmerald",88},
	{"PowderedOpal",82},
	{"PowderedQuartz",61},
	{"PowderedRuby",70},
	{"PowderedSapphire",27},
	{"PowderedTopaz",10},
	{"PowderedAmethyst",85},
	{"PowderedCitrine",45},
	{"PowderedGarnet",89},
	{"PowderedJade",8},
	{"PowderedLapis",25},
	{"PowderedSunstone",13},
	{"PowderedTurquoise",64},
	{"PowderedAquaPearl",73},
	{"PowderedBeigePearl",79},
	{"PowderedBlackPearl",30},
	{"PowderedCoralPearl",68},
	{"PowderedPinkPearl",71},
	{"PowderedSmokePearl",23},
	{"PowderedWhitePearl",6},
	{"SaltsOfAluminum",19},
	{"SaltsOfAntimony",66},
	{"SaltsOfCopper",8},
	{"SaltsOfGold",30},
	{"SaltsOfIron",52},
	{"SaltsOfLead",40},
	{"SaltsOfLithium",82},
	{"SaltsOfMagnesium",16},
	{"SaltsOfPlatinum",10},
	{"SaltsOfSilver",21},
	{"SaltsOfStrontium",34},
	{"SaltsOfTin",21},
	{"SaltsOfTitanium",57},
	{"SaltsOfTungsten",12},
	{"SaltsOfZinc",35},
	{"OysterShellMarbleDust",},
	{"Allbright",},
	{"Aloe",},
	{"AltarsBlessing",},
	{"Anansi",79},
	{"Apiphenalm",},
	{"ApothecarysScythe",},
	{"Artemesia",},
	{"Asafoetida",},
	{"Asane",},
	{"Ashoka",},
	{"AzureTristeria",},
	{"Banto",},
	{"BayTree",},
	{"BeeBalm",},
	{"BeetleLeaf",},
	{"BeggarsButton",},
	{"Bhillawa",},
	{"Bilimbi",},
	{"BitterFlorian",},
	{"BlackPepperPlant",48},
	{"BlessedMariae",},
	{"Bleubaille",},
	{"BloodBalm",},
	{"BloodBlossom",},
	{"BloodRoot",},
	{"BloodedHarebell",},
	{"Bloodwort",},
	{"BlueDamia",27},
	{"BlueTarafern",70},
	{"BlueberryTeaTree",},
	{"BluebottleClover",5},
	{"BlushingBlossom",},
	{"BrassyCaltrops",},
	{"BrownMuskerro",},
	{"Bucklerleaf",26},
	{"BullsBlood",},
	{"BurntTarragon",},
	{"ButterflyDamia",},
	{"Butterroot",},
	{"Calabash",},
	{"Camelmint",},
	{"Caraway",},
	{"Cardamom",63},
	{"Cassia",},
	{"Chaffa",50},
	{"Chatinabrae",27},
	{"Chives",42},
	{"Chukkah",},
	{"CicadaBean",},
	{"Cinnamon",3},
	{"Cinquefoil",},
	{"Cirallis",},
	{"Clingroot",},
	{"CommonBasil",32},
	{"CommonRosemary",73},
	{"CommonSage",46},
	{"Corsacia",},
	{"Covage",22},
	{"Crampbark",63},
	{"Cranesbill",},
	{"CreepingBlackNightshade",},
	{"CreepingThyme",},
	{"CrimsonClover",},
	{"CrimsonLettuce",43},
	{"CrimsonNightshade",},
	{"CrimsonPipeweed",},
	{"CrimsonWindleaf",},
	{"CrumpledLeafBasil",},
	{"CurlySage",},
	{"CyanCressidia",},
	{"Daggerleaf",58},
	{"Dalchini",},
	{"Dameshood",},
	{"DankMullien",},
	{"DarkOchoa",35},
	{"DarkRadish",},
	{"DeathsPiping",},
	{"DeadlyCatsclaw",},
	{"Dewplant",},
	{"Digweed",},
	{"Discorea",55},
	{"DrapeauDor",},
	{"DustyBlueSage",65},
	{"DwarfHogweed",8},
	{"DwarfWildLettuce",},
	{"EarthApple",},
	{"Elegia",},
	{"EnchantersPlant",},
	{"Finlow",69},
	{"FireAllspice",},
	{"FireLily",},
	{"Fivesleaf",},
	{"FlamingSkirret",},
	{"FlandersBlossom",},
	{"Fleabane",61},
	{"FoolsAgar",19},
	{"Fumitory",},
	{"Garcinia",31},
	{"GarlicChives",},
	{"GingerRoot",78},
	{"GingerTarragon",},
	{"GinsengRoot",59},
	{"Glechoma",50},
	{"Gnemnon",},
	{"Gokhru",},
	{"GoldenDoubloon",},
	{"GoldenGladalia",},
	{"GoldenSellia",},
	{"GoldenSweetgrass",},
	{"GoldenSun",},
	{"GoldenThyme",34},
	{"Gynura",55},
	{"Harebell",29},
	{"Harrow",},
	{"Hazlewort",47},
	{"HeadacheTree",},
	{"Heartsease",},
	{"Hogweed",87},
	{"HomesteaderPalm",},
	{"HoneyMint",},
	{"Houseleek",68},
	{"Hyssop",16},
	{"IceBlossom",},
	{"IceMint",},
	{"Ilex",},
	{"IndigoDamia",24},
	{"Ipomoea",},
	{"JaggedDewcup",},
	{"Jaivanti",},
	{"Jaiyanti",},
	{"JoyoftheMountain",},
	{"Jugwort",},
	{"KatakoRoot",9},
	{"Khokali",},
	{"KingsCoin",},
	{"Lamae",},
	{"Larkspur",},
	{"LavenderNavarre",},
	{"LavenderScentedThyme",},
	{"LemonBasil",},
	{"LemonGrass",},
	{"Lemondrop",30},
	{"Lilia",},
	{"Liquorice",},
	{"Lungclot",},
	{"Lythrum",63},
	{"Mahonia",},
	{"Maliceweed",},
	{"MandrakeRoot",},
	{"Maragosa",},
	{"Mariae",36},
	{"Meadowsweet",60},
	{"Medicago",},
	{"Mindanao",17},
	{"MiniatureBamboo",},
	{"MiniatureLamae",},
	{"MirabellisFern",},
	{"MoonAloe",},
	{"Morpha",35},
	{"Motherwort",13},
	{"MountainMint",59},
	{"Myristica",42},
	{"Myrrh",53},
	{"Naranga",},
	{"NubianLiquorice",},
	{"OctecsGrace",},
	{"OpalHarebell",83},
	{"OrangeNiali",72},
	{"OrangeSweetgrass",},
	{"Orris",},
	{"PaleDhamasa",77},
	{"PaleOchoa",65},
	{"PaleRusset",40},
	{"PaleSkirret",},
	{"Panoe",14},
	{"ParadiseLily",},
	{"Patchouli",},
	{"Peppermint",},
	{"Pippali",44},
	{"PitcherPlant",75},
	{"Primula",},
	{"Prisniparni",25},
	{"PulmonariaOpal",},
	{"PurpleTintiri",15},
	{"Quamash",},
	{"RedPepperPlant",75},
	{"Revivia",},
	{"Rhubarb",50},
	{"RoyalRosemary",},
	{"Rubia",},
	{"Rubydora",},
	{"SacredPalm",},
	{"SagarGhota",1},
	{"Sandalwood",},
	{"SandyDustweed",40},
	{"Satsatchi",27},
	{"Schisandra",},
	{"ShrubSage",80},
	{"ShrubbyBasil",26},
	{"Shyama",50},
	{"Shyamalata",},
	{"SicklyRoot",},
	{"SilvertongueDamia",25},
	{"Skirret",24},
	{"SkyGladalia",},
	{"Soapwort",},
	{"Sorrel",15},
	{"Spinach",73},
	{"Spinnea",},
	{"Squill",},
	{"SteelBladegrass",},
	{"SticklerHedge",2},
	{"StrawberryTea",10},
	{"Strychnos",},
	{"SugarCane",25},
	{"SweetGroundmaple",},
	{"Sweetflower",42},
	{"Sweetgrass",15},
	{"Sweetsop",10},
	{"Tagetese",16},
	{"Tamarask",},
	{"TangerineDream",11},
	{"ThunderPlant",},
	{"Thyme",17},
	{"TinyClover",80},
	{"Trilobe",},
	{"Tristeria",},
	{"TrueTarragon",17},
	{"Tsangto",6},
	{"Tsatso",},
	{"TurtlesShell",},
	{"UmberBasil",},
	{"UprightOchoa",},
	{"VanillaTeaTree",},
	{"VerdantSquill",38},
	{"VerdantTwo-Lobe",},
	{"Wasabi",},
	{"WeepingPatala",},
	{"WhitePepperPlant",},
	{"Whitebelly",},
	{"WildGarlic",},
	{"WildLettuce",70},
	{"WildOnion",60},
	{"WildYam",10},
	{"WoodSage",},
	{"Xanat",},
	{"Xanosi",33},
	{"Yava",},
	{"YellowGentian",},
	{"YellowTristeria",2},
	{"Yigory",82},
	{"Zanthoxylum",},
	{"CamelPheromoneFemale",},
	{"CamelPheromoneMale",}
};

tick_time = 100;
per_click_delay = 50;
per_read_delay = 150;

alcType = {};
alcType[3] = {"Wood", 1};
alcType[2] = {"Worm", 2};
alcType[1] = {"Grain", 3};
alcType[4] = {"Vegetable", 6};
alcType[5] = {"Mineral", 7};

function stripCharacters(s)
	local badChars = "%:%(%)%-%,%'%d%s";
	s = string.gsub(s, "[" .. badChars .. "]", "");
	return s;
end

function getSpirits(goal)
	local t = {};
	if goal < 10 then
		t[1] = {};
		t[1][1] = "Rock";
		t[1][2] = 10-goal;
		if goal ~= 0 then
			t[2] = {};
			t[2][1] = "Wood";
			t[2][2] = goal;
		end
		return t;
	end
	if goal == 81 or goal == 82 or goal == 83 then
		t[1] = {};
		t[1][1] = "Fish";
		t[1][2] = 10;
		return t;
	end
	if goal == 84 then
		t[1] = {};
		t[1][1] = "Grey";
		t[1][2] = 9;
		t[2] = {};
		t[2][1] = "Grain";
		t[2][2] = 1;
		return t;
	end
	if goal == 85 then
		if goal ~= 0 then
			t[1] = {};
			t[1][1] = "Mineral";
			t[1][2] = 1;
			t[2] = {};
			t[2][1] = "Vegetable";
			t[2][2] = 1;
			t[3] = {};
			t[3][1] = "Grey";
			t[3][2] = 8;
		end
		return t;
	end
	if goal == 83 then
		if goal ~= 0 then
			t[1] = {};
			t[1][1] = "Mineral";
			t[1][2] = 2;
			t[2] = {};
			t[2][1] = "Vegetable";
			t[2][2] = 1;
			t[3] = {};
			t[3][1] = "Grey";
			t[3][2] = 7;
		end
		return t;
	end
	if goal > 80 then
		alcType[7] = {"Grey", 9};
		alcType[6] = {"Fish", 8};
	else
		alcType[7] = nil;
		alcType[6] = nil;
	end
	if goal > 70 and goal <= 80 then
		t[1] = {};
		t[1][1] = "Fish";
		t[1][2] = goal - 70;
		if goal ~= 80 then
			t[2] = {};
			t[2][1] = "Mineral";
			t[2][2] = 80-goal;
		end
		return t;
	end
	for k = 1, #alcType do
		for l = 1, #alcType do
			for i = 10, 5, -1 do
				j = 10 - i;
				temp = alcType[k][2] * i + alcType[l][2] * j;
				if temp == goal then
					t[1] = {};
					t[1][1] = alcType[k][1];
					t[1][2] = i;
					if j ~= 0 then
						t[2] = {};
						t[2][1] = alcType[l][1];
						t[2][2] = j;
					end
					return t;
				end
			end
		end
	end
	--otherwise, we didn't find it
	
	for k = 1, #alcType do
		for l = 1, #alcType do
			for m = 1, #alcType do
				for i = 8, 5, -1 do
					j = 10 - i - 1;
					temp = alcType[k][2] * i + alcType[l][2] * j + alcType[m][2];
					if temp == goal then
						t[1] = {};
						t[2] = {};
						t[3] = {};
						t[1][1] = alcType[k][1];
						t[1][2] = i;
						t[2][1] = alcType[l][1];
						t[2][2] = j;
						t[3][1] = alcType[m][1];
						t[3][2] = 1;
						return t;
					end
				end
			end
		end
	end
end

function displayStatus()
	lsPrint(10, 6, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
	lsPrint(10, 18, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Alt+Shift to pause this script.");
	
	for window_index=1, #labWindows do
			lsPrint(10, 80 + 15*window_index, 0, 0.7, 0.7, 0xFFFFFFff, "#" .. window_index .. " - " .. labState[window_index].status);
	end
	if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0xFFFFFFff, "Finish up") then
		stop_cooking = 1;
	end
	if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
		error "Clicked End Script button";
	end
	
	checkBreak();
	lsDoFrame();
end

function clickAll(image_name, up)
	if nil then
		lsPrintln("Would click '".. image_name .. "'");
		return; -- not clicking buttons for debugging
	end
	-- Find buttons and click them!
	srReadScreen();
	xyWindowSize = srGetWindowSize();
	local buttons = findAllImages(image_name, nil, 1000);
	
	if #buttons ~= 0 then
		--statusScreen("Clicking " .. #buttons .. " button(s)...");
		if up then
			for i=#buttons, 1, -1  do
				srClickMouseNoMove(buttons[i][0]+2, buttons[i][1]+1, true);
				lsSleep(per_click_delay);
			end
		else
			for i=1, #buttons  do
				srClickMouseNoMove(buttons[i][0]+2, buttons[i][1]+1, true);
				lsSleep(per_click_delay);
			end
		end
		lsSleep(50);
		return true;
	end
	return false;
end

numFinished = 0;

function labTick(essWin, state)
	message = "";
	statusScreen("Starting ...", nil, 0.7, 0.7);
	state.count = state.count + 1;
	state.status = "Chem Lab: " .. state.count;
	state.active = false;
	local i;
	state.essenceIndex = nil;
	
	if state.finished then
		return;
	end
	
	--and here is where we add in the essence
	local outer;
	while outer == nil do
		safeClick(essWin.x + 10, essWin.y + essWin.height / 2);
		srReadScreen();
		statusScreen("Waiting to Click: Manufacture ...", nil, 0.7, 0.7);
		outer = findText("Manufacture...", essWin);
		lsSleep(per_read_delay);
		checkBreak();
	end
	clickText(outer);
--	lsSleep(per_click_delay);

	statusScreen("Waiting to Click: Essential Distill ...", nil, 0.7, 0.7);
	local t = waitForText("Essential Distill");
	clickText(t);
--	lsSleep(per_click_delay);
	statusScreen("Waiting to Click: Place Essential Mat ...", nil, 0.7, 0.7);
	t = waitForText("Place Essential Mat");
	clickText(t);
--	lsSleep(per_click_delay);

	statusScreen("Searching for Macerator ...", nil, 0.7, 0.7);
	--search for something to add
	local rw = waitForText("Choose a material", nil, nil, nil, REGION);
	rw.x = rw.x+7;
	rw.y = rw.y+29;
	rw.width = 204;
	rw.height = 240;
	local parse = findAllText(nil, rw);
	local foundEss = false;
	if parse then
		for i = 1, #parse do
			parse[i][2] = stripCharacters(parse[i][2]);
			if foundEss == false then
				for k = 1, #essences do
					if essences[k][2] ~= -1 and parse[i][2] == essences[k][1] and foundEss == false then
						state.essenceIndex = k;
						foundEss = true;
						clickText(parse[i]);
						message = "Added Macerator: " .. essences[k][1] .. "\n";
						state.temp = essences[k][2];
						if state.temp == nil then
						  error("That material has not yet been mapped.");
						end
					end
				end
			end
		end
	end
	
	
	if foundEss == false then
		state.status = "Couldn't find essence";
		numFinished = numFinished + 1;
		state.finished = 1;
		while clickAll("Cancel.png") == false do
			lsSleep(50);
		end
		lsSleep(100);
		return;
	end
	
	while clickAll("OK.png") == false do
		lsSleep(50);
	end
	
	lsSleep(per_read_delay);
	lsSleep(1000);
	
	local spiritsNeeded = getSpirits(state.temp);
	
	state.lastOffset = 10;
	
	for i = 1, #spiritsNeeded do
		--Add the alcohol
		clickText(waitForText("Manufacture...", nil, nil, essWin));
		lsSleep(per_click_delay);
		clickText(waitForText("Alcohol Lamp."));
		lsSleep(per_click_delay);
		clickText(waitForText("Fill Alcohol Lamp"), nil, 20, 1);
		lsSleep(per_click_delay);

		--click on the spirit itself
		message = message .. "\nAdding Spirits : " .. spiritsNeeded[i][2] .. " " .. spiritsNeeded[i][1];
		statusScreen(message, nil, 0.7, 0.7);
		clickText(waitForText(spiritsNeeded[i][1]));
		lsSleep(per_click_delay);
		waitForText("How much");
		srKeyEvent(spiritsNeeded[i][2] .. "\n");
		lsSleep(per_click_delay + per_read_delay)
		message = message .. " -- OK!"
	end
	
	clickText(waitForText("Manufacture...", nil, nil, essWin));
	lsSleep(per_click_delay + per_read_delay);
	t = waitForText("Essential Distill");
	clickText(t);
	lsSleep(per_click_delay);
	
	local image;
	
	while 1 do
		srReadScreen();
		image = srFindImage("StartDistillMini.png");
		if image then
			safeClick(image[0] + 2, image[1] + 2);
			lsSleep(per_click_delay);
			break;
		else
			statusScreen("Could not find start Essential, updating menu");
			--otherwise, search for place, and and update the menu
			clickText(t);
			lsSleep(200);
		end
	end
		safeClick(essWin.x + 10, essWin.y + essWin.height / 2);
	lsSleep(per_click_delay);
	return;
end

curActive = 1;

function doit()

	last_time = lsGetTimer() + 5000;
	
	askForWindow("Pin all Chemistry Laboratories");
	
	srReadScreen();
	labWindows = findAllText("This is [a-z]+ Chemistry Laboratory", nil, REGION+REGEX);
	
	if labWindows == nil then
		error 'Did not find any open windows';
	end
	
	labState = {};
	local last_ret = {};
	for window_index=1, #labWindows do
		labState[window_index] = {};
		labState[window_index].count = 0;
		labState[window_index].active = false;
		labState[window_index].status = "Initial";
		labState[window_index].needTest = 1;
	end
	
	labState[1].active = true;
	
	while 1 do
		-- Tick
		srReadScreen();

		--labWindows2 = findAllText("This is [a-z]+ Chemistry Laboratory", nil, REGION+REGEX);
		--On around October 22, 2018 - Chem Lab window behavior has changed breaking the macro
		--Once the Chem Lab starts up, the window shrinks down to almost nothing and most options disappear (including This is a Chem Lab)
		-- See https://i.gyazo.com/4ec9eaf1d3bd7dc65e9dc919ef921215.png for example
		-- Now we're forced to search for Utility on menu instead.
		labWindows2 = findAllText("Utility", nil, REGION+REGEX);



		
		local should_continue = nil;
		
		if #labWindows2 == #labWindows then
			for window_index=1, #labWindows do
				local wasActive = labState[window_index].active;
				if wasActive == true then
					local r = labTick(labWindows[window_index], labState[window_index]);
					--check to see if it's still active
					if window_index == #labWindows then
						labState[1].active = true;
					else
						labState[window_index + 1].active = true;
					end
					break;
				end
				if r then
					should_continue = 1;
				end
			end
		else
		--refresh windows. Chem Lab window does not refresh itself after it's done making essence. Refresh to force window to update, so we know when it's done.
		refreshWindows();
		end
		
		--check to see if we're finished.
		if numFinished == #labWindows then
			error "Completed.";
		end

		-- Display status and sleep

		local start_time = lsGetTimer();
		while tick_time - (lsGetTimer() - start_time) > 0 do
			time_left = tick_time - (lsGetTimer() - start_time);
			
			displayStatus(labState);
			lsSleep(25);
		end
		
		checkBreak();
		-- error 'done';
	end
end

function refreshWindows()
  srReadScreen();
  pinWindows = findAllImages("UnPin.png");
	for i=1, #pinWindows do
	  checkBreak();
	  safeClick(pinWindows[i][0] - 7, pinWindows[i][1]);
	  lsSleep(100);
  	end
  lsSleep(500);
end
