--
-- To run:
--  Copy a recipe from the output of the Thistle Mode (history.txt)
--  Update expected_gardens equal to the number you have opened and pinned
--    Gardens must all have their buttons visible, can overlap as long as the
--    row with "asc" is visible regardlesss of which window was clicked last
--  Update "last sun" to be what it is now (0 if night,
--    99 if daylight and open lid, 33 if daylight and closed lid)
--

dofile("common.inc");
dofile("settings.inc");


dropdown_values = {"Night - Canopy Ignored (0)", "Day - Canopy Closed (33)", "Day - Canopy Open (99)"};
dropdown_cur_value = 1;
per_click_delay = 0;

	--local expected_gardens = 2; -- You no longer need to alter this setting. Instead you choose number in config()
	--local last_sun = 0; -- You no longer need to alter this setting. Instead, you choose this from pulldown menu in config()


instructions = {
0,0,2,0,0,
0,0,0,1,0,
0,0,0,2,0,
0,0,0,0,0,
0,0,0,1,0,
0,0,1,0,0,
0,0,0,1,0,
0,0,0,0,0,
0,0,0,1,0,
0,0,1,0,0,
0,0,0,1,0,
0,0,0,0,0,
0,0,0,1,0,
0,0,0,0,0,
0,0,2,1,0,
0,0,0,0,0,
0,0,0,1,0,
0,0,2,0,0,
0,0,1,1,0,
0,0,0,0,0,
0,0,0,1,0,
0,0,0,0,0,
0,0,0,1,0,
0,0,0,0,0,
0,0,0,1,0,
0,0,0,0,0,
0,0,0,1,0,
0,0,0,0,0,
0,0,0,1,0,
0,0,0,0,0,
0,0,0,1,0,
0,0,0,0,0,
0,0,0,1,0,
0,0,0,0,0,
0,0,0,1,0,
0,0,0,0,0,
0,0,0,1,0,
0,0,0,0,0,
0,0,0,1,0,
0,0,0,0,0,
0,0,0,0,0,
};


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
	config();
	if dropdown_cur_value == 1 then
	  last_sun = 0;
	elseif dropdown_cur_value == 2 then
	  last_sun = 33;
	elseif dropdown_cur_value == 3 then
	  last_sun = 99;
	end
	
	if not ( #instructions == 41*5) then
		error 'Invalid instruction length';
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