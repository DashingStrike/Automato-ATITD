-- run and gather slate  v1.0 by Dunagain

dofile("common.inc");


numSlates = 0

function doit()
	local done = false
	


	askForWindow("Whenever possible, your avatar will collect a slate. You can perform other tasks while the macro is running. You can also minimize VT windows after the macro is started to let it run discreetly.") ;

	while not done	
	do
		sleepWithStatus(5, "Slates collected: " .. tostring(numSlates)) ;
		srReadScreen();
		local pos = srFindImage("slate.png");
		if (pos) then
			safeClick(pos[0] + 3, pos[1] + 3);
			numSlates = numSlates + 1;
		end
	end

end
