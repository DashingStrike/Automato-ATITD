dofile("common.inc");


essences = {};

essences[1] = {"Anaxi",23};
essences[2] = {"Arconis",76};
essences[3] = {"AshPalm",26};
essences[4] = {"Beetlenut",75};
essences[5] = {"Bloodbark",69};
essences[6] = {"BottleTree",34};
essences[7] = {"BrambleHedge",65};
essences[8] = {"BroadleafPalm",86};
essences[9] = {"ButterleafTree",18};
essences[10] = {"CeruleanBlue",55};
essences[11] = {"ChakkanutTree",74};
essences[12] = {"Chicory",20};
essences[13] = {"Cinnar",85};
essences[14] = {"CoconutPalm",24};
essences[15] = {"Cricklewood",78};
essences[16] = {"DeltaPalm",74};
essences[17] = {"Elephantia",70};
essences[18] = {"FeatherTree",86};
essences[19] = {"FernPalm",18};
essences[20] = {"FoldedBirch",11};
essences[21] = {"GiantCricklewood",18};
essences[22] = {"Hawthorn",90};
essences[23] = {"Hokkaido",30};
essences[24] = {"Kaeshra",67};
essences[25] = {"LocustPalm",61};
essences[26] = {"MiniPalmetto",41};
essences[27] = {"MiniatureFernPalm",41};
essences[28] = {"MonkeyPalm",42};
essences[29] = {"OilPalm",9};
essences[30] = {"Oleaceae",86};
essences[31] = {"Orrorin",14};
essences[32] = {"Passam",39};
essences[33] = {"PhoenixPalm",55};
essences[34] = {"PratyekaTree",12};
essences[35] = {"Ranyahn",80};
essences[36] = {"RazorPalm",23};
essences[37] = {"RedMaple",87};
essences[38] = {"RoyalPalm",41};
essences[39] = {"Savaka",22};
essences[40] = {"SpikedFishtree",24};
essences[41] = {"SpindleTree",50};
essences[42] = {"StoutPalm",5};
essences[43] = {"TapacaeMiralis",6};
essences[44] = {"TinyOilPalm",37};
essences[45] = {"ToweringPalm",72};
essences[46] = {"Trilobellia",8};
essences[47] = {"UmbrellaPalm",88};
essences[48] = {"WindriverPalm",27};
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
essences[78] = {"SaltsOfPlatinum",};
essences[79] = {"SaltsOfSilver",20};
essences[80] = {"SaltsOfStrontium",68};
essences[81] = {"SaltsOfTin",81};
essences[82] = {"SaltsOfTitanium",22};
essences[83] = {"SaltsOfTungsten",89};
essences[84] = {"SaltsOfZinc",23};


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
	rw.x = rw.x+9;
	rw.y = rw.y+73;
	rw.width = 222
	rw.height = 182
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
