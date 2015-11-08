dofile("screen_reader_common.inc");
dofile("ui_utils.inc");

window_w = 200;
window_h = 270;
tol=0;
taken=0;
made=0;
stop_cooking=0;

mes = '';
per_click_delay = 0;

tick_time = 100;

    -- All these coords are offsets from the image used to find the bars.
	-- X starts with 0 at the first black pixel in the P of progress.  (13 from window 0)
	-- Y has 0 as the topmost black pixel in the F of fuel. (156 from window 0)


	-- This is towards the end of progress bar, when it detects blue, at this coord, it starts looking
	-- for the Take... option
	-- It also stops stoking, should be enough heat to finish it the last 2 ticks, save a couple wood.
	-- Make this about 2 coords (X coord) from the end of the bar
	-- Also prevents a stoke after the barrel completes, which results in a popup.

	ProgressOffX = 176 
	ProgressOffY = 54


	-- Max Flame wanted (DANGER), do not have 2 wood in Fuel passed this point.  May need to adjust.
	-- Set about 24 coords (X coord) from the end of bar
	barMaxFlameOffX = 148 


	bar1WoodOffX = 57 	-- Coord for determining if at least 1 wood is in Fuel (+2 coords from left bar (black area/edge bar)
	bar2WoodOffX = 63 	-- Coord for determining if at least 2 wood is in Fuel (+8 coords from left bar (black area/edge bar)
	
	fuelBarOffY  =  5  	-- Y Coord for Fuel bar
	flameBarOffY = 20 	-- Y Coord for Flame bar


function clickAll(image_name, up)
	-- Find buttons and click them!
	srReadScreen();
	xyWindowSize = srGetWindowSize();
	local buttons = findAllImages(image_name);
	
	if #buttons == 0 then
		-- statusScreen("Could not find specified buttons...");
		-- lsSleep(1500);
	else
		-- statusScreen("Clicking " .. #buttons .. "button(s)...");
		if up then
			for i=#buttons, 1, -1  do
				srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3);
				lsSleep(per_click_delay);
			end
		else
			for i=1, #buttons  do
				srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3);
				lsSleep(per_click_delay);
			end
		end
		-- statusScreen("Done clicking (" .. #buttons .. " clicks).");
		-- lsSleep(100);
	end
end


function stoke(window_pos)
	-- lsPrintln(window_pos[0] .. " " .. window_pos[1] .. " " .. window_w .. " " .. window_h);
	local pos = srFindImageInRange("Stoke.png", window_pos[0], window_pos[1], window_w, window_h);
	if not pos then
		error 'Could not find Stoke button';
	end
	
	srClickMouseNoMove(pos[0]+5, pos[1]+2);
end

function ClosePopups()
	local OKpopup = srFindImage("OK-popup.png");
	if OKpopup then
		srClickMouseNoMove(OKpopup[0]+5, OKpopup[1]+2);
		lsSleep(100);
	end
	
end;

function FindBlue(X,Y)
		-- srSetMousePos(X,Y); lsSleep(250);
		local new_px = srReadPixel(X,Y);
		local px_R = (math.floor(new_px/256/256/256) % 256);
		local px_G = (math.floor(new_px/256/256) % 256);
		local px_B = (math.floor(new_px/256) % 256);
		local px_A = (new_px % 256);
	return ((px_B - px_R) > 0);
end;

function process_vise(window_pos)
	-- if we can take anything do that

	local take = srFindImageInRange("Take.png", window_pos[0], window_pos[1], window_w, window_h);
	if take then
		srClickMouseNoMove(take[0], take[1]);
		lsSleep(200);
		srClickMouseNoMove(take[0]+20, take[1]+7);
		taken = taken+1;
		return 'Take Everything'
	end;

	-- else if we can start a barrel do that
	-- ClosePopups();
	local makeabarrel = srFindImageInRange("Makeabarrel.png", window_pos[0], window_pos[1], window_w, window_h);
	if makeabarrel then
		if (made>=num_barrels) or (taken >=num_barrels) or (stop_cooking>0) then
			return nil;
		else
			made = made+1;
			srClickMouseNoMove(makeabarrel[0], makeabarrel[1]);
			return 'Starting New Barrel'
		end;
	end;

	-- else
	--   read bars
	--   
	local FuelStatus = 0;
	local cooldown = 0;
	local pos = srFindImageInRange("Vise_bars.png", window_pos[0]-5, window_pos[1], window_w, window_h);
	if not pos then
		error 'Cound not find Vise bars';
	end;
	local curFuel1 = FindBlue(pos[0]+bar1WoodOffX, pos[1]+fuelBarOffY);
	local curFuel2 = FindBlue(pos[0]+bar2WoodOffX, pos[1]+fuelBarOffY);
	local curFlame = FindBlue(pos[0]+barMaxFlameOffX, pos[1]+flameBarOffY);
	local curProgress = FindBlue(pos[0]+ProgressOffX, pos[1]+ProgressOffY);

	if curFuel2 then
		FuelStatus = 2			
	elseif curFuel1 then
		FuelStatus = 1
	else
		FuelStatus = 0
	end;

	if curProgress then
		cooldown = 1
	end


	if cooldown > 0 then	--Stop Stoking, should be enough heat to finish
		return('waiting for finish');
	elseif not curFlame then
		if FuelStatus < 1 then		-- Add 2 wood
			stoke(window_pos);
			stoke(window_pos);
			return "Flame: OK; Stoke (2 Wood)";
		elseif FuelStatus < 2 then		-- Add 1 wood
			stoke(window_pos);
			return "Flame: OK; Stoke (1 Wood)";
		end;
	else
		return "DANGER; No Stoke (0 Wood)";
	end;

	return 'Flame: OK; Fuel OK';
end


function refresh(window_pos)
	srClickMouseNoMove(window_pos[0], window_pos[1]);
end


function doit()

	-- testReorder();
	num_barrels = promptNumber("How many barrels?", 1);
	askForWindow("Have 100 Boards, 2 Copper Straps, and 80 Wood in your inventory for every barrel you want to make.\n	\nFor large numbers of barrels you can get away with less wood, the average used is 60.\n	\nPin as many vises as you want, put the cursor over the ATITD window, press Shift.");
	
	srReadScreen();
	
	local vise_windows = findAllImages("ThisIs.png");
	
	if #vise_windows == 0 then
		error 'Could not find \'Barrel Vise\' windows.';
	end
	
	local last_ret = {};
	local should_continue = 1;

	while should_continue > 0 do
	
		-- Tick

		clickAll("This.png", 1);
		ClosePopups();
		lsSleep(200);

		srReadScreen();
		local vise_windows2 = findAllImages("ThisIs.png");
		if #vise_windows == #vise_windows2 then
			for window_index=1, #vise_windows do
				local r = process_vise(vise_windows[window_index]);
				last_ret[window_index] = r;
			end
		end

		-- Display status and sleep
		should_continue = 0;
		checkBreak();
		local start_time = lsGetTimer();
		while tick_time - (lsGetTimer() - start_time) > 0 do
			time_left = tick_time - (lsGetTimer() - start_time);

			lsPrint(10, 6, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
			lsPrint(10, 18, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Alt+Shift to pause this script.");
			lsPrint(10, 30, 0, 0.7, 0.7, 0xFFFFFFff, "Waiting " .. time_left .. "ms...");
			
			if not (#vise_windows == #vise_windows2) then
				lsPrintWrapped(10, 45, 5, lsScreenX-15, 1, 1, 0xFF7070ff, "Expected " .. #vise_windows .. " windows, found " .. #vise_windows2 .. ", not ticking.");		
			elseif (made>=num_barrels) or (taken >= num_barrels) or (stop_cooking>0) then
				lsPrint(10, 45, 5, 1.5, 1.5, 0x70FF70ff, "Finishing up.");
			elseif (taken > made) then
				lsPrint(10, 45, 5, 1.5, 1.5, 0xFFFFFFff, taken .. "/" .. num_barrels .. " finished");
			else
				lsPrint(10, 45, 5, 1.5, 1.5, 0xFFFFFFff, made .. "/" .. num_barrels .. " started");
			end
			
			for window_index=1, #vise_windows do
				if last_ret[window_index] then
					should_continue = 1;
					lsPrint(10, 80 + 15*window_index, 0, 0.7, 0.7, 0xFFFFFFff, "#" .. window_index .. " - " .. last_ret[window_index]);
				else
					lsPrint(10, 80 + 15*window_index, 0, 0.7, 0.7, 0xFFFFFFff, "#" .. window_index .. " - Finished");
				end
			end
		
			if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0xFFFFFFff, "Finish up") then
				stop_cooking = 1;
			end
			if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
				error "Clicked End Script button";
			end
			
			checkBreak();
			lsDoFrame();
			lsSleep(25);
		end
		
		checkBreak();
		-- error 'done';
	end
end