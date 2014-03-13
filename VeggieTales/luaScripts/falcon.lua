--
-- 
--

assert(loadfile("luaScripts/common.inc"))();

delay = 100;

function doit()
	askForWindow('Falcon Assistant v1.0 by Cegaiel\n\nMacro will click "Search for Falcon Roosts" window. Then it will wait 1 second (so you can read) and close the popup box (OK Button) for you.\n\nIf the falcon is found, macro will quit, play a sound and display a message.\n\nAll you have to do is click trees, the macro will do the rest of the clicking for you!\n\nOptions, One-Click, Fast Gather Wood MUST be UNChecked!\n\nPress Shift over ATITD to continue.');

	while 1 do
		checkBreak();
		srReadScreen();
		local falcon = srFindImage("falcon.png"); 			-- "Search for Roost" message when you click a tree
		local falconfound = srFindImage("falcon2.png"); 		-- Popup after clicking a tree AND You found a falcon
		local ok = srFindImage("OK.png"); 					--  Popup after clicking a tree.
		local tired = srFindImage("Endurance-Red.png"); 		-- Verifies tired and skills window is showing
		local skills = srFindImage("dexterity_black_small.png"); 	-- Verifies skill window is showing. Use Dex (black) to verify because Endurance will change colors



			if falconfound then
			sleepWithStatus(15000, "YOU FOUND YOUR FALCON!\n\nCONGRATULATIONS!!!");
			lsPlaySound("Complete.wav");
			error("You found your falcon! Congratulations!!!");
			end


			if ok then
			sleepWithStatus(1000, "Preparing to click OK button..."); -- Wait a bit before clicking OK, so user has chance to read the popup.
			srClickMouseNoMove(ok[0]+5,ok[1],1);
			lsSleep(delay);
			end


			if falcon then
			srClickMouseNoMove(falcon[0]+5,falcon[1],1);
			lsSleep(delay);
			end


			if tired then
				sleepWithStatus(delay, "Searching for Falcon Roost...\n\nWAIT, You are tired!", 0xff8080ff);
			elseif not skills then
				sleepWithStatus(delay, "Searching for Falcon Roost...\n\nWARNING, Can not find skills window!", 0xffff40ff);
			else
				sleepWithStatus(delay, "Searching for Falcon Roost...\n\nREADY, Click a tree!", 0x40ff40ff);

			end
			

	end
end
