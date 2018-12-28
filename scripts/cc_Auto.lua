-- cc-auto.lua v1.0.2 -- by Tallow, based on Tak's cc program, updated by Manon on 5 jan 2018
-- Update History: https://github.com/DashingStrike/Automato-ATITD/commits/master/scripts/cc_Auto.lua
--
-- v1.0.1 - 2015.12.13 by wzdhek
-- v1.0.2 - 2018.03.16 by Manon120184
-- v1.0.3 - 2018.03.17 by taralx
-- v1.0.4 - 2018.05.06 by Cegaiel
-- v1.0.5 - 2018.06.05 by Cegaiel
--
-- Automatically runs many charcoal hearths or ovens simultaneously.
--

dofile("cc_Assist.lua");

askText = "CC Auto v1.0.5 (by Tallow, based on Tak's cc program; furthur tweaks by Manon, Tarral and Cegaiel)\n\nAutomatically runs many charcoal hearths or ovens simultaneously.\n\nMake sure this window is in the TOP-RIGHT corner of the screen.\n\nTap Shift (while hovering ATITD window) to continue.";

BEGIN = 1;
WOOD = 2;
WATER = 3;
CLOSE = 4;
OPEN = 5;
FULL = 6;

woodAddedTotal = 0;
waterAddedTotal = 0;

function ccMenu()
  local passCount = promptNumber("How many passes?", 1, 1.0);
  askForFocus();
  startTime = lsGetTimer();
  for i=1,passCount do
	woodAdded = 0;
	waterAdded = 0;
	woodx1Click = 0;
    drawWater(1); -- Refill Jugs. The parameter of 1 means don't do the animation countdown. Since we won't be running somewhere, not needed
    lsSleep(100);
    Do_Take_All_Click(); -- Make sure ovens are empty. If a previous run didn't complete and has wood leftover, will cause a popup 'Your oven already has wood' and throw macro off
    runCommand(buttons[1]);
    lsSleep(1000);
    ccRun(i, passCount);
  end
  Do_Take_All_Click(); -- All done, empty ovens
  lsPlaySound("Complete.wav");
  lsMessageBox("Elapsed Time:", getElapsedTime(startTime), 1);
end

function findOvens()
  local result = findAllImages("ThisIs.png");
  for i=1,#result do
    local corner = findImageInWindow("mm-corner.png",
				     result[i][0], result[i][1]);
    if not corner then
      error("Failed to find corner of cc window.");
    end
    result[i][1] = corner[1];-- - 0;
  end
  return result;
end

function setupVents(ovens)
  local result = {};
  for i=1,#ovens do
    result[i] = 0;
  end
  return result;
end

function findButton(pos, index)
  return findImageInWindow(buttons[index].image, pos[0], pos[1]);
end

function clickButton(pos, index, counter)
  local buttonPos = findButton(pos, index);
  if buttonPos then
    safeClick(buttonPos[0] + buttons[index].offset[0],
	      buttonPos[1] + buttons[index].offset[1]);

	if index == 3 and counter ~= nil then -- Water
	  waterAdded = waterAdded + 1;
	  waterAddedTotal = waterAddedTotal + 1;
	end
	if index == 2 and counter ~= nil then -- Wood
	  woodAdded = woodAdded + 1;
	  woodAddedTotal = woodAddedTotal + 1;
	end
  end
end

function ccRun(pass, passCount)
  local ovens = findOvens();
  local vents = setupVents(ovens);
  local done = false;
  while not done do
    sleepWithStatus(2000, "Waiting on next tick ...\n\n[" .. pass .. "/" .. passCount .. "] Passes\n\nTotals: [This Pass/All Passes]\n\n[".. woodAdded*3 .. "/" .. 
		woodAddedTotal*3 .. "] Wood Used - Actual\n[" .. woodAdded.. "/" .. woodAddedTotal .. "] 'Add Wood' Button Clicked (x1)\n\n[" .. waterAdded .. "/" .. waterAddedTotal .. 
		"] Water Used\n             (Excluding cooldown water)\n\n\nElapsed Time: " .. getElapsedTime(startTime),nil, 0.7, 0.7);
    done = true;
  	srReadScreen();
    for i=1,#ovens do
      if not findButton(ovens[i], BEGIN) then
				vents[i] = processOven(ovens[i], vents[i]);
				done = false;
      end
    end
  end
