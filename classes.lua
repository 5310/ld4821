-----------
--classes--
-----------

    
    
--level--

Level = {}
Level.__index = Level                                                       	-- setting pseudo-class index
function Level.create()
	local self = {}                                                         	-- creating pseudo-instance object 
	setmetatable(self, Level)                                               	-- sets metatable for pseudo-instance behavior
	--begin initialize stuff
	self.origin = {x=width/2, y=height/2}
	self.scroll = {x=0, y=0}
	self.data = {                                                           
				x = {
					{
					{1, 1},
					{1, 1},
					},
					{
					{1, 0},
					{0, 0},
					},
					{
					{0, 0},
					{0, 0},
					}                        
				},
				y = {
					{
					{1, 1},
					{1, 1},
					},
					{
					{1, 0},
					{0, 0},
					},
					{
					{0, 0},
					{0, 0},
					}                        
				},
				z = {
					{
					{1, 1},
					{1, 1},
					},
					{
					{1, 0},
					{0, 0},
					},
					{
					{0, 0},
					{0, 0},
					}                        
				}
				}
	self.sortedData = {}

	--finish initializing stuff
	return self                                                             	-- returns pseudo-instance object
end

function Level:draw()
	for key, object in pairs(self.sortedData) do 
		object:draw()
		love.graphics.print( object.depth , 10, key*10)                     	-- DEBUG
	end
end

function Level:sortTiles()
	table.sort(self.sortedData, function(a,b) return a.depth<b.depth end)   	-- sort by depth
end

function Level:update(dt)
	self:sortTiles()
	for key, object in pairs(self.sortedData) do
		object:update(dt, {x=self.origin.x+self.scroll.x, y=self.origin.y+self.scroll.y})
	end
end

function Level:insertData(tile)
	table.insert(self.sortedData, tile)
end

function Level:panScroll(dt, off)
	self.scroll.x = self.scroll.x - (off.x+self.scroll.x)/(dt*5000)
	self.scroll.y = self.scroll.y - (off.y+self.scroll.y)/(dt*5000)
end



--------------------------------------------------------------------------------

--Tile--

Tile = {}
Tile.__index = Tile
Tile.scale = {}
Tile.scale.iso = 100
Tile.scale.abs = {
				 x = {width = Tile.scale.iso*math.sin(math.pi/3), height = Tile.scale.iso*1.5},
				 y = {width = Tile.scale.iso*math.sin(math.pi/3), height = Tile.scale.iso*1.5},
				 z = {width = Tile.scale.iso*math.sin(math.pi/3)*2, height = Tile.scale.iso}
				 }
function Tile.create(axis, scroll, iso)
	local self = {}
	setmetatable(self, Tile)
	
	self.axis = axis
	
	self.scroll = scroll
	
	self.iso = iso
	
	self:calculateOffset()
	self:calculateDepth()
	
	return self            
end

function Tile:calculateDepth()
	--self:calculateOffset()
	self.depth = (self.off.y / (Tile.scale.iso/2)) + self.iso.z*100          	-- constant should at least be the maximum level dimension, player depth should increment all by 0.5
end

function Tile:calculateOffset()
	self.off = {}
	if self.axis == 'x' then
		self.off.x = Tile.scale.abs.x.width * ((self.iso.x-1) - (self.iso.y-1))
		self.off.y = Tile.scale.abs.x.height/3 * ((self.iso.x-1) + (self.iso.y-1)) - Tile.scale.abs.x.height*2/3 * (self.iso.z-1)
	elseif self.axis == 'y' then
		self.off.x = (Tile.scale.abs.z.width)/2 * ((self.iso.x-1) - (self.iso.y-1))
		self.off.y = (Tile.scale.abs.z.height)* ( ((self.iso.x-1) + (self.iso.y-1))/2 - (self.iso.z-1) )
	elseif self.axis == 'z' then
		self.off.x = (Tile.scale.abs.z.width)/2 * ((self.iso.x-1) - (self.iso.y-1))
		self.off.y = (Tile.scale.abs.z.height)* ( ((self.iso.x-1) + (self.iso.y-1))/2 - (self.iso.z-1) )
	end
