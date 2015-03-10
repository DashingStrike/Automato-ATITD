

dofile("ui_utils.inc");
dofile("settings.inc");
dofile("constants.inc");
dofile("screen_reader_common.inc");
dofile("common.inc");

imgThisIs = "ThisIs.png";
imgTake = "Take.png";
imgEverything = "Everything.png";
imtToMake = "toMake.png";
brickNames = { "Bricks", "Clay Bricks", "Firebricks" };
brickImages = { "makeBricks.png", "makeClayBricks.png", "makeFirebricks.png" };
typeOfBrick = 1;
arrangeWindows = true;
unpinWindows = true;

function doit()
	promptParameters();
	askForWindow("Make sure your chats are minimized and brick rack menus are pinned then hover ATITD window and press Shift to continue.");
	if(arrangeWindows) then
		arrangeInGrid();
	end
	while(true) do
		checkBreak();
		makeBricks();
		lsSleep(click_delay);
	end
end

function promptParameters()
	scale = 1.1;

	local z = 0;
	local is_done = nil;
	local value = nil;
	-- Edit box and text display
	while not is_done do
		-- Make sure we don't lock up with no easy way to escape!
		checkBreak();

		local y = 5;

		lsSetCamera(0,0,lsScreenX*scale,lsScreenY*scale);

		typeOfBrick = readSetting("typeOfBrick",typeOfBrick);
		typeOfBrick = lsDropdown("typeOfBrick", 5, y, 0, 150, typeOfBrick, brickNames);
		writeSetting("typeOfBrick",typeOfBrick);
		y = y + 32;

		arrangeWindows = readSetting("arrangeWindows",arrangeWindows);
		arrangeWindows = lsCheckBox(10, y, z, 0xFFFFFFff, "Arrange windows", arrangeWindows);
		writeSetting("arrangeWindows",arrangeWindows);
		y = y + 32;

		unpinWindows = readSetting("unpinWindows",unpinWindows);
		unpinWindows = lsCheckBox(10, y, z, 0xFFFFFFff, "Unpin windows on exit", unpinWindows);
		writeSetting("unpinWindows",unpinWindows);
		y = y + 32;

		lsPrintWrapped(10, y, z+10, lsScreenX - 20, 0.7, 0.7, 0xD0D0D0ff, 
			"Stand where you can reach all brick racks with all ingredients on you.");

		if lsButtonText(10, (lsScreenY - 30) * scale, z, 100, 0xFFFFFFff, "OK") then
			is_done = 1;
		end

		if lsButtonText((lsScreenX - 100) * scale, (lsScreenY - 30) * scale, z, 100, 0xFFFFFFff,
			"End script") then
			error "Clicked End Script button";
		end

		lsDoFrame();
		lsSleep(tick_delay);
	end
	if(unpinWindows) then
		setCleanupCallback(cleanup);
	end
end

function makeBricks()
	statusScreen("Making bricks");
	checkBreak();
	srReadScreen();
	local posList;
	posList = findAllImages(imgThisIs);
	if #posList > 0 then
		for i=1,#posList do
			safeClick(posList[i][0], posList[i][1]);
			lsSleep(click_delay);
			checkBreak();
		end
	end
	posList = findAllImages(brickImages[typeOfBrick]);
	if #posList > 0 then
		for i=1,#posList do
			safeClick(posList[i][0], posList[i][1]);
			lsSleep(click_delay);
			checkBreak();
			srReadScreen();
			local s = findAllImages(imtToMake);
			if(#s > 0) then
				cleanup();
				error("Out of supplies.");
			end
		end
	end
	posList = findAllImages(imgTake);
	if #posList > 0 then
		for i=1,#posList do
			safeClick(posList[i][0], posList[i][1]);
			lsSleep(click_delay);
			checkBreak();
		end
	end
	posList = findAllImages(imgEverything);
	if #posList > 0 then
		for i=1,#posList do
			safeClick(posList[i][0], posList[i][1]);
			lsSleep(click_delay);
			checkBreak();
		end
	end
end

function cleanup()
	if(unpinWindows) then
		closeAllWindows();
	end
end
