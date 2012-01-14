--
-- 
--

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

per_tree_delay_time = 5000;
total_delay_time = 80000;
carrot_delay_time = 10*60*1000;

function doit()
	carrot_timer = lsGetTimer();
	askForWindow("Pin 5-10 tree windows, will click them VERTICALLY (left to right if there is a tie - multiple columns are fine).  Additionally, optionally, pin a Bonfire and Consume window for stashing wood and eating grilled carrots (first carrot will be consumed after 10 minutes).");
	-- Find windows
	srReadScreen();
	xyWindowSize = srGetWindowSize();
	local buttons = findAllImages("GatherWood.png");
	if #buttons == 0 then
		error 'Could not find any Gather Wood buttons';
	end
	while 1 do
		for i=1, #buttons do
			-- srReadScreen();
			statusScreen("Grabbing Wood " .. i .. "/" .. #buttons);
			srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]);
			lsSleep(per_tree_delay_time);
		end
		srReadScreen();
		bonfire = srFindImage("Bonfire.png");
		if bonfire then
			statusScreen("Found bonfire...");
			add_wood = srFindImage("AddSomeWood.png");
			if add_wood then
				-- add it
				statusScreen("Adding wood to bonfire");
				srClickMouseNoMove(add_wood[0]+5, add_wood[1]+5);
				lsSleep(500);
				-- click Max
				srClickMouseNoMove(xyWindowSize[0]/2, xyWindowSize[1]/2 + 55);
			else
				statusScreen("No add wood button, refreshing bonfire");
				-- refresh bonfire window
				srClickMouseNoMove(bonfire[0]+5, bonfire[1]+5);
			end
		end
		
		carrots = srFindImage("EatSomeGrilledCarrots.png");
		
		local time_left = total_delay_time - #buttons * per_tree_delay_time;
		local eat_carrots = nil;
		if (time_left > 0) then
			local start_time = lsGetTimer();
			while time_left - (lsGetTimer() - start_time) > 0 do
				time_left2 = time_left - (lsGetTimer() - start_time);
				carrot_note = "";
				if carrots then
					carrot_time_left = carrot_timer + carrot_delay_time - lsGetTimer();
					if carrot_time_left < 0 then
						carrot_time_left = 0;
						eat_carrots = 1;
					end
					carrot_note = "  " .. math.floor(carrot_time_left / 1000) .. "s until eating carrots.";
				else
					carrot_note = "";
				end
				statusScreen("Waiting " .. time_left2 .. "ms before starting next pass..." .. carrot_note);
				lsSleep(100);
				checkBreak();
			end
		end
		if eat_carrots then
			srReadScreen();
			carrots = srFindImage("EatSomeGrilledCarrots.png");
			if carrots then
				srClickMouseNoMove(carrots[0]+5, carrots[1]+5);
				carrot_timer = lsGetTimer();
			end
		end
	end
end