end

function Tile:draw()
	self:calculateDepth()
	
	if self.axis == 'x' then
		love.graphics.setColor( 58, 58, 58, 100)
		love.graphics.quad(
						  "fill", 
						  self.scroll.x-Tile.scale.abs.x.width + self.off.x, self.scroll.y-Tile.scale.abs.x.height/3 + self.off.y, 
						  self.scroll.x + self.off.x, self.scroll.y-Tile.scale.abs.x.height*2/3 + self.off.y,
						  self.scroll.x + self.off.x, self.scroll.y + self.off.y,
						  self.scroll.x-Tile.scale.abs.x.width + self.off.x, self.scroll.y+Tile.scale.abs.x.height/3 + self.off.y
						  )
	elseif self.axis == 'y' then                                            	-- TODO does not draw y-facing tile, yet
		love.graphics.setColor( 20, 20, 20, 100)
		love.graphics.quad(
						  "fill", 
						  self.scroll.x + self.off.x, self.scroll.y-Tile.scale.abs.y.height*2/3 + self.off.y,
						  self.scroll.x+Tile.scale.abs.y.width + self.off.x, self.scroll.y-Tile.scale.abs.y.height/3 + self.off.y, 
						  self.scroll.x+Tile.scale.abs.y.width + self.off.x, self.scroll.y+Tile.scale.abs.y.height/3 + self.off.y,
						  self.scroll.x + self.off.x, self.scroll.y + self.off.y
						  )
	elseif self.axis == 'z' then
		love.graphics.setColor( 105, 105, 105, 100)
		love.graphics.quad(
						  "fill", 
						  self.scroll.x-Tile.scale.abs.z.width/2 + self.off.x, self.scroll.y+Tile.scale.abs.z.height/2 + self.off.y, 
						  self.scroll.x + self.off.x, self.scroll.y + self.off.y,
						  self.scroll.x+Tile.scale.abs.z.width/2 + self.off.x, self.scroll.y+Tile.scale.abs.z.height/2 + self.off.y,
						  self.scroll.x + self.off.x, self.scroll.y+Tile.scale.abs.z.height + self.off.y
						  )
	end
end

function Tile:update(dt, scroll)
	--self:calculateOffset()                                                	-- NOTE don't turn it on unless planning to more tiles around
	self:panScroll(scroll)
end

function Tile:panScroll(scroll)
	self.scroll = scroll
end



--------------------------------------------------------------------------------

--Player--

Player = {}
Player.__index = Player
function Player.create(g, scroll, iso, f)
	local self = {}
	setmetatable(self, Player)
	
	self.g = g                                                            
	self:setAxis()                                                        
		 
	self.scroll = scroll
	
	self.iso = iso
	
	self.f = f
	
	self:calculateOffset()
	self:calculateDepth()
	
	self.state = 0
	
	self.keys = {}
	
	return self     
end

function Player:calculateDepth()
	--self:calculateOffset()
	self.depth = (self.off.y / (Tile.scale.iso/2))+0.5 + self.iso.z*100       	-- constant should at least be the maximum level dimension
end

function Player:calculateOffset()
	self.off = {}
	if self.axis == 'x' then
		self.off.x = Tile.scale.abs.x.width * ((self.iso.x-1) - (self.iso.y-1))
		self.off.y = Tile.scale.abs.x.height/3 * ((self.iso.x-1) + (self.iso.y-1)) - Tile.scale.abs.x.height*2/3 * (self.iso.z-1)
	elseif self.axis == 'y' then
		self.off.x = (Tile.scale.abs.z.width)/2 * ((self.iso.x-1) - (self.iso.y-1))
		self.off.y = (Tile.scale.abs.z.height)* ( ((self.iso.x-1) + (self.iso.y-1))/2 - (self.iso.z-1) )
	elseif self.axis == 'z' then
		self.off.x = (Tile.scale.abs.z.width)/2 * ((self.iso.x-1) - (self.iso.y-1))
		self.off.y = (Tile.scale.abs.z.height)* ( ((self.iso.x-1) + (self.iso.y-1))/2 - (self.iso.z-1) )
	end
