
dofile("common.inc");

function doit()
  local tree = loadNotes("scripts/chem-cheap.txt");
  browseMenu(tree);
end

function browseMenu(tree)
  local done = false;
  local tags = {};
  local nextIndex = 1;
  while not done do
    local y = 0;
    for i=1,#tags do
      y = y + 30;
      lsPrint(40, y, 0, 0.9, 0.9, 0xd0d0d0ff, tags[i]);
    end
    local nextTags = lookupData(tree, tags);
    if not nextTags then
      lsPrint(10, y, 0, 0.7, 0.7, 0xffd0d0ff, "No note found");
      y = y + 30;
    elseif type(nextTags) == "table" then
      table.sort(nextTags);
      for i=1,#nextTags do
	local x = 40;
	if i % 2 == 0 then
	  x = 160;
	else
	  y = y + 30;
	end
	if lsButtonText(x, y, 0, 100, 0xd0ffd0ff, nextTags[i]) then
	  table.insert(tags, nextTags[i]);
	end
      end
      y = y + 30;
--      if nextTags[1] ~= "" then
--	table.insert(nextTags, 1, "");
--      end
--      nextIndex = lsDropdown("NoteIndex", 40, y, 0, 250, nextIndex, nextTags);
--      if nextIndex ~= 1 then
--	table.insert(tags, nextTags[nextIndex]);
--	nextIndex = 1;
--      end
    else
      y = y + 30;
      lsPrintWrapped(10, y, 0, lsScreenX - 20, 0.7, 0.7, 0xffffffff, nextTags);
    end

    if lsButtonText(10, lsScreenY - 30, 0, 100, 0xffffffff, "Restart") then
      if #tags > 0 then
--	table.remove(tags);
	tags = {};
	nextIndex = 1;
      else
--	done = true;
      end
    end

    if lsButtonText(lsScreenX - 110, lsScreenY - 30, 0, 100, 0xffffffff,
		    "End Script") then
      error(quit_message);
    end
    checkBreak();
    lsSleep(tick_delay);
    lsDoFrame();
  end
end

function setLine(tree, line)
  --local sections = csplit(line, "|");
  local sections = explode("|",line);
  if #sections ~= 2 then
    error("Cannot parse line: " .. line);
  end
  --local tags = csplit(sections[1], ",");
  local tags = explode(",",sections[1]);
  local data = sections[2];
  setData(tree, tags, data);
end

function setData(tree, tags, data, index)
  if not index then
    index = 1;
  end
  if #tags == index then
    tree[tags[index]] = data;
  else
    local current = tags[index];
    if type(tree[current]) ~= "table" then
      tree[current] = {};
    end
    setData(tree[current], tags, data, index + 1);
  end
end

function lookupData(tree, tags, index)
  if not index then
    index = 1;
  end
  local result = {};
  if tree == nil then
    result = nil;
  elseif type(tree) ~= "table" then
    result = tree;
  elseif #tags < index then
    for key,value in pairs(tree) do
      table.insert(result, key);
    end
  else
    local current = tags[index];
    result = lookupData(tree[current], tags, index + 1);
  end
  return result;
end

function dataToLine(prefix, value)
  local result = "";
  for i=1,#prefix do
    result = result .. prefix;
    if i ~= #prefix then
      result = result .. ",";
    end
  end
  result = result .. "|" .. value;
  return result;
end

function lookupAllData(prefix, tree, result)
  for key,value in pairs(tree) do
    table.insert(prefix, key);
    if type(value) == "table" then
      lookupAllData(prefix, value, result);
    else
      table.insert(result, dataToLine(prefix, value));
    end
    table.remove(prefix);
  end
end

function loadNotes(filename)
  local result = {};
  local file = io.open(filename, "a+");
  io.close(file);
  for line in io.lines(filename) do
    setLine(result, line);
  end
  return result;
end

function saveNotes(filename, tree)
  local file = io.open(filename, "w+");
  local lines = {};
  lookupAllData({}, tree, lines);
  for line in lines do
    file:write(line .. "\n");
  end
  io.close(file);
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

