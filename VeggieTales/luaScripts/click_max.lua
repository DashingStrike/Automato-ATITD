--
-- 
--

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

function doit()
	askForWindow('Will click any max button it sees. Great for filling grass hammocks quickly.  Not so good for dividing straw amongst many camel pens.');
	
	local num_clicks = 0;
	local warn_small_font=nil;
	local warn_large_font=nil;
	
	statusScreen('starting');
	while 1 do
		--lsSleep(12);
		statusScreen("searching");
		srReadScreen();
		local max = srFindImage("maxButton.png",5000);
		while max do 
			srClickMouseNoMove(max[0]+5,max[1],0);
			lsSleep(50);
			srReadScreen();
			max = srFindImage("maxButton.png",5000);
		end
		statusScreen("waiting");
		lsSleep(500);

	end
end

		
--		xyWindowSize = srGetWindowSize();
--		max_image2 = nil;
--		max_image3 = nil;
		
--		local max_images = findAllImages("maxButton.png");
--		if #max_images > 0 then
--			for i = 1, #max_images do
--				statusScreen("Found max button");
--				srClickMouseNoMove(max_images[i][0],max_images[i][1]);
--			end
--		end
--		statusScreen('looping');
