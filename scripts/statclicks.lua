-- statclicks v1.0 by Skyfeather
--
-- Repeatedly performs tasks based on required stat attributes. Can perform several tasks
-- at once as long as they use different attributes. Will also pluck gems from a watermine
-- and rewind the watermine if available
--

dofile("common.inc");

stirMaster = false; -- TODO: Make this an optional selection when choosing the Stir Cement option

items = {
--strength
{"", "Coconuts"},
--dex
{""},
--end
{"", "Comb Flax", "Dig Dirt", "Dig Hole", "Dig Limestone", "Stir Cement", "Excavate Blocks", "Push Pyramid", "Weave Canvas", "Weave Silk",
 "Weave Linen", "Weave Wool Cloth"},
--spd
{""},
--con
{""},
--foc
{"", "Tap Rods", "Sharpened Stick", "Tinder", "Crudely Carved Handle", "Wooden Peg", "Barrel Tap"},
--per
{""} };

local lagBound = {};
lagBound["Dig Hole"] = true;
lagBound["Survey (Uncover)"] = true;

--Set this to True if you want to take everything from flax comb/hackling rake
-- otherwise false.   Usually only true when using flax comb.
takeAllWhenCombingFlax = false;

local textLookup = {};
textLookup["Dig Hole"] = "Dig Deeper";
textLookup["Sharpened Stick"] = "Whittle a Sharpened Stick";
textLookup["Tinder"] = "Shred Wood into Tinder";
textLookup["Weave Canvas"] = "Weave Twine into Canvas";
textLookup["Coconuts"] = "Separate Coconut Meat";
textLookup["Crudely Carved Handle"] = "Whittle a Crudely Carved Handle";
textLookup["Wooden Peg"] = "Whittle a small Wooden Peg";
textLookup["Barrel Tap"] = "Whittle a Barrel Tap";
-- textLookup["Survey Area"] = "Survey Area";
-- textLookup["Survey (Uncover)"] = "Survey Area";

statNames = {"strength", "dexterity", "endurance", "constitution", "speed", "focus", "perception"};
statTimer = {};
askText = singleLine([[
   Statclicks v 1.0 by Skyfeather.

   Repeatedly performs stat-dependent tasks. Can perform several tasks at once as long as they use different attributes. Will also eat food from a kitchen grilled veggies once food is up if a kitchen is pinned. Lastly will pluck gems from a watermine and rewind the watermine if available.

   Ensure that windows of tasks you are performing are pinned and press shift.
]]);

function getClickActions()
   local scale = 1.4;
   local z = 0;
   local done = false;
   -- initializeTaskList
   tasks = {};
   for i = 1, 7 do
      tasks[i] = 1;
   end

   while not done do
      checkBreak();
      y = 10;
      lsSetCamera(0,0,lsScreenX*scale,lsScreenY*scale);
      lsPrint(5, y, z, 1.2, 1.2, 0xFFFFFFff, "Ensure that all menus are pinned!");
      y = y + 50;
      for i = 1, #statNames do
         lsPrint(5, y, z, 1, 1, 0xFFFFFFff, statNames[i]:gsub("^%l", string.upper) .. ":");
         y = y + 24;
         tasks[i] = lsDropdown(statNames[i], 5, y, 0, 200, tasks[i], items[i]);
         y = y + 32;
      end
      lsDoFrame();
      lsSleep(tick_delay);
      if lsButtonText(150, 58, z, 100, 0xFFFFFFff, "OK") then
         done = true;
      end
   end
end

function weave(clothType)
   if clothType == "Canvas" then
      srcType = "Twine";
   elseif clothType == "Linen" then
      srcType = "Thread";
   elseif clothType == "Wool" then
      srcType = "Yarn";
   elseif clothType == "Silk" then
      srcType = "Raw Silk";
   end

--   lsPrintln("Weaving " .. srcType);

   -- find our loom type
   loomReg = findText(" Loom", nil, REGION);
   if loomReg == nil then
 --    lsPrintln("Couldn't find loom");
      return;
   end
   studReg = findText("This is a Student's Loom", nil, REGION);

   if clothType == "Linen" then
      weaveText = findText("Weave Thread into Linen Cloth", loomReg);
   else
      weaveText = findText("Weave " .. srcType, loomReg);
   end
   if weaveText ~= nil then
      clickText(weaveText);
      lsSleep(per_tick);
      --Close the error window if a student's loom
      if studReg then
         lsSleep(500);
         srReadScreen();
         closeEmptyAndErrorWindows();
      end
      -- reload the loom
      loadText = findText("Load the Loom with " .. srcType, loomReg);
      if loadText ~= nil then
         clickText(loadText);
         local t = waitForText("Load how much", 2000);
         if t ~= nil then
            srCharEvent("MAX\n");
         end
         closeEmptyAndErrorWindows(); --This should just be a func to close the error region, but lazy.
      end
   end

      -- Restring student looms
   srReadScreen();
   if studReg then
