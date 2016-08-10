local map=Class("map")
local help=[[
	1. the enemies will go from 1 to 5,if it reaches 5 then game over!
	2. left click to build a tower
	3. press u to upgrade all the tower exist and future
	4. kill an enemy will give you 2 money
]]
function map:initialize(x,y,w,h,size)
	self.grid={}
	self.data={}
	self.width=w
	self.height=h
	self.size=size
	self.offX=x
	self.offY=y
	for i=1,h do
		self.data[i]={}
		self.grid[i]={}
		for j=1,w do
			self.data[i][j]={}
			self.grid[i][j]=0
		end
	end
	self:setGoal(5)

end

function map:reset()
	for i=1,self.height do
		for j=1,self.width do
			self.grid[i][j]=0
		end
	end
end

function map:select()
	local x, y = love.mouse.getPosition()
	local gx,gy = math.ceil((x-self.offX)/self.size),math.ceil((y-self.offY)/self.size)
	if gx<1 or gx>self.width or gy <1 or gy>self.height then return end
	if  love.mouse.isDown("l") and self.grid[gy][gx]==0 and game.money>=10+game.towerLevel*10 then
		local oGrid=self.grid[gy][gx]
		self.grid[gy][gx]=-1
		if self:check() then print("Can not pass"); self.grid[gy][gx]=oGrid;return end
		table.insert(game.tower,Tower:new(gx,gy,self,game.towerLevel))
		game.money=game.money-10-game.towerLevel*10
	end
	if  love.mouse.isDown("r") then
		self.grid[gy][gx]=0
	end
end

function map:check()
	local grid=Grid(self.grid)
	for i=1,#self.goal-1 do
		local finder=Pathfinder(grid, 'ASTAR', function(n) return n~=-1 end)
		finder:setMode('ORTHOGONAL')
		if not self.finder:getPath(self.goal[i].x, self.goal[i].y, self.goal[i+1].x, self.goal[i+1].y) then return true end
	end
end


function map:find(startx, starty, endx, endy)
	self.grid_finder=Grid(self.grid)
	self.finder=Pathfinder(self.grid_finder, 'ASTAR', function(n) return n~=-1 end)
	self.finder:setMode('ORTHOGONAL')
	local path=self.finder:getPath(startx, starty, endx, endy)
	if not path then print("no way"); return end	
	local pathTab={}
	for node, count in path:nodes() do
	  pathTab[count]={x=node:getX(),y=node:getY()}
	end
	return pathTab
end

function map:setGoal(count)
	self.goal={}
	for i=1,count do
		local nx,ny=love.math.random(1,self.width),love.math.random(1,self.height)
		self.goal[i]={
			x = nx,
			y = ny
		}
		self.grid[ny][nx]=i
	end

end

function map:draw()
	local size=self.size
	for i=1,self.height do
	    for j= 1,self.width do
		    if self.grid[i][j]~=0 then
		    	love.graphics.setColor(255,100,100)
		    else
		       love.graphics.setColor(0,0,0)
		    end
		    love.graphics.rectangle("fill", (j-1)*(size)+self.offX, (i-1)*(size)+self.offY, size, size)
	    	love.graphics.setColor(100, 100,100)
	    	love.graphics.rectangle("line", (j-1)*(size)+self.offX, (i-1)*(size)+self.offY, size, size)
	    	if self.grid[i][j]>0 then
	    		love.graphics.setColor(255, 255, 255)
		    	love.graphics.print(self.grid[i][j], (j-1+0.2)*(size)+self.offX,(i-1+0.2)*(size)+self.offY)
	    	end
	    end
  	end

  	love.graphics.print("Game Played: ".. string.sub(tostring(game.time), 1, 6) , 500,50)
  	love.graphics.print("Enemy Count: "..tostring(game.enemyCount), 500,100)
  	love.graphics.print("Your Money: "..tostring(game.money), 500,150)
  	love.graphics.print("Current Enemy HP: "..tostring(50+game.enemyCount*5), 500,200)
  	love.graphics.print("Current Tower Attack: "..tostring(30+20*game.towerLevel), 500,250)
  	love.graphics.print("Current Tower Price: "..tostring(10+game.towerLevel*10), 500,300)
  	love.graphics.print("Current Tower Level: "..tostring(game.towerLevel), 500,350)
  	love.graphics.print("Current Upgrade Price: "..tostring(game.towerLevel*1000), 500,400)
  	love.graphics.print(help , 100,500)
end

return map