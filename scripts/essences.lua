dofile("common.inc");


essences = {};

essences[1] = {"ResinAnaxi",4};
essences[2] = {"ResinArconis",82};
essences[3] = {"ResinAshPalm",80};
essences[4] = {"ResinBeetlenut",75};
essences[5] = {"ResinBloodbark",40};
essences[6] = {"ResinBottleTree",1};
essences[7] = {"ResinBrambleHedge",22};
essences[8] = {"ResinBroadleafPalm",16};
essences[9] = {"ResinButterleafTree",11};
essences[10] = {"ResinCeruleanBlue",10};
essences[11] = {"ResinChakkanutTree",61};
essences[12] = {"ResinChicory",58};
essences[13] = {"ResinCinnar",30};
essences[14] = {"ResinCoconutPalm",78};
essences[15] = {"ResinCricklewood",40};
essences[16] = {"ResinDeltaPalm",41};
essences[17] = {"ResinElephantia",88};
essences[18] = {"ResinFeatherTree",24};
essences[19] = {"ResinFernPalm",49};
essences[20] = {"ResinFoldedBirch",79};
essences[21] = {"ResinGiantCricklewood",29};
essences[22] = {"ResinHawthorn",30};
essences[23] = {"ResinHokkaido",48};
essences[24] = {"ResinKaeshra",43};
essences[25] = {"ResinLocustPalm",53};
essences[26] = {"ResinMiniPalmetto",1};
essences[27] = {"ResinMiniatureFernPalm",70};
essences[28] = {"ResinMonkeyPalm",47};
essences[29] = {"ResinOilPalm",77};
essences[30] = {"ResinOleaceae",14};
essences[31] = {"ResinOrrorin",52};
essences[32] = {"ResinPassam",48};
essences[33] = {"ResinPhoenixPalm",5};
essences[34] = {"ResinPratyekaTree",20};
essences[35] = {"ResinRanyahn",68};
essences[36] = {"ResinRazorPalm",34};
essences[37] = {"ResinRedMaple",74};
essences[38] = {"ResinRoyalPalm",41};
essences[39] = {"ResinSavaka",0};
essences[40] = {"ResinSpikedFishtree",46};
essences[41] = {"ResinSpindleTree",80};
essences[42] = {"ResinStoutPalm",76};
essences[43] = {"ResinTapacaeMiralis",24};
essences[44] = {"ResinTinyOilPalm",13};
essences[45] = {"ResinToweringPalm",90};
essences[46] = {"ResinTrilobellia",57};
essences[47] = {"ResinUmbrellaPalm",45};
essences[48] = {"ResinWindriverPalm",65};
essences[49] = {"PowderedDiamond",63};
essences[50] = {"PowderedEmerald",88};
essences[51] = {"PowderedOpal",82};
essences[52] = {"PowderedQuartz",61};
essences[53] = {"PowderedRuby",70};
essences[54] = {"PowderedSapphire",27};
essences[55] = {"PowderedTopaz",10};
essences[56] = {"PowderedAmethyst",85};
essences[57] = {"PowderedCitrine",45};
essences[58] = {"PowderedGarnet",89};
essences[59] = {"PowderedJade",8};
essences[60] = {"PowderedLapis",25};
essences[61] = {"PowderedSunstone",13};
essences[62] = {"PowderedTurquoise",64};
essences[63] = {"PowderedAquaPearl",81};
essences[64] = {"PowderedBeigePearl",50};
essences[65] = {"PowderedBlackPearl",16};
essences[66] = {"PowderedCoralPearl",77};
essences[67] = {"PowderedPinkPearl",2};
essences[68] = {"PowderedSmokePearl",3};
essences[69] = {"PowderedWhitePearl",69};
essences[70] = {"SaltsOfAluminum",19};
essences[71] = {"SaltsOfAntimony",66};
essences[72] = {"SaltsOfCopper",8};
essences[73] = {"SaltsOfGold",30};
essences[74] = {"SaltsOfIron",52};
essences[75] = {"SaltsOfLead",40};
essences[76] = {"SaltsOfLithium",82};
essences[77] = {"SaltsOfMagnesium",16};
essences[78] = {"SaltsOfPlatinum",10};
essences[79] = {"SaltsOfSilver",21};
essences[80] = {"SaltsOfStrontium",34};
essences[81] = {"SaltsOfTin",21};
essences[82] = {"SaltsOfTitanium",57};
essences[83] = {"SaltsOfTungsten",12};
essences[84] = {"SaltsOfZinc",35};
essences[85] = {"OysterShellMarbleDust",85};
essences[86] = {"Allbright",};
essences[87] = {"Aloe",33};
essences[88] = {"AltarsBlessing",22};
essences[89] = {"Anansi",83};
essences[90] = {"Apiphenalm",};
essences[91] = {"ApothecarysScythe",};
essences[92] = {"Artemesia",};
essences[93] = {"Asafoetida",};
essences[94] = {"Asane",};
essences[95] = {"Ashoka",74};
essences[96] = {"AzureTristeria",};
essences[97] = {"Banto",14};
essences[98] = {"BayTree",};
essences[99] = {"BeeBalm",87};
essences[100] = {"BeetleLeaf",17};
essences[101] = {"BeggarsButton",5};
essences[102] = {"Bhillawa",8};
essences[103] = {"Bilimbi",};
essences[104] = {"BitterFlorian",};
essences[105] = {"BlackPepperPlant",55};
essences[106] = {"BlessedMariae",};
essences[107] = {"Bleubaille",};
essences[108] = {"BloodBalm",};
essences[109] = {"BloodBlossom",};
essences[110] = {"BloodRoot",};
essences[111] = {"BloodedHarebell",82};
essences[112] = {"Bloodwort",};
essences[113] = {"BlueDamia",76};
essences[114] = {"BlueTarafern",52};
essences[115] = {"BlueberryTeaTree",};
essences[116] = {"BluebottleClover",71};
essences[117] = {"BlushingBlossom",};
essences[118] = {"BrassyCaltrops",};
essences[119] = {"BrownMuskerro",56};
essences[120] = {"Bucklerleaf",70};
essences[121] = {"BullsBlood",};
essences[122] = {"BurntTarragon",61};
essences[123] = {"ButterflyDamia",};
essences[124] = {"Butterroot",};
essences[125] = {"Calabash",};
essences[126] = {"Camelmint",};
essences[127] = {"Caraway",80};
essences[128] = {"Cardamom",48};
essences[129] = {"Cassia",};
essences[130] = {"Chaffa",19};
essences[131] = {"Chatinabrae",43};
essences[132] = {"Chives",73};
essences[133] = {"Chukkah",};
essences[134] = {"CicadaBean",};
essences[135] = {"Cinnamon",78};
essences[136] = {"Cinquefoil",87};
essences[137] = {"Cirallis",};
essences[138] = {"Clingroot",};
essences[139] = {"CommonBasil",28};
essences[140] = {"CommonRosemary",58};
essences[141] = {"CommonSage",32};
essences[142] = {"Corsacia",6};
essences[143] = {"Covage",74};
essences[144] = {"Crampbark",84};
essences[145] = {"Cranesbill",};
essences[146] = {"CreepingBlackNightshade",};
essences[147] = {"CreepingThyme",};
essences[148] = {"CrimsonClover",};
essences[149] = {"CrimsonLettuce",0};
essences[150] = {"CrimsonNightshade",};
essences[151] = {"CrimsonPipeweed",79};
essences[152] = {"CrimsonWindleaf",};
essences[153] = {"CrumpledLeafBasil",49};
essences[154] = {"CurlySage",};
essences[155] = {"CyanCressidia",};
essences[156] = {"Daggerleaf",75};
essences[157] = {"Dalchini",90};
essences[158] = {"Dameshood",};
essences[159] = {"DankMullien",};
essences[160] = {"DarkOchoa",21};
essences[161] = {"DarkRadish",};
essences[162] = {"DeathsPiping",};
essences[163] = {"DeadlyCatsclaw",};
essences[164] = {"DeadwoodTree",};
essences[165] = {"Dewplant",};
essences[166] = {"Digweed",63};
essences[167] = {"Discorea",52};
essences[168] = {"DrapeauDor",10};
essences[169] = {"DustyBlueSage",53};
essences[170] = {"DwarfHogweed",19};
essences[171] = {"DwarfWildLettuce",10};
essences[172] = {"EarthApple",60};
essences[173] = {"Elegia",};
essences[174] = {"EnchantersPlant",};
essences[175] = {"Finlow",67};
essences[176] = {"FireAllspice",20};
essences[177] = {"FireLily",};
essences[178] = {"Fivesleaf",2};
essences[179] = {"FlamingSkirret",};
essences[180] = {"FlandersBlossom",72};
essences[181] = {"Fleabane",10};
essences[182] = {"FoolsAgar",40};
essences[183] = {"Fumitory",};
essences[184] = {"Garcinia",86};
essences[185] = {"GarlicChives",};
essences[186] = {"GingerRoot",65};
essences[187] = {"GingerTarragon",};
essences[188] = {"GinsengRoot",55};
essences[189] = {"Glechoma",56};
essences[190] = {"Gnemnon",};
essences[191] = {"Gokhru",};
essences[192] = {"GoldenDoubloon",};
essences[193] = {"GoldenGladalia",};
essences[194] = {"GoldenSellia",};
essences[195] = {"GoldenSweetgrass",};
essences[196] = {"GoldenSun",};
essences[197] = {"GoldenThyme",70};
essences[198] = {"Gynura",75};
essences[199] = {"Harebell",20};
essences[200] = {"Harrow",64};
essences[201] = {"Hazlewort",32};
essences[202] = {"HeadacheTree",};
essences[203] = {"Heartsease",};
essences[204] = {"Hogweed",35};
essences[205] = {"HomesteaderPalm",};
essences[206] = {"HoneyMint",17};
essences[207] = {"Houseleek",66};
essences[208] = {"Hyssop",25};
essences[209] = {"IceBlossom",};
essences[210] = {"IceMint",};
essences[211] = {"Ilex",83};
essences[212] = {"IndigoDamia",51};
essences[213] = {"Ipomoea",28};
essences[214] = {"JaggedDewcup",9};
essences[215] = {"Jaivanti",};
essences[216] = {"Jaiyanti",};
essences[217] = {"JoyoftheMountain",};
essences[218] = {"Jugwort",};
essences[219] = {"KatakoRoot",80};
essences[220] = {"Khokali",86};
essences[221] = {"KingsCoin",};
essences[222] = {"Lamae",};
essences[223] = {"Larkspur",};
essences[224] = {"LavenderNavarre",0};
essences[225] = {"LavenderScentedThyme",};
essences[226] = {"LemonBasil",};
essences[227] = {"LemonGrass",};
essences[228] = {"Lemondrop",59};
essences[229] = {"Lilia",};
essences[230] = {"Liquorice",23};
essences[231] = {"Lungclot",};
essences[232] = {"Lythrum",3};
essences[233] = {"Mahonia",};
essences[234] = {"Maliceweed",};
essences[235] = {"MandrakeRoot",};
essences[236] = {"Maragosa",};
essences[237] = {"Mariae",89};
essences[238] = {"Meadowsweet",48};
essences[239] = {"Medicago",};
essences[240] = {"Mindanao",22};
essences[241] = {"MiniatureBamboo",};
essences[242] = {"MiniatureLamae",};
essences[243] = {"MirabellisFern",36};
essences[244] = {"MoonAloe",};
essences[245] = {"Morpha",66};
essences[246] = {"Motherwort",9};
essences[247] = {"MountainMint",38};
essences[248] = {"Myristica",70};
essences[249] = {"Myrrh",45};
essences[250] = {"Naranga",};
essences[251] = {"NubianLiquorice",};
essences[252] = {"OctecsGrace",};
essences[253] = {"OpalHarebell",12};
essences[254] = {"OrangeNiali",76};
essences[255] = {"OrangeSweetgrass",45};
essences[256] = {"Orris",};
essences[257] = {"PaleDhamasa",29};
essences[258] = {"PaleOchoa",};
essences[259] = {"PaleRusset",68};
essences[260] = {"PaleSkirret",};
essences[261] = {"Panoe",23};
essences[262] = {"ParadiseLily",};
essences[263] = {"Patchouli",};
essences[264] = {"Peppermint",};
essences[265] = {"Pippali",1};
essences[266] = {"PitcherPlant",10};
essences[267] = {"Primula",30};
essences[268] = {"Prisniparni",4};
essences[269] = {"PulmonariaOpal",45};
essences[270] = {"PurpleTintiri",28};
essences[271] = {"Quamash",};
essences[272] = {"RedPepperPlant",56};
essences[273] = {"Revivia",};
essences[274] = {"Rhubarb",55};
essences[275] = {"RoyalRosemary",};
essences[276] = {"Rubia",11};
essences[277] = {"Rubydora",};
essences[278] = {"SacredPalm",};
essences[279] = {"SagarGhota",3};
essences[280] = {"Sandalwood",};
essences[281] = {"SandyDustweed",};
essences[282] = {"Satsatchi",19};
essences[283] = {"ScaleyHardwood",};
essences[284] = {"Schisandra",};
essences[285] = {"ShrubSage",9};
essences[286] = {"ShrubbyBasil",14};
essences[287] = {"Shyama",20};
essences[288] = {"Shyamalata",};
essences[289] = {"SicklyRoot",};
essences[290] = {"SilvertongueDamia",69};
essences[291] = {"Skirret",84};
essences[292] = {"SkyGladalia",86};
essences[293] = {"Soapwort",69};
essences[294] = {"Sorrel",68};
essences[295] = {"Spinach",70};
essences[296] = {"Spinnea",};
essences[297] = {"Squill",};
essences[298] = {"SteelBladegrass",75};
essences[299] = {"SticklerHedge",69};
essences[300] = {"StrawberryTea",65};
essences[301] = {"Strychnos",};
essences[302] = {"SugarCane",12};
essences[303] = {"SweetGroundmaple",};
essences[304] = {"Sweetflower",15};
essences[305] = {"Sweetgrass",87};
essences[306] = {"Sweetsop",56};
essences[307] = {"Tagetese",60};
essences[308] = {"Tamarask",62};
essences[309] = {"TangerineDream",30};
essences[310] = {"ThunderPlant",};
essences[311] = {"Thyme",49};
essences[312] = {"TinyClover",89};
essences[313] = {"Trilobe",};
essences[314] = {"Tristeria",2};
essences[315] = {"TrueTarragon",65};
essences[316] = {"Tsangto",66};
essences[317] = {"Tsatso",79};
essences[318] = {"TurtlesShell",};
essences[319] = {"UmberBasil",};
essences[320] = {"UprightOchoa",};
essences[321] = {"VanillaTeaTree",};
essences[322] = {"VerdantSquill",40};
essences[323] = {"VerdantTwo-Lobe",};
essences[324] = {"Wasabi",};
essences[325] = {"WeepingPatala",50};
essences[326] = {"WhitePepperPlant",};
essences[327] = {"Whitebelly",74};
essences[328] = {"WildGarlic",};
essences[329] = {"WildLettuce",48};
essences[330] = {"WildOnion",40};
essences[331] = {"WildYam",37};
essences[332] = {"WoodSage",};
essences[333] = {"Xanat",};
essences[334] = {"Xanosi",30};
essences[335] = {"Yava",45};
essences[336] = {"YellowGentian",};
essences[337] = {"YellowTristeria",69};
essences[338] = {"Yigory",70};
essences[339] = {"Zanthoxylum",65};
essences[340] = {"CamelPheromoneFemale",9};
essences[341] = {"CamelPheromoneMale",18};

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
