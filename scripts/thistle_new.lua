dofile("common.inc");
dofile("settings.inc");


dropdown_values = {"Night - Canopy Ignored (0)", "Day - Canopy Closed (33)", "Day - Canopy Open (99)"};
per_click_delay = 0;

	--local expected_gardens = 2; -- You no longer need to alter this setting. Instead you choose number in config()
	--local last_sun = 0; -- You no longer need to alter this setting. Instead, you choose this from pulldown menu in config()
	--instructions = {}; -- You no longer need to copy your recipe here. Instead you Add a Silk Farm in menu. Then add recipe to the farmName.txt that is created in Automato/Games/ATITD folder.


local window_locs = {};

function setWaitSpot(x0, y0)
	setWaitSpot_x = x0;
	setWaitSpot_y = y0;
	setWaitSpot_px = srReadPixel(x0, y0);
end

function waitForChange()
	local c=0;
	while srReadPixel(setWaitSpot_x, setWaitSpot_y) == setWaitSpot_px do
		lsSleep(1);
		c = c+1;
		if (lsShiftHeld() and lsControlHeld()) then
			error 'broke out of loop from Shift+Ctrl';
		end
	end
	-- lsPrintln('Waited ' .. c .. 'ms for pixel to change.');
end



function clickAll(image_name, up)
	-- Find buttons and click them!
	srReadScreen();
	xyWindowSize = srGetWindowSize();
	local buttons = findAllImages(image_name);
	
	if #buttons == 0 then
		statusScreen("Could not find specified buttons...");
		lsSleep(1500);
	else
		statusScreen("Clicking " .. #buttons .. "button(s)...");
		if up then
			for i=#buttons, 1, -1  do
				srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3);
				lsSleep(per_click_delay);
			end
		else
			for i=1, #buttons  do
				srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3);
				lsSleep(per_click_delay);
			end
		end
		statusScreen("Done clicking (" .. #buttons .. " clicks).");
		lsSleep(100);
	end
end



function clickAllComplex(image_names, message)
	if not message then
		message = "";
	end
	-- Find buttons and click them!
	srReadScreen();
	local dpos = {};
	for i=1, #image_names do
		local pos = srFindImageInRange(image_names[i],
			window_locs[#window_locs][0], window_locs[#window_locs][1],
			410, 312);
		if not pos then
			error ('Failed to find ' .. image_names[i]);
		end
		dpos[i] = {};
		dpos[i][0] = pos[0] - window_locs[#window_locs][0];
		dpos[i][1] = pos[1] - window_locs[#window_locs][1];
	end
	statusScreen(message .. " Clicking " .. #window_locs .. " button(s)...");
	local first = 1;
	for i=#window_locs, 1, -1 do
		if not first then
			-- focus
			setWaitSpot(window_locs[i+1][0], window_locs[i+1][1]);
			srClickMouseNoMove(window_locs[i][0], window_locs[i][1]);
			waitForChange();
		end
		-- click all buttons
		for j=1, #image_names do
			srClickMouseNoMove(window_locs[i][0] + dpos[j][0] + 5, window_locs[i][1] + dpos[j][1] + 5);
		end
		first = nil;
	end
	lsSleep(100);
	statusScreen(message .. " Refocusing...");
	-- refocus
	for i=2, #window_locs do
		setWaitSpot(window_locs[i][0], window_locs[i][1]);
		--lsPrintln(window_locs[i][0] .. "," .. window_locs[i][1] + 308);
		srClickMouseNoMove(window_locs[i][0], window_locs[i][1] + 308);
		waitForChange();
	end
	lsSleep(100);
end

button_names = {"ThistleNit.png", "ThistlePot.png", "ThistleH2O.png", "ThistleOxy.png", "ThistleSun.png"};

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

function waitForMonChange(message)
	if not first_nit then
		first_nit = srFindImage("ThistleNit.png");
	end
	if not first_nit then
		error "Could not find first Nit";
	end
	mon_x = first_nit[0] - 25;
	mon_y = first_nit[1] + 13;
		
	local different = nil;
	local skip_next = nil;
	local first_loop = 1;
	while not different do
		srReadScreen();
		for x=1, mon_w do
			for y=1, mon_h do
				newvalue = srReadPixelFromBuffer(mon_x + x, mon_y + y);
				if not (newvalue == last_mon[x][y]) then
					different = 1;
				end
				last_mon[x][y] = newvalue;
			end
		end
		if not different then
			first_loop = nil;
		end
		
		if different then
			-- Make sure the screen was done refreshing and update again
			lsSleep(60);
			srReadScreen();
			for x=1, mon_w do
				for y=1, mon_h do
					last_mon[x][y] = srReadPixelFromBuffer(mon_x + x, mon_y + y);
				end
			end
		end
		
		if (different and skip_next) then
			skip_next = nil;
			different = nil;
		end 
		
		lsPrintWrapped(10, 5, 0, lsScreenX - 20, 0.8, 0.8, 0xFFFFFFff, message);
		lsPrintWrapped(10, 60, 0, lsScreenX - 20, 0.8, 0.8, 0xFFFFFFff, "Waiting for change...");
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
			error "Clicked End Script button";
		end

		if lsButtonText(40, lsScreenY - 60, z, 200, 0xFFFFFFff, "Force tick") then
			different = 1;
		end

		if lsButtonText(40, lsScreenY - 90, z, 200, 0xFFFFFFff, "Skip tick") then
			skip_next = 1;
		end

		if finish_up then
			if lsButtonText(40, lsScreenY - 120, z, 200, 0x40ff40ff, "Cancel Finish Up") then
				finish_up = nil;
			end

		else

			if lsButtonText(40, lsScreenY - 120, z, 200, 0xFFFFFFff, "Finish up") then
				finish_up = 1;
			end
		
		end

		-- display mon pixels
		for x=1, mon_w do
			for y=1, mon_h do
				local size = 2;
				lsDisplaySystemSprite(1, 10+x*size, 90+y*size, 0, size, size, last_mon[x][y]);
			end
		end
		lsDoFrame();
		lsSleep(100);
	end
	statusScreen("Changed, waiting a moment for other beds to catch up...");
	if not first_loop then -- Don't wait, we might be behind already!
		lsSleep(1500); -- Wait a moment after image changes before doing the next tick
	end
end

function test()

	local loop=0;
	while 1 do
		waitForMonChange("tick " .. loop);
		
		statusScreen('Changed!');
		lsSleep(1000);
		loop = loop + 1;
	end

	error 'done';
end


function doit()
	askForWindow("Pin any number of thistle gardens, edit thistle_new with recipe. Note the windows must be pinned  CASCADED. Use included Window Manager and choose \'Form Cascade\' to arrange the windows correctly. Check \'Water Gap\' so that water icon isn\'t covered. Optionally, you can pin a rain barrel (water gap not required) to refill your jugs. Water is refilled after each tick, so you only need same amount of jugs as gardens.\n\nCan handle up to about 32 gardens by using the cascade method (shuffles windows back and forth). Use thistle_custom.lua if you are only running a few gardens.");

	windowManager("Thistle Garden Setup", nil, true, true);
	thistleConfig();
	if dropdown_cur_value == 1 then
	  last_sun = 0;
	elseif dropdown_cur_value == 2 then
	  last_sun = 33;
	elseif dropdown_cur_value == 3 then
	  last_sun = 99;
	end
	
	if not ( #instructions == 41*5) then
		error("Invalid instruction length: " .. loadedFile .. "\nDid you add a valid recipe to the file?");
	end
	unpinOnExit(main);
end


function main()

	drawWater(1);

	srReadScreen();	
	window_locs = findAllImages("ThisIs.png");
	rainBarrel = findText("Rain Barrel");

	-- Pinning a rain barrel will cause an error to expected_gardens (since it looks for 'This is'). Add 1 to expected_gardens if Rain Barrel menu found.
	if rainBarrel then
	  expected_gardens = expected_gardens + 1;
	end

	if not (#window_locs == expected_gardens) then
		error ("Did not find expected number of thistle gardens (found " .. #window_locs .. " expected " ..  expected_gardens .. ")");
	end
	
--	wl2 = {};
--	wl2[1] = window_locs[31];
--	wl2[2] = window_locs[32];
--	window_locs = wl2;
--	if not (#window_locs == 2) then
--		error 'fail';
--	end
	
	
	-- test();
	
	for loops=1, num_loops do
		
		-- clickAll("ThisIs.png", 1);
		-- lsSleep(100);
		
		srReadScreen();
		
		-- clickAllComplex({"Harvest.png"}, 1);
		-- error 'done';


		-- clickAllComplex({"ThistleAbort.png"}, 1);
		-- error 'done';


		-- statusScreen("(" .. loops .. "/" .. num_loops .. ") Doing initial 2s wait...");
		-- lsSleep(2000);
		--waitForMonChange("Getting initial image...");
		for i=0, 39 do
			drawWater(1);

			local to_click = {};
			if (i == 0) then
				to_click[1] = "ThistlePlantACrop.png";
			end
			for j=0, 3 do
				for k=1, instructions[i*5 + j + 1] do
					to_click[#to_click+1] = button_names[j+1];
				end
			end
			if not (instructions[i*5 + 5] == last_sun) then
				last_sun = instructions[i*5 + 5];
				to_click[#to_click+1] = button_names[5];
			end
			if #to_click > 0 then
				clickAllComplex(to_click, ("(" .. loops .. "/" .. num_loops .. ") " .. i .. ":"));
			end
			waitForMonChange("(" .. loops .. "/" .. num_loops .. ") Tick " .. i .. "/40 done");
			if (i == 0) then -- first one immediately finds a change
				waitForMonChange("(" .. loops .. "/" .. num_loops .. ") Tick " .. i .. "/40 done");
			end
			if finish_up then
				num_loops = loops;
			end			
		end

		lsSleep(3000);
		clickAllComplex({"Harvest.png"});
		lsSleep(500);
		
		drawWater(1);
		
		if finish_up then
			break;
		end
	end
	lsPlaySound("Complete.wav");
end


function config()
  local is_done = false;
  local count = 1;
  while not is_done do
    checkBreak();
    local y = 10;
    lsPrint(12, y, 0, 0.7, 0.7, 0xffffffff,
            "Last Sun (Current Canopy Postion):");
    y = y + 35;
    lsSetCamera(0,0,lsScreenX*1.3,lsScreenY*1.3);
	dropdown_cur_value = readSetting("dropdown_cur_value",dropdown_cur_value);
    dropdown_cur_value = lsDropdown("ArrangerDropDown", 15, y, 0, 320, dropdown_cur_value, dropdown_values);
	writeSetting("dropdown_cur_value",dropdown_cur_value);
    lsSetCamera(0,0,lsScreenX*1.0,lsScreenY*1.0);
    y = y + 50;
    lsPrint(15, y+5, 0, 0.8, 0.8, 0xffffffff, "How many passes?");
    is_done, num_loops = lsEditBox("num_loops", 190, y, 0, 50, 30, 1.0, 1.0,
                                     0x000000ff, 1);
     num_loops = tonumber(num_loops);
       if not num_loops then
         is_done = false;
         lsPrint(10, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
         num_loops = 1;
       end
    y = y + 35;
    lsPrint(15, y+5, 0, 0.8, 0.8, 0xffffffff, "How many gardens?");
    is_done, expected_gardens = lsEditBox("expected_gardens", 190, y, 0, 50, 30, 1.0, 1.0,
                                     0x000000ff, 2);
     expected_gardens = tonumber(expected_gardens);
       if not expected_gardens then
         is_done = false;
         lsPrint(10, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
         expected_gardens = 2;
       end


    if lsButtonText(10, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Start") then
        is_done = 1;
    end


    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff,
                    "End script") then
      error(quitMessage);
    end
  lsDoFrame();
  lsSleep(50);
  end
end


function thistleConfig()
  local add;
  local y = 0;
  local z = 0;
  message = "";

  while not is_done do
  checkBreak();


  if not add then
	if lsButtonText(lsScreenX/2 - 60, 10, 0, 140, 0xffffffff, "Add Silk Farm") then
	  add = 1;
	end

  else
	if lsButtonText(10, y+70, 0, 100, 0xffffffff, "Cancel") then
	  add = nil;
	end

	if string.len(farmName) > 0 then
	  if lsButtonText(140, y+70, 0, 100, 0xffffffff, "Save") then
	    addSilkFarm();
	    add = nil;
	  end
	end
  end

  if add then
	lsPrint(10, y+10, 0, 0.8, 0.8, 0xffffffff, "Silk Farm Name:");
	is_done, farmName = lsEditBox("farmName", 10, y+30, 0, 230, 30, 0.8, 0.8, 0x000000ff);
  end

  lsPrintWrapped(10, y+210, z, lsScreenX - 20, 0.7, 0.7, 0xffff40ff, message); 

  parseSilkFarm();

  if #farms > 0 then
    dropdown_cur_value = readSetting("dropdown_cur_value",dropdown_cur_value);
    dropdown_cur_value = lsDropdown("ArrangerDropDown", 15, y+130, 0, lsScreenX - 50, dropdown_cur_value, farms);
    writeSetting("dropdown_cur_value",dropdown_cur_value);

	  if lsButtonText(15, y+165, 0, 100, 0xffffffff, "Delete") then
	    deleteSilkFarms(dropdown_cur_value);
	  end

	  if lsButtonText(lsScreenX - 135, y+165, 0, 100, 0xffffffff, "Load") then
	    loadSilkFarms(farms[dropdown_cur_value]);
	    config();
	    break;
	  end
  end

  if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
    error "Clicked End Script button";
  end

  lsDoFrame();
  lsSleep(20);
  end -- end while
end


-----------------------------------------------------------------
-- parse, load, add, delete functions
-----------------------------------------------------------------

function parseSilkFarm()
  farms = {};
  local file = io.open("SilkFarms.txt", "a+");
  io.close(file);
  for line in io.lines("SilkFarms.txt") do
    farms[#farms + 1] = line
  end
  return farms;
end


function loadSilkFarms(value)
  value = string.gsub(value, "%s+", "_");
  value = "SilkFarm_" .. value .. ".txt";
  dofile(value);
  loadedFile = value;
end


function addSilkFarm()
  fileName = string.gsub(farmName, "%s+", "_");
  local file = io.open("SilkFarms.txt", "a+");
  file:write(farmName .. "\n")
  io.close(file);
  file = io.open("SilkFarm_" .. fileName .. ".txt", "w+");
  file:write("instructions = {\n\n};")
  io.close(file);
  message = "Folder: Automato/Games/ATITD/\nAdded: \"" .. string.upper(farmName) .. "\" to SilkFarms.txt\n\nCreated: SilkFarm_" .. fileName .. ".txt\nYou can add your recipe to this file.";
end


function deleteSilkFarms(num)
  local farms = {};
  local lineNumber = 0;
  local output = "";
  local file = io.open("SilkFarms.txt", "r");
  io.close(file);
  for line in io.lines("SilkFarms.txt") do
    lineNumber = lineNumber + 1;
	if num ~= lineNumber then
	  table.insert(farms, line);
	else
	  farmName = line;
	  fileName = string.gsub(farmName, "%s+", "_");
	end
  end
  for i = 1, #farms,1 do
    output = output .. farms[i] .. "\n";
  end
  file = io.open("SilkFarms.txt", "w+");
  file:write(output)
  io.close(file);
  message = "Folder: Automato/Games/ATITD/\nDeleted: \"" .. string.upper(farmName) .. "\" from SilkFarms.txt\n\nLeftover File: SilkFarm_" .. fileName .. ".txt\nYou can delete this file if you wish.";
end
