THIS IS NOT REALLY A README
===========================

But rather a place I will use to jot down ideas for now.

**Don't read, unless you're masochistic.**

Gist
----

- The objective is to reach the exit-door to each level (labeled Escape?)

- The player character cannot jump or fall off ledges.
- Player can move in the following directions; Forwards and backwards, strafe left and right, or turn left and right.

- The levels are inside cubes.
- Nothing can go beyond the bounds of the cube, though. Except, perhaps the Escape-door, which will lead to another cube.

- Walls and Floors are impenetrable. But they're not solid, if you can get past a wall, the cell beyond will be perfectly walkable.
- Walls and Floors are, naturally, semi-transparent, to allow visibility.
- I don't want stairs or elevators in the game, just walls and floors...and doors.

- The main gameplay mechanic is the multicolored doors:
- They allow one to pass through walls (but not beyond the cube boundaries,) if walked straight through.
- However, if one passes through the door by any moving in any direction _but_ forwards, the player will exit to another door of the same color which is facing in the direction the player was facing when entering the first door.
- If there isn't any such door, and the player can move onto the the cell beyond the door, then the player will be moved through like a normal door. (Or rebounded?)
- If there isn't a legitimate cell beyond the door, then the player cannot move through that door, but will be rebounded like a solid wall.
- If there are multiple candidates for any non-forward entry, then the player will be cycled through them when entered in successive iterations.
- One rather neat trick will be to rotating the doors so they exit the player in a direction other than horizontal... Gravity be damned!

Level-Logic
------------

Data for the levels will be stored as a set of three 2D arrays, one for each slice of the cubes. Including the front three faces which are always invisible (but solid), a 2x2x2 cube will have three slices going in three directions.

For every movement, first the horizontal (I should say the parallel with a distance of zero) plane of the player, depending on what gravity he is in, is tested; then the perpendicular one.
	if target cell in parallel plane is legal:
		if target cell in parallel cell is solid:
			if intercepting cell in perpendicular cell is solid:
				rebound
			else:
				stop
		else:
			stop
	else:
		stop
		
For example:
For illustrated cube, the data will be:
X+: (1, 1, 1, 1) (0, 0, 1, 0) (1, 0, 0, 0)		[Eastwards, North top. Top-wise first.]
Y+: (1, 1, 1, 1) (0, 1, 0, 0) (1, 0, 0, 0)		[Southwards, Bottom top. East-wise first.]
Z+:	(1, 1, 1, 1) (1, 1, 1, 0) (0, 0, 0, 0)		[Bottom up, North top. East-wise first.]

																			 A  B  C      P  Q  R
