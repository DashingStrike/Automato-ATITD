-- Grain Oven Assist by Cegaiel
-- Pin multiple Grain Ovens. Make sure none of the borders overlap and are unobstructed by other windows.
-- Clicks the same button for all ovens.
-- Note when you can any + button, yes it will popup multiple boxes, asking for quantity.
-- The best way to deal with this is type a number, hit Enter key, repeatedly, until all windows close.
-- Yes, ATITD accepts copy/paste into Qty. So if you type 100 on notepad, copy it (Ctrl+C). Then you can Ctrl+V (Paste) the same value over and over.


dofile("common.inc");


askText = "Helps running one or more Grain Ovens.\n\nThose buttons are tiny and difficult to click them all on multiple ovens.\n\nClick buttons on GUI Interface and it will click the same buttons on all of your ovens with one click.\n\nPin all grain oven windows. Be sure none overlap and no other windows partially cover the windows. Don\'t pin to close to the center where popups can occur.";


button_names = {
"+ RW",
"+ LW",
"+ MW",
"+ DW",
"+ BW",
"- RW",
"- LW",
"- MW",
"- DW",
"- BW",
"+ RM",
"+ LM",
"+ MM",
"+ DM",
"+ BM",
"- RM",
"- LM",
"- MM",
"- DM",
"- BM",
"+ RB",
"+ LB",
"+ MB",
"+ DB",
"+ BB",
"- RB",
"- LB",
"- MB",
"- DB",
"- BB",
};


