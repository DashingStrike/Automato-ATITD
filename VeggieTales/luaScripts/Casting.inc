button_names = {
"Heavy Lead Bowl",
"Monkey Wrench",
"Silver Bowl",
"Iron Cookpot",
"Anvil Bed",
"Fuel",
"Gearwork",
"Hardware",
"Tools"
};

fuel_button_names = {
"Orichalcum Pellets"
};
gearwork_button_names = {
"Medium Gear",
"Small Gear"
};

hardware_button_names = {
"Bearing",
"12 Washers",
"4 Bolts"
};

tools_button_names = {
"Heavy Mallet Head",
"Wide Tungsten Chisel",
"Round Hammer",
"Ball Peen Hammer",
"Shaping Mallet",
"Lead Mallet",
"Pewter Incense Prong"
};

----------------- MAKE PROJECTS 'SUPPORTING' FUNCTIONS -----------------

function waitMinutes(minutes)
-- Teppy Minute is 66 seconds or 66000 ms
-- Add a 3 second delay (3000 ms) in case of lag

wait_delay = 3000; -- Extra delay on top of Teppy Time, for lag purposes. Default is 3000
wait = (minutes * 66000) + wait_delay;
askForFocus(); -- Pause to allow user to focus back to ATITD (if they checked the Pause for Focus Box), before starting project.
end

function doneGUI(totalPasses)
wait = 5000;  -- Gives a 5 second delay to review the GUI stats, before quitting/returing to Main Menu.
clickAllImages("This.png"); -- Refresh the screen. Update Casting box window so we know how much charcoal is currently in each box before next project

sleepWithStatus(wait, "[" .. totalPasses .. "/" .. totalPasses .. "] ALL DONE!\n----------------------------------------------\n[" .. made .. "/" .. batch*project_windows*num_loops .. "] " .. name .. " / Completed");

lsPlaySound("Complete.wav");
runCasting(); -- Return to/Display Main Menu
end


function waitGUI(pass)
	--If any casting menus shows the Forge_StartFire.png - refreshWindows() function, then display the stalledMessage in the GUI. Suggests its not lit (or out of charcoal)
	if #stalled > 0 then
	stalledMessage = "\n[" .. #stalled .. "] CB\'s STALLED (Needs Lit)"
	else
	stalledMessage = "";
	end

sleepWithStatus(wait, "[" .. pass .. "/" .. num_loops .. "] Total Passes\n----------------------------------------------\n[" .. batch .. "] " .. name .. " per CB\n[" .. project_windows .. "] CB\'s working" .. stalledMessage .. "\n----------------------------------------------\n[" .. batch*project_windows .. "] " .. name .. " per pass\n----------------------------------------------\n[" .. made .. "/" .. batch*project_windows*num_loops .. "] " .. name .. " / Completed");

made = made + (batch*project_windows);
end


function refreshWindows()
	checkBreak();
	pinned_windows = clickAllImages("This.png");
	lsSleep(400);
		if pinned_windows == 0 then
		error("No pinned windows found!");
		else
		srReadScreen();
		stalled = findAllImages("Forge/Forge_StartFire.png");
			if #stalled == pinned_windows/2 then -- The /2 is because each box has 'This' located in window twice. Can't use ThisIs.png either because idle/working box has different words (Idle box shows 'This' only and Working box shows 'This Is'
			error("No Casting Boxes are lit!");
			end
		end
end


----------------- MAKE PROJECT FUNCTIONS -----------------

function heavyleadbowl()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Heavy Lead Bowl";
	waitMinutes(10);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			project_windows = clickAllImages("Casting/HeavyLeadBowl.png");
				if project_windows == 0 then
				sleepWithStatus(1500, "Waiting for Project windows");
				else
				break;
				end
			end
			waitGUI(i);
		end
	doneGUI(num_loops);
end

function monkeywrench()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Monkey Wrench";
	waitMinutes(4);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			project_windows = clickAllImages("Casting/MonkeyWrench.png");
				if project_windows == 0 then
				sleepWithStatus(1500, "Waiting for Project windows");
				else
				break;
				end
			end
			waitGUI(i);
		end
	doneGUI(num_loops);
end

function silverbowl()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Silver Bowl";
	waitMinutes(15);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			project_windows = clickAllImages("Casting/SilverBowl.png");
				if project_windows == 0 then
				sleepWithStatus(1500, "Waiting for Project windows");
				else
				break;
				end
			end
			waitGUI(i);
		end
	doneGUI(num_loops);
end

function ironcookpot()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Iron Cookpot";
	waitMinutes(1);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			project_windows = clickAllImages("Casting/IronCookingPot.png");
				if project_windows == 0 then
				sleepWithStatus(1500, "Waiting for Project windows");
				else
				break;
				end
			end
			waitGUI(i);
		end
	doneGUI(num_loops);
end

function anvilbed()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Anvil Bed";
	waitMinutes(3);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			project_windows = clickAllImages("Casting/AnvilBed.png");
				if project_windows == 0 then
				sleepWithStatus(1500, "Waiting for Project windows");
				else
				break;
				end
			end
			waitGUI(i);
		end
	doneGUI(num_loops);
