

-- Serialize a variable (number, string, table, or nested table) to and from a file

function serializeExample(filename)
	local t1 = { { 1, 2, 3 }, { "one", "two", "three" } };
	serialize(t1,filename);
	local t2 = deserialize(filename);
	return t2;
end

function serialize(o, filename)
	local outputFile = io.open("scripts/" .. filename,"w");
	outputFile:write("return\n");
	serializeInternal(o,outputFile);
	outputFile:close();
end

function deserialize(filename)
  if (pcall(dofile,filename)) then
    local parsed = dofile(filename);
    if (type(parsed) == "table") then
      return true, parsed;
    end
  end
  return false, nil;
end




-- This is an internal function and should not be called directly.
function serializeInternal(o,outputFile,indentStr)
	if(not indentStr) then
		indentStr = "";
	end
	if type(o) == "number" then
		outputFile:write(o);
	elseif type(o) == "string" then
		outputFile:write(string.format("%q", o));
	elseif type(o) == "boolean" then
		if(o) then
			outputFile:write("true");
		else
			outputFile:write("false");
		end
	elseif type(o) == "table" then
		outputFile:write(indentStr .. "{\n");
		for k,v in pairs(o) do
			if(type(k) == "number") then
				outputFile:write(indentStr .. "\t[" .. k .. "] = ");
			else
				outputFile:write(indentStr .. "\t[" .. string.format("%q", k) .. "] = ");
			end
			if(type(v) == "table") then
				outputFile:write("\n");
			end
			serializeInternal(v,outputFile,indentStr .. "\t");
			if(type(v) == "table") then
				outputFile:write(indentStr .. "\t,\n");
			else
				outputFile:write(",\n");
			end
		end
		outputFile:write(indentStr .. "}\n");
	else
		error("cannot serialize a " .. type(o));
	end
end


