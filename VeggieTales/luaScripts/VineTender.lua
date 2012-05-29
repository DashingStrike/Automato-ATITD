-- VineTender.lua v1.1 by Teti, revised by Tallow)
--
-- Automatically tends vines based on the tends you specify.
--

loadfile("luaScripts/common.inc")( );

askText = singleLine([[
  Vine Tender v1.1 (by Teti, revised by Tallow) --
  Automatically tends vineyards based on vine type.
]]);

knownVineNames = {
  { name = "Appreciation",
    image = "Appreciation" },
  { name = "Balance",
    image = "Balance" },
  { name = "Contemplation",
    image = "Contemplation" },
  { name = "Distraction",
    image = "Distraction" },
  { name = "P Dexaglucose 10S",
    image = "" },
  { name = "P FOUR Skin KKKK",
    image = "Pascarella FOUR Skin KKKK" },
  { name = "P Rainbow AACCC",
    image = "Pascarella Rainbow AACCC" },
  { name = "P Sugar High 11S",
    image = "Pascarella Sugar High (11S)" }
};

vineyardActions = { "Tend", "Harvest", "Cutting" };
vineyardImages = { "", "Harvest the Gr", "Take a Cutting of the V" };

stateNames = {"Fat", "Musty", "Rustle", "Sagging", "Shimmer",
	      "Shrivel", "Wilting"};

vineStates = { "vineyard/State_Fat.png", "vineyard/State_Musty.png",
	       "vineyard/State_Rustle.png", "vineyard/State_Sagging.png",
	       "vineyard/State_Shimmer.png", "vineyard/State_Shrivel.png",
	       "vineyard/State_Wilting.png" };

tendActions = {"AS", "MG", "PO", "SL", "SV", "TL", "TV"};
tendIndices = { ["AS"] = 1, ["MG"] = 2, ["PO"] = 3, ["SL"] = 4, ["SV"] = 5,
		["TL"] = 6, ["TV"] = 7 };

tendImages = {
  ["AS"] = "vineyard/Action_AS.png",
  ["MG"] = "vineyard/Action_MG.png",
  ["PO"] = "vineyard/Action_PO.png",
  ["SL"] = "vineyard/Action_SL.png",
  ["SV"] = "vineyard/Action_SV.png",
  ["TL"] = "vineyard/Action_TL.png",
  ["TV"] = "vineyard/Action_TV.png" };

vigorNames = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "10", "11",
	       "12", "13", "14", "15" };

vines = {};
vinesUsed = {};
vineImagesUsed = {};
tendedCount = 0;

function doit()
  askForWindow(askText);
  parseVines();

  local status = "";
  local action = 1;
  while 1 do
    action = promptVineyard(status, action);

    local x, y = srMousePos();
    openAndPin(x, y, 500);

    if action == 1 then
      status = processVineyard();
    else
      srReadScreen();
      local clickPos = findText(vineyardImages[action]);
      if clickPos then
	safeClick(clickPos[0] + 10, clickPos[1] + 5);
	if action == 2 then
	  local yes = waitForImage("Yes.png", 500);
	  if yes then
	    safeClick(yes[0] + 5, yes[1] + 5);
	  end
	end
	tendedCount = tendedCount + 1;
	status = "(" .. tendedCount .. ") " .. vineyardActions[action]
	  .. " complete";
      else
	status = "Cannot find " .. vineyardActions[action] .. " button";
      end
    end
    closeAllWindows();
  end
end

function promptVineyard(status, action)
  while not lsControlHeld() do
    local edit = lsButtonText(10, lsScreenY - 30, 0, 120, 0xffffffff,
			      "Edit Tends");
    action = lsDropdown("VineyardAction", 80, lsScreenY - 120, 0, 150, action,
			vineyardActions);
    lsPrint(10, lsScreenY - 90, 0, 0.7, 0.7, 0xd0d0d0ff,
	    "Tap control over a vineyard");
    statusScreen(status);
    if edit then
      promptTends();
    end
    lsSleep(tick_delay);
  end

  while lsControlHeld() do
    statusScreen("Release control");
  end
  return action;
end

function promptTends()
  local done = false;
  local vineIndex = 1;
  while not done do
    local add = lsButtonText(lsScreenX/2 - 60, 10, 0, 120, 0xffffffff,
			     "Add Tend");
    local edit = false;
    local delete = false;
    if #vines > 0 then
      local tends = {};
      for i=1,#vines do
	tends[i] = vines[i].name;
      end
      vineIndex = lsDropdown("TendIndex", 30, 80, 0, 250, vineIndex,
			     tends);
      edit = lsButtonText(lsScreenX/2 - 60, 120, 0, 120, 0xffffffff,
			  "Edit Tend");
      delete = lsButtonText(lsScreenX/2 - 60, 150, 0, 120, 0xffffffff,
			    "Delete Tend");
    end
    done = lsButtonText(10, lsScreenY - 30, 0, 100, 0xffffffff, "Done");
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xffffffff,
		    "End Script") then
      error(quit_message);
    end
    checkBreak();
    lsSleep(tick_delay);
    lsDoFrame();
    if add then
      promptAdd();
    elseif edit then
      promptEdit(vines[vineIndex]);
    elseif delete then
      table.remove(vines, vineIndex);
      saveVines();
      parseVines();
    end
    lsSleep(tick_delay);
  end
