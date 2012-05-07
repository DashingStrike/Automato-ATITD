-- Forges v1.2 by Bardoth, Revised by Cegaiel
-- You must manually add charcoal and fire up each forge before pinning them up.
-- Does not take items from forge.

assert(loadfile("luaScripts/common.inc"))();
assert(loadfile("luaScripts/Forge.inc"))();

askText = singleLine([[
  Forges v1.2 (by Bardoth Revised by Cegaiel) --
  Automatically run one or more forges.
  Make sure the VT window is in the TOP-RIGHT
  corner of the screen.
]]);

wmText = "1) Manually add charcoal and light forges.\n2) Make sure forges are lit before pinning!\n3) Tap Ctrl on Forges to open and pin.";

--Global Variables. Dont change!
click_delay = 0;
stalled = 0;
made = 0;
project_windows = 0;


function doit()
  askForWindow(askText);
  windowManager("Forge Setup", wmText);
  unpinOnExit(runForge);
end


function runForge()
	while 1 do
		-- Ask for which button
		local image_name = nil;
		local is_done = nil;	
		while not is_done do
			local y = nil;
			local x = nil;
			local bsize = nil;
			for i=1, #button_names do
				if button_names[i] == "Knife Blade" then
					x = 30;
					y = 10;
					bsize = 130;
				elseif button_names[i] == "Shovel Blade" then
					x = 30;
					y = 40;
					bsize = 130;
				elseif button_names[i] == "Nails" then
					x = 30;
					y = 70;
					bsize = 130;
				elseif button_names[i] == "Copper Pipe" then
					x = 30;
					y = 100;
					bsize = 130;
				elseif button_names[i] == "Lead Pipe" then
					x = 30;
					y = 130;
					bsize = 130;
				elseif button_names[i] == "Bars" then
					x = 30;
					y = 160;
					bsize = 130;
				elseif button_names[i] == "Sheeting" then
					x = 30;
					y = 190;
					bsize = 130;
				elseif button_names[i] == "Straps" then
					x = 30;
					y = 220;
					bsize = 130;
				elseif button_names[i] == "Tools" then
					x = 30;
					y = 250;
					bsize = 130;
				elseif button_names[i] == "Wire" then
					x = 30;
					y = 280;
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
		
		if image_name == "Knife Blade" then
			KnifeBlade();
		elseif image_name == "Shovel Blade" then
			ShovelBlade();
		elseif image_name == "Nails" then
			Nails();
		elseif image_name == "Copper Pipe" then
			CopperPipe();
		elseif image_name == "Lead Pipe" then
			LeadPipe();
		elseif image_name == "Bars" then
			Bars();
		elseif image_name == "Sheeting" then
			Sheeting();
		elseif image_name == "Straps" then
			Straps();
		elseif image_name == "Tools" then
			Tools();
		elseif image_name == "Wire" then
			Wire();
		end
	end
end
