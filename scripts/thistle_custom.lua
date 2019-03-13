--
-- To run:
--  Copy a recipe from the output of the Thistle Mode
--  Update expected_gardens equal to the number you have opened and pinned
--    Gardens must all have their buttons visible, can overlap as long as the
--    row with "asc" is visible regardlesss of which window was clicked last
--  Update "last sun" to be what it is now (0 if night,
--    99 if daylight and open lid, 33 if daylight and closed lid)
--

dofile("common.inc");
dofile("settings.inc");

per_click_delay = 0;

local expected_gardens = 1;
local last_sun = 99;

instructions = {
0,0,2,1,99,
0,0,0,1,99,
0,0,0,0,99,
0,0,0,1,99,
0,0,0,1,99,
0,0,2,0,99,
0,0,0,0,33,
0,0,0,0,33,
0,0,0,0,33,
0,0,2,1,99,
0,0,0,1,99,
0,0,0,0,33,
0,0,0,0,33,
0,0,2,1,99,
0,0,0,1,99,
0,0,0,0,99,
0,0,0,2,33,
0,0,2,0,99,
0,0,1,1,99,
0,0,0,0,33,
0,0,0,1,33,
0,0,0,0,33,
0,0,0,0,33,
0,0,0,0,33,
0,0,0,1,33,
0,0,0,0,33,
0,0,1,0,33,
0,0,0,0,99,
0,0,0,0,99,
0,0,4,2,99,
0,0,1,0,33,
0,0,0,0,33,
0,0,0,1,33,
0,0,0,0,33,
0,0,0,1,99,
0,0,0,0,33,
0,0,2,0,33,
0,0,0,1,33,
0,0,0,2,33,
0,0,0,0,99,
0,0,0,0,99,
};



function clickAll(image_name, up)
	if nil then
		lsPrintln("Would click '".. image_name .. "'");
		return; -- not clicking buttons for debugging
	end
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
		
		lsPrintWrapped(10, 5, 0, lsScreenX - 20, 1, 1, 0xFFFFFFff, message);
		lsPrintWrapped(10, 60, 0, lsScreenX - 20, 1, 1, 0xFFFFFFff, "Waiting for change...");
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
			error "Clicked End Script button";
		end

		if lsButtonText(40, lsScreenY - 60, z, 200, 0xFFFFFFff, "Force tick") then
			different = 1;
		end

		if lsButtonText(40, lsScreenY - 90, z, 200, 0xFFFFFFff, "Skip tick") then
			skip_next = 1;
		end

		if lsButtonText(40, lsScreenY - 120, z, 200, 0xFFFFFFff, "Finish up") then
			finish_up = 1;
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

function config()
  local is_done = false;
  local count = 1;
  while not is_done do
    checkBreak();
    local y = 10;
    lsPrint(12, y, 0, 0.7, 0.7, 0xffffffff,
            "Garden Options:");
    y = y + 35;
    lsPrint(15, y+5, 0, 0.8, 0.8, 0xffffffff, "How many passes?");

    is_done, num_loops = lsEditBox("num_loops", 175, y+5, 0, 50, 0, 0.9, 0.9,
                                     0x000000ff, 1);
    num_loops = tonumber(num_loops);
      if not num_loops then
        is_done = false;
        lsPrint(15, y+22, 10, 0.7, 0.7, 0xFF2020ff, "MUST BE A NUMBER");
        num_loops = 1;
      end

    y = y + 45;
    if waterAllTicks then
      textColor = 0xffff80ff;
    else
      textColor = 0xffffffff;
    end

    waterAllTicks = readSetting("waterAllTicks",waterAllTicks);
    waterAllTicks = CheckBox(15, y, z, textColor, " Refill Jugs after EVERY tick?", waterAllTicks, 0.75, 0.75);
    writeSetting("waterAllTicks",waterAllTicks);

    y = y + 32;
    lsPrintWrapped(10, y, 1, lsScreenX, 0.7, 0.7, 0xFFFFFFff, "Note: Macro will always refill jugs before and after each pass.\n\nThe above checkbox isn\'t recommened but is available in case you're low on jugs or doing large batch quantities that consume lots of water.");

    if lsButtonText(lsScreenX - 110, lsScreenY - 80, 0, 100, 0xFFFFFFff, "Start") then
        is_done = 1;
        start = 1;
    end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff,
                    "End script") then
      error "Clicked End script button";
    end

   if lsButtonText(10, lsScreenY - 30, 0, 140, 0x80D080ff, "Window Manager") then
    windowManager("Thistle Garden Setup", nil, true, true, nil, nil, nil, nil, nil, nil, true);
   end

   lsDoFrame();
   lsSleep(10);
  end
end

function doit()
	askForWindow("Pin any number of thistle gardens, edit thistle_custom with recipe.\n\nWindows must be pinned in grid (use Windows Manager).\n\nMacro will attempt to refill jugs by water icon, pinned Aqueduct or Rain Barrel.");
	config();
	main();
end


function main()

	if not ( #instructions == 41*5) then
		error 'Invalid instruction length';
	end

	drawWater(1); -- in /common/common_click.inc. 1 = skipTimer (no 3s delay). Also checks aqueduct and barrel

	
	-- test();
	
	for loops=1, num_loops do
		
		clickAll("ThistleAsc.png", nil);
		lsSleep(100);
		
		srReadScreen();
		local buttons = findAllImages("ThistleNit.png");
		
		-- Sanity check
		if not (#buttons == expected_gardens) then
			error "Did not find expected number of thistle gardens";
		end
		local buttons2 = findAllImages("ThistlePlantACrop.png");
		if not (#buttons2 == #buttons) then
			error ("Some PlantACrop obscured, found " .. #buttons2 .. ", expected " .. #buttons);
		end
		for i=1, #button_names do
			local buttons2 = findAllImages(button_names[i]);
			if not (#buttons2 == #buttons) then
				error ("Some " .. button_names[i] .. " obscured, found " .. #buttons2 .. ", expected " .. #buttons);
			end
		end
		
		clickAll("ThistlePlantACrop.png", 1);
		statusScreen("(" .. loops .. "/" .. num_loops .. ") Doing initial 2s wait...");
		lsSleep(2000);
		waitForMonChange("Getting initial image...");
		for i=0, 39 do
			for j=0, 3 do
				for k=1, instructions[i*5 + j + 1] do
					clickAll(button_names[j+1], 1);
				end
			end
			if not (instructions[i*5 + 5] == last_sun) then
				last_sun = instructions[i*5 + 5];
				clickAll(button_names[5], 1);
			end
			waitForMonChange("(" .. loops .. "/" .. num_loops .. ") Tick " .. i .. " done.");
			if finish_up then
				num_loops = loops;
			end			
                        if waterAllTicks then
                          drawWater(1);
                        end
			lsSleep(1000); -- Wait a moment after image changes before doing the next tick
		end

		lsSleep(100);
		clickAll("ThistleAsc.png", nil);
		lsSleep(500);
		clickAll("Harvest.png", nil);
		lsSleep(500);
		
		drawWater(1);

		
		if finish_up then
			break;
		end
	end
	lsPlaySound("Complete.wav");
end
