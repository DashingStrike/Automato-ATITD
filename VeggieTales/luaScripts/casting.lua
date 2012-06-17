-- Casting Box v1.1 by Bardoth, Revised by Cegaiel
-- You must manually add charcoal and fire up each casting box before pinning them up.
-- Does not take items from casting box.

assert(loadfile("luaScripts/common.inc"))();
assert(loadfile("luaScripts/casting.inc"))();

askText = singleLine([[
  Casting Box v1.2 (by Bardoth Revised by Cegaiel) --
  Automatically run one or more casting boxes.
  Make sure the VT window is in the TOP-RIGHT
  corner of the screen.
]]);

wmText = "1) Manually add charcoal and light CB\'s.\n2) Make sure CB\'s are lit before pinning!\n3) Tap Ctrl on CB\'s to open and pin.";

--Global Variables. Dont change!
click_delay = 0;
stalled = 0;
made = 0;
project_windows = 0;


function doit()
  askForWindow(askText);
  windowManager("Casting Box Setup", wmText);
  unpinOnExit(runCasting);
end


function runCasting()
	while 1 do
		-- Ask for which button
		local image_name = nil;
		local is_done = nil;	
		while not is_done do
			local y = nil;
			local x = nil;
			local bsize = nil;
			for i=1, #button_names do
				if button_names[i] == "Heavy Lead Bowl" then
					x = 30;
					y = 10;
					bsize = 130;
				elseif button_names[i] == "Monkey Wrench" then
					x = 30;
					y = 40;
					bsize = 130;
				elseif button_names[i] == "Silver Bowl" then
					x = 30;
					y = 70;
					bsize = 130;
				elseif button_names[i] == "Iron Cookpot" then
					x = 30;
					y = 100;
					bsize = 130;
				elseif button_names[i] == "Anvil Bed" then
					x = 30;
					y = 130;
					bsize = 130;
				elseif button_names[i] == "Fuel" then
					x = 30;
					y = 160;
					bsize = 130;
				elseif button_names[i] == "Gearwork" then
					x = 30;
					y = 190;
					bsize = 130;
				elseif button_names[i] == "Hardware" then
					x = 30;
					y = 220;
					bsize = 130;
				elseif button_names[i] == "Tools" then
					x = 30;
					y = 250;
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
		
		if image_name == "Heavy Lead Bowl" then
			heavyleadbowl();
		elseif image_name == "Monkey Wrench" then
			monkeywrench();
		elseif image_name == "Silver Bowl" then
			silverbowl();
		elseif image_name == "Iron Cookpot" then
			ironcookpot();
		elseif image_name == "Anvil Bed" then
			anvilbed();
		elseif image_name == "Fuel" then
			fuel();
		elseif image_name == "Gearwork" then
			gearwork();
		elseif image_name == "Hardware" then
			hardware();
		elseif image_name == "Tools" then
			tools();
		end
	end
end