--      lsPrintln("Restringing");
      srReadScreen();
      t = findText("Re-String", studReg);
      if t ~= nil then
         clickText(t);
         lsSleep(per_tick);
         srReadScreen();
         closeEmptyAndErrorWindows(); --This should just be a func to close the error region, but lazy.
         lsSleep(per_tick);
      end
   end
end

function combFlax()
   flaxReg = findText("This is a Hackling Rake", nil, REGION);
   if flaxReg == nil then
      return;
   end
   flaxText = findText("This is a Hackling Rake", flaxReg);
   clickText(flaxText);
   lsSleep(per_tick);
   srReadScreen();
   s1 = findText("Separate Rotten", flaxReg);
   s23 = findText("Continue processing", flaxReg);
   clean = findText("Clean the");
   if s1 then
      clickText(s1);
   elseif s23 then
      clickText(s23);
   elseif clean then
      if takeAllWhenCombingFlax == true then
         clickText(findText("Take...", flaxReg));
         everythingObj = waitForText("Everything", 1000);
         if everythingObj == nil then
             return;
         end
         clickText(everythingObj);
         lsSleep(150);
      end
      clickText(clean);
   else
      lsPrint(5, 0 ,10, 1, 1, "Found Stats");
      lsDoFrame();
      lsSleep(2000);
   end
end

function pyramidPush()
   local curCoords = findCoords();
   local t, u;
   if curCoords[0] > pyramidXCoord + 2 then
      t = findText("Push this block West");
      if t ~= nil then u = t end;
   elseif curCoords[0] < pyramidXCoord - 2 then
      t = findText("Push this block East");
      if t ~= nil then u = t end;
   else
      t = findText("Turn this block to face North-South");
      if t ~= nil then u = t end;
   end
   if curCoords[1] > pyramidYCoord + 2 then
      t = findText("Push this block South");
      if t ~= nil then u = t end;
   elseif curCoords[1] < pyramidYCoord - 2 then
      t = findText("Push this block North");
      if t ~= nil then u = t end;
   else
      t = findText("Turn this block to face East-West");
      if t ~= nil then u = t end;
   end
   if u ~= nil then
      clickText(u);
   end
end

function stirCement()
   t = waitForText("Stir the cement", 1000);
   if t then
      clickText(t);
   else
      clickText(findText("This is a Clinker Vat"));
      if stirMaster then
         clickText(waitForText("Take..."));
         clickText(waitForText("Everything"));
         clickText(waitForText("Load the vat with Bauxite"));
         waitForText("how much");
         srCharEvent("10\n");
         waitForNoText("how much");
         clickText(waitForText("Load the vat with Gypsum"));
         waitForText("how much");
         srCharEvent("10\n");
         waitForNoText("how much");
         clickText(waitForText("Load the vat with Clinker"));
         waitForText("how much");
         srCharEvent("800\n");
         waitForNoText("how much");
         clickText(waitForText("Load the vat with Petroleum"));
         waitForText("much fuel");
         srCharEvent("40\n");
         waitForNoText("how much");
         clickText(waitForText("Make a batch of Cement"));
      end
   end
end

local function tapRods()
   local window = findText("This is a Bore Hole", nil, REGION);
   if window == nil then
      return;
   end
   local t = findText("Tap the Bore Rod", window);
   local foundOne = false;
   if t then
      clickText(t);
      foundOne = true;
   end
   t = waitForText("Crack an outline", 300);
   if t then
      clickText(t);
      foundOne = true;
   end
   if foundOne == false then
      t = findText("Retrieve the bore", window);
      if t then
         clickText(t);
      end
   end
end

local function excavateBlocks()
   local window = findAllText("This is a Pyramid Block(Roll", nil, REGION);
   if window then
      for i=1, #window do
         unpinWindow(window[i]);
      end
      lsSleep(50);
      srReadScreen();
   end
   window = findText("This is a Tooth Limestone Bl", nil, REGION);
   if window == nil then
      return;
   end
   local t = findText("Dig around", window);
   if t then
      clickText(t);
   end
   t = waitForText("Slide a rolling rack", 300);
   if t then
      clickText(t);
      t = waitForText("This is a Pyramid Block(Roll", 300, nil, nil, REGION);
      if t then
         unpinWindow(t);
      end
   end
   return;
end