Now, assuming gravity is Z-, which is normal, the player wants to move from (2, 2, 1) to (2, 1, 1), or Y-:
	First we check the parallel plane, for Z-:
	     P  Q         R																			    R+1
		(2, 1, X) on the 1st plane of the Z stack. (If gravity was Z+, upside-down, we would check the 2nd plane:
		[Also, check the stack of the gravity with that axis' value(+a if moving positive), with the other two co-ords of the destination.]
			Now, the perpendicular plane. Movement is by Y, direction unimportant:
				 PA RC        larger of B and Q
				(2, 1) on the 2nd plane (which is between the source and target cells):
				[Also, check the stack of the changing axis with the larger of the changing values with the other two axis which remain the same.]
					Solid wall, rebound.
					        
					                                           A  B  C      P  Q  R
Again, let's assume gravity is Y+. Player wants for move from (1, 2, 2) to (1, 2, 1), which is Z-:
	 A  C-1   Q+1							  [C-1 because player moving Z-]
	(1, 1) on 3rd layer of stack Y is valid.
		 A  B           C-0     [C-0 because movement Z-]
		(1, 2) of layer 2 of stack Z is solid: 
			Don't pass.
			
Now, distilled to logic. Starting from position vector `p` if player from gravity unit vector `g` wants to move in direction unit vector `d`:
	#has initial one for arrays like before
	if d.y:
		wall = stack.get_cell(p.y if d.y<0 else p.y+1, p.x, p.z).pass_logic(g)
		if wall.is_empty():
			if g.x:
				if stack.x.get_cell(g.x if g.x<0 else g.x+1, p.y if d.y>0 else p.y-1, p.z if d.z>0 else p.z-1).is_solid():
					walk()
			...
		elif wall.is_door():
			wall.pass(g, f) #f is facing direction
	...		
			
See, not tough at all!

Consider an alpha fall-off based on distance from player, or, occlusion.

Okay, now that depth has been calculated, we need to make a sorter. For now, we'll have a duplicate Level.tiles table that will be sorted per the .depth property.
As of the player, he will be inserted into the sorted table as per his location, then drawn in one go.

Make doors small, and more opaque colored. No, we'll NEVER have doors obscuring other doors.


Player
------

	--offset
	offset[2]
		x
		y

	--isometric co-ordinates
	iso[3]		--vector
		x
		y
		z
		
	abs[2]		--abs coordinate for drawing
		x
		y
		
	depth 		--draw-order
	
	--gravity
	g[3]		--vector (unit)
		x
		y
		z
	
	--orientation
	face[3]		--vector (unit)
		x
		y
		z

	draw() 		--isn't called directly
	update()	--isn'r called directly, moves and updates draw-order
	control()	-input "


Tile
----

	iso[3]
		x
		y
		z
		
	abs[2]	--absolute location for drawing
		x
		y
		
	depth	--draw-order = screen-space y + isometroc z, remains static

	--properties
	solid	--bolean
	door	--boolean
	open	--boolean
	g[3]	--usually empty for wall/floor/empty
		x
		y
		z
	color	--usually black/white for wall/floor/empty
	face[3]
		x
		y
		z
			
	init()		--adds to list of colored doors, calculates depth
	draw()
	update()	--adds to list of colored doors, and updates when necessary
	
Level
-----

	--offset
	offset[3]
		x
		y

	--dimension
	size[3]		--scalar tuple with three values
		x
		y
		z
		
	tile[3]
		x[size.x][size.z][size.y]
		y[size.y][size.x][size.z]
		z[size.z][size.y][size.x]
		
	isValid(x,y,z)	--checks if coord is valid
		
	addPlayer()		--adds player to level
	draw()			--contains Player.draw(), draws per z-depth
		for lack of a better process, simply iterates through minimum to maximum depth
	update()


Map					--simply a container
---

	levels[]		--contains levels
	
	
	
	
	
	
TODO
====

DONE 	level
	DONE	scrolling
	DONE	depth sorting and queue
	DONE	level parsing
		DONE	function to add tiles that will put them in relevant Level.data array AND insert into Level.dataSorted
		DONE	level format in lua
		DONE	loop to convert level file into level object		
				
DONE	tile
	DONE	base class
	DONE 	base drawing
	DONE 	per-tile scaling and fading
	TODO	door drawing
	
TODO	player
	DONE	base class
	DONE	base drawing
	DONE	basic player controls
	DONE 	logic to see if target move-location is valid
	TODO	logic to check collision
	TODO	logic to teleport per orientation
	
TODO 	release alpha
	DONE	implement scrolling
	DONE	add fadeout of tiles if distant from player
	TODO 	complete the above
	TODO	map a few levels
	TODO	special abilities to help see around
	
TODO	code maintenance
	TODO	refactor solids back into a single Tile type, since behavior is better done using an integer, player-side
	TODO	error checking on g and f initialization
	
TODO release beta
	TODO	menu
	TODO	obstacles? switches? points?
	TODO 	more levels
	TODO 	sound effects
	TODO	movement tween animation, consider having the black-head slow-in, and the body slow-out
	TODO	rotation animation by moving the black-head around (mind the z-sort)
	TODO	teleportation per smallifying and moving onto the door and vice-versa
	
TODO release gamma
	TODO 	add shading to player and obstacles and such, consider a gradient circular white shadow
	TODO	add glow/shadow under player 
	TODO	block effect on doors: try whitening the block upon contact
	TODO	fullscreenize
	TODO	package
	
	
Refs
====

http://stackoverflow.com/questions/892811/drawing-isometric-game-worlds
http://love2d.org/wiki/Tutorial:Isometric_Graphics
