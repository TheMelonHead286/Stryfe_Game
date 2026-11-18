extends Node2D

#dictionary to keep track of objects in level
var ActiveGrid = {}
var ActiveGridSliding = []

#level grid, may need to be dynamic, doubles the value entered
var ActiveGridMaxX = 11
var ActiveGridMaxY = 4
var ActiveLevelScale = 0.78 #<- intened for 9 x 3 grid, scales everything accordingly

#are inputs going to the grid, UI, or dialogue 
var InputMode = "GRIDbutcooler"

#Hexagons but square internal grid cause thats easier :)
#-2-4 hours later, square internal grid NOT easy, square internal grid fucking HARD
#okay now this has turned into general update things on board function, i should probably split it.....
func InternalposToGamepos(object,moveto):
	if object is String:
		#i swear, as you code, more and more ghosts appear. its sort of freaky
		print(str(object)+" tried to move "+moveto)
		return false
	
	var X = object.get_meta("X")
	var Y = object.get_meta("Y")
	
	#autofail if moving something that doesnt exist or is wall
	if str(X)+","+str(Y) not in ActiveGrid or object.get_meta("type") == "wall":
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
		object.position = Vector2(int(round(ActiveLevelScale*((X * 64) + 32))),int(round(ActiveLevelScale*(Y * 50))))
	else:
		object.position = Vector2(int(round(ActiveLevelScale*(X * 64))),int(round(ActiveLevelScale*(Y * 50))))
		
	return true

#General use case spawning scrip for cubes, crates (buttons), walls, etc
var cube = load("res://scenes/cube.tscn")
var cubeIce = load("res://scenes/cube_ice.tscn")
var tileWall = load("res://scenes/tile_wall.tscn")
@onready var InterfaceHandler = $InterfaceHandler
func SpawnEntity(X,Y,LevelObject):
	if ActiveGrid.has(str(X)+","+str(Y)) and ActiveGrid[str(X)+","+str(Y)] is String:
			var inst = LevelObject.instantiate()
			if abs(Y) % 2 == 1:
				inst.position = Vector2(int(round(ActiveLevelScale*(((X) * 64) + 32))),int(round(ActiveLevelScale*(Y * 50))))
			else:
				inst.position = Vector2(int(round(ActiveLevelScale*((X) * 64))),int(round(ActiveLevelScale*(Y * 50))))
			inst.set_meta("X",X)
			inst.set_meta("Y",Y)
			inst.scale = Vector2(ActiveLevelScale*2,ActiveLevelScale*2)
			add_child(inst)
			ActiveGrid[str(X)+","+str(Y)] = inst
	else:
		return false

#generating grid of level
func gengrid() -> void:
	#half of them, even row
	for ix in range(-(ActiveGridMaxX-1),ActiveGridMaxX):
		for iy in range(-(ActiveGridMaxY-1),ActiveGridMaxY):
			var tile = Sprite2D.new()
			tile.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			tile.scale = Vector2(ActiveLevelScale*2,ActiveLevelScale*2)
			tile.z_index = -2
			tile.position = Vector2(int(round(ActiveLevelScale*ix*64)),int(round(ActiveLevelScale*iy*100)))
			tile.name = "grid,"+str(ix*2)+","+str(iy*2)
			if ix == -ActiveGridMaxX+1 or iy == -ActiveGridMaxY+1 or ix == ActiveGridMaxX-1 or iy == ActiveGridMaxY-1:
				tile.texture = load("res://textures/prealpha/tile_wall.png")
				ActiveGrid[str(ix)+","+str(iy*2)] = tile
				tile.set_meta("X",ix)
				tile.set_meta("Y",iy)
				tile.set_meta("type","wall")
			else:
				tile.texture = load("res://textures/prealpha/tile.png")
				ActiveGrid[str(ix)+","+str(iy*2)] = "empty"
			add_child(tile)
	#other half, odd row
	for ix in range(-ActiveGridMaxX,ActiveGridMaxX):
		for iy in range(-ActiveGridMaxY,ActiveGridMaxY):
			var tile = Sprite2D.new()
			tile.texture = load("res://textures/prealpha/tile.png")
			tile.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			tile.scale = Vector2(ActiveLevelScale*2,ActiveLevelScale*2)
			tile.z_index = -2
			tile.position = Vector2(int(round(ActiveLevelScale*((ix*64)+32))),(int(round(ActiveLevelScale*((iy*100)+50)))))
			tile.name = "grid,"+str((ix*2)+1)+","+str((iy*2)+1)
			if ix == -ActiveGridMaxX or iy == -ActiveGridMaxY or ix == ActiveGridMaxX-1 or iy == ActiveGridMaxY-1:
				tile.texture = load("res://textures/prealpha/tile_wall.png")
				ActiveGrid[str(ix)+","+str((iy*2)+1)] = tile
				tile.set_meta("X",ix)
				tile.set_meta("Y",iy)
				tile.set_meta("type","wall")
			else:
				tile.texture = load("res://textures/prealpha/tile.png")
				ActiveGrid[str(ix)+","+str((iy*2)+1)] = "empty"
			add_child(tile)
			