end

function Player:draw()
	self:calculateDepth()
																				-- TODO facing and gravity
	if self.axis == 'x' then
	
		love.graphics.setColor( 10, 10, 10, 255)
		if self.f.y < 0 then
			love.graphics.circle("fill", self.scroll.x+self.off.x+Tile.scale.iso*0.2-2.5, self.scroll.y+self.off.y-Tile.scale.iso*0.1, Tile.scale.iso*0.2, 6)
		elseif self.f.z < 0 then
			love.graphics.circle("fill", self.scroll.x+self.off.x, self.scroll.y+self.off.y+Tile.scale.iso*0.2, Tile.scale.iso*0.2, 6)
		end
		
		love.graphics.setColor( 255, 255, 255, 255)
		if self.g.x < 0 then
			love.graphics.circle("fill", self.scroll.x+self.off.x-Tile.scale.iso*0.4+4, self.scroll.y+self.off.y-Tile.scale.iso*0.2, Tile.scale.iso*0.2, 6)
			love.graphics.circle("fill", self.scroll.x+self.off.x-Tile.scale.iso*0.2+2, self.scroll.y+self.off.y-Tile.scale.iso*0.1, Tile.scale.iso*0.2, 6)
			love.graphics.circle("fill", self.scroll.x+self.off.x, self.scroll.y+self.off.y, Tile.scale.iso*0.2, 6)
		elseif self.g.x > 0 then
			love.graphics.circle("fill", self.scroll.x+self.off.x+Tile.scale.iso*0.4-4, self.scroll.y+self.off.y+Tile.scale.iso*0.2, Tile.scale.iso*0.2, 6)
			love.graphics.circle("fill", self.scroll.x+self.off.x+Tile.scale.iso*0.2-2, self.scroll.y+self.off.y+Tile.scale.iso*0.1, Tile.scale.iso*0.2, 6)
			love.graphics.circle("fill", self.scroll.x+self.off.x, self.scroll.y+self.off.y, Tile.scale.iso*0.2, 6)
		end
		
		love.graphics.setColor( 10, 10, 10, 255)
		if self.f.y > 0 then
			love.graphics.circle("fill", self.scroll.x+self.off.x-Tile.scale.iso*0.2+2.5, self.scroll.y+self.off.y+Tile.scale.iso*0.1, Tile.scale.iso*0.2, 6)
		elseif self.f.z > 0 then
			love.graphics.circle("fill", self.scroll.x+self.off.x, self.scroll.y+self.off.y-Tile.scale.iso*0.2, Tile.scale.iso*0.2, 6)
		end
		
	elseif self.axis == 'y' then
	
		love.graphics.setColor( 10, 10, 10, 255)
		if self.f.x < 0 then    
			love.graphics.circle("fill", self.scroll.x+self.off.x-Tile.scale.iso*0.2+2, self.scroll.y+self.off.y-Tile.scale.iso*0.1, Tile.scale.iso*0.2, 6)
		elseif self.f.z < 0 then
			love.graphics.circle("fill", self.scroll.x+self.off.x, self.scroll.y+self.off.y+Tile.scale.iso*0.2, Tile.scale.iso*0.2, 6)
		end
		
		love.graphics.setColor( 255, 255, 255, 255)
		if self.g.y < 0 then
			love.graphics.circle("fill", self.scroll.x+self.off.x+Tile.scale.iso*0.4-4.5, self.scroll.y+self.off.y-Tile.scale.iso*0.2, Tile.scale.iso*0.2, 6)
			love.graphics.circle("fill", self.scroll.x+self.off.x+Tile.scale.iso*0.2-2.5, self.scroll.y+self.off.y-Tile.scale.iso*0.1, Tile.scale.iso*0.2, 6)
			love.graphics.circle("fill", self.scroll.x+self.off.x, self.scroll.y+self.off.y, Tile.scale.iso*0.2, 6)
		elseif self.g.y > 0 then
			love.graphics.circle("fill", self.scroll.x+self.off.x-Tile.scale.iso*0.4+4.5, self.scroll.y+self.off.y+Tile.scale.iso*0.2, Tile.scale.iso*0.2, 6)
			love.graphics.circle("fill", self.scroll.x+self.off.x-Tile.scale.iso*0.2+2.5, self.scroll.y+self.off.y+Tile.scale.iso*0.1, Tile.scale.iso*0.2, 6)
			love.graphics.circle("fill", self.scroll.x+self.off.x, self.scroll.y+self.off.y, Tile.scale.iso*0.2, 6)
		end
		
		love.graphics.setColor( 10, 10, 10, 255)
		if self.f.x > 0 then    
			love.graphics.circle("fill", self.scroll.x+self.off.x+Tile.scale.iso*0.2-2, self.scroll.y+self.off.y+Tile.scale.iso*0.1, Tile.scale.iso*0.2, 6)
		elseif self.f.z > 0 then
			love.graphics.circle("fill", self.scroll.x+self.off.x, self.scroll.y+self.off.y-Tile.scale.iso*0.2, Tile.scale.iso*0.2, 6)
		end
		
	elseif self.axis == 'z' then
	
		love.graphics.setColor( 10, 10, 10, 255)
		if self.f.x < 0 then    
			love.graphics.circle("fill", self.scroll.x+self.off.x-Tile.scale.iso*0.2+2, self.scroll.y+self.off.y-Tile.scale.iso*0.1, Tile.scale.iso*0.2, 6)
		elseif self.f.y < 0 then
			love.graphics.circle("fill", self.scroll.x+self.off.x+Tile.scale.iso*0.2-2.5, self.scroll.y+self.off.y-Tile.scale.iso*0.1, Tile.scale.iso*0.2, 6)
		end
	
		love.graphics.setColor( 255, 255, 255, 255)
		if self.g.z < 0 then
			love.graphics.circle("fill", self.scroll.x+self.off.x, self.scroll.y+self.off.y+Tile.scale.iso*0.4, Tile.scale.iso*0.2, 6)
			love.graphics.circle("fill", self.scroll.x+self.off.x, self.scroll.y+self.off.y+Tile.scale.iso*0.2, Tile.scale.iso*0.2, 6)
			love.graphics.circle("fill", self.scroll.x+self.off.x, self.scroll.y+self.off.y, Tile.scale.iso*0.2, 6)
		elseif self.g.z > 0 then
			love.graphics.circle("fill", self.scroll.x+self.off.x, self.scroll.y+self.off.y, Tile.scale.iso*0.2, 6)
			love.graphics.circle("fill", self.scroll.x+self.off.x, self.scroll.y+self.off.y-Tile.scale.iso*0.2, Tile.scale.iso*0.2, 6)
			love.graphics.circle("fill", self.scroll.x+self.off.x, self.scroll.y+self.off.y-Tile.scale.iso*0.4, Tile.scale.iso*0.2, 6)
		end
		
		love.graphics.setColor( 10, 10, 10, 255)
		if self.f.x > 0 then    
			love.graphics.circle("fill", self.scroll.x+self.off.x+Tile.scale.iso*0.2-2, self.scroll.y+self.off.y+Tile.scale.iso*0.1, Tile.scale.iso*0.2, 6)
		elseif self.f.y > 0 then
			love.graphics.circle("fill", self.scroll.x+self.off.x-Tile.scale.iso*0.2+2.5, self.scroll.y+self.off.y+Tile.scale.iso*0.1, Tile.scale.iso*0.2, 6)
		end
		
	end