end

-- 0% = 56, 100% = 249, each % = 1.94

minHeat = makePoint(199, 15);
minHeatProgress = makePoint(152, 15);
minOxy = makePoint(80, 33);
maxOxy = makePoint(116, 33);
maxOxyLowHeat = makePoint(160, 33);
minWood = makePoint(108, 50);
minWater = makePoint(58, 70);
minWaterGreen = makePoint(96, 70);
maxDangerGreen = makePoint(205, 90);
maxDanger = makePoint(219, 90);
uberDanger = makePoint(228, 90);
progressGreen = makePoint(62, 110);

greenColor = 0x07FE05;
barColor = 0x0606FD;

function processOven(oven, vent)
  local newVent = vent;
  if pixelMatch(oven, progressGreen, greenColor, 4) then
    -- Progress is green

    if not pixelMatch(oven, minWaterGreen, barColor, 8) then
      -- Aggressively add water
      clickButton(oven, WATER);
      clickButton(oven, WATER);
    end
    if pixelMatch(oven, maxDangerGreen, barColor, 4) then
      -- Danger too high
      clickButton(oven, WATER);
    elseif vent ~= 3 then
      newVent = 3;
      clickButton(oven, FULL);
    end


  else

    -- Progress is not green
    if not pixelMatch(oven, minHeat, barColor, 8) then
      -- Heat too low
      if not pixelMatch(oven, minWood, barColor, 8) then
	-- Wood too low
	clickButton(oven, WOOD, 1);
      end
    end

    if not pixelMatch(oven, minOxy, barColor , 8) then
      -- Oxygen too low
      if vent ~= 3 then
	newVent = 3;
	clickButton(oven, FULL);
      end
    else
      local point = maxOxy;
      if not pixelMatch(oven, minHeatProgress, barColor, 8) then
        point = maxOxyLowHeat;
      end
      if pixelMatch(oven, point, barColor, 8) then
        -- Oxygen too high
        if vent ~= 1 then
	  newVent = 1;
	  clickButton(oven, CLOSE);
        end
      else
        -- Oxygen OK
        if vent ~= 2 then
	  newVent = 2;
	  clickButton(oven, OPEN);
        end
      end
    end

    if pixelMatch(oven, maxDanger, barColor, 8) then
      -- Danger > 85%
      if not pixelMatch(oven, minWater, barColor, 8) then
	-- Water < 2.6%
	clickButton(oven, WATER, 1);
	-- Splash more water if it > 90%
	if pixelMatch(oven, uberDanger, barColor, 8) then
	  clickButton(oven, WATER, 1);
	end
      end
    end
  end
  return newVent;
end

function Do_Take_All_Click()
      statusScreen("Checking / Emptying Ovens ...",nil, 0.7, 0.7);
	-- refresh windows
	clickAll("This.png", 1);
	lsSleep(100);

	clickAll("Take.png", 1);
	lsSleep(100);
	
	clickAll("Everything.png", 1);
	lsSleep(100);
	
	-- refresh windows, one last time so we know for sure the machine is empty (Take menu disappears)
	clickAll("This.png", 1);
	lsSleep(100);
end

function clickAll(image_name)
	-- Find buttons and click them!
	srReadScreen();
	xyWindowSize = srGetWindowSize();
	local buttons = findAllImages(image_name);
	
	if #buttons == 0 then
		-- statusScreen("Could not find specified buttons...");
		-- lsSleep(1500);
	else
		-- statusScreen("Clicking " .. #buttons .. "button(s)...");
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
		-- statusScreen("Done clicking (" .. #buttons .. " clicks).");
		-- lsSleep(100);
	end
end
