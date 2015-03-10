-- Clay gatherer by Makazi
-- You need to have camera F8F8 zoomed all the way in,
-- You also need a WH nearby, and water where you start.
-- Start with empty jugs, pin the WH menu and select direction to walk.
-- It always walks in the direction mentioned first on the button.
-- Walking pattern may drift due to lag. Manual correction may be needed from time to time.

dofile("screen_reader_common.inc");
dofile("ui_utils.inc");
dofile("flax_common.inc");

move_delay = 500;
per_click_delay = 10;
WaterJugs = 0;
MaxClay = 0;
ClayCounter = 0;
FillWater = 0;
stashCounter = 0;
FlintCounter = 0;
moveDirection = 0;
moveCounter = 1;
WaterFound = 0;

function moveCharacter()
	srReadScreen();
	local xyCenter = getCenterPos();
	if moveDirection == 0 then
		if directionCounter == 0 then
			srClickMouseNoMove(xyCenter[0]+300, xyCenter[1], 0);
		else
			srClickMouseNoMove(xyCenter[0]-300, xyCenter[1], 0);	
		end
		lsSleep(move_delay);
	end
	if moveDirection == 1 then
		if directionCounter == 0 then
			srClickMouseNoMove(xyCenter[0], xyCenter[1]+300, 0);
		else
			srClickMouseNoMove(xyCenter[0], xyCenter[1]-300, 0);	
		end
		lsSleep(move_delay);
	end
	if moveDirection == 2 then
		if directionCounter == 0 then
			srClickMouseNoMove(xyCenter[0]-300, xyCenter[1], 0);
		else
			srClickMouseNoMove(xyCenter[0]+300, xyCenter[1], 0);	
		end
		lsSleep(move_delay);
	end
	if moveDirection == 3 then
		if directionCounter == 0 then
			srClickMouseNoMove(xyCenter[0], xyCenter[1]-300, 0);
		else
			srClickMouseNoMove(xyCenter[0], xyCenter[1]+300, 0);	
		end
		lsSleep(move_delay);
	end
	if moveCounter < 5 then
		directionCounter = 1;
	else
		directionCounter = 0;
	end
	if moveCounter > 8 then
		moveCounter = 0;
	else
		moveCounter = moveCounter + 1;
	end
end


function clickImage()
	if image_name == "UnPin.png" then
		x=30;
		y=30;
	elseif image_name == "gathermud.png" then
		x=150;
		y=90;
	else
		x=9;
		y=9;
	end
	
	srReadScreen();
	xyWindowSize = srGetWindowSize();	
	local buttons = findAllImages(image_name);
	if #buttons == 0 then
		statusScreen("Searching for " .. image_name .. "...");
		lsSleep(per_click_delay);
		if image_name == "water.png" then
			moveCharacter();
		end
	else
		for i=1, #buttons do
			srClickMouseNoMove(buttons[i][0]+x, buttons[i][1]+y, right_click);
			lsSleep(per_click_delay);
		end
		statusScreen(image_name .. " found and clicked.");
		lsSleep(per_click_delay);		
		if image_name == "clay.png" then
			statusScreen("Collecting clay..");
			ClayCounter = ClayCounter + 1;
			FillWater = FillWater + 1;
			lsSleep(per_click_delay);
		end
		if image_name == "stash.png" then
			stashCounter = stashCounter + 1;
			lsSleep(200);
		elseif image_name == "stashClay.png" then	
			stashCounter = stashCounter + 1;
			lsSleep(200);
		elseif image_name == "stashFlint.png" then
			stashCounter = stashCounter + 1;
			lsSleep(200);
		end
		if image_name == "water.png" then
			WaterFound = 1;
		end
	end	
end


function whStash()
-- First, press the Stash option on the pinned warehouse menu
	image_name = "stash.png"
	while stashCounter == 0 do
		clickImage();
	end
	
-- Then stash the Clay
	image_name = "stashClay.png"
	while stashCounter == 1 do
		clickImage();
	end
	image_name = "maxButton.png"
	clickImage();
	
-- Repeat and stash the Flint before returning to gathering
	image_name = "stash.png"
	while stashCounter == 2 do
		clickImage();
	end
	
	image_name = "stashFlint.png"
	while stashCounter == 3 and FlintCounter < 5 do
		clickImage();
		FlintCounter = FlintCounter + 1;
	end
	if FlintCounter < 5 then
		image_name = "maxButton.png"
		clickImage();
	else
		image_name = "UnPin.png"
		clickImage();
	end

-- Reset the counters
	FlintCounter = 0;
	ClayCounter = 0;
	stashCounter = 0;
end

function fillWater()
	move_delay = 500;
	statusScreen("Filling jugs with water..");
	image_name = "water.png";
	while WaterFound == 0 do
		clickImage();
	end
	lsSleep(200);
	image_name = "maxButton.png";
	clickImage();
	WaterFound = 0;
	FillWater = 0;
	lsSleep(4000);
	move_delay = 5;
end


function doit()
-- Ask about how many waterjugs you are carrying

	while WaterJugs < 1 do
		WaterJugs = promptNumber("How many jugs?");
	end
	
	FillWater = WaterJugs;
	
-- Ask about how much clay to gather before stashing

	while MaxClay < 1 do
		MaxClay =promptNumber("Amount of Clay before stash?");
	end

-- Ask what direction your character should move
	while not is_done do
	statusScreen("Select line of direction.");
		if lsButtonText(10, 100, 0, 250, 0xFFFFFFff, "West - East") then
			moveDirection = 0;
			is_done = 1;
		end
		if lsButtonText(10, 140, 0, 250, 0xFFFFFFff, "North - South") then
			moveDirection = 1;
			is_done = 1;
		end
		if lsButtonText(10, 180, 0, 250, 0xFFFFFFff, "East - West") then
			moveDirection = 2;
			is_done = 1;
		end
		if lsButtonText(10, 220, 0, 250, 0xFFFFFFff, "South - North") then
			moveDirection = 3;
			is_done = 1;
		end
	end
	
-- Get ATITD window	
	askForWindow("Script Author: Makazi\n\nStand in a place with both Clay and Water icon (start with empty jugs), and Warehouse close enough to stash and pin Warehouse menu.");


-- Start gathering, stashing and filling water
				
	while 1 do
		if ClayCounter == MaxClay then
			whStash();
		end
		if FillWater == WaterJugs then
			lsSleep(200);
			fillWater();			
		else
			image_name = "clay.png"
			clickImage();
		end
		moveCharacter();

-- Check if it accidently hit the Mud icon
		image_name="gathermud.png";
		clickImage();
	end
end
