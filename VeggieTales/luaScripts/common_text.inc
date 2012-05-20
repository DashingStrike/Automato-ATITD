-------------------------------------------------------------------------------
-- findAllTextRegions
--
-- Finds all regions on the screen completely surrounded by 4 black lines.
-- Intentionally does not find regions where a corner is covered up.
--
-- Returns an array of region objects on success, nil if no regions are found.
-------------------------------------------------------------------------------
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

-------------------------------------------------------------------------------
-- findText(text, isExact)
--
-- Searches for the specified text in normal papyrus regions.  Intentionally
-- does not check the inventory region and chat regions.  if isExact is true,
-- then looks for the exact text specified.
--
-- text - text to search for
-- isExact (optional) - true if trying to find the exact text
--
-- Returns a parse object containing the entire line of text that the text
-- object was found within. findText("Wood (") for instance will return
-- "Wood (154)" if done on a chest with 154 wood.
-------------------------------------------------------------------------------

function findTextOld(text, isExact)
	if text == nil then
		error "No text specified to find";
	end
	local regions = findAllTextRegions();
	local table;
	if regions then
		for i = 1, #regions, 1 do
			stripRegion(regions[i]);
			table = parseRegion(regions[i]);
			if table then
				for j = 1, #table, 1 do
					if isExact and isExact == true then
						if table[j][2] == text then
							return table[j];
						end
					--Search all text within that block for the goal text
					else
						if string.find(table[j][2], text, 1, true) ~= nil then
							return table[j];
						end
					end
				end
			end
		end
	end
end

-------------------------------------------------------------------------------
-- stripRegion(region)
--
-- Strips a region of all background color.  Recommended to call only from
-- Library functions.
-- region - region to be stripped
--
-- always returns nil
-------------------------------------------------------------------------------

function stripRegion(region)
	if region then
		srStripRegion(region[0], region[1], region[2], region[3]);
	end
end

-------------------------------------------------------------------------------
-- parseRegion(region)
--
-- parses a region for text.
-- region - region to be parsed
--
-- returns an array of parse objects, one per line of text in the region
-------------------------------------------------------------------------------

function parseRegion(region)
	if region then
		return parseText(region[0], region[1], region[2], region[3]);
	end
end

-------------------------------------------------------------------------------
-- findTextInRegion(region, text, isExact)
--
-- searches for the parse object containing the desired text in the specified
-- region
-- region - region which we're searching for the text in.
-- text - text we're looking for
-- isExact (optional) - true if we want to return true only if the line contains
-- the exact text specified
--
-- returns the parse object containing the desired text.
-------------------------------------------------------------------------------
function findTextInRegion(region, text, isExact)
	if region then
		stripRegion(region);
		local table = parseRegion(region);
		local j;
		if table then
			for j = 1, #table do
				local p = findTextInParse(table, text, isExact);
				if p then
					return p;
				end
			end
		end
	end
end

-------------------------------------------------------------------------------
-- findTextInParse(parseData, text, isExact)
--
-- Honestly, this probably needs depreciation, I'm not sure when you would call
-- this instead of findText, or findTextInRegion
-------------------------------------------------------------------------------

function findTextInParse(parseData, text, isExact)
	if text == nil then
		error "No text specified to find";
	end
	if parseData then
		for i = 1, #parseData, 1 do
			if isExact and isExact == true then
				if parsedata[i][2] == text then
					local t;
					t = {};
					t[0] = parseData[i][0];
					t[1] = parseData[i][1];
					t[2] = parseData[i][2];
					return t;
				end
			else
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
	end
	return nil;
end

-------------------------------------------------------------------------------
-- findAllRegionsWithText(text, isExact)
--
-- Searches all regions on the screen for desired text.  Useful for times when
-- you want to find all of a certain type of window, but click other buttons
-- within that window, such as chemistry labs.
-- text - text we're looking for
-- isExact (optional) - true if we want to return true only if the line contains
-- the exact text specified
--
-- returns an array of region objects, all of which contained the desired text.
-------------------------------------------------------------------------------
function findAllRegionsWithText(text, isExact)
	local r1 = findAllTextRegions();
	local count = 0;
	local r2 = {}
	if r1 then
		local i;
		for i = 1, #r1 do
			if findTextInRegion(r1[i], text, isExact) then
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

-------------------------------------------------------------------------------
-- getChatText()
--
-- Reads the chat screen and finds all the text on it.
--
-- returns a list of parse objects for all the chat on the screen.  Chats that
-- span multiple lines are combined into a single parse object, delineated by
-- lines that start with [time]
-------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------
-- getAllText()
--
-- finds all the text on the screen.  May need depreciation.
--
-- returns an array of parse objects of every item on the screen.
-------------------------------------------------------------------------------

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

-------------------------------------------------------------------------------
-- findRegionWithText(text, isExact)
--
-- Searches for the desired text
-- text - text we're looking for
-- isExact (optional) - true if we want to return true only if the line contains
-- the exact text specified
--
-- returns the first region object containing the desired text
-------------------------------------------------------------------------------

function findRegionWithText(text, isExact)
	f = findAllTextRegions();
	local i;
	if f then
		for i = 1, #f do
			if findTextInRegion(f[i], text, isExact) then
				return f[i];
			end
		end
	end
	return nil;
end

-------------------------------------------------------------------------------
-- parseText (x, y, w, h)
--
-- wrapper for srParseTextRegion so that it returns data in an array of parses
-- instead of a 1-dimensional array of parses.  Call parseRegion instead of this.
--
-- returns an array of parse objects
-------------------------------------------------------------------------------

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