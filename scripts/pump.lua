--
-- 
--

dofile("common.inc");

delay = 100;
pumpcount = 0;

function doit()
	askForWindow("Macro will pump the aqueduct towers.\n\nMake sure the Skills window is visible. Macro needs to see the word \"Endurance\" in the Skills window.\n\nPress Shift over ATITD to continue.");

	while 1 do
		checkBreak();
		srReadScreen();
		local tired = srFindImage("Endurance-Red.png"); 		-- Verifies tired and skills window is showing
		local skills = srFindImage("dexterity_black_small.png"); 	-- Verifies skill window is showing. Use Dex (black) to verify because Endurance will change colors
		local pump = srFindImage("pump1.png");				-- "Pump the Acqueduct" window						


			if not pump then
				sleepWithStatus(delay, "Pump Count: " .. pumpcount .. "\n\nWARNING, Can not find pump window!", 0xffff40ff);
			elseif tired then
				sleepWithStatus(delay, "Pump Count: " .. pumpcount .. "\n\nPAUSING, You are tired!", 0xff8080ff);
			elseif not skills then
				sleepWithStatus(delay, "Pump Count: " .. pumpcount .. "\n\nWARNING, Can't find skills window!", 0xffff40ff);

			else
				pumpcount = pumpcount + 1;
				srClickMouseNoMove(pump[0]+5, pump[1], 0);
				sleepWithStatus(delay, "Pump Count: " .. pumpcount .."\n\nREADY, Pumping...", 0x40ff40ff);
				lsSleep(300);
			end
			

	end
end