end

function Player:setAxis()
	if math.abs(self.g.x) == 1 then
		self.axis = 'x'
	elseif math.abs(self.g.y) == 1 then
		self.axis = 'y'
	elseif math.abs(self.g.z) == 1 then
		self.axis = 'z'
	end
end

function Player:update(dt, scroll)
	
	if self.state == 0 then
	
		self:move(dt)                                                       	-- TODO move, will need to hook into more logic
		self:turn(dt)                                                       	-- turn
		
		if love.keyboard.isDown('x') then                                   	-- DEBUG
			self.g.x = self.g.x*-1                                          	-- DEBUG
			self.g.y = self.g.y*-1                                          	-- DEBUG
			self.g.z = self.g.z*-1                                          	-- DEBUG
		end  
		
	elseif self.state == 1 then                                             	-- TODO move keybaord flags onto seperate instance table
		if not love.keyboard.isDown('w') and 
		   not love.keyboard.isDown('s') and 
		   not love.keyboard.isDown('a') and
		   not love.keyboard.isDown('d') and
		   not love.keyboard.isDown('q') and 
		   not love.keyboard.isDown('e') then
			self.state = 0
		end
	end
	
	self:calculateOffset()
	self:panScroll(scroll)
	
end

--function Player:listen(key)                                               	-- separating events, didn't work out
	--self.keys['key'] = 0
