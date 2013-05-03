-- run and gather  v1.0 by Dunagain

assert(loadfile("luaScripts/common.inc"))();


numSlates = 0

function doit()
	local done = false
	


	askForWindow("Whenever possible, your avatar will collect a slate. You can perform other tasks while the macro is running. You can also minimize VT windows after the macro is started to let it run discreetly.") ;

	while not done	
	do
		sleepWithStatus(100, "Slates collected: " .. tostring(numSlates)) ;
		srReadScreen();
		local xyWindowSize = srGetWindowSize();
		local midX = xyWindowSize[0] / 2;
		local pos = srFindImageInRange("slate.png",0,0,midX,100,1000);
		if (pos) then
			safeClick(pos[0] + 3, pos[1] + 3);
			numSlates = numSlates + 1;
		end
	end

end
