local convexhull = require("convexhull")

local function debugInfo(vec)
	return " { x="..vec.x .. " , y = " .. vec.y .. " } "
end
local function printTable( t)
	for i,v in ipairs(t) do
		print(i,debugInfo(v))
	end
end 

local function testgiftWrapping()
	local t = {	
				convexhull.vec(1,2),
				convexhull.vec(1,1),
				convexhull.vec(2,1),
				convexhull.vec(0,0),
				convexhull.vec(0,-1)
			  }
	local hull = convexhull.giftWrapping(t) 
	printTable(hull)
end

local function testGrahamScan()
	local t = {	
				convexhull.vec(1,2),
				convexhull.vec(1,1),
				convexhull.vec(2,1),
				convexhull.vec(0,0),
				convexhull.vec(0,-1)
			  }
	local hull = convexhull.GrahamScan(t)
	printTable(hull)
end



testgiftWrapping()
print("------")
testGrahamScan()