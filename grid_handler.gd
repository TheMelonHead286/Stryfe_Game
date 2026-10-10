extends Node2D

#dictionary to keep track of objects on board
var ActiveGrid = {}

#Hexagons but square internal grid cause thats easier :)
#-2- 4 hours later, square internal grid NOT easy, square internal grid fucking HARD
func InternalposToGamepos(X,Y,moveto):
	#autofail if moving something that doesnt exist
	if str(X)+","+str(Y) not in ActiveGrid:
		return false
	
	var object = ActiveGrid[str(X)+","+str(Y)]
	
	#remove old position
	#update new position (if facing is RIGHT, move to the RIGHT)
	if moveto == "RIGHT":
		if ActiveGrid.has(str(X+1)+","+str(Y)) and ActiveGrid[str(X+1)+","+str(Y)] is String:
			ActiveGrid[str(X)+","+str(Y)] = "empty"
			X += 1
		else:
			if InternalposToGamepos(X+1,Y,moveto) == true:
				ActiveGrid[str(X)+","+str(Y)] = "empty"
				X += 1
			else:
				return false
		ActiveGrid[str(X)+","+str(Y)] = object
	elif moveto == "LEFT":
		if ActiveGrid.has(str(X-1)+","+str(Y)) and ActiveGrid[str(X-1)+","+str(Y)] is String:
			ActiveGrid[str(X)+","+str(Y)] = "empty"
			X -= 1
		else:
			if InternalposToGamepos(X-1,Y,moveto) == true:
				ActiveGrid[str(X)+","+str(Y)] = "empty"
				X -= 1
			else:
				return false
		ActiveGrid[str(X)+","+str(Y)] = object
	elif moveto == "LOWN":
		if abs(Y) % 2 == 0:
			if ActiveGrid.has(str(X-1)+","+str(Y+1)) and ActiveGrid[str(X-1)+","+str(Y+1)] is String:
				ActiveGrid[str(X)+","+str(Y)] = "empty"
				X -= 1
				Y += 1
			else:
				if InternalposToGamepos(X-1,Y+1,moveto) == true:
					ActiveGrid[str(X)+","+str(Y)] = "empty"
					X -= 1
					Y += 1
				else:
					return false
		else:
			if ActiveGrid.has(str(X)+","+str(Y+1)) and ActiveGrid[str(X)+","+str(Y+1)] is String:
				ActiveGrid[str(X)+","+str(Y)] = "empty"
				Y+= 1
			else:
				if InternalposToGamepos(X,Y+1,moveto) == true:
					ActiveGrid[str(X)+","+str(Y)] = "empty"
					Y+= 1
				else:
					return false
		ActiveGrid[str(X)+","+str(Y)] = object
	elif moveto == "ROWN":
		if abs(Y) % 2 == 1:
			if ActiveGrid.has(str(X+1)+","+str(Y+1)) and ActiveGrid[str(X+1)+","+str(Y+1)] is String:
				ActiveGrid[str(X)+","+str(Y)] = "empty"
				X += 1
				Y += 1
			else:
				if InternalposToGamepos(X+1,Y+1,moveto) == true:
					ActiveGrid[str(X)+","+str(Y)] = "empty"
					X += 1
					Y += 1
				else:
					return false
		else:
			if ActiveGrid.has(str(X)+","+str(Y+1)) and ActiveGrid[str(X)+","+str(Y+1)] is String:
				ActiveGrid[str(X)+","+str(Y)] = "empty"
				Y += 1
			else:
				if InternalposToGamepos(X,Y+1,moveto) == true:
					ActiveGrid[str(X)+","+str(Y)] = "empty"
					Y += 1
				else:
					return false
		ActiveGrid[str(X)+","+str(Y)] = object
	elif moveto == "LUP":
		if abs(Y) % 2 == 0:
			if ActiveGrid.has(str(X-1)+","+str(Y-1)) and ActiveGrid[str(X-1)+","+str(Y-1)] is String:
				ActiveGrid[str(X)+","+str(Y)] = "empty"
				X -= 1
				Y -= 1
			else:
				if InternalposToGamepos(X-1,Y-1,moveto) == true:
					ActiveGrid[str(X)+","+str(Y)] = "empty"
					X -= 1
					Y -= 1
				else:
					return false
		else:
			if ActiveGrid.has(str(X)+","+str(Y-1)) and ActiveGrid[str(X)+","+str(Y-1)] is String:
				ActiveGrid[str(X)+","+str(Y)] = "empty"
				Y -= 1
			else:
				if InternalposToGamepos(X,Y-1,moveto) == true:
					ActiveGrid[str(X)+","+str(Y)] = "empty"
					Y -= 1
				else:
					return false
		ActiveGrid[str(X)+","+str(Y)] = object
	elif moveto == "RUP":
		if abs(Y) % 2 == 1:
			if ActiveGrid.has(str(X+1)+","+str(Y-1)) and ActiveGrid[str(X+1)+","+str(Y-1)] is String:
				ActiveGrid[str(X)+","+str(Y)] = "empty"
				X += 1
				Y -= 1
			else:
				if InternalposToGamepos(X+1,Y-1,moveto) == true:
					ActiveGrid[str(X)+","+str(Y)] = "empty"
					X += 1
					Y -= 1
				else:
					return false
		else:
			if ActiveGrid.has(str(X)+","+str(Y-1)) and ActiveGrid[str(X)+","+str(Y-1)] is String:
				ActiveGrid[str(X)+","+str(Y)] = "empty"
				Y -= 1
			else:
				if InternalposToGamepos(X,Y-1,moveto) == true:
					ActiveGrid[str(X)+","+str(Y)] = "empty"
					Y -= 1
				else:
					return false
		ActiveGrid[str(X)+","+str(Y)] = object
	elif moveto == "NEUTRAL":
		#lmao bye then
		ActiveGrid[str(X)+","+str(Y)] = "empty"
		remove_child(object)
		#guess you could say it, moved on?
		#....
		return true
	else:
		print("moving object did not have facing direction")
		return false
		
	#Character coords are special cause only 1 character :)
	if object.get_meta("type") == "character":
		CharacterX = X
		CharacterY = Y
		
	#1 internalx = 64 externalx
	#1 internaly = 50 externaly
	#the actual updating, is really simple
	if abs(Y) % 2 == 1:
		object.position = Vector2(((X * 64) + 32),(Y * 50))
	else:
		object.position = Vector2((X * 64),(Y * 50))
	#print(str(X)+","+str(Y)+objectName)
	return true

