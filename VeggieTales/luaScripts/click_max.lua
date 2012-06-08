--
-- 
--

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

function doit()
	askForWindow('Will click any max button it sees. Great for filling grass hammocks quickly.  Not so good for dividing straw amongst many camel pens.');

	while 1 do
		checkBreak();
		srReadScreen();
		statusScreen("Searching for Max button");
		local max = srFindImage("crem-max.png");
			if max then
			srClickMouseNoMove(max[0]+5,max[1],1);
			statusScreen("Clicking Max button");
			lsSleep(500);
			end
	end
end
