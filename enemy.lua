local enemy=Class("enemy")

function enemy:initialize(map,hp)
	self.x=map.offX+(map.goal[1].x-0.5)*map.size
	self.y=map.offY+(map.goal[1].y-0.5)*map.size
	self.blockX=map.goal[1].x
	self.blockY=map.goal[1].y
	self.groth=0.5
	self.map=map
	self.size=map.size
	self.goal=2
	self.speed=1+game.enemyCount*0.01
	self.rot=0
	self.step=1
	self.path=self.map:find(self.blockX,self.blockY,self.map.goal[self.goal].x,self.map.goal[self.goal].y)
	self.targetBlock=self.path[1]
	self.hp=hp or 100
end

function enemy:getBlock()
	if self.destroy then return end
	local offX,offY =self.map.offX,self.map.offY
	self.blockX,self.blockY= math.ceil((self.x-offX)/self.size),math.ceil((self.y-offY)/self.size)
	
	if self.blockX==self.targetBlock.x and self.blockY==self.targetBlock.y then
		self.path=self.map:find(self.blockX,self.blockY,self.map.goal[self.goal].x,self.map.goal[self.goal].y)
		self.targetBlock=self.path[2]
		
		if self.targetBlock==nil then
			self.goal=self.goal+1
			if self.goal>#self.map.goal then
				self.destroy=true
				game.gameover=true
				return
			end
			self.path=self.map:find(self.blockX,self.blockY,self.map.goal[self.goal].x,self.map.goal[self.goal].y)
			self.targetBlock=self.path[1]
		end
	end

end


function enemy:move()
	if self.destroy then return end
	self.targetX=self.targetBlock.x*self.size-0.5*self.size+self.map.offX
	self.targetY=self.targetBlock.y*self.size-0.5*self.size+self.map.offY
	self.rot= math.getRot(self.x,self.y,self.targetX,self.targetY)
	self.x=self.x+ math.sin(self.rot)*self.speed*1
	self.y=self.y- math.cos(self.rot)*self.speed*1
end

function enemy:die()


end

function enemy:getCanvas()
	self.canvas = love.graphics.newCanvas(self.size*(1+self.groth)/2,self.size*(1+self.groth)/2)
	love.graphics.setCanvas(self.canvas)
	love.graphics.circle("line", self.size*(1+self.groth)/4, self.size*(1+self.groth)/4, self.size*(1+self.groth)/4)
	love.graphics.setCanvas()
	return self.canvas
end


function enemy:update()
	self:getBlock()
	self:move()
end

function enemy:draw()
	if self.destroy then return end
	love.graphics.setColor(255,255,255)
	love.graphics.circle("fill", self.x, self.y, self.size*(1+self.groth)/4)

end


return enemy