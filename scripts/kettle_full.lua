-- kettle_full v1.1 by Bardoth. Revised by Tallow
--
-- Automatically runs many kettles, stoking as necessary.
--

assert(loadfile("luaScripts/common.inc"))();

askText = singleLine([[
  Kettles v1.1 (by Bardoth, revised by Tallow) --
  Automatically runs many kettles, stoking as necessary. Make sure the
  VT window is in the TOP-RIGHT corner of the screen.
]])

wmText = "Tap control on kettles to open and pin.";

actions = {
  {
    label = "Potash",
    buttonPos = makePoint(30, 10);
    stoked = true,
    menuImage = "Kettle_Potash.png",
    output = 5,
    matLabels = {"Ash", "Water", "Wood"},
    matCounts = {5, 25, 28}
  },
  {
    label = "Flower Fert",
    buttonPos = makePoint(30, 40);
    stoked = false,
    menuImage = "Kettle_Flower_Fert.png",
    output = 50,
    matLabels = {"Rotten Fish", "Water", "Wood"},
    matCounts = {3, 5, 5}
  },
  {
    label = "Grain Fert",
    buttonPos = makePoint(30, 70);
    stoked = false,
    menuImage = "Kettle_Grain_Fert.png",
    output = 50,
    matLabels = {"Rotten Fish", "Dung", "Water", "Wood"},
    matCounts = {1, 1, 5, 5}
  },
  {
    label = "Weed Killer",
    buttonPos = makePoint(30, 100);
    stoked = false,
    menuImage = "Kettle_Weed_Killer.png",
    output = 50,
    matLabels = {"Toad Skin Mushrooms", "Water", "Wood"},
    matCounts = {1, 5, 5}
  },
  {
    label = "Sulfur",
    buttonPos = makePoint(30, 130);
    stoked = true,
    menuImage = "Kettle_Sulfur.png",
    output = 25,
    matLabels = {"Sulphurous Water", "Wood"},
    matCounts = {25, 28}
  },
  {
    label = "Salt",
    buttonPos = makePoint(30, 160);
    stoked = true,
    menuImage = "Kettle_Salt.png",
    output = 3,
    matLabels = {"Coconut Water", "Wood"},
    matCounts = {25, 28}
  },
  {
    label = "Acid",
    buttonPos = makePoint(30, 190);
    stoked = true,
    menuImage = "Kettle_Acid.png",
    output = 3,
    matLabels = {"Sulphurous Water", "Salt", "Wood"},
    matCounts = {25, 1, 28}
  },
  {
    label = "Arsenic",
    buttonPos = makePoint(30, 220);
    stoked = false,
    menuImage = "Kettle_Arsenic.png",
    output = 8,
    matLabels = {"Razor's Edge Mushrooms", "Scorpion's Brood Mushrooms",
                 "Oil", "Wood"},
    matCounts = {1, 1, 5, 5}
  },
  {
    label = "Geb's Tears",
    buttonPos = makePoint(30, 250);
    stoked = false,
    menuImage = "Kettle_Gebs_Tears.png",
    output = 1,
    matLabels = {"Flower Bulbs", "Water", "Wood"},
    matCounts = {30, 20, 20}
  }
};

function runKettles(num_loops, action)
  for i=1, num_loops do
    drawWater();
    refreshAll();

    clickAllImages(action.menuImage);
    lsSleep(200);

    clickAllImages("Kettle_Begin.png");
    lsSleep(200);

    local message = "(" .. i .. "/" .. num_loops .. ") Making "
      .. action.label;

    waitForKettles(message, action.stoked);

    clickAllImages("kettle_take.png");
    lsSleep(200);
  end
end

function refreshAll()
  clickAllImages("ThisIs.png");
  lsSleep(200);
end

function waitForKettles(message, stoked)
  local done = false;
  while not done do
    if stoked then
      igniteAll();
    end
    srReadScreen();
    local anchors = findAllImages("ThisIs.png");
    done = true;
    for i=1,#anchors do
      if not stokeWindow(anchors[i], stoked) then
	done = false;
      end
    end
    sleepWithStatus(5000, message);
  end
end

function igniteAll()
  srReadScreen();
  local ignite = findAllImages("Ignite.png");
  for i=1,#ignite do
    srClickMouseNoMove(ignite[i][0] + 5, ignite[i][1] + 5);
    local maxButton = waitForImage("Kettle_Max.png", 500,
				   "Waiting for Max button");
    if maxButton then
      safeClick(maxButton[0], maxButton[1])
    else
      error("Timed out waiting for max button.");
    end
    lsSleep(50);
  end
  if #ignite > 0 then
    refreshAll();
  end
end

function stokeWindow(anchor, stoked)
  local done = true;
  local bounds = srGetWindowBorders(anchor[0], anchor[1]);
  local takePos = findImageInWindow("kettle_take.png", anchor[0], anchor[1],
				    bounds);
  if not takePos then
    done = false;
    if stoked then
      local wood = nil;
      local water = nil;
      local woodPos = findImageInWindow("Kettle_wood.png", anchor[0], anchor[1],
					bounds);
      if woodPos then
	wood = ocrNumber(woodPos[0] + 34, woodPos[1], SMALL_SET);
      end
      local waterPos = findImageInWindow("Kettle_water.png", anchor[0],
					 anchor[1], bounds);
      if waterPos then
	water = ocrNumber(waterPos[0] + 34, waterPos[1], SMALL_SET);
      end
      if wood and water
	and ((wood < 2 and water > 6)
	     or (water <= 6 and wood < water - 1))
      then
	local stoke = findImageInWindow("StokeMax.png", anchor[0], anchor[1],
					bounds);
	if stoke then
	  safeClick(stoke[0] + 5, stoke[1] + 5);
	end
      elseif not woodPos and not waterPos then
	done = true;
      end
    end
  end
  return done;
end

function doit()
  askForWindow(askText);
  windowManager("Kettle Setup", wmText, false, true);
  askForFocus();
  unpinOnExit(menuKettles);
end

function menuKettles()
  -- Ask for which button
  local selected = nil;
  while not selected do
    for i=1, #actions do
      if lsButtonText(actions[i].buttonPos[0], actions[i].buttonPos[1],
		      0, 250, 0x80D080ff, actions[i].label) then
	selected = actions[i];
      end
    end
      
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
		    "End script")
    then
      selected = nil;
      break;
    end
    lsDoFrame();
    lsSleep(tick_delay);
  end

  if selected then
    srReadScreen();
    local kettles = #(findAllImages("ThisIs.png"));
    local num_loops = promptNumber("How many passes ?", 10);
    local message = "Making " .. selected.label .. " requires:\n";
    for i=1,#(selected.matLabels) do
      message = message .. "  " .. selected.matCounts[i]*num_loops*kettles
	.. " " .. selected.matLabels[i] .. "\n";
    end
    askForWindow(message);
    runKettles(num_loops, selected);
  end
end
