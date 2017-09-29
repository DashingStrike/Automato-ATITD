-- Papyrus Tank, by Silden 03-SEP-17

dofile("screen_reader_common.inc"); -- required for askForWindow function
dofile("common.inc"); -- required for findText function

local papyrusAmount = 7; -- Amount of Papyrus to plant
local papyrusPlanted = false;
local stepCounter = 0;

function doit()
	askForWindow("For Loading Papyrus Tanks. Click on a tank to Plant Papyrus. Will also harvest, but due to the time taken by the system, you may want to just press H on every tank, then use this macro to plant the seeds!");
	
	
	while 1 do
		srReadScreen();
		
		
		
		sleepWithStatus(250, TankStatus());

	end
	
end

function TankStatus()
	papyrusTankLocation = findText("This is a Papyrus Tank", nil, REGION)
	if (not papyrusTankLocation) then
		papyrusPlanted = false;
		return ("Waiting for user to open up a Papyrus Tank");
	end
	
	if (findText("The Papyrus will be ready", nill, REGION)) then
		papyrusPlanted = false;
		return ("This Papyrus Tank is already making papyrus, come back in the time indicated, or select a different Papyrus Tank.");
	end
	
	local HarvestPapyrus = findText("Harvest the Sterile Papyrus");
	if (HarvestPapyrus) then
		srClickMouseNoMove(HarvestPapyrus[0]+25, HarvestPapyrus[1]+5);
		return ("Harvesting the Papyrus");
	end
	
	local PlantPapyrus = findText("Plant Papyrus");
	if (PlantPapyrus) and (not papyrusPlanted) then
		srClickMouseNoMove(PlantPapyrus[0]+25, PlantPapyrus[1]+5);
		sleepWithStatus(250, "Waiting for plant seeds window to show");
		
		srReadScreen();
		srKeyEvent(papyrusAmount);
		lsSleep(50);
		
		okButton = srFindImage("ok-faint.png");
		if (okButton) then
			srClickMouseNoMove(okButton[0], okButton[1]);
			papyrusPlanted = true;
			return ("Papyrus Planted.");
		end
		return "Did not find Ok button";
	end
	
	stepCounter = stepCounter + 1;
	if (stepCounter > 20) then
		-- If user is too quick for the window, reset itself after 5 seconds
		papyrusPlanted = true;
	end
	
	return "Waiting for system to process action.";
end

