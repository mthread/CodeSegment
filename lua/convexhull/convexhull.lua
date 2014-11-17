local Deviation = 0.01

local function clone(t)
	local o = {}
	for i,v in ipairs(t) do
		o[i] = v
	end
	return o
end

local function vec(x,y)
 	return {x=x, y=y}
end

local function cross(p1,p2,p3)
 	return 	(p2.x - p1.x)*(p3.y - p1.y)
   	      - (p2.y - p1.y)*(p3.x - p1.x) 
end 

local function getLeftIndex(points)
	local size = #points
	local leftIndex = 1
	for i=2,size do
		if points[i].x < points[leftIndex].x 
		then 
			leftIndex = i 
		end

		if 	points[i].x == points[leftIndex].x 
		and points[i].y < points[leftIndex].y 
		then 
			leftIndex = i 
		end
	end
	return leftIndex
end

local function longer(startP,endP1,endP2)
 	return ((endP2.x - startP.x)^2 + (endP2.y - startP.y)^2)
  		-  ((endP1.x - startP.x)^2 + (endP1.y - startP.y)^2)
  		>  Deviation
end

--判断(startP,midP)组成向量 a 是否顺时针旋转一个在 [0,180)区间的角度 β 后能与(startP,checkP)组成的向量 b 共线
--如果β 在(0,180)范围，则返回true
--如果β == 0 若，|b| > |a| 则，返回true 注意：如果midp 和 checkP是在误差范围内的相同点，返回的是false
local function isBetterVertice(startP,midP,checkP)
	local crossResult = cross(startP,midP,checkP)
	--crossResult<0 则，则顺时针
	-- >0 则，逆时针
	-- =0 则，共线
	if  crossResult < 0 then 
	 return true 
	end

	if crossResult < Deviation 
	and longer(startP,midP,checkP) 
	then 
		return true 
	end

	return false
end

local function stackValue(t,index)
	local index = index and index or -1
	local size = #t
	if index >0 and index <=size then return t[index] end
	if index <0 and index >=-size then return t[size +1 +index] end
	return nil
end

local function stackTop(t)
 	return t[#t]
end 



local function stackPush(t,v)
 	t[#t+1] = v
end

local function stackPop(t)
 	local pop = t[#t]
 	table.remove(t,#t)
 	return pop
end 
local function sortPoints(points)
	local leftIndex = getLeftIndex(points)
	local leftPoint = points[leftIndex]

	local function cmpFunction(vec1,vec2)
		return isBetterVertice(leftPoint,vec2, vec1)
	end
	local tempT = clone(points)
	table.remove(tempT,leftIndex)
	table.sort( tempT, cmpFunction) -- 排序
	table.insert(tempT,1,leftPoint)
	
	return tempT
end

local function GrahamScan(points)
	local  pointCount = #points
	if pointCount < 3 then return nil end

	local tempT = sortPoints(points)
	pointCount = #tempT
	local hull = {}
	stackPush(hull,tempT[1])
	stackPush(hull,tempT[2])

	for i=3, pointCount do
		local sp = stackValue(hull, -2)
		local mp = stackValue(hull, -1)
		local cp = tempT[i]

		if  isBetterVertice(sp,mp,cp)
		then 
			stackPop(hull)
			stackPush(hull,tempT[i])
		else
			stackPush(hull,tempT[i])
		end
	end

	return hull
end 


local function giftWrapping(points)
	local  pointCount = #points
	if pointCount < 3 then return nil end

	local leftIndex = getLeftIndex(points)
	local preIndex = leftIndex
	local hull = {}
	repeat
		table.insert(hull,#hull+1,points[preIndex])
		local bestIndex = 1

		for i=2,pointCount do
			if  bestIndex == preIndex 
			or  isBetterVertice(points[preIndex],points[bestIndex],points[i]) 
			then
				bestIndex = i
			end
		end

		preIndex = bestIndex
	until (preIndex == leftIndex)

	return hull
end


return {
	giftWrapping = giftWrapping,
	GrahamScan = GrahamScan,
	vec = vec
}
