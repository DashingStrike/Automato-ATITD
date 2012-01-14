-- CC Assist by Makazi, based on original multi_click.lua by Jimbly
-- Set ATITD Options -> Interface Options -> High Priority Mode
-- Use Veggietales as a Control Interface for running multiple CC Hearts/Ovens

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

per_click_delay = 10;

function ccBegin()
	image_name = "mm_Begin.png"
	srReadScreen();

	local buttons = findAllImages(image_name);
	for i=1, #buttons do
		srClickMouseNoMove(buttons[i][0]+20,buttons[i][1]+10);
		lsSleep(per_click_delay);
	end
end

function addWood()
	image_name = "mm_Wood.png"
	srReadScreen();

	local buttons = findAllImages(image_name);
	for i=1, #buttons do
		srClickMouseNoMove(buttons[i][0]+20,buttons[i][1]+30);
		lsSleep(per_click_delay);
	end
end

function addWater()
	image_name = "mm_Water.png"
	srReadScreen();

	local buttons = findAllImages(image_name);
	for i=1, #buttons do
		srClickMouseNoMove(buttons[i][0]+20,buttons[i][1]+30);
		lsSleep(per_click_delay);
	end
end

function ventLeft()
	image_name = "mm_Vent.png"
	srReadScreen();

	local buttons = findAllImages(image_name);
	for i=1, #buttons do
		srClickMouseNoMove(buttons[i][0]+15,buttons[i][1]+30);
		lsSleep(per_click_delay);
	end
end

function ventCenter()
	image_name = "mm_Vent.png"
	srReadScreen();

	local buttons = findAllImages(image_name);
	for i=1, #buttons do
		srClickMouseNoMove(buttons[i][0]+40,buttons[i][1]+30);
		lsSleep(per_click_delay);
	end
end

function ventRight()
	image_name = "mm_Vent.png"
	srReadScreen();

	local buttons = findAllImages(image_name);
	for i=1, #buttons do
		srClickMouseNoMove(buttons[i][0]+65,buttons[i][1]+30);
		lsSleep(per_click_delay);
	end
end

button_names = {
"Begin",
"Wood",
"Water",
"Closed",
"Open",
"Full"
};

function doit()
	askForWindow("Script Author: Makazi\n\nPin all charcoal oven/hearts and make sure your ATITD is set to High Priority Mode in Options -> Interface options.");

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
				
		if image_name == "Wood" then
			addWood();
		elseif image_name == "Water" then
			addWater();
		elseif image_name == "Closed" then
			ventLeft();
		elseif image_name == "Open" then
			ventCenter();
		elseif image_name == "Full" then
			ventRight();
		elseif image_name == "Begin" then
			ccBegin();
		end

		
	end
end
