
assert(loadfile("luaScripts/screen_reader_common.inc"))();
assert(loadfile("luaScripts/ui_utils.inc"))();
assert(loadfile("luaScripts/common.inc"))();


essences = {};

essences[1] = {"AltarsBlessing", 79};
essences[2] = {"Anansi", 39};
essences[3] = {"Ashoka", 71};
essences[4] = {"Banto", 47};
essences[5] = {"BeeBalm", 48};
essences[6] = {"BeetleLeaf", 43};
essences[7] = {"BlackPepperPlant", 10};
essences[8] = {"BlueDamia", 50};
essences[9] = {"BlueTarafern", 65};
essences[10] = {"BluebottleClover", 40};
essences[11] = {"BrownMuskerro", 10};
essences[12] = {"Bucklerleaf", 78};
essences[13] = {"CamelPheromoneFemale", 83};
essences[14] = {"CamelPheromoneMale", -1};
essences[15] = {"Cardamom", 83};
essences[16] = {"Chaffa", 55};
essences[17] = {"Chatinabrae", 6};
essences[18] = {"Chives", 69};
essences[19] = {"Cinnamon", 32};
essences[20] = {"Cinquefoil", 33};
essences[21] = {"CommonBasil", 61};
essences[22] = {"CommonRosemary", 67};
essences[23] = {"CommonSage", 52};
essences[24] = {"Covage", 21};
essences[25] = {"Crampbark", 36};
essences[26] = {"CrimsonLettuce", 90};
essences[27] = {"CrimsonPipeweed", 71};
essences[28] = {"CrumpledLeafBasil", 1};
essences[29] = {"Daggerleaf", 31};
essences[30] = {"Dalchini", 71};
essences[31] = {"DarkOchoa", 65};
essences[32] = {"Digweed", 88};
essences[33] = {"Discorea", 83};
essences[34] = {"DrapeauDor", 33};
essences[35] = {"DustyBlueSage", 27};
essences[36] = {"DwarfHogweed", 73};
essences[37] = {"DwarfWildLettuce", 32};
essences[38] = {"FireAllspice", 32};
essences[39] = {"Fleabane", 17};
essences[40] = {"FoolsAgar", 52};
essences[41] = {"Fumitory", 41};
essences[42] = {"Garcinia", 45};
essences[43] = {"GingerRoot", 87};
essences[44] = {"GinsengRoot", 9};
essences[45] = {"Glechoma", 19};
essences[46] = {"GoldenThyme", 44};
essences[47] = {"Gynura", 19};
essences[48] = {"Harebell", 39};
essences[49] = {"Hazlewort", 72};
essences[50] = {"Hogweed", 24};
essences[51] = {"HoneyMint", 35};
essences[52] = {"Houseleek", 80};
essences[53] = {"Hyssop", 42};
essences[54] = {"Ilex", 57};
essences[55] = {"IndigoDamia", 52};
essences[56] = {"JaggedDewcup", 3};
essences[57] = {"KatakoRoot", 39};
essences[58] = {"Khokali", 29};
essences[59] = {"Lemondrop", 7};
essences[60] = {"Lythrum", 30};
essences[61] = {"MarbleDust", 53};
essences[62] = {"Mariae", 57};
essences[63] = {"Meadowsweet", 12};
essences[64] = {"Mindanao", 41};
essences[65] = {"MirabellisFern", 51};
essences[66] = {"Morpha", 15};
essences[67] = {"Motherwort", 45};
essences[68] = {"MountainMint", 42};
essences[69] = {"Myristica", 18};
essences[70] = {"Myrrh", 55};
essences[71] = {"OpalHarebell", 69};
essences[72] = {"OrangeNiali", 10};
essences[73] = {"OrangeSweetgrass", 27};
essences[74] = {"PaleDhamasa", 4};
essences[75] = {"PaleOchoa", 37};
essences[76] = {"PaleRusset", 1};
essences[77] = {"Panoe", 89};
essences[78] = {"Pippali", 67};
essences[79] = {"PitcherPlant", 14};
essences[80] = {"PowderedAmethyst", 56};
essences[81] = {"PowderedCitrine", 55};
essences[82] = {"PowderedDiamond", 25};
essences[83] = {"PowderedEmerald", 9};
essences[84] = {"PowderedGarnet", 44};
essences[85] = {"PowderedJade", 9};
essences[86] = {"PowderedLapis", -1};
essences[87] = {"PowderedOpal", 67};
essences[88] = {"PowderedQuartz", 49};
essences[89] = {"PowderedRuby", 16};
essences[90] = {"PowderedSapphire", 50};
essences[91] = {"PowderedSunstone", -1};
essences[92] = {"PowderedTopaz", 49};
essences[93] = {"PowderedTurquoise", -1};
essences[94] = {"Primula", -1};
essences[95] = {"Prisniparni", 8};
essences[96] = {"PulmonariaOpal", 11};
essences[97] = {"PurpleTintiri", 10};
essences[98] = {"Rhubarb", 37};
essences[99] = {"SagarGhota", 89};
essences[100] = {"SaltsOfAluminum", 79};
essences[101] = {"SaltsOfAntimony", 43};
essences[102] = {"SaltsOfCopper", 23};
essences[103] = {"SaltsOfGold", 7};
essences[104] = {"SaltsOfIron", 71};
essences[105] = {"SaltsOfLead", 27};
essences[106] = {"SaltsOfLithium", 48};
essences[107] = {"SaltsOfMagnesium", 29};
essences[108] = {"SaltsOfPlatinum", 11};
essences[109] = {"SaltsOfSilver", 81};
essences[110] = {"SaltsOfStrontium", 80};
essences[111] = {"SaltsOfTin", 70};
essences[112] = {"SaltsOfTitanium", 74};
essences[113] = {"SaltsOfTungsten", 10};
essences[114] = {"SaltsOfZinc", 65};
essences[115] = {"SandyDustweed", 76};
essences[116] = {"Satsatchi", 37};
essences[117] = {"ShrubSage", 31};
essences[118] = {"ShrubbyBasil", 17};
essences[119] = {"Shyama", 79};
essences[120] = {"SilvertongueDamia", 84};
essences[121] = {"Skirret", 23};
essences[122] = {"Soapwort", 55};
essences[123] = {"Sorrel", 90};
essences[124] = {"Spinach", 90};
essences[125] = {"SteelBladegrass", 29};
essences[126] = {"SticklerHedge", 63};
essences[127] = {"StrawberryTea", 27};
essences[128] = {"SugarCane", 20};
essences[129] = {"Sweetflower", 35};
essences[130] = {"Sweetgrass", 2};
essences[131] = {"Sweetsop", 7};
essences[132] = {"Tagetese", 7};
essences[133] = {"Thyme", 45};
essences[134] = {"TinyClover", 17};
essences[135] = {"TrueTarragon", 89};
essences[136] = {"Tsangto", 78};
essences[137] = {"VerdantSquill", 20};
essences[138] = {"WeepingPatala", 26};
essences[139] = {"Whitebelly", 51};
essences[140] = {"WildLettuce", 47};
essences[141] = {"WildOnion", 18};
essences[142] = {"WildYam", -1};
essences[143] = {"Xanosi", 63};
essences[144] = {"Yava", 9};
essences[145] = {"YellowTristeria", 45};
essences[146] = {"Yigory", 71};
essences[147] = {"ResinAnaxi", 22};
essences[148] = {"ResinArconis", 34};
essences[149] = {"ResinAshPalm", 45};
essences[150] = {"ResinBeetlenut", 70};
essences[151] = {"ResinBloodbark", 24};
essences[152] = {"ResinBottleTree", 50};
essences[153] = {"ResinBrambleHedge", 42};
essences[154] = {"ResinBroadleafPalm", 30};
essences[155] = {"ResinButterleafTree", 85};
essences[156] = {"ResinCeruleanBlue", 34};
essences[157] = {"ResinChakkanutTree", 57};
essences[158] = {"ResinChicory", 37};
essences[159] = {"ResinCinnar", 6};
essences[160] = {"ResinCoconutPalm", 10};
essences[161] = {"ResinCricklewood", 54};
essences[162] = {"ResinDeltaPalm", 3};
essences[163] = {"ResinElephantia", 46};
essences[164] = {"ResinFeatherTree", 73};
essences[165] = {"ResinFernPalm", 62};
essences[166] = {"ResinFoldedBirch", 85};
essences[167] = {"ResinGiantCricklewood", 29};
essences[168] = {"ResinHawthorn", 44};
essences[169] = {"ResinHokkaido", 2};
essences[170] = {"ResinKaeshra", 0};
essences[171] = {"ResinLocustPalm", 6};
essences[172] = {"ResinMiniPalmetto", 46};
essences[173] = {"ResinMiniatureFernPalm", 50};
essences[174] = {"ResinMonkeyPalm", 27};
essences[175] = {"ResinOilPalm", 69};
essences[176] = {"ResinOleaceae", 9};
essences[177] = {"ResinOrrorin", 40};
essences[178] = {"ResinPassam", 54};
essences[179] = {"ResinPhoenixPalm", 8};
essences[180] = {"ResinPratyekaTree", 34};
essences[181] = {"ResinRanyahn", 16};
essences[182] = {"ResinRazorPalm", 61};
essences[183] = {"ResinRedMaple", 2};
essences[184] = {"ResinRoyalPalm", 76};
essences[185] = {"ResinSavaka", 78};
essences[186] = {"ResinSpikedFishtree", 3};
essences[187] = {"ResinSpindleTree", 17};
essences[188] = {"ResinStoutPalm", 79};
essences[189] = {"ResinTapacaeMiralis", 30};
essences[190] = {"ResinTinyOilPalm", 34};
essences[191] = {"ResinToweringPalm", 67};
essences[192] = {"ResinTrilobellia", 0};
essences[193] = {"ResinUmbrellaPalm", 45};
essences[194] = {"ResinWindriverPalm", 49};


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
	local buttons = findAllImages(image_name, 1000);
	
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

