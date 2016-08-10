require "lib/util"
love.graphics.setBackgroundColor(200, 200, 200)
love.math.setRandomSeed(os.time())
Grid = require "lib.jumper.grid"
Pathfinder = require "lib.jumper.pathfinder"
Class = require "lib.middleclass"
Map = require "map"
Enemy = require "enemy"
Tower =require "tower"
Bullet = require "bullet"
Frag= require "frag"
function love.load()
	game = require "game"
end


function love.update(dt)
	game:update()
end

function love.draw()
	game:draw()
end

function love.keypressed(k)
	game:keypressed(k)
end