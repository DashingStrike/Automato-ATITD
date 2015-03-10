function checkBreak(disallow_pause)
	if (lsShiftHeld() and lsControlHeld()) then
		if(cleanupCallback) then
			lsPrintln("calling cleanup call back");
			pcall(cleanupCallback);
			lsPrintln("cleanup call back returned");
		else
			lsPrintln("cleanupCallback == " .. type(cleanupCallback));
		end
		srKeyUp(-1);
		error "broke out with Shift+Ctrl";
	end
	if ((not disallow_pause) and (lsShiftHeld() and lsAltHeld())) then
		-- Pause
		while (lsAltHeld() or lsShiftHeld()) do
			statusScreen("Please release Alt+Shift", 0x808080ff, "disallow pause");
		end
		while not (lsAltHeld() and lsShiftHeld()) do
			statusScreen("Hold Alt+Shift to resume", 0xFFFFFFff, "disallow pause");
		end
		while (lsAltHeld() or lsShiftHeld()) do
			statusScreen("Please release Alt+Shift", 0x808080ff, "disallow pause");
		end
	end
	if ((disallow_pause == "button_pause") and (lsShiftHeld() and lsAltHeld())) then
		while 1 do
			-- Pause, but need a button to resume
			if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0xFFFFFFff, "Unpause") then
				return;
			end
			statusScreen("Paused", 0x808080ff, "disallow pause");
		end
	end
end

-- everything other than the prompt_string is optional!
function promptNumber(prompt_string, default_value, scale)
	if not default_value then
		default_value = 0;
	end
	if not scale then
		scale = 1.0;
	end
	local z = 0;
	local is_done = nil;
	local value = nil;
	-- Edit box and text display
	while not is_done do
		-- Put these everywhere to make sure we don't lock up with no easy way to escape!
		checkBreak("disallow pause");
		
		lsPrint(10, 10, z, scale, scale, 0xFFFFFFff, prompt_string);
		
		-- lsEditBox needs a key to uniquely name this edit box
		--   let's just use the prompt!
		-- lsEditBox returns two different things (a state and a value)
		is_done, value = lsEditBox(prompt_string,
			10, 40, z, 100, 30, scale, scale,
			0x000000ff, default_value);
			
		if lsButtonText(120, 40, z, 100, 0xFFFFFFff, "OK") then
			is_done = 1;
		end

		if is_done and not value then
			error 'Canceled';
		end
		
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
			error "Clicked End Script button";
		end
	
		if not tonumber(value) then
			is_done = nil;
			lsPrint(10, 80, z, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
		end
		
		lsDoFrame();
		lsSleep(10); -- Sleep just so we don't eat up all the CPU for no reason
	end
	
	return tonumber(value);
end

-- Okay/Cancel prompt
function promptOkay(prompt_string)
	local color = 0xffffffff;
	local z = 0;
	local is_done = nil;
	local ret = nil;
	local scale = 0.7;
	-- Edit box and text display
	while not is_done do
		-- Put these everywhere to make sure we don't lock up with no easy way to escape!
		checkBreak("disallow pause");
		
		lsPrint(10, 10, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
		lsPrint(10, 35, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Alt+Shift to choose Okay.");
		lsPrintWrapped(10, 60, 0, lsScreenX - 20, 1, 1, color, prompt_string);
		
		if (lsButtonText(120, 200, z, 100, 0xFFFFFFff, "OK") or
				(lsAltHeld() and lsShiftHeld())) then
			is_done = 1;
			ret = 1;
		end

		if lsButtonText(120, 230, z, 100, 0xFFFFFFff, "Cancel") then
			is_done = 1;
			ret = nil;
		end
		
		lsDoFrame();
		lsSleep(10); -- Sleep just so we don't eat up all the CPU for no reason
	end
	
	while (lsAltHeld() or lsShiftHeld()) do
		statusScreen("Please release Alt+Shift", 0x808080ff);
	end
	
	return ret;
end

-- Utility function for just displaying a status message and a cancel option
function statusScreen(message, color, disallow_pause)
	if not color then
		color = 0xFFFFFFff;
	end
	lsPrintWrapped(10, 60, 0, lsScreenX - 20, 1, 1, color, message);
	if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
		error "Clicked End Script button";
	end
	if not (disallow_pause == "no break") then
		lsPrint(10, 10, 0, 0.7, 0.7, 0xB0B0B0ff, "Hold Ctrl+Shift to end this script.");
		checkBreak(disallow_pause);
	end
	lsDoFrame();
end

function sleepWithStatus(delay_time, message, no_break)
	local start_time = lsGetTimer();
	while delay_time - (lsGetTimer() - start_time) > 0 do
		time_left = delay_time - (lsGetTimer() - start_time);
		if message then
			lsPrintWrapped(10, 60, 0, lsScreenX - 20, 1, 1, 0xFFFFFFff, message);
		end
		lsPrintWrapped(10, 120, 0, lsScreenX - 20, 1, 1, 0xFFFFFFff, "Waiting " .. time_left .. "ms...");
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
			error "Clicked End Script button";
		end
		if not no_break then
			checkBreak();
		end
		lsDoFrame();
		lsSleep(100);
	end
end

function fatalError(message)
	error_status = "Press Shift+Control to exit";
	statusScreen(message,0xFF0000ff);
	for curr = 0, 6 do
		lsPlaySound("Clank.wav");
		lsSleep(100);
	end
	while(1) do
		checkBreak();
		lsSleep(10);
	end
end
