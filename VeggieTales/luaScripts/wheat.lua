-- wheat.lua v1.1 -- Original macro by Bardoth - Revised by Cegaiel
--
-- Waters and harvests wheat plants, but you still need to manually plant every seed.
-- You can Alt+Shift to Pause the macro and plant new beds/add new windows anytime. Then Alt+Shift again to Resume the macro. It will find any new pinned bed windows.
--

assert(loadfile("luaScripts/common.inc"))();

askText = singleLine([[
 Wheat Tenderer v1.0 (Revised by Cegaiel) --
Pin 'Plant Wheat' window up for easy access later. Manually plant and pin up any number of wheat beds.
You must be standing with water icon present and 50 water jugs in inventory. Press Shift to continue.
]]);

water_count = 0; 
refill_jugs = 40;
total_harvests = 0;
total_waterings = 0;
right_click = true; -- Do right clicks to help prevent the possibility of avatar running on a misclick.
click_delay = 0;

function doit()
  askForWindow(askText);
  refillWater() -- Refill jugs if we can, if not don't return any errors.
  tendWheat()
end

function refillWater()
	water_count = 0;
	refill_jugs = 40;
	lsSleep(100);
	srReadScreen();
	FindWater = srFindImage("iconWaterJugSmall.png");

	if FindWater then
	statusScreen("Refilling water...");
	srClickMouseNoMove(FindWater[0]+3,FindWater[1]-5, right_click);
	lsSleep(500);


		srReadScreen();
		FindMaxButton = srFindImage("Maxbutton.png");

		if FindMaxButton then
		srClickMouseNoMove(FindMaxButton[0]+3,FindMaxButton[1]+3, right_click);
		lsSleep(500);
		end

	end
end


function tendWheat()

  while 1 do

	srReadScreen();

    -- Click pin ups to refresh the window
   local windowcount = clickAllImages("ThisIs.png");

		if windowcount == 0 then
		error 'Did not find any pinned windows'
		end



    sleepWithStatusPause(300, "Searching " .. windowcount .. " windows for Harvest");


	srReadScreen();
    	local harvest = findAllImages("Harvest.png");

	if #harvest > 0 then

	total_harvests = total_harvests + #harvest

			--First click harvest buttons
			for i=#harvest, 1, -1  do
				srClickMouseNoMove(harvest[i][0]+5, harvest[i][1]+3, right_click);
				lsSleep(click_delay);
			end


			sleepWithStatusPause(2000, "Harvested " .. windowcount .. " windows...");

			local windowcount = clickAllImages("ThisIs.png");  --Refresh windows to make the harvest windows turn blank
			sleepWithStatusPause(1000, "Refreshing " .. windowcount .. "/Preparing to Close windows...");


			--Right click and close previously harvested windows
			for i=#harvest, 1, -1  do
				srClickMouseNoMove(harvest[i][0]+5, harvest[i][1]+3, right_click);  -- Right click the window to close it.
				lsSleep(click_delay);
			end

	end		 


	srReadScreen();

    -- Click pin ups to refresh the window
    local windowcount = clickAllImages("ThisIs.png");

   sleepWithStatusPause(300, "Searching " .. windowcount .. " windows for Water");



	srReadScreen();


    	local water = findAllImages("waterw.png");
	if #water > 0 then

			for i=1, #water do
			srClickMouseNoMove(water[i][0]+5, water[i][1]+3, right_click);
			lsSleep(click_delay);
			water_count = water_count + #water;
			total_waterings = total_waterings + #water;
			refill_jugs = refill_jugs - #water;
			end



	end




	if water_count >= 40 then
	refillWater();
	end

    sleepWithStatusPause(3000, "----------------------------------------------\nIf you want to plant more wheat Press Alt+Shift to Pause\n----------------------------------------------\nWaterings SINCE Jugs Refill: " .. water_count .. "\nWaterings UNTIL Jugs Refill: " .. refill_jugs .. "\n----------------------------------------------\nTotal Waterings: " .. total_waterings .. "\nTotal Harvests: " .. total_harvests);
  end
  return quitMessage;
end
