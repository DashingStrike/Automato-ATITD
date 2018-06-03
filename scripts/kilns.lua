dofile("common.inc");

per_click_delay = 0;
crumbled = 0;
sleepDelay = 143000; -- 138 seconds is 2:38m, Kiln's exact timing; add extra 5 seconds in case of lag to 143000
wmText = "Tap Ctrl on Kilns to open and pin.\nTap Alt on kettles to open, pin and stash.";

function setWaitSpot(x0, y0)
	setWaitSpot_x = x0;
	setWaitSpot_y = y0;
	setWaitSpot_px = srReadPixel(x0, y0);
end

button_names = {
"Jugs",
"Clay Bricks",
"Firebricks",
"Clay Mortars",
"Window Manager"
};

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

function clickAll(image_name)
	-- Find buttons and click them!
	srReadScreen();
	xyWindowSize = srGetWindowSize();
	local buttons = findAllImages(image_name);
	
	if #buttons == 0 then
		error 'Could not find \'Kiln\' windows.'
		--statusScreen("Could not find specified buttons (" .. image_name .. ")");
		--lsSleep(1500);
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
		statusScreen("Done clicking (" .. #buttons .. " clicks).", nil, 0.7, 0.7);
		lsSleep(100);
	end
  closeOK();
  return #buttons;
end

function clickAllRight(image_name)
	-- Find windows and click them!
	srReadScreen();
	xyWindowSize = srGetWindowSize();
	local buttons = findAllImages(image_name);
	
	if #buttons == 0 then
		statusScreen("Could not find any pinned up windows...", nil, 0.7, 0.7);
		lsSleep(1500);
	else
		statusScreen("Clicking " .. #buttons .. "windows(s)...", nil, 0.7, 0.7);
		if up then
			for i=#buttons, 1, -1  do
				srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3, true);
				lsSleep(per_click_delay);
			end
		else
			for i=1, #buttons  do
				srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3, true);
				lsSleep(per_click_delay);
			end
		end
		statusScreen("Done clicking (" .. #buttons .. " windows).", nil, 0.7, 0.7);
		lsSleep(100);
	end
  closeOK();
  return #buttons;
end

function refocus()
	statusScreen("Refocusing...", nil, 0.7, 0.7);
	for i=2, #window_locs do
		setWaitSpot(window_locs[i][0], window_locs[i][1]);
		srClickMouseNoMove(window_locs[i][0] + 321, window_locs[i][1] + 74);
		waitForChange();
	end
end



function Clay_Mortar()
	num_loops = promptNumber("How many passes ?", 100);

	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

	-- refresh windows
		clickAll("This.png");
		lsSleep(200);
		-- refocus();

		checkBrokenKiln();

		clickAll("wet_clay_morters.png");
		lsSleep(200);
		-- refocus();
		
		clickAll("wood.png");
		lsSleep(200);
		-- refocus();
		
		clickAll("fire.png");
		lsSleep(200);
		-- refocus();
		
		closeOK();
		waitOnKilns(i);

		clickAll("Take.png");
		lsSleep(200);
		-- refocus();
		
		clickAll("Everything.png");
		lsSleep(200);
		-- refocus();
		
		-- refresh windows, one last time so we know for sure the machine is empty (Take menu disappears)
		clickAll("This.png");
		lsSleep(200);
		-- refocus();

		if abort then
		  error('Error: Detected popup box, not continuing remaining passes\nDid you run out of wood or materials?');
		end
		if finish_up then
		  error('Finished Up!');
		end


	end
end

function Jugs()
	num_loops = promptNumber("How many passes ?", 100);
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

	-- refresh windows
		clickAll("This.png");
		lsSleep(200);
		-- refocus();

		checkBrokenKiln();

		clickAll("wet_jugs.png");
		lsSleep(200);
		-- refocus();

		clickAll("wood.png");
		lsSleep(200);
		-- refocus();
		
		clickAll("fire.png");
		lsSleep(200);
		-- refocus();

		closeOK();
		waitOnKilns(i);

		clickAll("Take.png");
		lsSleep(200);
		-- refocus();
		
		clickAll("Everything.png");
		lsSleep(200);
		-- refocus();
		
		-- refresh windows, one last time so we know for sure the machine is empty (Take menu disappears)
		clickAll("This.png");
		lsSleep(200);
		-- refocus();

		if abort then
		  error('WARNING: Detected popup box, not continuing remaining passes\nDid you run out of wood or materials?');
		end
		if finish_up then
		  error('Finished Up!');
		end

	end
end

function Clay_Bricks()
	num_loops = promptNumber("How many passes ?", 100);
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

	-- refresh windows
		clickAll("This.png");
		lsSleep(200);
		-- refocus();

		checkBrokenKiln();

		clickAll("wet_clay_bricks.png");
		lsSleep(200);
		-- refocus();
		
		clickAll("wood.png");
		lsSleep(200);
		-- refocus();
		
		clickAll("fire.png");
		lsSleep(200);
		-- refocus();
		
		closeOK();
		waitOnKilns(i);

		clickAll("Take.png");
		lsSleep(200);
		-- refocus();
		
		clickAll("Everything.png");
		lsSleep(200);
		-- refocus();
		
		-- refresh windows, one last time so we know for sure the machine is empty (Take menu disappears)
		clickAll("This.png");
		lsSleep(200);
		-- refocus();

		if abort then
		  error('Error: Detected popup box, not continuing remaining passes\nDid you run out of wood or materials?');
		end
		if finish_up then
		  error('Finished Up!');
		end

	end
end

function Firebricks()
	num_loops = promptNumber("How many passes ?", 100);
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

	-- refresh windows
		clickAll("This.png");
		lsSleep(200);
		-- refocus();

		checkBrokenKiln();

		clickAll("wet_firebricks.png");
		lsSleep(200);
		-- refocus();
		
		clickAll("wood.png");
		lsSleep(200);
		-- refocus();
		
		clickAll("fire.png");
		lsSleep(200);
		-- refocus();
		
		closeOK();
		waitOnKilns(i);

		clickAll("Take.png");
		lsSleep(200);
		-- refocus();
		
		clickAll("Everything.png");
		lsSleep(200);
		-- refocus();
		
		-- refresh windows, one last time so we know for sure the machine is empty (Take menu disappears)
		clickAll("This.png");
		lsSleep(200);
		-- refocus();

		if abort then
		  error('Error: Detected popup box, not continuing remaining passes\nDid you run out of wood or materials?');
		end
		if finish_up then
		  error('Finished Up!');
		end

	end
end

function waitOnKilns(i)
  if crumbled == 0 then
    crumbledMessage = "";
  else
    crumbledMessage = "\n\nKilns nearing Crumble (windows closed): " .. crumbled;
  end

  if abort then
    abortMessage = "\n\nError: Detected a popup box!\n\nThis suggests you ran out of wood or materials. Will Abort/Exit after this pass is finished.\n\nHowever, you may go fetch your materials now and click the 'Cancel Abort' button, to continue.";
  else
    abortMessage = "";
  end
    sleepWithStatus(sleepDelay, "[" .. i .. "/" .. num_loops .. "] Waiting for Kilns to finish" .. crumbledMessage .. abortMessage, nil, 0.7, 0.7, i);
end

function checkBrokenKiln()
	-- Checks to see if kiln is about to crumble and close them
	-- This will allow macro continue running on remaining windows
	local almostCrumbled = findAllImages("crumble.png");
	if #almostCrumbled > 0 then
	  clickAllRight("crubmle.png");
	  crumbled = crumbled + #buttons;
	end
end


function closeOK()
    lsSleep(500);
  while 1 do
    checkBreak();
    srReadScreen();
    OK = srFindImage("OK.png");
	  if OK then  
	    abort = 1;
	    srClickMouseNoMove(OK[0]+2,OK[1]+2, true);
	    lsSleep(50);
	  else
          break;
	  end
    end
end


function sleepWithStatus(delay_time, message, color, scale, i)
-- Custom sleepWithStatus that includes 'Cancel Abort' button and integer i

local waitChars = {"-", "\\", "|", "/"};
local waitFrame = 1;
local finish_up_message = "\n\nFinishing up after this pass!";

  if not color then
    color = 0xffffffff;
  end
  if not delay_time then
    error("Incorrect number of arguments for sleepWithStatus()");
  end
  if not scale then
    scale = 0.8;
  end
  local start_time = lsGetTimer();
  while delay_time > (lsGetTimer() - start_time) do
    local frame = math.floor(waitFrame/5) % #waitChars + 1;
    time_left = delay_time - (lsGetTimer() - start_time);
    local waitMessage = "Waiting ";
    if delay_time >= 1000 then
      waitMessage = waitMessage .. time_left .. " ms ";
    end
    lsPrintWrapped(10, 50, 0, lsScreenX - 20, scale, scale, 0xd0d0d0ff,
		   waitMessage .. waitChars[frame]);
    statusScreen(message, color, nil, scale);
    lsSleep(tick_delay);
    waitFrame = waitFrame + 1;

	if abort then
        if lsButtonText(10, lsScreenY - 30, z, 100, 0xFFFFFFff, "Cancel Abort") then
	    abort = nil;
	    message = "[" .. math.ceil(i) .. "/" .. num_loops .. "] Waiting for Kilns to finish" .. crumbledMessage .. "\n\nYou have cancelled the Abort.\nMacro will continue to next pass!";
        end
	end

	if not finish_up and not abort then
        if lsButtonText(lsScreenX - 110, lsScreenY - 60, z, 100, 0xFFFFFFff, "Finish Up") then
	    finish_up = 1;
	    message = "[" .. math.ceil(i) .. "/" .. num_loops .. "] Waiting for Kilns to finish" .. crumbledMessage .. finish_up_message;
        end
	end

  end
end



function doit()
	askForWindow("You need to pin all Kiln windows up.\n\nThe next screen will prompt you to choose Jugs, Clay Bricks, Firebricks, Clay Mortars.\n\nWindow Manager is also on next screen to assist in pinning/unpinning windows.");
	while 1 do
		-- Ask for which button
		local image_name = nil;
		local is_done = nil;	
		while not is_done do
			local y = nil;
			local x = nil;
			local bsize = nil;
			for i=1, #button_names do
				if button_names[i] == "Jugs" then
					x = 30;
					y = 10;
					bsize = 200;
				elseif button_names[i] == "Clay Bricks" then
					x = 30;
					y = 40;
					bsize = 200;
				elseif button_names[i] == "Firebricks" then
					x = 30;
					y = 70;
					bsize = 200;
				elseif button_names[i] == "Clay Mortars" then
					x = 30;
					y = 100;
					bsize = 200;
				elseif button_names[i] == "Window Manager" then
					x = 30;
					y = 160;
					bsize = 200;

				end

				if button_names[i] == "Window Manager" then
				  color = 0x80D080ff;
				else
				  color = 0xe5d3a2ff;
				end

				if lsButtonText(x, y, 4, 250, color, button_names[i]) then
					image_name = button_names[i];
					is_done = 1;
				end

			end

			if lsButtonText(lsScreenX - 220, lsScreenY - 30, z, 150, 0xFF0000ff, "End script") then
				error "Clicked End Script button";
			end
			lsDoFrame();
			lsSleep(10);
		end	
		
		if image_name == "Jugs" then
			Jugs();
		elseif image_name == "Clay Bricks" then
			Clay_Bricks();
		elseif image_name == "Firebricks" then
			Firebricks();
		elseif image_name == "Clay Mortars" then
			Clay_Mortar()
		elseif image_name == "Window Manager" then
			windowManager("Kiln Setup", wmText, false, false);
		end
	end
end
