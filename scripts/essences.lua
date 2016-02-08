dofile("common.inc");


essences = {};

essences[1] = {"ResinAnaxi",23};
essences[2] = {"ResinArconis",76};
essences[3] = {"ResinAshPalm",26};
essences[4] = {"ResinBeetlenut",75};
essences[5] = {"ResinBloodbark",69};
essences[6] = {"ResinBottleTree",34};
essences[7] = {"ResinBrambleHedge",65};
essences[8] = {"ResinBroadleafPalm",86};
essences[9] = {"ResinButterleafTree",18};
essences[10] = {"ResinCeruleanBlue",55};
essences[11] = {"ResinChakkanutTree",74};
essences[12] = {"ResinChicory",20};
essences[13] = {"ResinCinnar",85};
essences[14] = {"ResinCoconutPalm",24};
essences[15] = {"ResinCricklewood",78};
essences[16] = {"ResinDeltaPalm",74};
essences[17] = {"ResinElephantia",70};
essences[18] = {"ResinFeatherTree",86};
essences[19] = {"ResinFernPalm",18};
essences[20] = {"ResinFoldedBirch",11};
essences[21] = {"ResinGiantCricklewood",18};
essences[22] = {"ResinHawthorn",90};
essences[23] = {"ResinHokkaido",30};
essences[24] = {"ResinKaeshra",67};
essences[25] = {"ResinLocustPalm",61};
essences[26] = {"ResinMiniPalmetto",41};
essences[27] = {"ResinMiniatureFernPalm",41};
essences[28] = {"ResinMonkeyPalm",42};
essences[29] = {"ResinOilPalm",9};
essences[30] = {"ResinOleaceae",86};
essences[31] = {"ResinOrrorin",14};
essences[32] = {"ResinPassam",39};
essences[33] = {"ResinPhoenixPalm",55};
essences[34] = {"ResinPratyekaTree",12};
essences[35] = {"ResinRanyahn",80};
essences[36] = {"ResinRazorPalm",23};
essences[37] = {"ResinRedMaple",87};
essences[38] = {"ResinRoyalPalm",41};
essences[39] = {"ResinSavaka",22};
essences[40] = {"ResinSpikedFishtree",24};
essences[41] = {"ResinSpindleTree",50};
essences[42] = {"ResinStoutPalm",5};
essences[43] = {"ResinTapacaeMiralis",6};
essences[44] = {"ResinTinyOilPalm",37};
essences[45] = {"ResinToweringPalm",72};
essences[46] = {"ResinTrilobellia",8};
essences[47] = {"ResinUmbrellaPalm",88};
essences[48] = {"ResinWindriverPalm",27};
essences[49] = {"PowderedDiamond",36};
essences[50] = {"PowderedEmerald",49};
essences[51] = {"PowderedOpal",83};
essences[52] = {"PowderedQuartz",47};
essences[53] = {"PowderedRuby",10};
essences[54] = {"PowderedSapphire",52};
essences[55] = {"PowderedTopaz",73};
essences[56] = {"PowderedAmethyst",3};
essences[57] = {"PowderedCitrine",83};
essences[58] = {"PowderedGarnet",6};
essences[59] = {"PowderedJade",49};
essences[60] = {"PowderedLapis",43};
essences[61] = {"PowderedSunstone",9};
essences[62] = {"PowderedTurquoise",68};
essences[63] = {"PowderedAquaPearl",81};
essences[64] = {"PowderedBeigePearl",50};
essences[65] = {"PowderedBlackPearl",16};
essences[66] = {"PowderedCoralPearl",77};
essences[67] = {"PowderedPinkPearl",2};
essences[68] = {"PowderedSmokePearl",3};
essences[69] = {"PowderedWhitePearl",69};
essences[70] = {"SaltsOfAluminum",89};
essences[71] = {"SaltsOfAntimony",7};
essences[72] = {"SaltsOfCopper",71};
essences[73] = {"SaltsOfGold",85};
essences[74] = {"SaltsOfIron",38};
essences[75] = {"SaltsOfLead",68};
essences[76] = {"SaltsOfLithium",25};
essences[77] = {"SaltsOfMagnesium",19};
essences[78] = {"SaltsOfPlatinum",25};
essences[79] = {"SaltsOfSilver",20};
essences[80] = {"SaltsOfStrontium",68};
essences[81] = {"SaltsOfTin",81};
essences[82] = {"SaltsOfTitanium",22};
essences[83] = {"SaltsOfTungsten",89};
essences[84] = {"SaltsOfZinc",23};
essences[85] = {"AngelsStoneDust",};
essences[86] = {"BloodGraniteDust",};
essences[87] = {"BlueMoonMarbleDust",};
essences[88] = {"BluePearlMarbleDust",};
essences[89] = {"CanaryGraniteDust",};
essences[90] = {"CherryTravertineDust",};
essences[91] = {"FireRockDust",};
essences[92] = {"GhostGraniteDust",};
essences[93] = {"GreenSunMarbleDust",};
essences[94] = {"GreyStarMarbleDust",};
essences[95] = {"HornetsWingGraniteDust",};
essences[96] = {"IslandBlueMarbleDust",};
essences[97] = {"JadeDust",};
essences[98] = {"LeopardsPawMarbleDust",};
essences[99] = {"MonkeyMarbleDust",};
essences[100] = {"MountainMarbleDust",};
essences[101] = {"MudGraniteDust",};
essences[102] = {"NightGraniteDust",};
essences[103] = {"OnyxDust",};
essences[104] = {"OysterShellMarbleDust",85};
essences[105] = {"PuzzleGraniteDust",};
essences[106] = {"RoseAlabasterDust",};
essences[107] = {"SerpentineMarbleDust",};
essences[108] = {"TangerineMarbleDust",};
essences[109] = {"TigersEyeGraniteDust",};
essences[110] = {"WhiteAlabasterDust",};
essences[111] = {"WhiteTravertineDust",};
essences[112] = {"YellowAlabasterDust",};
essences[113] = {"Allbright",};
essences[114] = {"Aloe",};
essences[115] = {"AltarsBlessing",};
essences[116] = {"Anansi",};
essences[117] = {"Apiphenalm",};
essences[118] = {"ApothecarysScythe",};
essences[119] = {"Artemesia",};
essences[120] = {"Asafoetida",};
essences[121] = {"Asane",};
essences[122] = {"Ashoka",};
essences[123] = {"AzureTristeria",};
essences[124] = {"Banto",};
essences[125] = {"BayTree",};
essences[126] = {"BeeBalm",87};
essences[127] = {"BeetleLeaf",};
essences[128] = {"BeggarsButton",};
essences[129] = {"Bhillawa",};
essences[130] = {"Bilimbi",};
essences[131] = {"BitterFlorian",};
essences[132] = {"BlackPepperPlant",55};
essences[133] = {"BlessedMariae",};
essences[134] = {"Bleubaille",};
essences[135] = {"BloodBalm",};
essences[136] = {"BloodBlossom",};
essences[137] = {"BloodRoot",};
essences[138] = {"BloodedHarebell",};
essences[139] = {"Bloodwort",};
essences[140] = {"BlueDamia",};
essences[141] = {"BlueTarafern",};
essences[142] = {"BlueberryTeaTree",};
essences[143] = {"BluebottleClover",71};
essences[144] = {"BlushingBlossom",};
essences[145] = {"BrassyCaltrops",};
essences[146] = {"BrownMuskerro",};
essences[147] = {"Bucklerleaf",70};
essences[148] = {"BullsBlood",};
essences[149] = {"BurntTarragon",};
essences[150] = {"ButterflyDamia",};
essences[151] = {"Butterroot",};
essences[152] = {"Calabash",};
essences[153] = {"Camelmint",};
essences[154] = {"Caraway",};
essences[155] = {"Cardamom",48};
essences[156] = {"Cassia",};
essences[157] = {"Chaffa",};
essences[158] = {"Chatinabrae",};
essences[159] = {"Chives",73};
essences[160] = {"Chukkah",};
essences[161] = {"CicadaBean",};
essences[162] = {"Cinnamon",78};
essences[163] = {"Cinquefoil",};
essences[164] = {"Cirallis",};
essences[165] = {"Clingroot",};
essences[166] = {"CommonBasil",28};
essences[167] = {"CommonRosemary",};
essences[168] = {"CommonSage",32};
essences[169] = {"Corsacia",};
essences[170] = {"Covage",74};
essences[171] = {"Crampbark",84};
essences[172] = {"Cranesbill",};
essences[173] = {"CreepingBlackNightshade",};
essences[174] = {"CreepingThyme",};
essences[175] = {"CrimsonClover",};
essences[176] = {"CrimsonLettuce",0};
essences[177] = {"CrimsonNightshade",};
essences[178] = {"CrimsonPipeweed",};
essences[179] = {"CrimsonWindleaf",};
essences[180] = {"CrumpledLeafBasil",};
essences[181] = {"CurlySage",};
essences[182] = {"CyanCressidia",};
essences[183] = {"Daggerleaf",75};
essences[184] = {"Dalchini",};
essences[185] = {"Dameshood",};
essences[186] = {"DankMullien",};
essences[187] = {"DarkOchoa",21};
essences[188] = {"DarkRadish",};
essences[189] = {"DeathsPiping",};
essences[190] = {"DeadlyCatsclaw",};
essences[191] = {"DeadwoodTree",};
essences[192] = {"Dewplant",};
essences[193] = {"Digweed",63};
essences[194] = {"Discorea",52};
essences[195] = {"DrapeauDOr",};
essences[196] = {"DustyBlueSage",};
essences[197] = {"DwarfHogweed",19};
essences[198] = {"DwarfWildLettuce",};
essences[199] = {"EarthApple",};
essences[200] = {"Elegia",};
essences[201] = {"EnchantersPlant",};
essences[202] = {"Finlow",};
essences[203] = {"FireAllspice",};
essences[204] = {"FireLily",};
essences[205] = {"Fivesleaf",};
essences[206] = {"FlamingSkirret",};
essences[207] = {"FlandersBlossom",};
essences[208] = {"Fleabane",10};
essences[209] = {"FoolsAgar",40};
essences[210] = {"Fumitory",};
essences[211] = {"Garcinia",};
essences[212] = {"GarlicChives",};
essences[213] = {"GingerRoot",65};
essences[214] = {"GingerTarragon",};
essences[215] = {"GinsengRoot",};
essences[216] = {"Glechoma",56};
essences[217] = {"Gnemnon",};
essences[218] = {"Gokhru",};
essences[219] = {"GoldenDoubloon",};
essences[220] = {"GoldenGladalia",};
essences[221] = {"GoldenSellia",};
essences[222] = {"GoldenSweetgrass",};
essences[223] = {"GoldenSun",};
essences[224] = {"GoldenThyme",};
essences[225] = {"Gynura",};
essences[226] = {"Harebell",20};
essences[227] = {"Harrow",};
essences[228] = {"Hazlewort",32};
essences[229] = {"HeadacheTree",};
essences[230] = {"Heartsease",};
essences[231] = {"Hogweed",};
essences[232] = {"HomesteaderPalm",};
essences[233] = {"HoneyMint",};
essences[234] = {"Houseleek",66};
essences[235] = {"Hyssop",25};
essences[236] = {"IceBlossom",};
essences[237] = {"IceMint",};
essences[238] = {"Ilex",};
essences[239] = {"IndigoDamia",};
essences[240] = {"Ipomoea",};
essences[241] = {"JaggedDewcup",};
essences[242] = {"Jaivanti",};
essences[243] = {"Jaiyanti",};
essences[244] = {"JoyoftheMountain",};
essences[245] = {"Jugwort",};
essences[246] = {"KatakoRoot",};
essences[247] = {"Khokali",};
essences[248] = {"KingsCoin",};
essences[249] = {"Lamae",};
essences[250] = {"Larkspur",};
essences[251] = {"LavenderNavarre",};
essences[252] = {"LavenderScentedThyme",};
essences[253] = {"LemonBasil",};
essences[254] = {"LemonGrass",};
essences[255] = {"Lemondrop",59};
essences[256] = {"Lilia",};
essences[257] = {"Liquorice",};
essences[258] = {"Lungclot",};
essences[259] = {"Lythrum",3};
essences[260] = {"Mahonia",};
essences[261] = {"Maliceweed",};
essences[262] = {"MandrakeRoot",};
essences[263] = {"Maragosa",};
essences[264] = {"Mariae",89};
essences[265] = {"Meadowsweet",48};
essences[266] = {"Medicago",};
essences[267] = {"Mindanao",22};
essences[268] = {"MiniatureBamboo",};
essences[269] = {"MiniatureLamae",};
essences[270] = {"MirabellisFern",};
essences[271] = {"MoonAloe",};
essences[272] = {"Morpha",66};
essences[273] = {"Motherwort",9};
essences[274] = {"MountainMint",38};
essences[275] = {"Myristica",70};
essences[276] = {"Myrrh",};
essences[277] = {"Naranga",};
essences[278] = {"NubianLiquorice",};
essences[279] = {"OctecsGrace",};
essences[280] = {"OpalHarebell",};
essences[281] = {"OrangeNiali",};
essences[282] = {"OrangeSweetgrass",};
essences[283] = {"Orris",};
essences[284] = {"PaleDhamasa",29};
essences[285] = {"PaleOchoa",};
essences[286] = {"PaleRusset",};
essences[287] = {"PaleSkirret",};
essences[288] = {"Panoe",};
essences[289] = {"ParadiseLily",};
essences[290] = {"Patchouli",};
essences[291] = {"Peppermint",};
essences[292] = {"Pippali",1};
essences[293] = {"PitcherPlant",};
essences[294] = {"Primula",};
essences[295] = {"Prisniparni",};
essences[296] = {"PulmonariaOpal",};
essences[297] = {"PurpleTintiri",};
essences[298] = {"Quamash",};
essences[299] = {"RedPepperPlant",};
essences[300] = {"Revivia",};
essences[301] = {"Rhubarb",};
essences[302] = {"RoyalRosemary",};
essences[303] = {"Rubia",};
essences[304] = {"Rubydora",};
essences[305] = {"SacredPalm",};
essences[306] = {"SagarGhota",};
essences[307] = {"Sandalwood",};
essences[308] = {"SandyDustweed",};
essences[309] = {"Satsatchi",19};
essences[310] = {"ScaleyHardwood",};
essences[311] = {"Schisandra",};
essences[312] = {"ShrubSage",9};
essences[313] = {"ShrubbyBasil",14};
essences[314] = {"Shyama",};
essences[315] = {"Shyamalata",};
essences[316] = {"SicklyRoot",};
essences[317] = {"SilvertongueDamia",69};
essences[318] = {"Skirret",};
essences[319] = {"SkyGladalia",};
essences[320] = {"Soapwort",};
essences[321] = {"Sorrel",68};
essences[322] = {"Spinach",};
essences[323] = {"Spinnea",};
essences[324] = {"Squill",};
essences[325] = {"SteelBladegrass",75};
essences[326] = {"SticklerHedge",69};
essences[327] = {"StrawberryTea",65};
essences[328] = {"Strychnos",};
essences[329] = {"SugarCane",};
essences[330] = {"SweetGroundmaple",};
essences[331] = {"Sweetflower",15};
essences[332] = {"Sweetgrass",87};
essences[333] = {"Sweetsop",};
essences[334] = {"Tagetese",};
essences[335] = {"Tamarask",};
essences[336] = {"TangerineDream",};
essences[337] = {"ThunderPlant",};
essences[338] = {"Thyme",49};
essences[339] = {"TinyClover",89};
essences[340] = {"Trilobe",};
essences[341] = {"Tristeria",};
essences[342] = {"TrueTarragon",65};
essences[343] = {"Tsangto",66};
essences[344] = {"Tsatso",};
essences[345] = {"TurtlesShell",};
essences[346] = {"UmberBasil",};
essences[347] = {"UprightOchoa",};
essences[348] = {"VanillaTeaTree",};
essences[349] = {"VerdantSquill",40};
essences[350] = {"VerdantTwo-Lobe",};
essences[351] = {"Wasabi",};
essences[352] = {"WeepingPatala",50};
essences[353] = {"WhitePepperPlant",};
essences[354] = {"Whitebelly",};
essences[355] = {"WildGarlic",};
essences[356] = {"WildLettuce",48};
essences[357] = {"WildOnion",40};
essences[358] = {"WildYam",};
essences[359] = {"WoodSage",};
essences[360] = {"Xanat",};
essences[361] = {"Xanosi",30};
essences[362] = {"Yava",};
essences[363] = {"YellowGentian",};
essences[364] = {"YellowTristeria",};
essences[365] = {"Yigory",70};
essences[366] = {"Zanthoxylum",};
essences[367] = {"CamelPheromones(Female)",};
essences[368] = {"CamelPheromones(Male)",};

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
	if goal == 81 or goal == 82 then
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
		statusScreen("Clicking " .. #buttons .. "button(s)...");
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
		outer = findText("Manufacture...", essWin);
		lsSleep(per_read_delay);
		checkBreak();
	end
	clickText(outer);
--	lsSleep(per_click_delay);
	
	local t = waitForText("Essential Distill");
	clickText(t);
--	lsSleep(per_click_delay);
	t = waitForText("Place Essential Mat");
	clickText(t);
--	lsSleep(per_click_delay);
	
	--search for something to add
	local rw = waitForText("Choose a material", nil, nil, nil, REGION);
	rw.x = rw.x+8;
	rw.y = rw.y+69;
	rw.width = 243;
	rw.height = 182;
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
	
	while clickAll("OKb.png") == false do
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
		clickText(waitForText("Fill Alcohol Lamp"));
		lsSleep(per_click_delay);
		
		--click on the spirit itself
		clickText(waitForText(spiritsNeeded[i][1]));
		lsSleep(per_click_delay);
		waitForText("How much");
		srKeyEvent(spiritsNeeded[i][2] .. "\n");
		lsSleep(per_click_delay + per_read_delay)
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
		labWindows2 = findAllText("This is [a-z]+ Chemistry Laboratory", nil, REGION+REGEX);
		
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
