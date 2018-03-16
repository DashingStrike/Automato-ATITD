-- Gather_Resources.lua v1.0 -- by Darkfyre
-- 
--

dofile("common.inc");

button_names = {"Grass","Grass Small Icon","Slate","Slate Small Icon","Clay","Clay Small Icon"};

function gatherGrass()
	while 1 do
		checkBreak();
		srReadScreen();
		local grass = srFindImage("grass.png");
			if grass then
			srClickMouseNoMove(grass[0]+5,grass[1],1);
			sleepWithStatus(100, "Clicking Gather Grass Icon");
			else
			sleepWithStatus(100, "Searching for Gather Grass Icon");
			end
	end
end

function gatherGrassSmall()
	while 1 do
		checkBreak();
		srReadScreen();
		local grasssmall = srFindImage("grass_small.png");
			if grasssmall then
			srClickMouseNoMove(grasssmall[0]+5,grasssmall[1],1);
			sleepWithStatus(100, "Clicking Gather Grass Icon");
			else
			sleepWithStatus(100, "Searching for Gather Grass Icon");
			end
	end
end

function gatherSlate()
	while 1 do
		checkBreak();
		srReadScreen();
		local slate = srFindImage("slate.png");
			if slate then
			srClickMouseNoMove(slate[0]+5,slate[1],1);
			sleepWithStatus(100, "Clicking Gather Slate Icon");
			else
			sleepWithStatus(100, "Searching for Gather Slate Icon");
			end
	end
end

function gatherSlateSmall()
	while 1 do
		checkBreak();
		srReadScreen();
		local slatesmall = srFindImage("slate_small.png");
			if slatesmall then
			srClickMouseNoMove(slatesmall[0]+5,slatesmall[1],1);
			sleepWithStatus(100, "Clicking Gather Slate Icon");
			else
			sleepWithStatus(100, "Searching for Gather Slate Icon");
			end
	end
end

function gatherClay()
	while 1 do
		checkBreak();
		srReadScreen();
		local clay = srFindImage("clay.png");
			if clay then
			srClickMouseNoMove(clay[0]+5,clay[1],1);
			sleepWithStatus(100, "Clicking Gather Clay Icon");
			else
			sleepWithStatus(100, "Searching for Gather Clay Icon");
			end
	end
end

function gatherClaySmall()
	while 1 do
		checkBreak();
		srReadScreen();
		local claysmall = srFindImage("clay_small.png");
			if claysmall then
			srClickMouseNoMove(claysmall[0]+5,claysmall[1],1);
			sleepWithStatus(100, "Clicking Gather Clay Icon");
			else
			sleepWithStatus(100, "Searching for Gather Clay Icon");
			end
	end
end

function doit()
gatherResources();
end

function gatherResources()
	askForWindow('Searches for and clicks the selected resource until stopped. Icons can be on either side of the screen and either large or small. \nPress Shift over ATITD window to continue.');
	while 1 do
		-- Ask for which button
		local image_name = nil;
		local is_done = nil;	
		while not is_done do
			local y = nil;
			local x = nil;
			local bsize = nil;
			for i=1, #button_names do
				if button_names[i] == "Grass" then
					x = 30;
					y = 10;
					bsize = 130;
				elseif button_names[i] == "Grass Small Icon" then
					x = 30;
					y = 40;
					bsize = 130;
				elseif button_names[i] == "Slate" then
					x = 30;
					y = 70;
					bsize = 130;
				elseif button_names[i] == "Slate Small Icon" then
					x = 30;
					y = 100;
					bsize = 130;
					elseif button_names[i] == "Clay" then
					x = 30;
					y = 130;
					bsize = 130;
				elseif button_names[i] == "Clay Small Icon" then
					x = 30;
					y = 160;
					bsize = 130;
				end
				if lsButtonText(x, y, 0, 250, 0xe5d3a2ff, button_names[i]) then
					image_name = button_names[i];
					is_done = 1;
				end
			end

		       if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
				error "Clicked End Script button";
			end
			lsDoFrame();
			lsSleep(10);
		end	
		
		if image_name == "Grass" then
			gatherGrass();
		elseif image_name == "Grass Small Icon" then
			gatherGrassSmall();
		elseif image_name == "Slate" then
			gatherSlate();
		elseif image_name == "Slate Small Icon" then
			gatherSlateSmall();
		elseif image_name == "Clay" then
			gatherClay();
		elseif image_name == "Clay Small Icon" then
			gatherClaySmall();
		end
	end
end
