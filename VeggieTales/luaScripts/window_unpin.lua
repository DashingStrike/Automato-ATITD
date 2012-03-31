-- Macro by Cegaiel
-- This will unpin all pinned windows. 
-- It searches for the word 'This' using this.png, which should occur in all windows. (ie This is a Thistle Garden, This is a brick rack, etc).
-- Upon finding This.png, it right clicks on the area, which would unpin the window (assuming its pinned).
-- Only problems would be if the window exists, but not actually pinned. A right click would cause this unpinned window to be pinned, so keep that in mind. Also added for a second check for unpin.png


loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();



function doit()

	askForWindow("Press Shift key to unpin/close all pinned windows. If you should get any errors, put ATITD window in focus first, before pressing Shift key.");
	
	srReadScreen();

	window_locs = findAllImages("This.png");

	clickAllRight("This.png", 1);
	lsSleep(200);
	


-- Do another check for unpin.png, Rare circumstances a window could not have the word 'This'. ie flax window that dropped to seed.  Searching for 'This' is more accurate, especially for overlapping windows, especially the thistle_new layout (from windows_arranger.lua). Using unpin.png will only close one window if its in thistle_new layout. But we will just double check for unpin.png, just in case...



	window_locs = findAllImages("unpin.png");

	clickAllRight("unpin.png", 1);
	lsSleep(200);



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