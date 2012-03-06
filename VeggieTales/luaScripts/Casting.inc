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


function heavyleadbowl()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill casting boxes with charcoal, arrange, and fire the casting boxes first before you pin the menu.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Casting/heavyleadbowl.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(690000, "[" .. i .. "/" .. num_loops .. "] Waiting for Heavy Lead Bowl to finish");
	end
end

function monkeywrench()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill casting boxes with charcoal, arrange, and fire the casting boxes first before you pin the menu.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Casting/monkeywrench.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(276000, "[" .. i .. "/" .. num_loops .. "] Waiting for Monkey Wrench to finish");
	end
end


function silverbowl()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill casting boxes with charcoal, arrange, and fire the casting boxes first before you pin the menu.");

	srReadScreen();	

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Casting/silverbowl.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(1035000, "[" .. i .. "/" .. num_loops .. "] Waiting for Silver Bowl to finish");
	end
end

function ironcookpot()

	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill casting boxes with charcoal, arrange, and fire the casting boxes first before you pin the menu.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Casting/Ironcookingpot.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(69000, "[" .. i .. "/" .. num_loops .. "] Waiting for Iron Cookpot to finish");
	end
end

function anvilbed()

	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill casting boxes with charcoal, arrange, and fire the casting boxes first before you pin the menu.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Casting/anvilbed.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(207000, "[" .. i .. "/" .. num_loops .. "] Waiting for Anvil Bed to finish");
	end
end

function orichalcumpellets()

	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill casting boxes with charcoal, arrange, and fire the casting boxes first before you pin the menu.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
				
		-- refresh windows
		clickAll("Casting/fuel.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Casting/orichalcumpellets.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(34500, "[" .. i .. "/" .. num_loops .. "] Waiting for Orichalcum Pellets to finish");
		end
end

function mediumgear()

	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill casting boxes with charcoal, arrange, and fire the casting boxes first before you pin the menu.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
				
		-- refresh windows
		clickAll("Casting/gearwork.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Casting/mediumgear.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(345000, "[" .. i .. "/" .. num_loops .. "] Waiting for Medium Gear to finish");
	end
end

function smallgear()

	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill casting boxes with charcoal, arrange, and fire the casting boxes first before you pin the menu.");
	
	srReadScreen();

		for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
				
		-- refresh windows
		clickAll("Casting/gearwork.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Casting/smallgear.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(69000, "[" .. i .. "/" .. num_loops .. "] Waiting for Small Gear to finish");
	end
end

function bearing()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill casting boxes with charcoal, arrange, and fire the casting boxes first before you pin the menu.");
	
	srReadScreen();

	
	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Casting/hardware.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Casting/bearing.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(138000, "[" .. i .. "/" .. num_loops .. "] Waiting for Bearings to finish");
	end
end

function washers()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill casting boxes with charcoal, arrange, and fire the casting boxes first before you pin the menu.");
	
	srReadScreen();


	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Casting/hardware.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Casting/12washers.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(138000, "[" .. i .. "/" .. num_loops .. "] Waiting for Washers to finish");
	end
end

function bolts()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill casting boxes with charcoal, arrange, and fire the casting boxes first before you pin the menu.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Casting/hardware.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Casting/4bolts.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(138000, "[" .. i .. "/" .. num_loops .. "] Waiting for Bolts to finish");
	end
end

function heavymallethead()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill casting boxes with charcoal, arrange, and fire the casting boxes first before you pin the menu.");
	
	srReadScreen();


	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Casting/Forge_Tools.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Casting/heavymallethead.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(690000, "[" .. i .. "/" .. num_loops .. "] Waiting for Heavy Mallet Head to finish");
	end
end

function widetungstenchisel()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill casting boxes with charcoal, arrange, and fire the casting boxes first before you pin the menu.");
	
	srReadScreen();


	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png");
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Casting/Forge_Tools.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Casting/widetungstenchisel.png");
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(345000, "[" .. i .. "/" .. num_loops .. "] Waiting for Wide Tungsten Chisel to finish");
	end
end

function roundhammer()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill casting boxes with charcoal, arrange, and fire the casting boxes first before you pin the menu.");
	
	srReadScreen();


	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png");
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Casting/Forge_Tools.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Casting/roundhammer.png");
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(345000, "[" .. i .. "/" .. num_loops .. "] Waiting for Round Hammer to finish");
	end
end

function ballpeenhammer()

	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill casting boxes with charcoal, arrange, and fire the casting boxes first before you pin the menu.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
		
		-- refresh windows
		clickAll("Casting/Forge_Tools.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Casting/ballpeenhammer.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(345000, "[" .. i .. "/" .. num_loops .. "] Waiting for Ball Peen Hammer to finish");
	end
end

function shapingmallet()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill casting boxes with charcoal, arrange, and fire the casting boxes first before you pin the menu.");
	
	srReadScreen();


	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png");
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Casting/Forge_Tools.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Casting/shapingmallet.png");
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(345000, "[" .. i .. "/" .. num_loops .. "] Waiting for Shaping Mallet to finish");
	end
end

function leadmallet()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill casting boxes with charcoal, arrange, and fire the casting boxes first before you pin the menu.");
	
	srReadScreen();


	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png");
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Casting/Forge_Tools.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Casting/leadmallet.png");
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(690000, "[" .. i .. "/" .. num_loops .. "] Waiting for Lead Mallet to finish");
	end
end

function pewterincenseprong()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill casting boxes with charcoal, arrange, and fire the casting boxes first before you pin the menu.");
	
	srReadScreen();


	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png");
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Casting/Forge_Tools.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Casting/pewterincenseprong.png");
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(207000, "[" .. i .. "/" .. num_loops .. "] Waiting for Pewter Incense Prong to finish");
	end
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
