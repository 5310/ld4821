require('classes.lua')

function love.load()


    ---------
    --setup--
    ---------
    
    width = 800
    height = 450
    fullscreen = false
    love.graphics.setMode(width, height, fullscreen)
    love.graphics.setBackgroundColor(200, 200, 200)                         
    
    ------------------------------------------------------------------------
    
    -----------
    --objects--
    -----------
    
    level = Level.create()                                                      -- initialize level
    
    player = Player.create({x=0, y=0, z=-1},
                      {x=width/2, y=height/2},
                      {x=1, y=1, z=1},
                      {x=1, y=0, z=0})                                          -- initializes player
    level:insertData( player )
                                                                                
    level:insertData(Tile.create('x', {x=width/2, y=height/2}, {x=1, y=1, z=1}))-- DEBUG        
    level:insertData(Tile.create('y', {x=width/2, y=height/2}, {x=1, y=1, z=1}))-- DEBUG
    level:insertData(Tile.create('z', {x=width/2, y=height/2}, {x=1, y=1, z=1}))-- DEBUG
    level:insertData(Tile.create('x', {x=width/2, y=height/2}, {x=2, y=1, z=1}))-- DEBUG
    level:insertData(Tile.create('y', {x=width/2, y=height/2}, {x=1, y=2, z=1}))-- DEBUG
    level:insertData(Tile.create('z', {x=width/2, y=height/2}, {x=1, y=1, z=2}))-- DEBUG
    

end



--------------------------------------------------------------------------------



function love.update(dt)
    level:update(dt)
    level:panScroll(dt, player.off)
end



--------------------------------------------------------------------------------



function love.draw()
    love.graphics.print( love.timer.getFPS() , 10, height-20)                   -- DEBUG
    level:draw()
end
