assert(loadfile("luaScripts/notepad.lua"))();

cheapRecipes = nil;
allRecipes = nil;

local types = {"Ra", "Thoth", "Osiris", "Set", "Maat", "Geb"};
local typePlus = {"+++++", "++++", "++++", "+++", "+++", "++"};
local typeMinus = {"-----", "----", "----", "---", "---", "--"};
local typeEnabled = {true, true, true, true, true, true};

local properties = {"Aromatic", "Astringent", "Bitter", "Salty",
		    "Sour", "Spicy", "Sweet", "Toxic"};
local props = {"Ar", "As", "Bi", "Sa", "So", "Sp", "Sw", "To"};

function doit()
  cheapRecipes = loadNotes("chem-cheap.txt");
  allRecipes = loadNotes("chem-all.txt");
  askForWindow("Magical Chemistry Vibes of Doom!!!!!!");
  while true do
    tryAllTypes();
    sleepWithStatus(2000, "Making more magic");
  end
end

function tryAllTypes()
  for i=1,#types do
    local done = false;
    if typeEnabled[i] then
      statusScreen("Trying type " .. types[i]);
      srReadScreen();
      clickAllText(types[i] .. "'s Compound");
      local anchor = waitForText("Required:");
      if anchor then
	local tags = {types[i]};
	local window = getWindowBorders(anchor[0], anchor[1]);
	addRequirements(tags, findAllText(typePlus[i], window), typePlus[i]);
	addRequirements(tags, findAllText(typeMinus[i], window), typeMinus[i]);
	local recipe = lookupData(cheapRecipes, tags);
	if not recipe and i <= 2 then
	  recipe = lookupData(allRecipes, tags);
	end
	if recipe then
	  lsPrintln("tags: " .. table.concat(tags, ", "));
--	  if not recipe then
--	    lsPrintln("Boohoo");
--	  end
--	  if recipe then
--	    lsPrintln("Impossible");
--	  else
--	    lsPrintln("else");
--	  end
--	  lsPrintln("Recipe: " .. table.concat(recipe, "---"));
	  local recipeList = csplit(recipe, ",");
	  lsPrintln("After csplit");
	  done = true;
	  local done = makeRecipe(recipeList, window);
	  if done then
	    break;
	  end
	else
	  lsPrintln("No recipe for " .. table.concat(tags, ","));
	end
      end
      while clickAllImages("Cancel.png") == 1 do
	sleepWithStatus(200, types[i] .. " not found: Cancel");
      end
    end
  end
end

function addRequirements(tags, lines, sign)
  for i=1,#lines do
    for j=1,#properties do
      if string.match(lines[i][2], properties[j]) then
	table.insert(tags, props[j] .. sign);
	break;
      end
    end
  end
end

function makeRecipe(recipe, window)
  statusScreen("Checking ingredients: " .. table.concat(recipe, ", "));
  local ingredients = findIngredients(recipe);
  if #ingredients < 5 then
    askForWindow("Not enough essences for recipe "
		 .. table.concat(recipe, ", "));
    return false;
  end

  local t = nil;
  for i=1,#ingredients do
    statusScreen("Adding Essence of " .. recipe[i]);
    safeClick(ingredients[i][0]+10, ingredients[i][1]+5);
    waitForText("many?", 5000, "", nil, NOPIN);
    srKeyEvent("7\n");
    local ingredientWindow = getWindowBorders(ingredients[i][0]+10,
					      ingredients[i][1]+5);
    safeClick(ingredientWindow.x + 2, ingredientWindow.y + 2);

    t = waitForText("Manufacture");
    safeClick(t[0]+10, t[1]+5);
    t = waitForText("Essential Mixture");
    safeClick(t[0]+10, t[1]+5);
    t = waitForText("Add Essence");
    safeClick(t[0]+10, t[1]+5);

    local done = false;
    while not done do
      local spot = findWithoutParen(recipe[i]);
      if spot then
	safeClick(spot[0]+10, spot[1]+5);
	done = true;
      end
      checkBreak();
    end
  end

  statusScreen("Mixing Compound");
  t = waitForText("Manufacture");
  safeClick(t[0]+10, t[1]+5);
  t = waitForText("Essential Mixture");
  safeClick(t[0]+10, t[1]+5);
  t = waitForText("Mix Comp");
  safeClick(t[0]+10, t[1]+5);
  waitForText("do you wish to name it?");
  srKeyEvent("autocompound\n");
  sleepWithStatus(300, "Updating");
  clickAllText("This is a Chemistry Lab");
  sleepWithStatus(300, "Updating");
  t = waitForText("Take...");
  safeClick(t[0]+10, t[1]+5);
  t = waitForText("Everything");
  safeClick(t[0]+10, t[1]+5);
  statusScreen("Creating extract");
  t = waitForText("Essential Comp", nil, "Waiting for autocompound",
		  makeBox(window.x + 10, window.y,
			  window.width - 10, window.height));
  safeClick(t[0]+10, t[1]+5);
  sleepWithStatus(200);
  clickAllImages("Okb.png");
  sleepWithStatus(200);
  return true;
end

function findIngredients(names)
  local result = {};
  for i=1,#names do
    local current = findTextPrefix(names[i]);
    if current then
      local window = getWindowBorders(current[0], current[1]);
      safeClick(window.x+2, window.y+2);
      lsSleep(100);
      current = findTextPrefix(names[i], window);
      if current then
	local first, len, match = string.find(current[2], "%(([0-9]+)");
	local count = tonumber(match);
	if count and count >= 7 then
	  table.insert(result, current);
	elseif count then
	  lsPrintln("No essences for: " .. names[i] .. " (" .. count .. ")");
	else
	  lsPrintln("No count for: " .. names[i]);
	end
      end
    end
  end
  return result;
end

function findTextPrefix(text, window)
  local result = nil;
  local matches = findAllText(text, window);
  for i=1,#matches do
    local first = string.find(matches[i][2], text);
    if first == 1 then
      result = matches[i];
      break;
    end
  end
  return result;
end

function findWithoutParen(text)
  local result = nil;
  local matches = findAllText(text);
  for i=1,#matches do
    local found = string.match(matches[i][2], "%(");
    if not found then
      result = matches[i];
      break;
    end
  end
  return result;
end