end

function orichalcumpellets()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 4;
	name = "Orichalcum Pellet";
	waitMinutes(.5);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Casting/Fuel.png");
			lsSleep(400);
			project_windows = clickAllImages("Casting/OrichalcumPellets.png");
				if project_windows == 0 then
				sleepWithStatus(1100, "Waiting for Project windows");
				else
				break;
				end
			end
			waitGUI(i);
		end
	doneGUI(num_loops);
end

function mediumgear()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Medium Gear";
	waitMinutes(5);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Casting/Gearwork.png");
			lsSleep(400);
			project_windows = clickAllImages("Casting/MediumGear.png");
				if project_windows == 0 then
				sleepWithStatus(1100, "Waiting for Project windows");
				else
				break;
				end
			end
			waitGUI(i);
		end
	doneGUI(num_loops);
end

function smallgear()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Small Gear";
	waitMinutes(1);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Casting/Gearwork.png");
			lsSleep(400);
			project_windows = clickAllImages("Casting/SmallGear.png");
				if project_windows == 0 then
				sleepWithStatus(1100, "Waiting for Project windows");
				else
				break;
				end
			end
			waitGUI(i);
		end
	doneGUI(num_loops);
end

function bearing()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Bearings";
	waitMinutes(2);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Casting/Hardware.png");
			lsSleep(400);
			project_windows = clickAllImages("Casting/Bearing.png");
				if project_windows == 0 then
				sleepWithStatus(1100, "Waiting for Project windows");
				else
				break;
				end
			end
			waitGUI(i);
		end
	doneGUI(num_loops);
end

function washers()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 12;
	name = "Washers";
	waitMinutes(2);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Casting/Hardware.png");
			lsSleep(400);
			project_windows = clickAllImages("Casting/12Washers.png");
				if project_windows == 0 then
				sleepWithStatus(1100, "Waiting for Project windows");
				else
				break;
				end
			end
			waitGUI(i);
		end
	doneGUI(num_loops);
end

function bolts()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 4;
	name = "Bolts";
	waitMinutes(2);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Casting/Hardware.png");
			lsSleep(400);
			project_windows = clickAllImages("Casting/4Bolts.png");
				if project_windows == 0 then
				sleepWithStatus(1100, "Waiting for Project windows");
				else
				break;
				end
			end
			waitGUI(i);
		end
	doneGUI(num_loops);
end

function heavymallethead()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Heavy Mallet Head";
	waitMinutes(10);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Casting/Forge_Tools.png");
			lsSleep(400);
			project_windows = clickAllImages("Casting/HeavyMalletHead.png");
				if project_windows == 0 then
				sleepWithStatus(1100, "Waiting for Project windows");
				else
				break;
				end
			end
			waitGUI(i);
		end
	doneGUI(num_loops);
end

function widetungstenchisel()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Wide Tungsten Chisel";
	waitMinutes(5);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Casting/Forge_Tools.png");
			lsSleep(400);
			project_windows = clickAllImages("Casting/WideTungstenChisel.png");
				if project_windows == 0 then
				sleepWithStatus(1100, "Waiting for Project windows");
				else
				break;
				end
			end
			waitGUI(i);
		end
	doneGUI(num_loops);
end

function roundhammer()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Round Hammer";
	waitMinutes(5);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Casting/Forge_Tools.png");
			lsSleep(400);
			project_windows = clickAllImages("Casting/RoundHammer.png");
				if project_windows == 0 then
				sleepWithStatus(1100, "Waiting for Project windows");
				else
				break;
				end
			end
			waitGUI(i);
		end
	doneGUI(num_loops);
end

function ballpeenhammer()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Ball Peen Hammer";
	waitMinutes(5);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Casting/Forge_Tools.png");
			lsSleep(400);
			project_windows = clickAllImages("Casting/BallPeenHammer.png");
				if project_windows == 0 then
				sleepWithStatus(1100, "Waiting for Project windows");
				else
				break;
				end
			end
			waitGUI(i);
		end
	doneGUI(num_loops);
end

function shapingmallet()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Shaping Mallet";
	waitMinutes(10);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Casting/Forge_Tools.png");
			lsSleep(400);
			project_windows = clickAllImages("Casting/ShapingMallet.png");
				if project_windows == 0 then
				sleepWithStatus(1100, "Waiting for Project windows");
				else
				break;
				end
			end
			waitGUI(i);
		end
	doneGUI(num_loops);
end

function leadmallet()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Lead Mallet";
	waitMinutes(5);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Casting/Forge_Tools.png");
			lsSleep(400);
			project_windows = clickAllImages("Casting/LeadMallet.png");
				if project_windows == 0 then
				sleepWithStatus(1100, "Waiting for Project windows");
				else
				break;
				end
			end
			waitGUI(i);
		end
	doneGUI(num_loops);
end

