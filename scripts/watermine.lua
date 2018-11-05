--
-- 
--

dofile("common.inc");

wind_time = 7920000;  	-- 2 hours teppy time
check_time = 10000;   	-- 10 seconds

do_initial_wind = 1;  	-- default
do_wind = 1;		-- default

srdelay = 100;  	--how long to wait after interacting before assuming the screen has finished changing
delay   = 100;  	--how long to wait when busy waiting

function doit()
	promptOptions();
	askForWindow("\nPin a WaterMine and hit shift\n	\nstay in range of the water mine, doing whatever you want.\n	\nIf you leave the area, the macro will keep running till it's time to wind again. When you get back in range, just click on the water mine screen to refresh it, and the macro will continue without problems.\nThe macro will error out if you're not in range of the mine when the time comes to wind it up. ");
	wind_timer = -1 - wind_time;
	gems = 0;

	initial_start_time = lsGetTimer();
	while 1 do
		local start_time = lsGetTimer();
		gems = gems + trygem();
		wind_timer = wind(wind_timer);
		while ((lsGetTimer() - start_time) < check_time) do
				time_left = check_time - (lsGetTimer() - start_time);
				time_left2 = wind_time - (lsGetTimer() - wind_timer);
				if (do_wind) then
					statusScreen("Gems found: " .. gems .. "\nTotal runtime: " .. timestr(lsGetTimer() - initial_start_time) .. "\nChecking in " .. timestr(time_left) .. "\nWinding in " .. timestr(time_left2));
				else
					statusScreen("Gems found: " .. gems .. "\nTotal runtime: " .. timestr(lsGetTimer() - initial_start_time) .. "\nChecking in " .. timestr(time_left) .. "\nNot Winding");

				end
				lsSleep(delay);
				checkBreak();
		end
	end
end

function wind (wind_timer)
	if (do_wind) then
	    if (do_initial_wind) then
		if ((lsGetTimer() - wind_timer) < wind_time) then
			return wind_timer;
		else
			srReadScreen();
			Windthe = srFindImage("Windthecollarspring.png");
			if Windthe then
				srClickMouseNoMove(Windthe[0]+5, Windthe[1]+5);
				lsSleep(srdelay)
				return lsGetTimer();
			else
				error 'Could not find WaterMine Wind location';
			end
		end
	    else
		do_initial_wind = 1;
		return lsGetTimer();
	    end

	else
		return 0; 
	end
end

function trygem ()
	srReadScreen();
	touch = srFindImage("ThisisaWaterMine.png");
	if (touch) then -- Don't error if we can't find it.  Assume the user will come back to the mine and touch the screen himself.
		srClickMouseNoMove(touch[0],touch[1]);
	end
	lsSleep(srdelay);
	srReadScreen();
	Takethe = srFindImage("Takethe.png");
	if Takethe then
		srClickMouseNoMove(Takethe[0]+5, Takethe[1]+5);
		lsSleep(srdelay)
		return 1;
	else 
		return 0;
	end

end



function promptOptions()
	scale = 1.0;
	
	local z = 0;
	local is_done = nil;
	local value = nil;
	-- Edit box and text display
	while not is_done do
		-- Put these everywhere to make sure we don't lock up with no easy way to escape!
		checkBreak("disallow pause");
		
		lsPrint(10, 10, z, scale, scale, 0xFFFFFFff, "Choose Options");
		
		-- lsEditBox needs a key to uniquely name this edit box
		--   let's just use the prompt!
		-- lsEditBox returns two different things (a state and a value)
		local y = 40;


		do_initial_wind = lsCheckBox(10, y, z+10, 0xFFFFFFff, " Do Initial Wind", do_initial_wind);
		y = y + 32;
		do_wind = lsCheckBox(10, y, z+10, 0xFFFFFFff, " Do Any Windings", do_wind);
		y = y + 32;


		if lsButtonText(170, y, z, 100, 0xFFFFFFff, "OK") then
			is_done = 1;
		end

		
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
			error "Clicked End Script button";
		end
	
		
		lsDoFrame();
		lsSleep(10); -- Sleep just so we don't eat up all the CPU for no reason
	end
end

function timestr (timer)
 	local fraction = timer - math.floor(timer/1000);
	local seconds =  math.floor(timer/1000);
	local minutes = math.floor(seconds/60);
	      seconds = seconds - minutes*60
	local hours = math.floor(minutes/60);
	      minutes = minutes - hours*60;
	local days = math.floor(hours/24);
	      hours = hours - days*24;

	local result = "";
	if (days > 0) then
		result = result .. days .. "d ";
	end
	if ((hours > 0) or (#result >1)) then
		result = result .. hours .. "h ";
	end
	if ((minutes > 0) or (#result>1)) then
		result = result .. minutes .. "m ";
	end
	if ((seconds > 0) or (#result>1)) then
		result = result .. seconds .. "s";
	else 
		result = result .. "0s";
	end
	return result;
end