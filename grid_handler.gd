extends Node2D

#dictionary to keep track of objects in level
var ActiveGridCoord = {}
var ActiveGridSliding = []

#level grid, may need to be dynamic, doubles the value entered
var ActiveGridMaxX = 11
var ActiveGridMaxY = 4
var ActiveLevelScale = 0.78 #<- intened for 9 x 3 grid, scales everything accordingly

#semi-command pattern inputs, inputs can go to the grid, UI, or dialogue (only grid inputs can be undone)
var InputMode = "GRIDbutcooler"
var GameState = []#: is a list, that has lists, of dictionaries of objects' of dictionaries of states
#order of lists are previous states, each key is the object, value is a list of metadata of the object

#Hexagons but square internal grid cause thats easier :)
#-2-4 hours later, square internal grid NOT easy, square internal grid fucking HARD
#okay now this has turned into general update things on board function, i should probably split it.....
#wrong! i do not want to split this: undoing game states
func InternalposToGamepos(object,moveto):
	#i swear, as you code, more and more ghosts appear. its sort of freaky
	if object is String:
		print(str(object)+" tried to move "+moveto)
		return false
	if !(is_instance_valid(object)):
		print("ghost tried to move "+moveto)
		return false
	
	var X = object.get_meta("X")
	var Y = object.get_meta("Y")
	print(object.get_meta("type")+" "+moveto)
	#autofail if moving something that doesnt exist or is wall
	if  object.get_meta("type") == "wall":
		return false
	
	#update new position (if facing is RIGHT, move obj to the RIGHT)
	if moveto == "RIGHT":
		if str(X+1)+","+str(Y) not in ActiveGridCoord or ActiveGridCoord[str(X+1)+","+str(Y)] is String:
			ActiveGridCoord.erase(str(X)+","+str(Y))
			X += 1
		else:
			if ActiveGridCoord.has(str(X+1)+","+str(Y)) and InternalposToGamepos(ActiveGridCoord[str(X+1)+","+str(Y)],moveto) == true:
				ActiveGridCoord.erase(str(X)+","+str(Y))
				X += 1
			else:
				return false
		ActiveGridCoord[str(X)+","+str(Y)] = object
	elif moveto == "LEFT":
		if str(X-1)+","+str(Y) not in ActiveGridCoord or ActiveGridCoord[str(X-1)+","+str(Y)] is String:
			ActiveGridCoord.erase(str(X)+","+str(Y))
			X -= 1
		else:
			if ActiveGridCoord.has(str(X-1)+","+str(Y)) and InternalposToGamepos(ActiveGridCoord[str(X-1)+","+str(Y)],moveto) == true:
				ActiveGridCoord.erase(str(X)+","+str(Y))
				X -= 1
			else:
				return false
		ActiveGridCoord[str(X)+","+str(Y)] = object
	elif moveto == "LOWN":
		if abs(Y) % 2 == 0:
			if str(X-1)+","+str(Y+1) not in ActiveGridCoord or ActiveGridCoord[str(X-1)+","+str(Y+1)] is String:
				ActiveGridCoord.erase(str(X)+","+str(Y))
				X -= 1
				Y += 1
			else:
				if ActiveGridCoord.has(str(X-1)+","+str(Y+1)) and InternalposToGamepos(ActiveGridCoord[str(X-1)+","+str(Y+1)],moveto) == true:
					ActiveGridCoord.erase(str(X)+","+str(Y))
					X -= 1
					Y += 1
				else:
					return false
		else:
			if str(X)+","+str(Y+1) not in ActiveGridCoord or ActiveGridCoord[str(X)+","+str(Y+1)] is String:
				ActiveGridCoord.erase(str(X)+","+str(Y))
				Y+= 1
			else:
				if ActiveGridCoord.has(str(X)+","+str(Y+1)) and InternalposToGamepos(ActiveGridCoord[str(X)+","+str(Y+1)],moveto) == true:
					ActiveGridCoord.erase(str(X)+","+str(Y))
					Y+= 1
				else:
					return false
		ActiveGridCoord[str(X)+","+str(Y)] = object
	elif moveto == "ROWN":
		if abs(Y) % 2 == 1:
			if str(X+1)+","+str(Y+1) not in ActiveGridCoord or ActiveGridCoord[str(X+1)+","+str(Y+1)] is String:
				ActiveGridCoord.erase(str(X)+","+str(Y))
				X += 1
				Y += 1
			else:
				if ActiveGridCoord.has(str(X+1)+","+str(Y+1)) and InternalposToGamepos(ActiveGridCoord[str(X+1)+","+str(Y+1)],moveto) == true:
					ActiveGridCoord.erase(str(X)+","+str(Y))
					X += 1
					Y += 1
				else:
					return false
		else:
			if str(X)+","+str(Y+1) not in ActiveGridCoord or ActiveGridCoord[str(X)+","+str(Y+1)] is String:
				ActiveGridCoord.erase(str(X)+","+str(Y))
				Y += 1
			else:
				if ActiveGridCoord.has(str(X)+","+str(Y+1)) and InternalposToGamepos(ActiveGridCoord[str(X)+","+str(Y+1)],moveto) == true:
					ActiveGridCoord.erase(str(X)+","+str(Y))
					Y += 1
				else:
					return false
		ActiveGridCoord[str(X)+","+str(Y)] = object
	elif moveto == "LUP":
		if abs(Y) % 2 == 0:
			if str(X-1)+","+str(Y-1) not in ActiveGridCoord or ActiveGridCoord[str(X-1)+","+str(Y-1)] is String:
				ActiveGridCoord.erase(str(X)+","+str(Y))
				X -= 1
				Y -= 1
			else:
				if ActiveGridCoord.has(str(X-1)+","+str(Y-1)) and InternalposToGamepos(ActiveGridCoord[str(X-1)+","+str(Y-1)],moveto) == true:
					ActiveGridCoord.erase(str(X)+","+str(Y))
					X -= 1
					Y -= 1
				else:
					return false
		else:
			if str(X)+","+str(Y-1) not in ActiveGridCoord or ActiveGridCoord[str(X)+","+str(Y-1)] is String:
				ActiveGridCoord.erase(str(X)+","+str(Y))
				Y -= 1
			else:
				if ActiveGridCoord.has(str(X)+","+str(Y-1)) and InternalposToGamepos(ActiveGridCoord[str(X)+","+str(Y-1)],moveto) == true:
					ActiveGridCoord.erase(str(X)+","+str(Y))
					Y -= 1
				else:
					return false
		ActiveGridCoord[str(X)+","+str(Y)] = object
	elif moveto == "RUP":
		if abs(Y) % 2 == 1:
			if str(X+1)+","+str(Y-1) not in ActiveGridCoord or ActiveGridCoord[str(X+1)+","+str(Y-1)] is String:
				ActiveGridCoord.erase(str(X)+","+str(Y))
				X += 1
				Y -= 1
			else:
				if ActiveGridCoord.has(str(X+1)+","+str(Y-1)) and InternalposToGamepos(ActiveGridCoord[str(X+1)+","+str(Y-1)],moveto) == true:
					ActiveGridCoord.erase(str(X)+","+str(Y))
					X += 1
					Y -= 1
				else:
					return false
		else:
			if str(X)+","+str(Y-1) not in ActiveGridCoord or ActiveGridCoord[str(X)+","+str(Y-1)] is String:
				ActiveGridCoord.erase(str(X)+","+str(Y))
				Y -= 1
			else:
				if ActiveGridCoord.has(str(X)+","+str(Y-1)) and InternalposToGamepos(ActiveGridCoord[str(X)+","+str(Y-1)],moveto) == true:
					ActiveGridCoord.erase(str(X)+","+str(Y))
					Y -= 1
				else:
					return false
		#one well-placed catch/try for an invalid dictionary key could have saved 50% of this code
		#but, cant really blame godot for not having that built into their system
		#still. would have saved a lot of code.
		ActiveGridCoord[str(X)+","+str(Y)] = object
	elif moveto == "NEUTRAL":
		return true
	elif moveto == "SPAWNED":
		#lmao bye then
		ActiveGridCoord.erase(str(X)+","+str(Y))
		object.free()
		#guess you could say it, moved on?
		#....
		return true
	else:
		print("moving object did not have facing direction")
		return false
	
	#Sliding cases
	if object.get_meta("type") == "cubeice":
		object.set_meta("sliding", true)
	if object.get_meta("sliding") == true:
		object.set_meta("facing", moveto)
		if object not in ActiveGridSliding:
			ActiveGridSliding.append(object)
	
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