function doit()
	askForWindow(askText);

		while 1 do
		checkBreak();
			for i=1, #button_names do

				-- WHEAT

				y = 50;
				if button_names[i] == "- RW" then
					x = 255;
					--y = 50;
				elseif button_names[i] == "- LW" then
					x = 255;
					y = y+50;
				elseif button_names[i] == "- MW" then
					x = 255;
					y = y+100;
				elseif button_names[i] == "- DW" then
					x = 255;
					y = y+150;
				elseif button_names[i] == "- BW" then
					x = 255;
					y = y+200;

				elseif button_names[i] == "+ RW" then
					x = 210;
					--y = 50;
				elseif button_names[i] == "+ LW" then
					x = 210;
					y = y+50;
				elseif button_names[i] == "+ MW" then
					x = 210;
					y = y+100;
				elseif button_names[i] == "+ DW" then
					x = 210;
					y = y+150;
				elseif button_names[i] == "+ BW" then
					x = 210;
					y = y+200;


				-- MALT

				elseif button_names[i] == "- RM" then
					x = 155;
					--y = 50;
				elseif button_names[i] == "- LM" then
					x = 155;
					y = y+50;
				elseif button_names[i] == "- MM" then
					x = 155;
					y = y+100;
				elseif button_names[i] == "- DM" then
					x = 155;
					y = y+150;
				elseif button_names[i] == "- BM" then
					x = 155;
					y = y+200;

				elseif button_names[i] == "+ RM" then
					x = 110;
					--y = 50;
				elseif button_names[i] == "+ LM" then
					x = 110;
					y = y+50;
				elseif button_names[i] == "+ MM" then
					x = 110;
					y = y+100;
				elseif button_names[i] == "+ DM" then
					x = 110;
					y = y+150;
				elseif button_names[i] == "+ BM" then
					x = 110;
					y = y+200;


				-- BARLEY

				elseif button_names[i] == "- RB" then
					x = 55;
					--y = 50;
				elseif button_names[i] == "- LB" then
					x = 55;
					y = y+50;
				elseif button_names[i] == "- MB" then
					x = 55;
					y = y+100;
				elseif button_names[i] == "- DB" then
					x = 55;
					y = y+150;
				elseif button_names[i] == "- BB" then
					x = 55;
					y = y+200;

				elseif button_names[i] == "+ RB" then
					x = 10;
					--y = 50;
				elseif button_names[i] == "+ LB" then
					x = 10;
					y = y+50;
				elseif button_names[i] == "+ MB" then
					x = 10;
					y = y+100;
				elseif button_names[i] == "+ DB" then
					x = 10;
					y = y+150;
				elseif button_names[i] == "+ BB" then
					x = 10;
					y = y+200;
				end



				if ButtonText(x, y, 0, 50, 0xe5d3a2ff, button_names[i], 0.7, 0.7) then
					image_name = button_names[i];
				end
			end

				if ButtonText(10, 320, 0, 130, 0xe5d3a2ff,
		                    "Start / Stop", 0.7, 0.7) then
				  xOffset = 190
				  yOffset = 130
				  clickButtons();
				end


				if ButtonText(10, 285, 0, 80, 0xe5d3a2ff,
		                    "+ Wood", 0.7, 0.7) then
				  xOffset = 82
				  yOffset = 132
				  clickButtons();
				end

				if ButtonText(80, 285, 0, 80, 0xe5d3a2ff,
		                    "- Wood", 0.7, 0.7) then
				  xOffset = 93
				  yOffset = 132
				  clickButtons();
				end


			lsPrint(28, 5, 0, 0.7, 0.7, 0xffffffff, "Barley");
			lsPrint(135, 5, 0, 0.7, 0.7, 0xffffffff, "Malt");
			lsPrint(225, 5, 0, 0.7, 0.7, 0xffffffff, "Wheat");
			lsPrint(10, 30, 0, 0.65, 0.65, 0xffffffff, "Raw -------------------------------------------------------");
			lsPrint(10, 80, 0, 0.65, 0.65, 0xffffffff, "Light -----------------------------------------------------");
			lsPrint(10, 130, 0, 0.65, 0.65, 0xffffffff, "Med -------------------------------------------------------");
			lsPrint(10, 180, 0, 0.65, 0.65, 0xffffffff, "Dark -------------------------------------------------------");
			lsPrint(10, 230, 0, 0.65, 0.65, 0xffffffff, "Burnt -----------------------------------------------------");


			if ButtonText(lsScreenX - 90, lsScreenY - 30, 0, 100, 0xFFFFFFff,
		                    "End Script") then
			error "Clicked End script button";
			end

			lsDoFrame();
			lsSleep(10);

		-- WHEAT

		if image_name == "- RW" then
			xOffset = 213
			yOffset = 25
			clickButtons();
		elseif image_name == "- LW" then
			xOffset = 213
			yOffset = 45
			clickButtons();
		elseif image_name == "- MW" then
			xOffset = 213
			yOffset = 65
			clickButtons();
		elseif image_name == "- DW" then
			xOffset = 213
			yOffset = 85
			clickButtons();
		elseif image_name == "- BW" then
			xOffset = 213
			yOffset = 105
			clickButtons();

		elseif image_name == "+ RW" then
			xOffset = 202
			yOffset = 25
			clickButtons();
		elseif image_name == "+ LW" then
			xOffset = 202
			yOffset = 45
			clickButtons();
		elseif image_name == "+ MW" then
			xOffset = 202
			yOffset = 65
			clickButtons();
		elseif image_name == "+ DW" then
			xOffset = 202
			yOffset = 85
			clickButtons();
		elseif image_name == "+ BW" then
			xOffset = 202
			yOffset = 105
			clickButtons();


		--  MALT

		elseif image_name == "- RM" then
			xOffset = 153
			yOffset = 25
			clickButtons();
		elseif image_name == "- LM" then
			xOffset = 153
			yOffset = 45
			clickButtons();
		elseif image_name == "- MM" then
			xOffset = 153
			yOffset = 65
			clickButtons();
		elseif image_name == "- DM" then
			xOffset = 153
			yOffset = 85
			clickButtons();
		elseif image_name == "- BM" then
			xOffset = 153
			yOffset = 105
			clickButtons();

		elseif image_name == "+ RM" then
			xOffset = 142
			yOffset = 25
			clickButtons();
		elseif image_name == "+ LM" then
			xOffset = 142
			yOffset = 45
			clickButtons();
		elseif image_name == "+ MM" then
			xOffset = 142
			yOffset = 65
			clickButtons();
		elseif image_name == "+ DM" then
			xOffset = 142
			yOffset = 85
			clickButtons();
		elseif image_name == "+ BM" then
			xOffset = 142
			yOffset = 105
			clickButtons();


		--  BARLEY

		elseif image_name == "- RB" then
			xOffset = 93
			yOffset = 25
			clickButtons();
		elseif image_name == "- LB" then
			xOffset = 93
			yOffset = 45
			clickButtons();
		elseif image_name == "- MB" then
			xOffset = 93
			yOffset = 65
			clickButtons();
		elseif image_name == "- DB" then
			xOffset = 93
			yOffset = 85
			clickButtons();
		elseif image_name == "- BB" then
			xOffset = 93
			yOffset = 105
			clickButtons();

		elseif image_name == "+ RB" then
			xOffset = 82
			yOffset = 25
			clickButtons();
		elseif image_name == "+ LB" then
			xOffset = 82
			yOffset = 45
			clickButtons();
		elseif image_name == "+ MB" then
			xOffset = 82
			yOffset = 65
			clickButtons();
		elseif image_name == "+ DB" then
			xOffset = 82
			yOffset = 85
			clickButtons();
		elseif image_name == "+ BB" then
			xOffset = 82
			yOffset = 105
			clickButtons();
		end


		end  --end for	
end



function clickButtons()
  checkBreak();
  srReadScreen();
  wheat = findAllText("Wheat");
	for i=1, #wheat do
	  --srSetMousePos(wheat[i][0]+xOffset,wheat[i][1]+yOffset);
	  srClickMouseNoMove(wheat[i][0]+xOffset,wheat[i][1]+yOffset, 1);
	end
  image_name = nil;
end
