-- Macro by Cegaiel
-- This will right click all windows, in an attempt to unpin and close them all. 
-- It searches for windows with BOTH 'ThisIs.png' and 'Unpin.png' to ensure nothing is missed.
-- This script does nothing more than right click on windows. If they are pinned, a right click will close them all (as intended).
-- If any or all of your windows exist, but not pinned , then this macro would pin them (not intended), keep that in mind!



loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();


right_click = true;  -- Set this boolean to 'true' to do right clicks. If this was blank or false, then it would do left clicks.
per_click_delay = 0;  -- Time is in ms


searchImage1 = "ThisIs.png"  -- Method 1
searchImage2 = "Unpin.png"   -- Method 2
repeatMethod1 = 1;
repeatMethod2 = 1;


function doit()

	-- Pause, say something to user, wait for Shift key to continue. Give opportunity to put ATITD in focus, if needed.
	askForWindow("This will right click all windows, attempting to close any pinned windows. Press Shift key continue.");  

	--Keep looking for and closing windows with Image1 until no more found, then move to Method 2.

	while repeatMethod1 == 1 do
	closeMethod1();
	end


	--Keep looking for and closing windows with Image2 until no more found, then done.

	while repeatMethod2 == 1 do
	closeMethod2();
	end

end




function closeMethod1()


		-- Search Method 1:


		-- Find pinned windows with searchImage1
		srReadScreen();

		-- Count how many windows that were found and assign the value to #buttons
		local buttons = findAllImages(searchImage1);
		
		if #buttons == 0 then
		repeatMethod1 = 0
		else


			for i=#buttons, 1, -1 do
				srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3, right_click);
				lsSleep(per_click_delay);

			end

		end

		checkBreak();
end



function closeMethod2()


		-- Search Method 2:


		-- Find pinned windows with searchImage2
		srReadScreen();

		-- Count how many windows that were found and assign the value to #buttons
		local buttons = findAllImages(searchImage2);
		
		if #buttons == 0 then
		repeatMethod2 = 0
		else


			for i=#buttons, 1, -1 do
				srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3, right_click);
				lsSleep(per_click_delay);

			end

		end

		checkBreak();
end
