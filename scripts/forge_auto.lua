dofile("common.inc");
dofile("serialize.inc");

-- Some notes in this macro. You may pin any variety of student casting boxes, master casting boxes, and forges. The macro will prioritize making master only stuff in master boxes, but will then make student goods in them. SELECT HOW MANY OF AN ITEM YOU WANT TO MAKE, NOT HOW MANY ROUNDS TO DO. The macro does know, for instance, that each time you click to make nails it makes 12 nails. - Skyfeather
debug = false; -- This simply prevents the popup box (that tells you what materials you need) from closing, so you can view what it needs. No materials in inventory


function pairsByKeys (t, f)
	local a = {}
	for n in pairs(t) do table.insert(a, n) end
	table.sort(a, f)
	local i = 0			-- iterator variable
	local iter = function ()	 -- iterator function
		i = i + 1
		if a[i] == nil then return nil
		else return a[i], t[a[i]]
		end
	end
	return iter
end

local scale;
forgeInfo = {};

initialText = "Forge Macro 0.9 by Skyfeather. Pin all Forges & Casting Boxes. Macro will start forges if needed. Forge & casting box windows should not overlap while cooling items.\n----------------------------\nMaterials Required:\n";

textLookup = {};
textLookup["Nails - Iron"] = "batch of Nails";
textLookup["Nails - Silver"] = "batch of Silver Nails";
textLookup["Pinch Roller"] = "Make a Pinch Roller";
textLookup["Extrusion Plate"] = "Make an Extrusion Plate";
textLookup["10 Bearings"] = "Make a set of 10 Bearings";
textLookup["60 Washers"] = "Make a set of 60 Washers";
textLookup["40 Bolts"] = "Make a set of 40 Bolts";
textLookup["12 Washers"] = "Make a set of 12 Washers";
textLookup["a bearing"] = "Make a Bearing";
textLookup["4 Bolts"] = "Make a set of 4 Bolts";

