extends Node2D

#dictionary to keep track of objects on board
var ActiveGrid = {}
var ActiveGridSliding = []

#Hexagons but square internal grid cause thats easier :)
#-2- 4 hours later, square internal grid NOT easy, square internal grid fucking HARD
#okay now this has turned into general update things on board function, i should probably split it.....
func InternalposToGamepos(object,moveto):
	if object is String:
		#i swear, as you code, more and more ghosts appear. its sort of freaky
		print(str(object)+" tried to move "+moveto)
		return false
	
	var X = object.get_meta("X")
	var Y = object.get_meta("Y")
	
	#autofail if moving something that doesnt exist
	if str(X)+","+str(Y) not in ActiveGrid:
		return false
	
	#Special cases for objects (pre position change)
	if object.get_meta("type") == "cubeice":
		object.set_meta("sliding", true)
	if object.has_meta("sliding") and object.get_meta("sliding") == true:
		object.set_meta("facing", moveto)
		if object not in ActiveGridSliding:
			ActiveGridSliding.append(object)
	else:
		object.set_meta("sliding", false)
	
	#remove old position
	#update new position (if facing is RIGHT, move obj to the RIGHT)
	if moveto == "RIGHT":
		if ActiveGrid.has(str(X+1)+","+str(Y)) and ActiveGrid[str(X+1)+","+str(Y)] is String:
			ActiveGrid[str(X)+","+str(Y)] = "empty"
			X += 1
		else:
			if ActiveGrid.has(str(X+1)+","+str(Y)) and InternalposToGamepos(ActiveGrid[str(X+1)+","+str(Y)],moveto) == true:
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
			if ActiveGrid.has(str(X-1)+","+str(Y)) and InternalposToGamepos(ActiveGrid[str(X-1)+","+str(Y)],moveto) == true:
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
				if ActiveGrid.has(str(X-1)+","+str(Y+1)) and InternalposToGamepos(ActiveGrid[str(X-1)+","+str(Y+1)],moveto) == true:
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
				if ActiveGrid.has(str(X)+","+str(Y+1)) and InternalposToGamepos(ActiveGrid[str(X)+","+str(Y+1)],moveto) == true:
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
				if ActiveGrid.has(str(X+1)+","+str(Y+1)) and InternalposToGamepos(ActiveGrid[str(X+1)+","+str(Y+1)],moveto) == true:
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
				if ActiveGrid.has(str(X)+","+str(Y+1)) and InternalposToGamepos(ActiveGrid[str(X)+","+str(Y+1)],moveto) == true:
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
				if ActiveGrid.has(str(X-1)+","+str(Y-1)) and InternalposToGamepos(ActiveGrid[str(X-1)+","+str(Y-1)],moveto) == true:
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
				if ActiveGrid.has(str(X)+","+str(Y-1)) and InternalposToGamepos(ActiveGrid[str(X)+","+str(Y-1)],moveto) == true:
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
				if ActiveGrid.has(str(X+1)+","+str(Y-1)) and InternalposToGamepos(ActiveGrid[str(X+1)+","+str(Y-1)],moveto) == true:
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
				if ActiveGrid.has(str(X)+","+str(Y-1)) and InternalposToGamepos(ActiveGrid[str(X)+","+str(Y-1)],moveto) == true:
					ActiveGrid[str(X)+","+str(Y)] = "empty"
					Y -= 1
				else:
					return false
		#one well-placed catch/try for an invalid dictionary key could have saved 50% of this code
		#but, cant really blame godot for not having that built into their system
		#still. would have saved a lot of code.
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
		
	#Special cases for objects (post position update)
	#print(str(moveto)+str(object)+" "+str(X)+","+str(Y))
	#print(str(ActiveGridSliding))
	if object.get_meta("type") == "character":
		CharacterX = X
		CharacterY = Y
	
	#1 internalx = 64 externalx
	#1 internaly = 50 externaly
	#the actual updating, is really simple
	object.set_meta("X",X)
	object.set_meta("Y",Y)
	if abs(Y) % 2 == 1:
		object.position = Vector2(((X * 64) + 32),(Y * 50))
	else:
		object.position = Vector2((X * 64),(Y * 50))
		
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
	$Character.set_meta("X",0)
	$Character.set_meta("Y",0)

var cube = load("res://scenes/cube.tscn")
var cubeIce = load("res://scenes/cube_ice.tscn")
@onready var InterfaceHandler = $InterfaceHandler
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#spawn cube / ice cube [temp]
	if Input.is_action_just_pressed("ACCEPT"):
		spawnCube(CharacterX-1,CharacterY)
	elif Input.is_action_just_pressed("DENY"):
		spawnIceCube(CharacterX+1,CharacterY)
		
	#player stuff!
	#hexagonal movement means six movement axis, up/down, topleft/bottomright, bottomleft/topright
	#movement used to look crazy until i just made a crazy function for everything instead. took a while.
	if Input.is_action_just_pressed("LEFT"):
		if InternalposToGamepos($Character,"LEFT") == true:
			updateTime()
	elif Input.is_action_just_pressed("RIGHT"):
		if InternalposToGamepos($Character,"RIGHT") == true:
			updateTime()
	elif Input.is_action_just_pressed("LOWN"):
		if InternalposToGamepos($Character,"LOWN") == true:
			updateTime()
	elif Input.is_action_just_pressed("ROWN"):
		if InternalposToGamepos($Character,"ROWN") == true:
			updateTime()
	elif Input.is_action_just_pressed("LUP"):
		if InternalposToGamepos($Character,"LUP") == true:
			updateTime()
	elif Input.is_action_just_pressed("RUP"):
		if InternalposToGamepos($Character,"RUP") == true:
			updateTime()

func spawnCube(X,Y):
	if ActiveGrid.has(str(X)+","+str(Y)) and ActiveGrid[str(X)+","+str(Y)] is String:
			var cubeinst = cube.instantiate()
			if abs(Y) % 2 == 1:
				cubeinst.position = Vector2((((X) * 64) + 32),(Y * 50))
			else:
				cubeinst.position = Vector2(((X) * 64),(Y * 50))
			cubeinst.set_meta("X",X)
			cubeinst.set_meta("Y",Y)
			add_child(cubeinst)
			ActiveGrid[str(X)+","+str(Y)] = cubeinst
	else:
		return false

func spawnIceCube(X,Y):
	if ActiveGrid.has(str(X)+","+str(Y)) and ActiveGrid[str(X)+","+str(Y)] is String:
			var cubeIceinst = cubeIce.instantiate()
			if abs(Y) % 2 == 1:
				cubeIceinst.position = Vector2((((X) * 64) + 32),(Y * 50))
			else:
				cubeIceinst.position = Vector2(((X) * 64),(Y * 50))
			cubeIceinst.set_meta("X",X)
			cubeIceinst.set_meta("Y",Y)
			add_child(cubeIceinst)
			ActiveGrid[str(X)+","+str(Y)] = cubeIceinst
	else:
		return false

func updateTime():
	InterfaceHandler.clockTick()
	var popTicker = 0
	for sliders in ActiveGridSliding:
		if InternalposToGamepos(sliders, sliders.get_meta("facing")) == false:
			sliders.set_meta("sliding", false)
			sliders.set_meta("facing", "NEUTRAL")
			ActiveGridSliding.pop_at(popTicker)
			print("slide failed")
		popTicker += 1
