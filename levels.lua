------------------------------------------------------------------------
------------------------------------------------------------------------
-- Level making is a PITA:
-- For now, just draw the level in Blender. 
-- ROTATE the axes and ORIENT them to fit the frames as a normal co-ord. 
-- Then write down the tiles.
------------------------------------------------------------------------
------------------------------------------------------------------------

leveldata01 = 	{           											-- the entire level                                                
					{													-- x-facing tiles	[x][y][z]
						{												-- x-wise slice of said tiles
							{1, 1},										-- y-wise slice inside the said x-wise slice, with z-wise tile values inside
							{1, 1}										-- y-wise slice inside the said x-wise slice, with z-wise tile values inside
						},
						{
							{1, 0},
							{0, 0}
						},
						{
							{0, 0},
							{0, 0}
						}                        
					},
					{													-- y-facing tiles	[y][x][z]
						{
							{1, 1},
							{1, 1}
						},
						{
							{1, 0},
							{0, 0}
						},
						{
							{0, 0},
							{0, 0}
						}                        
					},
					{													-- z-facing tiles	[z][y][x]
						{
							{1, 1},
							{1, 1}
						},
						{
							{1, 0},
							{0, 0}
						},
						{
							{0, 0},
							{0, 0}
						}                        
					}
				}
				


leveldata02 = 	{           											-- the entire level                                                
					{													-- x-facing tiles
						{												
							{1, 1, 1, 1},										
							{1, 1, 1, 1},										
							{1, 1, 1, 1},
							{0, 1, 1, 1}
						},
						{
							{0, 0, 0, 0},										
							{0, 1, 1, 0},										
							{0, 0, 1, 0},
							{1, 0, 0, 0}
						},
						{
							{0, 0, 0, 0},										
							{0, 0, 0, 0},										
							{0, 1, 0, 0},
							{0, 0, 0, 0}
						},
						{
							{0, 0, 0, 0},										
							{0, 1, 1, 0},										
							{0, 1, 1, 0},
							{0, 0, 0, 0}
						--},
						--{
							--{1, 1, 1, 1},										
							--{1, 1, 1, 1},										
							--{1, 1, 1, 1},
							--{1, 1, 1, 1}
						}                      
					},
					{													-- y-facing tiles
						{												
							{1, 1, 1, 1},										
							{1, 1, 1, 1},										
							{1, 1, 1, 1},
							{1, 1, 1, 1}
						},
						{
							{0, 0, 0, 0},										
							{0, 1, 1, 0},										
							{0, 1, 1, 0},
							{0, 0, 0, 0}
						},
						{
							{0, 0, 0, 0},										
							{0, 1, 0, 0},										
							{0, 0, 0, 0},
							{0, 0, 0, 0}
						},
						{
							{1, 0, 0, 0},										
							{0, 0, 1, 0},										
							{0, 1, 1, 0},
							{0, 0, 0, 0}
						--},
						--{
							--{0, 1, 1, 1},										
							--{1, 1, 1, 1},										
							--{1, 1, 1, 1},
							--{1, 1, 1, 1}
						}                      
					},
					{													-- z-facing tiles
						{												
							{1, 1, 1, 0},										
							{1, 1, 1, 1},										
							{1, 1, 1, 1},
							{1, 1, 1, 1}
						},
						{
							{0, 0, 0, 1},										
							{0, 1, 0, 0},										
							{0, 1, 1, 0},
							{0, 0, 0, 0}
						},
						{
							{0, 0, 0, 0},										
							{0, 0, 1, 0},										
							{0, 0, 0, 0},
							{0, 0, 0, 0}
						},
						{
							{0, 0, 0, 0},										
							{0, 1, 1, 0},										
							{0, 1, 1, 0},
							{0, 0, 0, 0}
						--},
						--{
							--{1, 1, 1, 1},										
							--{1, 1, 1, 1},										
							--{1, 1, 1, 1},
							--{1, 1, 1, 1}
						}                     
					}
				}
			
leveldataflat = {           											-- the entire level                                                
					{													-- x-facing tiles
						{												
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},										
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},										
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},										
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},										
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
						},
					},
					{
						{												
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},										
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},										
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},										
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},										
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
						},
					},
					{
						{												
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},										
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},										
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},										
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},										
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
							{1, 1, 1, 1, 1, 1, 1, 1, 1, 1}
						}
					}
				}
