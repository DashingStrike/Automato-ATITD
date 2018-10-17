-- wheat.lua v1.1 -- by Cegaiel
--
-- Waters and harvests wheat plants, but you still need to manually plant every seed and pin up the window.
-- You can Alt+Shift to Pause the macro and plant new beds/add new windows anytime.
-- Then Alt+Shift again to Resume the macro. It will find any new pinned bed windows.
-- Just make sure no windows overlap (The word 'This is'should be visibile in every window).
--

dofile("common.inc");

askText = singleLine([[
 Wheat Tenderer v1.1 (by Cegaiel) -- Pin 'Plant Wheat' window up for easy access later. Manually plant and pin up any number of wheat beds.
You must be standing with water icon present and 50 water jugs in inventory. After you manually plant your wheat beds and pin up each window, Press Shift to continue.
]]);

water_count = 0; 
refill_jugs = 40;
total_harvests = 0;
total_waterings = 0;
right_click = true; -- Do right clicks to help prevent the possibility of avatar running on a misclick. Right clicks works the same as left clicks!
click_delay = 0; -- Overide the default of 50 in common.inc libarary. Run faster, clicks get queued and still execute, even when executed during a lag spike.

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

function closeEmptyWindows()
        srReadScreen();
        emptyWindow = srFindImage("WindowEmpty.png");
        if emptyWindow then
		--clickAllImages(image_name, offsetX, offsetY, rightClick, tol)
            clickAllImages("WindowEmpty.png", 50, 20, 1);
            lsSleep(100);
        end
end

function tendWheat()

  while 1 do

    -- Click pin ups to refresh the window
   local windowcount = clickAllImages("ThisIs.png");
   lsSleep(100);
   closeEmptyWindows();

		if windowcount == 0 then
		--error 'Did not find any pinned windows'
		end


	 sleepWithStatus(300, "Searching " .. windowcount .. " windows for Harvest");


	--Search for Harvest windows. Havest and Water will exist at same time in window, so we always search for Harvest first.

	srReadScreen();
    	local harvest = findAllImages("Harvest.png");

	if #harvest > 0 then
	total_harvests = total_harvests + #harvest

			--First, click harvest buttons
			for i=#harvest, 1, -1  do
				srClickMouseNoMove(harvest[i][0]+5, harvest[i][1]+3, right_click);
				lsSleep(click_delay);
			end


			--Wait a long moment, it takes a while before the window turns blank, to allow a right click to close it.
			sleepWithStatus(2000, "Harvested " .. windowcount .. " windows...");
			local windowcount = clickAllImages("ThisIs.png");  --Refresh windows to make the harvest windows turn blank
			sleepWithStatus(1000, "Refreshing " .. windowcount .. "/Preparing to Close windows...");


			--Right click to close previously harvested windows
			for i=#harvest, 1, -1  do
				srClickMouseNoMove(harvest[i][0]+5, harvest[i][1]+3, right_click);  -- Right click the window to close it.
				lsSleep(click_delay);
			end

	end		 

    srReadScreen();
    -- Refresh windows again
    local windowcount = clickAllImages("ThisIs.png");
    sleepWithStatus(300, "Searching " .. windowcount .. " windows for Water");


	-- Search for Water windows.
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

	-- When 40+ water jugs has been consumed, Refill the jugs.
	if water_count >= 40 then
	refillWater();
	end
    sleepWithStatus(3000, "----------------------------------------------\nIf you want to plant more wheat Press Alt+Shift to Pause\n\nOR Use Win Manager button to Pause + Arrange Grids\n----------------------------------------------\nWaterings SINCE Jugs Refill: " .. water_count .. "\nWaterings UNTIL Jugs Refill: " .. refill_jugs .. "\n----------------------------------------------\nTotal Waterings: " .. total_waterings .. "\nTotal Harvests: " .. total_harvests);

  end
  return quit_message;
end

     -- This will override the sleepWithStatus, in common/common_ui.inc so we can add a custom button "Window Manager"
function sleepWithStatusPause(delay_time, message, color, scale)
  sleepWithStatus(delay_time, message, color, scale);
end

local waitChars = {"-", "\\", "|", "/"};
local waitFrame = 1;

function sleepWithStatus(delay_time, message, color, scale)
  if not color then
    color = 0xffffffff;
  end
  if not delay_time then
    error("Incorrect number of arguments for sleepWithStatus()");
  end
  if not scale then
    scale = 0.8;
  end
  local start_time = lsGetTimer();
  while delay_time > (lsGetTimer() - start_time) do
    local frame = math.floor(waitFrame/5) % #waitChars + 1;
    time_left = delay_time - (lsGetTimer() - start_time);
    local waitMessage = "Waiting ";
    if delay_time >= 1000 then
      waitMessage = waitMessage .. time_left .. " ms ";
    end
    lsPrintWrapped(10, 50, 0, lsScreenX - 20, scale, scale, 0xd0d0d0ff,
		   waitMessage .. waitChars[frame]);
  if lsButtonText(10, lsScreenY - 30, 0, 125, 0x80D080ff, "Win Manager") then
    windowManager("Wheat Setup", nil, false, true, nil, nil, nil, nil, nil, nil, true);
  end
    statusScreen(message, color, nil, scale);
    lsSleep(tick_delay);
    waitFrame = waitFrame + 1;
  end
end