#helper function to create undo functionality
func StoreState():
	var ThisGamesState = []
	var ThisObjectsState = {}
	
	for key in ActiveGridCoord:
		var MetaLofObject = {}
		var object = ActiveGridCoord[key]
		if object is not String: #if its a string, its considered an aesthetic tile that doesnt change
			if object.get_meta("type") != "wall": #(regular) walls dont change. would take too much memory
				for metaVal in object.get_meta_list(): 
					MetaLofObject[metaVal] = object.get_meta(metaVal)
				ThisObjectsState[object] = MetaLofObject
				ThisGamesState.append(ThisObjectsState)
				if object.get_meta("facing") == "SPAWNED":
					object.set_meta("facing","NEUTRAL")
	
	GameState.append(ThisGamesState) #updating list of list of dictionaries of objects' dictionaries of their metadata
	return true

#function called on undo (reverse Store State & Spawn Entity) (also no redoing, womp womp)
func UndoState(): 
	if GameState.size() == 1:
		return false
	#remove ActiveGridCoord entries so objects dont push their ghost selves
	for uhWhatWasThisListAgain in GameState[-1]:
		for shitDoesItReturnTheObjectsNow in uhWhatWasThisListAgain:
			#updating external position, from internalPos function
			var X = shitDoesItReturnTheObjectsNow.get_meta("X")
			var Y = shitDoesItReturnTheObjectsNow.get_meta("Y")
			ActiveGridCoord.erase(str(X)+","+str(Y))
			if shitDoesItReturnTheObjectsNow.get_meta("facing") == "SPAWNED":
				shitDoesItReturnTheObjectsNow.queue_free()
	#update to previous state
	for uhWhatWasThisListAgain in GameState[-2]:
		for shitDoesItReturnTheObjectsNow in uhWhatWasThisListAgain:
			for thenThenItsTheMetaNow in uhWhatWasThisListAgain[shitDoesItReturnTheObjectsNow]:
				#shitDoesItReturnTheObjectsNow.set_meta(thenThenItsTheMetaNow)
				var nowImUnderstanding = (uhWhatWasThisListAgain[shitDoesItReturnTheObjectsNow])[thenThenItsTheMetaNow]
				shitDoesItReturnTheObjectsNow.set_meta(thenThenItsTheMetaNow, nowImUnderstanding)
			#updating external position, from internalPos function
			var X = shitDoesItReturnTheObjectsNow.get_meta("X")
			var Y = shitDoesItReturnTheObjectsNow.get_meta("Y")
			#ActiveGridCoord.erase(str(X)+","+str(Y))
			ActiveGridCoord[str(X)+","+str(Y)] = shitDoesItReturnTheObjectsNow
			if abs(Y) % 2 == 1:
				shitDoesItReturnTheObjectsNow.position = Vector2(int(round(ActiveLevelScale*((X * 64) + 32))),int(round(ActiveLevelScale*(Y * 50))))
			else:
				shitDoesItReturnTheObjectsNow.position = Vector2(int(round(ActiveLevelScale*(X * 64))),int(round(ActiveLevelScale*(Y * 50))))
	GameState.pop_at(-1) #doesnt remove the (now current) gamestate, removes the one that was "ahead" of it (no redoing)

