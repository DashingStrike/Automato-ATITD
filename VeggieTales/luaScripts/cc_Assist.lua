-- CC Assist by Makazi, based on original multi_click.lua by Jimbly
-- Set ATITD Options -> Interface Options -> High Priority Mode
-- Use Veggietales as a Control Interface for running multiple CC Hearts/Ovens

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

per_click_delay = 10;

button_names = {
"Begin",
"Wood",
"Water",
"Closed",
"Open",
"Full"
};

button2image = {
Begin = "mm_Begin.png",
Wood = "mm_Wood.png",
Water = "mm_Water.png",
Closed = "mm_Vent.png",
Open = "mm_Vent.png",
Full = "mm_Vent.png"
};

button2offset = {
Begin = {20, 10},
Wood = {20-4, 30-2},
Water = {20-5, 30-2},
Closed = {15-9, 30-2},
Open = {40-9, 30-2},
Full = {65-9, 30-2}
};

function click(name)
  if not name then
    return nil;
  end
  local image = button2image[name];
  srReadScreen();
  local buttons = findAllImages(image);
  for i=1, #buttons do
    srClickMouseNoMove(buttons[i][0]+button2offset[name][1],
                       buttons[i][1]+button2offset[name][2]);
    lsSleep(per_click_delay);
  end
  return nil;
end

function doit()
	askForWindow("Script Author: Makazi\nTweaked by: Tallow\n\nPin all charcoal oven/hearts and make sure your ATITD is set to High Priority Mode in Options -> Interface options.");

	while 1 do
		-- Ask for which button
		local image_name = nil;
		local is_done = nil;	
		while not is_done do
			local y = nil;
			local x = nil;
			local bsize = nil;
			for i=1, #button_names do
				if button_names[i] == "Begin" then
					x = 10;
					y = 10;
					bsize = 270;
				elseif button_names[i] == "Wood" then
					x = 10;
					y = 56;
					bsize = 130;
				elseif button_names[i] == "Water" then
					x = 150;
					y = 56;
					bsize = 130;
				elseif button_names[i] == "Closed" then
					x = 10;
					y = 105;
					bsize = 80;
				elseif button_names[i] == "Open" then
					x = 100;
					y = 105;
					bsize = 80;
				elseif button_names[i] == "Full" then
					x = 190;
					y = 105;
					bsize = 80;
				end
				if lsButtonText(x, y, 0, bsize, 0xFFFFFFff, button_names[i]) then
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
		click(image_name);
	end
end
