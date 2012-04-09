-- Macro by Cegaiel
-- This will right click all windows, in an attempt to unpin and close them all. 
-- It searches for windows with BOTH 'ThisIs.png' and 'Unpin.png' to ensure nothing is missed.
-- This script does nothing more than right click on windows. If they are pinned, a right click will close them all (as intended).
-- If any or all of your windows exist, but not pinned , then this macro would pin them (not intended), keep that in mind!



loadfile("luaScripts/screen_reader_common.inc")();
loadfile("luaScripts/ui_utils.inc")();


right_click = true;  -- Set this boolean to 'true' to do right clicks. If this was blank or false, then it would do left clicks.
per_click_delay = 10;  -- Time is in ms

searchImage1 = "ThisIs.png"  -- Method 1
searchImage2 = "Unpin.png"   -- Method 2



function doit()


	-- Pause, say something to user, wait for Shift key to continue. Give opportunity to put ATITD in focus, if needed.
	askForWindow("Press Shift key to right click all windows.");  




--------------------------------- METHOD 1 ---------------------------------



		-- Search Method 1:


		-- Find pinned windows with searchImage1
		srReadScreen();

		-- Count how many windows that were found and assign the value to #buttons
		local buttons = findAllImages(searchImage1);
		
		if #buttons == 0 then

		statusScreen("Search method 1/2 failed!");
		lsSleep(1000);

		else
			statusScreen("Search method 1/2:\nFound " .. #buttons .. " windows");
			lsSleep(1000);
			statusScreen("Search method 1/2:\nClicking " .. #buttons .. " windows");
			lsSleep(1000);


			for i=#buttons, 1, -1 do

				srClickMouseNoMove(buttons[i][0]+5, buttons[i][1]+3, right_click);
				lsSleep(per_click_delay);

			end

					-- If any windows were found, with Method 1, then inform user when done clicking.
					if #buttons > 0 then
					statusScreen("Search method 1/2:\nDone clicking " .. #buttons .. " windows");
					lsSleep(1000);
					end


		end



		-- Done Method 1




------------------------------------------------------------------------------



-- Do another check (Method 2) for Unpin.png, if Thisis.png was not found, then it could mean 2 reasons:

-- Reason 1: Some buildings, like Warehouse, which shows 'This Small Warehouse' would fool Method 1.
	-- Why don't I use this.png instead to avoid that?
	-- Because many buildings may show 'This' twice. ie Kiln: "'This' is a True Kiln, 'This' True Kiln will survive 2 firings".
	-- or "'This' is a greenhouse, 'This' greenhouse is growing Grass"
	-- While the script would still work correctly with this.png, I use thisIs.png so that it doesn't make one window show as 2 in the status message.
	-- In other words, if I had one greenhouse pinned, it would say it found 2 windows, because it found the word 'This' twice.

-- Reason 2: Maybe a flax bed window went to a seed. If you refresh a flax bed window, after going to seed, it would turn blank, only leaving the unpin.png method to find and close it.


-- Why don't I use Method 2 only, instead of both Method 1 and 2? Wouldn't the unpin.png (Method 2) cover all scenarios?

	-- Yes it would, except for this scenario:  the "thistle new" layout (from windows_arranger.lua)...
	-- With this layout, Method 2 (Unpin.png) will only close one window out at a time :( I don't know why, but it does. I even tried changing the image, no luck :(
	-- So this is the reason to the methods...


------------------------------------------------------------------------------


-- Why did I use #buttons2 below instead of using #buttons again?
	-- Yes, I could have used #buttons again below, instead of #buttons2.
	-- The only reason that I used #buttons2 instead of #buttons is to add the totals of #buttons + #buttons2 at bottom. I wanted 2 different values.
	-- If I had used #buttons again, then the value (above) would have been overwritten on Method 2 (below).
	-- If not for the 'Total clicked:' thing, I would not have needed to use #buttons2, just FYI.



--------------------------------- METHOD 2 ---------------------------------

		-- Search Method 2:


		-- Find pinned windows with searchImage2
		srReadScreen();

		-- Count how many windows that were found and assign the value to #buttons2
		local buttons2 = findAllImages(searchImage2);
		
		if #buttons2 == 0 then

		statusScreen("Search method 2/2 failed!");
		lsSleep(1000);

		else
			statusScreen("Search method 2/2:\nFound " .. #buttons2 .. " windows");
			lsSleep(1000);
			statusScreen("Search method 2/2:\nClicking " .. #buttons2 .. " windows");
			lsSleep(1000);


			for i=#buttons2, 1, -1 do

				srClickMouseNoMove(buttons2[i][0]+5, buttons2[i][1]+3, right_click);
				lsSleep(per_click_delay);

			end


					-- If any windows were found, with Method 2, then inform user when done clicking.
					if #buttons2 > 0 then
					statusScreen("Search method 2/2:\nDone clicking " .. #buttons2 .. " windows");
					lsSleep(1000);
					end


		end


		-- Done Method 2



------------------------------------------------------------------------------


			-- Just an unneeded/optional message to user,  before we finish the doit() function
			-- If any windows found, with either Method 1 (#buttons) or Method 2 (#buttons2), then show the total windows clicked. Else say Sorry, try again.

			if #buttons + #buttons2 > 0 then
			--statusScreen("Total clicked: " .. #buttons + #buttons2 .. " windows");
			statusScreen("Method 1 clicked: " .. #buttons .. "\nMethod 2 clicked: " .. #buttons2 .. "\n---------------------------\nTotal clicked: " .. #buttons + #buttons2);
			else
			statusScreen("Sorry, didn't find any windows. Maybe try again with ATITD in focus!");
			end
			lsSleep(5000);


------------------------------------------------------------------------------



end
