--
-- 
--

dofile("common.inc");

per_click_delay = 20;


up = nil;
right_click = nil;

-- optional message
function askForWindowAndPixel(message)
	-- Wait for release if it's already held
	while lsShiftHeld() do end;
	-- Display message until shift is held
	while not lsShiftHeld() do
		lsPrintWrapped(0, 0, 1, lsScreenX, 0.7, 0.7, 0xFFFFFFff,
			"Mouse over the relevant pixel and press Shift.");
		if message then
			lsPrintWrapped(0, 40, 1, lsScreenX, 0.7, 0.7, 0xB0B0B0ff,
				message);
		end
		lsSetCaptureWindow();
		mouse_x, mouse_y = srMousePos();
		lsPrintWrapped(0, 40, 1, lsScreenX, 0.7, 0.7, 0xB0B0B0ff,
			mouse_x .. ", " .. mouse_y);
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

function clickAll(image_name, up)
	if nil then
		lsPrintln("Would click '".. image_name .. "'");
		return; -- not clicking buttons for debugging
	end
	-- Find buttons and click them!
	srReadScreen();
	xyWindowSize = srGetWindowSize();
	local buttons = findAllImages(image_name);
	
	if #buttons == 0 then
		statusScreen("Could not find " .. image_name, nil, 0.7, 0.7);
	else
		statusScreen("Clicking " .. #buttons .. "button(s)...", nil, 0.7, 0.7);
		if up then
			for i=#buttons, 1, -1  do
				srClickMouseNoMove(buttons[i][0]+2, buttons[i][1]+2);
				lsSleep(per_click_delay);
			end
		else
			for i=1, #buttons  do
				srClickMouseNoMove(buttons[i][0]+2, buttons[i][1]+2);
				lsSleep(per_click_delay);
			end
		end
		statusScreen("Done clicking (" .. #buttons .. " clicks).", nil, 0.7, 0.7);
		lsSleep(150);
	end
end

recipe = "aaaaaaaaaaaaaaaaammmmmmmmmmmmmmmmmmmbmmbmmbmmbmmmqm"

recipeLen = string.len(recipe);
keyDelay = 150;
function doit()
	local num_rounds;
	local keystrokes;
	num_rounds = promptNumber("How many thermos?", 1);
	askForWindowAndPixel("\n\nPin up the 'Start Making' menu.\n\nMake sure your chat is minimized!\n\nClick in ATITD, hover your mouse over the glory hole and press Shift key.\n\nEnsure your heater control is set to Standard.");
	srReadScreen();
	thermos = srFindImage("Thermometer.png")
	if not thermos then
	  error('No match on screen for Thermometer.png\nDo you have Start Making menu pinned?');
	end
	sleepWithStatus(5000, "Preparing to start macro!\n\nDon\'t touch mouse, EVER, while running!\n\nAre you sure chat is minimized?\n\nNow is your chance to Abort if not...", nil, 0.7, 0.7);
	for i = 1, num_rounds do
		keystrokes = 0;
		status = "";
		checkBreak();
		clickAll("Thermometer.png", true);
		lsSleep(100);
		srSetMousePos(mouse_x, mouse_y);
		for j = 1, string.len(recipe) do
			--recipe time
            checkBreak();
            local currKey = string.sub(recipe, j, j);
            srSetMousePos(mouse_x, mouse_y);
            srKeyEvent(currKey);
            keystrokes = keystrokes + 1;
            status = status .. currKey;
			lsSleep(keyDelay);

            statusScreen("[" .. i .. "/" .. num_rounds .. "] Thermometer(s)\n[" .. keystrokes .. "/" .. recipeLen .. "] Keystrokes remaining\n\nPlease be patient; Don\'t touch mouse!\nSending keystrokes to the glory hole...\n\n" .. status,nil, 0.7, 0.7);

		end
		lsSleep(keyDelay);
			srKeyEvent("u");
		lsSleep(keyDelay);
		clickAll("WindowEmpty.png");
		lsSleep(keyDelay);
		clickAll("Ok.png");
		lsSleep(keyDelay);
	end
lsPlaySound("Complete.wav");
end