function pewterincenseprong()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Incense Prong";
	waitMinutes(3);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Casting/Forge_Tools.png");
			lsSleep(400);
			project_windows = clickAllImages("Casting/PewterIncenseProng.png");
				if project_windows == 0 then
				sleepWithStatus(1100, "Waiting for Project windows");
				else
				break;
				end
			end
			waitGUI(i);
		end
	doneGUI(num_loops);
end

function fuel()
	while 1 do
		-- Ask for which button
		local image_name = nil;
		local is_done = nil;	
		while not is_done do
			local y = nil;
			local x = nil;
			local bsize = nil;
			for i=1, #fuel_button_names do
				if fuel_button_names[i] == "Orichalcum Pellets" then
					x = 30;
					y = 10;
					bsize = 250;

				end
				if lsButtonText(x, y, 0, bsize, 0x80D080ff, fuel_button_names[i]) then
					image_name = fuel_button_names[i];
					is_done = 1;
				end
			end

			if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
				error "Clicked End Script button";
			end
			lsDoFrame();
			lsSleep(10);
		end	
		
		if image_name == "Orichalcum Pellets" then
			orichalcumpellets();
		end
	end
end

function gearwork()
	while 1 do
		-- Ask for which button
		local image_name = nil;
		local is_done = nil;	
		while not is_done do
			local y = nil;
			local x = nil;
			local bsize = nil;
			for i=1, #gearwork_button_names do
				if gearwork_button_names[i] == "Medium Gear" then
					x = 30;
					y = 10;
					bsize = 150;
				elseif gearwork_button_names[i] == "Small Gear" then
					x = 30;
					y = 35;
					bsize = 150;
				end
				if lsButtonText(x, y, 0, 250, 0x80D080ff, gearwork_button_names[i]) then
					image_name = gearwork_button_names[i];
					is_done = 1;
				end
			end

			if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
				error "Clicked End Script button";
			end
			lsDoFrame();
			lsSleep(10);
		end	
		
		if image_name == "Medium Gear" then
			mediumgear();
		elseif image_name == "Small Gear" then
			smallgear();
		end
	end
end

function hardware()
	while 1 do
		-- Ask for which button
		local image_name = nil;
		local is_done = nil;	
		while not is_done do
			local y = nil;
			local x = nil;
			local bsize = nil;
			for i=1, #hardware_button_names do
				if hardware_button_names[i] == "Bearing" then
					x = 30;
					y = 10;
					bsize = 250;
				elseif hardware_button_names[i] == "12 Washers" then
					x = 30;
					y = 40;
					bsize = 250;
				elseif hardware_button_names[i] == "4 Bolts" then
					x = 30;
					y = 70;
					bsize = 250;
				end
				if lsButtonText(x, y, 0, bsize, 0x80D080ff, hardware_button_names[i]) then
					image_name = hardware_button_names[i];
					is_done = 1;
				end
			end

			if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
				error "Clicked End Script button";
			end
			lsDoFrame();
			lsSleep(10);
		end	
		
		if image_name == "Bearing" then
			bearing();
		elseif image_name == "12 Washers" then
			washers();
		elseif image_name == "4 Bolts" then
			bolts();
		end
	end
end

function tools()
	while 1 do
		-- Ask for which button
		local image_name = nil;
		local is_done = nil;	
		while not is_done do
			local y = nil;
			local x = nil;
			local bsize = nil;
			for i=1, #tools_button_names do
				if tools_button_names[i] == "Heavy Mallet Head" then
					x = 30;
					y = 10;
					bsize = 250;
				elseif tools_button_names[i] == "Wide Tungsten Chisel" then
					x = 30;
					y = 40;
					bsize = 250;
				elseif tools_button_names[i] == "Round Hammer" then
					x = 30;
					y = 70;
					bsize = 250;
				elseif tools_button_names[i] == "Ball Peen Hammer" then
					x = 30;
					y = 100;
					bsize = 250;
				elseif tools_button_names[i] == "Shaping Mallet" then
					x = 30;
					y = 130;
					bsize = 250;
				elseif tools_button_names[i] == "Lead Mallet" then
					x = 30;
					y = 160;
					bsize = 250;
				elseif tools_button_names[i] == "Pewter Incense Prong" then
					x = 30;
					y = 190;
					bsize = 250;
				end
				if lsButtonText(x, y, 0, bsize, 0x80D080ff, tools_button_names[i]) then
					image_name = tools_button_names[i];
					is_done = 1;
				end
			end

			if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
				error "Clicked End Script button";
			end
			lsDoFrame();
			lsSleep(10);
		end	
		
		if image_name == "Heavy Mallet Head" then
			heavymallethead();
		elseif image_name == "Wide Tungsten Chisel" then
			widetungstenchisel();
		elseif image_name == "Round Hammer" then
			roundhammer();
		elseif image_name == "Ball Peen Hammer" then
			ballpeenhammer();
		elseif image_name == "Shaping Mallet" then
			shapingmallet();
		elseif image_name == "Lead Mallet" then
			leadmallet();
		elseif image_name == "Pewter Incense Prong" then
			pewterincenseprong();
		end
	end
end
