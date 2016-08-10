local bullet=Class("bullet")

function bullet:initialize(x,y,rot,map,tower,level)
	self.x=x
	self.y=y
	self.map=map
	self.speed=5
	self.rot=rot
	self.size=map.size
	self.range=200+50*level
	self.tower=tower
	self.attack=30+20*level
end

function bullet:hitTest()
	if self.destroy then return end
	for i,v in ipairs(game.enemy) do
		if math.getDistance(self.x,self.y,v.x,v.y)<=self.size then
			self.destroy=true
			local frag=Frag:new(self.x,self.y,self.rot,self:getCanvas())
			table.insert(game.frag, frag)
			v.hp=v.hp-self.attack
			if v.hp<=0 then
				v.destroy=true
				local frag=Frag:new(v.x,v.y,v.rot,v:getCanvas())
				table.insert(game.frag, frag)
				game.money=game.money+5
			end
		end
	end

end

function bullet:outRangeTest()
	if self.destroy then return end
	if self.x<self.map.offX or self.x>self.map.offX+self.map.width*self.size then
		self.destroy=true
		return
	end
	if self.y<self.map.offY or self.y>self.map.offY+self.map.height*self.size then
		self.destroy=true
		return
	end
	if math.getDistance(self.x,self.y,self.tower.x,self.tower.y)>self.range then
		self.destroy=true
		return
	end
end


function bullet:update()
	if self.destroy then return end
	self.x =self.x + math.sin(self.rot)*self.speed
	self.y =self.y - math.cos(self.rot)*self.speed
	self:outRangeTest()
	self:hitTest()
end

function bullet:getCanvas()
	self.canvas = love.graphics.newCanvas(6,6)
	love.graphics.setCanvas(self.canvas)
	love.graphics.setColor(255, 0,0)
	love.graphics.circle("fill", 3,3,3)
	love.graphics.setCanvas()
	return self.canvas
end

function bullet:draw()
	if self.destroy then return end
	love.graphics.setColor(255, 0,0)
	love.graphics.circle("fill", self.x, self.y, 3)
end


return bullet