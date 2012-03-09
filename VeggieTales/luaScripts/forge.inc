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


function KnifeBlade()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Knife_Blade.png", 1);
		lsSleep(200);
		-- refocus();
		--10 Min
		sleepWithStatus(690000, "[" .. i .. "/" .. num_loops .. "] Waiting for Knife Blades to finish");
	end
end

function ShovelBlade()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge/Forge_Shovel_Blade.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(345000, "[" .. i .. "/" .. num_loops .. "] Waiting for Shovel Blades to finish");
	end
end


function Nails()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill with charcoal, arrange, and pin the forges first before you light the fire.");

	srReadScreen();	

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Nail.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(69000, "[" .. i .. "/" .. num_loops .. "] Waiting for nails to finish");
	end
end

function CopperPipe()

	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Copper_Pipe.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(345000, "[" .. i .. "/" .. num_loops .. "] Waiting for Copper Pipe to finish");
	end
end

function LeadPipe()

	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Lead_Pipe.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(345000, "[" .. i .. "/" .. num_loops .. "] Waiting for Lead Pipe to finish");
	end
end

function IronBar()

	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
				
		-- refresh windows
		clickAll("Forge/Forge_Bars.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Iron_Bar.png", 1);
		lsSleep(200);
		-- refocus();
		--15 Min
		sleepWithStatus(1035000, "[" .. i .. "/" .. num_loops .. "] Waiting for Iron Bars to finish");
		end
end

