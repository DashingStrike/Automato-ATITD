-- Hackling Rake - Original macro by Bardoth (T6) - Revised by Cegaiel
-- Runs the Hacking Rake (or Flax Comb). Monitors the skills tab and only clicks when its all black.
--
--

dofile("common.inc");

askText = singleLine([[
Hackling Rake v1.0 (by Bardoth - Revised by Cegaiel) --
Pin Hacking Rake or Flax Comb window up and have Rotten Flax in your inventory. Make sure your rake is showing "Step 1, Remove Straw" before starting. You MUST have Skills window open and everything from Strength to Perception skill should be visible.
This macro will not break if you need to alt-tab out of game to do something or need to move pinned window. As soon as you flip back in game, it will continue where it left off at!
Press Shift to continue.
]]);

do_click_refresh = 1;
do_click_refresh_when_end_red = 1;
improved_rake = 0;
num_flax = 0;
num_loops = 0;
per_rake = 10;

function promptRakeNumbers()
	scale = 0.8;
	
	local z = 0;
	local is_done = nil;
	local value = nil;
	-- Edit box and text display
	while not is_done do
		-- Put these everywhere to make sure we don't lock up with no easy way to escape!
		checkBreak("disallow pause");
		
		lsPrint(10, 10, z, scale, scale, 0xFFFFFFff, "Hackling Raking Setup");
		
		-- lsEditBox needs a key to uniquely name this edit box
		--   let's just use the prompt!
		-- lsEditBox returns two different things (a state and a value)
		local y = 40;
		lsPrint(5, y, z, scale, scale, 0xFFFFFFff, "How much flax: ");
		is_done, num_flax = lsEditBox("passes",
			160, y, z, 70, 30, scale, scale,
			0x000000ff, 1);
		if not tonumber(num_flax) then
			is_done = nil;
			lsPrint(5, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
			num_flax = 1;
		end
		y = y + 50;
		improved_rake = CheckBox(10, y, z, 0xFFFFFFff, " Improved Rake", improved_rake);
		lsSetCamera(0,0,lsScreenX/1.0,lsScreenY/1.0);
		
		if improved_rake then
			per_rake = 30;
		else
			per_rake = 10;
		end
		
		num_loops = math.floor(num_flax / per_rake);
			if num_loops == 0 then
				num_loops = 1;
			end
		y = y + 32;

		if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Next") then
			is_done = 1;
		end

		lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff, "This will attempt to rake " .. num_flax .. " rotten flax, requiring " .. num_loops .. " cycles.");

		if is_done and (not num_flax) then
			error 'Canceled';
		end
		
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
			error "Clicked End Script button";
		end
	
		
		lsDoFrame();
		lsSleep(10); -- Sleep just so we don't eat up all the CPU for no reason
	end
end


function doit()
	promptRakeNumbers();
  askForWindow(askText);

	local step = 1;
	local task = "";
	local task_text = "";
	local warn_small_font=nil;
	local warn_large_font=nil;
	local loop_count=1;
	local straw = 0;
	local tow = 0;
	local lint = 0;
	local clean = 0;
	local startTime = lsGetTimer();

	
	while num_loops do
		checkBreak();
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

		if step == 1 then
			task = "Separate Rotten Flax";
			task_text = "Separate Straw";
		elseif step == 2 then
			task = "Continue processing Rotten";
			task_text = "Separate Tow";
		elseif step == 3 then
			task = "Continue processing";
			task_text = "Refine the Lint";
		elseif step == 4 then
			task = "Clean the";
			task_text = "Clean the Rake";
		end
		
		if not stats_black and not stats_black2 and not stats_black3 then
			sleepWithStatus(100, "Next Step: " .. step .. "/4 - " .. task_text .. "\n\n----------------------------------------------\n1) Straw Removed: " .. straw .."/" .. num_loops*per_rake .. "\n2) Tow Seperated: " .. tow .. "/" .. num_loops*per_rake .. "\n3) Lint Refined: " .. lint .. "/" .. num_loops*per_rake .. "\n4) Cleanings: " .. clean .. "/" .. num_loops .. "\n----------------------------------------------\n\nFlax Processed: " .. (loop_count-1)*per_rake .. "\nFlax Remaining: " .. (num_loops*per_rake) - straw .. "\n\nElapsed Time: " .. getElapsedTime(startTime) .. "\n" .. warning, nil, 0.7, 0.7);
		elseif loop_count > num_loops then
			num_loops = nil;
		else
			
			srReadScreen();
			clickAllText("This Is");
			lsSleep(100);
		
			srReadScreen();
			clickAllText(task);
			lsSleep(100);
			if step == 1 then
				straw = straw + per_rake;
			elseif step == 2 then
				tow = tow + per_rake;
			elseif step == 3 then
				lint = lint + per_rake;
			elseif
				step == 4 then
				clean = clean + 1;			
				step = 0;
				loop_count= loop_count +1;
			end
			step = step + 1;
			statusScreen("Timer Expired - Clicking window(s)\n\n----------------------------------------------\n1) Straw Removed: " .. straw .."/" .. num_loops*per_rake .. "\n2) Tow Seperated: " .. tow .. "/" .. num_loops*per_rake .. "\n3) Lint Refined: " .. lint .. "/" .. num_loops*per_rake .. "\n4) Cleanings: " .. clean .. "/" .. num_loops .. "\n----------------------------------------------\n\nFlax Processed: " .. (loop_count-1)*per_rake .. "\nFlax Remaining: " .. (num_loops*per_rake) - straw .. "\n\nElapsed Time: " .. getElapsedTime(startTime) .. "\n" .. warning, nil, 0.7, 0.7);
			
			srReadScreen();
			clickAllText("This Is");
			lsSleep(100);
		end

end

		lsPlaySound("Complete.wav");
		lsMessageBox("Elapsed Time:", getElapsedTime(startTime));
end


