extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var tile = Sprite2D.new()
	#for i in range(0,10):
	tile.texture = load("res://textures/prealpha/tile_slippy.png")
	tile.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	tile.scale = Vector2(2,2)
	add_child(tile)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
