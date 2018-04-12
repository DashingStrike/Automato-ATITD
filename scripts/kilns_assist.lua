dofile("screen_reader_common.inc");
dofile("ui_utils.inc");

local per_click_delay = 0;

button_names = {
	"Wet Jugs",
	"Wet Clay Bricks",
	"Wet Firebricks",
	"Wet Clay Mortars"
};

function clickAll(image_name)
	-- Find buttons and click them!
	srReadScreen();
	xyWindowSize = srGetWindowSize();
	local buttons = findAllImages(image_name);
	
	if #buttons == 0 then
		error 'Could not find \'Kiln\' windows.'
		--statusScreen("Could not find specified buttons...");
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
		statusScreen("Done clicking (" .. #buttons .. " clicks).");
		lsSleep(100);
	end
end

function clickAllRight(image_name)
	-- Find windows and click them!
	srReadScreen();
	xyWindowSize = srGetWindowSize();
	local buttons = findAllImages(image_name);
	
	if #buttons == 0 then
		statusScreen("Could not find any pinned up windows...");
		lsSleep(1500);
	else
		statusScreen("Clicking " .. #buttons .. "windows(s)...");
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
		statusScreen("Done clicking (" .. #buttons .. " windows).");
		lsSleep(100);
	end
end

function Unpin()
	srReadScreen();

	window_locs = findAllImages("This.png");

	clickAllRight("This.png", 1);
	lsSleep(200);
end

function Do_Load_Click(img, item_name)
	srReadScreen();
	statusScreen("Loading kilns with " .. item_name)
	
	-- refresh windows
	clickAll("This.png", 1);
	lsSleep(200);

	-- do click
	clickAll(img, 1);
	lsSleep(200);
	
	-- refresh again
	clickAll("This.png", 1);
	lsSleep(200);
end

function Do_Take_All_Click()
	-- refresh windows
	clickAll("This.png", 1);
	lsSleep(200);

	clickAll("Take.png", 1);
	lsSleep(200);
	
	clickAll("Everything.png", 1);
	lsSleep(200);
	
	-- refresh windows, one last time so we know for sure the machine is empty (Take menu disappears)
	clickAll("This.png", 1);
	lsSleep(200);
end

function Do_Fire_Click()

	clickAll("This.png", 1);
	lsSleep(200);

	local crumbling = true
	local showUI = true
	
	while showUI do 
		--Checks to see if kiln is about to crumble
		srReadScreen();
		local Brokenkiln = srFindImage("crumble.png");
		if Brokenkiln then
			crumbling = true
		else
			crumbling = false
			showUI = false
		end

		if showUI then
			while true do
			
				lsPrint(10, 30, 1, 2, 2, 0xFF0000FF, "Warning!")
				lsPrint(10, 80, 1, 1, 1, 0xFFFFFFFF, "Kilns are about to crumble!")
				lsPrint(10, 110, 1, .8, .8, 0xFFFFFFFF, "Close or replace the crumbling")
				lsPrint(10, 130, 1, .8, .8, 0xFFFFFFFF, "kilns before continuing")
				
				if lsButtonText(30, 160, 1, 100, 0x00FF00FF, "Try again") then
					break;
				end
				
				if lsButtonText(150, 160, 1, 100, 0xFF0000FF, "Cancel") then
					showUI = false
					break
				end
				
				lsDoFrame();
				lsSleep(10)
			
			end
		end
	end

	if not crumbling then
		clickAll("fire.png", 1);
		lsSleep(200);
		
		clickAll("This.png", 1);
		lsSleep(200);
	end

end

function Do_Refresh_Click()
	-- refresh windows
	clickAll("This.png", 1);
	lsSleep(200);
end

function doit()
	askForWindow("Kiln Assist v1.0 by Huggz\nControl multiple kilns at once.  Just pin your kilns and push the buttons!");
 
	while 1 do
		-- Ask for which button
		local click_action = nil;
		local is_done = nil;
		
		local buttonOffsetY = 30;
		local smallSpaceY = 13;
		local buttonColor = 0xe5d3a2ff
		local x = 30;
		local y = 10;
		local z = 4;
		local w = 250;
	
		while click_action == nil do
			y = 10;
			
			local bsize = nil;
			
			if lsButtonText(x, y, z, w, 0x7A5132FF, "Add Wood") then
				click_action = "Add Wood"
			end
			y = y + buttonOffsetY 
			y = y + smallSpaceY 
			
			for i=1, #button_names do		
				if lsButtonText(x, y, z, w, buttonColor, button_names[i]) then
					click_action = button_names[i];
				end
				y = y + buttonOffsetY
			end
			
			y = y + smallSpaceY 
			
			if lsButtonText(x, y, z, w, 0xFF0000ff, "Fire") then
				click_action = "Fire"
			end
			y = y + buttonOffsetY 
			
			if lsButtonText(x, y, z, w, 0x00FF00ff, "Take All") then
				click_action = "Take All"
			end
			y = y + buttonOffsetY
			
			if lsButtonText(x, y, z, w, 0xFFFF00ff, "Refresh Windows") then
				click_action = "Refresh"
			end
			y = y + buttonOffsetY
			
			if lsButtonText(lsScreenX - 245, lsScreenY - 60, z, 200, 0xFFFF00ff, "Un-Pin Windows") then
				click_action = "Un-Pin Windows";
			end
			
			if lsButtonText(lsScreenX - 220, lsScreenY - 30, z, 150, 0xFF0000ff, "End script") then
				error "Clicked End Script button";
			end
			lsDoFrame();
			lsSleep(10);
		end	
		
		if click_action == "Add Wood" then
			Do_Load_Click("wood.png", "wood")
		elseif click_action == "Fire" then
			Do_Fire_Click()
		elseif click_action == "Take All" then
			Do_Take_All_Click();
		elseif click_action == "Wet Jugs" then
			Do_Load_Click("wet_jugs.png", "wet jugs")
		elseif click_action == "Wet Clay Bricks" then
			Do_Load_Click("wet_clay_bricks.png", "wet clay bricks")
		elseif click_action == "Wet Firebricks" then
			Do_Load_Click("wet_firebricks.png", "wet firebricks")
		elseif click_action == "Wet Clay Mortars" then
			Do_Load_Click("wet_clay_morters.png", "wet clay mortars")
		elseif click_action == "Un-Pin Windows" then
			Unpin();
		elseif click_action == "Refresh" then
			Do_Refresh_Click();
		end
	end
end
