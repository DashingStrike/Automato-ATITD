-- Hackling Rake - Original macro by Bardoth (T6) - Revised by Cegaiel
-- Runs the Hacking Rake (or Flax Comb). Monitors the skills tab and only clicks when its all black.
--
--

assert(loadfile("luaScripts/common.inc"))();

askText = singleLine([[
Hackling Rake v1.0 (by Bardoth - Revised by Cegaiel) --
Pin Hacking Rake or Flax Comb window up and have Rotten Flax in you inventory. Make sure your rake is on the first step before starting. You MUST have Skills window open and everything from Strength to Perception skill should be visible.
Press Shift to continue.
]]);

do_click_refresh = 1;
do_click_refresh_when_end_red = 1;
improved_rake = 0;
num_flax = 0;
num_loops = 0;
per_rake = 10;

function promptRakeNumbers()
	scale = 1.0;
	
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
			lsPrint(10, y+18, z+10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
			num_flax = 1;
		end
		y = y + 32;
		improved_rake = lsCheckBox(10, y, z, 0xFFFFFFff, "Improved Rake", improved_rake);
		
		if improved_rake then
			per_rake = 30;
		else
			per_rake = 10;
		end
		
		num_loops = math.floor(num_flax / per_rake);
		
		y = y + 32;

		if lsButtonText(170, y+32, z, 100, 0xFFFFFFff, "OK") then
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

	
	while num_loops do
		checkBreak();
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
			sleepWithStatus(1200, "Next Step: " .. step .. "/4 - " .. task_text .. "\n----------------------------------------------\n1) Straw Removed: " .. straw .."/" .. num_loops*per_rake .. "\n2) Tow Seperated: " .. tow .. "/" .. num_loops*per_rake .. "\n3) Lint Refined: " .. lint .. "/" .. num_loops*per_rake .. "\n4) Cleanings: " .. clean .. "/" .. num_loops .. "\n----------------------------------------------\nFlax Processed: " .. (loop_count-1)*per_rake .. "\nFlax Remaining: " .. num_flax - ((loop_count-1)*per_rake) .. "\n" .. warning);
		elseif loop_count >= num_loops then
			num_loops = nil;
		else
			
			srReadScreen();
			lsSleep(50);
			clickAllText("This Is");
			lsSleep(200);
		
			srReadScreen();
			lsSleep(50);
			clickAllText(task);
			lsSleep(200);
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
			sleepWithStatus(300, "Refreshing screen");
			
			srReadScreen();
			lsSleep(50);
			clickAllText("This Is");
			lsSleep(200);
		end

end
	if num_loops == nil then
			sleepWithStatus(5000, "ALL DONE!\n----------------------------------------------\n1) Straw Removed: " .. straw .."/" .. clean*10 .. "\n2) Tow Seperated: " .. tow .. "/" .. clean*10 .. "\n3) Lint Refined: " .. lint .. "/" .. clean*10 .. "\n4) Cleanings: " .. clean .. "/" .. clean .. "\n----------------------------------------------\nFlax Processed: " .. (loop_count-1)*10 .. "\nFlax Remaining: " .. num_flax - ((loop_count-1)*10));

	lsPlaySound("Complete.wav");
	end
end


