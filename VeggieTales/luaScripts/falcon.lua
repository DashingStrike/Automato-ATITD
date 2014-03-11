--
-- 
--

assert(loadfile("luaScripts/common.inc"))();

function doit()
	askForWindow('Macro looks for windows while searching falcons. Simply right click a tree while the macro is running. Macro will click "Search for Falcon Roosts" for you. Then it will wait 2.5 seconds and close the popup box (OK Button) for you. All you have to do is right click trees, the macro will do the rest of the clicking for you!');

	while 1 do
		checkBreak();
		srReadScreen();
		sleepWithStatus(100, "Searching for Falcon message");
		local falcon = srFindImage("falcon.png");
			if falcon then
			srClickMouseNoMove(falcon[0]+5,falcon[1],1);

				while not ok do
				checkBreak();
				srReadScreen();
				local ok = srFindImage("OK.png");
					if ok then
					sleepWithStatus(2500, "Preparing to click OK button"); -- Wait a bit before clicking OK, so user has chance to see the "Falcon was caught" message.
					srClickMouseNoMove(ok[0]+5,ok[1],1);
					break;
					end
				end
			end

	end
end
