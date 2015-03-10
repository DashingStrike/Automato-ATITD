--
-- 
--

dofile("common.inc");

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
		local tiredMessage = srFindImage("tired.png"); 			-- Popup after clicking a tree AND you are too tired
		local skills = srFindImage("dexterity_black_small.png"); 	-- Verifies skill window is showing. Use Dex (black) to verify because Endurance can appear in popup message when tired.

			if tiredMessage then
				message = "You're too tired to search tree!";
			else
				message = "No falcon found!";
			end


			if falconfound then
			lsPlaySound("Siren.wav");
			sleepWithStatus(15000, "YOU FOUND YOUR FALCON!\n\nCONGRATULATIONS!!!");
			lsPlaySound("Complete.wav");
			error("You found your falcon! Congratulations!!!");
			end


			if ok and not falconfound then
			sleepWithStatus(1000, message); -- Wait a bit before clicking OK, so user has chance to read the popup.
			srClickMouseNoMove(ok[0]+5,ok[1],1);
			lsSleep(delay);

			-- Double check the tree menu isn't pinned (ie Interface Options, Right click pins a menu) from right clicking the tree...
			-- If so, close it
			srReadScreen();
			local Pin = srFindImage("UnPin.png");
			  if Pin then
			  srClickMouseNoMove(Pin[0]+5,Pin[1],1);
			  lsSleep(delay);
			  end
			end


			-- "Search for Falcon Roost" message found, click it!
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
