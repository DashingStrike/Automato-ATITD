--
-- To choose a differnet layout, add a new section below, or change a "nil" to "1"
-- 'if nil' or 'elseif nil' means ignore this layout, 'if 1' or 'elseif 1' means use this layout

--

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

local window_w = 410;
local window_h = 312;

x0 = 10;
y0 = 50;
y0_2 = 14;
y0_2_threshold = window_w * 2; -- if x > this, use y0_2 instead, set large to ignore

-- Add new sections here
if nil then
	-- setting permissions
	dx = 413+55; -- when wrapping
	dy = 205;
	little_dx = 0; -- for every window
	num_high = 5;
	y0 = 15;
	y0_2_threshold = 100000;

elseif nil then
	-- mass rock saws
	dx = 137;
	dy = 125;
	little_dx = 0;
	num_high = 8;
	window_w = 340;

elseif 1 then
	-- paper presses
	dx = 388;
	dy = 100;
	little_dx = 0;
	num_high = 8;

elseif nil then
	-- pottery wheels
	dx = 190;
	dy = 150;
	little_dx = 0;
	num_high = 7;

elseif 1 then
	-- kettles
	dx = 165;
	dy = 275;
	little_dx = 0;
	num_high = 4;

elseif nil then
	-- thistle_custom
	dx = 413; -- when wrapping
	dy = 190;
	little_dx = 0; -- for every window
	num_high = 5;
else
	-- thistle_new
	dx = 413; -- when wrapping
	dy = 24;
	little_dx = 8; -- for every window
	num_high = 33;
end

function setWaitSpot(x0, y0)
	setWaitSpot_x = x0;
	setWaitSpot_y = y0;
	setWaitSpot_px = srReadPixel(x0, y0);
end

function waitForChange(timeout)
	local c=0;
	local startTime = lsGetTimer();
	while srReadPixel(setWaitSpot_x, setWaitSpot_y) == setWaitSpot_px do
		lsSleep(1);
		c = c+1;
		if (lsShiftHeld() and lsControlHeld()) then
			error 'broke out of loop from Shift+Ctrl';
		end
		if timeout and (lsGetTimer() - startTime > timeout) then
			break;
		end
	end
	lsPrintln('Waited ' .. c .. 'ms for pixel to change.');
end

function drag(x0, y0, x1, y1)
	srSetMousePos(x0, y0);
	setWaitSpot(x1, y1);
	srMouseDown(x0, y0, 0);
	-- lsSleep(15);
	srSetMousePos(x1, y1);
	-- lsSleep(50);
	waitForChange();
	srMouseUp(x0, y0, 0);
	-- lsSleep(50);
end

function dragWaitSource(x0, y0, x1, y1)
	setWaitSpot(x0, y0);
	srMouseDown(x0, y0, 0);
	srSetMousePos(x1, y1);
	waitForChange(1500);
	srMouseUp(x0, y0, 0);
end



function refocusThistles()
	x=x0;
	y=y0;
	yy=1;
	for i=1,num_windows do
		srReadScreen();
		srClickMouseNoMove(x + 50, y + 310);
		y = y + dy;
		yy = yy + 1;
		x = x + little_dx;
		if (yy == num_high+1) then
			yy = 1;
			if (x > y0_2_threshold) then
				y = y0_2;
			else
				y = y0;
			end
			x = x + dx;
		end
		statusScreen("Focusing ..");
		lsSleep(100);
	end
	error 'done';
end


function doit()
	askForWindow("Pin any number of windows.  Will be arranged according to settings in window_arranger.lua, edit this file to choose different layouts.");
	
	xyScreenSize = srGetWindowSize();
	
	-- refocusThistles();
	
	destx = xyScreenSize[0] - window_w;
	desty = xyScreenSize[1] - window_h;
	srSetMousePos(x0, y0);
	lsSleep(200);
		
	while true do
		srReadScreen();
		local pos = srFindImageInRange("This.png", 0, 0, xyScreenSize[0] - window_w, xyScreenSize[1]);
		if not pos then
			break;
		end
		dragWaitSource(pos[0], pos[1], destx, desty);
		checkBreak();
		lsSleep(100);
	end
	
	x=x0;
	y=y0;
	yy=1;
	while true do
		srReadScreen();
		local pos = srFindImageInRange("This.png", xyScreenSize[0] - window_w - 50, xyScreenSize[1] - window_h - 50, window_w + 50, window_h + 50);
		if not pos then
			error 'Moved all windows';
		end
		drag(pos[0], pos[1], x, y);
		y = y + dy;
		yy = yy + 1;
		x = x + little_dx;
		if (yy == num_high+1) then
			yy = 1;
			if (x > y0_2_threshold) then
				y = y0_2;
			else
				y = y0;
			end
			x = x + dx;
		end
		checkBreak();
	end
end