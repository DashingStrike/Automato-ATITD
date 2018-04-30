-- modified by Silden 03-SEP-17
-- * Fixed UI Changes (twice in one tale!)
-- * Added buttons to handle loading charcoal and materials
-- * Added sound when all glass has been made


dofile("common.inc"); -- To allow the findAllText function
--dofile("screen_reader_common.inc");
--dofile("ui_utils.inc");

-- Initial variables
window_w = 320;
window_h = 415;
temperature_width = 85; -- Width of the Temperature label
tol = 6500;
menuButtonSelected = 0;
madeSomeGlass = false; -- Becomes true when you've started to make anything

-- It will make the first in the list if available, otherwise the next, etc
-- This will let you make, e.g. Rods on your Soda Glass and Sheet Glass on your normal, by putting
--   sheet glass before rods (on soda it'll fail to find sheet)
item_priority = {"GlassMakeSheet.png", "GlassMakeRod.png", "GlassMakeWine.png", 
                 "GlassMakePipe.png", "GlassMakeJar.png","GlassMakeTorch.png",
                 "GlassMakeBlade.png", "GlassMakeFineRod.png", "GlassMakeFinePipe.png"};

item_name = {["GlassMakeSheet.png"] = "Sheet", ["GlassMakeRod.png"] = "Rod", ["GlassMakeWine.png"] = "Wine",
		["GlassMakePipe.png"] = "Pipe", ["GlassMakeJar.png"] = "Jar", ["GlassMakeTorch.png"] = "Torch",
		["GlassMakeBlade.png"] = "Blade", ["GlassMakeFineRod.png"] = "Fine Rod", ["GlassMakeFinePipe.png"] = "Fine Pipe"};		
  
-- max temperature in which we will contine heating it, wait until it gets below this before adding
max_add_temp = 2290; -- Rare (0.5%) occurance of temperature too high at 2300
-- minimum temperature in which we will start a new project, otherwise will reheat
min_new_temp = 1750;

tick_time = 3000;

function ocrNumber(x, y)
	-- Finds the number at the given coordinate. 
	-- Glass numbers are now bigger than other numbers, so a different set of number files are needed 
	-- (glass0.png to glass9.png)
	
	local numberImageWidth = 6;
	local numberImageHeight = 9
	
	-- Find the first number
	local digit=nil; -- digit found
	local offset=0;
	while (not digit) and (offset < 10) do
		for i=0, 9 do
			-- loop through each number 0 to 9 and see if it exists at the location x, y
			local pos = srFindImageInRange("glass/" .. i .. ".png", x, y, numberImageWidth, numberImageHeight, tol);
			if pos then
				digit=i;
				break;
			end
		end
		if not digit then
			x = x+1;
			offset = offset + 1;
		end
	end
	if (offset > 0) then
		lsPrintln("Perf warning: OCR non-0 offset of " .. offset);
	end
	local ret = digit;
	while 1 do
		digit = nil;
		x = x + numberImageWidth + 1;
		for i=0, 9 do
			local pos = srFindImageInRange("glass/" .. i .. ".png", x, y, numberImageWidth, numberImageHeight, tol);
			if pos then
				digit=i;
				break;
			end
		end
		if digit then
			ret = ret * 10 + digit;
		else
			break;
		end
	end
	return ret;
end

function addCC(window_pos, state)
	if state.just_added then
		return;
	end
	-- lsPrintln(window_pos[0] .. " " .. window_pos[1] .. " " .. window_w .. " " .. window_h);
	local pos = srFindImageInRange("GlassAdd2Charcoal.png", window_pos[0], window_pos[1], window_w, window_h, tol);
	
	state.just_added = 1;
	srClickMouseNoMove(pos[0]+5, pos[1]+2);
	state.status = state.status .. " Added 2 CC";
end

function glassTick(window_pos, state)
	state.status = "";
	local pos;
	local out_of_glass = nil;
	if state.want_spike then
		state.timer = state.timer - (tick_time / 1000);
	end
	
	pos = srFindImageInRange("GlassTimeToStop.png", window_pos[0], window_pos[1], window_w, window_h, tol);
	if pos then
		out_of_glass = 1;
	end
	pos = srFindImageInRange("GlassTemperature.png", window_pos[0], window_pos[1], window_w, window_h, tol);
	if not pos then
		state.status = state.status .. " No temperature found, ignoring";
		return state.status;
	end
	
	

	local temp = ocrNumber(pos[0] + temperature_width, pos[1]);
	if temp == null then
		-- If we don't get a valid number at the end of the Temperature Label, then complain loudly
	
		error("Whilst the macro picked up the Temperature label, it could not work out the actual temperature. Has the UI changed?");
	end

	state.status = (state.status .. " Temp:" .. temp);

	cooking = srFindImageInRange("GlassCooking.png", window_pos[0], window_pos[1], window_w, window_h, tol);
	
	if (stop_cooking or out_of_glass) and not cooking then
		return nil;
	end
	
	-- Some kind of glass is being made
	madeSomeGlass = true;
	
	-- Monitor temperature
	local last_frame_just_added = state.just_added;
	if state.last_temp then
		local fell = temp < state.last_temp;
		local rose = temp > state.last_temp;
		if fell then
			state.status = state.status .. " (Fell)";
			state.spiking = nil;
		end
		if rose then
			state.status = state.status .. " (Rose)";
		end
		--  if just fell, and under max threshold, add 1 CC
		if fell and (temp < max_add_temp) then
			state.status = state.status .. " Fell,Adding";
			addCC(window_pos, state);
		end
			
		--  if just fell, and is under 1600+threshold, add one
		--    item, add another and wait for spike or fall
		if fell and (temp < min_new_temp) then
			-- addCC(window_pos, state); -- done above
			state.timer = 72;
			state.want_spike = 1;
			state.status = state.status .. " WaitingToSpike";
		end
		
		--if it's time to add for spike, add
		if state.want_spike and state.timer <= 0 then
			state.want_spike = nil;
			state.spiking = 1;
			state.timer = 0;
			addCC(window_pos, state);
		end
	end

	if state.want_spike then
		state.status = state.status .. " (Wait to Spike: " .. state.timer .. ")";
	end

	if state.spiking then
		state.status = state.status .. " (Spiking)";
	end
	
	state.last_temp = temp;
	if last_frame_just_added then
		state.just_added = nil;
	end

	-- Monitor what we're making
	
	if not cooking then
		state.status = state.status .. " NothingCooking";
		if not stop_cooking then
			if temp > 1600 and temp < 2400 then
				local made_one=nil;
				for item_index=1, #item_priority do
					pos = srFindImageInRange(item_priority[item_index], window_pos[0], window_pos[1], window_w, window_h, tol);
					if pos then
							for pngName, glassName in pairs(item_name) do
								if pngName == item_priority[item_index] then
								  making = glassName;
								  break;
								end
							end
						--state.status = state.status .. " Making:" .. item_priority[item_index];
						state.status = state.status .. " Making:" .. making;
						srClickMouseNoMove(pos[0]+5, pos[1]+2);
						made_one = 1;
						break;
					end
				end
				if not made_one then
					state.status = state.status .. " NothingToMake";
					-- refresh window
					clickAllText("This is");
				end
			else
				state.status = state.status .. " (Temp out of range)";
			end
		end
	else
		-- Something cooking, leave it be
		state.status = state.status .. " InUse";
	end
	
	state.last_nothing_cooking = not cooking;
	lsPrintln(state.status);
	return state.status; -- keep going and return status
end

function allowReorder(x, y)
	local z = 0
	local scale=0.7;
	local dy = 28;
	lsPrint(x, y, z, scale, scale, 0xFFFFFFff, "Click an item to raise priority");
	y=y+20;
	x=x+5;
	

	
	local item_index;
	for item_index=1, #item_priority do

		if lsButtonText(x, y, z, 100, 0xFFFFFFff, string.sub(string.sub(item_priority[item_index], 10), 1, -5)) then
			if item_index > 1 then
				local temp = item_priority[item_index-1];
				item_priority[item_index-1] = item_priority[item_index];
				item_priority[item_index] = temp;
			end	
		end
		-- debug code for checking image matching
		if false then
			local list = findAllImages(item_priority[item_index], tol);
			lsPrint(x+110, y, z, scale, scale, 0xFFFFFFff, #list);
		end
		y=y+dy;
	end
end

function testReorder()
	while 1 do
		lsSleep(100);
		allowReorder(10, 10);
		checkBreak();
		lsDoFrame();
	end
end

function doit()

	-- testReorder();
	
	askForWindow("Pin Glazier's Bench(es). [+2cc] adds charcoal (5 temperature ticks, 6 for Jewel Glass). Above high tempearture (3200, or 4400 for jewel) melt materials ([M] to show Melt Material window, [S]=Soda, [N]=Normal, [J]=Jewel). With materials loaded, the macro will take over.  ***NOTE*** If all lines don't say COOL DOWN on the macro before you add materials, you will need to pause the macro whilst any of the benches are between 1600 and 2400 otherwise you will lose glass already in the Glaziers Bench. Self Click, Options, Interface Options, Notifications: \"Use the chat area instead of popups\" MUST be CHECKED! Pause the macro when you need to use your mouse. ");
	
	srReadScreen();
	
	local glass_windows = findAllImages("ThisIs.png");
	
	if #glass_windows == 0 then
		error 'Could not find any \'Glazier\'s Bench\' windows.';
	end
	
	local glass_state = {};
	for window_index=1, #glass_windows do
		glass_state[window_index] = {};
	end
	
	local last_ret = {};
	
	while 1 do
	
		-- Tick

		srReadScreen();
		
		local glass_windows2 = findAllImages("ThisIs.png");
		local should_continue=nil;
		if #glass_windows == #glass_windows2 then
			for window_index=1, #glass_windows do
				local r = glassTick(glass_windows[window_index], glass_state[window_index]);
				last_ret[window_index] = r;
				if r then
					should_continue = 1;
				end
			end
		end

		-- Display status and sleep

		local start_time = lsGetTimer();
		while tick_time - (lsGetTimer() - start_time) > 0 do
			time_left = tick_time - (lsGetTimer() - start_time);

			lsPrint(10, 6, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
			lsPrint(10, 18, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Alt+Shift to pause this script.");
				if stop_cooking then
				  lsPrint(10, 32, 0, 0.7, 0.7, 0xFFFFFFff, "Waiting (Finishing up) " .. time_left .. " ms ...");
				else
				  lsPrint(10, 32, 0, 0.7, 0.7, 0xFFFFFFff, "Waiting " .. time_left .. " ms ...");
				end

			lsSetCamera(0,0,lsScreenX*1.2,lsScreenY*1.2);
			
			if not (#glass_windows == #glass_windows2) then
				lsPrintWrapped(10, 55, 5, lsScreenX-15, 1, 1, 0xFF7070ff, "Expected " .. #glass_windows .. " windows, found " .. #glass_windows2 .. ", not ticking.");		
				--lsPlaySound("error.wav");
				--sleepWithStatus(10000, "Expected " .. #glass_windows .. " windows, found " .. #glass_windows2 .. ", not ticking.");
			elseif not should_continue then
				lsPrint(10, 60, 5, 1.5, 1.5, 0x70FF70ff, "All benches done!");
				if (madeSomeGlass) then
					lsPlaySound("Complete.wav");
					madeSomeGlass = false;
				end
			end
			
			  lsSetCamera(0,0,lsScreenX*1.1,lsScreenY*1.1);
			for window_index=1, #glass_windows do
				if last_ret[window_index] then
					should_continue = 1;
					lsPrint(10, 75 + 15*window_index, 0, 0.7, 0.7, 0xFFFFFFff, "#" .. window_index .. " - " .. last_ret[window_index]);
				else
					lsPrint(10, 75 + 15*window_index, 0, 0.7, 0.7, 0xFFFFFFff, "#" .. window_index .. " - COOL DOWN");
				end
			end
			
			-- New buttons to help add charcoal and melt materials
			if lsButtonText(lsScreenX - 59, lsScreenY - 100, z, 60, 0x00FFFFff, "+2cc") then
				menuButtonSelected = 1;
			end
			
			if lsButtonText(lsScreenX - 86, lsScreenY - 65, z, 22, 0xFFFF00ff, "M") then
				menuButtonSelected = 2;
			end

			if lsButtonText(lsScreenX - 59, lsScreenY - 65, z, 25, 0xFF00FFff, "S") then
				menuButtonSelected = 3;
			end

			if lsButtonText(lsScreenX - 32, lsScreenY - 65, z, 25, 0xFF00FFff, "N") then
				menuButtonSelected = 4;
			end

			if lsButtonText(lsScreenX - 5, lsScreenY - 65, z, 25, 0xFF00FFff, "J") then
				menuButtonSelected = 5;
			end

			
			if not stop_cooking then
				if lsButtonText(lsScreenX - 80, lsScreenY - 30, z, 100, 0xFFFFFFff, "Finish Up") then
					stop_cooking = 1;
				end
			else
				if lsButtonText(lsScreenX - 80, lsScreenY - 30, z, 100, 0x80ff80ff, "Cancel ...") then
					stop_cooking = nil;
				end
			end


			if lsButtonText(lsScreenX - 80, lsScreenY, z, 100, 0xFFFFFFff, "End script") then
				error "Clicked End Script button";
			end
			
			allowReorder(10, 100+15*#glass_windows);
			
			checkBreak();
			checkButtons();
			lsDoFrame();
			lsSleep(25);
		end
		
		checkBreak();
		-- error 'done';
	end

end

function checkButtons()
	if (menuButtonSelected == 1) then
		-- User has clicked the +2 cc button, so click all Add 2 Charcoal buttons on the screen
		clickAllText("Add 2 Charcoal");
	end
	
	if (menuButtonSelected == 2) then
		-- User has clicked the M button, so click all Melt Materials buttons
		clickAllText("Melt Materials...");
	end
	
	if (menuButtonSelected == 3) then
		-- User has clicked the S button, so click all Into Soda Glass buttons on the screen
		clickAllText("Into Soda Glass");
	end
	
	if (menuButtonSelected == 4) then
		-- User has clicked the N button, so click all Into Normal Glass buttons on the screen
		clickAllText("Into Normal Glass");
	end
	
	if (menuButtonSelected == 5) then
		-- User has clicked the J button, so click all Into Jewel Glass buttons on the screen
		clickAllText("Into Jewel Glass");
	end
	
	menuButtonSelected= 0;
end

function clickAllText(textToFind)
	local allTextReferences = findAllText(textToFind);
	
	for buttons=1, #allTextReferences do
		srClickMouseNoMove(allTextReferences[buttons][0]+20, allTextReferences[buttons][1]+5);
	end
end

function fetchItemName()
      for k, v in pairs(item_name) do
         if string.find(chatText[j][2], k, 0, true) then
            return true;
         end
      end
end
