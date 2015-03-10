-- Hackling Rake - Original macro by Bardoth (T6) - Revised by Cegaiel
-- Runs the Hacking Rake (or Flax Comb). Monitors the skills tab and only clicks when its all black.
--
--

dofile("common.inc");
dofile("stats.inc");
dofile("ui_utils.inc");

askText = singleLine([[
Hackling Rake v1.0 (by tripps) --
This macro will run multiple hackling rakes and/or flax combs one at a time until they have each processed flax 99 times or you run out of rotten flax to process.  Once they have processed flax 99 times you should salvage and rebuild them.  That is much cheaper than waiting for them to break.
Pin their menus, pick up the rotten flax, and make sure your skills window is visible.
Place your mouse over the ATITD windows and press Shift to continue.
]]);

function doit()
	askForWindow(askText);
	lsSleep(100);
	srReadScreen();
	local rake = nil;
	local rakesCrushed = 0;
	local hitsOnCurr = 0;
	local processed = 0;
	local startTime = lsGetTimer();
	while(true) do
		statusScreen(processed .. " flax processed\n" .. rakesCrushed .. " rakes/combs maxed\n\r\nElapsed: " .. getElapsedTime(startTime));
		if(hitsOnCurr >= 98) then
			safeClick(rakeTop[0]+15, rakeTop[1]+3, true);
			hitsOnCurr = 0;
			rakesCrushed = rakesCrushed + 1;
			rake = nil;
			lsSleep(150);
		end
		srReadScreen();
		if(rake == nil) then
			local rakes = findAllImages("ThisIs.png");
			if(rakes == nil or #rakes == 0) then
				if(rakesCrushed == 0) then
					error("Unable to find any pinned menus");
				else
					lsPlaySound("Complete.wav");
					lsMessageBox("All rakes/combs are ready to be salvaged", processed .. " flax processed\n" .. rakesCrushed .. " rakes/combs maxed");
					return;
				end
			end
			rake = rakes[1];
			lsPrintln("Rake count: " .. #rakes);
			rakeTop = rakes[1];
		end		
		local retCode = processFlax(rakeTop);
		if(retCode > 0) then
			hitsOnCurr = hitsOnCurr + 1;
			processed = processed + 10;
		elseif(retCode < 0) then
			lsPlaySound("Complete.wav");
			lsMessageBox("Your rake/comb crumbled", processed .. " flax processed\n" .. rakesCrushed .. " rakes/combs maxed");
			return;
		end
		if(checkEmptyPocketsPopup()) then
			lsPlaySound("Complete.wav");
			lsMessageBox("You are out of rotten flax", processed .. " flax processed\n" .. rakesCrushed .. " rakes/combs maxed");
			return;
		end
		lsSleep(100);
	end
	lsPlaySound("Complete.wav");
	lsMessageBox("All rakes/combs are ready to be salvaged", processed .. " flax processed\n" .. rakesCrushed .. " rakes/combs maxed");
end

function processFlax(rake)
	if(statState(ss_Endurance) > 1) then
		return 0;
	end
	local window = getWindowBorders(rake[0], rake[1]);
	local r = boxToRegion(window);
	local posList = findAllText("Separate", window);
	if(posList) then
		local pos = posList[1];
		if(pos) then
			safeClick(pos[0]+15, pos[1]+3);
			checkEndurancePopup();
			return 0;
		end
	end
	local posList = findAllText("Continue", window);
	if(posList) then
		local pos = posList[1];
		if(pos) then
			safeClick(pos[0]+15, pos[1]+3);
			checkEndurancePopup();
			return 0;
		end
	end
	local posList = findAllText("Clean", window);
	if(posList) then
		local pos = posList[1];
		if(pos) then
			safeClick(pos[0]+15, pos[1]+3);
			checkEndurancePopup();
			return 1;
		end
	end
	return -1;
end

function checkEndurancePopup()
	lsSleep(150);
	srReadScreen();
	local pos = findText("You are too");
	if(pos) then
		pos = srFindImage("ok.png",15000);
		if(pos) then
			safeClick(pos[0]+5,pos[1]+5);
		end
		return true;
	end
	return false;
end

function checkEmptyPocketsPopup()
	lsSleep(150);
	srReadScreen();
	local pos = findText("You don't have any");
	if(pos) then
		pos = srFindImage("ok.png",15000);
		if(pos) then
			safeClick(pos[0]+5,pos[1]+5);
		end
		return true;
	end
	return false;
end




