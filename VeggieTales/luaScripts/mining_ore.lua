-- mining_ore.lua v1.2 -- by Cegaiel
-- Credits to Tallow for his Simon macro, which was used as a template to build on.
-- 
-- Brute force method, you manually click/set every stones' location and it will work every possible 3 node/stone combinations
--

assert(loadfile("luaScripts/common.inc"))();

askText = singleLine([[
  Ore Mining v1.2 (by Cegaiel) --
  Brute Force method. Will try every possible 3 node/stone combination.
  Make sure chat is MINIMIZED! Press Shift over ATITD window.
]]);


clickList = {};
mineList = {};
dropdown_values = {"Shift Key", "Ctrl Key", "Alt Key", "Mouse Wheel Click"};
dropdown_cur_value = 1;
dropdown_ore_values = {"Aluminum (9)", "Antimony (14)", "Copper (8)", "Gold (12)", "Iron (7)", "Lead (9)", "Lithium (10)", "Magnesium (9)", "Platinum (12)", "Silver (10)", "Strontium (10)", "Tin (9)", "Tungsten (12)", "Zinc (10)"};
dropdown_ore_cur_value = 1;


function doit()
  askForWindow(askText);
  promptDelays();
  getMineLoc();
  getPoints();
  clickSequence();
end


function getMineLoc()
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
  mx = 0;
  my = 0;
  z = 0;
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
      mineList[#mineList + 1] = {mx, my};
    end
    was_shifted = is_shifted;
    checkBreak();
    lsPrint(10, 10, z, 1.0, 1.0, 0xFFFFFFff,
	    "Set Mine Location");
    local y = 60;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "1) Lock ATITD screen (Alt+L) .");
    y = y+16;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "1b) Suggest F5 view, zoomed out.");
    y = y+16;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "2) Hover and " .. key .. " over the MINE.");
    y = y + 30;
    local start = math.max(1, #mineList - 20);
    local index = 0;
    for i=start,#mineList do
	mineX = mineList[i][1];
	mineY = mineList[i][2];
    end

  if #mineList >= 1 then
      is_done = 1;
  end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "End script") then
      error "Clicked End Script button";
    end
    lsDoFrame();
    lsSleep(10);
  end
end

function fetchTotalCombos()
  totalCombos = 0;
	for i=1,#clickList do
		for j=i+1,#clickList do
			for k=j+1,#clickList do
			totalCombos = totalCombos + 1;
			end
		end
	end
  statusScreenPause("[1/" .. totalCombos .. "] Nodes Worked:");
end


function getPoints()
  if (dropdown_ore_cur_value == 1) then
  ore = "Aluminum";
  stonecount = 9;
  elseif (dropdown_ore_cur_value == 2) then
  ore = "Antimony";
  stonecount = 14;
  elseif (dropdown_ore_cur_value == 3) then
  ore = "Copper";
  stonecount = 8;
  elseif (dropdown_ore_cur_value == 4) then
  ore = "Gold";
  stonecount = 12;
  elseif (dropdown_ore_cur_value == 5) then
  ore = "Iron";
  stonecount = 7;
  elseif (dropdown_ore_cur_value == 6) then
  ore = "Lead";
  stonecount = 9;
  elseif (dropdown_ore_cur_value == 7) then
  ore = "Lithium";
  stonecount = 10;
  elseif (dropdown_ore_cur_value == 8) then
  ore = "Magnesium";
  stonecount = 9;
  elseif (dropdown_ore_cur_value == 9) then
  ore = "Platinum";
  stonecount = 12;
  elseif (dropdown_ore_cur_value == 10) then
  ore = "Silver";
  stonecount = 10;
  elseif (dropdown_ore_cur_value == 11) then
  ore = "Strontium";
  stonecount = 10;
  elseif (dropdown_ore_cur_value == 12) then
  ore = "Tin";
  stonecount = 9;
  elseif (dropdown_ore_cur_value == 13) then
  ore = "Tungsten";
  stonecount = 12;
  end

  local nodeleft = stonecount;
  local was_shifted = lsShiftHeld();
  if (dropdown_cur_value == 1) then
  was_shifted = lsShiftHeld();
  elseif (dropdown_cur_value == 2) then
  was_shifted = lsControlHeld();
  elseif (dropdown_cur_value == 3) then
  was_shifted = lsAltHeld();
  elseif (dropdown_cur_value == 4) then
  was_shifted = lsMouseIsDown(2); --Button 3, which is middle mouse or mouse wheel
  end

  local is_done = false;
  local nx = 0;
  local ny = 0;
  local z = 0;
  while not is_done do
    nx, ny = srMousePos();
    local is_shifted = lsShiftHeld();
  if (dropdown_cur_value == 1) then
  is_shifted = lsShiftHeld();
  elseif (dropdown_cur_value == 2) then
  is_shifted = lsControlHeld();
  elseif (dropdown_cur_value == 3) then
  is_shifted = lsAltHeld();
  elseif (dropdown_cur_value == 4) then
  is_shifted = lsMouseIsDown(2);
  end

    if is_shifted and not was_shifted then
      nodeError = 0;
      clickList[#clickList + 1] = {nx, ny};
      nodeleft = nodeleft - 1;
    end
    was_shifted = is_shifted;
    checkBreak();
    lsPrint(10, 10, z, 1.0, 1.0, 0xFFFFFFff,
	    "Set Node Locations (" .. #clickList .. ")");
    local y = 60;

    if nodeError == 1 then
    clickList = {};
    lsPrint(5, y, z, 0.7, 0.7, 0xff4040ff, "Not enough nodes! Minimum is 7.");
    y = y + 30
    end

    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "1) Hover and " .. key .. " over each node.");
    y = y + 16;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "2) Make sure chat is MINIMIZED!");
    y = y + 40;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Mine Type:  " .. ore);
    y = y + 16;
    lsPrint(5, y, z, 0.7, 0.7, 0xf0f0f0ff, "Select " .. nodeleft .. " more nodes to activate auto-mine!");
    y = y + 30;
    local start = math.max(1, #clickList - 20);
    local index = 0;
    for i=start,#clickList do
      local xOff = (index % 3) * 100;
      local yOff = (index - index%3)/2 * 15;
      lsPrint(20 + xOff, y + yOff, z, 0.5, 0.5, 0xffffffff,
              "(" .. clickList[i][1] .. ", " .. clickList[i][2] .. ")");
      index = index + 1;
    end


  -- Old way (v1.0-1.1), now it doesn't need you to click the button to continue.
  --Now it automatically detects if you've clicked the correct amount of nodes.
  --if #clickList >= 7 then
    --if lsButtonText(10, lsScreenY - 30, z, 100, 0x80ff80ff, "Work") then
      --is_done = 1;
   --end

    if #clickList >= stonecount then
      is_done = 1;
    end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
                    "End script") then
      error "Clicked End Script button";
    end
    lsDoFrame();
    lsSleep(10);
  end
