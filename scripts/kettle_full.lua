-- kettle_full v1.1 by Bardoth. Revised by Tallow
--
-- Automatically runs many kettles, stoking as necessary.
--

dofile("common.inc");

askText = singleLine([[
  Kettles v1.1 (by Bardoth, revised by Tallow) --
  Automatically runs many kettles, stoking as necessary. Make sure the
  VT window is in the TOP-RIGHT corner of the screen.
]])

wmText = "Tap Ctrl on kettles to open and pin.\nTap Alt on kettles to open, pin and stash.";

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
  startTime = lsGetTimer();
  for i=1, num_loops do
    startTimePass = lsGetTimer();
    drawWater();
    refreshAll();

    clickAllImages(action.menuImage);
    lsSleep(200);

    clickAllImages("Kettle_Begin.png");
    lsSleep(200);

    local message = "(" .. i .. "/" .. num_loops .. ") Making " .. action.label;

    waitForKettles(message, action.stoked, i, num_loops);
    clickAllImages("kettle_take.png");
    if i < num_loops then
      sleepWithStatus(5000,"Take all Kettles Completed!\n\nPausing before next Pass, in case you want to End Script", nil, 0.7, 0.7);
    end
    if finish_up then
      sleepWithStatus(5000,"Finish up initiated ...\n\nYou have completed " .. i .. "/" .. num_loops .. " passes.", nil, 0.7, 0.7);
      break;
    end
  end
end

function refreshAll()
  clickAllImages("ThisIs.png");
  lsSleep(200);
end

function waitForKettles(message, stoked, passes, num_loops)
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
    if finish_up and not finish_up_message then
      message = message .. "\n\nFinishing up, this will be last pass!";
      finish_up_message = 1;
    end
    if passes > 1 then
      sleepWithStatus(5000, message .. "\n\nPass Elapsed Time: " .. getElapsedTime(startTime) .. "\n\nTotal Elapsed Time: " .. getElapsedTime(startTimePass), nil, 0.7, 0.7);
    else
      sleepWithStatus(5000, message .. "\n\nPass Elapsed Time: " .. getElapsedTime(startTimePass), nil, 0.7, 0.7);
    end
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
    --The lag is causing the refresh to not show "stoke max". Need a bit of a pause.
    sleepWithStatus(2000, "Waiting for refresh");
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
  windowManager("Kettle Setup", wmText, false, true, 215, 288);
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
      message = message .. "\n\nNote: Jugs are refilled before each pass begins, if an available water source is available (water icon or pinned Water Barrel)\n\nTip: Did you know? If the macro breaks or you quit (before kettles are done), restarting macro will pick up where you left off at (even if kettles are idle)!";
    askForWindow(message);
    runKettles(num_loops, selected);
  end
end

-- This is copy/paste of statusScreen from /common/common_ui.inc. The reason this is duplicated here, is so the Finish Up (hard coded below) button doesn't flicker during countdown
function statusScreen(message, color, allow_break, scale)
  if not message then
    message = "";
  end
  if not color then
    color = 0xFFFFFFff;
  end
  if allow_break == nil then
    allow_break = true;
  end
  if not scale then
    scale = 0.8;
  end
  lsPrintWrapped(10, 80, 0, lsScreenX - 20, scale, scale, color, message);
  lsPrintWrapped(10, lsScreenY-100, 0, lsScreenX - 20, scale, scale, 0xffd0d0ff,
		 error_status);
  if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100,
		  0xFFFFFFff, "End script") then
    error(quit_message);
  end
  if allow_break then
    lsPrint(10, 10, 0, 0.7, 0.7, 0xB0B0B0ff,
	    "Hold Ctrl+Shift to end this script.");
    if allow_pause then
      lsPrint(10, 24, 0, 0.7, 0.7, 0xB0B0B0ff,
	      "Hold Alt+Shift to pause this script.");
    end
    if not finish_up then
	if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0xFFFFFFff, "Finish up") then
	  finish_up = 1;
      end
    end
    checkBreak();
  end
  lsSleep(tick_delay);
  lsDoFrame();
end
