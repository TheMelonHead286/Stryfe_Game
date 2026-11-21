extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

var clckTckr = 2
@onready var Clock = $Clock
func clockTick(amount) -> void:
	clckTckr += amount
	if clckTckr%4 == 0:
		Clock.texture = load("res://textures/prealpha/clockbl.png")
	elif clckTckr%4 == 1:
		Clock.texture = load("res://textures/prealpha/clocktl.png")
	elif clckTckr%4 == 2:
		Clock.texture = load("res://textures/prealpha/clocktr.png")
	elif clckTckr%4 == 3:
		Clock.texture = load("res://textures/prealpha/clockbr.png")
		
