--
-- 
--

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

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


function doit()
	askForWindowAndPixel();
	
	local num_clicks = 0;
	local warn_small_font=nil;
	local warn_large_font=nil;
	
	while 1 do
		lsSleep(250);
		srReadScreen();
		stats_black2 = nil;
		stats_black3 = nil;
		
		stats_black = srFindImage("AllStats-Black.png");
		if not stats_black then
			stats_black2 = srFindImage("AllStats-Black2.png");
			if not stats_black2 then
				stats_black3 = srFindImage("AllStats-Black3.png");
				if stats_black3 then
					warn_large_font = true;
				end
			else
				warn_small_font = true;
			end
		end
		
		local warning="";
		if warn_small_font then
			warning = "Your font size appears to be smaller than the default, many macros here will not work correctly.";
		elseif warn_large_font then
			warning = "Your font size appears to be larger than the default, many macros here will not work correctly.";
		end
		
		if not stats_black and not stats_black2 and not stats_black3 then
			statusScreen("Waiting (all stats not black or not visible). " .. num_clicks .. " clicks so far. " .. warning);
		else
			srClickMouseNoMove(mouse_x, mouse_y);
			num_clicks = num_clicks + 1;
			statusScreen("Clicking. " .. num_clicks .. " clicks so far.");
		end
	end
end