function labTick(region, state)
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
		srClickMouseNoMove(region[0] + 12, region[1] + 5);
		srReadScreen();
		outer = findTextInRegion(region, "Manufacture...");
		lsSleep(per_read_delay);
		checkBreak();
	end
	srClickMouseNoMove(outer[0] + 12, outer[1] + 5);
	lsSleep(per_click_delay);
	
	local t = waitForText("Essential Distillation...");
	srClickMouseNoMove(t[0] + 12, t[1] + 5);
	lsSleep(per_click_delay);
	t = waitForText("Place Essential Material");
	srClickMouseNoMove(t[0] + 12, t[1] + 5);
	lsSleep(per_click_delay);
	
	--search for something to add
	local rc = waitForRegionWithText("Choose a material");
	rc[0] = rc[0] + 5;
	rc[2] = rc[2] - 5;
	local parse = parseRegion(rc);
	local foundEss = false;
	if parse then
		for i = 1, #parse do
			parse[i][2] = stripCharacters(parse[i][2]);
			if foundEss == false then
				for k = 1, #essences do
					if essences[k][2] ~= -1 and parse[i][2] == essences[k][1] and foundEss == false then
						state.essenceIndex = k;
						foundEss = true;
						srClickMouseNoMove(parse[i][0] + 8, parse[i][1] + 5);
						state.temp = essences[k][2];
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
	
	local spiritsNeeded = getSpirits(state.temp);
	
	state.lastOffset = 10;
	
	for i = 1, #spiritsNeeded do
		--Add the alcohol
		t = waitForTextInRegion(region, "Manufacture...");
		srClickMouseNoMove(t[0] + 10, t[1] + 5);
		lsSleep(per_click_delay);
		t = waitForText("Alcohol Lamp...");
		srClickMouseNoMove(t[0] + 10, t[1] + 5);
		lsSleep(per_click_delay);
		t = waitForText("Fill Alcohol Lamp with Spirits...");
		srClickMouseNoMove(t[0] + 10, t[1] + 5);
		lsSleep(per_click_delay);
		
		--click on the spirit itself
		t = waitForText(spiritsNeeded[i][1]);
		srClickMouseNoMove(t[0] + 12, t[1] + 5);
		lsSleep(per_click_delay);
		waitForText("How much");
		srKeyEvent(spiritsNeeded[i][2] .. "\n");
		lsSleep(per_click_delay + per_read_delay)
	end
	
	t = waitForTextInRegion(region, "Manufacture...");
	srClickMouseNoMove(t[0] + 7, t[1] + 7);
	lsSleep(per_click_delay + per_read_delay);
	t = waitForText("Essential Distillation...");
	srClickMouseNoMove(t[0] + 10, t[1] + 5);
	lsSleep(per_click_delay);
	
	local image;
	
	while 1 do
		srReadScreen();
		image = srFindImage("StartDistillMini.png");
		if image then
			srClickMouseNoMove(image[0] + 2, image[1] + 2);
			lsSleep(per_click_delay);
			break;
		else
			statusScreen("Could not find start Essential, updating menu");
			--otherwise, search for place, and and update the menu
			srClickMouseNoMove(t[0] + 10, t[1] + 5);
			lsSleep(200);
		end
	end

	srClickMouseNoMove(region[0] + 10, region[1] + 10);
	lsSleep(per_click_delay);
	return;
end

curActive = 1;

function doit()

	last_time = lsGetTimer() + 5000;
	
	askForWindow("Pin all Chemistry Laboratories");
	
	srReadScreen();
	labWindows = findAllRegionsWithText("This is a Chemistry Laboratory");
	
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
		labWindows2 = findAllRegionsWithText("This is a Chemistry Laboratory");
		
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
			for i = 1, #essences do
				lsWriteToLog("TempTests.txt", "essences[" .. i .. "] = {\"" .. essences[i][1] .. "\", " .. essences[i][2] .. "};\n");
			end
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