#generating grid of level
func gengrid() -> void:
	#half of them, even row
	for ix in range(-8,9):
		for iy in range(-2,3):
			var tile = Sprite2D.new()
			tile.texture = load("res://textures/prealpha/tile_slippy.png")
			tile.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			tile.scale = Vector2(2,2)
			tile.z_index = -2
			tile.position = Vector2(ix*64,iy*100)
			tile.name = "grid,"+str(ix*2)+","+str(iy*2)
			add_child(tile)
			ActiveGrid[str(ix)+","+str(iy*2)] = "empty"
	#other half, odd row
	for ix in range(-9,9):
		for iy in range(-2,3):
			var tile = Sprite2D.new()
			tile.texture = load("res://textures/prealpha/tile_slippy.png")
			tile.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			tile.scale = Vector2(2,2)
			tile.z_index = -2
			tile.position = Vector2((ix*64)+32,(iy*100)+50)
			tile.name = "grid,"+str((ix*2)+1)+","+str((iy*2)+1)
			add_child(tile)
			ActiveGrid[str(ix)+","+str((iy*2)+1)] = "empty"

var CharacterX = 0
var CharacterY = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gengrid()
	ActiveGrid[str(CharacterX)+","+str(CharacterY)] = $Character

var cube = load("res://scenes/cube.tscn")
var cubeIce = load("res://scenes/cube_ice.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#spawn cube [temp]
	if Input.is_action_just_pressed("ACCEPT"):
		if ActiveGrid.has(str(CharacterX-1)+","+str(CharacterY)) and ActiveGrid[str(CharacterX-1)+","+str(CharacterY)] is String:
			var cubeinst = cube.instantiate()
			if abs(CharacterY) % 2 == 1:
				cubeinst.position = Vector2((((CharacterX-1) * 64) + 32),(CharacterY * 50))
			else:
				cubeinst.position = Vector2(((CharacterX-1) * 64),(CharacterY * 50))
			add_child(cubeinst)
			ActiveGrid[str(CharacterX-1)+","+str(CharacterY)] = cubeinst
	elif Input.is_action_just_pressed("DENY"):
		if ActiveGrid.has(str(CharacterX+1)+","+str(CharacterY)) and ActiveGrid[str(CharacterX+1)+","+str(CharacterY)] is String:
			var cubeIceinst = cubeIce.instantiate()
			if abs(CharacterY) % 2 == 1:
				cubeIceinst.position = Vector2((((CharacterX+1) * 64) + 32),(CharacterY * 50))
			else:
				cubeIceinst.position = Vector2(((CharacterX+1) * 64),(CharacterY * 50))
			add_child(cubeIceinst)
			ActiveGrid[str(CharacterX+1)+","+str(CharacterY)] = cubeIceinst
		
	#player stuff!
	#hexagonal movement means six movement axis, up/down, topleft/bottomright, bottomleft/topright
	#movement used to look crazy until i just made a crazy function for everything instead. took a while.
	if Input.is_action_just_pressed("LEFT"):
		InternalposToGamepos(CharacterX,CharacterY,"LEFT")
	elif Input.is_action_just_pressed("RIGHT"):
		InternalposToGamepos(CharacterX,CharacterY,"RIGHT")
	elif Input.is_action_just_pressed("LOWN"):
		InternalposToGamepos(CharacterX,CharacterY,"LOWN")
	elif Input.is_action_just_pressed("ROWN"):
		InternalposToGamepos(CharacterX,CharacterY,"ROWN")
	elif Input.is_action_just_pressed("LUP"):
		InternalposToGamepos(CharacterX,CharacterY,"LUP")
	elif Input.is_action_just_pressed("RUP"):
		InternalposToGamepos(CharacterX,CharacterY,"RUP")
		
