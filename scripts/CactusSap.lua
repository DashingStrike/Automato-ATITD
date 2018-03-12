-- 
-- CactusSap Collector v1.0 by Larame
-- 

dofile("common.inc");

cactus = {};
collected = 0;

function doit()
	askForWindow("Pin Royal Cactus.");
	srReadScreen();
	cactus = findAllText("This is [a-z]+ Royal Cactus", nil, REGION+REGEX);

	while (1) do
		srReadScreen();
		checkBreak();
		for i=1,#cactus do
			safeClick(cactus[i].x + 4, cactus[i].y + cactus[i].height / 2);
			lsSleep(200);
			srReadScreen();
			text = findText("Collect the sap and Injure the Cactus", cactus[i]);
			if (text ~= nil) then
				clickText(text, true);
				collected = collected + 1;
			end
		end
		sleepWithStatus(4000, "Cactus Sap Collected: " .. collected)
	end
end