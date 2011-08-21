
function draw_face_x(x, y)
    s = 100
    love.graphics.quad("fill", x+0, y+0, x+s*math.sin(math.pi/3), y+s/2, x+s*math.sin(math.pi/3), y+s*1.5, x+0, y+s)
    love.graphics.quad("fill", x+0, y+0, x+s*math.sin(math.pi/3), y+s/2, x+s*math.sin(math.pi/3), y+s*1.5, x+0, y+s)
end

function draw_face_y(x, y)
    s = 100
    love.graphics.quad("fill", x+0, y+0, x+s*math.sin(math.pi/3), y+s/2, x+s*math.sin(math.pi/3), y+s*1.5, x+0, y+s)
end

function draw_face_z(x, y)
    s = 100
    love.graphics.quad("fill", x+0, y+0, x+s*math.sin(math.pi/3), y-s/2, x+s*math.sin(math.pi/3)*2, x+0, x+s*math.sin(math.pi/3), y+s/2)
end