function doTasks()
   didTask = false;
   for i=1, 7 do
      curTask = items[i][tasks[i]];
      if curTask ~= "" then
         srReadScreen();
         statImg = srFindImageInRange(statNames[i] .. "_black_small.png", 0, windowSize[1]/2, windowSize[0]/3, windowSize[1]/2-1, 500);
         if statTimer[i] ~= nil then
            timeDiff = lsGetTimer() - statTimer[i];
         else
            timeDiff = 999999999;
         end
         local delay = 1400;
         if lagBound[curTask] then
            delay = 3000;
         end
         if statImg and timeDiff > delay then
            --check for special cases, like flax.
            lsPrint(10, 10, 0, 0.7, 0.7, 0xB0B0B0ff,"Working on " .. curTask);
            lsDoFrame();
            if curTask == "Comb Flax" then
               combFlax();
            elseif curTask == "Dig Dirt" then
               t = srFindImage("dirt.png", 10000);
               if t then
   --               lsPrintln("Found dirt");
                  safeClick(t[0] + 5, t[1] + 5);
               end
            elseif curTask == "Dig Limestone" then
               t = srFindImage("limestone.png", 5000);
               if t then
 --                lsPrintln("Found limestone");
                  safeClick(t[0] + 5, t[1] + 5);
               end
            elseif curTask == "Weave Canvas" then
               weave("Canvas");
            elseif curTask == "Weave Linen" then
               weave("Linen");
            elseif curTask == "Weave Wool Cloth" then
               weave("Wool");
            elseif curTask == "Weave Silk" then
               weave("Silk");
            elseif curTask == "Push Pyramid" then
               pyramidPush();
            elseif curTask == "Excavate Blocks" then
               excavateBlocks();
            elseif curTask == "Tap Rods" then
               tapRods();
            elseif curTask == "Stir Cement" then
               stirCement();
            else
--               lsPrintln("finding text: " .. textLookup[curTask]);
               clickText(findText(textLookup[curTask]));
            end
            statTimer[i] = lsGetTimer();
            didTask = true;
         end
      end
   end
   if didTask == false then
      lsPrint(10, 10, 0, 0.7, 0.7, 0xB0B0B0ff,"Waiting for task to be ready.");
      lsDoFrame();
   else
      srReadScreen();
      closeEmptyAndErrorWindows();
      lsSleep(per_tick);
   end
end

--Returns true if it can find a stat, false if it can't find any.
function checkStatsPane()
   -- try to find at least one of the various stats.
   found = false;
   srReadScreen();
   for i=1, #statNames do
      if srFindImageInRange(statNames[i] .. "_black_small.png", 0, windowSize[1]/2, windowSize[0]/3, windowSize[1]/2-1, 500) then
         return true;
      end
   end
   return false;
end

local lastClickWaterMineTime = 0;
local waterMineLastRan = 0;

function doWaterMine()
    if lsGetTimer() - waterMineLastRan < 9000 then
         return;
    end
    waterMineLastRan = lsGetTimer();
    srReadScreen();
    local thisIs = findText("This is a Water Mine");
    local w = findText("This is a Water Mine", nil, REGION);
    local curTime = getTime();
    local curCoords = findCoords();
    if thisIs == nil or w == nil then
         return;
    end
    local pitchText = findText("Pitch Angle", w);
    local pitch = tonumber(string.match(pitchText[2], "Pitch Angle is (%d+)"));
    local u = findText("Take the", w);
    if u ~= nil then
         clickText(u);
         -- Log the data
    --    logWaterMineData(string.match(u[2], "Take the (.*)"), curTime, curCoords);
    elseif lastClickWaterMineTime ~= curTime and curTime % 360 == 0 then
         t = findText("Wind the", w);
         if t then
             clickText(t);
             lastClickWaterMineTime = curTime;
         end
    else
       clickText(thisIs);
    end
end

function checkAndEat()
   if foodTimer == nil or lsGetTimer() - foodTimer > 3000 then
      srReadScreen();
      invLoc = srFindInvRegion();

      invLoc[0] = invLoc[0] + 1;
      invLoc[2] = invLoc[2] - 2;
      stripRegion(invLoc);
      inv = parseRegion(invLoc);
      if inv == nil then
         return;
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

      if onFood == false and allStatsVisible == true then
         lsPrint(10, 10, 0, 0.7, 0.7, 0xB0B0B0ff,"Eating food");
         lsDoFrame();
         parse = findText("Enjoy the food")
         if parse then
            clickText(parse)
         else
            clickText(findText("Eat some Grilled"));
         end
         foodTimer = lsGetTimer();
      end
   end
end

function doit()
   getClickActions();
   if items[3][tasks[3]] == "Push Pyramid" then
      pyramidXCoord = promptNumber("Pyramid x coordinate:");
      pyramidYCoord = promptNumber("Pyramid y coordinate:");
   end
   local mousePos = askForWindow(askText);
   windowSize = srGetWindowSize();
   done = false;
   while done == false do
      checkAndEat();
      doTasks();
      doWaterMine();
      checkBreak();
      lsSleep(80);
   end
end
