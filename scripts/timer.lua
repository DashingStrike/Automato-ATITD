
-- This script has not yet been updated to use the new UI utilties

--
-- 
--

loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();

delay_time = 60*2.2*1000;

function doit()
	delay_time = 1000*promptNumber("How many seconds?", 2.2*60)
	while 1 do
		lsPlaySound("Clank.wav");
		local start_time = lsGetTimer();
		while delay_time - (lsGetTimer() - start_time) > 0 do
			time_left = delay_time - (lsGetTimer() - start_time);
			lsPrintWrapped(10, 60, 0, lsScreenX - 20, 1, 1, 0xFFFFFFff, "Waiting " .. time_left .. "ms...");
			if lsButtonText(lsScreenX - 110, lsScreenY - 30, z, 100, 0xFFFFFFff, "End script") then
				error "Clicked End Script button";
			end
			lsDoFrame();
			lsSleep(100);
		end
	end
end
