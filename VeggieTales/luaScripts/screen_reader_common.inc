function checkBreak()
	if (lsShiftHeld() and lsControlHeld()) then
		error "broke out with Shift+Ctrl";
	end
end

-- optional message
function askForWindow(message)
	-- Wait for release if it's already held
	while lsShiftHeld() do end;
	-- Display message until shift is held
	while not lsShiftHeld() do
		lsPrintWrapped(0, 0, 1, lsScreenX, 0.7, 0.7, 0xFFFFFFff,
			"Mouse over the ATITD window and press Shift.  For best results, either put the ATITD window in focus first (click the ATITD window), or set Options | Interface Options | Priority to High Priority Mode.");
		if message then
			lsPrintWrapped(0, 85, 1, lsScreenX, 0.7, 0.7, 0xB0B0B0ff,
				message);
		end
		lsDoFrame();
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Exit") then
			error "Canceled";
		end
	end
	lsSetCaptureWindow();
	-- Wait for shift to be released
	while lsShiftHeld() do end;
	xyWindowSize = srGetWindowSize();
end

-- Returns an array of all positions matching the given image
function findAllImages(imgName, tol)
	if not tol then
		tol = 5000;
	end
	local xyImageSize = srImageSize(imgName);
	local xyWindowSize = srGetWindowSize();
	local y = 0;
	local buttons = {};
	while 1 do
		local pos = srFindImageInRange(imgName, 0, y, xyWindowSize[0], xyWindowSize[1]-y, tol);
		if not pos then
			break;
		end
		buttons[#buttons+1] = pos;
		local newy = pos[1] + 1;
		y = pos[1];
		-- Look for other ones on the exact same line
		while 1 do
			local x = pos[0]+1;
			pos = srFindImageInRange(imgName, x, y, xyWindowSize[0]-x, xyImageSize[1], tol);
			if not pos then
				break;
			end
			buttons[#buttons+1] = pos;
		end
		y = newy;
	end
	return buttons;
end

function findOneImage(imgName, tol)
	if not tol then
		tol = 5000;
	end
	local xyImageSize = srImageSize(imgName);
	local xyWindowSize = srGetWindowSize();
	local y = 0;
	local buttons = {};
	local pos = srFindImageInRange(imgName, 0, y, xyWindowSize[0], xyWindowSize[1]-y, tol);
	if not pos then
		return buttons;
	end
	buttons[#buttons+1] = pos;
	return buttons;
end

function parseColor(color)
	local rgb = {};
	local c = color / 256;
	rgb[0] = math.floor(c / 65536);
	c1 = c - (rgb[0] * 65536);
	if(rgb[0] < 0) then
		rgb[0] = rgb[0] + 256;
	end
	rgb[1] = math.floor(c1 / 256);
	rgb[2] = math.floor(c1 - (rgb[1] * 256));
	return rgb;
end

function compareColor(left, right)
	local leftRgb = parseColor(left);
	local rightRgb = parseColor(right);
	local max = 0;
	local i;
	for i = 0, 2 do
		-- Compare raw RGB values
		if(math.abs(leftRgb[i] - rightRgb[i]) > max) then
			max = math.abs(leftRgb[i] - rightRgb[i]);
		end
		-- Compare hue
		if(i < 2) then
			if(math.abs((leftRgb[i] - leftRgb[i+1] + 256) - (rightRgb[i] - rightRgb[i+1] + 256)) > max) then
				max = math.abs((leftRgb[i] - leftRgb[i+1] + 256) - (rightRgb[i] - rightRgb[i+1] + 256));
			end
		else
			if(math.abs((leftRgb[i] - leftRgb[0] + 256) - (rightRgb[i] - rightRgb[0] + 256)) > max) then
				max = math.abs((leftRgb[i] - leftRgb[0] + 256) - (rightRgb[i] - rightRgb[0] + 256));
			end
		end
	end
	return max;
end

