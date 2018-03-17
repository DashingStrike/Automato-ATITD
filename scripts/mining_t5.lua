-- TODO: Change color of stones who have been assigned the current trait

dofile("screen_reader_common.inc");
dofile("ui_utils.inc");

function closestMine(pos)
	local ret = 1;
	local testpos = {};
	testpos[0] = pos[0] / lsScreenX;
	testpos[1] = pos[1] / lsScreenY;
	for i=2, #mines do
		local this_distance = (mines[i].pos[0] - testpos[0])*(mines[i].pos[0] - testpos[0]) + 
			(mines[i].pos[1] - testpos[1])*(mines[i].pos[1] - testpos[1]);
		local best_distance = (mines[ret].pos[0] - testpos[0])*(mines[ret].pos[0] - testpos[0]) + 
			(mines[ret].pos[1] - testpos[1])*(mines[ret].pos[1] - testpos[1]);
		if this_distance < best_distance then
			ret = i;
		end
	end
	return ret;
end

function displayMines(max_trait)
	lsFontShadow(1);
	for i = 1, #mines do
		local pos = {};
		pos[0] = mines[i].pos[0] * lsScreenX;
		pos[1] = mines[i].pos[1] * lsScreenY;
		lsPrint(pos[0] - 5, pos[1] - 8, 1, 1, 1, 0xFFFFFFff, i);
		for j=1, max_trait do
			if mines[i].trait[j] then
				lsPrint(pos[0], pos[1] - 8 + 16*j, 1, 0.8, 0.8, 0xFFFFFFff, j .. ":" .. mines[i].trait[j]);
			end
		end
	end
	lsFontShadow(0);
end

function allMinesHaveTrait(trait_num)
	for i=1, #mines do
		if not mines[i].trait[trait_num] then
			return false;
		end
	end
	return true;
end

function is_valid_set(set)
	local used = {};
	local last = 0;
	for i=1, #set do
		if set[i] <= last then
			return false;
		end
		last = set[i];
	end
	return true;
end

function is_matching_set(set)
	for i=1, num_traits do
		local match=false;
		local unmatch=false;
		for j=2, #set do
			for k=1, j-1 do
				if mines[set[j]].trait[i] == mines[set[k]].trait[i] then
					match = true;
				else
					unmatch = true;
				end
			end
		end
		if match and unmatch then
			return false;
		end
	end
	return true;
end

function increment_set(set)
	local newset = {};
	for i=1, #set do
		newset[i] = set[i];
	end
	set = newset;
	local index = #set;
	while true do
		if set[index] == #mines then
			if index == 1 then
				return nil;
			end
			set[index] = 1;
			index = index - 1;
		else
			set[index] = set[index] + 1;
			return set;
		end
	end
end

function set_to_string(set)
	local ret = "";
	for i=1, #set do
		ret = ret .. "  " .. set[i];
	end
	return ret;
end


function doit()
	set_min_size = promptNumber("Number of ore stones needed to make a set?", 3);
	askForWindow("Get mine field on screen, put the cursor over the ATITD window, and then press shift");

	srReadScreen();

	mines = {};
	
	lsTopmost(0);

	local done = nil;
	while not done do
		statusScreen("First, resize this window, then select each ore stone by clicking below.", 0xFFFFFFff, "no break");
		-- show the screen capture
		lsShowScreengrab(0x808080ff);
		
		if lsButtonText(lsScreenX - 110, lsScreenY - 30, 5, 100, 0xFFFFFFff, "End script") then
			error "Clicked End Script button";
		elseif lsButtonText(5, lsScreenY - 30, 1, 250, 0xFFFFFFff, "Done selecting mines") then
			done = true;
		else 
			click_pos = lsMouseClick();
			if (click_pos) then
				index = #mines+1;
				mines[index] = {};
				mines[index].pos = {};
				mines[index].pos[0] = click_pos[0] / lsScreenX;
				mines[index].pos[1] = click_pos[1] / lsScreenY;
				mines[index].trait = {};
			end
			
			displayMines(0);
		
			lsSleep(16);
		end
	end
	
	local trait=1;
	local traits_done = nil;
	local trait_value = 1;
	while not traits_done do
		local done = nil;
		while not lsShiftHeld() and not traits_done do
			statusScreen("Trait #" .. trait .. ", value #" .. trait_value .. ", hold shift and then click all matching ore stones", 0xFFFFFFff, "no break");
			lsShowScreengrab(0x808080ff);
			
			if lsButtonText(5, lsScreenY - 75, 1, 220, 0xFFFFFFff, "Next Trait") then
				if not allMinesHaveTrait(trait) then
					lsMessageBox("Trait not done", "You have not finished assigning values to all ore stones for this trait.");
				else
					trait = trait + 1;
					trait_value = 1;
				end
			end

			if lsButtonText(5, lsScreenY - 50, 1, 220, 0xFFFFFFff, "Prev Trait") then
				trait = trait - 1;
				trait_value = 1;
			end
			
			if lsButtonText(5, lsScreenY - 25, 1, 220, 0xFFFFFFff, "Done assigning traits") then
				traits_done = true;
			end
			
			displayMines(trait);
						
			lsSleep(16);
		end
		
		if not traits_done then
			local didone=nil;
			while lsShiftHeld() do
				statusScreen("Trait #" .. trait .. ", value #" .. trait_value .. ", click all matching ore stones, then release shift", 0xFFFFFFff, "no break");
				lsShowScreengrab(0xE0E0E0ff);
				
				click_pos = lsMouseClick();
				if click_pos then
					local index = closestMine(click_pos);
					mines[index].trait[trait] = trait_value;
					didone = true;
				end
				
				displayMines(trait);
				
				lsSleep(16);
			end
		
			if didone then
				trait_value = trait_value + 1;
			end
		end
	end
	
	-- find all sets
	statusScreen("Searching for sets (this may take a while)", 0xFFFFFFff, "no break");
	num_traits = trait;
	sets = {};
	count = 0;
	for set_size = set_min_size, #mines do
		local found_one_at_this_size = false;
		set = {};
		for i=1, set_size do
			set[i] = i;
		end
		
		while set do
			count = count + 1;
			if count == 1000 then
				count = 0;
				lsPrintln(set_to_string(set) .. " found " .. #sets .. " so far.");
			end
			
			if is_valid_set(set) then
				if is_matching_set(set) then
					sets[#sets + 1] = set;
					found_one_at_this_size = true;
				end	
			end
			
			set = increment_set(set);
		end
		if not found_one_at_this_size then
			break;
		end
	end
	
	-- display results
	
	while true do
		if #sets == 0 then
			statusScreen("NO matching sets", 0xFFFFFFff, "no break");
		else
			statusScreen("Matching sets", 0xFFFFFFff, "no break");
		end
		lsShowScreengrab(0xFFFFFF80);
		displayMines(trait);
		lsScrollAreaBegin("ResultsScroll", 0, 100, -10, lsScreenX - 50, lsScreenY - 50)
		for i=1, #sets do
			lsPrint(0, (i-1)*20, 3, 1, 1, 0xFFFFFFff, set_to_string(sets[i]));
		end	
		lsScrollAreaEnd(#sets*20);
		lsSleep(100);
	end

end