--end

--function Player:signal()
	--for key, value in pairs(self.keys) do
		--value = love.keyboard.isDown(key)
	--end
--end

function Player:move(dt)
	
	if love.keyboard.isDown('w') then                                       	-- forward
		self.iso.x = self.iso.x+self.f.x
		self.iso.y = self.iso.y+self.f.y
		self.iso.z = self.iso.z+self.f.z
		self.state = 1
		
	elseif love.keyboard.isDown('s') then                                   	--backward
		self.iso.x = self.iso.x-self.f.x
		self.iso.y = self.iso.y-self.f.y
		self.iso.z = self.iso.z-self.f.z
		self.state = 1
		
	elseif love.keyboard.isDown('a') then                                   	--strafe left
		if math.abs(self.g.x) > 0 then
			self.iso.y = self.iso.y-self.f.z*self.g.x
			self.iso.z = self.iso.z+self.f.y*self.g.x
		elseif math.abs(self.g.y) > 0 then
			self.iso.x = self.iso.x+self.f.z*self.g.y
			self.iso.z = self.iso.z-self.f.x*self.g.y
		elseif math.abs(self.g.z) > 0 then
			self.iso.y = self.iso.y+self.f.x*self.g.z
			self.iso.x = self.iso.x-self.f.y*self.g.z
		end
		self.state = 1
		
	elseif love.keyboard.isDown('d') then                                   	--strafe right
		if math.abs(self.g.x) > 0 then
			self.iso.y = self.iso.y+self.f.z*self.g.x
			self.iso.z = self.iso.z-self.f.y*self.g.x
		elseif math.abs(self.g.y) > 0 then
			self.iso.x = self.iso.x-self.f.z*self.g.y
			self.iso.z = self.iso.z+self.f.x*self.g.y
		elseif math.abs(self.g.z) > 0 then
			self.iso.y = self.iso.y-self.f.x*self.g.z
			self.iso.x = self.iso.x+self.f.y*self.g.z
		end
		self.state = 1
	end
end

function Player:turn(dt)
	if love.keyboard.isDown('q') then                                       	--turn left
			if math.abs(self.g.x) > 0 then
				t = self.f.z
				self.f.z = self.f.y*self.g.x
				self.f.y = -t*self.g.x
			elseif math.abs(self.g.y) > 0 then
				t = self.f.z
				self.f.z = -self.f.x*self.g.y
				self.f.x = t*self.g.y
			elseif math.abs(self.g.z) > 0 then
				t = self.f.x
				self.f.x = -self.f.y*self.g.z
				self.f.y = t*self.g.z
			end
			self.state = 1
			
	elseif love.keyboard.isDown('e') then                                   	--turn right
			if math.abs(self.g.x) > 0 then
				t = self.f.z
				self.f.z = -self.f.y*self.g.x
				self.f.y = t*self.g.x
			elseif math.abs(self.g.y) > 0 then
				t = self.f.z
				self.f.z = self.f.x*self.g.y
				self.f.x = -t*self.g.y
			elseif math.abs(self.g.z) > 0 then
				t = self.f.x
				self.f.x = self.f.y*self.g.z
				self.f.y = -t*self.g.z
			end
			self.state = 1
			
	end
end

function Player:panScroll(scroll)
	self.scroll = scroll
end

									--------