end

function promptAdd()
  local vineNames = {};
  local vineImages = {};
  for i=1,#knownVineNames do
    if not vinesUsed[knownVineNames[i].name]
      and not vineImagesUsed[knownVineNames[i].image]
    then
      vineNames[#vineNames + 1] = knownVineNames[i].name;
      vineImages[#vineImages + 1] = knownVineNames[i].image;
    end
  end
  vineNames[#vineNames + 1] = "Other";
  local otherIndex = #vineNames;
  local addIndex = 1;

  local done = false;
  while not done do
    lsPrint(10, 10, 0, 1.0, 1.0, 0xffffffff, "Adding New Vine");
    done = lsButtonText(10, lsScreenY - 30, 0, 80, 0xffffffff, "Next");
    local cancel = lsButtonText(100, lsScreenY - 30, 0, 80, 0xffffffff,
				"Cancel");
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xffffffff,
		    "End Script") then
      error(quit_message);
    end
    
    addIndex = lsDropdown("VineAddIndex", 30, 50, 0, 250, addIndex,
			  vineNames);
    local vineName, vineImage;
    if addIndex == otherIndex then
      local foo;
      lsPrint(5, 100, 0, 1.0, 1.0, 0xd0d0d0ff, "Short Name:");
      foo, vineName = lsEditBox("aVineName", 80, 100, 0, 200, 30, 1.0, 1.0,
				0x000000ff, "Custom");
      lsPrint(5, 140, 0, 1.0, 1.0, 0xd0d0d0ff, "Full Name:");
      foo, vineImage = lsEditBox("aVineImage", 80, 140, 0, 200, 30, 1.0, 1.0,
				 0x000000ff, "vineyard/Custom.png");
    else
      vineName = vineNames[addIndex];
      vineImage = vineImages[addIndex];
    end

    if vinesUsed[vineName] then
      done = false;
      lsPrint(10, 220, 10, 0.7, 0.7, 0xFF2020ff, "Short Name In Use");
    elseif vineImagesUsed[vineImage] then
      done = false;
      lsPrint(10, 220, 10, 0.7, 0.7, 0xFF2020ff, "Long Name In Use");
    elseif string.match(vineImage, ".png$") then
      local status, error = pcall(srImageSize, vineImage);
      if not status then
	done = false;
	lsPrint(10, 220, 10, 0.7, 0.7, 0xFF2020ff, "Image Not Found");
      end
    end

    checkBreak();
    lsSleep(tick_delay);
    lsDoFrame();

    if done then
      vines[#vines + 1] = {
	name = vineName,
	image = vineImage,
	tends = {1, 1, 1, 1, 1, 1, 1},
	vigors = {1, 1, 1, 1, 1, 1, 1}
      };
      vinesUsed[vineName] = vines[#vines];
      vineImagesUsed[vineImage] = vines[#vines];
      promptEdit(vines[#vines]);
    elseif cancel then
      done = true;
    end
    lsSleep(tick_delay);
  end
end

function promptEdit(vine)
  local done = false;
  while not done do
    lsPrint(10, 10, 0, 1.0, 1.0, 0xffffffff, "Editing " .. vine.name);
    lsPrint(80, 50, 0, 0.7, 0.7, 0xd0d0d0ff, "Action");
    lsPrint(160, 50, 0, 0.7, 0.7, 0xd0d0d0ff, "Vigor");
    local y = 70;
    for i=1,#stateNames do
      lsPrint(10, y, 0, 0.7, 0.7, 0xd0d0d0ff, stateNames[i] .. ":");
      local tendIndex = tendIndices[vine.tends[i]];
      local tend  = lsDropdown(stateNames[i] .. "T" .. "-" .. vine.name,
			       80, y, 0, 60, tendIndex, tendActions);
      vine.tends[i] = tendActions[tend];
      vine.vigors[i] = lsDropdown(stateNames[i] .. "V" .. "-" .. vine.name,
				  160, y, 0, 60, vine.vigors[i], vigorNames);
				  
      y = y + 30;
    end
    done = lsButtonText(10, lsScreenY - 30, 0, 80, 0xffffffff, "Save");
    local cancel = lsButtonText(100, lsScreenY - 30, 0, 80, 0xffffffff,
				"Cancel");
    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xffffffff,
		    "End Script") then
      error(quit_message);
    end

    checkBreak();
    lsSleep(tick_delay);
    lsDoFrame();
    if done then
      saveVines();
    elseif cancel then
      parseVines();
      done = true;
    end
    lsSleep(tick_delay);
  end
end

function processVineyard()
  local status = "";
  srReadScreen();

  local window = srFindImage("vineyard/CanBeTended.png" );
  if not window then
    return "Vineyard is not ready for tending";
  end

  local vigorPos = srFindImage("vineyard/Number_Vigor.png" );
  if not vigorPos then
    return "Could not find Vigor";
  end

  local vigorSize = srImageSize("vineyard/Number_Vigor.png")
  local vigor = ocrNumber(vigorPos[0] + vigorSize[0], vigorPos[1], BOLD_SET);
  if not vigor then
    return "Could not read Vigor";
  end

  local vineType = nil;
  srReadScreen();
  for i=1,#vines do
    lsPrintln("Testing " .. vines[i].image);
    if findVine(vines[i].image) then
      lsPrintln("Found " .. vines[i].image);
      vineType = vines[i];
      break;
    end
  end
  if not vineType then
    return "Could not identify this vine type";
  end

  local vineState = findVineState();
  if vineState == 0 then
    return "Could not determine vine state";
  end

  if vigor <= vineType.vigors[vineState] then
    return "This vine does not have enough vigor. Time to harvest.";
  end

  local clickPos = srFindImage(tendImages[vineType.tends[vineState]]);
  if not clickPos then
    return "Could not find tend action to click";
  end
  safeClick(clickPos[0], clickPos[1]);
  sleepWithStatus(200, "Tending vineyard");
  return statusSuccess(vineType);
end

function findVine(image)
  if string.match(image, ".png$") then
    return srFindImage(image, 10000);
  else
    return findText(image);
  end
end

function statusSuccess(vine)
  srReadScreen();
  tendedCount = tendedCount + 1;
  local result = "(" .. tendedCount .. ") Tended " .. vine.name .. "\n\n";
  result = result .. statusNumber("Acid");
  result = result .. statusNumber("Color");
  result = result .. statusNumber("Grapes");
  result = result .. statusNumber("Quality");
  result = result .. statusNumber("Skin");
  result = result .. statusNumber("Sugar");
  result = result .. statusNumber("Vigor");
  return result;
end

function statusNumber(name)
  local result = "";
  local image = "vineyard/Number_" .. name .. ".png"
  local anchor = srFindImage(image);
  if anchor then
    local number = ocrNumber(anchor[0] + srImageSize(image)[0],
			     anchor[1], BOLD_SET);
    if number then
      result = name .. ": " .. number .. "\n";
    end
  end
  return result;
end


--      elseif vine == 2 then
--	if sagging and vigor -1>0 then
--	  clickpos=srFindImage("V_TV.png")		
--	elseif wilting and vigor -1>0 then
--	  clickpos=srFindImage("V_PO.png")		
--	elseif musty and vigor -2 >0 then
--	  clickpos=srFindImage("V_TV.png")		
--	elseif fat and vigor -4 >0 then 
--	  clickpos=srFindImage("V_TL.png")		
--	elseif rustle and vigor -1>0 then
--	  clickpos=srFindImage("V_AS.png")		
--	elseif shrivel and vigor -3>0 then
--	  clickpos=srFindImage("V_SV.png")		
--	elseif shimmer and vigor -1>0 then
--	  clickpos=srFindImage("V_SV.png")		
--	end

function findVineState()
  local result = 0;
  srReadScreen();
  for i=1,#vineStates do
    if srFindImage(vineStates[i]) then
      result = i;
      break;
    end
  end
  return result;
end

function parseVines()
  vines = {};
  vinesUsed = {};
  vineImagesUsed = {};
  local file = io.open("vines.txt", "a+");
  io.close(file);
  for line in io.lines("vines.txt") do
    local fields = csplit(line, ",");
    if #fields == 9 then
      vines[#vines + 1] = {
	name = fields[1],
	image = fields[2],
	tends = {},
	vigors = {}
      };
      vinesUsed[fields[1]] = vines[#vines];
      vineImagesUsed[fields[2]] = vines[#vines];

      for i=3,#fields do
	local sub = csplit(fields[i], "-");
	if #sub ~= 2 then
	  error("Failed parsing line: " .. line);
	end
	if not tendImages[sub[1]] then
	  error("Failed parsing line: " .. line);
	end
	vines[#vines].tends[i-2] = sub[1];
	local vigor = tonumber(sub[2])
	if not vigor then
	  error("Failed parsing line: " .. line);
	end
	vines[#vines].vigors[i-2] = vigor;
      end
    end
  end
end

function saveVines()
  local file = io.open("vines.txt", "w+");
  for i=1,#vines do
    file:write(vines[i].name .. "," .. vines[i].image);
    for j=1,#vines[i].tends do
      file:write("," .. vines[i].tends[j] .. "-" .. vines[i].vigors[j]);
    end
    file:write("\n");
  end
  io.close(file);
end
