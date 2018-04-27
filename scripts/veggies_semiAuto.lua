--- Veggies SemiAuto v1.3.0 by Cegaiel
-- Credits to the Author of veggies.lua (Submitted to Github by MHoroszowski on Sep 19, 2015) for his work as a starting point.

-- Make sure Automato is not at the bottom right corner, as this is where the plant windows are stashed, prior to pinning.
-- Also beware, if you have the stand alone version of Discord running, you will want to turn off Notifications or Mute Servers.
-- Those notifications that appear on bottom right of screen will eventually mess up the pinning process, if it tries to stash windows while the notification exists.

-- Pin your plant window, showing the seed you want to plant.  Enter the name of seed (partial name is fine -- ie you can enter 'Tears' for 'Tears of Sinai'). It is ok to move the plant window between plantings.
-- You can typically plant 8 plants and get the first watering done, before they die with 1 watering seeds. 2 to 3 watering seeds might be pushing it. May want to use 4-6 plants on those.
-- If you are unsure how many waterings a seed takes, try checking wiki: https://wiki.desert-nomad.com/index.php?title=Vegetable

-- Options:
-- Plant Veggies Closer together: This will plant your veggies in a small radius around your avatar.
-- Auto Gather Water: If you are planting near a water source, it will refill your jugs prior to each planting. You can optionally pin a Rain Barrel window and it will draw water from the barrel.
-- Pause/Wait for Trigger after Harvest: Due to current variations in lag and duck time, sometimes it takes a few moments before all your veggies disappear, even after you stop moving.
-- This will pause the macro until you press your hotkey, to be sure all veggies are off the screen. If you uncheck this box, then it plants in continuous mode. You can adjust the timer below (delayAfterHarvestPerPlant = 2500) 
-- Let me Pin my windows manually: The macro does pin up all your plant windows manually and form a grid (but you have to Tap Shift (optionally Ctrl, Alt, click MouseWheel). If you feel you can do it faster, then thats what this option is for.
-- 'Remember plant coords' between planting: Prior to v1.3.0 you had to tap Shift over each plant, every time you planted.  This option remembers the last positions and attempts to use the same coordinates every round.
-- 'Remember plant coords' can be inconsistent, sometimes. I think if you move too far while watering/harvesting, it can throw off coords by a pixel or two, sometimes resulting in a right click to miss the plant.
-- If you find that some windows don't appear (or none at all), then this is likely the reason.
-- And experiment, to give consistent results, there is now a repositionAvatar() function. This simply attempts to make your avatar face the same direction every time, prior to planting.
-- I find that using the "Plant Veggies closer together' option usually gives better results. But for small plants, like Leeks, it can be tricky to click each one when Plant > 6.
-- Just remember, for the most reliable results, don't use 'Remember plant coords' options. Expect some minor issues when you do.  But the macro should be able to recover and continue regardless.

-- How to Use:
-- Pin your your plant menu, so that your seed name shows.
-- Your veggies will be planted. Quickly (before they die), tap Shift (or your trigger key) over each plant. As soon as you tap key over your last veggie, macro will automatically begin:
-- It will now pin all your plant windows up, arrange the windows in a grid and give it it's first watering.  Then it will Pause.
-- When you see ALL of your plants grow Tap key and it will water all your plants again. Keep doing this until the windows shows Harvest.  Another tap of the key will Harvest them, close out windows and ready for next round.


dofile("common.inc");

Button = {};
Button[0] = makePoint(45, 60); --NW
Button[1] = makePoint(75, 62); --NE
Button[2] = makePoint(45, 87); --SW
Button[3] = makePoint(75, 91); --SE
Button[4] = makePoint(59, 51); --N
Button[5] = makePoint(60, 98); --S
Button[6] = makePoint(84, 74); --E
Button[7] = makePoint(37, 75); --W
BuildButton = makePoint(31, 135);

dropdown_values = {"Shift Key", "Ctrl Key", "Alt Key", "Mouse Wheel Click"};
dropdown_cur_value = 1;
waterImage = "WaterThese.png";
harvestImage = "HarvestThese.png";
thisIs = "This is";
plantCloser = true;
autoWater = true;
pauseAfterHarvest = true;
manualPin = false;
saveCoords = true;

delayAfterHarvestPerPlant = 2500;
grid_x = 240;
grid_y = 100;

firstLoop = true;

function doit()
  askForWindow("This macro will assist you by planting seeds, watering/harvesting your pinned windows when you tap the hotkey. After seeds are planted, you will tap hotkey over each plant, it will then pin the windows for you and do first watering automatically. After first watering, you will then tap hotkey to water/harvest (after you see it grow).\n\nMust have 'Plant all crops where you stand' turned OFF! Right click pins/unpins Must be ON! One-Click: Auto-take Piles ON!\n\nMake sure plant seed menu window AND Automato is in the TOP-RIGHT corner of the screen.");

  center = getCenterPos();
  size = srGetWindowSize();

	chooseMethod();

	if saveCoords and not plantCloser then
	  message = "Note:\n\nWhen using 'Remember Plant Coords' option, you may find that also using the 'Plant veggies closer' option MIGHT provide better results (when trying to use previous coordinates).\n\nThis is not required, but might be worth experimenting!\n\n" .. key .. " to continue!";
	  displayError(message);
	end

	setCameraView(CARTOGRAPHER2CAM);
	lsSleep(1000);

  while 1 do
	firstWater = 1;

	closeAllWindows(0,0, size[0]-350, size[1]); -- Look for windows for any left over planted windows
	closeAllWindows(size[0]-500, size[1]-200, size[0], size[1]); -- Look for any leftover windows (stashed) at bottom right.

	 if autoWater then
	   drawWater();
	 end

	if saveCoords then
	  repositionAvatar();	
	end

	main();

	if not manualPin then
		if firstLoop or not saveCoords then
		  getPoints();
		  firstLoop = false;
		else
		  sleepWithStatus(2500,"Slight pause for 'Water These' to appear on plants, before we pin",nil, 0.7, 0.7);
		end
	  pinWindows();
	end

	waterThese();
	closeAllWindows(0,0, size[0]-350, size[1]); -- Look for windows for any left over planted windows
	closeAllWindows(size[0]-500, size[1]-200, size[0], size[1]); -- Look for any leftover windows (stashed) at bottom right.

	if pauseAfterHarvest then
	  waitForShift();
	else
	  sleepWithStatus(delayAfterHarvestPerPlant*#tops, "Harvesting vegetables ...");
	end
  end
end


function waterThese()
  local was_shifted = lsShiftHeld();
  if (dropdown_cur_value == 1) then
  was_shifted = lsShiftHeld();
  key = "Tap Shift";
  elseif (dropdown_cur_value == 2) then
  was_shifted = lsControlHeld();
  key = "Tap Ctrl";
  elseif (dropdown_cur_value == 3) then
  was_shifted = lsAltHeld();
  key = "Tap Alt";
  elseif (dropdown_cur_value == 4) then
  was_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
  key = "click MWheel ";
  end
  
  local is_done = false;
  while not is_done do
    checkBreak();
    local is_shifted = lsShiftHeld();
    if (dropdown_cur_value == 1) then
      is_shifted = lsShiftHeld();
    elseif (dropdown_cur_value == 2) then
      is_shifted = lsControlHeld();
    elseif (dropdown_cur_value == 3) then
      is_shifted = lsAltHeld();
    elseif (dropdown_cur_value == 4) then
      is_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
    end

  if firstWater == 0 then
    statusScreen("When ALL plants GROW:\n" .. key .. " to Water/Harvest plants\n\n[" .. tended .. "] All Plants Watered\n\nYou can " .. key .. " even if you are still watering (animations) last growth. Watering/Harvests will be queued!\n\n\nClick Abort button if something went wrong. This will close all veggie windows and start over.", nil, 0.7, 0.7);
	refreshWindows();
  elseif firstWater == 1 and manualPin then
    statusScreen("After you pin your windows:\n\n" .. key .. " to water pinned plants", nil, 0.7, 0.7);
  end

	if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0xFFFFFFff, "Abort") then
	  break;
	end


    if (is_shifted and not was_shifted) or (firstWater == 1 and not manualPin) then
	statusScreen("Watering / Harvesting plants ...");
	checkBreak();
	srReadScreen();
	local waters = findAllImages(waterImage);
	local harvest = findAllImages(harvestImage);

	if #waters == 0 and #harvest == 0 then
	  message = "Could not find any pinned veggies!\n\nThis usually happens if you missed a plant when you " .. key .. ".\n\nHigh resolutions, such as 1920x1080 has such a small margin of where you clicked on veggie.\n\nIf avatar moves or body is facing a certain direction MIGHT be a factor...\n\n" .. key .. " to continue"
	  displayError(message);
	  break;
	end


	  if #harvest >= 1 then

		  for i=#harvest,1,-1 do
			checkBreak();
			safeClick(harvest[i][0] + 5, harvest[i][1]);
			lsSleep(click_delay);
		  end

			break;  -- Break the loop after Harvest found and clicked

	  else
		     tended = tended + 1
		  for i=#waters,1,-1 do
		    checkBreak();

			  for water=1,water_req do
			    safeClick(waters[i][0] + 5, waters[i][1] + 5);
			    lsSleep(click_delay);
		         end

			if firstWater == 1 and not manualPin then
			  sleepWithStatus(2500, "Giving FIRST watering, to ALL plants ...", nil, 0.7, 0.7);
			end
		  firstWater = 0;
		  end
	  end
    end
    was_shifted = is_shifted;
    lsSleep(100);
  end
end


function main()
  getPlantWindowPos();
  tended = 0;

  for i = 0, count-1 do
	checkBreak();
	--Click Seed in Plant Window	
	safeClick(plantPos[0], plantPos[1]);
	lsSleep(click_delay);

	--Click Build window to move veggies on ground
    safeClick(Button[i][0], Button[i][1]);
    lsSleep(click_delay);
	if not plantCloser then
    safeClick(Button[i][0], Button[i][1]);
    lsSleep(click_delay);
	end
    safeClick(BuildButton[0], BuildButton[1]);
    lsSleep(click_delay);
  end
    srSetMousePos(center[0],center[1]);
end


function chooseMethod()
  local was_shifted = lsShiftHeld();
  if (dropdown_cur_value == 1) then
  was_shifted = lsShiftHeld();
  key = "Tap Shift";
  elseif (dropdown_cur_value == 2) then
  was_shifted = lsControlHeld();
  key = "Tap Ctrl";
  elseif (dropdown_cur_value == 3) then
  was_shifted = lsAltHeld();
  key = "Tap Alt";
  elseif (dropdown_cur_value == 4) then
  was_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
  key = "click MWheel ";
  end

  local is_done = false;
  count = 1;
  while not is_done do
	checkBreak();
	local y = 10;
	lsPrint(5, y, 0, 0.7, 0.7, 0xffffffff,
            "Key or Mouse to Trigger Watering/Harvest:");
	y = y + 35;
	lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);
	dropdown_cur_value = lsDropdown("ArrangerDropDown", 10, y, 0, 200, dropdown_cur_value, dropdown_values);
	lsSetCamera(0,0,lsScreenX*1.1,lsScreenY*1.1);
	y = y + 35;

      lsPrint(10, y, 0, 0.8, 0.8, 0xffffffff, "Seed Name:");
      is_done, seedName = lsEditBox("seedName", 120, y-5, 0, 190, 30, 0.8, 0.8, 0x000000ff, "Tears");
	y = y + 35;



      lsPrint(10, y, 0, 0.8, 0.8, 0xffffffff, "How many plants (1-8):");
      is_done, count = lsEditBox("count", 200, y, 0, 50, 30, 0.8, 0.8, 0x000000ff, 6);
      count = tonumber(count);
      if not count then
        is_done = false;
        lsPrint(10, y+19, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        count = 6;
      end
	y = y + 35;
      lsPrint(10, y, 0, 0.8, 0.8, 0xffffffff, "Water per plant:");
      is_done, water_req = lsEditBox("water_req", 200, y, 0, 50, 30, 0.8, 0.8, 0x000000ff, 1);
      water_req = tonumber(water_req);
      if not water_req then
        is_done = false;
        lsPrint(10, y+19, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        water_req = 1;
      end
	y = y + 35;
      lsPrint(10, y, 0, 0.8, 0.8, 0xffffffff, "Click Delay (ms):");
      is_done, click_delay = lsEditBox("click_delay", 200, y, 0, 50, 30, 0.8, 0.8, 0x000000ff, 75);
      click_delay = tonumber(click_delay);
      if not click_delay then
        is_done = false;
        lsPrint(10, y+19, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        click_delay = 75;
      end
	y = y + 105;
      lsSetCamera(0,0,lsScreenX*1.5,lsScreenY*1.5);
      autoWater = lsCheckBox(15, y, z, 0xffffffff, " Auto gather water", autoWater);
	y = y + 25;
      pauseAfterHarvest = lsCheckBox(15, y, z, 0xffffffff, " Pause/Wait for Trigger after Harvest", pauseAfterHarvest);
	y = y + 25;
      saveCoords = lsCheckBox(15, y, z, 0xffffffff, " Remember plant coords between plantings", saveCoords);
	y = y + 25;
      plantCloser = lsCheckBox(15, y, z, 0xffffffff, " Plant Veggies closer together", plantCloser);
	y = y + 25;
      manualPin = lsCheckBox(15, y, z, 0xffffffff, " Let me Pin plant windows Manually", manualPin);
	y = y + 35;
      lsPrint(10, y, 0, 0.9, 0.9, 0xffffffff, "Click Delay: Pause between clicking each plant");
	y = y + 20;
      lsPrint(10, y, 0, 0.9, 0.9, 0xffffffff, "Plant closer: Not for large veggy, like cabbage");
      lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);

    if lsButtonText(10, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Next") then
        is_done = 1;
    end
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 110, 0xFFFFFFff,
                    "End script") then
      error(quitMessage);
    end
  lsDoFrame();
  lsSleep(50);
  end
  return count;
end


function closeAllWindows(x, y, width, height)
  if not x then
    x = 0;
  end
  if not y then
    y = 0;
  end
  if not width then
    width = srGetWindowSize()[0];
  end
  if not height then
    height = srGetWindowSize()[1];
  end

  local closeImages = {"ThisIs.png", "Ok.png", "UnPin.png"};
  local closeRight = {1, 1, nil};
  local found = true;

  while found do
    found = false;
    for i=1,#closeImages do

      local image = closeImages[i];
      local right = closeRight[i];
      srReadScreen();
      local images = findAllImagesInRange(image, x, y, width, height);
      while #images >= 1 do
	done = true;
	safeClick(images[#images][0], images[#images][1], right);
	sleepWithStatus(click_delay, "Closing Windows");
	srReadScreen();
	images = findAllImagesInRange(image, x, y, width, height);
      end
    end
  end
end


function refreshWindows()
  srReadScreen();
	tops = findAllText(thisIs);
		for i=1,#tops do
        	  safeClick(tops[i][0], tops[i][1]);
		  --lsSleep(10);
	       end
end


function getCenterPos()
	xyWindowSize = srGetWindowSize()
	bottomRightX = xyWindowSize[0] - 20;
	bottomRightY = xyWindowSize[1] - 20;
	local ret = {};
	ret[0] = xyWindowSize[0] / 2;
	ret[1] = xyWindowSize[1] / 2;
	return ret;
end


function pinWindows()
	srSetMousePos(bottomRightX, bottomRightY);
	lsSleep(65);

    for i=1,#vegclickList do
	checkBreak();
	srSetMousePos(bottomRightX, bottomRightY);
	safeClick(vegclickList[i][1], vegclickList[i][2], 1);
	lsSleep(click_delay);
    end
	arrangeStashed(false, false, grid_x, grid_y);
	srSetMousePos(center[0],center[1]);
end


function getPoints()
vegclickList = {};
  local was_shifted = lsShiftHeld();
  
  if (dropdown_cur_value == 1) then
  was_shifted = lsShiftHeld();
  key = "Tap Shift";
  elseif (dropdown_cur_value == 2) then
  was_shifted = lsControlHeld();
  key = "Tap Ctrl";
  elseif (dropdown_cur_value == 3) then
  was_shifted = lsAltHeld();
  key = "Tap Alt";
  elseif (dropdown_cur_value == 4) then
  was_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
  key = "click MWheel ";
  end
  
  local is_done = false;
  local mx = 0;
  local my = 0;
  local z = 0;
  while not is_done do
    mx, my = srMousePos();
    local is_shifted = lsShiftHeld();
    
    if (dropdown_cur_value == 1) then
      is_shifted = lsShiftHeld();
    elseif (dropdown_cur_value == 2) then
      is_shifted = lsControlHeld();
    elseif (dropdown_cur_value == 3) then
      is_shifted = lsAltHeld();
    elseif (dropdown_cur_value == 4) then
      is_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
    end
    
    if is_shifted and not was_shifted then
      vegclickList[#vegclickList + 1] = {mx, my};
    end
    was_shifted = is_shifted;
    checkBreak();
    lsPrint(10, 10, z, 0.7, 0.7, 0xffff80ff,
	    "Set Planted Veggy Locations (" .. #vegclickList .. "/" .. count .. ")");
    lsPrint(10, 50, z, 0.9, 0.9, 0xff8080ff, "Quickly!");
    lsPrint(10, 85, z, 0.7, 0.7, 0x80ff80ff, key .. " over each veggie on ground!");

    local index = 0;
    local y = 130;
    local start = math.max(1, #vegclickList - 20);
    for i=start,#vegclickList do
      local xOff = (index % 4) * 70;
      local yOff = (index - index%4)/2 * 7;
      lsPrint(5 + xOff, y + yOff, z, 0.5, 0.5, 0xffffffff,
              i .. ": (" .. vegclickList[i][1] .. ", " .. vegclickList[i][2] .. ")");
      index = index + 1;
    end

    if #vegclickList == count then -- Break out of loop once #plants clicked
    lsDoFrame();
	break;
    end
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 110, 0xFFFFFFff,
                    "End script") then
      error "Clicked End Script button";
    end
    lsDoFrame();
    lsSleep(50);
  end
end


function waitForShift()
  local was_shifted = lsShiftHeld();
  if (dropdown_cur_value == 1) then
  was_shifted = lsShiftHeld();
  key = "Tap Shift";
  elseif (dropdown_cur_value == 2) then
  was_shifted = lsControlHeld();
  key = "Tap Ctrl";
  elseif (dropdown_cur_value == 3) then
  was_shifted = lsAltHeld();
  key = "Tap Alt";
  elseif (dropdown_cur_value == 4) then
  was_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
  key = "click MWheel ";
  end
  
  local is_done = false;

  while not is_done do
	if lsButtonText(5, lsScreenY - 30, z, 150, 0xFFFFFFff, "Pick Up Seeds") then
	  pickUpSeeds();
	  closeAllWindows(0,0, size[0]-350, size[1]); -- Look for windows for any left over planted windows
	  closeAllWindows(size[0]-500, size[1]-200, size[0], size[1]); -- Look for any leftover windows (stashed) at bottom right.
	end

    statusScreen(key .. " to continue planting!\n\nWait until ALL animations STOP and ALL plants disappear, FIRST.\n\nNote: 'Pick Up Seeds' button isn\'t foolproof.\n\nIt simply right-clicks where you previously set plant locations.\n\nIf you moved too far from starting position, it will likely misclick and fail! If this happens, you need to manually click the seeds (bags)", nill, 0.7, 0.7);
    local is_shifted = lsShiftHeld();

    if (dropdown_cur_value == 1) then
      is_shifted = lsShiftHeld();
    elseif (dropdown_cur_value == 2) then
      is_shifted = lsControlHeld();
    elseif (dropdown_cur_value == 3) then
      is_shifted = lsAltHeld();
    elseif (dropdown_cur_value == 4) then
      is_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
    end
    
    if is_shifted and not was_shifted then
	break;
    end
    was_shifted = is_shifted;
    lsSleep(100);
  end
end


function getPlantWindowPos()
  srReadScreen();
  plantPos = findText(seedName);
  if plantPos then
    plantPos[0] = plantPos[0] + 20;
    plantPos[1] = plantPos[1] + 10;
  end
  if not plantPos then
    error 'Could not find plant window';
  end
  return plantPos;
end

function displayError(message)
  local was_shifted = lsShiftHeld();
  if (dropdown_cur_value == 1) then
  was_shifted = lsShiftHeld();
  key = "Tap Shift";
  elseif (dropdown_cur_value == 2) then
  was_shifted = lsControlHeld();
  key = "Tap Ctrl";
  elseif (dropdown_cur_value == 3) then
  was_shifted = lsAltHeld();
  key = "Tap Alt";
  elseif (dropdown_cur_value == 4) then
  was_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
  key = "click MWheel ";
  end
  
  local is_done = false;

  while not is_done do
--    statusScreen("Could not find any pinned veggies!\n\nThis usually happens if you missed a plant when you " .. key .. ".\n\nHigh resolutions, such as 1920x1080 has such a small margin of where you clicked on veggie.\n\nIf avatar moves or body is facing a certain direction MIGHT be a factor...\n\n" .. key .. " to continue", nil, 0.7, 0.7);
    statusScreen(message, nil, 0.7, 0.7);

    local is_shifted = lsShiftHeld();

    if (dropdown_cur_value == 1) then
      is_shifted = lsShiftHeld();
    elseif (dropdown_cur_value == 2) then
      is_shifted = lsControlHeld();
    elseif (dropdown_cur_value == 3) then
      is_shifted = lsAltHeld();
    elseif (dropdown_cur_value == 4) then
      is_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
    end
    
    if is_shifted and not was_shifted then
	break;
    end
    was_shifted = is_shifted;
  end
end


function repositionAvatar()
  statusScreen("Repositioning Avatar to face N/S ...");
  safeClick(center[0],center[1]-200);
  lsSleep(500);
  safeClick(center[0],center[1]+200);
  lsSleep(500);
end


function pickUpSeeds()
  srSetMousePos(center[0],center[1]);
  lsSleep(100);
  srKeyEvent(string.char(27));  -- Send Esc Key to close the window
  lsSleep(100);
  srReadScreen();
  utility = findText("Utility");
  lsSleep(100);
	if utility then
	  srClickMouseNoMove(utility[0]+12,utility[1]+5);
	  lsSleep(100);
  	else
	  sleepWithStatus(1250, "Error: Could not find menu option 'Utility'\n\nWas part of the menu obscured behind Automato, perhaps?");
  	end
  srReadScreen();

  bags = findText("Make nearby");
  lsSleep(250);

	if bags then
	  srClickMouseNoMove(bags[0]+12,bags[1]+5);
	  lsSleep(100);
	else
	  sleepWithStatus(1250, "Error: Could not find menu option 'Make nearby portables look like bags'\n\nWas part of the menu obscured behind Automato, perhaps?");
  end


  if bags then
    for i=1,#vegclickList do
	checkBreak();
	safeClick(vegclickList[i][1], vegclickList[i][2], 1);
	--lsSleep(click_delay);
    end
  end

end