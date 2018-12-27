dofile("common.inc");

local distance_scale = 0.50; -- only scans pixels within a distance of this percentage from the center of the screen



function getCenterPos()
	xyWindowSize = srGetWindowSize();
	local ret = {};
	ret[0] = xyWindowSize[0] / 2;
	ret[1] = xyWindowSize[1] / 2;
	return ret;
end


function isWithinRange(x, y)
	local radius = xyWindowSize[0] * 0.15;
	local dx, dy, d;
	dx = x - getCenterPos()[0];
	dy = y - getCenterPos()[1];
	if (dx*dx + dy*dy <= radius*radius) then
		return 1;
	end
	
	return nil;
end


function clickMouseSplatter(x, y, right)
	--srSetMousePos(x, y);
	srClickMouse(x + math.random(-2, 2), y + math.random(-2, 2), right);
	srReadScreen();
	unpin = srFindImage("UnPin.png")
	if unpin then
	  clickAllImages("Unpin.png", 5, 3, 1);
	end
end


function clickAllImages(image_name, offsetX, offsetY, rightClick, tol)
  if not image_name then
    error("Incorrect number of arguments for clickAllImages()");
  end

  srReadScreen();
  local buttons = findAllImages(image_name, nil, tol);
  clickAllPoints(buttons, offsetX, offsetY, rightClick);
  return #buttons;
end


function doit()
	askForWindow("Click Silt while you run around.\nRequires Automato v2.31 or above.\n\nUse F5 camera zoomed out about half way.\n\nRun around with arrows keys after macro begins, stop moving if it fails to pick something.\n\nInterface Options | Right-Click opens a Menu as Pinned must be ON.\n\nVideo | Time-of-Day Lighting must be at LOWEST (off).");


	getCenterPos();
	srReadScreen();

	while true do
		local frame_start = lsGetTimer();
		statusScreen("Watching for Silt (Red Dots)", nil, 0.7, 0.7);
		-- Looks for pixels whose red is between 0xA0 and 0xFF (160-255), and green/blue are less than 0x60
		clusters = lsAnalyzeCustom(7, 40, 1, xyWindowSize[0] * distance_scale, 0xcac2b7FF, 0xe7e2d9FF, true);
		local clicked = nil;
		if clusters then
			for i = 1, #clusters do
				-- bias because it seems to drag to the upper left, take this off
				--  if I fix the downsampling
				clusters[i][0] = clusters[i][0] + 5;
				--clusters[i][1] = clusters[i][1] + 5;
				if isWithinRange(clusters[i][0], clusters[i][1]) then
				
					-- srClickMouse(clusters[i][0], clusters[i][1], 1);
					-- srSetMousePos(clusters[i][0], clusters[i][1]);

					-- code to try to make sure the pixel is the right color
					-- off by a few pixels in translation, maybe?  needs to be pixel accurate!
					local good;
					local r, g, b;
					if nil then
						pxval = srReadPixel(clusters[i][0], clusters[i][1]);
						a = pxval % 256;
						pxval = (pxval - a) / 256;
						b = pxval % 256;
						pxval = (pxval - b) / 256;
						g = pxval % 256;
						pxval = (pxval - g) / 256;
						r = pxval % 256;
						if (r > 130 and g > 130 and b < 20 and math.abs(r - g) < 20) then
							good = 1;
						end
					else
						r = 0;
						g = 0;
						b = 0;
						good = 1;
					end
					
					if good then
						lsPrint(10, 80 + i*20, 0, 0.7, 0.7, 0xFFFFFFff, clusters[i][0] .. ", " .. clusters[i][1] .. " : " .. r .. "," .. g .. "," .. b);
						clickMouseSplatter(clusters[i][0], clusters[i][1], 1);
						clicked = 1;
					else
						lsPrint(10, 80 + i*20, 0, 0.7, 0.7, 0xFF7F7Fff, clusters[i][0] .. ", " .. clusters[i][1] .. " : " .. r .. "," .. g .. "," .. b);
					end
				else 
					lsPrint(10, 80 + i*20, 0, 0.7, 0.7, 0x7F7F7Fff, clusters[i][0] .. ", " .. clusters[i][1] );
				end
			end
		end
		
		lsSleep(50);
	end
end
