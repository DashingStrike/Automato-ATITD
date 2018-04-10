-- Gather_Resources.lua v1.0 -- by Darkfyre
-- 
--

dofile("common.inc");

button_names = {"Grass","Grass Small Icon","Slate","Slate Small Icon","Clay","Clay Small Icon"};
counter = 0;

function checkOK()
	while 1 do
		checkBreak();
		srReadScreen();
		OK = srFindImage("OK.png");
			if OK then
			sleepWithStatus(100, "A popup box has been detected!\n\nAre you out of water?\n\nRun to nearby water (leave this popup open).\n\nAs soon as water icon appears, jugs will be refilled and popup window closed.");
			checkWater();
			else
			break;
			end
	end
end


function checkWater()
	checkBreak();
	srReadScreen();
	local water = srFindImage("iconWaterJugSmall.png", 1);
	local watersmall = srFindImage("iconWaterJugSmallIcon.png", 1);

    if (water or watersmall) then
	--Right click the ground to stop running, before gathering water. Or it interupts the gather water
	srClickMouseNoMove(OK[0], OK[1]+35, 1);
	lsSleep(100);

		if water then
	      safeClick(water[0]+3, water[1]-5);
		else
	      safeClick(watersmall[0]+3, watersmall[1]-5);
		end


      local max = waitForImage("crem-max.png", 500, "Waiting for Max button", nil, 3000);
      if max then
        safeClick(max[0]+5, max[1]+5);
        sleepWithStatus(3500, "Waiting for water pickup animation...");
	  closePopUp();
      end

   end 
end



function closePopUp()
		srReadScreen();
		local OK = srFindImage("OK.png");
			if OK then
		      safeClick(OK[0]+3, OK[1]-5);
			end
end




function gatherGrass()
	while 1 do
		checkBreak();
		srReadScreen();
		local grass = srFindImage("grass.png",1000);
			if grass then
			srClickMouseNoMove(grass[0]+5,grass[1],1);
			sleepWithStatus(100, "Clicking Grass Icon\n\nGrass Collected: " .. tostring(counter));
			counter = counter + 1;
			else
			sleepWithStatus(100, "Searching for Grass Icon\n\nGrass Collected: " .. tostring(counter));
			end
	end
end

function gatherGrassSmall()
	while 1 do
		checkBreak();
		srReadScreen();
		local grasssmall = srFindImage("grass_small.png", 1000);
			if grasssmall then
			srClickMouseNoMove(grasssmall[0]+5,grasssmall[1],1);
			sleepWithStatus(100, "Clicking Small Grass Icon\n\nGrass Collected: " .. tostring(counter));
			counter = counter + 1;
			else
			sleepWithStatus(100, "Searching for Small Grass Icon\n\nGrass Collected: " .. tostring(counter));
			end
	end
end

function gatherSlate()
	while 1 do
		checkBreak();
		srReadScreen();
		local slate = srFindImage("slate.png",1000);
			if slate then
			srClickMouseNoMove(slate[0]+5,slate[1],1);
			sleepWithStatus(100, "Clicking Slate Icon\n\nSlate Collected: " .. tostring(counter));
			counter = counter + 1;
			else
			sleepWithStatus(100, "Searching for Slate Icon\n\nSlate Collected: " .. tostring(counter));
			end
	end
end

function gatherSlateSmall()
	while 1 do
		checkBreak();
		srReadScreen();
		local slatesmall = srFindImage("slate_small.png", 10000);
			if slatesmall then
			srClickMouseNoMove(slatesmall[0]+5,slatesmall[1],1);
			sleepWithStatus(100, "Clicking Small Slate Icon\n\nSlate Collected: " .. tostring(counter));
			counter = counter + 1;
			else
			sleepWithStatus(100, "Searching for Small Slate Icon\n\nSlate Collected: " .. tostring(counter));
			end
	end
end

function gatherClay()
	while 1 do
		checkOK();
		checkBreak();
		srReadScreen();
		local clay = srFindImage("clay.png");
			if clay then
			srClickMouseNoMove(clay[0]+5,clay[1],1);
			sleepWithStatus(100, "Clicking Clay Icon\n\nClay Collected: " .. tostring(counter));
			counter = counter + 1;
			else
			sleepWithStatus(100, "Searching for Clay Icon\n\nClay Collected: " .. tostring(counter));
			end
	end
end

function gatherClaySmall()
	while 1 do
		checkOK();
		checkBreak();
		srReadScreen();
		local claysmall = srFindImage("clay_small.png", 10000);
			if claysmall then
			srClickMouseNoMove(claysmall[0]+5,claysmall[1],1);
			sleepWithStatus(100, "Clicking Small Clay Icon\n\nClay Collected: " .. tostring(counter));
			counter = counter + 1;
			else
			sleepWithStatus(100, "Searching for Small Clay Icon\n\nClay Collected: " .. tostring(counter));
			end
	end
end

function doit()
gatherResources();
end

function gatherResources()
	askForWindow('Searches for and clicks the selected resource (clay, grass, slate) until stopped. Icons can be on either side of the screen and either large or small.\n\nGrass: It\'s efficient (less running) if you walk instead of run (Self Click -> Emote -> Gait: Walking -- Gait: Running to restore)\n\nPress Shift over ATITD window to continue.');
	while 1 do
		-- Ask for which button
		local image_name = nil;
		local is_done = nil;	
		while not is_done do
			local y = nil;
			local x = nil;
			local bsize = nil;
			checkBreak();


			lsPrint(5, 200, 2, 0.65, 0.65, 0xffffffff, "     If you have \'Smaller Icons\' chosen in ");
			lsPrint(5, 215, 2, 0.65, 0.65, 0xffffffff, "Action Icons (Interface-Options), then choose");
			lsPrint(5, 230, 2, 0.65, 0.65, 0xffffffff, "\'Small Icon\' button.");
			lsPrint(5, 260, 2, 0.65, 0.65, 0xffffffff, "     Else choose Grass, Slate, Clay button.");


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