end


function fetchTotalCombos()
  totalCombos = 0;
	for i=1,#clickList do
		for j=i+1,#clickList do
			for k=j+1,#clickList do
			totalCombos = totalCombos + 1;
			end
		end
	end
  statusScreenPause("DON\'T MOVE MOUSE !!!");
  lsSleep(750);
end


function clickSequence()
  fetchTotalCombos();
  local worked = 1;
	for i=1,#clickList do
		for j=i+1,#clickList do
			for k=j+1,#clickList do
	-- 1st Node
	checkBreak();
	srSetMousePos(clickList[i][1], clickList[i][2]);
	lsSleep(clickDelay);
	srKeyEvent('A'); 

		-- 2nd Node
		checkBreak();
		srSetMousePos(clickList[j][1], clickList[j][2]);
		lsSleep(clickDelay);
		srKeyEvent('A'); 

			-- 3rd Node
			checkBreak();
			srSetMousePos(clickList[k][1], clickList[k][2]);
			lsSleep(clickDelay);
			srKeyEvent('S'); 
			lsSleep(popDelay);
			findClosePopUp();
		       statusScreenPause("[" .. worked .. "/" .. totalCombos .. "] Nodes Worked: " .. i .. ", " .. j .. ", " .. k);
			worked = worked + 1
	end

		end

			end

  checkBreak();
  --Send 'W' key over Mine to Work it (Get new nodes)
  srSetMousePos(mineX, mineY);
  lsSleep(clickDelay);
  srKeyEvent('W'); 
  sleepWithStatusPause(3000, "Working mine (Fetching new nodes)");
  --Reset the mine/node points and restart
  mineList = {};
  clickList = {};
  getPoints();
  clickSequence();
 end

function findClosePopUp()
  while 1 do
  checkBreak();
  srReadScreen();
  OK = srFindImage("OK.png");
	if OK then  
	srClickMouseNoMove(OK[0]+2,OK[1]+2, true);
	lsSleep(clickDelay);
	else
	break;
	end
  end
end

function promptDelays()
  local is_done = false;
  local count = 1;
  while not is_done do
    checkBreak();
    local y = 10;
    lsPrint(12, y, 0, 0.8, 0.8, 0xffffffff,
            "Key or Mouse to Select Nodes:");
    y = y + 35;
    lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);
    dropdown_cur_value = lsDropdown("ArrangerDropDown", 15, y, 0, 320, dropdown_cur_value, dropdown_values);
    lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);

    y = y + 25;
    lsPrint(12, y, 0, 0.8, 0.8, 0xffffffff,
            "How many Nodes? (Choose ore)");
    y = y + 50;

    lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);
    dropdown_ore_cur_value = lsDropdown("ArrangerDropDown2", 15, y, 0, 320, dropdown_ore_cur_value, dropdown_ore_values);
    lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);

    y = y + 15;
    lsPrint(12, y, 0, 0.8, 0.8, 0xffffffff,
            "Set Delays:");
	y = y + 35;

      lsPrint(15, y, 0, 0.8, 0.8, 0xffffffff, "Node Delay (ms):");
      is_done, clickDelay = lsEditBox("delay", 165, y, 0, 50, 30, 1.0, 1.0,
                                     0x000000ff, 150);
      clickDelay = tonumber(clickDelay);
      if not clickDelay then
        is_done = false;
        lsPrint(10, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        clickDelay = 150;
      end
	y = y + 50;
      lsPrint(15, y, 0, 0.8, 0.8, 0xffffffff, "Popup Delay (ms):");
      is_done, popDelay = lsEditBox("delay2", 165, y, 0, 50, 30, 1.0, 1.0,
                                      0x000000ff, 500);
      popDelay = tonumber(popDelay);
      if not popDelay then
        is_done = false;
        lsPrint(10, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        popDelay = 500;
      end

	y = y + 35;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Node Delay: Delay before selecting each node.");
	y = y + 16;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Popup Delay: After Finalizing, delay to find Popup.");
	y = y + 16;
      lsPrint(5, y, 0, 0.6, 0.6, 0xffffffff, "Decrease values to run faster (try increments of 25)");

    if lsButtonText(10, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Next") then
        is_done = 1;
    end
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff,
                    "End script") then
      error(quitMessage);
    end

    lsSleep(50);
    lsDoFrame();
  end
  return count;
end