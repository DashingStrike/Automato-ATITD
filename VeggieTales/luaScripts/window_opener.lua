--
-- 
--

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

function askForWindowAndPixel(message)
	-- Wait for release if it's already held
	while lsShiftHeld() do end;
	-- Display message until shift is held
	while not lsShiftHeld() do
		lsPrintWrapped(0, 0, 1, lsScreenX, 0.7, 0.7, 0xFFFFFFff,
			"Mouse over the relevant pixel and press Shift. Right-click opens a Menu as Pinned must be ON.");
		if message then
			lsPrintWrapped(0, 100, 1, lsScreenX, 0.7, 0.7, 0xB0B0B0ff,
				message);
		end
		lsSetCaptureWindow();
		mouse_x, mouse_y = srMousePos();
		lsPrintWrapped(0, 70, 1, lsScreenX, 0.7, 0.7, 0xB0B0B0ff,
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
	return mouse_x, mouse_y;
end

function doit()
	w = promptNumber("Width?", 5);
	h = promptNumber("Height?", 4);
	max = promptNumber("Max Windows?", 20);
	ul_x, ul_y = askForWindowAndPixel("Upper Left corner");
	lr_x, lr_y = askForWindowAndPixel("Lower Right corner");
	pxw = lr_x - ul_x;
	pxh = lr_y - ul_y;
	
	xyScreenSize = srGetWindowSize();

	for i=w, 1, -1 do
		for j=1, h do
			checkBreak();
			srClickMouse(ul_x + (i-1) * pxw / (w-1) - j*2,
				ul_y + (j-1) * pxh / (h-1),
				1);
			lsSleep(100);
			max = max - 1;
			if max == 0 then
				return;
			end
		end
	end
				

end