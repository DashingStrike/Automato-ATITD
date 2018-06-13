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
		statusScreen("Could not find " .. image_name);
	else
		statusScreen("Clicking " .. #buttons .. "button(s)...");
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
		statusScreen("Done clicking (" .. #buttons .. " clicks).");
		lsSleep(150);
	end
end

recipe = "aaaaaaaaaaaaaaaaammmmmmmmmmmmmmmmmmmbmmbmmbmmbmmmqm"


keyDelay = 150;
function doit()
	status = "";
	local num_rounds;
	num_rounds = promptNumber("How many thermos?", 1);
	askForWindowAndPixel("                        Pin up the 'Start Making' menu. Make sure your chat is minimized! Click in ATITD, hover your mouse over the glory hole and push shift.  Ensure your heater control is set to Standard.");
	for i = 1, num_rounds do
		checkBreak();
		clickAll("Thermometer.png", true);
		lsSleep(100);
		srSetMousePos(mouse_x, mouse_y);
		statusScreen("Please be patient, the macro is sending keys to the glory hole",nil, 0.7, 0.7);
		for j = 1, string.len(recipe) do
			--recipe time
            checkBreak();
            local currKey = string.sub(recipe, j, j);
            srKeyEvent(currKey);
            status = status .. currKey;
			lsSleep(keyDelay);

            statusScreen("Please be patient, the macro is sending keys to the glory hole\n\n" .. status,nil, 0.7, 0.7);

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
