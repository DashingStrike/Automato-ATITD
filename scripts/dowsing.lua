-- dowsing v1.0 by Ashen
--
-- Repeatedly dowses whenever able, keeping a log of dowse results in dowsing.txt

dofile("common.inc");

lastX = 0;
lastY = 0;

function doDowse()
	srReadScreen();
	t = srFindImageInRange("dowsingrod.png", 175, 0, 100, 125, 0);
	if t then
		safeClick(t[0] + 3, t[1] + 3);
		return true;
	end

	return false;
end

function writeDowseLog(text)
	logfile = io.open("dowsing.txt","a+");
	logfile:write(text .. "\n");
	logfile:close();
end

function checkIfMain(chatText)
	for j = 1, #chatText do
		if string.find(chatText[j][2], "^%*%*", 0) then
			return true;
		end
	end
	return false;
end

function getDowseResult()
	srReadScreen();
	local chatText = getChatText();
	local onMain = checkIfMain(chatText);

	if not onMain then
		lsPlaySound("boing.wav");
	end

	-- Wait for Main chat screen and alert user if its not showing
	while not onMain do
		checkBreak();
		srReadScreen();
		chatText = getChatText();
		onMain = checkIfMain(chatText);
		sleepWithStatus(500, "Looking for Main chat screen...\n\nMake sure main chat tab is showing and that the window is sized, wide enough, so that no lines wrap to next line.\n\nAlso if you main chat tab is minimized, you need to check Options, Interface Option, Minimized chat-channels are still visible.", nil, 0.7, 0.7);
	end

	lastLine = chatText[#chatText][2];
	lastLineParse = string.sub(lastLine,string.find(lastLine,"m]")+3,string.len(lastLine));

	foundSand, x, y = string.match(lastLineParse, "You detect nothing but sand at (%D+) ([-0-9]+) ([-0-9]+)");

	if (foundSand) then
		if ((x ~= lastX) or (y ~= lastY)) then
			writeDowseLog(x .. "," .. y .. "," .. "Sand");
			sleepWithStatus(3000, "Found Sand at " .. x .. "," .. y);
			lastX = x;
			lastY = y;
		end
		return;
	end

	foundOre, x, y = string.match(lastLineParse, "You detect an underground vein of (%D+) at %D+ ([-0-9]+) ([-0-9]+)");

	if (foundOre) then
		if ((x ~= lastX) or (y ~= lastY)) then
			lsPlaySound("cymbals.wav");
			writeDowseLog(x .. "," .. y .. "," .. foundOre);
			sleepWithStatus(3000, "Found " .. foundOre .. " at " .. x .. "," .. y);
			lastX = x;
			lastY = y;
		end
		return;
	end

	foundOre, x, y = string.match(lastLineParse, "You detect a vein of (%D+), somewhere nearby %D+ ([-0-9]+) ([-0-9]+)");

	if (foundOre) then
		if ((x ~= lastX) or (y ~= lastY)) then
			lsPlaySound("cymbals.wav");
			writeDowseLog(x .. "," .. y .. "," .. foundOre .. " nearby");
			sleepWithStatus(3000, "Found " .. foundOre .. " near " .. x .. "," .. y);
			lastX = x;
			lastY = y;
		end
	end
end

function doit()
   local mousePos = askForWindow("Click shift in ATITD window.");
   windowSize = srGetWindowSize();
   while true do
		doDowse();
		getDowseResult();
		checkBreak();
		sleepWithStatus(1000, "Waiting...");
   end
end
