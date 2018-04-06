-- Macro by Cegaiel
-- This will right click all windows found (both searchImage1 or searchImage2), in an attempt to unpin and close all pinned windows. 
-- It right clicks (closes) every open window that currently shows on screen, in one pass.. If it finds any windows to click then:
	--Repeat and search for more windows and close all found in another pass again, repeat.
	-- The purpose of repeating is in case you had any windows were hidden behind other windows from the previous right clicks/close windows.
	-- Repeat above until no more windows are found. Then do Search Method 2 (another .png) for expired windows (ie. flax bed that turned to seed and window turned blank)
-- Repeat same pattern for Method 2, until no more windows are found, then exit.


dofile("common.inc");


right_click = true;  -- Set this boolean to 'true' to do right clicks. If this was blank or false, then it would do left clicks.
per_click_delay = 150;  -- Time is in ms


searchImage1 = "ThisIs.png"  -- Method 1
searchImage2 = "Unpin.png"   -- Method 2
searchImage3 = "Ok.png"      -- Method 3
repeatMethod1 = 1;
repeatMethod2 = 1;
repeatMethod3 = 1;

function doit()

	-- Pause, say something to user, wait for Shift key to continue. Give opportunity to put ATITD in focus, if needed.
	askForWindow("This will right click all windows, attempting to close any pinned windows. This will also close/click any PopUp windows with 'OK' buttons. This will find any windows or popups that are hidden behind other windows, too. Press Shift key continue.");  
	

	--Keep looking for and closing windows with Image1 until no more found, then move to Method 2.

	while repeatMethod1 == 1 do
	sleepWithStatus(100, "Closing windows and popups, Method 1");
	closeMethod1();
	end


lsSleep(200);

	--Keep looking for and closing windows with Image2 until no more found, then move to Method 3.

	while repeatMethod2 == 1 do
	sleepWithStatus(100, "Closing windows and popups, Method 2");
	closeMethod2();
	end


lsSleep(200);

	--Keep looking for and closing windows with Image3 until no more found, then done.

	while repeatMethod3 == 1 do
	sleepWithStatus(100, "Closing windows and popups, Method 3");
	closeMethod3();
	end

  lsPlaySound("Complete.wav");
  error 'Closed all windows and popups.';


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


function closeMethod3()


		-- Search Method 3:


		-- Find OK buttons with searchImage3
		srReadScreen();

		-- Count how many windows that were found and assign the value to #buttons
		local buttons = findAllImages(searchImage3);
		
		if #buttons == 0 then
		repeatMethod3 = 0
		else


			for i=#buttons, 1, -1 do
				srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3, right_click);
				lsSleep(per_click_delay);

			end

		end

		checkBreak();
end
