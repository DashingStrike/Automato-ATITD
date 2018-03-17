-- cc-auto.lua v1.0 -- by Tallow, based on Tak's cc program, updated by Manon on 5 jan 2018
--
-- Automatically runs many charcoal hearths or ovens simultaneously.
--

dofile("cc_Assist.lua");

askText = singleLine([[
  CC Auto v1.0 (by Tallow, based on Tak's cc program, updated by Manon on 5 jan 2018) --
  Automatically runs many charcoal hearths or ovens 
  simultaneously. Make sure this window is in the TOP-RIGHT corner 
  of the screen. 
]]);

BEGIN = 1;
WOOD = 2;
WATER = 3;
CLOSE = 4;
OPEN = 5;
FULL = 6;

function ccMenu()
  local passCount = promptNumber("How many passes?", 1, 1.0);
  askForFocus();
  for i=1,passCount do
    runCommand(buttons[1]);
    lsSleep(1000);
    ccRun(i, passCount);
  end
  lsPlaySound("Complete.wav");
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

function clickButton(pos, index)
  local buttonPos = findButton(pos, index);
  if buttonPos then
    safeClick(buttonPos[0] + buttons[index].offset[0],
	      buttonPos[1] + buttons[index].offset[1]);
  end
end

function ccRun(pass, passCount)
  local ovens = findOvens();
  local vents = setupVents(ovens);
  local done = false;
  while not done do
    sleepWithStatus(2000, "(" .. pass .. " / " .. passCount .. ")\n" ..
		    "Waiting for next tick");
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

minHeat = makePoint(199, 15-0);
minHeatProgress = makePoint(152, 15-0);
minOxy = makePoint(80, 33-0);
maxOxy = makePoint(116, 33-0);
maxOxyLowHeat = makePoint(160, 33-0);
minWood = makePoint(108, 50-0);
minWater = makePoint(58, 70-0);
minWaterGreen = makePoint(96, 70-0);
maxDangerGreen = makePoint(205, 90-0);
maxDanger = makePoint(219, 90-0);
uberDanger = makePoint(228, 90-0);
progressGreen = makePoint(62, 110-0);

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
	clickButton(oven, WOOD);
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
	clickButton(oven, WATER);
	-- Splash more water if it > 90%
	if pixelMatch(oven, uberDanger, barColor, 8) then
	  clickButton(oven, WATER);
	end
      end
    end
  end
  return newVent;
end