#General use case spawning scrip for cubes, crates (buttons), walls, etc
var cube = load("res://scenes/cube.tscn")
var cubeIce = load("res://scenes/cube_ice.tscn")
var tileWall = load("res://scenes/tile_wall.tscn")
@onready var InterfaceHandler = $InterfaceHandler
func SpawnEntity(X,Y,LevelObject):
	if str(X+1)+","+str(Y-1) not in ActiveGridCoord or ActiveGridCoord[str(X)+","+str(Y)] is String:
			var inst = LevelObject.instantiate()
			if abs(Y) % 2 == 1:
				inst.position = Vector2(int(round(ActiveLevelScale*(((X) * 64) + 32))),int(round(ActiveLevelScale*(Y * 50))))
			else:
				inst.position = Vector2(int(round(ActiveLevelScale*((X) * 64))),int(round(ActiveLevelScale*(Y * 50))))
			inst.set_meta("X",X)
			inst.set_meta("Y",Y)
			inst.scale = Vector2(ActiveLevelScale*2,ActiveLevelScale*2)
			add_child(inst)
			ActiveGridCoord[str(X)+","+str(Y)] = inst
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
				ActiveGridCoord[str(ix)+","+str(iy*2)] = tile
				tile.set_meta("X",ix)
				tile.set_meta("Y",iy)
				tile.set_meta("type","wall")
			else:
				tile.texture = load("res://textures/prealpha/tile.png")
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
				ActiveGridCoord[str(ix)+","+str((iy*2)+1)] = tile
				tile.set_meta("X",ix)
				tile.set_meta("Y",iy)
				tile.set_meta("type","wall")
			else:
				tile.texture = load("res://textures/prealpha/tile.png")
			add_child(tile)

# Called when the node enters the scene tree for the first time.
var CharacterFacing = 0
var forSakeOfCodeReadabilityTheCharacterIsFacing = "RIGHT"
func _ready() -> void:
	gengrid()
	ActiveGridCoord[str(0)+","+str(0)] = $Character
	$Character.set_meta("X",0)
	$Character.set_meta("Y",0)
	$Character.scale = Vector2(ActiveLevelScale*2,ActiveLevelScale*2)
	StoreState()

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
			SpawnEntity($Character.get_meta("X")-1,$Character.get_meta("Y"),cube)
			SpawnEntity($Character.get_meta("X")+1,$Character.get_meta("Y"),cubeIce)
			updateTime()
		
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
			$Character.set_meta("facing",forSakeOfCodeReadabilityTheCharacterIsFacing)
			InternalposToGamepos($Character,forSakeOfCodeReadabilityTheCharacterIsFacing)
			updateTime()
		elif Input.is_action_just_pressed("UNDO"):
			UndoState()

func updateTime():
	InterfaceHandler.clockTick()
	var popTicker = 0
	ActiveGridSliding = ActiveGridSliding.filter(func(sliders): return is_instance_valid(sliders))#supposedly this is a good safeguard. thanks godot forums
	for slider in ActiveGridSliding:
		if slider.get_meta("facing") == "NEUTRAL":
			ActiveGridSliding.pop_at(popTicker)
		elif InternalposToGamepos(slider, slider.get_meta("facing")) == false:
			slider.set_meta("sliding", false)
			slider.set_meta("facing", "NEUTRAL")
			ActiveGridSliding.pop_at(popTicker)
		popTicker += 1
	StoreState()
