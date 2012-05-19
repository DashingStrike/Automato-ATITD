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


function doit()
	num_flax = promptNumber("How much flax to process?", 100);
	num_loops = math.floor(num_flax / 10);

  askForWindow(askText);

	local step = 1;
	local task = "Remove Straw"; -- Step 1
	local warn_small_font=nil;
	local warn_large_font=nil;
	local loop_count=1;
	local straw = 0;
	local tow = 0;
	local lint = 0;
	local clean = 0;

	
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


			if step == 1 then
			task = "Remove Straw";
			elseif step == 2 then
			task = "Separate Tow";
			elseif step == 3 then
			task = "Refine the Lint"
			elseif step == 4 then
			task = "Clean"
			end

		
		if not stats_black and not stats_black2 and not stats_black3 then
			sleepWithStatus(1200, "Next Step: " .. step .. "/4 - " .. task .. "\n----------------------------------------------\n1) Straw Removed: " .. straw .."/" .. num_loops*10 .. "\n2) Tow Seperated: " .. tow .. "/" .. num_loops*10 .. "\n3) Lint Refined: " .. lint .. "/" .. num_loops*10 .. "\n4) Cleanings: " .. clean .. "/" .. num_loops .. "\n----------------------------------------------\nFlax Processed: " .. (loop_count-1)*10 .. "\nFlax Remaining: " .. num_flax - ((loop_count-1)*10) .. "\n" .. warning);


		elseif loop_count > num_loops then
			num_loops = nil;
		elseif step <= 3 then

			if step == 1 then
			straw = straw + 10;
			elseif step == 2 then
			tow = tow + 10;
			elseif step == 3 then
			lint = lint + 10;
			end

			step = step + 1;

			clickAllImages("ThisIs.png");
			lsSleep(200);
		
			clickAllImages("step.png");
			lsSleep(200);
			
		elseif step == 4 then
			-- refresh windows
			clickAllImages("ThisIs.png");
			lsSleep(200);
		
			clickAllImages("clean.png");
			lsSleep(200);

			clean = clean + 1;			
			step = 1;
			loop_count= loop_count +1;
		elseif loop_count >= num_loops then
			num_loops = nil;
		end

end
	if num_loops == nil then
			sleepWithStatus(5000, "ALL DONE!\n----------------------------------------------\n1) Straw Removed: " .. straw .."/" .. clean*10 .. "\n2) Tow Seperated: " .. tow .. "/" .. clean*10 .. "\n3) Lint Refined: " .. lint .. "/" .. clean*10 .. "\n4) Cleanings: " .. clean .. "/" .. clean .. "\n----------------------------------------------\nFlax Processed: " .. (loop_count-1)*10 .. "\nFlax Remaining: " .. num_flax - ((loop_count-1)*10));

	lsPlaySound("Complete.wav");
	end
end


