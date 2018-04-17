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
plantCloser = false;
autoWater = true;
pauseAfterHarvest = true;
manualPin = false;

delayAfterHarvestPerPlant = 2500;
grid_x = 240;
grid_y = 100;


function doit()
  askForWindow("This macro will assist you by planting seeds, watering/harvesting your pinned windows when you tap the hotkey. After seeds are planted, you will tap hotkey over each plant, it will then pin the windows for you and do first watering automatically. After first watering, you will then tap hotkey to water/harvest (after you see it grow).\n\nBe in F8F8, zoomed in. Must have 'Plant all crops where you stand' turned OFF! Right click pins/unpins Must be ON!\n\nPress Shift over ATITD window to continue.");

center = getCenterPos();

	chooseMethod();
	setCameraView(CARTOGRAPHER2CAM);
	config();

  while 1 do
	firstWater = 1;
	
	 if autoWater then
	   drawWater();
	 end

	main();

	if not manualPin then
	  getPoints();
	  pinWindows();
	end

	waterThese();
	closeAllWindows(); -- This won't close the plant window, only the veggy windows


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
    sleepWithStatus(100, "When ALL plants grow:\n\n" .. key .. " to Water/Harvest plants");
  elseif firstWater == 1 and manualPin then
    sleepWithStatus(100, "After you pin your windows:\n\n" .. key .. " to water pinned plants");
  else
   checkBreak();
  end

  if firstWater == 0 then
    refreshWindows();
  end

    if (is_shifted and not was_shifted) or (firstWater == 1 and not manualPin) then
	statusScreen("Watering / Harvesting plants ...");
	checkBreak();
	srReadScreen();
	local waters = findAllImages(waterImage);
	local harvest = findAllImages(harvestImage);

	  if #harvest >= 1 then

		  for i=#harvest,1,-1 do
			checkBreak();
			safeClick(harvest[i][0] + 5, harvest[i][1]);
			lsSleep(click_delay);
		  end

			break;  -- Break the loop after Harvest found and clicked

	  else

		  for i=#waters,1,-1 do
		    checkBreak();
			  for water=1,water_req do
			    safeClick(waters[i][0] + 5, waters[i][1] + 5);
			    lsSleep(click_delay);
		         end

			if firstWater == 1 and not manualPin then
			  sleepWithStatus(3000, "Giving FIRST watering, to ALL plants ...");
			end

		  firstWater = 0;
		  end
	  end
    end
    was_shifted = is_shifted;
  end
end


function config()
  clickList = {};
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
    sleepWithStatus(100, key .. " over seed name (in pinned plant window) to record location and begin planting"); 
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
      clickList[#clickList + 1] = {mx, my};
      break;
    end
    was_shifted = is_shifted;
  end
end


function main()
  lsSleep(click_delay);

  for i = 0, count-1 do

    	for i=1,#clickList do
		checkBreak();
		safeClick(clickList[i][1], clickList[i][2]);
		lsSleep(click_delay);
    	end

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
	lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
	y = y + 30;
      lsPrint(10, y, 0, 0.8, 0.8, 0xffffffff, "How many plants (1-8)?");
      is_done, count = lsEditBox("count", 210, y, 0, 50, 30, 0.8, 0.8, 0x000000ff, 6);
      count = tonumber(count);
      if not count then
        is_done = false;
        lsPrint(10, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        count = 6;
      end
	y = y + 35;
      lsPrint(10, y, 0, 0.8, 0.8, 0xffffffff, "Water per plant:");
      is_done, water_req = lsEditBox("water_req", 210, y, 0, 50, 30, 0.8, 0.8, 0x000000ff, 1);
      water_req = tonumber(water_req);
      if not water_req then
        is_done = false;
        lsPrint(10, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        water_req = 1;
      end
	y = y + 35;
      lsPrint(10, y, 0, 0.8, 0.8, 0xffffffff, "Click Delay (ms):");
      is_done, click_delay = lsEditBox("click_delay", 210, y, 0, 50, 30, 0.8, 0.8, 0x000000ff, 50);
      click_delay = tonumber(click_delay);
      if not click_delay then
        is_done = false;
        lsPrint(10, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        click_delay = 50;
      end
	y = y + 120;
      lsSetCamera(0,0,lsScreenX*1.4,lsScreenY*1.4);
      plantCloser = lsCheckBox(15, y, z, 0xffffffff, " Plant Veggies closer together", plantCloser);
	y = y + 25;
      autoWater = lsCheckBox(15, y, z, 0xffffffff, " Auto gather water", autoWater);
	y = y + 25;
      pauseAfterHarvest = lsCheckBox(15, y, z, 0xffffffff, " Pause/Wait for Trigger after Harvest", pauseAfterHarvest);
	y = y + 25;
      manualPin = lsCheckBox(15, y, z, 0xffffffff, " Let me Pin plant windows Manually", manualPin);
	y = y + 40;
      lsPrint(10, y, 0, 0.9, 0.9, 0xffffffff, "Click Delay: Pause between clicking each plant");
	y = y + 20;
      lsPrint(10, y, 0, 0.9, 0.9, 0xffffffff, "Plant closer: Not for large veggy, like cabbage");
      lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);

    if lsButtonText(10, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Next") then
        is_done = 1;
    end
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff,
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

  local closeImages = {"ThisIs.png", "Ok.png"};
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
	safeClick(vegclickList[i][1], vegclickList[i][2], 1);
	lsSleep(75);
	end
	arrangeStashed(false, false, grid_x, grid_y);
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
    if #vegclickList == count then -- Break out of loop once #plants clicked
    lsDoFrame();
	break;
    end
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
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
  key = "tap Shift";
  elseif (dropdown_cur_value == 2) then
  was_shifted = lsControlHeld();
  key = "tap Ctrl";
  elseif (dropdown_cur_value == 3) then
  was_shifted = lsAltHeld();
  key = "tap Alt";
  elseif (dropdown_cur_value == 4) then
  was_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
  key = "click MWheel ";
  end
  
  local is_done = false;

  while not is_done do
    sleepWithStatus(100, "When done harvesting " .. key .. " to continue planting.\n\nIf you need a break, do so now before you " .. key .. "\n\nIf you're tired, now is a good time to Ctrl+Shift to quit ...");
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