function chooseItems(itemList, multiple)
   local x, y, z;
   local numRows = 9;
   local pickedOne = false;
   scale = 1.5;
   local retList = {};
   while true do
      local currentItem = {};
      currentItem.parents = {};
      local leafNode = false;
      local curList = itemList;
      while leafNode == false do
         local parentString = "";
         local suff = "";
         for i=1, #currentItem.parents do
            parentString = parentString .. currentItem.parents[i] .. suff;
            suff = "/";
         end
         lsSetCamera(0,0,lsScreenX*scale,lsScreenY*scale);
         if parentString == "" then
            lsPrint(0, 0, z, 1, 1, 0xffffffff, "What would you like to make?");
         else
            lsPrint(0, 0, z, 1, 1, 0xffffffff, string.format("What kind of %s would you like to make?", parentString));
         end
         x = 10;
         y = 30;
         z = 0;
         local c = 0;
         for k, v in pairsByKeys(curList) do
            if c % numRows == 0 and c ~= 0 then
               x = x + 160;
               y = 30;
            end
            local suff = "";
            if v.q == nil then
               suff = "...";
            end
            local buttonColor = 0xffffffff
            if v.masterOnly then
               buttonColor = 0xffff00ff
            end
            if lsButtonText(x, y, z, 140, buttonColor, k .. suff) then
               currentItem.name = k;
               curList = curList[k];
               -- check if q exists, which means we're at the leaf.
               if curList.q ~= nil then
                  -- Special case treated metal sheeting, add in an extra parent
                  if currentItem.name == "Treated Metal" then
                     table.insert(currentItem.parents, "Make some Treated Metal Sheeting")
                  end
                  currentItem.item = curList;
                  leafNode = true;
               else
                  table.insert(currentItem.parents, currentItem.name);
               end
            end
            c = c + 1;
            y = y + 30;
         end
         x = 10;
         y = 30 + numRows *30;
         if pickedOne then
            lsPrint(x, y, z, 1, 1, 0xffffffff, "Item List:");
            y = y + 30;
            for i=1, #retList do
               local leafParentsString = "";
               for j=1, #retList[i].parents do
                  leafParentsString = leafParentsString .. retList[i].parents[j] .. "/";
               end
               local num = retList[i].num;
               if num == -1 then
                  num = "Unlimited";
               else
                  num = "" .. num;
               end
               lsPrint(x, y, z, 1, 1, 0xffffffff, string.format("%s %s%s", num, leafParentsString,
                                                                 retList[i].name));
               y = y + 30;
            end
         end
         -- Add in exit and optionally done and Back buttons.
         lsSetCamera(0,0,lsScreenX,lsScreenY);
         if #currentItem.parents ~= 0 then
            if lsButtonText(lsScreenX - 100, lsScreenY - 60, z, 90, 0xFFFFFFff, "Back") then
               local p = currentItem.parents;
               currentItem = {};
               currentItem.parents = {};
               curList = itemList;
               for i=1, #p-1 do
                  curList = curList[p[i]];
               end
               currentItem.name = p[#p];
               for i=1, #p-1 do
                  currentItem.parents[i] = p[i];
               end
            end
         end
         if lsButtonText(lsScreenX - 100, lsScreenY - 30, z, 90, 0xFFFFFFff, "Exit") then
            return nil;
         end
         if pickedOne then
            if lsButtonText(10, lsScreenY - 30, z, 90, 0xFFFFFFff, "Done") then
               return retList;
            end
         end
         lsSetCamera(0,0,lsScreenX*scale,lsScreenY*scale);
         lsDoFrame();
         lsSleep(10);
      end
      local numToMake = nil;
      local leafParentsString = "";
      for i=1, #currentItem.parents do
         leafParentsString = leafParentsString .. currentItem.parents[i] .. "/";
      end
      currentItem.num = promptNumber(string.format("How many %s%s would you like to make?", leafParentsString, currentItem.name),nil,0.66);
      if multiple then
         if currentItem.num ~= 0 then
            table.insert(retList, currentItem);
         end
      else
         return currentItem
      end
      pickedOne = true;
   end
end

local function makeItem(currentItem, window)
   local parents = currentItem[2];
   local name = currentItem[1];
   local t;
   -- Start at 2 so that it skips the Forge... and Casting... objects
   lsPrintln("Making " .. name);
   if #parents >= 2 then

     if parents[2] == "Bars x1" or parents[2] == "Bars x5" then
        t = findText("Bars" .. "...", window);
        clickText(t);
     elseif parents[2] == "Small Gear x1" or parents[2] == "Small Gear x10" then
        t = findText("Gearwork" .. "...", window);
        clickText(t);
     else
        t = findText(parents[2] .. "...", window);
     end

      lsSleep(100);
      if t == nil then
         lsPrintln("Initial window error");
         return false;
      end
      clickText(t);
      lsSleep(100);
   end

   for i=3, #parents do
      t = waitForText(parents[i] .. "...", 1000);
      if t == nil then
         lsPrintln("Secondary window error");
         return false;
      end
      clickText(t);
      lsSleep(100);
   end
   local text;
   local lastParent = parents[#parents];

   if lastParent == "Small Gear x1" then
     local t = waitForText("Small Gear");
     clickText(t);
     local t = waitForText("Make 1...");
     clickText(t);
   elseif lastParent == "Small Gear x10" then
      local t = waitForText("Small Gear");
      clickText(t);
      local t = waitForText("Make 10...");
      clickText(t);
   elseif lastParent == "Bars x5" then
      local t = waitForText("Make 5 sets");
      clickText(t);
   elseif lastParent == "Bars x1" then
      local t = waitForText("Make 1 set");
      clickText(t);
   end
      lsSleep(100);

   -- Check if we have to click down arrow button (scrollable menu)
   if (lastParent == "Bars x1" or lastParent == "Bars x5") and name > "Titanium" then
      local t = waitForText("Aluminum Bars", nil, nil, nil, REGION);
      downArrow(); -- Click the Down arrow button to scroll
   end
   if (lastParent == "Sheeting" or lastParent == "Straps" or lastParent == "Wire")  and name > "Titanium" then
      local t = waitForText("Make Aluminum", nil, nil, nil, REGION);
      downArrow(); -- Click the Down arrow button to scroll
   end

   if lastParent == "Bars x1" or lastParent == "Bars x5" then
	text = name .. " Bars";
   elseif lastParent == "Sheeting" or lastParent == "Wire" then
      text = string.format("Make %s %s", name, lastParent);
   elseif lastParent == "Pipes" or lastParent == "Foils" or lastParent == "Straps" then
      text = string.format("Make %s %s", name, string.sub(lastParent, 1, #lastParent-1));
   elseif lastParent == "Large Gear" or lastParent == "Medium Gear" or lastParent == "Small Gear" then
      text = string.format("Make %s %s", name, lastParent);
   elseif lastParent == "Steam Mechanics" then
      text = "Make a " .. name;
   elseif lastParent == "Tools" then
      if name == "Iron Poker" then
         text = "Make an " .. name;
      else
         text = "Make a " .. name;
      end
   elseif lastParent == "Make some Treated Metal Sheeting" then
      text = "From";
   else
      text = name;
   end
   if textLookup[text] ~= nil then
      text = textLookup[text];
   end

   lsPrintln(string.format("Searching for text %s", text));
   -- For top level items look in the window we're currently on
   -- otherwise, search the entire screen.

   if #parents == 1 then
      t = waitForText(text, 1000, nil, window);
   elseif lastParent == "Bars x1" or lastParent == "Bars x5" then
      srReadScreen();
      pin = srFindImage("unpinnedPin.png");
      thisRange = makeBox(pin[0]-180, pin[1], 180, 450);
      t = waitForText(text, 1000, nil, thisRange);
   else
      t = waitForText(text, 1000);
   end

   if t == nil then
      return false;
   end
   clickText(t);
   if #parents ~= 1 then
      waitForNoText(text, 1000);
   end
   -- Special case for complex items
--   if name == "Stainless Steel Pot" then
--      local win = waitForText("A stainless Steel Pot requires", 1000, nil, nil, REGION);
--      if win ~= nil then
--         t = findText("Steel:", nil, nil, CPLX_ITEM_CHOOSE);
--         if t ~= nil then
--            clickText(t);
--            waitForNoText("Steel:", 1000, nil, nil, nil, CPLX_ITEM_CHOOSE);
--            t = findText("Steel:", nil, nil, CPLX_ITEM_CHOOSE);
--            if t ~= nil then
--               lsPrintln(string.format("tl: %d, %d", win.x, win.y));
--               safeClick(win.x+93, win.y + 290);
--               waitForNoText("A stainless Steel Pot requires", 1500);
--            end
--         else
--            lsPrintln("Couldn't find Steel:");
--         end
--      end
--   end

-- Quick/dirty hack to get Stainless working on T8. Above commented section doesn't work due to how the text displays

  if name == "Stainless Steel Pot" then
  local win = waitForText("A stainless Steel Pot requires", 1000, nil, nil, REGION);

    if win ~= nil then
     t = findText("Steel");

      if t ~= nil then
       safeClick(t[0]+20,t[1]+60);
       lsSleep(per_tick);
       srReadScreen()
       ok = srFindImage("ok.png")
        if ok then
          safeClick(ok[0],ok[1]);
        end -- if ok
      end -- if t
    end -- if win
  end -- if name


   lsSleep(per_tick);
   return true;
end

function putOutWindows(text)
   t = findAllText(text .. " is lit", nil, REGION);
   for i=1, #t do
      clickText(findText("Put out", t[i]));
   end
end

boxTypes = {"Student's Forge", "Student's Casting Box", "Master's Forge", "Master's Casting Box"};

function doit()
   local t;
   success, forgeItems = deserialize("forgeItems.txt");
   if success == false then
      error("Could not read forge info");
   end
   success, castingItems = deserialize("castingItems.txt");
   if success == false then
      error("Could not read casting box info");
   end
   
   local topLevel = {};
   topLevel.Forge = forgeItems;
   topLevel.Casting = castingItems;
   desiredItems = chooseItems(topLevel, true);
   if desiredItems == nil then
      return;
   end
   -- Calculate the total amount of materials needed:
   local mats = {};
   local beeswax = 0;
   for i, v in ipairs(desiredItems) do
      lsPrintln(string.format("num = %d, prod = %d, q = %d", v.num, v.item.prod, v.item.q));
      local num = math.ceil(v.num/v.item.prod)*v.item.q;
      local metalType;
      if v.parents[1] == "Casting" then
         if v.item.beeswax == nil then
            beeswax = beeswax + num;
         else
            beeswax = beeswax + math.ceil(v.num/v.item.prod)*v.item.beeswax;
         end
      end


      if v.item.metal == nil then
         metalType = v.name
      else
         metalType = v.item.metal;
      end
      if v.num ~= -1 then
         if mats[metalType] == nil then
            mats[metalType] = num;
         else
            mats[metalType] = num + mats[metalType];
         end
      end
   end
   local printText = initialText;
   for k, v in pairsByKeys(mats) do
      local num = mats[k];
      if num == -1 then
         num = "Unlimited";
      else
         num = "" .. num;
      end
      printText = printText .. string.format("%s %s\n", num, k);
   end
   if beeswax ~= 0 then
      printText = printText .. string.format("Beeswax %d\n", beeswax);
   end
   askForWindow(printText);
   
   itemQueue = {};
   itemQueue["Student's Forge"] = {};
   itemQueue["Master's Forge"] = {};
   itemQueue["Student's Casting Box"] = {};
   itemQueue["Master's Casting Box"] = {};
   viableQueue = {}
   viableQueue["Student's Forge"] = {"Student's Forge"};
   viableQueue["Master's Forge"] = {"Master's Forge", "Student's Forge"};
   viableQueue["Student's Casting Box"] = {"Student's Casting Box"};
   viableQueue["Master's Casting Box"] = {"Master's Casting Box", "Student's Casting Box"};
   
-- Build item queues that we're going to pull from to make stuff.
-- Add them in backwards so that we can pop cheaply
   for i=#desiredItems, 1, -1 do
      local v = desiredItems[i];
      local toMake = math.ceil(v.num/v.item.prod);
      for j=1, toMake do
         if v.parents[1] == "Forge" then
            if v.item.masterOnly then
               table.insert(itemQueue["Master's Forge"], {v.name, v.parents});
            else
               table.insert(itemQueue["Student's Forge"], {v.name, v.parents});
            end
         elseif v.parents[1] == "Casting" then
            if v.item.masterOnly then
               table.insert(itemQueue["Master's Casting Box"], {v.name, v.parents});
            else
               table.insert(itemQueue["Student's Casting Box"], {v.name, v.parents});
            end
         else
            error("Invalid data type for queue");
         end
      end
   end
   
   srReadScreen();
   clickAllText("in the chamber");
   lsSleep(200);
   srReadScreen();
   local win = findAllText("in the chamber", nil, REGION);
   for i=1, #win do
      -- is it lit? if not, light it.
      t = findText("is out", win[i]);
      local ccamount;
      local u = findText("in the chamber", win[i]);
      local curCC = tonumber(string.match(u[2], "(%d+) Charcoal in the chamber."));
      if findText("Student's Forge", win[i]) then
         ccamount = 60;
      elseif findText("Master's Forge", win[i]) then
         ccamount = 250;
      elseif findText("Student's Casting Box", win[i]) then
         ccamount = 100;
      elseif findText("Master's Casting Box", win[i]) then
         ccamount = 600;
      end
      local toAdd = ccamount - curCC;
      if t and toAdd > 0 then
         clickText(findText("Fill this ", win[i]));
         waitForText("Add how much Charcoal?", nil, "Waiting for Charcoal message");
         srKeyEvent(string.format("%d\n", toAdd));
         waitForNoText("Add how much Charcoal?");
      end
   end
   clickAllText("Start fire");
   
   -- Begin infinite loop. Broken out of by finishing making all items.
   local slept = true;
   while 1 do
      local t, u;
      if slept == false then
         sleepWithStatus(6000, "Sleeping before checking forges again", nil, 0.7, 0.7);
         slept = true;
      else
         sleepWithStatus(150, "Short sleep before forges", nil, 0.7, 0.7);
         slept = false;
      end
      srReadScreen();
      -- TODO: Put out the forges when they're done.
      foundOne = false;
      for k, v in pairs(itemQueue) do
         if #v > 0 then
            foundOne = true;
         end
      end
      -- if foundOne == false then
         -- error("done making items");
      -- end
            
         -- if #itemQueue["Student's Forge"] == 0 then
            -- putOutWindows("Student's Forge");
         -- end
      -- if #masterForgeQ == 0 and #studentForgeQ == 0 then
         -- putOutWindows("Master's Forge");
      -- end
      -- if #studentCastingQ == 0 then
         -- putOutWindows("Student's Casting Box");
      -- end
      -- if #masterCastingQ == 0 and #studentCastingQ == 0 then
         -- putOutWindows("Master's Casting Box");
      -- end
      t = findText("is cooling");
      local numItemsLeft = 0;
      for k, v in pairs(itemQueue) do
         numItemsLeft = numItemsLeft + #itemQueue[k];
      end
      if t == nil and numItemsLeft == 0 then
         lsPrintln("Finished all items");
         return;
      end
      local windows = findAllText("is lit", nil, REGION);
      for i=1, #windows do
         local charcoalText = findText("in the chamber", windows[i]);
         if charcoalText then
            local cc = tonumber(string.match(charcoalText[2], "(%d+) Charcoal in the chamber"));
            if cc and cc <= 10 then
               t = findText("Fill this ", windows[i]);
               clickText(t);
               waitForText("Add how much Charcoal?", nil, "Waiting for charcoal topoff");
               srKeyEvent("10\n");
               waitForNoText("Add how much Charcoal?");
            end
         end
         t = findText("is cooling", windows[i]);
         if t == nil then
            if findText("This Master's Casting Box is lit.", windows[i]) then
               buildingType = "Master's Casting Box";
            elseif findText("This Student's Casting Box is lit.", windows[i]) then
               buildingType = "Student's Casting Box";
            elseif findText("This Master's Forge is lit.", windows[i]) then
               buildingType = "Master's Forge";
            elseif findText("This Student's Forge is lit.", windows[i]) then
               buildingType = "Student's Forge";
            end
            local currentItem, currentQueue;
            if #itemQueue[buildingType] ~= 0 then
               currentQueue = buildingType;
               currentItem = table.remove(itemQueue[currentQueue]);
            else
               if buildingType == "Master's Casting Box" and #itemQueue["Student's Casting Box"] ~= 0 then
                  currentQueue = "Student's Casting Box";
                  currentItem = table.remove(itemQueue[currentQueue]);
               elseif buildingType == "Master's Forge" and  #itemQueue["Student's Forge"] ~= 0 then
                  currentQueue = "Student's Forge";
                  currentItem = table.remove(itemQueue[currentQueue]);
               end
            end
            if currentItem ~= nil then
               local madeItem = makeItem(currentItem, windows[i]);
               if madeItem ~= true then
                  table.insert(itemQueue[currentQueue], currentItem);
               end
            end
         end
      end
      lsSleep(100);
      srReadScreen();
	if not debug then
      closeEmptyAndErrorWindows();
	end
      clickAllText("in the chamber");
      lsSleep(500);
      clickAllImages("ThisIs.png");
   end
end



function downArrow()
  srReadScreen();
  downPin = srFindImage("Fishing/Menu_DownArrow.png");
  if downPin then
  --srSetMousePos(downPin[0]+8,downPin[1]+5);
  srClickMouseNoMove(downPin[0]+8,downPin[1]+5);
  lsSleep(100);
  end
end
