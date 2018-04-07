-- Updated by Manon for T8 beta
-- Updated by Huggz for T8 proper
--

 dofile("screen_reader_common.inc");
 dofile("ui_utils.inc");
 
 delay_time = 3000;
 total_delay_time = 300000;
 carrot_delay_time = 10*60*1000;
 
 function doit()
 	carrot_timer = lsGetTimer();
 	askForWindow("Pin 5-10 tree windows, will click them VERTICALLY (left to right if there is a tie - multiple columns are fine).  Additionally, optionally, pin a Bonfire and Consume window for stashing wood and eating grilled carrots (first carrot will be consumed after 10 minutes).");
 	-- Find windows
 	srReadScreen();
 	xyWindowSize = srGetWindowSize();
 	
 	buttons = findAllImages("GatherWood.png");
 		
 	harvestIndex = 1
 	
 	while true do
 		winPosX = buttons[harvestIndex][0] - 1
 		winPosY = buttons[harvestIndex][1] - 1
 	
 		srClickMouseNoMove(winPosX, winPosY)
 		lsSleep(500)
 		srReadScreen()
 		
 		hasWood = srFindImageInRange("GatherWood.png", winPosX, winPosY, 80, 15)
 		
 		if hasWood == nil then
 			statusScreen("Tree " .. harvestIndex .. "/" .. #buttons .. " has no wood.  Waiting...")
 		else			
 			statusScreen("Grabbing Wood " .. harvestIndex .. "/" .. #buttons);
 			srClickMouseNoMove(hasWood[0] + 2, hasWood[1] + 2)
 			
 			harvestIndex = harvestIndex + 1
 			if harvestIndex > #buttons then
 				harvestIndex = 1
 				
 				lsSleep(delay_time)
 				
 				-- stash to bonfire
 				-- add logic to stash to warehouse
 				srReadScreen()
 				bonfire = srFindImage("Bonfire.png");
 				if bonfire then
 					statusScreen("Found bonfire...");
 					add_wood = srFindImage("AddSomeWood.png");
 					if add_wood then
 						-- add it
 						statusScreen("Adding wood to bonfire");
 						srClickMouseNoMove(add_wood[0]+5, add_wood[1]+5);
 						lsSleep(500);
 						-- click Max
 						
 						click_max = srFindImage("maxButton.png");
 						if(not click_max) then
 							click_max = srFindImage("maxButton2.png");
 							srClickMouseNoMove(xyWindowSize[0]/2, xyWindowSize[1]/2 + 5);
 						end
 					else
 						statusScreen("No add wood button, refreshing bonfire");
 						-- refresh bonfire window
 						srClickMouseNoMove(bonfire[0]+5, bonfire[1]+5);
 					end
 				end
 				
 			end
 		end
 		
 		carrots = srFindImage("EatSomeGrilledCarrots.png");
 
 		carrot_note = "";
 		if carrots then
 			carrot_time_left = carrot_timer + carrot_delay_time - lsGetTimer();
 			if carrot_time_left < 0 then
 				carrot_time_left = 0;
 				eat_carrots = 1;
 			end
 			carrot_note = "  " .. math.floor(carrot_time_left / 1000) .. "s until eating carrots.";
 		else
 			carrot_note = "";
 		endn
 
 		if eat_carrots then
 			srReadScreen();
 			carrots = srFindImage("EatSomeGrilledCarrots.png");
 			if carrots then
 				srClickMouseNoMove(carrots[0]+5, carrots[1]+5);
 				carrot_timer = lsGetTimer();
 			end
 		end
 		
 		lsSleep(delay_time)
 		checkBreak()
 		
 	end
 end
