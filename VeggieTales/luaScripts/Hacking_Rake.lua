do_click_refresh = 1;
do_click_refresh_when_end_red = 1;

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

function clickAll(image_name)
	-- Find buttons and click them!
	srReadScreen();
	xyWindowSize = srGetWindowSize();
	local buttons = findAllImages(image_name);
	
	if #buttons == 0 then
		statusScreen("Could not find specified buttons...");
		lsSleep(1500);
	else
		statusScreen("Clicking " .. #buttons .. "button(s)...");
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
		statusScreen("Done clicking (" .. #buttons .. " clicks).");
		lsSleep(100);
	end
end


function doit()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Pin Hacking Rake window up and have Rotten Flax in you inventory. Make sure your rake is on the first step before beginning. You MUST have Skills window open and everything from Strength to Perception skill should be visible.");
	local step = 1;
	local warn_small_font=nil;
	local warn_large_font=nil;
	local loop_count=1;
	
	while num_loops do
		lsSleep(250);
		srReadScreen();
		stats_black2 = nil;
		stats_black3 = nil;
		
		stats_black = srFindImage("AllStats-Black.png");
		if not stats_black then
			stats_black2 = srFindImage("AllStats-Black2.png");
			if not stats_black2 then
				stats_black3 = srFindImage("AllStats-Black3.png");
				if stats_black3 then
					warn_large_font = true;
				end
			else
				warn_small_font = true;
			end
		end
		
		local warning="";
		if warn_small_font then
			warning = "Your font size appears to be smaller than the default, many macros here will not work correctly.";
		elseif warn_large_font then
			warning = "Your font size appears to be larger than the default, many macros here will not work correctly.";
		end
		
		if not stats_black and not stats_black2 and not stats_black3 then
			sleepWithStatus(10*60*5, "[" .. loop_count .. "/" .. num_loops .. "] Wait for Endurance\n[" .. step .. "/4] Step Of Hacking Rake" .. warning);
		elseif loop_count > num_loops then
			num_loops = nil;
		elseif step <= 3 then

			step = step + 1;

			clickAll("This.png", 1);
			lsSleep(200);
		
			clickAll("step.png", 1);
			lsSleep(200);
			
		elseif step == 4 then
			-- refresh windows
			clickAll("This.png", 1);
			lsSleep(200);
		
			clickAll("clean.png", 1);
			lsSleep(200);
			
			step = 1;
			loop_count= loop_count +1;
		elseif loop_count >= num_loops then
			num_loops = nil;
		end
end
	if num_loops == nil then
	lsPlaySound("Complete.wav");
	end
end
