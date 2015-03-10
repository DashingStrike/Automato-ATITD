

dofile("common.inc");
dofile("screen_reader_common.inc");



-------------------------------------------------------------------------------
-- statState(stat)
--
-- Looks for the color of a given stat
--    returns:
--        nil if the stat can't be found
--        0 if the stat is black
--        1 if the stat is maroon
--        2 if the stat is bright red
--
-- stat -- a number of the stat to check (see the constants below)
-------------------------------------------------------------------------------

ss_Strength = 1;
ss_Dexterity = 2;
ss_Endurance = 3;
ss_Speed = 4;
ss_Constitution = 5;
ss_Focus = 6;
ss_Perception = 7;

local ss_statPositions = { {nil,nil}, {nil,nil}, {nil,nil}, {nil,nil}, {nil,nil}, {nil,nil} };
local ss_statNames = { "Strength", "Dexterity", "Endurance", "Speed", "Constitution", "Focus", "Perception" };
local ss_statFontSizes = { "Tiny", "Small", "Medium", "Large", "Huge" };

function statState(stat)
	while(ss_statPositions[stat][1] == nil) do
		initializeStatState();
		if(ss_statPositions[stat][1] == nil) then
			if(not promptOkay("Unable to locate the stats.  Make sure they are visible and black.  Press OK to try again.")) then
				error("Unable to locate the stats.");
			end
		end
	end
	local color = srReadPixelFromBuffer(ss_statPositions[stat][0],ss_statPositions[stat][1]);
	local rgb = parseColor(color);
	if(rgb[0] < 75) then
		return 0;
	end
	if(rgb[0] < 200) then
		return 1;
	end
	return 2;
end

function initializeStatState()
	srReadScreen();
	local currImgName;
	local stat;
	for stat = 1, #ss_statNames do
		local pos = nil;
		local size = 1;
		while(pos == nil and size <= #ss_statFontSizes) do
			currImgName = ss_statNames[stat] .. "_black_" .. ss_statFontSizes[size] .. ".png";
			pos = srFindImage(currImgName,5000);
			size = size + 1;
		end
		if(pos) then
			local bestPos = findBestStatPosition(pos, srImageSize(currImgName));
			if(bestPos == false) then
				ss_statPositions[stat][0] = nil;
				ss_statPositions[stat][1] = nil;
			else
				ss_statPositions[stat] = bestPos;
			end
		else
			ss_statPositions[stat][0] = nil;
			ss_statPositions[stat][1] = nil;
		end
	end
end

function findBestStatPosition(startPos, size)
	local most = 0;
	local mostX = nil;
	local mostY = nil;
	local x;
	for x=startPos[0], startPos[0] + size[0] do
		checkBreak();
		local y;
		for y=startPos[1], startPos[1] + size[1] do
			local curr = 0;
			if(getGreenValue(srReadPixelFromBuffer(x, y)) == 0) then
				curr = curr + 1;
				if(x > 0) then
					if(getGreenValue(srReadPixelFromBuffer(x - 1, y)) == 0) then
						curr = curr + 1;
					end
					if(y > 0) then
						if(getGreenValue(srReadPixelFromBuffer(x - 1, y - 1)) == 0) then
							curr = curr + 1;
						end
					end
				end
				if(y > 0) then
					if(getGreenValue(srReadPixelFromBuffer(x, y)) == 0) then
						curr = curr + 1;
					end
					if(x > 0) then
						if(getGreenValue(srReadPixelFromBuffer(x - 1, y - 1)) == 0) then
							curr = curr + 1;
						end
					end
				end
			end
			if(curr == 5) then
				return makePoint(x,y);
			end
			if(curr > most) then
				most = curr;
				mostX = x;
				mostY = y;
			end
		end
	end
	if(most > 0) then
		return makePoint(mostX, mostY);
	end
	return false;
end


function getGreenValue(color)
	local rgb = parseColor(color);
	return rgb[1];
end





