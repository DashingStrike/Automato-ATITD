-- cc-auto.lua v1.0 -- by Tallow, based on Tak's cc program
--
-- Automatically runs many charcoal hearths or ovens simultaneously.
--

assert(loadfile("luaScripts/cc_Assist.lua"))();

askText = singleLine([[
  CC Auto v1.0 (by Tallow, based on Tak's cc program) --
  Automatically runs many charcoal hearths or ovens
  simultaneously. Make sure the VT window is in the TOP-RIGHT corner
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
  askForWindow(focusMessage);
  for i=1,passCount do
    runCommand(buttons[1]);
    ccRun(i, passCount);
  end
end

function findOvens()
  local result = findAllImages("ThisIs.png");
  for i=1,#result do
    local corner = findImageInWindow("mm-corner.png",
				     result[i][0], result[i][1]);
    if not corner then
      error("Failed to find corner of cc window.");
    end
    result[i][1] = corner[1] - 102;
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

function getPixelDiffs(left, right)
  local result = {};
  for i=1,3 do
    result[i] = math.abs((left % 256) - (right % 256));
    left = math.floor(left / 256);
    right = math.floor(right / 256);
  end
  return result;
end

function pixelCheck(oven, offset, color, tolerance)
  local result = true;
  local screenColor = srReadPixel(oven[0] + offset[0], oven[1] + offset[1]);
  local diffs = getPixelDiffs(color, math.floor(screenColor/256));
  for i=1,#diffs do
    if diffs[i] > tolerance then
      result = false;
      break;
    end
  end
  return result;
end

function ccRun(pass, passCount)
  local ovens = findOvens();
  local vents = setupVents(ovens);
  local done = false;
  while not done do
    done = true;
    for i=1,#ovens do
      if not findButton(ovens[i], BEGIN) then
	vents[i] = processOven(ovens[i], vents[i]);
	done = false;
      end
    end
    sleepWithStatusPause(2000, "(" .. pass .. " / " .. passCount .. ")\n" ..
			 "Waiting for next tick");
  end
end

--px05 = 70
--px25 = 93
--px30 = 98
--px35 = 104
--px45 = 116
--px50 = 121
--px60 = 133
--px65 = 139
--px70 = 144
--px85 = 162
--px90 = 168

progressGreen = makePoint(70, 174);
maxDangerGreen = makePoint(150, 162);
minHeat = makePoint(144, 115);
minWood = makePoint(104, 139);
minOxy = makePoint(80, 126);
maxOxy = makePoint(100, 126);
maxDanger = makePoint(158, 162);
minWater = makePoint(67, 150);

greenColor = 0x07FE05;
barColor = 0x0706FD;

function processOven(oven, vent)
  local newVent = vent;
  if pixelCheck(oven, progressGreen, greenColor, 4) then
    -- Progress is green
    if pixelCheck(oven, maxDangerGreen, barColor, 4) then
      -- Danger too high
      clickButton(oven, WATER);
    elseif vent ~= 3 then
      newVent = 3;
      clickButton(oven, FULL);
    end
  else
    -- Progress is not green
    if not pixelCheck(oven, minHeat, barColor, 8) then
      -- Heat too low
      if not pixelCheck(oven, minWood, barColor, 8) then
	-- Wood too low
	clickButton(oven, WOOD);
      end
    end

    if not pixelCheck(oven, minOxy, barColor , 8) then
      -- Oxygen too low
      if vent ~= 3 then
	newVent = 3;
	clickButton(oven, FULL);
      end
    elseif pixelCheck(oven, maxOxy, barColor, 8) then
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

    if pixelCheck(oven, maxDanger, barColor, 8) then
      -- Danger > 90%
      if not pixelCheck(oven, minWater, barColor, 8) then
	-- Water < 2.6%
	clickButton(oven, WATER);
      end
    end
  end
  return newVent;
end
