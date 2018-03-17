-- alembic.lua v1.0 -- by Tallow
--
-- Automatically maintain the temperature on an alembic at a given point.
--

dofile("common.inc");

--pot = makePoint(255, 239);
flow = makePoint(21, 326+9);
flowSmall = makePoint(31 - flow[0], 233 - flow[1]);
flowLarge = makePoint(31 - flow[0], 317 - flow[1]);
tempMinus = makePoint(86 - flow[0], 308 - flow[1]);
tempPlus = makePoint(86 - flow[0], 260 - flow[1]);

tempBar = 63 - flow[0];
tempBackgroundColor = 0xece0c1

heatSpots = {
  makePoint(tempBar, 230 - flow[1]), -- Fish
  makePoint(tempBar, 242 - flow[1]), -- Mineral
  makePoint(tempBar, 254 - flow[1]), -- Vegetable
  makePoint(tempBar, 292 - flow[1]), -- Grain
  makePoint(tempBar, 304 - flow[1]), -- Worm
  makePoint(tempBar, 318 - flow[1]), -- Wood
  makePoint(tempBar, 329 - flow[1]), -- Rock
  makePoint(0, 0) -- Off
};

heatNames = {
    "Fish",
    "Mineral",
    "Vegetable",
    "Grain",
    "Worm",
    "Wood",
    "Rock",
    "Off"
};

qualityNames = {
  "Great",
  "Good",
  "Moderate",
  "Low",
};

NO_HEAT = 8;

-- notes
-- flow = 21 - 255 + 255, 326 - 230 + 239
-- flow == 21, 326
-- pot == 255, 230

-- fish: 230
-- mineral: 242
-- vegetable: 254
-- grain: 292
-- worm: 304
-- wood: 318
-- rock: 329
-- flow-small: 31, 233
-- flow-large: 31, 317
-- temp-minus: 86, 308
-- temp-plus: 86, 260
-- temp-bar: 63

-- temp-color: 0xf57364

heat_delay = 1000;

isRising = {};
isSmall = {};

function doit()
  askForWindow("Alembic Control v1.0 by Tallow\n \nAutomatically maintain the temperature on an alembic at a given point.\n \nPress shift over ATITD window to continue.");
  alembicControl();
end

function alembicControl()
  local done = false;
  local heat = NO_HEAT;
  local quality = 2;
  local deadline = lsGetTimer();
  while not done do
    lsPrint(5, 110, 0, 1.0, 1.0, 0xd0d0d0ff, "Heat:");
    heat = lsDropdown("AlembicHeat", 90, 110, 0, 180, heat, heatNames);
    lsPrint(5, 140, 0, 1.0, 1.0, 0xd0d0d0ff, "Quality:");
    quality = lsDropdown("AlembicQuality", 90, 140, 0, 180, quality,
			 qualityNames);
    statusScreen("Alembic Control Center");

    if lsGetTimer() > deadline then
      srReadScreen();
      local anchors = findAllImages("alembic-flow.png");
      for i=1,#anchors do
	isRising[i] = maintainHeat(anchors[i], heat, isRising[i]);
	isSmall[i] = maintainQuality(anchors[i], quality, heat, isSmall[i]);
      end
      deadline = lsGetTimer() + heat_delay;
    end
  end
end

function maintainHeat(anchor, index, lastRise)
  local rise = heatShouldRise(anchor, index);
  if rise and lastRise then
    safeClick(anchor[0] + tempPlus[0],
	      anchor[1] + tempPlus[1]);
  elseif not rise and lastRise then
    safeClick(anchor[0] + tempMinus[0],
	      anchor[1] + tempMinus[1]);
  end
  return rise;
end

function heatShouldRise(anchor, index)
  local result = false;
  if index ~= NO_HEAT then
    result = pixelMatch(anchor, heatSpots[index], tempBackgroundColor, 20);
  end
  return result;
end

function maintainQuality(anchor, quality, heat, lastSmall)
  local top = makePoint(heatSpots[heat][0],
			heatSpots[heat][1] - quality - 2);
  local bottom = makePoint(heatSpots[heat][0],
			   heatSpots[heat][1] + quality + 1);
  local small = (heat == NO_HEAT
		 or not pixelMatch(anchor, top, tempBackgroundColor, 20)
		 or pixelMatch(anchor, bottom, tempBackgroundColor, 20));
  if small and not lastSmall then
    safeClick(anchor[0] + flowSmall[0],
	      anchor[1] + flowSmall[1]);
  elseif not small and lastSmall then
    safeClick(anchor[0] + flowLarge[0],
	      anchor[1] + flowLarge[1]);
  end
  return small;
end

