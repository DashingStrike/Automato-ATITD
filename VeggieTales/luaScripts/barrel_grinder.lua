--
-- Simply looks for "dig deeper" and a red "endurance" timer
--

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

xyWindowSize = srGetWindowSize();
imgWind1 = "BarrelGrinderWind1.png";
imgWind2 = "BarrelGrinderWind2.png";
imgStart = "BarrelGrinderStart.png";
imgRepair = "BarrelGrinderRepair.png";
imgEndRed = "Endurance-Red.png";
delay_time = 19000; -- just shy of 20 seconds
rest_time = 60000;

num_clicks = 0;
num_repairs = 0;

function doit()
	askForWindow("Pin up your barrel grinder menu, then press Shift to continue.");
	while 1 do
		lsSleep(100);
		if (lsShiftHeld() and lsControlHeld()) then
			error 'broke out of loop from Shift+Ctrl';
		end
		srReadScreen();
		-- start it
		lsPrintln(lsGetTimer() .. " start it");
		local st = srFindImage(imgStart, 4000);
		if not st then
			error 'Could not find \'Start grinding\' button.';
		end
		lsPrintln(lsGetTimer() .. " winding and waiting");
		statusScreen("Winding and waiting.");
		srClickMouseNoMove(st[0]+5, st[1], 0);
		while 1 do
			lsSleep(delay_time);
			if (lsShiftHeld() and lsControlHeld()) then
				error 'broke out of loop from Shift+Ctrl';
			end
			srReadScreen();
			local end_red = srFindImage(imgEndRed);
			while end_red do
				lsPrintln(lsGetTimer() .. " end red");
				statusScreen("Waiting (END red)  clicks=" .. num_clicks .. "  repairs=" .. num_repairs);
				lsSleep(15);
				srReadScreen();
				if (lsShiftHeld() and lsControlHeld()) then
					error 'broke out of loop from Shift+Ctrl';
				end
				end_red = srFindImage(imgEndRed);
			end
			local wind = srFindImage(imgWind1, 4000);
			if wind then
				lsPrintln(lsGetTimer() .. " winding");
				num_clicks = num_clicks + 1;
				srClickMouseNoMove(wind[0]+5, wind[1], 0);
			else
				srReadScreen();
				wind = srFindImage(imgWind2, 4000);
				if wind then
					lsPrintln(lsGetTimer() .. " winding2");
					srClickMouseNoMove(wind[0]+5, wind[1], 0);
				else
					statusScreen("Repairing");
					srReadScreen();
					local repair = srFindImage(imgRepair);
					if repair then
						num_repairs = num_repairs + 1;
						lsPrintln(lsGetTimer() .. " repairing");
						srClickMouseNoMove(repair[0]+5, repair[1], 0);
						lsPrintln(lsGetTimer() .. " resting");
						statusScreen("Resting for 2 minutes");
						lsSleep(rest_time);

						-- start it
						srReadScreen();
						local st = srFindImage(imgStart, 4000);
						if not st then
							error 'Could not find start button';
						end
						statusScreen("Winding and waiting.");
						srClickMouseNoMove(st[0]+5, st[1], 0);
					else
						error 'Could not find repair button';
					end
				end
			end
		end
	end
end
