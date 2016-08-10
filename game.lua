local game={}

game.map=Map:new(20,20,20,20,20)

game.enemy={}
game.tower={}
game.bullet={}
game.frag={}
game.cd=0
game.cd_time=60
game.enemyCount=0
game.money=100
game.time=0
game.towerLevel=1
local font = love.graphics.newFont(64)
function game:addEnemy()
	self.cd=self.cd-1
	if self.cd<0 then
		self.cd=self.cd_time
		self.cd_time=self.cd_time-0.1
		if self.cd_time<5 then self.cd_time =5 end
		self.enemyCount=self.enemyCount+1
		table.insert(self.enemy, Enemy:new(self.map,50+self.enemyCount*5))
	end
end


function game:update()
	game.time= game.time+love.timer.getDelta()
	game:addEnemy()
	self.map:select()
	for i,v in ipairs(self.enemy) do
		v:update()
		if v.destroy then
			table.remove(self.enemy, i)
		end
	end
	for i,v in ipairs(self.tower) do
		v:update()
	end
	for i,v in ipairs(self.bullet) do
		v:update()
		if v.destroy then
			table.remove(self.bullet, i)
		end
	end
	for i,v in ipairs(self.frag) do
		v:update()
		if v.destroy then
			table.remove(self.frag, i)
		end
	end

end

function game:draw()
	self.map:draw()
	for i,v in ipairs(self.enemy) do
		v:draw()
	end
	for i,v in ipairs(self.tower) do
		v:draw()
	end
	for i,v in ipairs(self.bullet) do
		v:draw()
	end
	for i,v in ipairs(self.frag) do
		v:draw()
	end
	if game.gameover then
		love.graphics.setColor(0,0,0)
		love.graphics.rectangle("fill", 0, 0, 800,600)
		love.graphics.setColor(255,255,255)
		love.graphics.setFont(font)
		love.graphics.print("GAME OVER", 200,200)
	end
end

function game.keypressed(key)
	if key=="u" then
		if game.mony>=game.towerLevel*1000 then
			game.money=game.money-game.towerLevel*1000
			game.towerLevel=game.towerLevel+1
			for i,v in ipairs(self.tower) do
				v.level=v.level+1
			end
		end
	end
	if game.gameover then
		love.event.quit()
	end
end

return game







