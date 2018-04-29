-- thistle.lua v1.0 -- Revised by Tallow
--
-- Automatically run thistle gardens according to a recipe. Making
-- thistles with a macro is extremely complicated. Read
-- ThistleReference.txt located in your Automato folder.
--
-- To run:
--  Copy a recipe from the output of the Thistle Mode and replace the
--  instructions below.
--

instructions = {
-- You can now paste the recipe when starting up.
};

dofile("common.inc");

tick_delay = 1;

askText = singleLine([[
  Thistle v1.1 (Revised by Tallow) --
  Automatically run thistle gardens according to a recipe. Making
  thistles with a macro is extremely complicated. Read
  ThistleReference.txt located in your Automato folder.
  Make sure the VT window is in the TOP-RIGHT corner of the screen.
  Macro will always look for water icon to refill jugs.
  You can optionally pin the Water Barrel menu to refill jugs.
]]);

wmText = "Tap Control on Thistle Gardens to open and pin.";

-- Variables set by prompt.
lastSun = 0;
passCount = 1;
overlap = true;

allButtons = {"ThistleNit.png", "ThistlePot.png", "ThistleH2O.png",
	      "ThistleOxy.png", "ThistleSun.png", "ThistlePlantACrop.png"};

per_click_delay = 0;

window_locs = {};
buttons = {};
finish_up = false;

button_names = {"ThistleNit.png", "ThistlePot.png", "ThistleH2O.png",
		"ThistleOxy.png", "ThistleSun.png"};

local z = 2;

-- Initialize last_mon
local mon_w = 10;
local mon_h = 152;
local last_mon = {};
for x=1, mon_w do
  last_mon[x] = {};
  for y=1, mon_h do
    last_mon[x][y] = 0;
  end
end

first_nit = nil;

-------------------------------------------------------------------------------
-- doit()
-------------------------------------------------------------------------------

function doit()
  askForWindow(askText);
  promptThistles();
  promptRecipe();
  windowManager("Thistle Window Setup", wmText, overlap, true);
  unpinOnExit(runThistles);
end

-------------------------------------------------------------------------------
-- promptThistles()
-------------------------------------------------------------------------------