function GoldBar()

	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
				
		-- refresh windows
		clickAll("Forge/Forge_Bars.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Gold_Bar.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(345000 "[" .. i .. "/" .. num_loops .. "] Waiting for Gold Bars to finish");
	end
end

function SilverBar()

	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

		for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
				
		-- refresh windows
		clickAll("Forge/Forge_Bars.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Silver_Bar.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(690000, "[" .. i .. "/" .. num_loops .. "] Waiting for Silver Bars to finish");
	end
end

function LeadSheeting()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	--local buttons = findAllImages(image_name);
	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Forge/Forge_Sheeting.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Lead_Sheeting.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(69000, "[" .. i .. "/" .. num_loops .. "] Waiting for Lead Sheeting to finish");
	end
end

function GoldSheeting()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	--local buttons = findAllImages(image_name);
	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Forge/Forge_Sheeting.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Gold_Sheeting.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(69000, "[" .. i .. "/" .. num_loops .. "] Waiting for Gold Sheeting to finish");
	end
end

function CopperSheeting()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	--local buttons = findAllImages(image_name);
	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Forge/Forge_Sheeting.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Copper_Sheeting.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(69000, "[" .. i .. "/" .. num_loops .. "] Waiting for Copper Sheeting to finish");
	end
end

function OctecsAlloySheeting()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	--local buttons = findAllImages(image_name);
	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Forge/Forge_Sheeting.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Octecs_Alloy_Sheeting.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(1380000, "[" .. i .. "/" .. num_loops .. "] Waiting for Octecs Alloy Sheeting to finish");
	end
end

function SilverSheeting()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	--local buttons = findAllImages(image_name);
	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png");
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Forge/Forge_Sheeting.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Silver_Sheeting.png");
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(138000, "[" .. i .. "/" .. num_loops .. "] Waiting for Silver Sheeting to finish");
	end
end

function SteelSheeting()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	--local buttons = findAllImages(image_name);
	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png");
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Forge/Forge_Sheeting.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Steel_Sheeting.png");
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(690000, "[" .. i .. "/" .. num_loops .. "] Waiting for Steel Sheeting to finish");
	end
end

function GoldFoil()

	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
		
		-- refresh windows
		clickAll("Forge/Forge_Sheeting.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Gold_Foil.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(69000, "[" .. i .. "/" .. num_loops .. "] Waiting for Gold Foil to finish");
	end
end

function MetalBlueSheeting()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	--local buttons = findAllImages(image_name);
	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png");
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Forge/Forge_Sheeting.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Metal_Blue_Sheeting.png");
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(1035000, "[" .. i .. "/" .. num_loops .. "] Waiting for Metal Blue Sheeting to finish");
	end
end

function TinSheeting()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	--local buttons = findAllImages(image_name);
	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png");
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Forge/Forge_Sheeting.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Tin_Sheeting.png");
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(345000, "[" .. i .. "/" .. num_loops .. "] Waiting for Tin Sheeting to finish");
	end
end

function MoonSteelSheeting()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	--local buttons = findAllImages(image_name);
	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png");
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Forge/Forge_Sheeting.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Moon_Steel_Sheeting.png");
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(345000, "[" .. i .. "/" .. num_loops .. "] Waiting for Moon Steel Sheeting to finish");
	end
end

function ThothsMetalSheeting()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	--local buttons = findAllImages(image_name);
	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png");
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Forge/Forge_Sheeting.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Thoths_Metal_Sheeting.png");
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(690000, "[" .. i .. "/" .. num_loops .. "] Waiting for Thoths Metal Sheeting to finish");
	end
end

function WaterMetalStrap()

	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

		for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
				
		-- refresh windows
		clickAll("Forge/Forge_Straps.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Water_Metal_Strap.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(69000, "[" .. i .. "/" .. num_loops .. "] Waiting for Water Metal Straps to finish");
		end
end

function IronStrap()

	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

		for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
				
		-- refresh windows
		clickAll("Forge/Forge_Straps.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Iron_Strap.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(207000, "[" .. i .. "/" .. num_loops .. "] Waiting for Iron Straps to finish");
		end
end

function AluminumStrap()

	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

		for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
				
		-- refresh windows
		clickAll("Forge/Forge_Straps.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Aluminum_Strap.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(69000, "[" .. i .. "/" .. num_loops .. "] Waiting for Aluminum Straps to finish");
		end
end
	
function CopperStrap()

	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

		for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
				
		-- refresh windows
		clickAll("Forge/Forge_Straps.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Copper_Strap.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(138000, "[" .. i .. "/" .. num_loops .. "] Waiting for Copper Straps to finish");
		end
end

function IronPoker()

	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

		for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
				
		-- refresh windows
		clickAll("Forge/Forge_Tools.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Iron_Poker.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(1380000, "[" .. i .. "/" .. num_loops .. "] Waiting for Iron Pokers to finish");
		end
end

function SteelBlade()

	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

		for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
				
		-- refresh windows
		clickAll("Forge/Forge_Tools.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Steel_Blade.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(690000, "[" .. i .. "/" .. num_loops .. "] Waiting for Steel Blades to finish");
		end
end
	
function LeadChisel()

	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

		for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
				
		-- refresh windows
		clickAll("Forge/Forge_Bars.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Lead_Chisel.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(414000, "[" .. i .. "/" .. num_loops .. "] Waiting for Lead Chisels to finish");
		end
end

function ThothsMetalWire()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	--local buttons = findAllImages(image_name);
	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Forge/Forge_Wire.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Thoths_Metal_Wire.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(345000, "[" .. i .. "/" .. num_loops .. "] Waiting for Thoths Metal Wire to finish");
	end
end

function MetalBlueWire()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	--local buttons = findAllImages(image_name);
	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Forge/Forge_Wire.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Metal_Blue_Wire.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(345000, "[" .. i .. "/" .. num_loops .. "] Waiting for Metal Blue Wire to finish");
	end
end

function MagnesiumWire()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	--local buttons = findAllImages(image_name);
	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Forge/Forge_Wire.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Magnesium_Wire.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(69000, "[" .. i .. "/" .. num_loops .. "] Waiting for Magnesium Wire to finish");
	end
end

function OctecsAlloyWire()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	--local buttons = findAllImages(image_name);
	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Forge/Forge_Wire.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Octecs_Alloy_Wire.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(690000, "[" .. i .. "/" .. num_loops .. "] Waiting for Octecs Alloy Wire to finish");
	end
end

function SilverWire()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	--local buttons = findAllImages(image_name);
	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Forge/Forge_Wire.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Silver_Wire.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(345000, "[" .. i .. "/" .. num_loops .. "] Waiting for Silver Wire to finish");
	end
end

function CopperWire()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	--local buttons = findAllImages(image_name);
	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Forge/Forge_Wire.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Copper_Wire.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(345000, "[" .. i .. "/" .. num_loops .. "] Waiting for Copper Wire to finish");
	end
end

function SteelWire()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	--local buttons = findAllImages(image_name);
	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Forge/Forge_Wire.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Steel_Wire.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(345000, "[" .. i .. "/" .. num_loops .. "] Waiting for Steel Wire to finish");
	end
end

function GoldWire()
	num_loops = promptNumber("How many passes ?", 100);
	askForWindow("Fill forges with charcoal, arrange, and fire the forges first before you pin the menu.");
	
	srReadScreen();

	--local buttons = findAllImages(image_name);
	for i=1, num_loops do
		window_locs = findAllImages("This.png");

		-- refresh windows
		clickAll("This.png", 1);
		lsSleep(200);
		-- refocus();
			
		-- refresh windows
		clickAll("Forge/Forge_Wire.png", 1);
		lsSleep(200);
		-- refocus();
		
		clickAll("Forge/Forge_Gold_Wire.png", 1);
		lsSleep(200);
		-- refocus();
		
		sleepWithStatus(690000, "[" .. i .. "/" .. num_loops .. "] Waiting for Gold Wire to finish");
	end
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
