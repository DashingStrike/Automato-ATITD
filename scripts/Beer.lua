--
--
--

dofile("common.inc");

-- Please modify the following lines to customize for your brew
-- Ingredient entry format:  { <ingredient>, <quantity>, <insert time> }
-- <ingredient> should be quoted, no spaces or special characters. IE: "MaltMediumRoasted"
--
ingredients = { 
	{ "WheatDriedRaw", 60, 1200 },
	{ "Honey", 160, 1200 }
};
sealTime = 10;

-- Please DON'T modify anything below for proper operation
kettles = {};
finished = 0;
tick_time = 100;
per_click_delay = 50;
pass = 0;
default_num_loops = 1;
xyWindowSize = nil;

STAGE_WAITING = 0;
STAGE_BEERWAIT = 1;
STAGE_BREWING = 2;
STAGE_FERMENTING = 3;
STAGE_COMPLETE = 4;
STAGE_FINISHED = 5;

function promptForNumbers()
	local scale = 1.0
	
	local z = 0;
	local is_done = nil;
	local value = nil;

	-- Edit box and text display
	while not is_done do
		local y = 40;
		lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "Passes:");
		is_done, num_loops = lsEditBox("passes", 110, y, z, 50, 30, scale, scale, 0x000000ff, default_num_loops);
		if not tonumber(num_loops) then
			is_done = nil;
			lsPrint(10, y+100, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
			num_loops = default_num_loops;
		end
		y = y + 32
		if lsButtonText(170, y-32, z, 100, 0xFFFFFFff, "OK") then
			is_done = 1;
		end
		
		if is_done and (not num_loops and not num_columns and not num_rows) then
			error 'Cancelled';
		end
		
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End Script") then
			error 'Clicked End Script button';
		end
		
		lsDoFrame();
		lsSleep(10);
	end
end

function stripCharacters(s)
	local badChars = "%:%(%)%-%,%'%d%s";
	s = string.gsub(s, "[" .. badChars .. "]", "");
	return s;
end

function clickAll(image_name, up)
	if nil then
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

function displayStatus()
	lsPrint(10, 6, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
	lsPrint(10, 18, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Alt+Shift to pause this script.");
	
	for window_index=1, #kettles do
			lsPrint(10, 80 + 15*window_index, 0, 0.7, 0.7, 0xFFFFFFff, "#" .. window_index .. " - " .. kettles[window_index].status);
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

function kettleTick(kettle)
	local anchor = findText("Utility", kettle);
	if anchor == nil then
		kettle.stage = STAGE_COMPLETE
		kettle.status = "Parse Error";
		finished = finished + 1;
		return;
	end
	
	anchor[0] = anchor[0]+8;
	
	if kettle.stage == STAGE_WAITING then
		safeClick(anchor[0] + 165, anchor[1] + 127);
		kettle.stage = STAGE_BEERWAIT;
		kettle.status = "Starting";
		lsSleep(200);
		return;
	end
	if kettle.stage == STAGE_BEERWAIT then
		safeClick(anchor[0] + 46, anchor[1] + 153);
		kettle.stage = STAGE_BREWING;
		kettle.status = "Brewing";
		lsSleep(200);
		return;
	end
	if kettle.stage == STAGE_BREWING then
		srReadScreen();
		pos = srFindImageInRange("BeerSealButton.png", kettle.x, kettle.y, kettle.width, kettle.height);
		if pos == nil then
			srReadScreen();
			pos = srFindImageInRange("BrewTime.png", kettle.x, kettle.y, kettle.width, kettle.height);
			local time = ocrNumber(pos[0] + 47, pos[1], SMALL_SET);
			for i=1, #ingredients do
				if kettle.lasting < i then
					if time <= ingredients[i][3] then
						AddIngredient(kettle, i);
						kettle.lasting = i;
					end
				end
			end
		else
			kettle.stage = STAGE_FERMENTING;
			kettle.status = "Fermenting";
		end
	end
	if kettle.stage == STAGE_FERMENTING then
		srReadScreen();
		pos = srFindImageInRange("BrewTime.png", kettle.x, kettle.y, kettle.width, kettle.height);
		local time = ocrNumber(pos[0] + 47, pos[1], SMALL_SET);
		if time <= sealTime then
			pos = srFindImageInRange("BeerSealButton.png", kettle.x, kettle.y, kettle.width, kettle.height);
			safeClick(pos[0]+33, pos[1]+7);
			kettle.stage = STAGE_COMPLETE;
			kettle.status = "Sealed";
			finished = finished + 1;
		end
	end
end

function AddIngredient(kettle, ing)
	local pos = srFindImageInRange("BeerIngredient.png", kettle.x, kettle.y, kettle.width, kettle.height);
	safeClick(pos[0] + 30, pos[1] + 6);
	local rw = waitForText("Choose Beer Ingredient:", nil, nil, nil, REGION);
	rw.x = rw.x+7;
	rw.y = rw.y+29;
	rw.width = 204;
	rw.height = 240;
	srReadScreen();

	local parse = findAllText(nil, rw);
	local foundIng = false;
	if parse then
		for i = 1, #parse do
			parse[i][2] = stripCharacters(parse[i][2]);
			if foundIng == false then
				if ingredients[ing][1] == parse[i][2] then
					safeClick(parse[i][0]+13, parse[i][1]+5);
					lsSleep(200);
					safeClick(rw.x + 96, rw.y + 263);
					lsSleep(200)
					srKeyEvent(ingredients[ing][2] .. "\n");
					lsSleep(200);
					while clickAll("OK1.png") == false do
						lsSleep(50);
					end
				end
			end
		end
	end
end

function doit()
--	promptForNumbers();
	askForWindow("-- Script written by Walter K. Zydhek\n\nPlease avoid using the mouse while macro is working.");
	srReadScreen();
	
	kettles = findAllText("This is [a-z]+ Beer Kettle", nil, REGION+REGEX);
	
	for window_index=1, #kettles do
		kettles[window_index].stage = STAGE_WAITING;
		kettles[window_index].status = "Waiting";
		kettles[window_index].lasting = 0;
	end
	
	while finished < #kettles do
		for index=1, #kettles do
			if not (kettles[index].stage == STAGE_COMPLETE) then
				kettleTick(kettles[index]);
			else
				kettles[index].status = "Finished";
			end

			-- Display status and sleep
	
			local start_time = lsGetTimer();
			while tick_time - (lsGetTimer() - start_time) > 0 do
				time_left = tick_time - (lsGetTimer() - start_time);
				
				displayStatus();
				lsSleep(25);
			end
			
			checkBreak();
			--lsDoFrame();
			
		end
	end
end