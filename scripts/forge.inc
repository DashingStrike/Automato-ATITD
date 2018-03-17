button_names = {
"Knife Blade",
"Shovel Blade",
"Nails",
"Copper Pipe",
"Lead Pipe",
"Bars",
"Sheeting",
"Straps",
"Tools",
"Wire"
};

bar_button_names = {
"Iron Bar",
"Gold Bar",
"Silver Bar"
};

sheeting_button_names = {
"Lead Sheeting",
"Gold Sheeting",
"Copper Sheeting",
"Octecs Alloy Sheeting",
"Silver Sheeting",
"Steel Sheeting",
"Gold Foil",
"Metal Blue Sheeting",
"Treated Metal Sheeting",
"Tin Sheeting",
"Moon Steel Sheeting",
"Thoths Metal Sheeting"
};

straps_button_names = {
"Water Metal Strap",
"Iron Strap",
"Aluminum Strap",
"Copper Strap"
};

tools_button_names = {
"Iron Poker",
"Steel Blade",
"Lead Chisel"
};

wire_button_names = {
"Thoths Metal Wire",
"Metal Blue Wire",
"Magnesium Wire",
"Octecs Alloy Wire",
"Silver Wire",
"Copper Wire",
"Steel Wire",
"Gold Wire"
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
clickAllImages("This.png"); -- Refresh the screen. Update forge window so we know how much charcoal is currently in each forge before next project

sleepWithStatus(wait, "[" .. totalPasses .. "/" .. totalPasses .. "] ALL DONE!\n----------------------------------------------\n[" .. made .. "/" .. batch*project_windows*num_loops .. "] " .. name .. " / Completed");

lsPlaySound("Complete.wav");
runForge(); -- Return to/Display Main Menu
end


function waitGUI(pass)
	--If any forge menus shows the Forge_StartFire.png - refreshWindows() function, then display the stalledMessage in the GUI. Suggests its not lit (or out of charcoal)
	if #stalled > 0 then
	stalledMessage = "\n[" .. #stalled .. "] Forges STALLED (Needs Lit)"
	else
	stalledMessage = "";
	end

sleepWithStatus(wait, "[" .. pass .. "/" .. num_loops .. "] Total Passes\n----------------------------------------------\n[" .. batch .. "] " .. name .. " per forge\n[" .. project_windows .. "] Forges working" .. stalledMessage .. "\n----------------------------------------------\n[" .. batch*project_windows .. "] " .. name .. " per pass\n----------------------------------------------\n[" .. made .. "/" .. batch*project_windows*num_loops .. "] " .. name .. " / Completed");

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
			if #stalled == pinned_windows/2 then -- The /2 is because each forge has 'This' located in window twice. Can't use ThisIs.png either because idle/working forge has different words (Idle Forge shows 'This' only and Working Forge shows 'This Is'
			error("No forges are lit!");
			end
		end
end


----------------- MAKE PROJECT FUNCTIONS -----------------

function KnifeBlade()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Knife Blade";
	waitMinutes(10);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			project_windows = clickAllImages("Forge/Forge_Knife_Blade.png");
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

function ShovelBlade()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Shovel Blade";
	waitMinutes(5);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			project_windows = clickAllImages("Forge/Forge_Shovel_Blade.png");
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

function Nails()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 12;
	name = "Nails";
	waitMinutes(1);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			project_windows = clickAllImages("Forge/Forge_Nail.png");
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

function CopperPipe()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Copper Pipe";
	waitMinutes(5);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			project_windows = clickAllImages("Forge/Forge_Copper_Pipe.png");
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

function LeadPipe()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Lead Pipe";
	waitMinutes(5);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			project_windows = clickAllImages("Forge/Forge_Lead_Pipe.png");
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

function IronBar()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Iron Bar";
	waitMinutes(15);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Bars.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Iron_Bar.png");
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

function GoldBar()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Gold Bar";
	waitMinutes(5);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Bars.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Gold_Bar.png");
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

function SilverBar()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Silver Bar";
	waitMinutes(10);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Bars.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Silver_Bar.png");
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

function LeadSheeting()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Lead Sheeting";
	waitMinutes(10);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Sheeting.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Lead_Sheeting.png");
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

function GoldSheeting()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 4;
	name = "Gold Sheeting";
	waitMinutes(10);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Sheeting.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Gold_Sheeting.png");
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

function CopperSheeting()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Copper Sheeting";
	waitMinutes(1);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Sheeting.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Copper_Sheeting.png");
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

function TreatedSheeting()
	num_loops = promptNumber("How many passes ?", 1);
	typeOfMetal = promptText("Enter the metal name:");
	batch = 1;
	name = "Treated Metal Sheeting";
	waitMinutes(2);
		for i=1, num_loops do
			while 1 do
				refreshWindows();
				clickAllImages("Forge/Forge_Sheeting.png");
				lsSleep(400);
				project_windows = clickAllText("Treated");
				if project_windows == 0 then
					sleepWithStatus(1100, "Waiting for Project windows");
				else
					lsSleep(400);
					local numClicked = clickAllText(typeOfMetal);
					if numClicked == 0 then
						break;
					end
				end
			end
			waitGUI(i);
		end
	doneGUI(num_loops);
end

function OctecsAlloySheeting()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 8;
	name = "Octecs Alloy";
	waitMinutes(20);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Sheeting.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Octecs_Alloy_Sheeting.png");
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

function SilverSheeting()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Silver Sheeting";
	waitMinutes(2);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Sheeting.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Silver_Sheeting.png");
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

function SteelSheeting()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 6;
	name = "Steel Sheeting";
	waitMinutes(10);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Sheeting.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Steel_Sheeting.png");
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

function GoldFoil()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 4;
	name = "Gold Foil";
	waitMinutes(1);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Sheeting.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Gold_Foil.png");
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

function MetalBlueSheeting()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Metal Blue Sheeting";
	waitMinutes(15);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Sheeting.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Metal_Blue_Sheeting.png");
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

function TinSheeting()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Tin Sheeting";
	waitMinutes(5);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Sheeting.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Tin_Sheeting.png");
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

function MoonSteelSheeting()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Moon Steel Sheeting";
	waitMinutes(5);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Sheeting.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Moon_Steel_Sheeting.png");
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

function ThothsMetalSheeting()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Thoths Metal Sheeting";
	waitMinutes(10);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Sheeting.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Thoths_Metal_Sheeting.png");
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

function WaterMetalStrap()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Water Metal Strap";
	waitMinutes(1);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Straps.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Water_Metal_Strap.png");
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

function IronStrap()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Iron Strap";
	waitMinutes(3);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Straps.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Iron_Strap.png");
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

function AluminumStrap()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Aluminum Strap";
	waitMinutes(1);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Straps.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Aluminum_Strap.png");
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
	
function CopperStrap()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Copper Strap";
	waitMinutes(2);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Straps.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Copper_Strap.png");
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

function IronPoker()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Iron Poker";
	waitMinutes(20);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Tools.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Iron_Poker.png");
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

function SteelBlade()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Steel Blade";
	waitMinutes(10);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Tools.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Steel_Blade.png");
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
	
function LeadChisel()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 1;
	name = "Lead Chisel";
	waitMinutes(6);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Tools.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Lead_Chisel.png");
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

function ThothsMetalWire()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 14;
	name = "Thoths Metal Wire";
	waitMinutes(5);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Wire.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Thoths_Metal_Wire.png");
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

function MetalBlueWire()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 12;
	name = "Metal Blue Wire";
	waitMinutes(5);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Wire.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Metal_Blue_Wire.png");
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

function MagnesiumWire()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 10;
	name = "Magnesium Wire";
	waitMinutes(1);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Wire.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Magnesium_Wire.png");
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

function OctecsAlloyWire()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 16;
	name = "Octecs Alloy Wire";
	waitMinutes(10);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Wire.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Octecs_Alloy_Wire.png");
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

function SilverWire()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 5;
	name = "Silver Wire";
	waitMinutes(5);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Wire.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Silver_Wire.png");
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

function CopperWire()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 20;
	name = "Copper Wire";
	waitMinutes(5);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Wire.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Copper_Wire.png");
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

function SteelWire()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 20;
	name = "Steel Wire";
	waitMinutes(5);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Wire.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Steel_Wire.png");
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

function GoldWire()
	num_loops = promptNumber("How many passes ?", 1);
	batch = 10;
	name = "Gold Wire";
	waitMinutes(10);
		for i=1, num_loops do
			while 1 do
			refreshWindows();
			clickAllImages("Forge/Forge_Wire.png");
			lsSleep(400);
			project_windows = clickAllImages("Forge/Forge_Gold_Wire.png");
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


function Bars()
	while 1 do
		-- Ask for which button
		local image_name = nil;
		local is_done = nil;	
		while not is_done do
			local y = nil;
			local x = nil;
			local bsize = nil;
			for i=1, #bar_button_names do
				if bar_button_names[i] == "Iron Bar" then
					x = 30;
					y = 10;
					bsize = 250;
				elseif bar_button_names[i] == "Gold Bar" then
					x = 30;
					y = 40;
					bsize = 250;
				elseif bar_button_names[i] == "Silver Bar" then
					x = 30;
					y = 70;
					bsize = 250;
				end
				if lsButtonText(x, y, 0, bsize, 0x80D080ff, bar_button_names[i]) then
					image_name = bar_button_names[i];
					is_done = 1;
				end
			end

			if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
				error "Clicked End Script button";
			end
			lsDoFrame();
			lsSleep(10);
		end	
		
		if image_name == "Iron Bar" then
			IronBar();
		elseif image_name == "Gold Bar" then
			GoldBar();
		elseif image_name == "Silver Bar" then
			SilverBar();
		end
	end
end

function Sheeting()
	while 1 do
		-- Ask for which button
		local image_name = nil;
		local is_done = nil;	
		while not is_done do
			local y = nil;
			local x = nil;
			local bsize = nil;
			for i=1, #sheeting_button_names do
				if sheeting_button_names[i] == "Lead Sheeting" then
					x = 30;
					y = 10;
					bsize = 150;
				elseif sheeting_button_names[i] == "Gold Sheeting" then
					x = 30;
					y = 35;
					bsize = 150;
				elseif sheeting_button_names[i] == "Copper Sheeting" then
					x = 30;
					y = 60;
					bsize = 150;
        elseif sheeting_button_names[i] == "Treated Metal Sheeting" then
					x = 30;
					y = 285;
					bsize = 150;
				elseif sheeting_button_names[i] == "Octecs Alloy Sheeting" then
					x = 30;
					y = 85;
					bsize = 150;
				elseif sheeting_button_names[i] == "Silver Sheeting" then
					x = 30;
					y = 110;
					bsize = 150;
				elseif sheeting_button_names[i] == "Steel Sheeting" then
					x = 30;
					y = 135;
					bsize = 150;
				elseif sheeting_button_names[i] == "Gold Foil" then
					x = 30;
					y = 160;
					bsize = 150;
				elseif sheeting_button_names[i] == "Metal Blue Sheeting" then
					x = 30;
					y = 185;
					bsize = 150;
				elseif sheeting_button_names[i] == "Tin Sheeting" then
					x = 30;
					y = 210;
					bsize = 150;
				elseif sheeting_button_names[i] == "Moon Steel Sheeting" then
					x = 30;
					y = 235;
					bsize = 150;
				elseif sheeting_button_names[i] == "Thoths Metal Sheeting" then
					x = 30;
					y = 260;
					bsize = 150;
				end
				if lsButtonText(x, y, 0, 250, 0x80D080ff, sheeting_button_names[i]) then
					image_name = sheeting_button_names[i];
					is_done = 1;
				end
			end

			if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
				error "Clicked End Script button";
			end
			lsDoFrame();
			lsSleep(10);
		end	
		
		if image_name == "Lead Sheeting" then
			LeadSheeting();
		elseif image_name == "Gold Sheeting" then
			GoldSheeting();
		elseif image_name == "Copper Sheeting" then
			CopperSheeting();
    elseif image_name == "Treated Metal Sheeting" then
			TreatedSheeting();
		elseif image_name == "Octecs Alloy Sheeting" then
			OctecsAlloySheeting();
		elseif image_name == "Silver Sheeting" then
			SilverSheeting();
		elseif image_name == "Steel Sheeting" then
			SteelSheeting();
		elseif image_name == "Gold Foil" then
			GoldFoil();
		elseif image_name == "Metal Blue Sheeting" then
			MetalBlueSheeting();
		elseif image_name == "Tin Sheeting" then
			TinSheeting();
		elseif image_name == "Moon Steel Sheeting" then
			MoonSteelSheeting();
		elseif image_name == "Thoths Metal Sheeting" then
			ThothsMetalSheeting();
		end
	end


end

function Straps()
	while 1 do
		-- Ask for which button
		local image_name = nil;


		local is_done = nil;	
		while not is_done do
			local y = nil;
			local x = nil;
			local bsize = nil;
			for i=1, #straps_button_names do
				if straps_button_names[i] == "Water Metal Strap" then
					x = 30;
					y = 10;
					bsize = 250;
				elseif straps_button_names[i] == "Iron Strap" then
					x = 30;
					y = 40;
					bsize = 250;
				elseif straps_button_names[i] == "Aluminum Strap" then
					x = 30;
					y = 70;
					bsize = 250;
				elseif straps_button_names[i] == "Copper Strap" then
					x = 30;
					y = 100;
					bsize = 250;
				end
				if lsButtonText(x, y, 0, bsize, 0x80D080ff, straps_button_names[i]) then
					image_name = straps_button_names[i];
					is_done = 1;
				end
			end

			if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
				error "Clicked End Script button";
			end
			lsDoFrame();
			lsSleep(10);
		end	
		
		if image_name == "Water Metal Strap" then
			WaterMetalStrap();
		elseif image_name == "Iron Strap" then
			IronStrap();
		elseif image_name == "Aluminum Strap" then
			AluminumStrap();
		elseif image_name == "Copper Strap" then
			CopperStrap();
		end
	end
end

function Tools()
	while 1 do
		-- Ask for which button
		local image_name = nil;
		local is_done = nil;	
		while not is_done do
			local y = nil;
			local x = nil;
			local bsize = nil;
			for i=1, #tools_button_names do
				if tools_button_names[i] == "Iron Poker" then
					x = 30;
					y = 10;
					bsize = 250;
				elseif tools_button_names[i] == "Steel Blade" then
					x = 30;
					y = 40;
					bsize = 250;
				elseif tools_button_names[i] == "Lead Chisel" then
					x = 30;
					y = 70;
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
		
		if image_name == "Iron Poker" then
			IronPoker();
		elseif image_name == "Steel Blade" then
			SteelBlade();
		elseif image_name == "Lead Chisel" then
			LeadChisel();
		end
	end
end

function Wire()
	while 1 do
		-- Ask for which button
		local image_name = nil;
		local is_done = nil;	
		while not is_done do
			local y = nil;
			local x = nil;
			local bsize = nil;
			for i=1, #wire_button_names do
				if wire_button_names[i] == "Thoths Metal Wire" then
					x = 30;
					y = 10;
					bsize = 150;
				elseif wire_button_names[i] == "Metal Blue Wire" then
					x = 30;
					y = 35;
					bsize = 150;
				elseif wire_button_names[i] == "Magnesium Wire" then
					x = 30;
					y = 60;
					bsize = 150;
				elseif wire_button_names[i] == "Octecs Alloy Wire" then
					x = 30;
					y = 85;
					bsize = 150;
				elseif wire_button_names[i] == "Silver Wire" then
					x = 30;
					y = 110;
					bsize = 150;
				elseif wire_button_names[i] == "Copper Wire" then
					x = 30;
					y = 135;
					bsize = 150;
				elseif wire_button_names[i] == "Steel Wire" then
					x = 30;
					y = 160;
					bsize = 150;
				elseif wire_button_names[i] == "Gold Wire" then
					x = 30;
					y = 185;
					bsize = 150;
				end
				if lsButtonText(x, y, 0, 250, 0x80D080ff, wire_button_names[i]) then
					image_name = wire_button_names[i];
					is_done = 1;
				end
			end

			if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
				error "Clicked End Script button";
			end
			lsDoFrame();
			lsSleep(10);
		end	
		
		if image_name == "Thoths Metal Wire" then
			ThothsMetalWire();
		elseif image_name == "Metal Blue Wire" then
			MetalBlueWire();
		elseif image_name == "Magnesium Wire" then
			MagnesiumWire();
		elseif image_name == "Octecs Alloy Wire" then
			OctecsAlloyWire();
		elseif image_name == "Silver Wire" then
			SilverWire();
		elseif image_name == "Copper Wire" then
			CopperWire();
		elseif image_name == "Steel Wire" then
			SteelWire();
		elseif image_name == "Gold Wire" then
			GoldWire();
		end
	end
end
