extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var clckTckr = 0
@onready var Clock = $Clock
func clockTick() -> void:
	if clckTckr == 0:
		clckTckr += 1
		Clock.texture = load("res://textures/prealpha/clockbl.png")
	elif clckTckr == 1:
		clckTckr += 1
		Clock.texture = load("res://textures/prealpha/clocktl.png")
	elif clckTckr == 2:
		clckTckr += 1
		Clock.texture = load("res://textures/prealpha/clocktr.png")
	elif clckTckr == 3:
		clckTckr = 0
		Clock.texture = load("res://textures/prealpha/clockbr.png")
		
