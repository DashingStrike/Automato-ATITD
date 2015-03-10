
loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();
loadfile("luaScripts/common.inc")();

foundBladePos = {};
offset = {};

function doit()
	promptOkay("Make sure you are in the F8F8 view, zoomed all the way in, with the anvil menu pinned where it does not overlap the anvil.");
	promptOkay("Stand to the left of the anvil without any part of your body overlapping the anvil.");

	local howMany = promptNumber("How many?",10);
	if(howMany < 1) then
		fatalError("Must make at least one.");
	end
	
	askForWindow("Make sure your chats are minimized, then hover ATITD window and press Shift to continue.");
	click_delay = 150;
	per_click_delay	 = click_delay;
	
	checkAnvil();
	findAnvil();

	local numMade;
	for numMade=1, howMany do
		statusScreen("Making blade " .. numMade .. " of " .. howMany .. " with " .. (howMany - numMade) .. " to go after this one.");
		checkBreak();
		loadAnvil();
		makeBlade();
		checkBlade();
		takeBlade();
	end
end

function mouseHome()
	srSetMousePos(0,0);
end

function checkAnvil()
	mouseHome();
	srReadScreen();
	local pos = findText("This is a Anvil");
	if(not pos) then
		fatalError("Unable to find the anvil menu, in checkAnvil().");
	end

	local pos = findText("Complete Project");
	if(pos) then
		fatalError("The anvil already has a project loaded.  Clear the anvil and try again.");
	end
end

function findAnvil()
	mouseHome();
	srReadScreen();
	local pos = findText("Load Anvil...");
	if(not pos) then
		fatalError("Unable to find the Load Anvil menu item.");
	end
	clickText(pos);
	
	srReadScreen();
	pos = findText("Iron...");
	if(not pos) then
		fatalError("Unable to find the Iron menu item.");
	end
	clickText(pos);
	
	srReadScreen();
	pos = findText("Resin Wedge");
	if(not pos) then
		fatalError("Unable to find the Resin Wedge menu item.");
	end
	clickText(pos);

	findResinWedgeRightTop();
	
	srReadScreen();
	local pos = findText("This is a Anvil");
	if(not pos) then
		fatalError("Unable to find the anvil menu, in findAnvil().");
	end
	clickText(pos);
	
	srReadScreen();
	local pos = findText("Discard Project");
	if(not pos) then
		fatalError("Unable to find the Discard Project menu item.");
	end
	clickText(pos);
	
	srReadScreen();
	local pos = findText("Really scrap");
	if(not pos) then
		fatalError("Unable to find the scap confirmation dialog.");
	end
	pos[0] = pos[0] + 10;
	pos = findImageInWindow("Yes.png", pos[0], pos[1], 5000);
	if(not pos) then
		fatalError("Unable to find the Yes button.");
	end
	clickText(pos);
	
	srReadScreen();
	local pos = findText("This is a Anvil");
	if(not pos) then
		fatalError("Unable to find the anvil menu, in findAnvil().");
	end
	clickText(pos);
end

function findResinWedgeRightTop()
	mouseHome();
	srReadScreen();
	local xyWindowSize = srGetWindowSize();
	local mid = {};
	mid[0] = xyWindowSize[0] / 2;
	mid[1] = xyWindowSize[1] / 2;

	local bestX = mid[0];
	local bestY = mid[1] - 400;

	local count = 220;
	local step = 64;
	local currX = bestX;
	local currY = bestY;
	local x;
	local maxHue = 0;
	for x = mid[0], mid[0] + 600, step do
		checkBreak();
		local y;
		for y = mid[1] - 400, mid[1], step do
			count = count - 1;
			local rgb = parseColor(srReadPixel(x,y));
			if(math.min(rgb[0]-rgb[2],rgb[1]-rgb[2]) >= 44) then
				if(x > bestX or (x == bestX and y < bestY)) then
					bestX = x;
					bestY = y;
					srSetMousePos(x,y);
					lsSleep(100);
				end
			end
			statusScreen("Finding reference point... " .. count);
		end
	end
	
	step = 32;
	while(step >= 1) do
		local currX = bestX;
		local currY = bestY;
		local x;
		local maxHue = 0;
		for x = currX - (step * 2), currX + (step * 2), step do
			checkBreak();
			local y;
			for y = currY - (step * 2), currY + (step * 2), step do
				count = count - 1;
				local rgb = parseColor(srReadPixel(x,y));
				if(math.min(rgb[0]-rgb[2],rgb[1]-rgb[2]) >= 40) then
					if(x > bestX or (x == bestX and y < bestY)) then
						bestX = x;
						bestY = y;
						srSetMousePos(x,y);
					end
				end
				statusScreen("Finding reference point... " .. count);
			end
		end
		step = step / 2;
	end
	foundBladePos[0] = bestX;
	foundBladePos[1] = bestY;
	srSetMousePos(bestX, bestY);
--	lsClipboardSet(bestX .. ", " .. bestY);
--	fatalError(bestX .. ", " .. bestY);
	mouseHome();
end

function loadAnvil()
	mouseHome();
	srReadScreen();
	local pos = findText("Load Anvil...");
	if(not pos) then
		fatalError("Unable to find the Load Anvil menu item.");
	end
	clickText(pos);
	
	srReadScreen();
	pos = findText("Iron...");
	if(not pos) then
		fatalError("Unable to find the Iron menu item.");
	end
	clickText(pos);
	
	srReadScreen();
	pos = findText("Carpentry Blade");
	if(not pos) then
		fatalError("Unable to find the Carpentry Blade menu item.");
	end
	clickText(pos);
	lsSleep(250);

	srReadScreen();
	local pos = findText("This is a Anvil");
	if(not pos) then
		fatalError("Unable to find the anvil menu, in loadAnvil().");
	end
	clickText(pos);