function promptThistles()
  local is_done = false;
  local count = 1;
  local night = true;
  local shade = false;
  while not is_done do
    checkBreak();
    lsPrint(10, 10, 0, 1.0, 1.0, 0xffffffff,
            "Configure Thistles");
    local y = 60;
    lsPrint(5, y, 0, 1.0, 1.0, 0xffffffff, "Passes:");
    is_done, count = lsEditBox("passes", 120, y, 0, 50, 30, 1.0, 1.0,
                               0x000000ff, 1);
    count = tonumber(count);
    if not count then
      is_done = false;
      lsPrint(10, y+18, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
      count = 1;
    end

    y = y + 48;
    overlap = lsCheckBox(10, y, 10, 0xffffffff, "Overlap Windows", overlap);
    y = y + 32;
    night = lsCheckBox(10, y, 10, 0xffffffff, "Night Recipe", night);
    y = y + 32;
    if not night then
      shade = lsCheckBox(10, y, 10, 0xffffffff, "Shaded", shade);
      y = y + 32;
    end

    if lsButtonText(10, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Next") then
        is_done = 1;
    end
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff,
                    "End script") then
      error(quit_message);
    end

    lsSleep(50);
    lsDoFrame();
  end
  passCount = count;
  if night then
    lastSun = 0;
  elseif shade then
    lastSun = 33;
  else
    lastSun = 99;
  end
end


-------------------------------------------------------------------------------
-- promptRecipe()
--
-- Won't work until VT allows pasting
-------------------------------------------------------------------------------

function promptRecipe()
  local is_done = false;
  local recipe = "";
  while not is_done do
    checkBreak();
    lsPrint(10, 10, 0, 1.0, 1.0, 0xffffffff,
            "Paste Recipe");
    local y = 30;
--    is_done, recipe = lsEditBox("recipe", 10, y, 0,
--				lsScreenX - 20, lsScreenY - 70,
--				0.5, 0.5,
--				0x000000ff, recipe);
    
    if lsButtonText(100, lsScreenY - 30, 0, 80, 0xffffffff, "Paste") then
      recipe = lsClipboardGet();
    end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff,
                    "End script") then
      error(quit_message);
    end

    local badList = false;
    --local list = csplit(singleLine(recipe), ",");
    local list = explode(",",singleLine(recipe)); 
    if list[#list] == "" then
      table.remove(list);
    end
    for i=1,#list do
      list[i] = tonumber(list[i]);
      if not list[i] then
	badList = true;
      end
    end
    if #list ~= 41*5 then
      badList = true;
    end
    if badList then
      is_done = false;
      lsPrint(140, 15, 10, 0.7, 0.7, 0xFF2020ff, "INVALID RECIPE");
    elseif lsButtonText(10, lsScreenY - 30, 0, 80, 0xFFFFFFff, "Next") then
      is_done = true;
    end
    instructions = list;
    lsPrintWrapped(10, 40, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff,
		   string.sub(recipe, 0, math.floor(string.len(recipe)/2)));
    lsPrintWrapped(100, 40, 0, lsScreenX - 20, 0.5, 0.5, 0xFFFFFFff,
		   string.sub(recipe, math.floor(string.len(recipe)/2)));

    lsSleep(50);
    lsDoFrame();
  end
end

-------------------------------------------------------------------------------
-- runThistles()
-------------------------------------------------------------------------------

function runThistles()  
  if not ( #instructions == 41*5) then
    error("Invalid instruction length");
  end

  srReadScreen();	
  window_locs = findAllImages("ThisIs.png");
  if #window_locs == 0 then
    error("Did not find any thistle gardens.");
  end

  forAllWindows(setupButtons, allButtons, "Setting up buttons");

  for loops=1, passCount do
    srReadScreen();

    for i=0, 39 do
      local message = "(" .. loops .. "/" .. passCount .. ") Tick " .. i;
      if finish_up then
	message = "(Finishing up) Tick " .. i;
      end
      local to_click = findClicks(i);
      if #to_click > 0 then
	clickAllComplex(to_click, message .. ":");
      end
      waitForMonChange(message .. " done.");
      if (i == 0) then -- first one immediately finds a change
	waitForMonChange(message .. " done.");
      end
      -- Wait a moment after image changes before doing the next tick
      sleepWithStatus(500,
		      "Waiting a moment for other beds to catch up...");
    end

    sleepWithStatus(6000, "Waiting for all beds to finish");
    forAllWindows(clickHarvest, {"Harvest.png"}, "Harvesting");
    lsSleep(500);
    
    refillWater();
    refillWaterBarrel();

    if finish_up then
      break;
    end			
  end
  lsPlaySound("Complete.wav");
end

-------------------------------------------------------------------------------
-- findClicks()
-------------------------------------------------------------------------------

function findClicks(tick)
  local result = {};
  if (tick == 0) then
    result[1] = "ThistlePlantACrop.png";
  end
  for j=0, 3 do
    for k=1, instructions[tick*5 + j + 1] do
      result[#result+1] = button_names[j+1];
    end
  end
  if not (instructions[tick*5 + 5] == lastSun) then
    lastSun = instructions[tick*5 + 5];
    result[#result+1] = button_names[5];
  end
  return result;
end

-------------------------------------------------------------------------------
-- refillWater()
-------------------------------------------------------------------------------

function refillWater()
  sleepWithStatus(200, "Refilling water...");
  srReadScreen();
  local water = srFindImage("iconWaterJugSmall.png", 1);
  if water then
    safeClick(water[0]+3, water[1]-5);
    local max = waitForMax("crem-max.png", 500, "Waiting for Max buttong");
    if max then
      safeClick(max[0]+5, max[1]+5);
    end
  end
end

function refillWaterBarrel()
	lsSleep(100);
	srReadScreen();
	FindWater = findText("Draw Water");

	if FindWater then
	statusScreen("Refilling water...");
	srClickMouseNoMove(FindWater[0]+30,FindWater[1]+5, right_click);
	lsSleep(500);


		srReadScreen();
		FindMaxButton = srFindImage("Maxbutton.png", 5000);

		if FindMaxButton then
		srClickMouseNoMove(FindMaxButton[0]+3,FindMaxButton[1]+3, right_click);
		lsSleep(500);
		end
	end
end

-------------------------------------------------------------------------------
-- waitForMonChange()
-------------------------------------------------------------------------------

function waitForMonChange(message)
  if not first_nit then
    first_nit = srFindImage("ThistleNit.png");
  end
  if not first_nit then
    error("Could not find first Nit");
  end
  mon_x = first_nit[0] - 25;
  mon_y = first_nit[1] + 13;
  
  local different = false;
  local skip_next = false;
  local done = false;
  while not done do
    local different = checkDifferent();
    while different do
      different = checkDifferent();
      done = true;
    end
    
    local skip, force = monInterface(message);
    done = done or force;
    skip_next = skip_next or skip;

    if (done and skip_next) then
      done = false;
      skip_next = false;
    end
  end
end

-------------------------------------------------------------------------------
-- checkDifferent()
-------------------------------------------------------------------------------

function checkDifferent()
  local different = false;
  lsSleep(tick_delay);
  srReadScreen();
  for x=1, mon_w do
    for y=1, mon_h do
      newvalue = srReadPixelFromBuffer(mon_x + x, mon_y + y);
      if not (newvalue == last_mon[x][y]) then
	different = true;
      end
      last_mon[x][y] = newvalue;
    end
  end
  return different;
end

-------------------------------------------------------------------------------
-- monInterface()
-------------------------------------------------------------------------------

function monInterface(message)
  local skip = false;
  local force = false;
  lsPrintWrapped(10, 5, 0, lsScreenX - 20, 1, 1, 0xFFFFFFff, message);
  lsPrintWrapped(10, 60, 0, lsScreenX - 20, 1, 1, 0xFFFFFFff,
		 "Waiting for change...");
  if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff,
		  "End script")
  then
    error(quit_message);
  end
    
  force = lsButtonText(40, lsScreenY - 60, z, 200, 0xFFFFFFff, "Force tick");
  skip = lsButtonText(40, lsScreenY - 90, z, 200, 0xFFFFFFff, "Skip tick");
  if lsButtonText(40, lsScreenY - 120, z, 200, 0xFFFFFFff, "Finish up") then
    finish_up = true;
  end

  -- display mon pixels
  for x=1, mon_w do
    for y=1, mon_h do
      local size = 2;
      lsDisplaySystemSprite(1, 10+x*size, 90+y*size, 0, size, size,
			    last_mon[x][y]);
    end
  end
  lsDoFrame();
  lsSleep(100);
  return skip, force;
end

-------------------------------------------------------------------------------
-- clickAllComplex()
-------------------------------------------------------------------------------

function clickAllComplex(image_names, message)
  if not message then
    message = "";
  end
  statusScreen(message .. " Clicking " .. #window_locs .. " button(s)...");
  forAllWindows(clickButtons, image_names, message);
end

-------------------------------------------------------------------------------
-- forAllWindows()
-------------------------------------------------------------------------------

function forAllWindows(f, image_names, message)
  local first = true;
  for i=#window_locs, 1, -1 do
    if not first and overlap then
      statusScreen(message);
      -- focus
      local spot = getWaitSpot(window_locs[i + 1][0] - 9,
			       window_locs[i + 1][1] - 8);
      safeClick(window_locs[i][0], window_locs[i][1]);
      waitForChange(spot);
    end
    f(i, image_names);
    first = false;
  end
  lsSleep(10);
  -- refocus
  if overlap then
    statusScreen(message .. " Refocusing...");
    for i=2, #window_locs do
--      local spot = getWaitSpot(window_locs[i][0] - 9,
--			       window_locs[i][1] - 8);
      safeClick(window_locs[i][0], window_locs[i][1] + 310);
      lsSleep(tick_delay);
--      waitForChange(spot);
    end
--    lsSleep(100);
    waitForPixelList(window_locs[#window_locs], makePoint(-9, -8),
		     WINDOW_COLORS, 4, message .. " Refocusing...", 2000);
  end
end

-------------------------------------------------------------------------------
-- setupButtons()
-------------------------------------------------------------------------------

function setupButtons(anchorIndex, image_names)
  local anchor = window_locs[anchorIndex];
  buttons[anchorIndex] = {};
  srReadScreen();
  for i=1, #image_names do
    local pos = srFindImageInRange(image_names[i],
				   anchor[0], anchor[1],
				   410, 312);
    if not pos then
      error ('Failed to find ' .. image_names[i]);
    end
    buttons[anchorIndex][image_names[i]] = pos;
  end
end

-------------------------------------------------------------------------------
-- clickButtons()
-------------------------------------------------------------------------------

function clickButtons(anchorIndex, image_names)
  for i=1, #image_names do
    safeClick(buttons[anchorIndex][image_names[i]][0] + 5,
	      buttons[anchorIndex][image_names[i]][1] + 5);
  end
end

-------------------------------------------------------------------------------
-- clickHarvest()
-------------------------------------------------------------------------------

function clickHarvest(anchorIndex, image_names)
  local anchor = window_locs[anchorIndex];
  for i=1, #image_names do
    lsSleep(200);
    srReadScreen();
    local pos = srFindImageInRange(image_names[i],
				   anchor[0], anchor[1],
				   410, 312);
    if not pos then
      error ('Failed to find ' .. image_names[i]);
    end
    safeClick(pos[0] + 5, pos[1] + 5);
  end
end


--------------
-- Added in an explode function (delimiter, string) to deal with broken csplit.
function explode(d,p)
   local t, ll
   t={}
   ll=0
   if(#p == 1) then
      return {p}
   end
   while true do
      l = string.find(p, d, ll, true) -- find the next d in the string
      if l ~= nil then -- if "not not" found then..
         table.insert(t, string.sub(p,ll,l-1)) -- Save it in our array.
         ll = l + 1 -- save just after where we found it for searching next time.
      else
         table.insert(t, string.sub(p,ll)) -- Save what's left in our array.
         break -- Break at end, as it should be, according to the lua manual.
      end
   end
   return t
end

