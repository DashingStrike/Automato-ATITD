
dofile("screen_reader_common.inc");
dofile("ui_utils.inc");

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
		px = srReadPixel(mouse_x, mouse_y);
		lsPrintWrapped(0, 40, 1, lsScreenX, 0.7, 0.7, 0xB0B0B0ff,
			mouse_x .. ", " .. mouse_y);
		lsPrintWrapped(0, 55, 1, lsScreenX, 0.7, 0.7, px,
			"(" .. (math.floor(px/256/256/256) % 256) .. "," .. (math.floor(px/256/256) % 256) .. "," .. (math.floor(px/256) % 256) .. "," .. (px % 256) .. ")" );
		-- Testing other methods of grabbing the pixel, making sure RGBA values match
		-- srReadScreen();
		-- px2 = srReadPixelFromBuffer(mouse_x, mouse_y);
		-- lsPrintWrapped(0, 80, 1, lsScreenX, 0.7, 0.7, 0xB0B0B0ff,
		-- 	mouse_x .. ", " .. mouse_y .. " = " .. (math.floor(px2/256/256/256) % 256) .. "," .. (math.floor(px2/256/256) % 256) .. "," .. (math.floor(px2/256) % 256) .. "," .. (px2 % 256) );
		-- lsButtonText(lsScreenX - 110, lsScreenY - 90, 0, 100, px, "test1");
		-- lsButtonText(lsScreenX - 110, lsScreenY - 60, 0, 100, px2, "test2");
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
	
	local t0 = lsGetTimer();
	local px = 0;
	local index=0;
	while 1 do
		lsSleep(100);
		srReadScreen();
		new_px = srReadPixel(mouse_x, mouse_y);
		local t = (lsGetTimer() - t0) / 1000 / 60;
		t = math.floor(t*10 + 0.5)/10;
		local t_string = t;
		if not (new_px == px) then
			index = index+1;
			srSaveLastReadScreen("screen_" .. index .. "_" .. t_string .. ".png");
			px = new_px;
			lsPlaySound("Clank.wav");
		end
		
		lsPrintWrapped(0, 0, 1, lsScreenX, 1, 1, 0xFFFFFFff,
			" pixel: " .. new_px .. "  screen: " .. index .. " timer: " .. t_string);
		lsPrintWrapped(0, 60, 1, lsScreenX, 0.7, 0.7, px,
			"(" .. (math.floor(px/256/256/256) % 256) .. "," .. (math.floor(px/256/256) % 256) .. "," .. (math.floor(px/256) % 256) .. "," .. (px % 256) .. ")" );
		
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xFFFFFFff, "Exit") then
			error "Canceled";
		end	
		lsDoFrame();
	end
end
