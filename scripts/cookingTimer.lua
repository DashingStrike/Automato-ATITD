dofile("common.inc");

local askText = singleLine([[
   "cookingTimer 1.0 by Skyfeather. This macro eats a meal and times how long it's effects last in ducktime.
   Pin a kitchen ready to be eaten from. Ensure that your stats are visible and that you're not doing any
   stat timed activities, such as combing flax."
]]);

local statNames = {"strength", "dexterity", "endurance", "speed", "constitution", "focus", "perception"};

-- TODO: Add this to common_ui.inc
function waitForCtrl(message)
   if not message then
     message = "";
   end
   local basicText = singleLine([[
       Get all systems ready, then press ctrl
   ]]);

   -- Wait for release if it's already held
   while lsControlHeld() do
     checkBreak();
   end

   -- Display message until shift is held
   while not lsControlHeld() do
     lsPrintWrapped(0, 0, 1, lsScreenX, 0.7, 0.7, 0xFFFFFFff, basicText);
     lsPrintWrapped(0, 85, 1, lsScreenX, 0.7, 0.7, 0xB0B0B0ff, message);
     lsDoFrame();
     if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100,
                     0xFFFFFFff, "Exit") then
       error(quit_message);
     end
     lsSleep(tick_delay);
     checkBreak();
   end
 end

function waitForTimeShift()
   srReadScreen();
   startTime = getTime();
   while true do
      sleepWithStatus(500, "Waiting for clock to change");
      srReadScreen();
      curTime = getTime();
      if curTime ~= startTime then
         return curTime;
      end
   end
end

function eatFood()
   foodLoc = findText("Enjoy the food");
   if foodLoc == nil then
      error("Could not find a meal to eat");
   end
   clickText(foodLoc);
end

-- Returns true/false on whether we're on food. Prompts the user for the stat
-- screen if we're not.
function checkFood()
   srReadScreen();
   invLoc = srFindInvRegion();

   invLoc[0] = invLoc[0] + 1;
   invLoc[2] = invLoc[2] - 2;
   stripRegion(invLoc);
   inv = parseRegion(invLoc);
   if inv == nil then
      lsPlaySound("Clank.wav");
      sleepWithStatus(2000, "Could not find stats");
      return checkFood();
   end
   onFood = false;
   allStatsVisible = true;
   for i=1, #statNames do
      foundStat = false;
      for j=1, #inv do
      -- Check for a stat with an unparseable number. if so, on food.
         if string.find(inv[j][2], statNames[i]:gsub("^%l", string.upper)) and
                     string.find(inv[j][2], statNames[i]:gsub("^%l", string.upper) .. "%s+%d") == nil then
             onFood = true;
         end
         if string.find(inv[j][2], statNames[i]:gsub("^%l", string.upper)) then
            foundStat = true;
         end
      end
      if foundStat == false then
         allStatsVisible = false;
      end
   end
   if allStatsVisible == false then
      lsPlaySound("Clank.wav");
      sleepWithStatus(2000, "Could not find stats");
      return checkFood();
   end
   return onFood;
end

-- Minimum timer so that we don't mistakenly think we're not on food when
-- we really haven't given it enough time to set in.
local minimumFoodTimer = 5000;

function eatAndCalculate()
   -- Wait until the next time shift to see how long the real duration is
   checkFood();
   local startTime = waitForTimeShift();
   eatFood();
   local minTimer = lsGetTimer();
   local curMin = startTime;
   -- TODO, change this to look for effects with < minTimer durations
   sleepWithStatus(minimumFoodTimer, "Waiting for food to take effect");

   if not checkFood() then
      lsPrintln("Food had no effect");
      return nil;
   end
   while true do
      sleepWithStatus(750, "Waiting for stat change");
      srReadScreen();
      if not checkFood() then
         break;
      end
      local ts = getTime();
      if ts ~= curMin then
         curMin = ts;
         minTimer = lsGetTimer();
      end
   end
   local endTimer = lsGetTimer();
   while true do
      sleepWithStatus(250, "Calculating Duckytime...");
      srReadScreen();
      local ts = getTime();
      if ts ~= curMin then
         break;
      end
   end
   local nextMinuteTimer = lsGetTimer();
   local duckSeconds = (endTimer - minTimer) / (nextMinuteTimer - minTimer) * 20;
   local finalTime = ((curMin - startTime) * 20) + duckSeconds;
   return finalTime;
end

function doit()
   askForWindow(askText);
   -- check food to make sure stats are visible before starting
   while true do
      local duration = eatAndCalculate();
      lsPlaySound("Clank.wav");
      local message = "Food had no effect";
      if duration ~= nil then
         message = string.format("Cooking Duration: %d seconds", duration);
      end
      lsPrintln(message);
      local okay = promptOkay(message);
      if okay == nil then
         return
      end
      waitForCtrl("Press ctrl when the kitchen is reset and ready to try another test");
   end
end
