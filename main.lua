require('classes.lua')
require('levels.lua')

function love.load()


    ---------
    --setup--
    ---------
    
    width = 800
    height = 450
    scale = 1
    fullscreen = false
    love.graphics.setMode(width, height, fullscreen)
    love.graphics.setBackgroundColor(200, 200, 200)                         
    
    ------------------------------------------------------------------------
    
    -----------
    --objects--
    -----------
    
    level = Level.create(leveldata02)                                   -- initialize level
    
    player = Player.create({x=0, y=0, z=-1},
                      {x=width/2, y=height/2},
                      {x=1, y=1, z=1},
                      {x=1, y=0, z=0})                                  -- initializes player
    level:insertData( player , 'player')
                                                                                   
    

end



--------------------------------------------------------------------------------



function love.update(dt)
    level:update(dt)
end



--------------------------------------------------------------------------------



function love.draw()
    love.graphics.print( love.timer.getFPS() , 10, height-20)                   -- DEBUG
    --love.graphics.print( level.data[1][1][1][1] , 10, height-40)                   -- DEBUG
    love.graphics.print( player.debug , 10, height-40)                   -- DEBUG
    level:draw()
end
