extends Node2D

#dictionary to keep track of shite on board
var ActiveGrid = {}
#generating grid of level
func gengrid() -> void:
	#half of them, even row
	for ix in range(-9,9):
		for iy in range(-2,3):
			var tile = Sprite2D.new()
			tile.texture = load("res://textures/prealpha/tile_slippy.png")
			tile.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
			tile.scale = Vector2(2,2)
			tile.z_index = -2
			tile.position = Vector2(ix*64,iy*100)
			tile.name = "grid,"+str(ix*2)+","+str(iy*2)
			add_child(tile)
			ActiveGrid[str(ix)+","+str(iy)] = "empty"
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
			ActiveGrid[str((ix*2)+1)+","+str((iy*2)+1)] = "empty"
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gengrid()
	
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
