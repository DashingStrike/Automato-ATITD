----------------------------------------------
-- essences.lua
-- By Skyfeather
-- Automation for creating essences
----------------------------------------------

dofile("common.inc");
dofile("serialize.inc");

-- Not a very efficient way of logging data, but we don't do it often and flush doesn't appear to work
function writeToLog(filename, logdata)
   local logFile = assert(io.open(filename, "a+"));
   logFile:write(logdata);
   logFile:close();
end

local essences;

local inProgress = {};
local subtypes = { -- Subtyped areas when clicking on the stash menu
["Herb"] = {}, 
["Salts of Metal"] = {}, 
["Powdered Gemstones"] = {},
};

alcType = {};
alcType[1] = {"Vegetable", 6};
alcType[2] = {"Mineral", 7};
alcType[3] = {"Wood", 1};
alcType[4] = {"Worm", 2};
alcType[5] = {"Grain", 3};

alcQual = {};
alcQual[1] = {"Air", 7};
alcQual[2] = {"Fire", 6};
alcQual[3] = {"Water", 5};
alcQual[4] = {"Earth", 4};
alcQual[5] = {"Grey", 3};

function stripCharacters(s)
   local badChars = "%(%)%-%,%'%d%s%:";
   s = string.gsub(s, "[" .. badChars .. "]", "");
   return s;
end


alcType = {};
alcType[1] = {"Wood", 1};
alcType[2] = {"Grain", 3};
alcType[3] = {"Vegetable", 6};
alcType[4] = {"Mineral", 7};
alcType[5] = {"Worm", 2};

function getSpirits(goal)
   local t = {};
   if goal < 10 then
      t[1] = {"Rock", 10-goal};
      if goal ~= 0 then
         t[2] = {"Wood", goal};
      end
      return t;
   end
   if goal == 89 then
      t[1] = {"Grey", 9};
      t[2] = {"Fish", 1};
      return t;
   end
   if goal > 80 then
      alcType[6] = {"Grey", 9};
   else
      alcType[6] = nil;
      
   end
   if goal > 70 and goal <= 80 then
      t[1] = {"Fish", goal-70};
      if goal ~= 80 then
         t[2] = {"Mineral", 80-goal};
      end
      return t;
   end
   --check for 1 and 2 ingredient solutions
   for k = 1, #alcType do
      for l = 1, #alcType do
         for i = 10, 5, -1 do
            j = 10 - i;
            temp = alcType[k][2] * i + alcType[l][2] * j;
            if temp == goal then
               t[1] = {alcType[k][1], i};
               if j ~= 0 then
                  t[2] = {alcType[l][1], j};
               end
               return t;
            end
         end
      end
   end
   
   --otherwise, we didn't find it, therefore 3 ingredients.
   for k = 1, #alcType do
      for l = 1, #alcType do
         for m = 1, #alcType do
            for i = 8, 5, -1 do
               j = 10 - i - 1;
               temp = alcType[k][2] * i + alcType[l][2] * j + alcType[m][2];
               if temp == goal then
                  t[1] = {alcType[k][1], i};
                  t[2] = {alcType[l][1], j};
                  t[3] = {alcType[m][1], 1};
                  return t;
               end
            end
         end
      end
   end
end

numFinished = 0;

-- too hot = too high
-- too cold = too low
-- Essences = Objects (O)
-- temp = temperature, i.e. guess

-- Child function which detects test results, evaluates guess range
-- selects Essences, manipulates owning window, and begins test.
function labTick(win)
   local temp;
   --Wait for chat notification of result
   --Search for hot, cold, or amount produced
   
   local t = findText("Manufacture...", win);
   clickText(t);
   
   t = waitForText("Essential Distillation...", 1000);
   if not t then
      return;
   end
   clickText(t);
   t = waitForText("Place Essential Material");
   clickText(t);
   
   --search for essences and select them.
   local rc = waitForText("Choose a material", nil, "Selecting material", nil, REGION);
   local parse = findAllText(nil, rc, nil, CPLX_ITEM_CHOOSE);
   local foundEss = false;
   if parse then
      for i = 1, #parse do
         curItem = stripCharacters(parse[i][2]); -- Pull out ugly characters and spaces
         --If we have no current working essence, select a new one that we still need data for
         -- Otherwise, search for essence name of our current working essence
         if essences[curItem] and essences[curItem].temp then
            clickText(parse[i]);
            waitForNoText(parse[i][2], 2000, nil, rc, nil, CPLX_ITEM_CHOOSE);
            foundEss = true;
            temp = essences[curItem].temp;
            break;
         end
      end
   end
   
   safeClick(rc.x+93, rc.y + 290);
   
   --If we couldn't find a new essence with no data, than test is complete and time to wrap up.
   if foundEss == false then
      local iter = 0;
      while closeEmptyAndErrorWindows() ~= 0 and iter < 10 do
         lsSleep(100);
         checkBreak();
         iter = iter + 1;
      end
      return;
   end
   
   local iter = 0;
   while closeEmptyAndErrorWindows() ~= 0 and iter < 10 do
      lsSleep(100);
      checkBreak();
      iter = iter + 1;
   end
   
   local spiritsNeeded = getSpirits(temp);
   
   -- For each type of alcohol (S) we need, click manufacture and add it in.
   for i = 1, #spiritsNeeded do
      --Add the alcohol
      t = waitForText("Manufacture...", nil, nil, win);
      clickText(t);
      t = waitForText("Alcohol Lamp...");
      clickText(t);
      t = waitForText("Fill Alcohol Lamp");
      clickText(t);     
      
      --click on the spirit itself
      t = waitForText(spiritsNeeded[i][1]);
      --Look for the quality of that spirit
      local q;
      local spiritType;
      for k = 1, #alcQual do
         if string.find(t[2], alcQual[k][1]) then
            q = alcQual[k][2];
         end
      end
      clickText(t);
      waitForText("How much");
      --Use text entry to enter in number.
      srCharEvent(spiritsNeeded[i][2] .. "\n");
      waitForNoText("How much");
   end

--Queue up test button until time to sleep
   waitForNoText("Checking material", nil, nil, nil, nil, INFO_POPUP);
   clickText(waitForText("Manufacture...", nil, nil, win));
   clickText(waitForText("Essential Distillation..."));
   clickText(waitForText("Start Essential"));
   waitForNoText("Start Essential");
end

-- Main Method
-- labWindows = Machines
function doit()

   -- Try to read in the Essences data file
   local success;
   success, essences = deserialize("essences.txt");
   if not success then
      error("Could not read essences file");
   end
   askForWindow("Pin all Chemistry Laboratories");
   local lastClick = -9999999;
   clickAllText("This is a Chemistry Laboratory");
   lsSleep(50);
   
   while 1 do
      -- Tick Loop
      srReadScreen();
      labWindows = findAllText("Manufacture...", nil, REGION);
      for window_index=1, #labWindows do
         labTick(labWindows[window_index]);
      end
      checkBreak();
      timeDiff = lsGetTimer() - lastClick;
      if timeDiff < 2000 then
         sleepWithStatus(2000 - timeDiff, "Updating Windows");
      end
      clickAllText("This is a Chemistry Laboratory");
      lastClick = lsGetTimer();
      lsSleep(200);
   end
end
