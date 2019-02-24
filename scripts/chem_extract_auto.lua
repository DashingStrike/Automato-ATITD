dofile("chem_notepad.lua");

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
  cheapRecipes = loadNotes("scripts/chem-cheap.txt");
  allRecipes = loadNotes("scripts/chem-all.txt");
  askForWindow("Setup for this macro is complicated. To view detailed instructions:\n \nClick Exit button, Open Folder button\nDouble click 'chem_extract_auto.txt'.\n \nClick Shift over ATITD window to continue.");
  while true do
    tryAllTypes();
    sleepWithStatus(2000, "Making more magic");
  end
end

function tryAllTypes()
  for i=1,#types do
checkBreak();
    local done = false;
    if typeEnabled[i] then
      statusScreen("Trying type " .. types[i]);
      srReadScreen();
      clickAllText(types[i] .. "'s Compound");
      sleepWithStatus(2750, "Waiting out requirement mutation...");  -- This line added per SomeBob's recommendation on February 23, 2019
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
	  --local recipeList = csplit(recipe, ",");
	  local recipeList = explode(",", recipe);
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
    lsPrintln("Line: " .. lines[i][2]);
    for j=1,#properties do
      if string.match(lines[i][2], properties[j]) or
	(properties[j] == "Toxic" and string.match(lines[i][2], "Txic"))
      then
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
    local status = "Recipe: " .. table.concat(recipe, ", ") .. "\n\n\n" ..
      "Adding Essence of " .. recipe[i];
--    statusScreen("Adding Essence of " .. recipe[i]);
    safeClick(ingredients[i][0]+10, ingredients[i][1]+5);
    waitForText("many?", 5000, status, nil, nil, NOPIN);
    srKeyEvent("7\n");
    local ingredientWindow = getWindowBorders(ingredients[i][0]+10,
					      ingredients[i][1]+5);
    safeClick(ingredientWindow.x + 2, ingredientWindow.y + 2);

    t = waitForText("Manufacture...", nil, status);
    safeClick(t[0]+10, t[1]+5);
    t = waitForText("Essential Mixture", nil, status);
    safeClick(t[0]+10, t[1]+5);
    t = waitForText("Add Essence", nil, status);
    safeClick(t[0]+10, t[1]+5);

    t = waitForText(recipe[i], nil, status, nil, EXACT);
    clickText(t);
  end

  local status = "Mixing Compound";
  t = waitForText("Manufacture...", nil, status);
  safeClick(t[0]+10, t[1]+5);
  t = waitForText("Essential Mixture", nil, status);
  safeClick(t[0]+10, t[1]+5);
  t = waitForText("Mix Comp", nil, status);
  safeClick(t[0]+10, t[1]+5);
  waitForText("lZUlll", nil, status);
  srKeyEvent("autocompound\n");
  sleepWithStatus(300, status);
  clickAllText("This is [a-z]+ Chemistry Lab", nil, REGEX);
  sleepWithStatus(500, status);
  t = waitForText("Take...", nil, status);
  safeClick(t[0]+10, t[1]+5);
  t = waitForText("Everything", nil, status);
  safeClick(t[0]+10, t[1]+5);
  sleepWithStatus(500, status);
  srReadScreen();
  statusScreen("Creating extract", nil, status);
  requiredWindow = findText("Required:", nil, REGION);
  t = findText("Required:", requiredWindow);
  safeClick(t[0]+20, t[1]+135);
  sleepWithStatus(200, status);
  clickAllImages("Ok.png");
  sleepWithStatus(200, status);
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

-- Added in an explode function (delimiter, string) to deal with broken csplit.
function explode(d,p)
   local t, ll
   t={}
   ll=0
   if(#p == 1) then
      return {p}
   end
   while true do
      l = string.find(p, d, ll, true) -- find the next d in the string
      if l ~= nil then -- if "not not" found then..
         table.insert(t, string.sub(p,ll,l-1)) -- Save it in our array.
         ll = l + 1 -- save just after where we found it for searching next time.
      else
         table.insert(t, string.sub(p,ll)) -- Save what's left in our array.
         break -- Break at end, as it should be, according to the lua manual.
      end
   end
   return t
end

