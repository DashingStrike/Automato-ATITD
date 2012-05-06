
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

-- Returns an array of all positions matching the given image
function findAllTextRegions()
	local xyWindowSize = srGetWindowSize();
	local y = 0;
	local buttons = {};
	local pos = srFindFirstTextRegion();
	if not pos then
		return nil;
	end
	--trim off the outside edges of the window
	while 1 do
		buttons[#buttons+1] = pos;
		pos = srFindNextTextRegion(pos[0] + 1, pos[1]);
		if not pos then
			break;
		end
	end
	local i;
	for i = 1, #buttons do
		buttons[i][0] = buttons[i][0] + 4;
		buttons[i][1] = buttons[i][1] + 1;
		buttons[i][2] = buttons[i][2] - 30;
		buttons[i][3] = buttons[i][3] - 2;
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

function findText(text)
	local regions = findAllTextRegions();
	local table;
	if regions then
		for i = 1, #regions, 1 do
			stripRegion(regions[i]);
			table = parseRegion(regions[i]);
			if table then
				for j = 1, #table, 1 do
					--Search all text within that block for the goal text
					if string.find(table[j][2], text, 1, true) ~= nil then
						return table[j];
					end
				end
			end
		end
	end
end

function stripRegion(region)
	if region then
		srStripRegion(region[0], region[1], region[2], region[3]);
	end
end

function parseRegion(region)
	if region then
		return parseText(region[0], region[1], region[2], region[3]);
	end
end

function findTextInRegion(region, text)
	if region then
		stripRegion(region);
		local table = parseRegion(region);
		local j;
		if table then
			for j = 1, #table do
				local p = findTextInParse(table, text);
				if p then
					return p;
				end
			end
		end
	end
end

function findTextInParse(parseData, text)
	if parseData then
		for i = 1, #parseData, 1 do
			if string.find(parseData[i][2], text, 1, true) then
				local t;
				t = {};
				t[0] = parseData[i][0];
				t[1] = parseData[i][1];
				t[2] = parseData[i][2];
				return t;
			end
		end
	end
	return nil;
end

function findAllRegionsWithText(text)
	local r1 = findAllTextRegions();
	local count = 0;
	local r2 = {}
	if r1 then
		local i;
		for i = 1, #r1 do
			if findTextInRegion(r1[i], text) then
				r2[count + 1] = r1[i];
				count = count + 1;
			end
		end
	end
	if count == 0 then
		return nil;
	end
	return r2;
end

function getChatText()
	local creg = srFindChatRegion();
	stripRegion(creg);
	local lreg = {};
	if creg then
		local w = creg[2];
		if creg[2] > 600 then
			creg[0] = creg[0] + 106;
			creg[2] = creg[2] - 106;
		else
			creg[0] = creg[0] + w/6 + 6;
			creg[2] = creg[2] - w/6 - 6;
		end
	else
		return nil;
	end
	local p = parseRegion(creg);
	local count = 1;
	local first = nil;
	local p2 = {};
	if p then
		--search through lines until we get to the first section that starts with a [time]
		for i = 1, #p do
			if string.match(p[i][2], "%d?h?%d+m\]") then
				if first == nil then
					count = i;
				else
					count = count + 1;
				end
				p2[count] = p[i];
				first = 1;
			else
				if first ~= nil then
					p2[count][2] = p2[count][2] .. " " .. p[i][2];
		--			p[i] = nil;
				else
					p2[count] = p[i];
					count = i + 1;
				end
			end
		end
	end
	return p2;
end

function getAllText()
	local r = findAllTextRegions();
	local p;
	if r then
		local i;
		local retText = {};
		local count = 1;
		for i = 1, #r do
			stripRegion(r[i]);
			p = parseRegion(r[i]);
			local numP;
			if p then
				for numP = 1, #p do
					retText[count] = p[numP];
					count = count + 1;
				end
			end
		end
		if count == 1 then
			return nil;
		else
			return retText;
		end
	end
end
				

function waitForText(text)
	local r;
	while r == nil do
		srReadScreen();
		r = findText(text);
		lsSleep(20);
		checkBreak();
	end
	return r;
end	

function waitForNoText(text)
	local r = {};
	while r ~= nil do
		srReadScreen();
		r = findText(text);
		lsSleep(20);
		checkBreak();
	end
end	

function waitForRegionWithText(text)
	local r;
	while r == nil do
		srReadScreen();
		r = findRegionWithText(text);
		lsSleep(20);
		checkBreak();
	end
	return r;
end

function findRegionWithText(text)
	f = findAllTextRegions();
	local i;
	if f then
		for i = 1, #f do
			if findTextInRegion(f[i], text) then
				return f[i];
			end
		end
	end
	return nil;
end

function waitForTextInRegion(region, text)
	local r;
	while r == nil do
		srReadScreen();
		r = findTextInRegion(region, text);
		lsSleep(20);
		checkBreak();
	end
	return r;
end

function parseText(x, y, w, h)
	local table = srParseTextRegion(x, y, w, h);
	if table == nil then
		return nil;
	end
	local found = (#table +1)/ 3;
	local newTable = {};
	for i = 1, found, 1 do
		newTable[i] = {};
		newTable[i][0] = table[(i-1)*3];
		newTable[i][1] = table[(i-1)*3+1];
		newTable[i][2] = table[(i-1)*3+2];
	end
	return newTable;
end

function clickText(parse)
	srClickMouseNoMove(parse[0] + 20, parse[1] + 7);
	lsSleep(per_click_delay);
end