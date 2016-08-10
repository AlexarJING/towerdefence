local tower=Class("tower")

function tower:initialize(x,y,map,level)
	self.map=map
	self.size=map.size
	self.x=map.offX+x*self.size-0.5*self.size
	self.y=map.offY+y*self.size-0.5*self.size
	self.rot=0
	self.range=50
	self.cd=0
	self.cd_time=60
	self.level=level or 1
end

function tower:enemyDetect()
	local targets={}
	for i,v in ipairs(game.enemy) do
		if math.getDistance(self.x,self.y,v.x,v.y)<=self.range then
			table.insert(targets,v)
		end
	end
	self.target=targets
end


function tower:fire()
	if self.target[1] and self.cd<0 then
		self.cd=self.cd_time
		local rot=math.getRot(self.x,self.y,self.target[1].x,self.target[1].y)
		table.insert(game.bullet, Bullet(self.x,self.y,rot,self.map,self,self.level))
	end
end

function tower:update()
	self.cd=self.cd-1
	self:enemyDetect()
	self:fire()
end

function tower:draw()
	love.graphics.setColor(255, 255, 255 )
	love.graphics.circle("fill", self.x, self.y, 5)
	love.graphics.setColor(50, 255, 50, 10)
	love.graphics.circle("fill", self.x, self.y, self.range)
	if self.target[1] then
		love.graphics.setColor(255*(1-self.cd/self.cd_time),255*(self.cd/self.cd_time),0,100)
		love.graphics.line(self.x, self.y,self.target[1].x,self.target[1].y)
	end
end


return tower