# Called when the node enters the scene tree for the first time.
var CharacterX = 0
var CharacterY = 0
var CharacterFacing = 0
var forSakeOfCodeReadabilityTheCharacterIsFacing = "RIGHT"
func _ready() -> void:
	gengrid()
	ActiveGrid[str(CharacterX)+","+str(CharacterY)] = $Character
	$Character.set_meta("X",0)
	$Character.set_meta("Y",0)
	$Character.scale = Vector2(ActiveLevelScale*2,ActiveLevelScale*2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#Swapping input modes grid/ui elements
	if Input.is_action_just_pressed("ACCEPT"):
		if InputMode == "GRIDbutcooler":
			InputMode = "UIMode"
			$Character/Arrow.visible = !$Character/Arrow.visible
		elif InputMode == "UIMode":
			InputMode = "DialogueOption"
		elif InputMode == "DialogueOption":
			InputMode = "GRIDbutcooler"
			$Character/Arrow.visible = !$Character/Arrow.visible
	
	elif Input.is_action_just_pressed("DENY"):
		#spawn cube / ice cube [temp]
		if InputMode == "GRIDbutcooler":
			SpawnEntity(CharacterX-1,CharacterY,cube)
			SpawnEntity(CharacterX+1,CharacterY,cubeIce)
		
	if Input.is_action_just_pressed("WAIT"):
		updateTime()
	
	#player stuff!
	elif InputMode == "GRIDbutcooler":
		#it has now been updated, move the next direction to step
		if Input.is_action_just_pressed("LEFT"):
			if CharacterFacing == 0:
				CharacterFacing = 6
			CharacterFacing -= 1
			#$Character/Arrow.offset.x = (cos(CharacterFacing*(3.14/3))*25)
			#$Character/Arrow.offset.y = (sin(CharacterFacing*(3.14/3))*25)
			$Character/Arrow.rotation_degrees = CharacterFacing*60
		elif Input.is_action_just_pressed("RIGHT"):
			CharacterFacing += 1
			if CharacterFacing == 6:
				CharacterFacing = 0
			#$Character/Arrow.offset.x = (cos(CharacterFacing*(3.14/3))*25)
			#$Character/Arrow.offset.y = (sin(CharacterFacing*(3.14/3))*25)
			$Character/Arrow.rotation_degrees = CharacterFacing*60
		elif Input.is_action_just_pressed("FORWARD"):
			if CharacterFacing == 0:
				forSakeOfCodeReadabilityTheCharacterIsFacing = "RIGHT"
			elif CharacterFacing == 1:
				forSakeOfCodeReadabilityTheCharacterIsFacing = "ROWN"
			elif CharacterFacing == 2:
				forSakeOfCodeReadabilityTheCharacterIsFacing = "LOWN"
			elif CharacterFacing == 3:
				forSakeOfCodeReadabilityTheCharacterIsFacing = "LEFT"
			elif CharacterFacing == 4:
				forSakeOfCodeReadabilityTheCharacterIsFacing = "LUP"
			elif CharacterFacing == 5:
				forSakeOfCodeReadabilityTheCharacterIsFacing = "RUP"
			if InternalposToGamepos($Character,forSakeOfCodeReadabilityTheCharacterIsFacing) == true:
				updateTime()

func updateTime():
	InterfaceHandler.clockTick()
	var popTicker = 0
	for sliders in ActiveGridSliding:
		if InternalposToGamepos(sliders, sliders.get_meta("facing")) == false:
			sliders.set_meta("sliding", false)
			sliders.set_meta("facing", "NEUTRAL")
			ActiveGridSliding.pop_at(popTicker)
		popTicker += 1
