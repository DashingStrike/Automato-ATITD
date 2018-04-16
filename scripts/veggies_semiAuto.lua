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
water_req = 1;  -- How many times to click the Water button per onion seed. Most are 1, some variations might need 2 per click.
plantCloser = false;
autoWater = true;
delayAfterHarvestPerPlant = 2500;
grid_x = 240;
grid_y = 288;


function doit()
  askForWindow("This macro does nothing except plant veggie seeds.\n\nIt will assist you by watering and harvesting your pinned windows when you click the trigger key. You must manually pin (or use Windows Manager) them yourself!\n\nBe in F8F8, zoomed in. Must have 'Plant all crops where you stand' turned OFF! Probably want to have chat minimized as well. Right click pins/unpins should be checked to properly close old windows\n\nPress Shift on ATITD window to continue.");

center = getCenterPos();

	chooseMethod();
	config();

  while 1 do
	  firstWater = 1;

	main();
	getPoints();
	pinWindows();
	waterThese();
	refreshWindows();
	  sleepWithStatus(delayAfterHarvestPerPlant*#tops, "Harvesting vegetables ...");
	closeAllWindows(); -- This won't close the plant window, only the veggy windows

	 if autoWater then
	  drawWater();
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

  if firstWater == 0 then
    sleepWithStatus(100, "When plant grows:\n\n" .. key .. " to water/harvest pinned plants");
  end

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

    if (is_shifted and not was_shifted) or (firstWater == 1) then
	checkBreak();
	refreshWindows();
	lsSleep(100);
	srReadScreen();
	local waters = findAllImages(waterImage);
	local harvest = findAllImages(harvestImage);

	statusScreen("Watering / Harvesting plants ...");

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

		if firstWater == 1 then
	        sleepWithStatus(3000, "Giving first water, to ALL plants ...");
		firstWater = 0;
		end
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
    srSetMousePos(center[0],center[1]);
  end
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
	y = y + 40;
      lsPrint(10, y, 0, 0.8, 0.8, 0xffffffff, "Water per plant:");
      is_done, water_req = lsEditBox("water_req", 210, y, 0, 50, 30, 0.8, 0.8, 0x000000ff, 3);
      water_req = tonumber(water_req);
      if not water_req then
        is_done = false;
        lsPrint(10, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        water_req = 3;
      end
	y = y + 40;
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
	y = y + 50;
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
	sleepWithStatus(200, "Closing Windows");
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
		  lsSleep(10);
	       end
end


function getCenterPos()
	xyWindowSize = srGetWindowSize()
	local ret = {};
	ret[0] = xyWindowSize[0] / 2;
	ret[1] = xyWindowSize[1] / 2;
	return ret;
end


function pinWindows()
    for i=1,#vegclickList do
	checkBreak();
	srSetMousePos(vegclickList[i][1], vegclickList[i][2]);
	srSetMousePos(35, 135);
	lsSleep(100);
	srClickMouseNoMove(vegclickList[i][1], vegclickList[i][2], 1);
	lsSleep(100);
	end

	arrangeInGrid(false, false, grid_x, grid_y);
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
    lsPrint(10, 10, z, 0.7, 0.7, 0xFFFFFFff,
	    "Set Planted Veggy Locations (" .. #vegclickList .. ")");
    lsPrint(10, 50, z, 0.7, 0.7, 0xFFFFFFff, "Quickly!");
    lsPrint(10, 85, z, 0.7, 0.7, 0xFFFFFFff, key .. " over each veggie in ground!");
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