end

function setShapingMallet()
	mouseHome();
	srReadScreen();
	local pos = findText("Tools...");
	if(not pos) then
		fatalError("Unable to find the Tools menu item.");
	end
	clickText(pos);
	
	srReadScreen();
	pos = findText("Shaping Mallet");
	if(not pos) then
		fatalError("Unable to find the Shaping Mallet menu item.");
	end
	clickText(pos);
end

function setChisel()
	mouseHome();
	srReadScreen();
	local pos = findText("Tools...");
	if(not pos) then
		fatalError("Unable to find the Tools menu item.");
	end
	clickText(pos);
	
	srReadScreen();
	pos = findText("Wide Chisel");
	if(not pos) then
		fatalError("Unable to find the Wide Chisel menu item.");
	end
	clickText(pos);
end

function setBallPeen()
	mouseHome();
	srReadScreen();
	local pos = findText("Tools...");
	if(not pos) then
		fatalError("Unable to find the Tools menu item.");
	end
	clickText(pos);
	
	srReadScreen();
	pos = findText("Ball Peen");
	if(not pos) then
		fatalError("Unable to find the Ball Peen menu item.");
	end
	clickText(pos);
end

function setForce(force)
	mouseHome();
	srReadScreen();
	local pos = findText("Tools...");
	if(not pos) then
		fatalError("Unable to find the Tools menu item.");
	end
	clickText(pos);
	
	srReadScreen();
	pos = findText("Force Level");
	if(not pos) then
		fatalError("Unable to find the Force Level menu item.");
	end
	clickText(pos);

	srReadScreen();
	pos = findText("[" .. force .. "]");
	if(not pos) then
		fatalError("Unable to find the Force Level menu item.");
	end
	clickText(pos);
end	

function makeBlade()
	mouseHome();
	checkBreak();
	srReadScreen();

	click_delay = 200;
	
	local recordedBladePos = { 1261, 408 };
	offset[0] = foundBladePos[0] - recordedBladePos[1];
	offset[1] = foundBladePos[1] - recordedBladePos[2];
	
	setShapingMallet();
	setForce(8);
	
	clickXY(1046, 435, offset[0], offset[1]);
	checkBreak();
	clickXY(1046, 479, offset[0], offset[1]);
	checkBreak();
	clickXY(1046, 523, offset[0], offset[1]);
	checkBreak();
	clickXY(1046, 567, offset[0], offset[1]);
	checkBreak();
	clickXY(1046, 611, offset[0], offset[1]);
	checkBreak();
	clickXY(1046, 655, offset[0], offset[1]);
	checkBreak();
	clickXY(1046, 699, offset[0], offset[1]);
	checkBreak();
	clickXY(1046, 745, offset[0], offset[1]);
	checkBreak();

	setChisel();
	setForce(9);
	
	clickXY(1046, 435, offset[0], offset[1]);
	checkBreak();
	clickXY(1046, 745, offset[0], offset[1]);
	checkBreak();

	clickXY(1046, 538, offset[0], offset[1]);
	checkBreak();
	clickXY(1046, 642, offset[0], offset[1]);
	checkBreak();

	setForce(4);
	
	clickXY(1145, 534, offset[0], offset[1]);
	checkBreak();
	clickXY(1145, 590, offset[0], offset[1]);
	checkBreak();
	clickXY(1145, 652, offset[0], offset[1]);
	checkBreak();

	setBallPeen();
	setForce(9);
	
	clickXY(1164, 462, offset[0], offset[1]);
	checkBreak();
	clickXY(1162, 722, offset[0], offset[1]);
	checkBreak();
	
	clickXY(1258, 463, offset[0], offset[1]);
	checkBreak();
	clickXY(1261, 721, offset[0], offset[1]);
	checkBreak();

	clickXY(1236, 463, offset[0], offset[1]);
	checkBreak();
	clickXY(1239, 730, offset[0], offset[1]);
	checkBreak();

	clickXY(1237, 490, offset[0], offset[1]);
	checkBreak();
	clickXY(1236, 700, offset[0], offset[1]);
	checkBreak();
	
	clickXY(1250, 490, offset[0], offset[1]);
	checkBreak();
	clickXY(1255, 700, offset[0], offset[1]);
	checkBreak();

end

function checkBlade()
	mouseHome();
	srReadScreen();
	local pos = findText("Tools...");
	if(not pos) then
		fatalError("Unable to find the Tools menu item.");
	end
	clickText(pos);
	
	srReadScreen();
	pos = findText("Quality Check");
	if(not pos) then
		fatalError("Unable to find the Quality Check menu item.");
	end
	clickText(pos);
end

function takeBlade()
	mouseHome();
	srReadScreen();
	local pos = findText("Complete Project");
	if(not pos) then
		fatalError("Unable to find the Complete Project menu item.");
	end
	clickText(pos);
	
	srReadScreen();
	pos = findText("Ready to Unload");
	if(not pos) then
		fatalError("Unable to find the Ready to Unload confirmation dialog.");
	end
	pos[0] = pos[0] + 10;
	pos = findImageInWindow("Yes.png", pos[0], pos[1], 5000);
	if(not pos) then
		fatalError("Unable to find the Yes button.");
	end
	clickText(pos);

	lsSleep(500);
	srReadScreen();
	pos = srFindImage("ok.png", 10000);
	if(pos) then
		clickText(pos);
	end

	srReadScreen();
	local pos = findText("This is a Anvil");
	if(not pos) then
		fatalError("Unable to find the anvil menu, in findAnvil().");
	end
	clickText(pos);
end

