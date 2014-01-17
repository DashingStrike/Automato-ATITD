
--
-- 
--

assert(loadfile("luaScripts/common.inc"))();



function doit()
	askForWindow('This macro assists in building Pyramids. This attempts to Crack Outline first, then tries to Tap Bore Rods next. Watches stats timer during the process. Pin up as many menus (Bore Holes) as you like. Any window that is cracked, will be closed automatically. Macro processes menus from left to right, top to bottom. Press Shift over ATITD window to continue. This simple macro by Cegaiel.');


	sleepWithStatus(500, "Searching for something to click...");


	while 1 do
		checkBreak();
		srReadScreen();
		local crack = srFindImage("crack_outline.png");
		local tap = srFindImage("tap_bore_rod.png");
		local OK = srFindImage("ok.png");
		local stats = srFindImage("AllStats-Black.png");
		local unpin = srFindImage("unpin.png");


			if OK then
			srClickMouseNoMove(OK[0]+5,OK[1],1);
			sleepWithStatus(500, "Clicking OK button!");
			end

			if crack then
			srClickMouseNoMove(crack[0]+5,crack[1],1);
			sleepWithStatus(1000, "Cracking the Outline!");


			--Close the window that cracked
			sleepWithStatus(500, "Closing Window!");
			srClickMouseNoMove(unpin[0]+5,unpin[1],1);
			end



	if stats then

			if tap then
			srClickMouseNoMove(tap[0]+5,tap[1],1);
			sleepWithStatus(500, "Tapping the Bore Rod!");
			else
			--sleepWithStatus(500, "Hmmm, I'm lost!");
			error("Nothing to click! Quitting...");
			end


	else
	sleepWithStatus(500, "You're tired!\n\nWaiting on timer...");
	end


	end
end
