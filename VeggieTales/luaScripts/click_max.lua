--
-- 
--

assert(loadfile("luaScripts/common.inc"))();

function doit()
	askForWindow('Searches for and clicks Max button until stopped.\n \nGreat for filling grass hammocks, loading distaffs, etc quickly.\n \nNot so good for dividing straw amongst many camel pens.\n \nPress Shift over ATITD window to continue.');

	while 1 do
		checkBreak();
		srReadScreen();
		sleepWithStatus(100, "Searching for Max button");
		local max = srFindImage("crem-max.png");
			if max then
			srClickMouseNoMove(max[0]+5,max[1],1);
			sleepWithStatus(500, "Clicking Max button");
			end
	end
end
